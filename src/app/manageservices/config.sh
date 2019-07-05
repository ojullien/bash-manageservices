## -----------------------------------------------------------------------------
## Linux Scripts.
## Services manager app configuration file.
##
## @package ojullien\bash\app\manageservices
## @license MIT <https://github.com/ojullien/bash-manageservices/blob/master/LICENSE>
## -----------------------------------------------------------------------------

readonly m_SERVICES_DISABLE="bind9 exim4 postfix smbd nmbd telnet rlogin rexec ftp automount named lpd inetd"
readonly m_SERVICES_STOP="apache2 fail2ban php7.3-fpm php7.2-fpm mysql"
readonly m_SERVICES_START="mysql php7.3-fpm php7.2-fpm apache2 fail2ban"

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
ManageServices::trace() {
    String::separateLine
    String::notice "App configuration: ManageServices"
    String::notice "\tServices to disable:"
    String::notice  "\t\t${m_SERVICES_DISABLE}"
    String::notice "\tServices to stop:"
    String::notice  "\t\t${m_SERVICES_STOP}"
    String::notice "\tServices to start:"
    String::notice  "\t\t${m_SERVICES_START}"
    return 0
}
