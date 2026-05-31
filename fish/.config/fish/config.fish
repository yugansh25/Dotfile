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
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/home/yugansh/development/flutter/bin"
starship init fish | source
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8

#if status is-interactive
#    and not set -q TMUX
#    # Check if ANY tmux session exists silently
#    if tmux has-session 2>/dev/null
#        # Attach to the most recently active session
#        exec tmux attach
#    else
#        # Spin up a brand new session
#        exec tmux
#    end
#end
