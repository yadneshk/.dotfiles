# Zinit bootstrap
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/code/ricing}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Core plugins
zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-history-substring-search
zinit light mrjohannchang/zsh-interactive-cd

# Patina (syntax highlighting)
zinit ice as"program" from"gh-r" pick"zsh-patina-*/zsh-patina" nocompletions atload'eval "$(zsh-patina activate)"'
zinit light michel-kraemer/zsh-patina

# Autosuggestions (lazy loaded)
typeset -ga ZSH_AUTOSUGGEST_IGNORE_WIDGETS=(
  orig-\*
  beep
  run-help
  set-local-history
  which-command
  yank
  yank-pop
  zle-\*
  delete-char-or-list
)
zinit wait lucid atload'_zsh_autosuggest_start' light-mode for zsh-users/zsh-autosuggestions
