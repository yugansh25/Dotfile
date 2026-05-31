#!/usr/bin/env bash

# .-------------------------------------------------------------------------.
# |  Yugansh's Dotfiles Installer                                           |
# |  Uses GNU Stow to safely symlink configurations to your home directory. |
# '-------------------------------------------------------------------------'

set -e

# Colors for better visibility
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Ensure we are in the repository root
cd "$(dirname "$0")"

# ASCII Header
echo -e "${CYAN}"
echo " .-------------------------------------------------------------------------."
echo " |  __   __ _   _  ____    _    _   _ ____  _   _     _____  ____          |"
echo " |  \\ \\ / /| | | |/ ___|  / \\  | \\ | / ___|| | | |   | ____||  _ \\         |"
echo " |   \\ V / | | | | |  _  / _ \\ |  \\| \\___ \\| |_| |   |  _|  | | | |        |"
echo " |    | |  | |_| | |_| |/ ___ \\| |\\  |___) |  _  |   | |___ | |_| |        |"
echo " |    |_|   \\___/ \\____/_/   \\_\\_| \\_|____/|_| |_|   |_____||____/         |"
echo " |                                                                         |"
echo " |  The \"I probably broke something\" Edition. Proceed with caution.        |"
echo " '-------------------------------------------------------------------------'"
echo -e "${NC}"

show_help() {
    echo -e "${YELLOW}Usage:${NC} ./install.sh [options]"
    echo ""
    echo -e "${GREEN}Options:${NC}"
    echo -e "  ${CYAN}-d, --dry-run${NC}    Simulation mode. For those with trust issues (rightfully so)."
    echo "                   Shows exactly what would happen without touching your disk."
    echo ""
    echo -e "  ${CYAN}-r, --restore${NC}    The \"Panic Button\". Reverts your config to the last known"
    echo "                   stable backup. Digital duct tape not included."
    echo ""
    echo -e "  ${CYAN}-h, --help${NC}       Shows this masterpiece of a help screen."
    echo ""
    echo -e "${GREEN}Examples:${NC}"
    echo "  ./install.sh -d          # Safe testing (Highly recommended for the faint of heart)"
    echo "  ./install.sh             # The full send. Installs everything."
    echo "  ./install.sh -r -d       # Simulates a restoration. See the ghosts of configs past."
    echo "  ./install.sh -r          # Actually restores your original files. Safety first!"
    echo ""
    echo -e "${YELLOW}Note:${NC} This script uses GNU Stow. If you don't have it, I'll try to install it"
    echo "      using pacman (CachyOS/Arch). If you're on something else... good luck!"
}

# --- Dependency Check & Arch Guard ---
check_stow() {
    if ! command -v stow &> /dev/null; then
        echo -e "${YELLOW}GNU Stow not found. Checking if you are an Arch user...${NC}"
        
        # Guard: Check if it is Arch or Arch-based (like CachyOS)
        if [ -f /etc/arch-release ]; then
            echo -e "${CYAN}Arch detected. But where's GNU Stow?${NC}"
            echo -e "I can handle the dirty work for you using this command:"
            echo -e "  ${GREEN}sudo pacman -S stow --noconfirm${NC}"
            echo ""
            read -p "Should I proceed with the installation? [y/N] " stow_response
            if [[ "$stow_response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
                sudo pacman -S stow --noconfirm
                echo -e "${GREEN}Stow installed! Now back to your regularly scheduled programming (neofetching).${NC}"
            else
                echo -e "${RED}Installation skipped. Please install 'stow' manually to continue.${NC}"
                exit 1
            fi
        else
            echo -e "${RED}GNU Stow missing and... wait, you're not on Arch? GNU Stow not found. I only automate the 'Arch way.' You're on a different path traveler. Install 'stow' manually and we can continue the journey.${NC}"
            exit 1
        fi
    fi
}

DRY_RUN=false
RESTORE=false

# Parse flags independently
for arg in "$@"; do
    case $arg in
        --dry-run|-d) DRY_RUN=true ;;
        --restore|-r) RESTORE=true ;;
        --help|-h) show_help; exit 0 ;;
    esac
done

# Run dependency check only for actual operations
if [ "$DRY_RUN" = false ]; then
    check_stow
fi

if [ "$DRY_RUN" = true ]; then
    MODE_PREFIX="[DRY-RUN] "
    if [ "$RESTORE" = true ]; then
        echo -e "${BLUE}>>> DRY RUN RESTORE MODE ENABLED <<<${NC}"
    else
        echo -e "${BLUE}>>> DRY RUN INSTALL MODE ENABLED <<<${NC}"
    fi
    echo -e "No files will be moved, and no links will be created.\n"
else
    MODE_PREFIX=""
fi

# Packages to stow
PACKAGES=("tmux" "fish" "ghostty" "alacritty" "bash" "vim" "zsh")

