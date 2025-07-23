# Created by newuser for 5.9
#

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Keybindings
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

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

WORDCHARS='*?_=[]~&;!#$%^(){}<>'
bindkey "^[[1;5D" backward-word   # Ctrl+Left
bindkey "^[[1;5C" forward-word    # Ctrl+Right


# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship
zinit snippet OMZP::kube-ps1
zinit snippet OMZP::kubectx

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q


zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview-window 'right:60%:wrap' # Example with right-aligned, 60% width, and wrapping

source /home/ykulkarn/code/ricing/zsh-transient-prompt/transient-prompt.zsh-theme
#TRANSIENT_PROMPT_TRANSIENT_PROMPT='%  '
autoload -U colors && colors

SEG_BG="#ed8796" # background for the segment
SEG_FG="#181926"    # text/icon color inside the segment
ICON="󰣛"          # Nerd‑Font glyph (paste directly or use \u)
ICON_CLOCK=""
SEG2_BG="#b7bdf8"

TRANSIENT_PROMPT_TRANSIENT_PROMPT=$'\n''%F{'$SEG_BG'}'\
'%K{'$SEG_BG'}%F{'$SEG_FG'}'"$ICON"' %n %f%k'\
'%F{'$SEG_BG'}%K{'$SEG2_BG'}'\
'%F{'$SEG_FG'} '"$ICON_CLOCK"' %D{%H:%M} %f%k'\
'%F{'$SEG2_BG'}%f'$'\n' 
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
export EDITOR=nvim
export VISUAL=nvim
#export OC_EDITOR=vim

alias azcli="source /home/ykulkarn/code/go/src/github.com/Azure/ARO-RP/pyenv/bin/activate && starship toggle azure"
alias azcluster-creds="get_cluster_credentials"
alias arohcp="cd /home/ykulkarn/code/go/src/github.com/Azure/ARO-HCP"
alias vimcfg="cd /home/ykulkarn/.config/nvim"
alias ls='ls --color -ltr'
alias vim="nvim"
alias c="clear"
alias k="kubectl"
alias cat="bat"
alias o="oc"
alias ls='eza -a --icons=always'
alias ll='eza -al --icons=always'
alias lt='eza -a --tree --level=1 --icons=always'
alias kittyconf="vim ~/.dotfiles/kitty/.config/kitty/kitty.conf"
alias alacrittyconf="vim ~/.dotfiles/alacritty/.config/alacritty/alacritty.toml"
alias tmuxconf="vim ~/.dotfiles/tmux/.config/tmux/tmux.conf"
alias nvimconf="vim ~/.dotfiles/neovim/.config/nvim/init.lua"
alias zshconf="vim ~/.dotfiles/zsh/.zshrc"
alias starshipconf="vim ~/.dotfiles/starship/.config/starship/starship.toml"

# Load the kubectl completion code for zsh[1] into the current shell
source <(kubectl completion zsh)
source <(oc completion zsh)
# Set the kubectl completion code for zsh[1] to autoload on startup
kubectl completion zsh > "${fpath[1]}/_kubectl"

export GOPATH="$HOME/code/go"; export GOROOT="$GOPATH/goroot"; export PATH="$GOPATH/bin:$PATH"; # g-install: do NOT edit, see https://github.com/stefanmaric/g
export PATH="$HOME/.pyenv/bin:$PATH"
export FZF_CTRL_R_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_OPTS='--preview "bat --style=numbers --color=always --line-range :100 {}" --height 40% --layout=reverse --border'
export XDG_CONFIG_HOME="$HOME/.config"

eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(fzf --zsh)"

source ~/.azure_credentials.sh
