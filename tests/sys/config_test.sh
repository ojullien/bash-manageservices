## -----------------------------------------------------------------------------
## Linux Scripts.
## Test of the config functions
##
## @package ojullien\bash\tests\sys
## @license MIT <https://github.com/ojullien/bash-sys/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Init
## -----------------------------------------------------------------------------
readonly m_TEST_DIR_TEMP_01="tmp.01"
readonly m_TEST_DIR_TEMP_02="tmp.02"
readonly m_TEST_DIR_TEMP_03="tmp.03"

# shellcheck source=/dev/null
. "${m_DIR_SYS}/config.sh"

## -----------------------------------------------------------------------------
## Load config file
## -----------------------------------------------------------------------------

Test::Config::loadBadParameterTest() {
    Config::load ""
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::Config::loadBadAppFolderTest() {
    Config::load "doesnotexist"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::Config::loadMissingDefaultConfigFileTest() {
    echo 'String::error "local.config.sh is loaded"' > "${m_DIR_APP}/${m_TEST_DIR_TEMP_01}/local.config.sh"
    Config::load "${m_TEST_DIR_TEMP_01}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::Config::loadLocal() {
    echo 'String::success "local.config.sh is loaded"' > "${m_DIR_APP}/${m_TEST_DIR_TEMP_02}/local.config.sh"
    echo 'String::error "config.php is loaded"' > "${m_DIR_APP}/${m_TEST_DIR_TEMP_02}/config.sh"
    Config::load "${m_TEST_DIR_TEMP_02}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::Config::loadDefault() {
    echo 'String::success "config.sh is loaded"' > "${m_DIR_APP}/${m_TEST_DIR_TEMP_03}/config.sh"
    Config::load "${m_TEST_DIR_TEMP_03}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Use lowerspace in namespace of the main function
## -----------------------------------------------------------------------------

Test::config::main() {
    String::separateLine
    String::notice "Testing: sys/config ..."

    mkdir --parents "${m_DIR_APP}/${m_TEST_DIR_TEMP_01}"
    mkdir --parents "${m_DIR_APP}/${m_TEST_DIR_TEMP_02}"
    mkdir --parents "${m_DIR_APP}/${m_TEST_DIR_TEMP_03}"

    Test::Config::loadBadParameterTest
    Test::Config::loadBadAppFolderTest
    Test::Config::loadMissingDefaultConfigFileTest
    Test::Config::loadLocal
    Test::Config::loadDefault
}

## -----------------------------------------------------------------------------
## End
## -----------------------------------------------------------------------------
Test::Config::finish() {
    rm -Rf "${m_DIR_APP:?}/${m_TEST_DIR_TEMP_01:?}"
    rm -Rf "${m_DIR_APP:?}/${m_TEST_DIR_TEMP_02:?}"
    rm -Rf "${m_DIR_APP:?}/${m_TEST_DIR_TEMP_03:?}"
}
trap Test::Config::finish EXIT SIGQUIT SIGTERM SIGINT ERR
