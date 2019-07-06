# Bash-ManageServices

Simple tool for disabling, stopping or starting a list of services with just one command.

*Note: I use this script for my own projects, it contains only the features I need.*

## Table of Contents

[Installation](#installation) | [Features](#features) | [Test](#test) | [Contributing](#contributing) | [License](#license)

## Installation

Requires: a Debian/Ubuntu version of linux and a Bash version ~4.4. [bash-sys](https://github.com/ojullien/bash-sys) installed.

1. [Download a release](https://github.com/ojullien/bash-manageservices/releases) or clone this repository.
2. Use [scripts/install.sh](https://github.com/ojullien/bash-manageservices/tree/master/scripts) to automatically install the application in the /opt/oju/bash project folder.
3. If needed, add `PATH="$PATH:/opt/oju/bash/bin"` to the .profile files.

## Features

This tool is a wrapper to the 'system and service manager' (systemd or SysV) functions. It allows you to disable, start or stop a list of services with just one command. The services are defined in the [config.sh](https://github.com/ojullien/bash-manageservices/tree/master/src/app) file.

```bash
Usage: manageservices.sh [options] command

command <disable | start | stop>
  disable   Disable services from starting automatically.
  start     Start services.
  stop      Stop services.

options
  -n | --no-display     Display mode. Nothing is displayed in terminal.
  -l | --active-log     Log mode. Content outputs are logged in a file.
  -w | --wait           Wait user. Wait for user input between actions.
  -h | --help           Show this help.
  -v | --version        Show the version.
```

## Test

As this tool is just a wrapper to the system and service manager functions, I didn't write any line of 'unit test' code. Sorry.

## Contributing

Thanks you for taking the time to contribute. Please fork the repository and make changes as you'd like.

As I use these scripts for my own projects, they contain only the features I need. But If you have any ideas, just open an [issue](https://github.com/ojullien/bash-manageservices/issues/new) and tell me what you think. Pull requests are also warmly welcome.

If you encounter any **bugs**, please open an [issue](https://github.com/ojullien/bash-manageservices/issues/new).

Be sure to include a title and clear description,as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.

## License

This project is open-source and is licensed under the [MIT License](https://github.com/ojullien/bash-manageservices/blob/master/LICENSE).
