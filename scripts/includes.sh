## -----------------------------------------------------------------------------
## Linux Scripts.
## Usefull functions.
##
## @package ojullien\bash\scripts
## @license MIT <https://github.com/ojullien/bash-manageservices/blob/master/LICENSE>
## -----------------------------------------------------------------------------

Install::trace() {
    String::separateLine
    String::notice "Main configuration"
    FileSystem::checkDir "\tSource directory:\t\t${m_DIR_REALPATH}" "${m_DIR_REALPATH}"
    FileSystem::checkDir "\tSystem directory:\t\t${m_DIR_SYS}" "${m_DIR_SYS}"
    FileSystem::checkDir "\tDestination app directory:\t${m_DIR_APP}" "${m_DIR_APP}"
    FileSystem::checkDir "\tDestination bin directory:\t${m_DIR_BIN}" "${m_DIR_BIN}"
    FileSystem::checkFile "\tLog file is:\t\t\t${m_LOGFILE}" "${m_LOGFILE}"
    return 0
}

Install::run() {

    String::separateLine

    if ((m_INSTALL_OPTION_REMOVE)); then
        FileSystem::removeDirectory "${m_DIR_APP}/${m_INSTALL_APP_NAME}"
        iReturn=$?
        ((0!=iReturn)) && return ${iReturn}
        else
        echo "==> ${m_INSTALL_OPTION_REMOVE}"
    fi

    FileSystem::removeDirectory "${m_DIR_BIN}/${m_INSTALL_APP_NAME}.sh"
    iReturn=$?
    ((0!=iReturn)) && return ${iReturn}

    FileSystem::copyFile "${m_INSTALL_SOURCE_APP_DIR}" "${m_DIR_APP}"
    iReturn=$?
    ((0!=iReturn)) && return ${iReturn}
    Console::waitUser

    FileSystem::copyFile "${m_INSTALL_SOURCE_BIN_FILE}" "${m_DIR_BIN}"
    iReturn=$?
    ((0!=iReturn)) && return ${iReturn}
    Console::waitUser

    String::notice -n "Change owner:"
    chown -R root:root "${m_DIR_APP}/${m_INSTALL_APP_NAME}" "${m_DIR_BIN}/${m_INSTALL_APP_NAME}.sh"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}
    ((0!=iReturn)) && return ${iReturn}
    Console::waitUser

    String::notice -n "Change directory access rights:"
    find "${m_DIR_APP}" -type d -name "${m_INSTALL_APP_NAME}" -exec chmod u=rwx,g=rx,o=rx {} \;
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}
    ((0!=iReturn)) && return ${iReturn}

    String::notice -n "Change files access rights:"
    find "${m_DIR_APP}/${m_INSTALL_APP_NAME}" -type f -exec chmod u=rw,g=r,o=r {} \;
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}
    ((0!=iReturn)) && return ${iReturn}

    String::notice -n "Change sh files access rights:"
    chmod +x "${m_DIR_BIN}/${m_INSTALL_APP_NAME}.sh"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}
    ((0!=iReturn)) && return ${iReturn}

    return ${iReturn}
}
