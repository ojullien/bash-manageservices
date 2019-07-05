## -----------------------------------------------------------------------------
## Linux Scripts.
## Managing services with SystemV
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
    if [[ -x "/etc/init.d/${sService}" ]]; then
        update-rc.d -f "${sService}" remove > /dev/null 2>&1
        iReturn=$?
        String::checkReturnValueForTruthiness ${iReturn}
    else
        String::notice "unrecognized service"
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Shutting down the system
## -----------------------------------------------------------------------------

Service::shutdown() {
    shutdown --poweroff now
    return 0
}
