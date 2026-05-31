# Yugansh's Dotfiles 🛠️

Welcome to my dotfiles. This is basically the digital glue holding my setup together.

## 🏔️ The Foundation: CachyOS
I use **[CachyOS](https://cachyos.org/)** and most of the configs here are based on their great defaults. Big thanks to the CachyOS team for giving me such a fast and solid baseline. I just added some personal flair and likely a few bugs on top of their work.

## What's in here? 📦

*   **🐟 Fish (CachyOS flavor):** CachyOS gives a great start but I added my own overrides and aliases to fit my workflow.
*   **🖥️ Tmux:** I use Oh-My-Tmux with custom sysstat widgets and thin battery bars. It helps me see when my RAM is struggling.
*   **👻 Ghostty:** Terminal speed is everything.
*   **🐚 Bash/Zsh:** The classics for whenever I need them.
*   **⌨️ Alacritty:** My backup terminal.

## ⚠️ Security Note
I removed all my sensitive API keys like OpenAI from these files. If you fork this repo make sure to put your keys in a local file that git doesn't track.

## 🚀 Installation (The Easy Way)
This repo is built for [GNU Stow](https://www.gnu.org/software/stow/). I wrote a safe script to handle everything for you.

### 1. Clone the repo
\`\`\`bash
git clone https://github.com/yugansh25/Dotfile.git ~/.dotfiles
cd ~/.dotfiles
\`\`\`

### 2. Test it (Safety First)
Check exactly what will happen without touching your files.
\`\`\`bash
./install.sh --dry-run
\`\`\`

### 3. Install
Apply the symlinks. The script will automatically backup any existing configs it finds.
\`\`\`bash
./install.sh
\`\`\`

### 4. Undo (The Panic Button)
If you change your mind just run the restore command to put your original files back.
\`\`\`bash
./install.sh --restore
\`\`\`

## 🛠️ Manual Installation (The Stow Way)
You can also stow things one by one if you prefer. Just make sure you are in the dotfiles directory.
\`\`\`bash
stow alacritty
stow bash
stow fish
stow ghostty
stow tmux
stow vim
stow zsh
\`\`\`

## 📜 Credits
- **CachyOS Team** for the incredible baseline.
- **Gregory Pakosz** for the Oh-My-Tmux foundation.
