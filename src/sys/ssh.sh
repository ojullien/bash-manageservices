## -----------------------------------------------------------------------------
## Linux Scripts.
## SSH functions
##
## @package ojullien\bash\sys
## @license MIT <https://github.com/ojullien/bash-sys/blob/master/LICENSE>
## -----------------------------------------------------------------------------

SSH::error() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
  return 0
}

SSH::loadAgentEnv() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        SSH::error "Usage: SSH::loadAgentEnv <ssh environment file path>"
        return 1
    fi

    # Init
    local sPath="$1"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sPath}" ]]; then
        # shellcheck source=/dev/null
        . "${sPath}" >| /dev/null ;
        iReturn=$?
    fi

    return ${iReturn}
}

SSH::startAgent() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        SSH::error "Usage: SSH::startAgent <ssh environment file path>"
        return 1
    fi

    # Init
    local sPath="$1"
    local -i iReturn=1

    # Do the job in a subshell
    (umask 077; ssh-agent >| "${sPath}")
    iReturn=$?
    # shellcheck source=/dev/null
    . "${sPath}" >| /dev/null ;

    return ${iReturn}
}

SSH::addKeyToAgent() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        SSH::error "Usage: SSH::addKeyToAgent <ssh environment file path> <key file>"
        return 1
    fi

    # Init
    local sSSHEnv="$1" sKeyFile="$2"
    local -i iReturn=1 iRunState=2

    # Do the job

    # iRunState: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
    iRunState=$(ssh-add -l >| /dev/null 2>&1; echo $?)

    if [[ -z "$SSH_AUTH_SOCK" ]] || (( 2==iRunState )); then
        SSH::startAgent "${sSSHEnv}"
        ssh-add "${sKeyFile}"
        iReturn=$?
    elif [ -n "$SSH_AUTH_SOCK" ] && (( 1==iRunState )); then
        ssh-add "${sKeyFile}"
        iReturn=$?
    fi

    return ${iReturn}
}
