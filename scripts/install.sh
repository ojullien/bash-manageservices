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

## -----------------------------------------------------------------------------
## Defines current date
## -----------------------------------------------------------------------------
readonly m_DATE="$(date +"%Y%m%d")_$(date +"%H%M")"

## -----------------------------------------------------------------------------
## Defines main directories
## -----------------------------------------------------------------------------

# DESTINATION
readonly m_INSTALL_DESTINATION_DIR="/opt/oju/bash"
readonly m_DIR_APP="${m_INSTALL_DESTINATION_DIR}/app" # Directory holds apps
readonly m_DIR_BIN="${m_INSTALL_DESTINATION_DIR}/bin" # Directory holds app entry point
readonly m_DIR_SYS="${m_INSTALL_DESTINATION_DIR}/sys" # Directory holds system files

# SOURCE
readonly m_INSTALL_APP_NAME="manageservices"
readonly m_INSTALL_SOURCE_APP_DIR="$(realpath "${m_DIR_REALPATH}/../src/app/${m_INSTALL_APP_NAME}")"
readonly m_INSTALL_SOURCE_BIN_FILE="$(realpath "${m_DIR_REALPATH}/../src/bin/${m_INSTALL_APP_NAME}.sh")"

## -----------------------------------------------------------------------------
## Defines main files
## Log file cannot be in /var/log 'cause few apps clean this directory
## -----------------------------------------------------------------------------
readonly m_LOGDIR="$(realpath "${m_DIR_REALPATH}/../src/log")"
readonly m_LOGFILE="${m_LOGDIR}/${m_DATE}_$(basename "$0").log"

## -----------------------------------------------------------------------------
## Defines colors
## -----------------------------------------------------------------------------
readonly COLORRED="$(tput -Txterm setaf 1)"
readonly COLORGREEN="$(tput -Txterm setaf 2)"
readonly COLORRESET="$(tput -Txterm sgr0)"

## -----------------------------------------------------------------------------
## Functions
## -----------------------------------------------------------------------------
Constant::trace() {
    String::separateLine
    String::notice "Main configuration"
    FileSystem::checkDir "\tSource directory:\t\t${m_DIR_REALPATH}" "${m_DIR_REALPATH}"
    FileSystem::checkDir "\tSystem directory:\t\t${m_DIR_SYS}" "${m_DIR_SYS}"
    FileSystem::checkDir "\tDestination app directory:\t\t\t${m_DIR_APP}" "${m_DIR_APP}"
    FileSystem::checkDir "\tDestination bin directory:\t\t\t${m_DIR_BIN}" "${m_DIR_BIN}"
    FileSystem::checkFile "\tLog file is:\t\t\t${m_LOGFILE}" "${m_LOGFILE}"
    return 0
}

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
## Trace
## -----------------------------------------------------------------------------
Constant::trace
Console::waitUser

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Today is: $(date -R)"
String::notice "The PID for $(basename "$0") process is: $$"
Console::waitUser

FileSystem::removeDirectory "${m_DIR_APP}/${m_INSTALL_APP_NAME}"
iReturn=$?
((0!=iReturn)) && exit ${iReturn}

FileSystem::removeDirectory "${m_DIR_BIN}/${m_INSTALL_APP_NAME}.sh"
iReturn=$?
((0!=iReturn)) && exit ${iReturn}

FileSystem::copyFile "${m_INSTALL_SOURCE_APP_DIR}" "${m_DIR_APP}"
iReturn=$?
((0!=iReturn)) && exit ${iReturn}
Console::waitUser

FileSystem::copyFile "${m_INSTALL_SOURCE_BIN_FILE}" "${m_DIR_BIN}"
iReturn=$?
((0!=iReturn)) && exit ${iReturn}
Console::waitUser

String::notice -n "Change owner:"
chown -R root:root "${m_DIR_APP}/${m_INSTALL_APP_NAME}" "${m_DIR_BIN}/${m_INSTALL_APP_NAME}.sh"
iReturn=$?
String::checkReturnValueForTruthiness ${iReturn}
((0!=iReturn)) && exit ${iReturn}
Console::waitUser

String::notice -n "Change directory access rights:"
find "${m_DIR_APP}" -type d -name "${m_INSTALL_APP_NAME}" -exec chmod u=rwx,g=rx,o=rx {} \;
iReturn=$?
String::checkReturnValueForTruthiness ${iReturn}
((0!=iReturn)) && exit ${iReturn}

String::notice -n "Change files access rights:"
find "${m_DIR_APP}/${m_INSTALL_APP_NAME}" -type f -exec chmod u=rw,g=r,o=r {} \;
iReturn=$?
String::checkReturnValueForTruthiness ${iReturn}
((0!=iReturn)) && exit ${iReturn}

String::notice -n "Change sh files access rights:"
chmod +x "${m_DIR_BIN}/${m_INSTALL_APP_NAME}.sh"
iReturn=$?
String::checkReturnValueForTruthiness ${iReturn}
((0!=iReturn)) && return ${iReturn}

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"
exit ${iReturn}
