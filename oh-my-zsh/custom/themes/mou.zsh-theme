precmd() {
    echo ''
}

# preexec() {
#     print -nP "%{$reset_color%}"
# }


local ret_status="%(?:%# :%{$fg_bold[red]%}%# )"
local jobs="%(1j.%{$fg_bold[white]%}%j%{$reset_color%} .)"
PROMPT='%~ $(git_prompt_info)
${jobs}${ret_status}%{$reset_color%}'
# TODO: Print execution time

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
