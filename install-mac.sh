#!/usr/bin/env bash

##### Change Mac name
# Display name
sudo scutil --set HostName <name>
# Network identity
sudo scutil --set LocalHostName <name>
sudo scutil --set HostName <name>

##### Set up dotfiles #####
git clone --separate-git-dir=$HOME/.dotfiles.git https://github.com/allpan3/dotfiles.git dotfiles-tmp
rsync --recursive --verbose dotfiles-tmp/ $HOME/
rm -rf dotfiles-tmp
git checkout nonroot
git config status.showUntrackedFiles no

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# macOS ships with zsh. Enable brew in zsh and install /opt/homebrew/bin/bash
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install bash

# Modify /etc/shells to add bash (sudo)
# Change default shell to bash
chsh -s /opt/homebrew/bin/bash

#!! Open a new shell

# Brew CLI utils
brew install bash-completion@2 tree
brew install tree-sitter-cli ripgrep nvim
brew install fd fzf git-delta lazygit dust bat
brew install starship

# Python dev
brew install uv
uv python install 3.14 --default

# Rust dev & utils
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# Install cargo install-update command
cargo install cargo-update


# Fonts
brew install --cask font-meslo-lg-nerd-font
brew install --cask font-jetbrains-mono-nerd-font

# gnu tools
brew install coreutils make grep findutils gnu-sed gawk

# Link selected GNU tools into ~/.local/bin
gnu_link_bins=(
  make
  readlink
  realpath
  timeout
  sed
  awk
  grep
  find
)

mkdir -p "$HOME/.local/bin"

for bin in "${gnu_link_bins[@]}"; do
  for dir in \
    "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin" \
    "$HOMEBREW_PREFIX/opt/make/libexec/gnubin" \
    "$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin" \
    "$HOMEBREW_PREFIX/opt/gawk/libexec/gnubin" \
    "$HOMEBREW_PREFIX/opt/grep/libexec/gnubin" \
    "$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin"
  do
    if [[ -x "$dir/$bin" ]]; then
      ln -sfn "$dir/$bin" "$HOME/.local/bin/$bin"
      break
    fi
  done
done


# C dev
brew install cmake
brew install llvm bear
# Only link clang-tidy to ~/.local/bin, since other tools are shipped with macOS
ln -sf $(brew --prefix llvm)/bin/clang-tidy ~/.local/bin/clang-tidy

## Latex
brew install --cask basictex
sudo tlmgr update --self --all
sudo tlmgr install collection-latexrecommended collection-latexextra collection-fontsrecommended collection-mathscience

## Hardware design
brew install verilator surfer


## Other useful tools
# pdftotext
brew install poppler
brew install ffmpeg
# Markdown renderer
brew install glow
