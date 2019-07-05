## -----------------------------------------------------------------------------
## Linux Scripts.
## Managing services with SystemD
##
## @package ojullien\bash\sys\system
## @license MIT <https://github.com/ojullien/bash-sys/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Disable
## -----------------------------------------------------------------------------

Service::disable() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Service::disable <service>"
        return 1
    fi

    # Init
    local -i iReturn=0
    local sService="$1"

    # Do the job
    String::notice -n "Disabling '${sService}' service:"
    if systemctl --quiet is-enabled "${sService}" > /dev/null 2>&1 ; then
        systemctl --quiet disable "${sService}" > /dev/null 2>&1
        iReturn=$?
    fi
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Shutting down the system
## -----------------------------------------------------------------------------

Service::shutdown() {
    systemctl --quiet poweroff
    return 0
}
