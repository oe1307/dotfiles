#!/bin/sh
# Start one WSL relay per user. Check the local socket, not the Windows agent:
# Bitwarden may be locked or stopped temporarily while the relay is healthy.
set -eu

socket=${SSH_AUTH_SOCK:?SSH_AUTH_SOCK must be set}
state_dir="$HOME/.local/state/bitwarden-ssh-agent"
log_file="$state_dir/socat.log"

socket_ready() {
    [ -S "$socket" ] && [ ! -L "$socket" ] &&
        timeout "${1:-1s}" socat -u /dev/null "UNIX-CONNECT:$socket" >/dev/null 2>&1
}

# A failed connection is not sufficient evidence that a listener is dead
# (for example, its accept queue may be full). Check the Linux socket table
# before removing any existing socket. Return 2 if it cannot be inspected.
listener_exists() {
    [ -r /proc/net/unix ] || return 2
    while IFS=' ' read -r num refs protocol flags type state inode path; do
        if [ "$flags" = 00010000 ] && [ "$path" = "$socket" ]; then
            return 0
        fi
    done < /proc/net/unix || return 2
    return 1
}

if [ "${1:-}" = --locked ]; then
    # Recheck after acquiring the lock, including pre-existing legacy relays.
    if [ -L "$socket" ] || { [ -e "$socket" ] && [ ! -S "$socket" ]; }; then
        printf 'Refusing to replace non-socket path: %s\n' "$socket" >&2
        exit 1
    fi
    if [ -S "$socket" ]; then
        if socket_ready; then exit 0; fi
        status=0
        listener_exists || status=$?
        if [ "$status" -eq 0 ]; then exit 0; fi
        if [ "$status" -ne 1 ]; then
            printf 'Cannot inspect existing socket: %s\n' "$socket" >&2
            exit 1
        fi
        rm -f -- "$socket"
    fi
    # No unlink-early: never replace an active socket on bind.
    exec socat "UNIX-LISTEN:$socket,fork,mode=600" "EXEC:npiperelay.exe -ei -s //./pipe/openssh-ssh-agent,nofork"
fi

for dep in socat npiperelay.exe flock timeout nohup; do
    if ! command -v "$dep" >/dev/null 2>&1; then
        printf 'Bitwarden SSH relay: missing command: %s\n' "$dep" >&2
        exit 1
    fi
done
umask 077
mkdir -p "$(dirname "$socket")" "$state_dir"
chmod 700 "$state_dir"
if [ -L "$socket" ] || { [ -e "$socket" ] && [ ! -S "$socket" ]; }; then
    printf 'Bitwarden SSH relay: refusing to replace non-socket path: %s\n' "$socket" >&2
    exit 1
fi
if socket_ready; then exit 0; fi

# flock keeps the exclusive lock for the lifetime of socat. --close prevents
# forked client relays from retaining the lock after the listener exits.
nohup flock -n --close "$state_dir/relay.lock" sh "$0" --locked >>"$log_file" 2>&1 </dev/null &

# Wait briefly for the winning process to bind, rather than racing the first
# SSH command. Limit the duration of each readiness probe.
attempt=0
while [ "$attempt" -lt 20 ]; do
    if socket_ready 0.1s; then exit 0; fi
    attempt=$((attempt + 1))
    sleep 0.1
done
printf 'Bitwarden SSH relay: socket not ready; see %s\n' "$log_file" >&2
exit 1
