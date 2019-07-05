## -----------------------------------------------------------------------------
## Linux Scripts.
## Config functions
##
## @package ojullien\bash\sys
## @license MIT <https://github.com/ojullien/bash-sys/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## If exists, loads the named 'local.config.sh' configuration file instead of
## the default 'config.sh' file.
## -----------------------------------------------------------------------------

Config::load() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Config::load <app name>"
        return 1
    fi

    # Init
    local sAppFolder="${m_DIR_APP}/$1"
    local sLocalConfigFile="${sAppFolder}/local.config.sh"
    local sDefaultConfigFile="${sAppFolder}/config.sh"

    # Do the job
    if [[ ! -d "${sAppFolder}" ]]; then
        String::error "Folder app '${sAppFolder}' does not exist."
        return 1
    fi
    if [[ ! -f "${sDefaultConfigFile}" ]]; then
        String::error "Default app config file '${sDefaultConfigFile}' does not exist."
        return 1
    fi
    if [[ -f "${sLocalConfigFile}" ]]; then
        # shellcheck source=src/lib.sh
        . "${sLocalConfigFile}"
    else
        # shellcheck source=src/lib.sh
        . "${sDefaultConfigFile}"
    fi

    return 0
}
