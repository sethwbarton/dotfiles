#!/usr/bin/env bash
set -euo pipefail

OS="$(uname -s)"

info() { printf '\033[1;34m==> %s\033[0m\n' "$1"; }
warn() { printf '\033[1;33m==> %s\033[0m\n' "$1"; }
error() { printf '\033[1;31m==> %s\033[0m\n' "$1"; }

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# ---------- prerequisites ----------

install_prerequisites() {
    case "$OS" in
        Darwin)
            if ! command -v brew &>/dev/null; then
                error "Homebrew is not installed."
                echo "  Install it first: https://brew.sh"
                echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
                exit 1
            fi

            if ! command -v stow &>/dev/null; then
                info "Installing GNU Stow..."
                brew install stow
            fi
            ;;
        Linux)
            if ! command -v stow &>/dev/null; then
                info "Installing GNU Stow..."
                if command -v pacman &>/dev/null; then
                    sudo pacman -S --noconfirm stow
                elif command -v apt-get &>/dev/null; then
                    sudo apt-get install -y stow
                else
                    error "Could not detect package manager. Install GNU Stow manually."
                    exit 1
                fi
            fi
            ;;
        *)
            error "Unsupported OS: $OS"
            exit 1
            ;;
    esac
}

# ---------- fonts ----------

install_fonts() {
    case "$OS" in
        Darwin)
            if brew list --cask font-jetbrains-mono-nerd-font &>/dev/null 2>&1; then
                info "JetBrainsMono Nerd Font already installed."
            else
                info "Installing JetBrainsMono Nerd Font..."
                brew install --cask font-jetbrains-mono-nerd-font
            fi
            ;;
        Linux)
            if fc-list | grep -qi "JetBrainsMono Nerd Font"; then
                info "JetBrainsMono Nerd Font already installed."
            else
                warn "JetBrainsMono Nerd Font not found."
                echo "  On Omarchy it should be pre-installed. Otherwise install it manually:"
                echo "  https://www.nerdfonts.com/font-downloads"
            fi
            ;;
    esac
}

# ---------- stow ----------

link_dotfiles() {
    info "Linking dotfiles with GNU Stow..."

    cd "$DOTFILES_DIR"

    for package in nvim alacritty; do
        if [ -d "$package" ]; then
            info "  Stowing $package..."
            stow --restow "$package"
        fi
    done
}

# ---------- main ----------

echo ""
info "Setting up dotfiles on $OS..."
echo ""

install_prerequisites
install_fonts
link_dotfiles

echo ""
info "Done! You may need to:"
case "$OS" in
    Darwin)
        echo "  - Set your terminal font to 'JetBrainsMono Nerd Font' in Alacritty preferences"
        echo "  - Restart Alacritty to pick up the new config"
        ;;
    Linux)
        echo "  - Restart Alacritty to pick up any config changes"
        ;;
esac
echo ""
