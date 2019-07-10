#!/bin/bash
## -----------------------------------------------------------------------------
## Linux Scripts.
## Install the bash-manageservices project into the /opt/oju/bash directory.
##
## @package ojullien\bash\scripts
## @license MIT <https://github.com/ojullien/bash-manageservices/blob/master/LICENSE>
## -----------------------------------------------------------------------------
#set -o errexit
set -o nounset
set -o pipefail

## -----------------------------------------------------------------------------
## Current project directory, eg: /opt/Shell/scripts/
## -----------------------------------------------------------------------------
readonly m_DIR_REALPATH="$(realpath "$(dirname "$0")")"
# shellcheck source=/dev/null
. "${m_DIR_REALPATH}/config.sh"
# shellcheck source=/dev/null
. "${m_DIR_REALPATH}/includes.sh"

## -----------------------------------------------------------------------------
## Includes sources & configuration
## -----------------------------------------------------------------------------
# shellcheck source=/dev/null
. "${m_DIR_SYS}/runasroot.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/string.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/filesystem.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/option.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/config.sh"

## -----------------------------------------------------------------------------
## Help
## -----------------------------------------------------------------------------
((m_OPTION_SHOWHELP)) && Option::showHelp && exit 0

## -----------------------------------------------------------------------------
## bash-sys must exists
## -----------------------------------------------------------------------------
if [[ ! -d "${m_DIR_SYS}" ]]; then
    String::error "bash-sys is not installed on ${m_DIR_SYS}"
    exit 1
fi

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Today is: $(date -R)"
String::notice "The PID for $(basename "$0") process is: $$"
Console::waitUser

## -----------------------------------------------------------------------------
## Parse the app options and arguments
## -----------------------------------------------------------------------------
declare -i iReturn=1

while (( "$#" )); do
    case "$1" in
    -t|--trace)
        shift
        String::separateLine
        Install::trace
        ;;
    -r|--remove)
        shift
        m_INSTALL_OPTION_REMOVE=1
        ;;
    *) # unknown option
        shift
        String::separateLine
        Option::showHelp
        exit 0
        ;;
    esac
done

Install::run ${m_INSTALL_OPTION_REMOVE}
Console::waitUser

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"
exit ${iReturn}
