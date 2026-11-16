# History
HISTSIZE=100000
HISTFILE=~/.zsh_history
SAVEHIST=10000000
HISTDUP=erase

# Word boundaries
WORDCHARS='*?_[]~&;!#$%^(){}<>'

# Sensible Zsh settings
setopt ALWAYS_TO_END        # Full completions move cursor to the end
setopt AUTO_CD              # `dirname` is equivalent to `cd dirname`
setopt AUTO_PARAM_SLASH     # If completed parameter is a directory, add a trailing slash
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt HIST_REDUCE_BLANKS     # Strip superfluous blanks from history entries
setopt HIST_VERIFY            # Edit history-expanded line before executing
setopt INTERACTIVE_COMMENTS
setopt CORRECT              # Correct typos
setopt PATH_DIRS            # Perform path search even on command names with slashes
setopt COMPLETE_ALIASES
