function bye --description 'Detach from tmux and close terminal'
    if set -q TMUX
        # -P: SIGHUP the parent shell (closes terminal)
        # Note: older tmux versions may not support -q. Removing to ensure compatibility.
        tmux detach-client -P
    else
        exit
    end
end
