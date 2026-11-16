# Keybindings & line editor widgets

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey "^[[1;5D" backward-word   # Ctrl+Left
bindkey "^[[1;5C" forward-word    # Ctrl+Right

# Fuzzy cd widget (Alt+D)
fcd-widget() {
  local dir="$(fd --type d --hidden . '/home/ykulkarn' | fzf)"
  if [[ -n "$dir" ]]; then
    zle push-line
    BUFFER="builtin cd -- ${(q)dir}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N fcd-widget
bindkey '\ed' fcd-widget
