# Transcode any image to JPG image that's great for shrinking wallpapers
function img2jpg
    set -l img $argv[1]
    set -l extra $argv[2..-1]
    set -l output (string replace -r '\.[^.]+$' '-optimized.jpg' $img)
    magick "$img" $extra -quality 95 -strip $output
end
