# Environment variables

export DOCKER_COMMAND=podman
export EDITOR=nvim
export VISUAL=nvim
export COLORTERM=${COLORTERM:-truecolor}
export XDG_CONFIG_HOME="$HOME/.config"

# Go
export GOPATH="$HOME/code/go"
export GOBIN="$GOPATH/bin"
export GOROOT="$HOME/code/go/goroot"
export PATH="$GOPATH/bin:$PATH"

# User binaries & tooling
export PATH="$HOME/.azure/bin:$HOME/.pyenv/bin:$HOME/.local/bin:/usr/local/bin:$HOME/code/go/src/github.com/Azure/ARO-HCP/tooling/hcpctl:$PATH"

# Locales
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
