# Transcode a video to a good-balance 1080p that's great for sharing online
function transcode-video-1080p
    set -l input $argv[1]
    set -l output (string replace -r '\.[^.]+$' '-1080p.mp4' $input)
    ffmpeg -i $input -vf scale=1920:1080 -c:v libx264 -preset fast -crf 23 -c:a copy $output
end
