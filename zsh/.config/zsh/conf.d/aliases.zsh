# Aliases

alias vim="nvim"
alias vimdiff="nvim -d"
alias diff="colordiff -y"
alias c="clear"
alias k="kubectl"
alias cat="bat -p"
alias o="oc"
alias ls='eza -lh --group-directories-first --icons=always'
alias ll='eza -l -lh --group-directories-first --icons=always'
alias la='eza -l -a -lh --group-directories-first --icons=always'
alias lt='eza --tree --level=1 --icons=always -lh --group-directories-first'
alias gover="$GOPATH/bin/g"
alias grep="grep --color=always"
alias update="sudo dnf upgrade --refresh -y && flatpak update -y && zinit update && zinit self-update"
alias ctx="kubectx"

# Azure & ARO
alias aro="az aro"
alias arohcp="cd $HOME/code/go/src/github.com/Azure/ARO-HCP"
alias arorp="cd $HOME/code/go/src/github.com/Azure/ARO-RP"
