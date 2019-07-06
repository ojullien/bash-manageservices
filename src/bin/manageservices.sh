#!/bin/bash
## -----------------------------------------------------------------------------
## Linux Scripts.
## Start, stop or disable a list of services.
##
## @package ojullien\bash\bin\manageservices
## @license MIT <https://github.com/ojullien/bash-manageservices/blob/master/LICENSE>
## -----------------------------------------------------------------------------
#set -o errexit
set -o nounset
set -o pipefail

## -----------------------------------------------------------------------------
## Shell scripts directory, eg: /root/work/Shell/src/bin
## -----------------------------------------------------------------------------
readonly m_DIR_REALPATH="$(realpath "$(dirname "$0")")"

## -----------------------------------------------------------------------------
## Load constants
## -----------------------------------------------------------------------------
# shellcheck source=/dev/null
. "${m_DIR_REALPATH}/../sys/constant.sh"

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
# shellcheck source=/dev/null
. "${m_DIR_SYS}/service.sh"
Config::load "manageservices"
# shellcheck source=/dev/null
. "${m_DIR_APP}/manageservices/app.sh"

## -----------------------------------------------------------------------------
## Help
## -----------------------------------------------------------------------------
((m_OPTION_SHOWHELP)) && ManageServices::showHelp && exit 0

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

if (( "$#" )); then
    case "$1" in
    stop)
        String::separateLine
        Service::stopServices ${m_SERVICES_STOP}
        iReturn=$?
        ;;
    start)
        String::separateLine
        Service::startServices ${m_SERVICES_START}
        iReturn=$?
        ;;
    disable)
        String::separateLine
        Service::disableServices ${m_SERVICES_DISABLE}
        iReturn=$?
        ;;
    trace)
        String::separateLine
        Constant::trace
        ManageServices::trace
        iReturn=0
        ;;
    *) # unknown option
        String::separateLine
        ManageServices::showHelp
        ;;
    esac
else
        String::separateLine
        ManageServices::showHelp
fi

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"
exit ${iReturn}
