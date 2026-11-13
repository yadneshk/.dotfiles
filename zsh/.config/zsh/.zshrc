eval "$("/usr/bin/lig" init zsh pre)"
# zmodload zsh/zprof

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
fcd-widget() {
  local dir="$(fd --type d --hidden . '/home/ykulkarn' | fzf)"
  if [[ -n "$dir" ]]; then
    zle push-line
    BUFFER="builtin cd -- ${(q)dir}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N fcd-widget
bindkey '\ed' fcd-widget
WORDCHARS='*?_[]~&;!#$%^(){}<>'

# History
HISTSIZE=100000
HISTFILE=~/.zsh_history
SAVEHIST=10000000
HISTDUP=erase

# Apply sensisble zsh settings
setopt ALWAYS_TO_END        # full completions move cursor to the end
setopt AUTO_CD              # `dirname` is equivalent to `cd dirname`
setopt AUTO_PARAM_SLASH     # if completed parameter is a directory, add a trailing slash
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt HIST_REDUCE_BLANKS     # strip superfluous blanks from history entries
setopt HIST_VERIFY            # edit history-expanded line before executing
setopt INTERACTIVE_COMMENTS
setopt CORRECT              # Correct typos
setopt PATH_DIRS            # perform path search even on command names with slashes
setopt COMPLETE_ALIASES


zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-history-substring-search
# zinit light zsh-users/zsh-autosuggestions
zinit light mrjohannchang/zsh-interactive-cd
zinit ice as"program" from"gh-r" pick"zsh-patina-*/zsh-patina" nocompletions atload'eval "$(zsh-patina activate)"'
zinit light michel-kraemer/zsh-patina
# zinit light zsh-users/zsh-syntax-highlighting
# zinit light zdharma-continuum/fast-syntax-highlighting
#ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern regexp cursor root line)

# Lazy loading
# Must be set before autosuggestions binds widgets. Wrapping
# delete-char-or-list makes Ctrl-D swallow EOF instead of logging out.
typeset -ga ZSH_AUTOSUGGEST_IGNORE_WIDGETS=(
  orig-\*
  beep
  run-help
  set-local-history
  which-command
  yank
  yank-pop
  zle-\*
  delete-char-or-list
)
zinit wait lucid atload'_zsh_autosuggest_start' light-mode for zsh-users/zsh-autosuggestions
#zinit wait lucid light-mode for Aloxaf/fzf-tab

# Set up fzf key bindings and fuzzy completion
export FZF_CTRL_T_COMMAND="fd --type f --hidden --follow"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow"
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
source ${ZDOTDIR:-${HOME}/.dotfiles/zsh/.config/zsh}/.fzf-history-delete.zsh

#export GCM_CREDENTIAL_STORE=secretservice
export DOCKER_COMMAND=podman
export EDITOR=nvim
export VISUAL=nvim
export COLORTERM=${COLORTERM:-truecolor}
export XDG_CONFIG_HOME="$HOME/.config"
export GOPATH="$HOME/code/go"; export GOBIN="$GOPATH/bin"; export GOROOT="$HOME/code/go/goroot"; export PATH="$GOPATH/bin:$PATH"; # g-install: do NOT edit, see https://github.com/stefanmaric/g
export PATH="$HOME/.pyenv/bin:$HOME/.local/bin:/usr/local/bin:$HOME/code/go/src/github.com/Azure/ARO-HCP/tooling/hcpctl:$PATH"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
#export PATH=$PATH:$HOME/.npm-global/bin
#export FZF_CTRL_T__COMMAND="fd --type file --color always --follow --hidden --no-ignore --exclude '~/.var' --exclude '~/.cache' --exclude '~/.local' --exclude '~/Videos'"
#export FZF_DEFAULT_COMMAND='find . -type f ! -path "*git*"'
#export FZF_DEFAULT_COMMAND="rg --files --follow --hidden --glob '!.git'"
# export FZF_DEFAULT_COMMAND='fd --type f --color always --follow --hidden'
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
# export FZF_CTRL_T_OPTS="--preview 'fzf-preview.sh {}' --bind='enter:become:nvim {} >/dev/tty'"
# export FZF_CTRL_R_OPTS="--with-nth 2.. --color header:italic"
export FZF_CTRL_R_OPTS="--preview 'echo {2..}' --preview-window down:3:wrap --with-nth 2.. --color header:italic"
#export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :100 {}'"
export FZF_ALT_C_OPTS="--delimiter=/ --nth=-2 --preview 'eza -T -L 2 --group-directories-first --color=always --icons=always {}'"

# Turbo
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
zinit cdreplay -q

# Remove right prompt trailing space
ZLE_RPROMPT_INDENT=0

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source ${HOME}/.dotfiles/zsh/.config/zsh/.p10k.zsh
source ${ZDOTDIR:-${HOME}/.dotfiles/zsh/.config/zsh}/.history-success-only.zsh

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
#alias azcli="source $HOME/code/go/src/github.com/Azure/ARO-RP/pyenv/bin/activate"
alias arohcp="cd $HOME/code/go/src/github.com/Azure/ARO-HCP"
alias arorp="cd $HOME/code/go/src/github.com/Azure/ARO-RP"
alias gover="$GOPATH/bin/g"; # g-install: do NOT edit, see https://github.com/stefanmaric/g
alias grep="grep --color=always"
alias update="sudo dnf upgrade --refresh -y && flatpak update -y && zinit update && zinit self-update"
alias aro="az aro"
alias ctx="kubectx"

fkenv() {
  local kf
  kf=$(print -l "$HOME"/.kube/config(N) "$HOME"/.kube/*.kubeconfig(N) | fzf --prompt="kubeconfig> " --preview='kubectl --kubeconfig {} config get-contexts --no-headers 2>/dev/null' --height=40% --delimiter=/ --nth=-1 --with-nth=-1) || return
  export KUBECONFIG="$kf"
}


fgbr() {
  local branch
  branch=$(git branch --sort=-committerdate --format='%(refname:short)' 2>/dev/null |
    fzf --prompt="branch> " \
        --preview='git log --oneline --graph --color=always -15 {}' \
        --height=40%) || return
  git switch "$branch"
}

fps() {
  local pid
  pid=$(ps -u "$USER" -o pid,ppid,%cpu,%mem,etime,comm --sort=-%cpu |
    fzf --header-lines=1 \
        --prompt="process> " \
        --preview='ps -p {1} -o pid,ppid,user,%cpu,%mem,start,etime,command --no-headers -ww' \
        --preview-window=wrap,75% \
        --height=50% \
        --bind='shift-delete:execute-silent(kill -9 {1})+reload(ps -u "$USER" -o pid,ppid,%cpu,%mem,etime,comm --sort=-%cpu)') || return
  kill -9 "$pid"
}

fport() {
  local line pid
  line=$(ss -tulnp 2>/dev/null |
    fzf --header-lines=1 \
        --prompt="port> " \
        --preview='pid=$(echo {} | grep -oP "pid=\K[0-9]+" | head -1)
                   if [ -n "$pid" ]; then
                     ps -p $pid -o pid,user,%cpu,%mem,etime,args -ww
                     echo ""
                     echo "── process tree ──"
                     pstree -p $pid 2>/dev/null
                   else
                     echo "no pid visible (try: sudo fport)"
                   fi' \
        --preview-window=wrap,50% \
        --height=50% \
        --bind='shift-delete:execute-silent(echo {} | grep -oP "pid=\K[0-9]+" | head -1 | xargs -r kill -9)+reload(ss -tulnp 2>/dev/null | tail -n +2)') || return
  pid=$(echo "$line" | grep -oP 'pid=\K[0-9]+' | head -1)
  [[ -n "$pid" ]] && echo "Port $(echo "$line" | awk '{print $5}') → PID $pid"
}

faz() {
  local sub
  sub=$(az account list --query '[].{id:id, name:name, state:state}' -o tsv 2>/dev/null |
    awk -F'\t' '{print $1 " - " $2 "\t" $1}' |
    fzf --prompt="subscription> " \
        --delimiter=$'\t' \
        --with-nth=1 \
        --preview='az account show --subscription {2} --query "{Name:name, TenantDefaultDomain:tenantDefaultDomain, TenantDisplayName:tenantDisplayName, TenantId:tenantId}" -o table 2>/dev/null' \
        --preview-window=down:6:wrap \
        --height=40%) || return
  local id=$(echo "$sub" | awk -F'\t' '{print $2}')
  az account set --subscription "$id" && echo "Switched → $(echo "$sub" | awk -F'\t' '{print $1}')"
}

fenv() {
  local line
  line=$(env | sort |
    fzf --prompt="env> " \
        --delimiter='=' \
        --preview='echo {} | cut -d= -f2- | tr ":" "\n"' \
        --preview-window=down:5:wrap \
        --height=50%) || return
  echo "$line"
}

fglog() {
  local sha
  sha=$(git log --oneline --graph --color=always --date=short \
        --format='%C(auto)%h %C(green)%ad %C(blue)%an%C(auto)%d %s' 2>/dev/null |
    fzf --ansi --no-sort \
        --prompt="log> " \
        --preview='sha=$(echo {} | grep -oE "[a-f0-9]{7,}" | head -1)
                   echo "── changed files ──"
                   git diff-tree --no-commit-id --name-status -r $sha 2>/dev/null
                   echo ""
                   echo "── diff ──"
                   git show --stat --color=always $sha 2>/dev/null
                   echo ""
                   git diff $sha^..$sha --color=always 2>/dev/null' \
        --preview-window=right:60%:wrap \
        --height=80% \
        --bind='ctrl-y:execute-silent(echo {} | grep -oE "[a-f0-9]{7,}" | head -1 | tr -d "\n" | xclip -selection clipboard)') || return
  echo "$sha" | grep -oE '[a-f0-9]{7,}' | head -1
}

fgstash() {
  local stash
  stash=$(git stash list 2>/dev/null |
    fzf --prompt="stash> " \
        --preview='s=$(echo {} | cut -d: -f1)
                   echo "── files ──"
                   git stash show --name-status $s 2>/dev/null
                   echo ""
                   echo "── diff ──"
                   git stash show -p --color=always $s 2>/dev/null' \
        --preview-window=right:65%:wrap \
        --height=70% \
        --bind='ctrl-d:execute-silent(git stash drop $(echo {} | cut -d: -f1))+reload(git stash list)') || return
  local target=$(echo "$stash" | cut -d: -f1)
  [[ -n "$target" ]] && git stash apply "$target"
}

farologin() {
  local cluster_info selected name rg apiserver creds user pass
  echo "Fetching ARO clusters..."
  cluster_info=$(az aro list --query '[].{name:name, resourceGroup:resourceGroup, apiserver:apiserverProfile.url}' -o tsv 2>/dev/null)
  if [[ -z "$cluster_info" ]]; then
    echo "No ARO clusters found or not logged in to Azure."
    return 1
  fi

  selected=$(echo "$cluster_info" |
    awk -F'\t' '{printf "%-30s %-30s %s\n", $1, $2, $3}' |
    fzf --prompt="aro cluster> " \
        --header="$(printf "%-30s %-30s %s" "NAME" "RESOURCE GROUP" "API SERVER")" \
        --preview='name=$(echo {} | awk "{print \$1}"); rg=$(echo {} | awk "{print \$2}"); az aro show -n "$name" -g "$rg" -o yaml 2>/dev/null' \
        --preview-window=right:50%:wrap \
        --height=60%) || return

  name=$(echo "$selected" | awk '{print $1}')
  rg=$(echo "$selected" | awk '{print $2}')
  apiserver=$(echo "$selected" | awk '{print $3}')

  echo "Fetching credentials for $name in $rg..."
  user=$(az aro list-credentials -n "$name" -g "$rg" --query 'kubeadminUsername' -o tsv 2>/dev/null)
  pass=$(az aro list-credentials -n "$name" -g "$rg" --query 'kubeadminPassword' -o tsv 2>/dev/null)

  if [[ -z "$user" || -z "$pass" || -z "$apiserver" ]]; then
    echo "Failed to retrieve credentials or API server URL for $name."
    return 1
  fi
  echo "Logging into $name as $user ($apiserver)..."
  oc login "$apiserver" -u "$user" -p "$pass" --insecure-skip-tls-verify=true
}

farovm() {
  local cluster_info selected name rg cluster_json cluster_rg node_vms pick_vm vm_name vm_type vm_rg vmss_id

  echo "Fetching ARO clusters..."
  cluster_info=$(az aro list --query '[].{name:name, resourceGroup:resourceGroup, apiserver:apiserverProfile.url}' -o tsv 2>/dev/null)
  if [[ -z "$cluster_info" ]]; then
    echo "No ARO clusters found or not logged in to Azure."
    return 1
  fi

  selected=$(echo "$cluster_info" |
    awk -F'\t' '{printf "%-30s %-30s %s\n", $1, $2, $3}' |
    fzf --prompt="aro cluster> " \
        --header="$(printf "%-30s %-30s %s" "NAME" "RESOURCE GROUP" "API SERVER")" \
        --preview='name=$(echo {} | awk "{print \$1}"); rg=$(echo {} | awk "{print \$2}"); az aro show -n "$name" -g "$rg" -o yaml 2>/dev/null' \
        --preview-window=right:50%:wrap \
        --height=60%) || return

  name=$(echo "$selected" | awk '{print $1}')
  rg=$(echo "$selected" | awk '{print $2}')

  echo "Finding cluster resource group for $name..."
  cluster_rg=$(az aro show -n "$name" -g "$rg" --query 'clusterProfile.resourceGroupId' -o tsv 2>/dev/null | awk -F'/' '{print $NF}')
  if [[ -z "$cluster_rg" ]]; then
    cluster_rg=$(az aro show -n "$name" -g "$rg" --query 'resourceGroup' -o tsv 2>/dev/null)
  fi

  if [[ -z "$cluster_rg" ]]; then
    echo "Could not find resource group via query. Trying direct show:"
    az aro show -n "$name" -g "$rg" -o table
    return 1
  fi

  echo "Cluster node resource group: $cluster_rg"
  echo "Fetching nodes in $cluster_rg..."

  local standalone_vms vmss_vms
  standalone_vms=$(az vm list -g "$cluster_rg" --query '[].{name:name, size:hardwareProfile.vmSize, state:provisioningState}' -o tsv 2>/dev/null |
    awk -F'\t' -v crg="$cluster_rg" '{printf "%-38s %-12s %-22s %-14s\t%s\t%s\n", $1, "master", ($2 ? $2 : "-"), ($3 ? $3 : "-"), "standalone", crg}')

  vmss_vms=""
  for vmss in $(az vmss list -g "$cluster_rg" --query '[].name' -o tsv 2>/dev/null); do
    [[ -z "$vmss" ]] && continue
    local instances
    instances=$(az vmss list-instances -g "$cluster_rg" -n "$vmss" --query '[].{name:osProfile.computerName, id:instanceId, size:sku.name, state:provisioningState}' -o tsv 2>/dev/null |
      awk -F'\t' -v crg="$cluster_rg" -v sname="$vmss" '{
        n = ($1 ? $1 : sname "_" $2);
        printf "%-38s %-12s %-22s %-14s\t%s\t%s:%s:%s\n", n, "worker", ($3 ? $3 : "-"), ($4 ? $4 : "-"), "vmss", crg, sname, $2
      }')
    [[ -n "$instances" ]] && vmss_vms+="${instances}"$'\n'
  done

  node_vms="${standalone_vms}"$'\n'"${vmss_vms}"
  node_vms=$(echo "$node_vms" | sed '/^[[:space:]]*$/d')

  if [[ -z "$node_vms" ]]; then
    echo "No nodes found in $cluster_rg. Checking direct VM list:"
    az vm list -g "$cluster_rg" -o table
    az vmss list -g "$cluster_rg" -o table
    return 1
  fi

  pick_vm=$(echo "$node_vms" |
    fzf --prompt="node> " \
        --delimiter=$'\t' \
        --with-nth=1 \
        --header="$(printf "%-38s %-12s %-22s %-14s" "NODE NAME" "ROLE" "VM SIZE" "STATUS")" \
        --preview='type=$(echo {2}); loc=$(echo {3});
                   if [[ "$type" == "vmss" ]]; then
                     crg=$(echo "$loc" | cut -d: -f1); sname=$(echo "$loc" | cut -d: -f2); iid=$(echo "$loc" | cut -d: -f3);
                     az vmss show -g "$crg" -n "$sname" --instance-id "$iid" -o yaml 2>/dev/null;
                   else
                     vname=$(echo {1} | awk "{print \$1}"); crg="$loc";
                     az vm show -g "$crg" -n "$vname" -d -o yaml 2>/dev/null;
                   fi' \
        --preview-window=right:55%:wrap \
        --height=70%) || return

  vm_name=$(echo "$pick_vm" | awk -F'\t' '{print $1}' | awk '{print $1}')
  vm_type=$(echo "$pick_vm" | awk -F'\t' '{print $2}')
  vm_loc=$(echo "$pick_vm" | awk -F'\t' '{print $3}')

  echo "Showing full details for $vm_name..."
  if [[ "$vm_type" == "vmss" ]]; then
    local s_crg=$(echo "$vm_loc" | cut -d: -f1)
    local s_name=$(echo "$vm_loc" | cut -d: -f2)
    local s_iid=$(echo "$vm_loc" | cut -d: -f3)
    az vmss show -g "$s_crg" -n "$s_name" --instance-id "$s_iid" -d -o yaml
  else
    az vm show -g "$vm_loc" -n "$vm_name" -d -o yaml
  fi
}

fz() {
  local -A cmds=(
    ["farologin Login to ARO cluster"]="farologin"
    ["farovm    Show VM details of ARO nodes"]="farovm"
    ["fgbr      Switch git branch"]="fgbr"
    ["fglog     Browse git log & diff"]="fglog"
    ["fgstash   Browse git stashes & diff"]="fgstash"
    ["fps       List running process"]="fps"
    ["fport     Show listening ports & kill"]="fport"
    ["faz       Switch Azure subscription"]="faz"
    ["fenv      Browse environment variables"]="fenv"
    ["fkenv     Switch kubeconfig"]="fkenv"
  )
  local pick
  pick=$(printf '%s\n' "${(@k)cmds}" | sort |
    fzf --prompt="fz> " \
        --height=40% \
        --no-preview) || return
  eval "${cmds[$pick]}"
}

fz-widget() {
  zle -I
  fz
  zle reset-prompt
}
zle -N fz-widget
bindkey '\ez' fz-widget

export PATH="$HOME/.pyenv/shims:$PATH"
export KUBECONFIG=$(find ~/.kube -maxdepth 1 -name '*.kubeconfig' | paste -sd:)
pyenv() {
  unfunction pyenv
  eval "$(command pyenv init --path)"
  eval "$(command pyenv init -)"
  pyenv "$@"
}

source ${HOME}/.dotfiles/zsh/.config/zsh/.azure_credentials.sh
source <(oc completion zsh)
# if [ $commands[oc] ]; then
#   compdef _oc oc
# fi
if [ $commands[k] ]; then
  source <(kubectl completion zsh)
  compdef _kubectl k
fi

source ${HOME}/.dotfiles/zsh/.config/zsh/pi-enmaas-key.sh

# zprof
# >>> lig pre >>>
eval "$("/usr/bin/lig" init zsh post)"
# <<< lig post <<<
