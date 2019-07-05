## -----------------------------------------------------------------------------
## Linux Scripts.
## Test of the filesystem functions
##
## @package ojullien\bash\tests\sys
## @license MIT <https://github.com/ojullien/bash-sys/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Init
## -----------------------------------------------------------------------------
readonly m_TEST_DIR_TEMP="$(mktemp --directory -t shell.filesystem.test.XXXXXXXXXX)"

## -----------------------------------------------------------------------------
## Checks whether a directory exists
## -----------------------------------------------------------------------------

Test::FileSystem::checkDirTest() {
    local sValueToTest="$1"
    FileSystem::checkDir "Directory exists:\t${sValueToTest}" "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::checkDirErrorTest() {
    local sValueToTest="$1"
    FileSystem::checkDir "Directory does not exist:\t${sValueToTest}" "${sValueToTest}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Checks whether a file exists
## -----------------------------------------------------------------------------

Test::FileSystem::checkFileTest() {
    local sValueToTest
    sValueToTest="$(mktemp -p "${1}")"
    FileSystem::checkFile "File exists:\t${sValueToTest}" "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::checkFileErrorTest() {
    local sValueToTest="${1}"
    FileSystem::checkFile "File does not exist:\t${sValueToTest}" "${sValueToTest}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Copy SOURCE to DEST, or multiple SOURCE(s) to DIRECTORY
## -----------------------------------------------------------------------------

Test::FileSystem::copyFileTest() {
    local sSource="${1}"
    local sDestination="${2}"
    FileSystem::copyFile "${sSource}" "${sDestination}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::copyFileErrorTest() {
    local sSource="${1}"
    local sDestination="${2}"
    FileSystem::copyFile "${sSource}" "${sDestination}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Rename SOURCE to DEST, or move SOURCE(s) to DIRECTORY.
## -----------------------------------------------------------------------------

Test::FileSystem::moveFileTest() {
    local sSource="${1}"
    local sDestination="${2}"
    FileSystem::moveFile "${sSource}" "${sDestination}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::moveFileErrorTest() {
    local sSource="${1}"
    local sDestination="${2}"
    FileSystem::moveFile "${sSource}" "${sDestination}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Flush file system buffers
## -----------------------------------------------------------------------------

Test::FileSystem::syncFileTest() {
    FileSystem::syncFile
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Directories
## -----------------------------------------------------------------------------

Test::FileSystem::removeDirectoryTest() {
    local sValueToTest="${1}"
    FileSystem::removeDirectory "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::removeDirectoryErrorTest() {
    local sValueToTest="${1}"
    FileSystem::removeDirectory "${sValueToTest}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::cleanDirectoryTest() {

    # Init
    local -i iReturn=1
    local sDirPath sFile01Path sFile02Path
    sDirPath="$(mktemp --directory -p "${1}")"
    sFile01Path="$(mktemp -p "${sDirPath}")"
    sFile02Path="$(mktemp -p "${sDirPath}")"

    # Do the job
    FileSystem::cleanDirectory "${sDirPath}"
    iReturn=$?
    sync
    sync --file-system
    if [[ -f "${sFile01Path}" ]] || [[ -f "${sFile02Path}" ]]; then
        iReturn=1
    fi
    Test::assertTrue "${FUNCNAME[0]}" "${iReturn}"
}

Test::FileSystem::cleanDirectoryErrorTest() {
    local sValueToTest="${1}"
    FileSystem::cleanDirectory "${sValueToTest}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Compress
## -----------------------------------------------------------------------------

Test::FileSystem::compressFileTest() {

    # Init
    local sDirPath sFile01Path sFile02Path
    sDirPath="$(mktemp --directory -p "${1}")"
    sFile01Path="$(mktemp -p "${sDirPath}")"
    sFile02Path="$(mktemp -p "${sDirPath}")"

    # Do the job
    FileSystem::compressFile "${1}/compressed_zip_file" "${sDirPath}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::FileSystem::compressFileErrorTest() {
    FileSystem::compressFile "${1}/empty_zip_file" "${1}/doesnotexist"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Find and remove files
## -----------------------------------------------------------------------------

Test::FileSystem::findToRemoveTest() {

    # Init
    local -i iReturn=1
    local sDirPath sFile01Path sFile02Path
    sDirPath="$(mktemp --directory -p "${1}")"
    sFile01Path="$(mktemp -p "${sDirPath}")"
    sFile02Path="$(mktemp -p "${sDirPath}")"

    # Do the job
    FileSystem::findToRemove "${sDirPath}" "tmp.*"
    iReturn=$?
    FileSystem::syncFile
    if [[ -f "${sFile01Path}" ]] || [[ -f "${sFile02Path}" ]]; then
        iReturn=1
    fi
    Test::assertTrue "${FUNCNAME[0]}" "${iReturn}"
}

## -----------------------------------------------------------------------------
## Use lowerspace in namespace of the main function
## -----------------------------------------------------------------------------

Test::filesystem::main() {

    # Do the job
    String::separateLine
    String::notice "Testing: sys/filesystem ..."

    Test::FileSystem::checkDirTest "${m_TEST_DIR_TEMP}"
    Test::FileSystem::checkDirErrorTest "${m_TEST_DIR_TEMP}/doesnotexist"
    Test::FileSystem::checkFileTest "${m_TEST_DIR_TEMP}"
    Test::FileSystem::checkFileErrorTest "${m_TEST_DIR_TEMP}/doesnotexist.sh"
    # Keep the order
    Test::FileSystem::copyFileTest "${m_TEST_DIR_SYS}" "${m_TEST_DIR_TEMP}"
    Test::FileSystem::copyFileErrorTest "${m_TEST_DIR_SYS}/doesnotexist" "${m_TEST_DIR_TEMP}"
    Test::FileSystem::moveFileTest "${m_TEST_DIR_TEMP}/sys" "${m_TEST_DIR_TEMP}/delete_me"
    Test::FileSystem::moveFileErrorTest "${m_TEST_DIR_TEMP}/doesnotexist" "${m_TEST_DIR_TEMP}/delete_me_too"
    Test::FileSystem::syncFileTest
    Test::FileSystem::removeDirectoryTest "${m_TEST_DIR_TEMP}/delete_me"
    Test::FileSystem::removeDirectoryErrorTest "${m_TEST_DIR_TEMP}/doesnotexist"
    Test::FileSystem::cleanDirectoryTest "${m_TEST_DIR_TEMP}"
    Test::FileSystem::cleanDirectoryErrorTest "${m_TEST_DIR_TEMP}/doesnotexist"
    Test::FileSystem::compressFileTest "${m_TEST_DIR_TEMP}"
    Test::FileSystem::compressFileErrorTest "${m_TEST_DIR_TEMP}"
    Test::FileSystem::findToRemoveTest "${m_TEST_DIR_TEMP}"

}

## -----------------------------------------------------------------------------
## End
## -----------------------------------------------------------------------------
Test::FileSystem::finish() {
    rm -Rf "${m_TEST_DIR_TEMP:?}"
}
trap Test::FileSystem::finish EXIT SIGQUIT SIGTERM SIGINT ERR
