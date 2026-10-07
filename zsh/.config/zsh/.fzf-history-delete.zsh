# Shift+Delete in fzf Ctrl-R: drop selected history lines from HISTFILE
# and the current session. Stock fzf zsh bindings do not implement this.

_fzf_hist_strip_file() {
  emulate -L zsh
  local histfile=$1 cmdfile=$2
  [[ -f $histfile && -s $cmdfile ]] || return 0
  command perl -e '
    use strict;
    use warnings;
    my ($histfile, $cmdfile) = @ARGV;
    open my $cf, "<:raw", $cmdfile or exit 0;
    my %drop;
    while (<$cf>) {
      s/\r?\n\z//;
      $drop{$_} = 1 if length;
    }
    close $cf;
    exit 0 unless %drop;

    open my $in, "<:raw", $histfile or die $!;
    my $out = "";
    while (defined(my $line = <$in>)) {
      if ($line =~ /^: \d+:\d+;/) {
        my $rec = $line;
        while ($rec =~ /\\\n\z/ && defined(my $cont = <$in>)) {
          $rec .= $cont;
        }
        my ($cmd) = $rec =~ /^: \d+:\d+;(.*)\n\z/s;
        $cmd =~ s/\\\n/\n/g if defined $cmd;
        next if defined $cmd && $drop{$cmd};
        $out .= $rec;
      } else {
        my $cmd = $line;
        $cmd =~ s/\r?\n\z//;
        next if $drop{$cmd};
        $out .= $line;
      }
    }
    close $in;
    my $tmp = "$histfile.tmp.$$";
    open my $fh, ">:raw", $tmp or die $!;
    print $fh $out;
    close $fh;
    rename $tmp, $histfile or die $!;
  ' -- "$histfile" "$cmdfile"
}

_fzf_hist_delete_from_file() {
  emulate -L zsh
  local cmdfile=$1
  [[ -s $cmdfile ]] || return 0
  [[ -n $HISTFILE && -f $HISTFILE ]] || return 0
  builtin fc -W
  _fzf_hist_strip_file "$HISTFILE" "$cmdfile" || return
  builtin fc -p "$HISTFILE" "$HISTSIZE" "$SAVEHIST"
}

fzf-history-widget-with-delete() {
  emulate -L zsh
  local deletefile
  deletefile=$(command mktemp "${TMPDIR:-/tmp}/fzf-hist-del.XXXXXX") || {
    fzf-history-widget "$@"
    return
  }

  local FZF_CTRL_R_OPTS="${FZF_CTRL_R_OPTS-} --bind 'shift-delete:execute-silent(cat {+f2..} >> ${deletefile:q})+exclude-multi'"
  fzf-history-widget "$@"
  local ret=$?
  _fzf_hist_delete_from_file "$deletefile"
  command rm -f "$deletefile"
  return $ret
}

zle -N fzf-history-widget fzf-history-widget-with-delete
bindkey -M emacs '^R' fzf-history-widget
bindkey -M vicmd '^R' fzf-history-widget
bindkey -M viins '^R' fzf-history-widget
