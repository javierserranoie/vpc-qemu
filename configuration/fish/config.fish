if status is-login
	if test "$XDG_VTNR" = "1"
		exec sway
	end
end

if status is-interactive
    
# Disable fish greeting
set -U fish_greeting ""

direnv hook fish | source
zoxide init fish | source
fzf --fish | source

set term_config_dir ~/.config/term
test -f $term_config_dir/aliases.fish; and source $term_config_dir/aliases.fish
test -f $term_config_dir/functions.fish; and source $term_config_dir/functions.fish
test -f $term_config_dir/hooks.fish; and source $term_config_dir/hooks.fish
test -f $term_config_dir/paths.fish; and source $term_config_dir/paths.fish

end

