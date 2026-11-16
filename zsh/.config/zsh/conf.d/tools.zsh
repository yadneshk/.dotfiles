# Third-party CLI tools, environments & credentials

# Pyenv
export PATH="$HOME/.pyenv/shims:$PATH"
pyenv() {
  unfunction pyenv
  eval "$(command pyenv init --path)"
  eval "$(command pyenv init -)"
  pyenv "$@"
}

# Kubeconfig
export KUBECONFIG=$(find ~/.kube -maxdepth 1 -name '*.kubeconfig' 2>/dev/null | paste -sd:)

# Credentials & external secrets
[[ -f "${ZDOTDIR}/.azure_credentials.sh" ]] && source "${ZDOTDIR}/.azure_credentials.sh"
[[ -f "${ZDOTDIR}/pi-enmaas-key.sh" ]] && source "${ZDOTDIR}/pi-enmaas-key.sh"
