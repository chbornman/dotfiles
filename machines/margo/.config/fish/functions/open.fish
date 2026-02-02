# Open files with default application
function open
    xdg-open $argv >/dev/null 2>&1 &
    disown
end
