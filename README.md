# Bash-Sys

Bash framework. Provides generic functionality to facilitate development of my personal bash scripts.

## Table of Contents

[Installation](#installation) | [Features](#features) | [Documentation](#documentation) | [Test](#test) | [Contributing](#contributing) | [License](#license)

## Installation

Require a Debian/Ubuntu version of linux and a Bash version ~4.4.

1. [Download a release](https://github.com/ojullien/bash-sys/releases) or clone this repository.
2. Use [scripts/install.sh](https://github.com/ojullien/bash-sys/tree/master/scripts) to automatically install the project in the /opt/ folder.
3. If needed, add `PATH="$PATH:/opt/oju/bash-sys/bin"` to the .profile files.

## Features

- [sys](https://github.com/ojullien/bash-sys/tree/master/src/sys) contains scripts that offer useful functions:
  - db/mariadb.sh: MariaDB wrapper functions.
  - db/mysql.sh: MySQL wrapper functions.
  - bashversion.sh: Tests the current bash version.
  - config.sh: Load local app configuration file.
  - constant.sh: Core constants.
  - filesystem.sh: file system wrapper functions.
  - ftp.sh: FTP wrapper functions.
  - openssl.sh: openssl-req and openssl-x509 wrapper functions.
  - option.sh: common command line options functions.
  - package.sh: package manager (dpkg, apt, aptitude)
  - runasroot.sh: Tests the user credentials.
  - service.sh: service manager (use system/d.sh or system/v.sh)
  - ssh.sh: SSH functions.
  - string.sh: string functions.
  - system/d.sh: System V service manager.
  - system/v.sh: systemd service manager.

## Documentation

I wrote and I use these scripts for my own projects. And, unfortunately, I do not provide exhaustive documentation. Please read the code and the comments ;)

## Test

I wrote few lines of 'unit test' code. No more, sorry.

## Contributing

Thanks you for taking the time to contribute. Please fork the repository and make changes as you'd like.

As I use these scripts for my own projects, it contains only the features I need. But If you have any ideas, just open an [issue](https://github.com/ojullien/bash-sys/issues/new) and tell me what you think. Pull requests are also warmly welcome.

If you encounter any **bugs**, please open an [issue](https://github.com/ojullien/bash-sys/issues/new).

Be sure to include a title and clear description,as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.

## License

This project is open-source and is licensed under the [MIT License](https://github.com/ojullien/bash-sys/blob/master/LICENSE).
