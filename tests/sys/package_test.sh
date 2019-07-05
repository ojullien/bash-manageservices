## -----------------------------------------------------------------------------
## Linux Scripts.
## Test of Package Management System
##
## @package ojullien\bash\tests\sys
## @license MIT <https://github.com/ojullien/bash-sys/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Get list of package selections.
## -----------------------------------------------------------------------------

Test::Package::displayLinuxSelectionsTest() {
    Package::displayLinuxSelections
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Install the newest versions of all packages currently installed on the system
## -----------------------------------------------------------------------------

Test::Package::upgradeTest() {
    Package::upgrade "--simulate"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Report existing status of specified package.
## Returns:
##          0 if the package exists in repos sourced in sources.list.
##        100 if Problems were encountered while parsing the command line or
##            performing the query, including no file or package being found.
## -----------------------------------------------------------------------------

Test::Package::existsParameterTest() {
    Package::exists
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::Package::existsErrorTest() {
    local sValueToTest="packagedoesnotexist"
    Package::exists "${sValueToTest}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::Package::existsTest() {
    local sValueToTest="apt-file"
    Package::exists "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Report installed status of specified package.
## Returns:
##          0 if the requested query was successfully performed.
##          1 if Problems were encountered while parsing the command line or
##            performing the query, including no file or package being found
## -----------------------------------------------------------------------------

Test::Package::isInstalledParameterTest() {
    local sValueToTest=""
    Package::isInstalled "${sValueToTest}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::Package::isInstalledErrorTest() {
    local sValueToTest="packagedoesnotexist"
    Package::isInstalled "${sValueToTest}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::Package::isInstalledTest() {
    local sValueToTest="apt"
    Package::isInstalled "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Install or upgrade specific packages
## -----------------------------------------------------------------------------

Test::Package::installParameterTest() {
    local sValueToTest=""
    Package::install "${sValueToTest}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::Package::installErrorTest() {
    local sValueToTest="packagedoesnotexist"
    Package::install "${sValueToTest}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::Package::installTest() {
    local sValueToTest="apt-file"
    Package::install "--simulate" "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Removes software packages including their configuration files
## -----------------------------------------------------------------------------

Test::Package::uninstallParameterTest() {
    local sValueToTest=""
    Package::uninstall "${sValueToTest}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::Package::uninstallErrorTest() {
    local sValueToTest="packagedoesnotexist"
    Package::uninstall "${sValueToTest}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::Package::uninstallTest() {
    local sValueToTest="nano"
    Package::uninstall "--simulate" "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Removes packages that were automatically installed to satisfy dependencies
## for other packages and are now no longer needed.
## Clears out the local repository of retrieved package files.
## -----------------------------------------------------------------------------

# shellcheck source=/dev/null
. "${m_DIR_SYS}/package.sh"

Test::Package::clean() {
    Package::clean
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Use lowerspace in namespace of the main function
## -----------------------------------------------------------------------------

Test::package::main() {
    String::separateLine
    String::notice "Testing: sys/package ..."
    # shellcheck source=/dev/null
    . "${m_DIR_SYS}/runasroot.sh"
    Test::Package::displayLinuxSelectionsTest
    Test::Package::upgradeTest
    Test::Package::existsParameterTest
    Test::Package::existsErrorTest
    Test::Package::existsTest
    Test::Package::isInstalledParameterTest
    Test::Package::isInstalledErrorTest
    Test::Package::isInstalledTest
    Test::Package::installParameterTest
    Test::Package::installErrorTest
    Test::Package::installTest
    Test::Package::uninstallParameterTest
    Test::Package::uninstallErrorTest
    Test::Package::uninstallTest
    Test::Package::clean
}
