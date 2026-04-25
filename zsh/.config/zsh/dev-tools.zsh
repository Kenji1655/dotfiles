# Development toolchain environment
export NVM_DIR="$HOME/.nvm"
[[ -s /usr/share/nvm/init-nvm.sh ]] && source /usr/share/nvm/init-nvm.sh

export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
[[ -d "$ANDROID_HOME/platform-tools" ]] && export PATH="$ANDROID_HOME/platform-tools:$PATH"
[[ -d "$ANDROID_HOME/emulator" ]] && export PATH="$ANDROID_HOME/emulator:$PATH"
[[ -d "$ANDROID_HOME/cmdline-tools/latest/bin" ]] && export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
[[ -d "$ANDROID_HOME/cmdline-tools/bin" ]] && export PATH="$ANDROID_HOME/cmdline-tools/bin:$PATH"
command -v chromium >/dev/null 2>&1 && export CHROME_EXECUTABLE="$(command -v chromium)"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"

command -v mise >/dev/null 2>&1 && eval "$(mise activate zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh)"
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"
