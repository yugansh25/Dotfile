# Yugansh's Dotfiles 🛠️

My personal configuration files, optimized for speed, aesthetics, and sanity.

These configurations are heavily derived from the excellent defaults provided by [CachyOS](https://cachyos.org/). I've customized them to fit my personal workflow, adding custom widgets, specific keybindings, and a unified theme.

---

## ✨ Features

*   **🐟 Fish:** CachyOS flavor with smart overrides. Now with `bye` for smooth tmux exits.
*   **🖥️ Tmux:** Powered by [Oh-My-Tmux](https://github.com/gpakosz/.tmux), featuring custom sysstat widgets and minimal battery indicators.
*   **👻 Ghostty:** My primary terminal emulator, configured for maximum speed.
*   **📝 Neovim / Vim:** Fast, functional editor configurations.
*   **🐚 Bash & Zsh:** The classics, kept around as reliable fallbacks.
*   **🛡️ Hardened:** Automatic permission management for sensitive configs (secrets.fish).
*   **🚀 Dynamic:** Automatic package detection. Add a folder, run the script, profit.

---

## 🚀 Installation

This repository uses [GNU Stow](https://www.gnu.org/software/stow/) to manage symlinks cleanly. I have included an automated installer script.

### 1. Clone the Repository

```bash
git clone https://github.com/yugansh25/Dotfile.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Dry Run (Recommended)

Simulate the installation without making any changes to your filesystem:

```bash
./install.sh --dry-run
```

### 3. Install

The script will automatically detect existing configurations and back them up as `.bak` files in place before creating the new symlinks.

```bash
./install.sh
```

---

## 🔄 Restoration

If you need to revert to your original configurations, use the built-in restore function. This removes the symlinks and moves your `.bak` files back into place.

```bash
./install.sh --restore
```

---

## 🛡️ Security Note

I keep my sensitive API keys (like OpenAI) out of this public repository. The installer automatically enforces `600` permissions on `~/.config/fish/conf.d/secrets.fish` for your safety.

---

## 📜 Credits and Inspirations

*   The **CachyOS Team** for the incredible baseline and OS.
*   **Gregory Pakosz** for the robust Oh-My-Tmux framework.
*   **Derek Taylor (DistroTube)** for shell inspiration and snippets.
*   **Alexey Samoshkin** for `tmux-plugin-sysstat`.
