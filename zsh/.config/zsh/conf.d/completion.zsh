# Completion system

autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
zinit cdreplay -q

# CLI completions
if (( $+commands[oc] )); then
  source <(oc completion zsh)
fi

if (( $+commands[kubectl] )); then
  source <(kubectl completion zsh)
  compdef _kubectl k
fi
