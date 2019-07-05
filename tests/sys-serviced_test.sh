#!/bin/bash
## -----------------------------------------------------------------------------
## Linux Scripts.
## Run sys\serviceD tests
##
## @package ojullien\bash\tests
## @license MIT <https://github.com/ojullien/bash-sys/blob/master/LICENSE>
## -----------------------------------------------------------------------------

#set -o errexit
set -o nounset
set -o pipefail

if [[ ${BASH_VERSINFO[0]} -lt 4 ]]; then
    echo "At least Bash version 4 is needed!" >&2
    exit 4
fi

## -----------------------------------------------------------------------------
## Shell scripts directory, eg: /root/work/Shell/tests
## -----------------------------------------------------------------------------
readonly m_DIR_REALPATH="$(realpath "$(dirname "$0")")"

## -----------------------------------------------------------------------------
## Load constants
## -----------------------------------------------------------------------------
# shellcheck source=/dev/null
. "${m_DIR_REALPATH}/framework/constant.sh"

## -----------------------------------------------------------------------------
## Includes sources
## -----------------------------------------------------------------------------
# shellcheck source=/dev/null
. "${m_DIR_SYS}/string.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/filesystem.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/option.sh"
# shellcheck source=/dev/null
. "${m_DIR_REALPATH}/framework/library.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/system/d.sh"

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
Test::Constant::trace

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------

String::separateLine
String::notice "Today is: $(date -R)"
String::notice "The PID for $(basename "$0") process is: $$"
Console::waitUser

# shellcheck source=/dev/null
. "${m_TEST_DIR_SYS}/system/d_test.sh"
Test::serviced::main
Console::waitUser

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"
