#!/bin/sh
# Linux-only integration test; replace the Windows named-pipe client with cat.
set -eu

script=$(CDPATH= cd -- "$(dirname -- "$0")/../config/zsh" && pwd)/bitwarden-ssh-agent.sh
for dep in socat flock timeout nohup; do
    command -v "$dep" >/dev/null || { echo "Missing test dependency: $dep" >&2; exit 1; }
done
root=$(mktemp -d)
export HOME="$root/home"
export SSH_AUTH_SOCK="$HOME/.ssh/bitwarden-ssh-agent.sock"
export PATH="$root/bin:$PATH"
mkdir -p "$HOME/.ssh" "$root/bin"
cat > "$root/bin/npiperelay.exe" <<'RELAY'
#!/bin/sh
exec cat
RELAY
chmod +x "$root/bin/npiperelay.exe"

listener_pids() {
    # Match only the listener for this test's unique socket path.
    ps -eo pid=,args= | awk -v addr="UNIX-LISTEN:$SSH_AUTH_SOCK,fork,mode=600" '$2 == "socat" && $3 == addr { print $1 }'
}
cleanup() {
    for pid in $(listener_pids); do kill "$pid" 2>/dev/null || :; done
    rm -rf "$root"
}
trap cleanup EXIT
trap 'exit 1' HUP INT TERM

assert_one_listener() {
    pids=$(listener_pids)
    set -- $pids
    [ "$#" -eq 1 ] || { echo "Expected one listener; got: $pids" >&2; exit 1; }
}
check_relay() {
    result=$(printf 'test relay\n' | timeout 2s socat - "UNIX-CONNECT:$SSH_AUTH_SOCK")
    [ "$result" = 'test relay' ]
}
start_parallel() {
    jobs=
    for i in 1 2 3 4 5 6 7 8; do
        sh "$script" &
        jobs="$jobs $!"
    done
    for job in $jobs; do wait "$job"; done
}

# An existing relay started without the new lock must also be reused.
socat "UNIX-LISTEN:$SSH_AUTH_SOCK,fork,mode=600" "EXEC:npiperelay.exe -ei -s //./pipe/openssh-ssh-agent,nofork" &
legacy=$!
for i in 1 2 3 4 5 6 7 8 9 10; do
    if [ -S "$SSH_AUTH_SOCK" ]; then break; fi
    sleep 0.1
done
sh "$script"
[ "$(listener_pids)" = "$legacy" ]
kill "$legacy"
wait "$legacy" || :

# First boot: concurrent shells create exactly one listening process.
start_parallel
assert_one_listener
first=$(listener_pids)
check_relay
[ "$(stat -c %a "$SSH_AUTH_SOCK")" = 600 ]
[ "$(stat -c %a "$HOME/.local/state/bitwarden-ssh-agent")" = 700 ]
[ "$(stat -c %a "$HOME/.local/state/bitwarden-ssh-agent/socat.log")" = 600 ]

# Existing live relay is reused, even when the Windows-side client fails.
sh "$script"
[ "$(listener_pids)" = "$first" ]
cat > "$root/bin/npiperelay.exe" <<'RELAY'
#!/bin/sh
exit 1
RELAY
sh "$script"
[ "$(listener_pids)" = "$first" ]

# SIGKILL leaves a stale socket; concurrent restarts must replace it once.
kill -KILL "$first"
for i in 1 2 3 4 5 6 7 8 9 10; do
    if flock -n "$HOME/.local/state/bitwarden-ssh-agent/relay.lock" true; then break; fi
    sleep 0.1
done
[ -S "$SSH_AUTH_SOCK" ]
cat > "$root/bin/npiperelay.exe" <<'RELAY'
#!/bin/sh
exec cat
RELAY
start_parallel
assert_one_listener
second=$(listener_pids)
[ "$second" != "$first" ]
check_relay

# Do not remove a regular file or a symlink in place of the socket.
kill -KILL "$second"
rm -f "$SSH_AUTH_SOCK"
printf 'keep me\n' > "$SSH_AUTH_SOCK"
if sh "$script"; then exit 1; fi
[ "$(cat "$SSH_AUTH_SOCK")" = 'keep me' ]
mv "$SSH_AUTH_SOCK" "$root/target"
ln -s "$root/target" "$SSH_AUTH_SOCK"
if sh "$script"; then exit 1; fi
[ -L "$SSH_AUTH_SOCK" ]
[ "$(cat "$root/target")" = 'keep me' ]
echo 'Bitwarden SSH relay tests passed'
