# Login-shell environment setup shared with zsh interactive fallback.
[[ -n ${_LEON_ZPROFILE_SOURCED:-} ]] && return
_LEON_ZPROFILE_SOURCED=1
export ZSH_PROFILE_LOADED=1

# Keep CLI tools in the real home directory, even when shells are launched
# from sandboxed apps such as the VS Code snap.
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_DATA_HOME="$HOME/.local/share"
export UV_TOOL_BIN_DIR="$XDG_BIN_HOME"

export ANDROID_HOME="$HOME/Android/Sdk"
export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"
export VCPKG_ROOT="/opt/vcpkg"
export NVM_DIR="$HOME/.nvm"

# Keep Homebrew at the end so system tools win by default.
HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
typeset -U path PATH
path=("${path[@]:#$HOMEBREW_PREFIX/bin}")
path=("${path[@]:#$HOMEBREW_PREFIX/sbin}")
path=(
	/usr/local/sbin
	/usr/local/bin
	"$JAVA_HOME/bin"
	/usr/sbin
	/usr/bin
	/sbin
	/bin
	"$XDG_BIN_HOME"
	/opt/flutter/bin
	"${path[@]}"
	"$ANDROID_HOME/tools"
	"$ANDROID_HOME/platform-tools"
	"$HOME/.pub-cache/bin"
	/snap/bin
	"$HOME/.opencode/bin"
)

if [[ -d "$HOME/bin" ]]; then
	path=("$HOME/bin" "${path[@]}")
fi

if [[ -x "$HOMEBREW_PREFIX/bin/brew" ]]; then
	path+=("$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin")
fi

export PATH

[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
[[ -f "$HOME/.local/share/swiftly/env.sh" ]] && source "$HOME/.local/share/swiftly/env.sh"

# Make login and tool shells resolve the same Node.js version as interactive zsh.
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
