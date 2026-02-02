# Aliases for fish shell
# Migrated from omarchy bash aliases

# File system - eza
if command -v eza &>/dev/null
    alias ls='eza -lh --group-directories-first --icons=auto'
    alias lsa='ls -a'
    alias lt='eza --tree --level=2 --long --icons --git'
    alias lta='lt -a'
end

# fzf with bat preview
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Tools
alias c='opencode'
alias d='docker'
alias r='rails'
alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'

# Compression
alias decompress='tar -xzf'

# ESP-IDF
alias get_idf='. $HOME/esp/esp-idf/export.fish'
