#!/bin/bash
## -----------------------------------------------------------------------------
## Linux Scripts.
## Install the bash-sys project into the /opt/oju/bash directory.
##
## @package ojullien\bash
## @license MIT <https://github.com/ojullien/bash-sys/blob/master/LICENSE>
## -----------------------------------------------------------------------------
#set -o errexit
set -o nounset
set -o pipefail

## -----------------------------------------------------------------------------
## Shell scripts directory, eg: /opt/Shell/scripts/
## -----------------------------------------------------------------------------
readonly m_DIR_REALPATH="$(realpath "$(dirname "$0")")"

## -----------------------------------------------------------------------------
## Defines current date
## -----------------------------------------------------------------------------
readonly m_DATE="$(date +"%Y%m%d")_$(date +"%H%M")"

## -----------------------------------------------------------------------------
## Defines main directories
## -----------------------------------------------------------------------------

# Directory holds system files
readonly m_DIR_SYS="$(realpath "${m_DIR_REALPATH}/../src/sys")"
# Directory holds apps
readonly m_DIR_APP="$(realpath "${m_DIR_REALPATH}/../src/app")"
# Directory destination
readonly m_INSTALLSHELL_DIR_SOURCE="$(realpath "${m_DIR_REALPATH}/../src")"
# Directory destination
readonly m_INSTALLSHELL_DIR_DESTINATION="/opt/oju"
# Directory to install
readonly m_INSTALLSHELL_PROJECT_NAME="bash"

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
    FileSystem::checkDir "\tScript directory:\t\t${m_DIR_REALPATH}" "${m_DIR_REALPATH}"
    FileSystem::checkDir "\tSystem directory:\t\t${m_DIR_SYS}" "${m_DIR_SYS}"
    FileSystem::checkDir "\tApp directory:\t\t\t${m_DIR_APP}" "${m_DIR_APP}"
    FileSystem::checkFile "\tLog file is:\t\t\t${m_LOGFILE}" "${m_LOGFILE}"
    String::notice "Distribution"
    (( m_OPTION_DISPLAY )) && lsb_release --all
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
## Install packages system
## -----------------------------------------------------------------------------
String::separateLine
apt-get install "lsb-release" --yes --quiet
Console::waitUser

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
Constant::trace
String::separateLine
String::notice "App configuration: installShell"
FileSystem::checkDir "\tSource directory:\t${m_INSTALLSHELL_DIR_SOURCE}" "${m_INSTALLSHELL_DIR_SOURCE}"
FileSystem::checkDir "\tDestination directory:\t${m_INSTALLSHELL_DIR_DESTINATION}" "${m_INSTALLSHELL_DIR_DESTINATION}"
String::notice "\tProject name:\t\t${m_INSTALLSHELL_PROJECT_NAME}"

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Today is: $(date -R)"
String::notice "The PID for $(basename "$0") process is: $$"
Console::waitUser

FileSystem::removeDirectory "${m_INSTALLSHELL_DIR_DESTINATION}/${m_INSTALLSHELL_PROJECT_NAME}"
iReturn=$?
((0!=iReturn)) && exit ${iReturn}

FileSystem::createDirectory "${m_INSTALLSHELL_DIR_DESTINATION}"
iReturn=$?
((0!=iReturn)) && exit ${iReturn}

FileSystem::copyFile "${m_INSTALLSHELL_DIR_SOURCE}" "${m_INSTALLSHELL_DIR_DESTINATION}/${m_INSTALLSHELL_PROJECT_NAME}"
iReturn=$?
((0!=iReturn)) && exit ${iReturn}

String::notice -n "Change owner:"
chown -R root:root "${m_INSTALLSHELL_DIR_DESTINATION}"
iReturn=$?
String::checkReturnValueForTruthiness ${iReturn}
((0!=iReturn)) && exit ${iReturn}

String::notice -n "Change common directories access rights:"
find "${m_INSTALLSHELL_DIR_DESTINATION}" -type d -exec chmod u=rwx,g=rx,o=rx {} \;
iReturn=$?
String::checkReturnValueForTruthiness ${iReturn}
((0!=iReturn)) && exit ${iReturn}

String::notice -n "Change log directory access rights:"
find "${m_INSTALLSHELL_DIR_DESTINATION}/${m_INSTALLSHELL_PROJECT_NAME}/log" -type d -exec chmod u=rwx,g=rwx,o=rwx {} \;
iReturn=$?
String::checkReturnValueForTruthiness ${iReturn}
((0!=iReturn)) && exit ${iReturn}

String::notice -n "Change files access rights:"
find "${m_INSTALLSHELL_DIR_DESTINATION}/${m_INSTALLSHELL_PROJECT_NAME}" -type f -exec chmod u=rw,g=r,o=r {} \;
iReturn=$?
String::checkReturnValueForTruthiness ${iReturn}
((0!=iReturn)) && exit ${iReturn}

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"
exit ${iReturn}
