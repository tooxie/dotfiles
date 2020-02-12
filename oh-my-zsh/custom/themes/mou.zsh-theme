precmd() {
    echo ''
}

okta_profile() {
    # Get everything after the '=' of the `aws_okta_profile` config in the credentials file
    AWS_OKTA_PROFILE=${$(cat ~/.aws/credentials | grep aws_okta_profile)##*=}
    # Check if the profile name contains the string 'sandbox'
    PROFILE_IS_SANDBOX=`echo $AWS_OKTA_PROFILE | grep sandbox`
    if [ -z "$PROFILE_IS_SANDBOX" ]; then
        # If the variable is empty (no 'sandbox' in the name)
        # output the profile name in red
        echo "%{$fg_bold[red]%}$AWS_OKTA_PROFILE%{$reset_color%}"
    else
        # Otherwise simply output the profile name in white
        echo $AWS_OKTA_PROFILE
    fi
}

local ret_status="%(?:%# :%{$fg_bold[red]%}%# )"
local jobs="%(1j.%{$fg_bold[white]%}%j%{$reset_color%} .)"
PROMPT='%~ $(git_prompt_info)
${jobs}${ret_status}%{$reset_color%}'
# TODO: Print execution time

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
