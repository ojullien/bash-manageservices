## -----------------------------------------------------------------------------
## Linux Scripts.
## Managing services
##
## @package ojullien\bash\sys
## @license MIT <https://github.com/ojullien/bash-sys/blob/master/LICENSE>
## -----------------------------------------------------------------------------

if [[ -d "/run/systemd/system" ]]; then
    # shellcheck source=/dev/null
    . "${m_DIR_SYS}/system/d.sh"
else
    # shellcheck source=/dev/null
    . "${m_DIR_SYS}/system/v.sh"
fi

## -----------------------------------------------------------------------------
## Stop
## -----------------------------------------------------------------------------

Service::stop() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Service::stop <service>"
        return 1
    fi

    # Init
    local -i iReturn=0
    local sService="$1"

    # Do the job
    String::notice -n "Stopping '${sService}' service:"
    (service --status-all | grep --word-regexp "${sService}$") > /dev/null 2>&1
    iReturn=$?
    if ((iReturn == 0)); then
        service "${sService}" stop > /dev/null 2>&1
        iReturn=$?
        String::checkReturnValueForTruthiness ${iReturn}
    else
        String::notice "not loaded"
        iReturn=0
    fi

    return ${iReturn}
}

Service::stopServices() {

    # Parameters
    if [[ -z "$1" ]]; then
        String::error "Usage: Service::stopServices <service 1> <service 2> <...>"
        return 1
    fi

    # Init
    local -i iReturn=0

    # Do the job
    String::notice "Stopping '$*' services..."
    for myService in "$@"
    do
        Service::stop "${myService}"
        ((iReturn+=$?))
    done

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Disable
## -----------------------------------------------------------------------------

Service::disableServices() {

    # Parameters
    if [[ -z "$1" ]]; then
        String::error "Usage: Service::disableServices <service 1> <service 2> <...>"
        return 1
    fi

    # Init
    local -i iReturn=0

    # Do the job
    String::notice "Disabling '$*' services..."
    for myService in "$@"
    do
        Service::stop "${myService}"
        ((iReturn+=$?))
        Service::disable "${myService}"
        ((iReturn+=$?))
    done

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------

Service::start() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Service::start <service>"
        return 1
    fi

    # Init
    local -i iReturn=1
    local sService="$1"

    # Do the job
    String::notice -n "Starting '${sService}' service:"
    (service --status-all | grep --word-regexp "${sService}$") > /dev/null 2>&1
    iReturn=$?
    if ((iReturn == 0)); then
        service "${sService}" start > /dev/null 2>&1
        iReturn=$?
        String::checkReturnValueForTruthiness ${iReturn}
    else
        String::notice "not found"
    fi

    return ${iReturn}
}

Service::startServices() {

    # Parameters
    if [[ -z "$1" ]]; then
        String::error "Usage: Service::startServices <service 1> <service 2> <...>"
        return 1
    fi

    # Init
    local -i iReturn=0

    # Do the job
    String::notice "Starting '$*' services..."
    for myService in "$@"
    do
        Service::start "${myService}"
        ((iReturn+=$?))
    done

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Status
## -----------------------------------------------------------------------------

Service::status() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: Service::status <service>"
        return 1
    fi

    # Init
    local -i iReturn=1
    local sService="$1"

    # Do the job
    String::notice -n "'${sService}' status is:"
    if service --status-all | grep --word-regexp --quiet "${sService}$"; then
        service "${sService}" status > /dev/null 2>&1
        iReturn=$?
        case ${iReturn} in
            0)
                String::notice "running"
                ;;
            3)
                String::notice "stopped"
                ;;
            *)
                String::error "ERROR code: ${iReturn}"
        esac
    else
        String::notice "not found"
    fi

    return ${iReturn}
}

Service::statusServices() {

    # Parameters
    if [[ -z "$1" ]]; then
        String::error "Usage: Service::statusServices <service 1> <service 2> <...>"
        return 1
    fi

    # Init
    local -i iReturn=0

    String::notice "Getting status for '$*' services..."
    for myService in "$@"
    do
        Service::statusService "${myService}"
        ((iReturn+=$?))
    done

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Shutting down the system
## -----------------------------------------------------------------------------

Service::shutdownSystem() {
    Service::shutdown
    return 0
}
