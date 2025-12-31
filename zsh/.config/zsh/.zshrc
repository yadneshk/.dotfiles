# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/code/ricing}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey "^[[1;5D" backward-word   # Ctrl+Left
bindkey "^[[1;5C" forward-word    # Ctrl+Right
WORDCHARS='*?_[]~&;!#$%^(){}<>'

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

# Apply sensisble zsh settings
setopt ALWAYS_TO_END        # full completions move cursor to the end
setopt AUTO_CD              # `dirname` is equivalent to `cd dirname`
setopt AUTO_PARAM_SLASH     # if completed parameter is a directory, add a trailing slash
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt HIST_EXPIRE_DUPS_FIRST
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt INTERACTIVE_COMMENTS
setopt correct              # Correct typos
setopt PATH_DIRS            # perform path search even on command names with slashes

zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-history-substring-search
zinit light zsh-users/zsh-autosuggestions
zinit light mrjohannchang/zsh-interactive-cd
#source /home/ykulkarn/code/ricing/zsh-syntax-highlighting/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh
zinit light zsh-users/zsh-syntax-highlighting
zinit light zdharma-continuum/fast-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern regexp cursor root line)

# Lazy loading
zinit wait lucid atload'_zsh_autosuggest_start' light-mode for zsh-users/zsh-autosuggestions
zinit wait lucid light-mode for Aloxaf/fzf-tab

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

export DOCKER_COMMAND=podman
export EDITOR=nvim
export VISUAL=nvim
export COLORTERM=${COLORTERM:-truecolor}
export XDG_CONFIG_HOME="$HOME/.config"
export GOPATH="$HOME/code/go"; export GOBIN="$GOPATH/bin"; export GOROOT="$HOME/code/go/goroot"; export PATH="$GOPATH/bin:$PATH"; # g-install: do NOT edit, see https://github.com/stefanmaric/g
export PATH="$HOME/.pyenv/bin:$HOME/.local/bin:$PATH"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PATH=$PATH:$HOME/.npm-global/bin
#export FZF_CTRL_T__COMMAND="fd --type file --color always --follow --hidden --no-ignore --exclude '~/.var' --exclude '~/.cache' --exclude '~/.local' --exclude '~/Videos'"
#export FZF_DEFAULT_COMMAND='find . -type f ! -path "*git*"'
#export FZF_DEFAULT_COMMAND="rg --files --follow --hidden --glob '!.git'"
export FZF_DEFAULT_OPTS="--highlight-line \
--style=default \
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
export FZF_ALT_C_COMMAND='fd --color always --hidden --type d . '
export FZF_ALT_C_OPTS="--preview 'eza -l -T -L 2 --group-directories-first --color=always --icons=always {}'"

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu no
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:descriptions' format '-- %d --'
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:complete:*:options' sort true
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm,cmd -w -w'
zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap
#zstyle ":fzf-tab:complete:cd:*" fzf-preview "tree -L 2 -C \${realpath}"
zstyle ':completion:*' fzf-search-display true

# General file preview for most commands (should come first)
zstyle ':fzf-tab:complete:*:*' fzf-preview 'if [[ -f $realpath ]]; then bat --color=always --style=numbers --line-range :100 $realpath; elif [[ -d $realpath ]]; then eza -l -T -L 2 --group-directories-first --color=always --icons=always $realpath; fi'

# Specific cd preview (more specific, comes after general)
zstyle ":fzf-tab:complete:cd:*" fzf-preview "eza -l -T -L 2 --group-directories-first --color=always --icons=always \${realpath}"

# Specific previews for common commands
zstyle ':fzf-tab:complete:vim:*' fzf-preview 'bat --color=always --style=numbers --line-range :100 $realpath'
zstyle ':fzf-tab:complete:nvim:*' fzf-preview 'bat --color=always --style=numbers --line-range :100 $realpath'
zstyle ':fzf-tab:complete:cat:*' fzf-preview 'bat --color=always --style=numbers --line-range :100 $realpath'
zstyle ':fzf-tab:complete:bat:*' fzf-preview 'bat --color=always --style=numbers --line-range :100 $realpath'
zstyle ':fzf-tab:complete:less:*' fzf-preview 'bat --color=always --style=numbers --line-range :100 $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'if [[ -f $realpath ]]; then bat --color=always --style=numbers --line-range :100 $realpath; else eza -l -T -L 2 --group-directories-first --color=always --icons=always $realpath; fi'
zstyle ':fzf-tab:complete:eza:*' fzf-preview 'if [[ -f $realpath ]]; then bat --color=always --style=numbers --line-range :100 $realpath; else eza -l -T -L 2 --group-directories-first --color=always --icons=always $realpath; fi'

#zstyle ':completion:*' matcher-list "" "m:{a-z}={A-Z}" "m:{a-zA-Z}={A-Za-z}" "r:|[._-]=* r:|=* l:|=*" 
#zstyle ':completion:*' menu select=2
zstyle ":completion:*" completer _expand _complete _correct _approximate
zstyle ":completion:*" list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
#zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
#zstyle ":completion:*" use-compctl false
#zstyle ":completion:*" verbose true
#zstyle ':fzf-tab:*' use-fzf-default-opts yes
#zstyle ":fzf-tab:complete:cd:*" fzf-preview "eza -1 --color=always --icons=always \${realpath}"


# Turbo
autoload -Uz compinit
compinit
zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source ${HOME}/.dotfiles/zsh/.config/zsh/.p10k.zsh

alias vim="nvim"
alias c="clear"
alias k="kubectl"
alias cat="bat"
alias o="oc"
alias ls='eza -lh --group-directories-first --icons=always'
alias ll='eza -l -lh --group-directories-first --icons=always'
alias la='eza -l -a -lh --group-directories-first --icons=always'
alias lt='eza --tree --level=1 --icons=always -lh --group-directories-first'
alias azcli="source $HOME/code/go/src/github.com/Azure/ARO-RP/pyenv/bin/activate"
alias arohcp="cd $HOME/code/go/src/github.com/Azure/ARO-HCP"
alias arorp="cd $HOME/code/go/src/github.com/Azure/ARO-RP"
alias gover="$GOPATH/bin/g"; # g-install: do NOT edit, see https://github.com/stefanmaric/g
alias grep="grep --color=always"

eval "$(pyenv init --path)"
eval "$(pyenv init -)"

source ~/.azure_credentials.sh
source ~/.claude.sh

#zmodload zsh/zprof
#zprof
