## -----------------------------------------------------------------------------
## Linux Scripts.
## Options
##
## @package ojullien\bash\sys
## @license MIT <https://github.com/ojullien/bash-sys/blob/master/LICENSE>
## -----------------------------------------------------------------------------

declare -i m_OPTION_DISPLAY=1
declare -i m_OPTION_LOG=0
declare -i m_OPTION_WAIT=0
declare -i m_OPTION_SHOWHELP=0
declare -a m_APP_ARGUMENTS=()

Option::showHelp() {
    String::notice "Options:"
    String::notice "\t-n | --no-display\tdisplay mode. Contents are not displayed."
    String::notice "\t-l | --active-log\tlog mode. Contents are logged."
    String::notice "\t-w | --wait\t\twait user. Wait for user input between actions."
    String::notice "\t-h | --help\t\tShow the help."
    String::notice "\t-v | --version\t\tShow the version."
    return 0
}

Option::showVersion() {
    String::notice "\tVersion: 20190322"
    return 0
}

## -----------------------------------------------------------------------------
## Parse the common options
## -----------------------------------------------------------------------------

while (( "$#" )); do
    case "$1" in
    -n|--no-display)
        m_OPTION_DISPLAY=0
        shift
        ;;
    -l|--active-log)
        m_OPTION_LOG=1
        shift
        ;;
    -w|--wait)
        m_OPTION_WAIT=1
        shift
        ;;
    -h|--help)
        m_OPTION_SHOWHELP=1
        shift
        ;;
    -v|--version)
        Option::showVersion
        exit 0
        ;;
    --) # end argument parsing
        shift
        break
        ;;
    *) # preserve positional app arguments
        m_APP_ARGUMENTS+=("$1")
        shift
        ;;
  esac
done

# Keep the options and the arguments for the app.
# set positional arguments in their proper place
eval set -- "${m_APP_ARGUMENTS[@]}"
m_APP_ARGUMENTS=()

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------

if ((m_OPTION_DISPLAY)); then

    Console::display "Display mode is ON. Contents will be displayed."

    if ((m_OPTION_LOG)); then
        Console::display "Log mode is ON. Contents will be logged."
    else
        Console::display "Log mode is OFF. Contents will not be logged."
    fi

    if ((m_OPTION_WAIT)); then
        Console::display "Wait mode is ON. Wait for user input between actions."
    else
        Console::display "Wait mode is OFF. Do not wait for user input between actions."
    fi

    if ((m_OPTION_SHOWHELP)); then
        Console::display "Will show the help."
    fi

fi
