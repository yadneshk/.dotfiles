ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Load completions
autoload -Uz compinit && compinit
#autoload -U colors && colors

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

#zinit snippet OMZP::git
#zinit snippet OMZP::sudo
#zinit snippet OMZP::azure
#zinit snippet OMZP::kubectl
#zinit snippet OMZP::kubectx


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
#setopt globdots
unsetopt correct_all

# Add in zsh plugins
#zinit light zsh-users/zsh-syntax-highlighting
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
zinit light Aloxaf/fzf-tab

export XDG_CONFIG_HOME="$HOME/.config"
export GOPATH="$HOME/code/go"; export GOBIN="$GOPATH/bin"; export GOROOT="$HOME/code/go/goroot"; export PATH="$GOPATH/bin:$PATH"; # g-install: do NOT edit, see https://github.com/stefanmaric/g
export PATH="$HOME/.pyenv/bin:$HOME/.local/bin:$PATH"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH=$PATH:$HOME/.npm-global/bin
export FZF_DEFAULT_COMMAND="rg --files --follow --hidden --glob '!.git'"
export FZF_DEFAULT_OPTS="--highlight-line \
--height=60% \
--layout=reverse \
--info=inline-right \
--ansi \
--border=rounded \
--prompt '∷ ' \
--marker ⇒ \
--color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796 \
--color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6 \
--color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796 \
--color=selected-bg:#494D64 \
--color=border:#6E738D,label:#CAD3F5"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :100 {}'"

zstyle ':completion:*' matcher-list "" "m:{a-z}={A-Z}" "m:{a-zA-Z}={A-Za-z}" "r:|[._-]=* r:|=* l:|=*" 
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select=2
zstyle ":completion:*" completer _expand _complete _correct _approximate
zstyle ":completion:*" list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ":completion:*" use-compctl false
zstyle ":completion:*" verbose true
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ":fzf-tab:complete:cd:*" fzf-preview "eza -1 --color=always --icons=always \${realpath}"
zstyle ':fzf-tab:*' switch-group '<' '>'

alias azcli="source /home/ykulkarn/code/go/src/github.com/Azure/ARO-RP/pyenv/bin/activate"
alias azcluster-creds="get_cluster_credentials"
alias arohcp="cd /home/ykulkarn/code/go/src/github.com/Azure/ARO-HCP"
alias arorp="cd /home/ykulkarn/code/go/src/github.com/Azure/ARO-RP"
alias vimcfg="cd /home/ykulkarn/.config/nvim"
alias vim="nvim"
alias c="clear"
alias k="kubectl"
alias cat="bat"
alias o="oc"
alias ls='eza --icons=always'
alias ll='eza -l --icons=always'
alias lt='eza --tree --level=1 --icons=always'
alias azcli="source /home/ykulkarn/code/go/src/github.com/Azure/ARO-RP/pyenv/bin/activate"
alias arohcp="cd /home/ykulkarn/code/go/src/github.com/Azure/ARO-HCP"
alias arorp="cd /home/ykulkarn/code/go/src/github.com/Azure/ARO-RP"
alias gover="$GOPATH/bin/g"; # g-install: do NOT edit, see https://github.com/stefanmaric/g

# Load the kubectl completion code for zsh[1] into the current shell
source <(kubectl completion zsh)
source <(oc completion zsh)

eval "$(pyenv init --path)"
eval "$(pyenv init -)"

source ~/.azure_credentials.sh
source ~/.claude.sh
