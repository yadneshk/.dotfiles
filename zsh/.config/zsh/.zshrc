#POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

source /usr/share/cachyos-zsh-config/cachyos-config.zsh
source /home/ykulkarn/.config/zsh/.my_configs.sh


# Choose your prompt engine: "p10k" or "omp"
export ZSH_PROMPT_ENGINE="p10k"

# Common environment settings
export ZSH_DISABLE_COMPFIX=true
setopt prompt_subst

# Load Powerlevel10k
if [[ "$ZSH_PROMPT_ENGINE" == "p10k" ]]; then
  source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
  [[ -f /home/ykulkarn/.config/zsh/.p10k.zsh ]] && source /home/ykulkarn/.config/zsh/.p10k.zsh
fi

# Load oh-my-posh
if [[ "$ZSH_PROMPT_ENGINE" == "omp" ]]; then
  eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config.omp.toml)"
fi

