# Persist interactive history only when the command exits 0.
# zshaddhistory runs before execution, so the line is stashed and
# written from precmd after the status is known. Returning the captured
# status keeps later precmd hooks (p10k) accurate.
autoload -Uz add-zsh-hook

typeset -g _hist_success_only_cmd=
typeset -gi _hist_success_only_save=0

_hist_success_only_stash() {
  emulate -L zsh
  (( _hist_success_only_save )) && return 0
  _hist_success_only_cmd=${1%$'\n'}
  return 1
}

_hist_success_only_precmd() {
  integer _hs=$?
  emulate -L zsh

  if [[ -n $_hist_success_only_cmd ]] &&
     (( _hs == 0 )) &&
     [[ $_hist_success_only_cmd != [[:space:]]* ]]; then
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
