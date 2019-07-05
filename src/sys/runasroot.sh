## -----------------------------------------------------------------------------
## Linux Scripts.
## Root test
##
## @package ojullien\bash\sys
## @license MIT <https://github.com/ojullien/bash-sys/blob/master/LICENSE>
## -----------------------------------------------------------------------------

if [[ "$(id -u)" != 0 ]]; then
   echo -e "${COLORRED}This script must be run as root!${COLORRESET}" >&2
   exit 3
fi
