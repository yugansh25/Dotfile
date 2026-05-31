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
This repo is built for [GNU Stow](https://www.gnu.org/software/stow/). 

If you want to test things out without changing your files run the dry run command.
```bash
./install.sh --dry-run
```

To install everything follow these steps.
1. Clone the repo: \`git clone https://github.com/yugansh25/Dotfile.git ~/.dotfiles\`
2. Enter the directory: \`cd ~/.dotfiles\`
3. Run the installer: \`./install.sh\`

The installer is safe to use. It asks for your permission and creates a backup of your current files before it does anything.

If you want to test the restore process run this.
```bash
./install.sh --restore --dry-run
```

To undo everything and go back to your original files use the restore flag.
```bash
./install.sh --restore
```

## 🛠️ Manual Installation (The Stow Way)
You can also stow things one by one if you prefer. Just make sure you are in the dotfiles directory.
```bash
stow alacritty
stow bash
stow fish
stow ghostty
stow tmux
stow vim
stow zsh
```

