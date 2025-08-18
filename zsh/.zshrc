if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey "^[[1;5D" backward-word   # Ctrl+Left
bindkey "^[[1;5C" forward-word    # Ctrl+Right
WORDCHARS='*?_=[]~&;!#$%^(){}<>'

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q


zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview-window '--height 60% --border' # Example with right-aligned, 60% width, and wrapping
zstyle ':fzf-tab:*' use-fzf-default-opts yes

source /home/ykulkarn/code/ricing/zsh-transient-prompt/transient-prompt.zsh-theme
#TRANSIENT_PROMPT_TRANSIENT_PROMPT='%  '
autoload -U colors && colors

SEG_BG="#ed8796" # background for the segment
SEG_FG="#181926"    # text/icon color inside the segment
ICON="󰣛"          # Nerd‑Font glyph (paste directly or use \u)
ICON_CLOCK=""
SEG2_BG="#b7bdf8"

TRANSIENT_PROMPT_TRANSIENT_PROMPT=$'\n❯ '
TRANSIENT_PROMPT_RPROMPT='%(?..%B%F{1}%?%f%b)'
#TRANSIENT_PROMPT_TRANSIENT_PROMPT=$'\n''%F{'$SEG_BG'}'\
#'%K{'$SEG_BG'}%F{'$SEG_FG'}'"$ICON"' %n %f%k'\
#'%F{'$SEG_BG'}%K{'$SEG2_BG'}'\
#'%F{'$SEG_FG'} '"$ICON_CLOCK"' %D{%H:%M} %f%k'\
#'%F{'$SEG2_BG'}%f'$'\n''❯ '
get_cluster_credentials() {
    #if [[ -z "$RG" || -z "$NAME" ]]; then
    #    echo "Error: RG (resource group) and NAME (cluster name) must be set."
    #    echo "Usage: export RG=<resource-group>; export NAME=<cluster-name>; get-cluster-credentials"
    #    return 1
    #fi
    az aro list-credentials -g "$1" -n "$2" && \
    az aro show -g "$1" -n "$2" --query apiserverProfile.url -o tsv
}

# Alias for the function
alias rebase='git fetch origin main && git rebase origin/main'

export PATH=$PATH:$GOPATH/bin
#export EDITOR=nvim
#export VISUAL=nvim
#export OC_EDITOR=vim

alias azcli="source /home/ykulkarn/code/go/src/github.com/Azure/ARO-RP/pyenv/bin/activate"
alias azcluster-creds="get_cluster_credentials"
alias arohcp="cd /home/ykulkarn/code/go/src/github.com/Azure/ARO-HCP"
alias arorp="cd /home/ykulkarn/code/go/src/github.com/Azure/ARO-RP"
alias vimcfg="cd /home/ykulkarn/.config/nvim"
alias ls='ls --color -ltr'
alias vim="nvim"
alias c="clear"
alias k="kubectl"
alias cat="bat"
alias o="oc"
alias s="sudo"
alias ls='eza --icons=always'
alias ll='eza -l --icons=always'
alias lt='eza --tree --level=1 --icons=always'
alias kittyconf="vim ~/.dotfiles/kitty/.config/kitty/kitty.conf"
alias alacrittyconf="vim ~/.dotfiles/alacritty/.config/alacritty/alacritty.toml"
alias tmuxconf="vim ~/.dotfiles/tmux/.config/tmux/tmux.conf"
alias nvimconf="vim ~/.dotfiles/neovim/.config/nvim/init.lua"
alias zshconf="vim ~/.dotfiles/zsh/.zshrc"
alias starshipconf="vim ~/.dotfiles/starship/.config/starship/starship.toml"

# Load the kubectl completion code for zsh[1] into the current shell
source <(kubectl completion zsh)
source <(oc completion zsh)

export GOPATH="$HOME/code/go"; export GOROOT="$GOPATH/goroot"; export PATH="$GOPATH/bin:$PATH"; # g-install: do NOT edit, see https://github.com/stefanmaric/g
export PATH="$HOME/.pyenv/bin:$PATH"
export FZF_CTRL_R_OPTS="--height 60% --layout=reverse --border --prompt '∷ ' --pointer ▶ --marker ⇒"

#export FZF_CTRL_T_OPTS='--preview "bat --style=numbers --color=always --line-range :100 {}" --height 40% --layout=reverse --border'
export FZF_CTRL_T_OPTS="--height 60% \
--border \
--preview 'bat --style=numbers --color=always --line-range :100 {}' \
--layout reverse \
--prompt '∷ ' \
--pointer ▶ \
--marker ⇒"

export XDG_CONFIG_HOME="$HOME/.config"
export STARSHIP_CONFIG=$HOME/.dotfiles/starship/.config/starship/starship.toml
export PATH=$PATH:$HOME/.npm-global/bin
export FZF_DEFAULT_OPTS=" \
--color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796 \
--color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6 \
--color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796 \
--color=selected-bg:#494D64 \
--color=border:#6E738D,label:#CAD3F5"

eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(fzf --zsh)"

source ~/.azure_credentials.sh
source ~/.claude.sh


