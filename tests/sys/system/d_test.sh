## -----------------------------------------------------------------------------
## Linux Scripts.
## Test of serviceD functions
##
## @package ojullien\bash\tests\sys\system
## @license MIT <https://github.com/ojullien/bash-sys/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Disable
## -----------------------------------------------------------------------------

Test::ServiceD::disableParameterTest() {
    Service::disable
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::ServiceD::disableUnknownServiceTest() {
    local sValueToTest="servicedoesnotexist"
    Service::disable "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::ServiceD::disableTest() {
    local sValueToTest="test-remove-me"
    cp "/etc/init.d/skeleton" "/etc/init.d/${sValueToTest}"
    chmod +x "/etc/init.d/${sValueToTest}"
    service "${sValueToTest}" enable > /dev/null 2>&1
    Service::disable "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
    rm -f "/etc/init.d/${sValueToTest}"
}

## -----------------------------------------------------------------------------
## Use lowerspace in namespace of the main function
## -----------------------------------------------------------------------------

Test::serviced::main() {
    String::separateLine
    String::notice "Testing: sys/ServiceD ..."
    # shellcheck source=/dev/null
    . "${m_DIR_SYS}/runasroot.sh"
    Test::ServiceD::disableParameterTest
    Test::ServiceD::disableUnknownServiceTest
    Test::ServiceD::disableTest
}
