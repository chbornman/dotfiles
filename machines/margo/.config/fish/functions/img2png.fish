# Transcode any image to compressed-but-lossless PNG
function img2png
    set -l img $argv[1]
    set -l extra $argv[2..-1]
    set -l output (string replace -r '\.[^.]+$' '-optimized.png' $img)
    magick "$img" $extra -strip \
        -define png:compression-filter=5 \
        -define png:compression-level=9 \
        -define png:compression-strategy=1 \
        -define png:exclude-chunk=all \
        $output
end
