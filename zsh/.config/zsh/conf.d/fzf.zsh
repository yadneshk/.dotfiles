# FZF integration & configuration

export FZF_CTRL_T_COMMAND="fd --type f --hidden --follow"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow"

export FZF_DEFAULT_OPTS="--highlight-line \
--style=default \
--height=40% \
--layout=reverse \
--info=inline-right \
--border=rounded \
--color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796 \
--color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6 \
--color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796 \
--color=selected-bg:#494D64 \
--color=border:#6E738D,label:#CAD3F5"

export FZF_CTRL_T_OPTS="--preview 'fzf-preview.sh {}'"
export FZF_CTRL_R_OPTS="--preview 'echo {2..}' --preview-window down:3:wrap --with-nth 2.. --color header:italic"
export FZF_ALT_C_OPTS="--delimiter=/ --nth=-2 --preview 'eza -T -L 2 --group-directories-first --color=always --icons=always {}'"

# Cache fzf --zsh output for fast startup
_fzf_cache="${XDG_CACHE_HOME:-$HOME/.cache}/fzf-zsh.zsh"
if [[ ! -f "$_fzf_cache" || "$(command -v fzf)" -nt "$_fzf_cache" ]]; then
  fzf --zsh > "$_fzf_cache"
fi
source "$_fzf_cache"
unset _fzf_cache

# Lazy-load fzf: widgets self-replace on first keypress
__fzf_lazy_init() {
  emulate -L zsh
  unfunction __fzf_lazy_init __fzf_ctrl_r __fzf_ctrl_t __fzf_alt_c 2>/dev/null
  source <(fzf --zsh)
  zle -N fzf-history-widget fzf-history-widget-with-delete 2>/dev/null
  zle "${1}" -- "${@:2}"
}
for __w in fzf-history-widget fzf-file-widget fzf-cd-widget; do
  eval "__fzf_${__w}() { __fzf_lazy_init ${__w} \"\$@\" }"
  zle -N "${__w}" "__fzf_${__w}"
done
unset __w

bindkey '^R' fzf-history-widget
bindkey '^T' fzf-file-widget
bindkey '\ec' fzf-cd-widget

[[ -f "${ZDOTDIR}/.fzf-history-delete.zsh" ]] && source "${ZDOTDIR}/.fzf-history-delete.zsh"
