## -----------------------------------------------------------------------------
## Linux Scripts.
## Mysql database functions
##
## Requires MySQL 5.5 at least
##
## @package ojullien\bash\sys\db
## @license MIT <https://github.com/ojullien/bash-sys/blob/master/LICENSE>
## -----------------------------------------------------------------------------

DB::flush() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: DB::flush <user> <password>"
        return 1
    fi

    # Init
    local sUser="$1" sPwd="$2"
    local -i iReturn=1

    # Do the job
    String::notice "Flushing all informations ..."
    mysqladmin --user="${sUser}" --password="${sPwd}" --host=localhost flush-hosts flush-logs flush-privileges flush-status flush-tables flush-threads
    iReturn=$?
    String::notice -n "Flush all informations:"
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

DB::check() {

    # Parameters
    if (($# < 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: DB::check <user> <password> [database]"
        return 1
    fi

    # Init
    local sUser="$1" sPwd="$2" sDatabase=""
    local -i iReturn=1

    if (($# == 3)) && [[ -n "$3" ]]; then
        sDatabase="$3"
    else
        sDatabase="--all-databases"
    fi

    # Do the job
    String::notice "Checking '${sDatabase}' ..."
    mysqlcheck --user="${sUser}" --password="${sPwd}" --host=localhost --check --auto-repair --force --silent ${sDatabase}
    iReturn=$?
    String::notice -n "Check '${sDatabase}':"
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

DB::analyse() {

    # Parameters
    if (($# < 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: DB::analyse <user> <password> [database]"
        return 1
    fi

    # Init
    local sUser="$1" sPwd="$2" sDatabase=""
    local -i iReturn=1

    if (($# == 3)) && [[ -n "$3" ]]; then
        sDatabase="$3"
    else
        sDatabase="--all-databases"
    fi

    # Do the job
    String::notice "Analysing '${sDatabase}' ..."
    mysqlcheck --user="${sUser}" --password="${sPwd}" --host=localhost --analyze --auto-repair --force --silent "${sDatabase}"
    iReturn=$?
    String::notice -n "Analyse '${sDatabase}':"
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

DB::optimize() {

    # Parameters
    if (($# < 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: DB::optimize <user> <password> [database]"
        return 1
    fi

    # Init
    local sUser="$1" sPwd="$2" sDatabase=""
    local -i iReturn=1

    if (($# == 3)) && [[ -n "$3" ]]; then
        sDatabase="$3"
    else
        sDatabase="--all-databases"
    fi

    # Do the job
    String::notice "Optimizing '${sDatabase}' ..."
    mysqlcheck --user="${sUser}" --password="${sPwd}" --host=localhost --optimize --force --silent "${sDatabase}"
    iReturn=$?
    String::notice -n "Optimize '${sDatabase}':"
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

DB::repair() {

    # Parameters
    if (($# != 3)) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]]; then
        String::error "Usage: DB::repair <user> <password> <database>"
        return 1
    fi

    # Init
    local sUser="$1" sPwd="$2" sDatabase="$3"
    local -i iReturn=1

    # Do the job
    String::notice "Repairing '${sDatabase}' ..."
    mysqlcheck --user="${sUser}" --password="${sPwd}" --host=localhost --repair --flush --force --silent "${sDatabase}"
    iReturn=$?
    String::notice -n "Repair '${sDatabase}':"
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

DB::dump() {

    # Parameters
    if (($# != 5)) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]] || [[ -z "$4" ]] || [[ -z "$5" ]]; then
        String::error "Usage: DB::dump <user> <password> <database> <error log file> <result file>"
        return 1
    fi

    # Init"$4"
    local sUser="$1" sPwd="$2" sDatabase="$3" sErrorLog="$4" sResultFile="$5"
    local -i iReturn=1

    # Do the job
    String::notice "Dumping '${sDatabase}' to '${sResultFile}' with error in '${sErrorLog}' ..."
    mysqldump --user="${sUser}" --password="${sPwd}" --log-error="${sErrorLog}" --result-file="${sResultFile}" \
        --host=localhost --add-drop-database --databases --add-drop-table --add-locks --allow-keywords --comments \
        --complete-insert --create-options --dump-date --extended-insert --flush-logs --flush-privileges --force \
        --hex-blob --single-transaction --max_allowed_packet=50M --quick --quote-names --routines --triggers \
        --tz-utc "${sDatabase}"
    iReturn=$?
    String::notice -n "Dump '${sDatabase}':"
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}
