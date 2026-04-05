# Setup

## overleaf-toolkit

1. Run below

```
git clone https://github.com/overleaf/toolkit.git ./overleaf-toolkit
cd ./overleaf-toolkit
bin/init
mkdir data/overleaf data/mongo data/redis data/git-bridge
```

2. Edit config

```
# config/overleaf.rc

OVERLEAF_IMAGE_NAME=tuetenk0pp/sharelatex-full
```

2. Edit functions

```sh
# lib/shared-functions.sh

function read_variable() {
  local name=$1
  grep -E "^$name=" "$TOOLKIT_ROOT/config/variables.env" \
  | sed -r "s/^$name=[\"']?([^\"']+)[\"']?\$/\1/"
}

function read_configuration() {
  local name=$1
  grep -E "^$name=" "$TOOLKIT_ROOT/config/overleaf.rc" \
  | sed -r "s/^$name=[\"']?([^\"']+)[\"']?\$/\1/"
}
```

3. Build up

```
export DOCKER_DEFAULT_PLATFORM=linux/amd64; bin/up
```

4. Create account

http://localhost/launchpad
