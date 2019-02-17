set -g theme_display_date no

function fish_user_key_bindings
    bind $argv \e\[7~ beginning-of-line
    bind $argv \e\[8~ end-of-line
end