# --- Restore Mode ---
if [ "$RESTORE" = true ]; then
    LATEST_BACKUP=$(ls -td $HOME/dotfiles_old_* 2>/dev/null | head -n 1 || true)
    
    if [ -z "$LATEST_BACKUP" ]; then
        echo -e "${RED}Error: No backup directory (dotfiles_old_*) found in $HOME.${NC}"
        exit 1
    fi

    echo -e "${YELLOW}${MODE_PREFIX}Starting Dotfiles Restoration...${NC}"
    echo -e "Latest backup found: ${GREEN}$LATEST_BACKUP${NC}"
    echo "This will remove current symlinks and restore files from the backup."
    
    read -p "Do you want to proceed? [y/N] " response
    if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo -e "${RED}Restore cancelled.${NC}"
        exit 0
    fi

    for pkg in "${PACKAGES[@]}"; do
        echo -e "\n${BLUE}--- Package: $pkg ---${NC}"
        if [ "$DRY_RUN" = true ]; then
            echo -e "${YELLOW}[ACTION] Would REMOVE symlinks via GNU Stow (dry-run):${NC}"
            stow -t "$HOME" -nvD "$pkg" 2>&1 | grep "UNLINK" | sed 's/^/  /' || echo "  (Package was not stowed)"
        else
            echo -e "${YELLOW}[ACTION] Removing symlinks for $pkg...${NC}"
            stow -t "$HOME" -D "$pkg" || echo "  Note: $pkg was not stowed."
        fi
    done

    echo -e "\n${YELLOW}${MODE_PREFIX}Restoring files from backup...${NC}"
    if [ "$DRY_RUN" = true ]; then
        find "$LATEST_BACKUP" -type f -o -type l | while read -r file; do
            rel_path="${file#$LATEST_BACKUP/}"
            echo -e "  [DRY-RUN] Would move: $LATEST_BACKUP/$rel_path  -->  ~/$rel_path"
        done
        echo -e "\n${BLUE}>>> Dry run restore complete. No actual changes were made. <<<${NC}"
    else
        find "$LATEST_BACKUP" -type f -o -type l | while read -r file; do
            rel_path="${file#$LATEST_BACKUP/}"
            target="$HOME/$rel_path"
            echo "  Restoring ~/$rel_path"
            mkdir -p "$(dirname "$target")"
            mv "$file" "$target"
        done
        rmdir "$LATEST_BACKUP" 2>/dev/null || true
        echo -e "\n${GREEN}Restore complete!${NC}"
    fi
    exit 0
fi

# --- Install Mode ---
echo -e "${YELLOW}${MODE_PREFIX}Starting Dotfiles Installation...${NC}"
echo "This script will create symlinks from this repository to your home directory ($HOME)."
echo "It uses GNU Stow to manage the links."

read -p "Do you want to proceed? [y/N] " response
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "${RED}Installation cancelled.${NC}"
    exit 0
fi

BACKUP_DIR="$HOME/dotfiles_old_$(date +%Y%m%d_%H%M%S)"

stow_package() {
    local pkg=$1
    echo -e "\n${BLUE}--- Package: $pkg ---${NC}"
    
    local stow_output
    stow_output=$(stow -t "$HOME" -nv "$pkg" 2>&1 || true)
    
    if echo "$stow_output" | grep -q "existing target"; then
        local conflicts
        conflicts=$(echo "$stow_output" | grep "existing target" | sed -E 's/.*existing target ([^ ]+).*/\1/')

        if [ "$DRY_RUN" = true ]; then
            echo -e "${YELLOW}[ACTION] Would BACKUP existing files to avoid conflicts:${NC}"
            echo "$conflicts" | while read -r line; do
                echo -e "  - ~/$line  -->  $BACKUP_DIR/$line"
            done
        else
            echo -e "${YELLOW}[ACTION] Backing up existing files to $BACKUP_DIR...${NC}"
            mkdir -p "$BACKUP_DIR"
            echo "$conflicts" | while read -r line; do
                local target="$HOME/$line"
                if [ -e "$target" ] || [ -L "$target" ]; then
                    echo "  Moving ~/$line"
                    mkdir -p "$BACKUP_DIR/$(dirname "$line")"
                    mv "$target" "$BACKUP_DIR/$line"
                fi
            done
        fi
    fi

    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[ACTION] Would create the following SYMLINKS via GNU Stow:${NC}"
        echo "$stow_output" | grep -E "LINK|MKDIR" | sed 's/^/  /' || true
        if echo "$stow_output" | grep -q "conflicts"; then
            echo -e "  ${GREEN}(All conflicts above would be resolved and linked after backup)${NC}"
        fi
    else
        echo -e "${GREEN}[ACTION] Symlinking $pkg...${NC}"
        if ! stow -t "$HOME" "$pkg" 2>&1; then
             echo -e "${RED}Error stowing $pkg. You might need to check for manual conflicts.${NC}"
        else
             echo -e "${GREEN}✓ $pkg installed successfully!${NC}"
        fi
    fi
}

for pkg in "${PACKAGES[@]}"; do
    if [ -d "$pkg" ]; then
        stow_package "$pkg"
    fi
done

if [ "$DRY_RUN" = true ]; then
    echo -e "\n${BLUE}>>> Dry run install complete. No actual changes were made. <<<${NC}"
else
    echo -e "\n${GREEN}Installation complete!${NC}"
    [ -d "$BACKUP_DIR" ] && echo "Original files backed up in: $BACKUP_DIR"
fi
