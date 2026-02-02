# Compress a directory to tar.gz
function compress
    set -l dir (string trim -r -c '/' $argv[1])
    tar -czf "$dir.tar.gz" "$dir"
end
