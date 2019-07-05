## -----------------------------------------------------------------------------
## Linux Scripts.
## Test of the ssh functions
##
## @package ojullien\bash\tests\sys
## @license MIT <https://github.com/ojullien/bash-sys/blob/master/LICENSE>
## -----------------------------------------------------------------------------

# Remove these 3 lines once you have configured this file
echo "The 'tests/sys/ssh_test.sh' file is not configured !!!"
String::error "The 'tests/sys/ssh_test.sh' file is not configured !!!"
exit 3

## -----------------------------------------------------------------------------
## Constant
## -----------------------------------------------------------------------------

declare ENV_SSH="${HOME}/.ssh/agent.env"
declare ENV_SSH_ERROR="${HOME}/.ssh/doesnotexist.env"
declare KEY_SSH="${HOME}/.ssh/id_ed25519.key"
declare KEY_SSH_ERROR="${HOME}/.ssh/doesnotexist.key"

## -----------------------------------------------------------------------------
## Tests
## -----------------------------------------------------------------------------

Test::SSH::errorTest() {
    SSH::error "Hello SSH"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::SSH::loadAgentEnvParameterTest() {
    SSH::loadAgentEnv
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::SSH::loadAgentEnvErrorTest() {
    SSH::loadAgentEnv "${ENV_SSH_ERROR}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::SSH::loadAgentEnvTest() {
    SSH::loadAgentEnv "${ENV_SSH}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::SSH::startAgentParameterTest() {
    SSH::startAgent
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::SSH::startAgentTest() {
    SSH::startAgent "${ENV_SSH}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

Test::SSH::addKeyToAgentParameterTest() {
    SSH::addKeyToAgent
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::SSH::addKeyToAgentErrorTest() {
    SSH::addKeyToAgent "${ENV_SSH}" "${KEY_SSH_ERROR}"
    Test::assertFalse "${FUNCNAME[0]}" "$?"
}

Test::SSH::addKeyToAgentTest() {
    SSH::addKeyToAgent "${ENV_SSH}" "${KEY_SSH}"
    Test::assertTrue "${FUNCNAME[0]}" "$?"
}

## -----------------------------------------------------------------------------
## Use lowerspace in namespace of the main function
## -----------------------------------------------------------------------------

# shellcheck source=/dev/null
. "${m_DIR_SYS}/ssh.sh"

Test::ssh::main() {
    String::separateLine
    String::notice "Testing: sys/ssh ..."

    Test::SSH::errorTest
    Test::SSH::loadAgentEnvParameterTest
    Test::SSH::loadAgentEnvErrorTest
    Test::SSH::loadAgentEnvTest
    Test::SSH::startAgentParameterTest
    Test::SSH::startAgentTest
    Test::SSH::addKeyToAgentParameterTest
    Test::SSH::addKeyToAgentErrorTest
    Test::SSH::addKeyToAgentTest
}
