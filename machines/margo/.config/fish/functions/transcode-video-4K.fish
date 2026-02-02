# Transcode a video to a good-balance 4K that's great for sharing online
function transcode-video-4K
    set -l input $argv[1]
    set -l output (string replace -r '\.[^.]+$' '-optimized.mp4' $input)
    ffmpeg -i $input -c:v libx265 -preset slow -crf 24 -c:a aac -b:a 192k $output
end
