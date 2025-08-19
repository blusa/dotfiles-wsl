#!/usr/bin/env bash
set -e

sudo apt update

# --- Core CLI packages ---
apt_packages=(
  zsh
  git
  curl
  fzf
  zoxide
  starship
  eza
  bat
  command-not-found
  nodejs
  npm
  gh
  lazygit
  neovim
  python3
  python3-pip
  stow
  tmux
  build-essential
  pkg-config
  libssl-dev
)

echo "📦 Installing APT packages..."
sudo apt install -y "${apt_packages[@]}"
sudo update-command-not-found || true

# --- Set zsh as default shell ---
if [ "$SHELL" != "$(command -v zsh)" ]; then
  echo "🔄 Changing default shell to zsh..."
  chsh -s "$(command -v zsh)"
fi

	
# --- yazi (needs Rust/cargo) ---
if ! command -v yazi &>/dev/null; then
  # deps commonly needed for building Rust crates
  sudo apt install -y build-essential pkg-config libssl-dev curl

  if ! command -v cargo &>/dev/null; then
    echo "📦 Installing Rust (rustup)..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    # load cargo into this shell
    source "$HOME/.cargo/env"
  fi

  echo "📦 Installing yazi via cargo..."
  cargo install --locked yazi-fm yazi-cli
fi

# --- uv (Python package manager by Astral) ---
if ! command -v uv &>/dev/null; then
  echo "📦 Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  # add ~/.local/bin to PATH for this session (installer puts uv there)
  export PATH="$HOME/.local/bin:$PATH"
fi

# --- gemini-cli ---
if ! command -v gemini &>/dev/null; then
  # Needs Node >= 18
  if ! node -v >/dev/null 2>&1 || [ "$(node -p 'process.versions.node.split(".")[0]')" -lt 18 ]; then
    echo "⚠️ Node 18+ required. Install a newer Node first."
  fi
  echo "📦 Installing Google Gemini CLI..."
  npm install -g @google/gemini-cli
fi

# --- SST OpenCode ---
if ! command -v opencode &>/dev/null; then
  echo "📦 Installing OpenCode..."
  npm install -g opencode-ai
fi

# --- Claude Code CLI ---
if ! command -v claude &>/dev/null; then
  echo "📦 Installing Claude Code CLI..."

  # Option A: Native Installer (Beta, recommended if available)
  curl -fsSL https://claude.ai/install.sh | bash || true

  # Option B: Fallback to npm install if native fails
  if ! command -v claude &>/dev/null; then
    echo "⟳ Native install failed—using npm..."
    npm install -g @anthropic-ai/claude-code
  fi
fi

# Optional: verify installation
if command -v claude &>/dev/null; then
  echo "✅ Claude Code installed. Run 'claude' to authenticate and start coding."
else
  echo "❌ Failed to install Claude Code; check your PATH or install method."
fi


# Cleanup
sudo apt autoremove -y
sudo apt clean

echo "✅ All CLI tools installed!"

echo "✅ Installation complete. Restart your terminal for zsh to load."

