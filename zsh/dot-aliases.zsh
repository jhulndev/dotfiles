
alias reload-zsh="source ~/.zshrc"

alias cat=bat
alias cl=clear
alias pwdy="echo $(pwd) | pbcopy"

# Eza (better ls) 
alias l="eza --long --icons --smart-group --time-style=relative --git"
alias lt="l --tree" 
alias l2="lt --level=2"
alias l3="lt --level=3"
alias l4="lt --level=4"
alias l5="lt --level=5"

# Zoxide (better cd) 
alias cd="z"
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.."

# thefuck alias
eval $(thefuck --alias)
eval $(thefuck --alias fk)

# Neovim
alias v=nvim
alias vim=nvim

# Tmux
alias t=tmux

# Pre Commit
alias pc="pre-commit run --all-files"

