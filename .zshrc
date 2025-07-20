# Enable colored output for ls
alias ls='ls -G'
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Custom prompt with colored brackets based on last command status
setopt PROMPT_SUBST
PROMPT='%(?,%F{green}[%f,%F{red}[%f)%n@%F{240}%m%f %1~ %(?,%F{green}]%f,%F{red}]%f)$ '