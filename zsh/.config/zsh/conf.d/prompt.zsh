# Prompt & Theme styling

ZLE_RPROMPT_INDENT=0

# Powerlevel10k theme configuration
[[ -f "${ZDOTDIR}/.p10k.zsh" ]] && source "${ZDOTDIR}/.p10k.zsh"

# Record only successful commands in history
[[ -f "${ZDOTDIR}/.history-success-only.zsh" ]] && source "${ZDOTDIR}/.history-success-only.zsh"
