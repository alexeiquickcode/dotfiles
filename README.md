# 🛠 dotfiles

This repo is a collection of all my dotfiles, managed by GNU Stow for easy symlink management

## 📂 Structure

Inside ~/dotfiles (Actual Files)

```bash
~/dotfiles/
│── ghostty/
│   └── .config/
│       └── ghostty/
│           └── config    <-- 🔹 Real file
│── nvim/
│   └── .config/
│       └── nvim/
│           ├── init.lua  <-- 🔹 Real file
│           └── lua/
│               └── plugins.lua

Inside ~/.config/ (Symlinks)

~/.config/
├── ghostty/
│   └── config           ->  ~/dotfiles/ghostty/.config/ghostty/config  (🔗 Symlink)
├── nvim/
│   ├── init.lua         ->  ~/dotfiles/nvim/.config/nvim/init.lua  (🔗 Symlink)
│   └── lua/
│       └── plugins.lua  ->  ~/dotfiles/nvim/.config/nvim/lua/plugins.lua  (🔗 Symlink)
```

## 🚀 Add or remove dotfiles 

Move the configuration file(s) into the `dotfiles` repository:

Example for **Ghostty**:
```sh
mkdir -p ~/dotfiles/ghostty/.config/ghostty
mv ~/.config/ghostty/config ~/dotfiles/ghostty/.config/ghostty/
stow -v ghostty
```
To remove a dotfiles `stow -D -v ghostty`

## 🖥️ Install all dotfiles 

```sh
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow -v */
```

## Install Scripts

```bash
curl -sSL https://raw.githubusercontent.com/alexeiquickcode/dotfiles/main/scripts/fresh-install/archlinux.sh | bash
```

## Misc

### 🔑 Github / Bitbucket SSH Keys Setup

```bash
cd ~/.ssh
ssh-keygen -t ed25519 -b 4096 -C "alexei.quick@gmail.com" -f github-personal
eval "$(ssh-agent -s)" # Check if the SSH agent is running
ssh-add ~/.ssh/github-personal
ssh -T git@github.com

ssh-keygen -t ed25519 -b 4096 -C "x@x.com.au" -f bitbucket-x
ssh-add ~/.ssh/bitbucket-x
ssh -T git@bitbucket.org
```
