# Custom interactive FZF functions & command palette

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
  local cluster_info selected name rg apiserver user pass
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
  local cluster_info selected name rg cluster_rg node_vms pick_vm vm_name vm_type vm_loc

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
  local entries=(
    "$(print -P "%F{208}󰊢 git%f %F{240}│%f %B%F{15}fgbr     %f%b %F{240}│%f Switch git branch\tfgbr\tInteractive branch switcher with commit graph preview. Press Enter to switch.")"
    "$(print -P "%F{208}󰊢 git%f %F{240}│%f %B%F{15}fglog    %f%b %F{240}│%f Browse git log & diff\tfglog\tView git commits with diff. Press Ctrl-Y to copy commit SHA.")"
    "$(print -P "%F{208}󰊢 git%f %F{240}│%f %B%F{15}fgstash  %f%b %F{240}│%f Browse git stashes & diff\tfgstash\tView stashes with patch diff. Press Enter to apply, Ctrl-D to drop.")"
    "$(print -P "%F{75}󰠅 az %f %F{240}│%f %B%F{15}faz      %f%b %F{240}│%f Switch Azure subscription\tfaz\tSwitch active Azure subscription with tenant & account details.")"
    "$(print -P "%F{75}󰠅 az %f %F{240}│%f %B%F{15}farologin%f%b %F{240}│%f Login to ARO cluster\tfarologin\tSelect Azure Red Hat OpenShift cluster and authenticate with oc login.")"
    "$(print -P "%F{75}󰠅 az %f %F{240}│%f %B%F{15}farovm   %f%b %F{240}│%f Show VM details of ARO nodes\tfarovm\tInspect master standalone VMs and worker VMSS instances of an ARO cluster.")"
    "$(print -P "%F{114}󱃾 k8s%f %F{240}│%f %B%F{15}fkenv    %f%b %F{240}│%f Switch kubeconfig\tfkenv\tSwitch active KUBECONFIG file from ~/.kube/*.kubeconfig.")"
    "$(print -P "%F{141}󰒋 sys%f %F{240}│%f %B%F{15}fps      %f%b %F{240}│%f List running process\tfps\tList processes sorted by CPU. Press Shift-Delete to kill with SIGKILL.")"
    "$(print -P "%F{141}󰒋 sys%f %F{240}│%f %B%F{15}fport    %f%b %F{240}│%f Show listening ports & kill\tfport\tList open TCP/UDP ports with pstree. Press Shift-Delete to kill process.")"
    "$(print -P "%F{141}󰒋 sys%f %F{240}│%f %B%F{15}fenv     %f%b %F{240}│%f Browse environment variables\tfenv\tFuzzy search env vars. Previews multi-line colon paths.")"
  )

  local pick cmd
  pick=$(printf "%s\n" "${entries[@]}" |
    fzf --ansi \
        --prompt="fz> " \
        --delimiter=$'\t' \
        --with-nth=1 \
        --header="$(print -P "%F{244}Filter by typing:%f %F{208}git%f %F{240}•%f %F{75}az%f %F{240}•%f %F{114}k8s%f %F{240}•%f %F{141}sys%f")" \
        --preview='cmd=$(echo {2}); desc=$(echo {3});
                   printf "\033[1;36mCommand:\033[0m   %s\n\033[1;36mDetails:\033[0m   %s\n" "$cmd" "$desc"' \
        --preview-window=down:3:wrap \
        --height=50%) || return

  cmd=$(echo "$pick" | cut -f2)
  [[ -n "$cmd" ]] && eval "$cmd"
}

fz-widget() {
  zle -I
  fz
  zle reset-prompt
}
zle -N fz-widget
bindkey '\ez' fz-widget
