# Enable colored output for ls
alias ls='ls -G'
alias vim='nvim'

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Custom prompt with colored brackets based on last command status
setopt PROMPT_SUBST
PROMPT='%(?,%F{green}[%f,%F{red}[%f)%n@%F{240}%m%f %1~ %(?,%F{green}]%f,%F{red}]%f)$ '

# Enable smart autocompletion
autoload -Uz compinit && compinit
# Enable case insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Homebrew overrides
#
# We want to override the system python3, which is 3.9 and has some issues with libressl vs openssl, use 3.13+ from homebrew instead.
export PATH="$(brew --prefix python@3)/libexec/bin:$PATH"

