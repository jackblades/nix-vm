function fish_right_prompt
    set -l status_copy $status
    set -l status_color 0f6

    if test "$status_copy" -ne 0
        set status_color f00
    end

    if test "$CMD_DURATION" -gt 100
        set -l duration_copy $CMD_DURATION
        set -l duration (echo $CMD_DURATION | humanize_duration)
        printf (set_color $status_color)" $duration  "(set_color normal)
    end

    printf (set_color -b $status_color)" "(set_color normal)
end

function humanize_duration -d "Humanize a time interval for display"
    command awk '
        function hmTime(time,   stamp) {
            split("h:m:s:ms", units, ":")

            for (i = 2; i >= -1; i--) {
                if (t = int( i < 0 ? time % 1000 : time / (60 ^ i * 1000) % 60 )) {
                    stamp = stamp t units[sqrt((i - 2) ^ 2) + 1] " "
                }
            }
            if (stamp ~ /^ *$/) {
                return "0ms"
            }
            return substr(stamp, 1, length(stamp) - 1)
        }
        { 
            print hmTime($0) 
        }
    '
end
