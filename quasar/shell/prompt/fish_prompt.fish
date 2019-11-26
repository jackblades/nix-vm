function fish_prompt
    set -l status_copy $status
    set -l time_now (date +"%H:%M:%S")

    set -l cwd_dir_base (
        set -l dir (dirname $PWD)

        if test "$PWD" != "$HOME" -a "$dir" != /
            echo $dir | sed -E "s|$HOME||"
        end
    )

    set -l branch_name
    if set branch_name (git_branch_name)
        set -l color 222 9f3
        set -l repo_status
        set -l branch_ref ➦

        if git symbolic-ref HEAD ^/dev/null >/dev/null
            set branch_ref 
        end

        if git_is_touched
            if git_is_staged
                set repo_status S

            else if git_is_touched
                set color 9f3 222
            end
        end

        if git_is_dirty
            set repo_status $repo_status +
        end

        if git_is_stashed
            set repo_status $repo_status -
        end

        segment $color " $branch_ref $branch_name $repo_status "

        if test ! -z "$cwd_base"
            segment 9f3 222 "$cwd_base  "
        end
    else
        if test ! -z "$cwd_base"
            set -l color 222

            if test ! -z "$cwd_dir"
                set color 444
            end

            segment fff $color "  $cwd_base  "
        end
    end

    if test "$PWD" != "$HOME"
        segment fff 444 " "(basename $PWD)" "
    end

    set -l segment
    set -l segment_colors

    switch "$PWD"
        case "$HOME"\*
            set segment " ~$cwd_dir_base "
            set segment_colors 000 7d3

        case \*
            set segment " $cwd_dir_base " # →
            set segment_colors 000 blue
    end

    if test "$status_copy" -ne 0
        set segment_colors fff red
    end

    segment $segment_colors $segment
    segment 0f0 000 " $time_now "

    segment_close
end
