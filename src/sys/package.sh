## -----------------------------------------------------------------------------
## Linux Scripts.
## Package Management System
##
## @package ojullien\bash\sys
## @license MIT <https://github.com/ojullien/bash-sys/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Get list of package selections.
## -----------------------------------------------------------------------------

Package::displayLinuxSelections() {

    # Init
    local -i iReturn=1

    # Do the job
    String::notice "Linux selections"
    dpkg --get-selections | grep --extended-regexp --ignore-case "Linux-headers|linux-image"
    iReturn=$?

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Install the newest versions of all packages currently installed on the system
## -----------------------------------------------------------------------------

Package::upgrade() {

    # Init
    local -i iReturn=1
    local sOption=""

    # Parameters
    if (($# == 1)) && [[ "--simulate" == "$1" ]]; then
        sOption="--simulate"
    fi

    # Re-synchronize the package index files from their sources.
    String::notice "Updating..."
    apt-get update > /dev/null 2>&1
    iReturn=$?
    String::notice -n "Update status:"
    String::checkReturnValueForTruthiness ${iReturn}

    # Install the newest versions of all packages currently installed on the system
    if ((0==iReturn)); then
        String::separateLine
        String::notice "Upgrading..."
        apt-get upgrade --yes ${sOption}
        iReturn=$?
        String::notice -n "Upgrade status:"
        String::checkReturnValueForTruthiness ${iReturn}
    fi

    # Updates the package cache and checks for broken dependencies.
    if ((0==iReturn)); then
        String::separateLine
        String::notice "Checking..."
        apt-get check
        iReturn=$?
        String::notice -n "Check status:"
        String::checkReturnValueForTruthiness ${iReturn}
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Report existing status of specified package.
## Returns:
##          0 if the package exists in repos sourced in sources.list.
##        100 if Problems were encountered while parsing the command line or
##            performing the query, including no file or package being found.
## -----------------------------------------------------------------------------

Package::exists() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Package::exists <package name>"
        return 100
    fi

    # Init
    local sPackage="$1"
    local -i iReturn=100

    # Do the job
    String::notice -n "Does package '${sPackage}' exist in repos sourced in sources.list? "
    apt-cache show "${sPackage}" > /dev/null 2>&1
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Report installed status of specified package.
## Returns:
##          0 if the requested query was successfully performed.
##          1 if Problems were encountered while parsing the command line or
##            performing the query, including no file or package being found
## -----------------------------------------------------------------------------

Package::isInstalled() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Package::isInstalled <package name>"
        return 1
    fi

    # Init
    local sPackage="$1"
    local -i iReturn=1

    # Do the job
    String::notice -n "Is the package '${sPackage}' installed? "
    dpkg-query --status "${sPackage}" > /dev/null 2>&1
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Install or upgrade specific packages
## -----------------------------------------------------------------------------

Package::install() {

    # Parameters
    if (($# == 0)) || [[ -z "$1" ]]; then
        String::error "Usage: Package::install <package 1> [package 2 ...]"
        return 1
    fi

    # Init
    local -i iReturn=1

    # Do the job
    String::notice "Installing '$*' package(s) ..."
    apt-get install --yes "$@"
    iReturn=$?
    String::notice -n "Install '$*' package(s) status:"
    String::checkReturnValueForTruthiness ${iReturn}

    if ((0==iReturn)); then
        String::notice "Checking..."
        apt-get check
        iReturn=$?
        String::notice -n "Check status:"
        String::checkReturnValueForTruthiness ${iReturn}
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Removes software packages including their configuration files
## -----------------------------------------------------------------------------

Package::uninstall() {

    # Parameters
    if (($# == 0)) || [[ -z "$1" ]]; then
        String::error "Usage: Package::uninstall <package 1> [package 2 ...]"
        return 1
    fi

    # Init
    local -i iReturn=1

    String::notice "Purgeing '$*' package(s)..."
    apt-get purge --yes "$@"
    iReturn=$?
    String::notice -n "Purge '$*' package(s) status:"
    String::checkReturnValueForTruthiness ${iReturn}

    if ((0==iReturn)); then
        String::notice "Checking..."
        apt-get check
        iReturn=$?
        String::notice -n "Check status:"
        String::checkReturnValueForTruthiness ${iReturn}
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Removes packages that were automatically installed to satisfy dependencies
## for other packages and are now no longer needed.
## Clears out the local repository of retrieved package files.
## -----------------------------------------------------------------------------

Package::clean() {

    # Init
    local -i iReturnA=1 iReturnC=1

    # Do the job
    String::notice "Removing no longer needed dependencies packages..."
    apt-get autoremove --purge
    iReturnA=$?
    String::notice -n "Autoremove status:"
    String::checkReturnValueForTruthiness ${iReturnA}

    String::notice "Cleaning downloaded packages..."
    apt-get clean
    iReturnC=$?
    String::notice -n "Clean status:"
    String::checkReturnValueForTruthiness ${iReturnC}

    return $((iReturnA+iReturnC))
}
