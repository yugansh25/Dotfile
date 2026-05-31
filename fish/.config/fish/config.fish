# # .-------------------------------------------------------------------------.
# # |  __   __ _   _  ____    _    _   _ ____  _   _     _____  ____          |
# # |  \ \ / /| | | |/ ___|  / \  | \ | / ___|| | | |   | ____||  _ \         |
# # |   \ V / | | | | |  _  / _ \ |  \| \___ \| |_| |   |  _|  | | | |        |
# # |    | |  | |_| | |_| |/ ___ \| |\  |___) |  _  |   | |___ | |_| |        |
# # |    |_|   \___/ \____/_/   \_\_| \_|____/|_| |_|   |_____||____/         |
# # |                                                                         |
# # |  The "I probably broke something" Edition. Proceed with caution.        |
# # '-------------------------------------------------------------------------'
# #
# # My personal customizations for CachyOS.
# # Optimized for speed, aesthetics, and minimal sanity.
# #
source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
# function fish_greeting
#    # smth smth
#end

fish_vi_key_bindings
if test -d $HOME/.local/bin; fish_add_path $HOME/.local/bin; end
if test -d $HOME/development/flutter/bin; fish_add_path $HOME/development/flutter/bin; end
if command -v starship >/dev/null; starship init fish | source; end
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

# Auto-tmux logic (Allowlist approach)
if status is-interactive
    and not set -q TMUX
    
    # Standalone terminal names (for env vars and process names)
    set -l allowed "alacritty" "kitty" "iterm" "apple_terminal" "gnome-terminal" "konsole" "wezterm" "foot" "xfce4-terminal" "st" "ghostty"
    
    # Detect environment variables
    set -l term_low (string lower "$TERM")
    set -l prog_low (string lower "$TERM_PROGRAM")
    
    # Detect parent process name (handles cases where env vars are missing/generic)
    # Using 'ps' to find the command name of the parent of the current fish process
    set -l p_comm (ps -p (ps -p $fish_pid -o ppid= | xargs) -o comm= | string lower | string trim)

    if contains $term_low $allowed
        or contains $prog_low $allowed
        or contains $p_comm $allowed
        and command -v tmux >/dev/null
        
        # Check if ANY tmux session exists
        if tmux has-session 2>/dev/null
            # Attach to the most recently active session
            exec tmux attach-session -t (tmux list-sessions -F '#S' | head -n1)
        else
            # Spin up a brand new session
            exec tmux
        end
    end
end
