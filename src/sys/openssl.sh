## -----------------------------------------------------------------------------
## Linux Scripts.
## OpenSSL common wrapper functions.
##
## @package ojullien\bash\sys
## @license MIT <https://github.com/ojullien/bash-sys/blob/master/LICENSE>
## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
## Verify key consistency
## -----------------------------------------------------------------------------
MyOpenSSL::checkKey() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: MyOpenSSL::checkKey <input filename to read a key from>"
        return 1
    fi

    # Init
    local sFile="$1"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sFile}" ]]; then
        String::separateLine
        openssl pkey -inform PEM -in "${sFile}" -text_pub -noout -check
        iReturn=$?
        String::separateLine
    else
        String::error "MyOpenSSL::checkKey: file '${sFile}' does not exist."
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Generate a PKCS#8 private and public key using elliptic curves algorithm.
## -----------------------------------------------------------------------------
MyOpenSSL::generateKeypair() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: MyOpenSSL::generatePrivateKeypair <name> <filename>"
        return 1
    fi

    # Init
    local sKeyFile="$2" sName="$1"
    local -i iReturn=1

    # Do the job
    String::notice -n "generate PKCS#8 '${sName}' keypair using elliptic curves algorithm:"
    openssl genpkey -out "${sKeyFile}" -outform PEM -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -pkeyopt ec_param_enc:named_curve \
        && chmod 640 "${sKeyFile}"
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Display the contents of CSR file in a human-readable output format
## -----------------------------------------------------------------------------
MyOpenSSL::verifyRequest() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: MyOpenSSL::verifyRequest <input filename to read a request from>"
        return 1
    fi

    # Init
    local sFile="$1"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sFile}" ]]; then
        String::separateLine
        openssl req -noout -text -verify -in "${sFile}" -nameopt multiline
        iReturn=$?
        String::separateLine
    else
        String::error "MyOpenSSL::verifyRequest: file '${sFile}' does not exist."
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Generates a new PKCS#10 certificate request using information specified in
## the [req] section of the configuration file.
## -----------------------------------------------------------------------------
MyOpenSSL::createRequest() {

    # Parameters
    if (($# != 4)) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]] || [[ -z "$4" ]]; then
        String::error "Usage: MyOpenSSL::createRequest <name> <file to read the private key from> <configuration file> <output filename to write>"
        return 1
    fi

    # Init
    local sKeyFile="$2" sName="$1" sConf="$3" sCsrFile="$4"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sKeyFile}" ]] && [[ -f "${sConf}" ]]; then
        String::notice -n "Create the '${sName}' certificate signing request:"
        openssl req -new -outform PEM -out "${sCsrFile}" -config "${sConf}" -key "${sKeyFile}" -keyform PEM
        iReturn=$?
        String::checkReturnValueForTruthiness ${iReturn}
    else
        String::error "MyOpenSSL::createRequest: file '${sKeyFile}' does not exist."
        String::error "MyOpenSSL::createRequest: file '${sConf}' does not exist."
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Display the contents of a certificate file in a human-readable output format
## -----------------------------------------------------------------------------
MyOpenSSL::displayCertificate() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: MyOpenSSL::displayCertificate <input filename to read a certificate from>"
        return 1
    fi

    # Init
    local sFile="$1"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sFile}" ]]; then
        String::separateLine
        openssl x509 -noout -text -inform PEM -in "${sFile}" -nameopt multiline,-esc_msb,utf8
        iReturn=$?
        String::separateLine
    else
        String::error "MyOpenSSL::viewCertificate: file '${sFile}' does not exist."
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Check the certificate extensions and determines what the certificate can be
## used for
## -----------------------------------------------------------------------------
MyOpenSSL::purposeCertificate() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: MyOpenSSL::purposeCertificate <input filename to read a certificate from>"
        return 1
    fi

    # Init
    local sFile="$1"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sFile}" ]]; then
        String::separateLine
        openssl x509 -noout -purpose -inform PEM -in "${sFile}"
        iReturn=$?
        String::separateLine
    else
        String::error "MyOpenSSL::viewCertificate: file '${sFile}' does not exist."
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## The verify command verifies certificate chains.
## -----------------------------------------------------------------------------
MyOpenSSL::verifyCertificate() {

    # Parameters
    if (($# != 2)) || [[ -z "$1" ]] || [[ -z "$2" ]]; then
        String::error "Usage: MyOpenSSL::verifyCertificate <A file of trusted certificates> <input filename to read a certificate from>"
        return 1
    fi

    # Init
    local sCACrtFile="$1" sCrtFile="$2"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sCACrtFile}" ]] && [[ -f "${sCrtFile}" ]]; then
        String::separateLine
        openssl verify -show_chain -policy_print -policy_check -x509_strict -verbose -CAfile "${sCACrtFile}" "${sCrtFile}"
        iReturn=$?
        String::separateLine
    else
        String::error "MyOpenSSL::verifyCertificate: file '${sCACrtFile}' does not exist."
        String::error "MyOpenSSL::verifyCertificate: file '${sCrtFile}' does not exist."
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Create and self-sign the root CA certificate root based on the CSR.
## The openssl ca command takes its configuration from the [ca] section of the configuration file.
## -----------------------------------------------------------------------------
MyOpenSSL::createSelfSignedCertificate() {

    # Parameters
    if (($# != 6)) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]] || [[ -z "$4" ]] || [[ -z "$5" ]] || [[ -z "$6" ]]; then
        String::error "Usage: MyOpenSSL::createSelfSignedCertificate <csr file> <key file> <crt file> <conf file> <extention> <name>"
        return 1
    fi

    # Init
    local sCsrFile="$1" sKeyFile="$2" sCrtFile="$3" sConf="$4" sExtention="$5" sName="$6" sSerial
    local -i iReturn=1

    # Do the job
    sSerial=$(openssl rand -hex 20)
    if [[ -f "${sKeyFile}" ]] && [[ -f "${sCsrFile}" ]] && [[ -f "${sConf}" ]]; then
        String::notice -n "Create the self-signed '${sName}' certificate:"
        openssl x509 -req -inform PEM -in "${sCsrFile}" -keyform PEM -signkey "${sKeyFile}" -days 1826\
         -outform PEM -out "${sCrtFile}" -extfile "${sConf}" -extensions "${sExtention}" -set_serial 0x${sSerial}
        iReturn=$?
        String::checkReturnValueForTruthiness ${iReturn}
    else
        String::error "MyOpenSSL::createSelfSignedCertificate: file '${sKeyFile}' does not exist."
        String::error "MyOpenSSL::createSelfSignedCertificate: file '${sCsrFile}' does not exist."
        String::error "MyOpenSSL::createSelfSignedCertificate: file '${sConf}' does not exist."
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Sign a certificate request using a CA certificate.
## -----------------------------------------------------------------------------
MyOpenSSL::signCertificate() {

    # Parameters
    if (($# != 8)) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]] || [[ -z "$4" ]] || [[ -z "$5" ]] || [[ -z "$6" ]] || [[ -z "$7" ]] || [[ -z "$8" ]]; then
        String::error "Usage: MyOpenSSL::signCertificate <CA certificate to be used for signing> <CA private key to sign a certificate with> <CA serial number file to use> <File containing certificate extensions to use> <The section to add certificate extensions from> <input filename to read a certificate from> <name> <output filename to write>"
        return 1
    fi

    # Init
    local sCACert="$1" sCAKey="$2" sCASerial="$3" sConf="$4" sExtention="$5" sCsrFile="$6" sName="$7" sCrtFile="$8"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sCAKey}" ]] && [[ -f "${sCsrFile}" ]] && [[ -f "${sConf}" ]] && [[ -f "${sCACert}" ]]; then
        String::notice -n "Create the signed '${sName}' certificate:"
        openssl x509 -req -inform PEM -in "${sCsrFile}" -CA "${sCACert}" -CAkey "${sCAKey}" -days 365\
         -outform PEM -out "${sCrtFile}" -extfile "${sConf}" -extensions "${sExtention}" -CAcreateserial -CAserial "${sCASerial}"
        iReturn=$?
        String::checkReturnValueForTruthiness ${iReturn}
    else
        [[ -f "${sCsrFile}" ]] || String::error "MyOpenSSL::signCertificate: file '${sCsrFile}' does not exist."
        [[ -f "${sCACert}" ]] || String::error "MyOpenSSL::signCertificate: file '${sCACert}' does not exist."
        [[ -f "${sCAKey}" ]] || String::error "MyOpenSSL::signCertificate: file '${sCAKey}' does not exist."
        [[ -f "${sConf}" ]] || String::error "MyOpenSSL::signCertificate: file '${sConf}' does not exist."
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Output additional information about the PKCS#12 file structure, algorithms used and iteration counts.
## -----------------------------------------------------------------------------
MyOpenSSL::outputPKCS12Bundle() {

    # Parameters
    if (($# != 1)) || [[ -z "$1" ]]; then
        String::error "Usage: MyOpenSSL::outputBundle <filename of the PKCS#12 file to be parsed>"
        return 1
    fi

    # Init
    local sFile="$1"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sFile}" ]]; then
        String::separateLine
        openssl pkcs12 -nodes -info -in "${sFile}" -passin pass:""
        iReturn=$?
        String::separateLine
    else
        String::error "MyOpenSSL::outputBundle: file '${sFile}' does not exist."
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Pack the private key and the certificate into a PKCS#12 bundle.
## Additional certificates may be added, typically the certificates comprising
## the chain up to the Root CA.
## -----------------------------------------------------------------------------
MyOpenSSL::createPKCS12bundle() {

    # Parameters
    if (($# != 4)) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]] || [[ -z "$4" ]]; then
        String::error "Usage: MyOpenSSL::createPKCS12bundle <friendly name> <filename to read certificates and private keys from> <file to read private key from> <filename to write the PKCS#12 file to>"
        return 1
    fi

    # Init
    local sName="$1" sCrtFile="$2" sKeyFile="$3" sP12="$4"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sCrtFile}" ]] && [[ -f "${sKeyFile}" ]]; then
        String::notice -n "Create the PKCS#12 '${sName}' bundle:"
        openssl pkcs12 -export -nodes -name "${sName}" -in "${sCrtFile}" -inkey "${sKeyFile}" -out "${sP12}" -passout pass:""
        iReturn=$?
        String::checkReturnValueForTruthiness ${iReturn}
    else
        [[ -f "${sCrtFile}" ]] || String::error "MyOpenSSL::createPKCS12bundle: file '${sCrtFile}' does not exist."
        [[ -f "${sKeyFile}" ]] || String::error "MyOpenSSL::createPKCS12bundle: file '${sKeyFile}' does not exist."
    fi

    return ${iReturn}
}

## -----------------------------------------------------------------------------
## Pack a chain certificate into a PKCS#12 bundle
## -----------------------------------------------------------------------------
MyOpenSSL::createPKCS12Chainbundle() {

    # Parameters
    if (($# != 6)) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]] || [[ -z "$4" ]] || [[ -z "$5" ]] || [[ -z "$6" ]]; then
        String::error "Usage: MyOpenSSL::createPKCS12Chainbundle <friendly name> <filename to read certificates and private keys from> <file to read private key from> <friendly name for additional certificates> <filename to read additional certificates from> <filename to write the PKCS#12 file to>"
        return 1
    fi

    # Init
    local sName="$1" sCrtFile="$2" sKeyFile="$3" sOtherName="$4" sOtherCrtFile="$5" sP12="$6"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sCrtFile}" ]] && [[ -f "${sKeyFile}" ]] && [[ -f "${sOtherCrtFile}" ]]; then
        String::notice -n "Create the PKCS#12 '${sName}' bundle:"
        openssl pkcs12 -export -nodes -name "${sName}" -in "${sCrtFile}" -inkey "${sKeyFile}" -caname "${sOtherName}" -certfile "${sOtherCrtFile}" -out "${sP12}" -passout pass:""
        iReturn=$?
        String::checkReturnValueForTruthiness ${iReturn}
    else
        [[ -f "${sCrtFile}" ]] || String::error "MyOpenSSL::createPKCS12Chainbundle: file '${sCrtFile}' does not exist."
        [[ -f "${sKeyFile}" ]] || String::error "MyOpenSSL::createPKCS12Chainbundle: file '${sKeyFile}' does not exist."
        [[ -f "${sOtherCrtFile}" ]] || String::error "MyOpenSSL::createPKCS12Chainbundle: file '${sOtherCrtFile}' does not exist."
    fi

    return ${iReturn}
}


## -----------------------------------------------------------------------------
## PEM bundles are created by concatenating other PEM-formatted files. The most
## common forms are “cert chain”, “key + cert”, and “key + cert chain”.
## -----------------------------------------------------------------------------
MyOpenSSL::createPEMBundle() {

    # Parameters
    if (($# != 4)) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]] || [[ -z "$4" ]]; then
        String::error "Usage: MyOpenSSL::CreatePEMBundle <friendly operation name><first PEM-formatted file> <second PEM-formatted file> <output filename to write the chain>"
        return 1
    fi

    # Init
    local sName="$1" sIn01="$2" sIn02="$3" sOut="$4"
    local -i iReturn=1

    # Do the job
    if [[ -f "${sIn01}" ]] && [[ -f "${sIn02}" ]]; then
        String::notice -n "Create the '${sName}' PEM bundle:"
        cat "${sIn01}" "${sIn02}" > "${sOut}"
        iReturn=$?
        String::checkReturnValueForTruthiness ${iReturn}
    else
        [[ -f "${sIn01}" ]] || String::error "MyOpenSSL::CreatePEMBundle: file '${sIn01}' does not exist."
        [[ -f "${sIn02}" ]] || String::error "MyOpenSSL::CreatePEMBundle: file '${sIn02}' does not exist."
    fi

    return ${iReturn}
}
