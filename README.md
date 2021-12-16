# mic-cli-bash
A Simple CLI written in BASH for interracting with Telenor IoT Cloud's REST API. This is suitable for demo and development or inspiration for your own systems.

__NOTE:__ *mic-cli-bash is not intended for direct use in production. It is maintained and supported on a best effort basis and carries no guarantee!*

## Supported Systems
### Mac OS

`% bash --version
GNU bash, version 3.2.57(1)-release (x86_64-apple-darwin21)
Copyright (C) 2007 Free Software Foundation, Inc.`

### Linux
*untested*

### Windows
*untested*

## Installation

1. Clone or download & extract the repository to a suitable location
2. Add execute priveleges `% chmod u+x micCLI.sh`

## Usage

`% ./micCLI.sh`

### settings.conf
For repeated operations, micCLI.sh supports a `settings.conf` file, which it expects to find in the same directory as `micCLI.sh`. `settings.conf` allows you to preconfigure settings for your instance for efficiency.

Although it is possible to store UserName and Password in the `settings.conf` file, please be aware of the security risk, as the username and password is stored in plain text.

- __never__ share this script with stored credentials
- __never__ store credentials longer than is necessary
- always ensure access to your credentials are protected

`micCLI.sh` will remind you to clear your credentials. 

`settings.conf` should be configured as follow

```
instanceName:demo
username:mic_user_name
password:mic_password
domain:domain_name
```
- instanceName: if the URL is demo.mic.telenorconnexion.com, the instanceName will be "demo" (strip the .mic.telenorconnexion.com)
- username & password: the username and password of the user; ensure the user has sufficient priveleges for the actions
- domain: the domain id to work with (__do not__ include the path)

### Interractive
if a `settings.conf` file is not found, or the parameter is missing, `micCLI.sh` will prompt the user for the required information. The format is as for `settings.conf`. 

## Functionality
- List Things : List the total number of things in the given domain that the user has visibility of
- Create Thing : Create a thing in the given domain. This is intended to create a thing with a specific/custom name (for example IMSI or IMEI), rather than the MIC generated name.
    - `./micCLI.sh` will ask for a thingName, the user should provide the custom name, such as IMSI

## Notes
`micCLI.sh` performs minimal error checking. For example it will not validate the format of the parameters or information provided by the user, it will trust that is is correct. This may result in a simple error (for example unable to authenticate) or a much more serious error (deletion of data) - exercise caution! Read-Only operations (List *) should be relatively safe!

## Bugs & Support
`micCLI.sh` is supported and maintained on a best effort basis. No guarantees are provided. It is intended for demonstration, development, inspiration and learning the MIC API. It is __not__ intended for production use.

### Start IoT Forum
You can discuss this tool in the [Start IoT Forum](https://forum.startiot.telenorconnexion.com)
### GitHub Issues
You can raise bugs/request features in [GitHub](https://github.com/TelenorStartIoT/mic-cli-bash/issues)