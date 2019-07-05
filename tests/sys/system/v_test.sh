## -----------------------------------------------------------------------------
## Linux Scripts.
## Test of serviceV functions
##
## @package ojullien\bash\tests\sys\system
## @license MIT <https://github.com/ojullien/bash-sys/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Disable
## -----------------------------------------------------------------------------

Test::ServiceV::disableParameterTest() {
    Service::disable
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::ServiceV::disableUnknownServiceTest() {
    local sValueToTest="servicedoesnotexist"
    Service::disable "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::ServiceV::disableTest() {
    local sValueToTest="test-remove-me"
    cp "/etc/init.d/skeleton" "/etc/init.d/${sValueToTest}"
    chmod +x "/etc/init.d/${sValueToTest}"
    Service::disable "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
    rm -f "/etc/init.d/${sValueToTest}"
}

## -----------------------------------------------------------------------------
## Use lowerspace in namespace of the main function
## -----------------------------------------------------------------------------

Test::servicev::main() {
    String::separateLine
    String::notice "Testing: sys/serviceV ..."
    # shellcheck source=/dev/null
    . "${m_DIR_SYS}/runasroot.sh"
    Test::ServiceV::disableParameterTest
    Test::ServiceV::disableUnknownServiceTest
    Test::ServiceV::disableTest
}
