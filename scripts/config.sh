## -----------------------------------------------------------------------------
## Linux Scripts.
## Configuration file.
##
## @package ojullien\bash\scripts
## @license MIT <https://github.com/ojullien/bash-manageservices/blob/master/LICENSE>
## -----------------------------------------------------------------------------

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
## Defines options
## -----------------------------------------------------------------------------
declare -i m_INSTALL_OPTION_REMOVE=0
