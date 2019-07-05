## -----------------------------------------------------------------------------
## Linux Scripts.
## File System functions
##
## @package ojullien\bash\sys
## @license MIT <https://github.com/ojullien/bash-sys/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Checks whether a directory exists
## -----------------------------------------------------------------------------

FileSystem::checkDir() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: FileSystem::checkDir <label> <path>"
        return 1
    fi

    # Init
    local sLabel="$1" sPath="$2"
    local -i iReturn=1

    # Do the job
    if [[ -d "${sPath}" ]]; then
        String::success "${sLabel}"
        iReturn=0
    else
        String::error "${sLabel}"
        iReturn=1
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Checks whether a file exists
## -----------------------------------------------------------------------------

FileSystem::checkFile() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: FileSystem::checkFile <label> <path>"
        return 1
    fi

    # Init
    local sLabel="$1" sPath="$2"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sPath}" ]]; then
        String::success "${sLabel}"
        iReturn=0
    else
        String::error "${sLabel}"
        iReturn=1
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Copy SOURCE to DEST, or multiple SOURCE(s) to DIRECTORY
## -----------------------------------------------------------------------------

FileSystem::copyFile() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: FileSystem::copyFile <source> <destination>"
        return 1
    fi

    # Init
    local sSource="$1" sDestination="$2"
    local -i iReturn=1

    # Do the job
    String::notice -n "Copying '${sSource}' to '${sDestination}':"
    if [[ -e "${sSource}" ]]; then
        cp --force --recursive "${sSource}" "${sDestination}"
        iReturn=$?
    else
        iReturn=1
    fi
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Rename SOURCE to DEST, or move SOURCE(s) to DIRECTORY.
## -----------------------------------------------------------------------------

FileSystem::moveFile() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: FileSystem::moveFile <source> <destination>"
        return 1
    fi

    # Init
    local sSource="$1" sDestination="$2"
    local -i iReturn=1

    # Do the job
    String::notice -n "Moving '${sSource}' to '${sDestination}':"
    if [[ -e ${sSource} ]]; then
        mv --force "${sSource}" "${sDestination}"
        iReturn=$?
    else
        iReturn=1
    fi
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Flush file system buffers
## -----------------------------------------------------------------------------

FileSystem::syncFile() {

    # Init
    local -i iReturn=1

    # Do the job
    String::notice -n "flush file system buffers:"
    sync
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Directories
## -----------------------------------------------------------------------------

FileSystem::removeDirectory() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: FileSystem::removeDirectory <path>"
        return 1
    fi

    # Init
    local sPath="$1"
    local -i iReturn=1

    # Do the job
    String::notice -n "Removing '${sPath}':"
    rm --recursive --force "${sPath:?}"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

FileSystem::cleanDirectory() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: FileSystem::cleanDirectory <path>"
        return 1
    fi

    # Init
    local sPath="$1"
    local -i iReturn=1

    # Do the job
    String::notice -n "Cleaning '${sPath}':"
    find "${sPath}" -mindepth 1 -delete > /dev/null 2>&1
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

FileSystem::createDirectory() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: FileSystem::createDirectory <top directory>"
        return 1
    fi

    # Init
    local sPath="$1"
    local -i iReturn=1

    # Do the job
    String::notice -n "Creating '${sPath}':"
    mkdir --parents "${sPath}"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Compress
## -----------------------------------------------------------------------------

FileSystem::compressFile() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error 'Usage: FileSystem::compressFile <DESTINATION> <SOURCE>'
        return 1
    fi

    # Init
    local sSource="$2" sDestination="$1"
    local -i iReturn=1

    # Do the job
    String::notice -n "Compress '${sSource}':"
    tar --create --bzip2 -f "${sDestination}.tar.bz2" "${sSource}" > /dev/null 2>&1
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Find and remove files
## -----------------------------------------------------------------------------

FileSystem::findToRemove() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: FileSystem::findToRemove <PATH> <NAME>"
        return 1
    fi

    # Init
    local sPath="$1" sName="$2"
    local -i iReturn=1

    # Do the job
    String::notice -n "Remove all '${sName}' in '${sPath}':"
    find "${sPath}" -type f -iname "${sName}" -exec rm --force '{}' \;
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}
