## -----------------------------------------------------------------------------
## Linux Scripts.
## Test of the mariadb functions
##
## @package ojullien\bash\tests\sys
## @license MIT <https://github.com/ojullien/bash-sys/blob/master/LICENSE>
## -----------------------------------------------------------------------------

# shellcheck source=/dev/null
. "${m_DIR_SYS}/db/mariadb.sh"

## -----------------------------------------------------------------------------
## Init
## -----------------------------------------------------------------------------
readonly m_TEST_DIR_TEMP="$(mktemp --directory -t shell.db.test.XXXXXXXXXX)"

Test::DB::flush() {
    local sUser="${1}"
    local sPassword="${2}"
    DB::flush "${sUser}" "${sPassword}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::DB::flushError() {
    local sUser="${1}"
    local sPassword="${2}"
    DB::flush "${sUser}" "${sPassword}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::DB::check() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    DB::check "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::DB::checkAll() {
    local sUser="${1}"
    local sPassword="${2}"
    DB::check "${sUser}" "${sPassword}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::DB::checkError() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    DB::check "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::DB::analyse() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    DB::analyse "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::DB::analyseAll() {
    local sUser="${1}"
    local sPassword="${2}"
    DB::analyse "${sUser}" "${sPassword}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::DB::analyseError() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    DB::analyse "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::DB::optimize() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    DB::optimize "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::DB::optimizeAll() {
    local sUser="${1}"
    local sPassword="${2}"
    DB::optimize "${sUser}" "${sPassword}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::DB::optimizeError() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    DB::optimize "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::DB::repair() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    DB::repair "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::DB::repairError() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    DB::repair "${sUser}" "${sPassword}" "${sDatabase}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::DB::dump() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    local sErrorLogFile="${4}"
    local sResultFile="${5}"
    DB::dump "${sUser}" "${sPassword}" "${sDatabase}" "${sErrorLogFile}" "${sResultFile}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::DB::dumpError() {
    local sUser="${1}"
    local sPassword="${2}"
    local sDatabase="${3}"
    local sErrorLogFile="${4}"
    local sResultFile="${5}"
    DB::dump "${sUser}" "${sPassword}" "${sDatabase}" "${sErrorLogFile}" "${sResultFile}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Use lowerspace in namespace of the main function
## -----------------------------------------------------------------------------

Test::mariadb::main() {

    # Init
    local sUser sPassword sDatabase sErrorLogFile sResultFile
    sUser="root"
    sPassword="<password>"
    sDatabase="<database>"
    sErrorLogFile="$(mktemp -p "${m_TEST_DIR_TEMP}")"
    sResultFile="$(mktemp -p "${m_TEST_DIR_TEMP}")"

    # Do the job
    String::separateLine
    String::notice "Testing: sys/db/mysql ..."

    Test::DB::flush "${sUser}" "${sPassword}"
    Test::DB::flushError "${sUser}" "notvalid"

    Test::DB::check "${sUser}" "${sPassword}" "${sDatabase}"
    Test::DB::checkAll "${sUser}" "${sPassword}"
    Test::DB::checkError "${sUser}" "notvalid" "${sDatabase}"

    Test::DB::analyse "${sUser}" "${sPassword}" "${sDatabase}"
    Test::DB::analyseAll "${sUser}" "${sPassword}"
    Test::DB::analyseError "${sUser}" "notvalid" "${sDatabase}"

    Test::DB::optimize "${sUser}" "${sPassword}" "${sDatabase}"
    Test::DB::optimizeAll "${sUser}" "${sPassword}"
    Test::DB::optimizeError "${sUser}" "notvalid" "${sDatabase}"

    Test::DB::repair "${sUser}" "${sPassword}" "${sDatabase}"
    Test::DB::repairError "${sUser}" "${sPassword}" "doesnotexist"

    Test::DB::dump "${sUser}" "${sPassword}" "${sDatabase}" "${sErrorLogFile}" "${sResultFile}"
    Test::DB::dumpError "${sUser}" "${sPassword}" "doesnotexist" "${sErrorLogFile}" "${sResultFile}"

}

## -----------------------------------------------------------------------------
## End
## -----------------------------------------------------------------------------
Test::DB::finish() {
  rm -Rf "${m_TEST_DIR_TEMP}"
}
trap Test::DB::finish EXIT SIGQUIT SIGTERM SIGINT ERR
