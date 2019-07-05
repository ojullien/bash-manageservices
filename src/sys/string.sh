## -----------------------------------------------------------------------------
## Linux Scripts.
## String functions
##
## @package ojullien\bash\sys
## @license MIT <https://github.com/ojullien/bash-sys/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Write functions
## -----------------------------------------------------------------------------

Log::writeToLog() {
    if [[ -n "$1" ]] && ((m_OPTION_LOG)); then
        if [[ "$1" == "-n" ]]; then
            shift
            printf "%b" "${*}" >> "${m_LOGFILE}"
        else
            printf "%b\\n" "${*}" >> "${m_LOGFILE}"
        fi
    fi
    return 0
}

## -----------------------------------------------------------------------------
## Display functions
## -----------------------------------------------------------------------------

Console::displayError() {
    if [[ -n "$1" ]] && ((m_OPTION_DISPLAY)); then
        if [[ "$1" == "-n" ]]; then
            shift
            printf "${COLORRED}%b${COLORRESET}" "${*}" >&2
        else
            printf "${COLORRED}%b${COLORRESET}\\n" "${*}" >&2
        fi
    fi
    return 0
}

Console::displaySuccess() {
    if [[ -n "$1" ]] && ((m_OPTION_DISPLAY)); then
        if [[ "$1" == "-n" ]]; then
            shift
            printf "${COLORGREEN}%b${COLORRESET}" "${*}"
        else
            printf "${COLORGREEN}%b${COLORRESET}\\n" "${*}"
        fi
    fi
    return 0
}

Console::display() {
    if [[ -n "$1" ]] && ((m_OPTION_DISPLAY)); then
        if [[ "$1" == "-n" ]]; then
            shift
            printf "%b" "${*}"
        else
            printf "%b\\n" "${*}"
        fi
    fi
    return 0
}

## -----------------------------------------------------------------------------
## Log functions
## -----------------------------------------------------------------------------

String::error() {
    if [[ -n "$1" ]]; then
        Log::writeToLog "$@"
        Console::displayError "$@"
    fi
    return 0
}

String::notice() {
    if [[ -n "$1" ]]; then
        Log::writeToLog "$@"
        Console::display "$@"
    fi
    return 0
}

String::success() {
    if [[ -n "$1" ]]; then
        Log::writeToLog "$@"
        Console::displaySuccess "$@"
    fi
    return 0
}

String::checkReturnValueForTruthiness() {
    local -i iReturn=1
    if [[ -n "$1" ]]; then
        iReturn=$1
        if ((iReturn)); then
            String::error "NOK code: ${iReturn}"
        else
            String::success "OK"
        fi
    fi
    return "${iReturn}"
}

## -----------------------------------------------------------------------------
## Clear screen
## -----------------------------------------------------------------------------

Console::clearScreen() {
    ((m_OPTION_WAIT)) || clear
    return 0
}

String::separateLine() {
    String::notice "---------------------------------------------------------------------------"
    return 0
}

## -----------------------------------------------------------------------------
## Wait
## -----------------------------------------------------------------------------

Console::waitUser() {
    local sBuffer
    ((m_OPTION_WAIT)) && read -s -r -e -p "Press [ENTER] to continue." -n 1 sBuffer
    return 0
}
