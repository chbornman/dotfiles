# Transcode any image to JPG image that's great for sharing online without being too big
function img2jpg-small
    set -l img $argv[1]
    set -l extra $argv[2..-1]
    set -l output (string replace -r '\.[^.]+$' '-optimized.jpg' $img)
    magick "$img" $extra -resize '1080x>' -quality 95 -strip $output
end
