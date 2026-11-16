# Base directory
ZDOTDIR="${ZDOTDIR:-${HOME}/.dotfiles/zsh/.config/zsh}"

# lig pre-init
(( $+commands[lig] )) && eval "$(lig init zsh pre)"

# Enable Powerlevel10k instant prompt (must stay near the top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load modular configurations in strict order
local -a config_files=(
  env.zsh
  options.zsh
  keybindings.zsh
  plugins.zsh
  fzf.zsh
  completion.zsh
  prompt.zsh
  aliases.zsh
  fzf-tools.zsh
  tools.zsh
)

for config_file in "${config_files[@]}"; do
  [[ -r "${ZDOTDIR}/conf.d/${config_file}" ]] && source "${ZDOTDIR}/conf.d/${config_file}"
done
unset config_files config_file

# lig post-init
(( $+commands[lig] )) && eval "$(lig init zsh post)"
