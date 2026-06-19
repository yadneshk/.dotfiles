#!/usr/bin/zsh

export CLAUDE_CODE_USE_VERTEX=1
export CLOUD_ML_REGION=global
export ANTHROPIC_VERTEX_PROJECT_ID=itpc-gcp-hcm-pe-eng-claude

alias azsre-shared-cluster-login="oc login https://api.vbj6calm.eastus.aroapp.io:6443/ -u kubeadmin -p 9HTmP-ypPXn-5ccXP-PQnow"
alias azcanary="az account set --subscription 60bf318d-6914-4105-a3b5-d0d2c10388c8"
alias azsre="az account set --subscription fe16a035-e540-4ab7-80d9-373fa9a3d6ae"
alias azhcp="az account set --subscription 1d3378d3-5a3f-4712-85a1-2485495dfc4b"
alias azhcprp="az account set --subscription 5299e6b7-b23b-46c8-8277-dc1147807117"
alias azint="az account set --subscription 64f0619f-ebc2-4156-9d91-c4c781de7e54"
alias otp="oathtool --base32 --totp DFJY5NTP2I7T4DAG5CHATWAU2F4VOADI |  xclip -selection clipboard"
