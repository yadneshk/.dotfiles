# Persist interactive history unless the command's exit status is in
# HIST_SKIP_EXIT_CODES. Set that array before sourcing this file to override.
# zshaddhistory runs before execution, so the line is stashed first.
# Return 2 keeps the line on the in-session list (Up-arrow) without writing
# HISTFILE; keepers are then print -sr'd from precmd so other shells see them.
# Returning the captured status keeps later precmd hooks (p10k) accurate.
autoload -Uz add-zsh-hook

if (( ! ${+HIST_SKIP_EXIT_CODES} )); then
  typeset -ga HIST_SKIP_EXIT_CODES=(2 126 127 130)
fi

typeset -g _hist_success_only_cmd=
typeset -gi _hist_success_only_save=0

_hist_success_only_stash() {
  emulate -L zsh
  (( _hist_success_only_save )) && return 0
  _hist_success_only_cmd=${1%$'\n'}
  # Leading space: drop entirely (HIST_IGNORE_SPACE). Everything else stays
  # in the session list so a typo can be recalled with Up-arrow.
  [[ $_hist_success_only_cmd == [[:space:]]* ]] && return 1
  return 2
}

_hist_success_only_precmd() {
  integer _hs=$?
  emulate -L zsh

  if [[ -n $_hist_success_only_cmd ]] &&
     (( ! ${HIST_SKIP_EXIT_CODES[(Ie)$_hs]} )); then
    _hist_success_only_save=1
    builtin print -sr -- "$_hist_success_only_cmd"
    _hist_success_only_save=0
  fi
  _hist_success_only_cmd=

  return $_hs
}

add-zsh-hook zshaddhistory _hist_success_only_stash
add-zsh-hook precmd _hist_success_only_precmd
precmd_functions=(_hist_success_only_precmd ${precmd_functions:#_hist_success_only_precmd})
