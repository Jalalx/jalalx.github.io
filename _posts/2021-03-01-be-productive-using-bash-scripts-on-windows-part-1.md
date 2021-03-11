---
layout: post
title: Be productive using bash scripts on Windows! - Part I
author: jalal
categories: [ bash, windows ]
description: "Bash scripting comes in handy when you have some repetitive routines, like obtaining a token when you want to test an `Authorization` header required API! In this blog post, we're going to write some scripts to automate the process of getting a new bearer token from an Identity Server."
---

Bash scripting comes in handy when you have some repetitive routines, like obtaining a token when you want to test an `Authorization` header required API!

In this blog post, we're going to write some scripts to automate the process of getting a new bearer token from an Identity Server.


### WARNING: Copying sensitive data like production environment access tokens to the clipboard using automated tools is a risky thing. Consider checking the clipboard tool source code to make sure it does what it is meant to do. Also, remember to use this tool in the development environment only.


This instruction works for both Windows and Linux machines. I usually code on a Windows 10 powered machine, and I found [Git-Bash](https://git-scm.com/downloads) very handy. I also installed [Windows Terminal](https://github.com/microsoft/terminal) which makes working with multiple terminal windows easy.

1. First, make sure you have [NodeJs](https://nodejs.org/en/download/) installed, then run `npm install clipboard-cli`. This will install the `clipboard` command line tool.

2. Then install `jq`. You will need it for parsing JSON responses. You can install it using [WinGet](https://github.com/microsoft/winget-cli) by running `winget install jq` or if you're on Debian based Linux, just run `sudo apt-get install jq`

3. Do you have `curl` installed? It comes with most Linux distros but on Windows download and install it from [curl website](https://curl.se/windows/).

4. If you're on Windows, make sure you have Git-Bash installed. Then create a `copy-token.sh` file like this:

    ```sh
    #!/bin/sh
    echo 'Fetching a new token. Please wait...'

    EMAIL=$1
    PSWD=$2

    REQUEST_BODY='{
        "email":"'"$EMAIL"'",
        "password": "'"$PSWD"'"
    }'

    curl -s --location --request POST 'http://<your-identity-server-url>/api/v1/account/token' --header 'Content-Type: application/json' --data-raw "$REQUEST_BODY" | jq -j .result.access_token | awk '{print "Bearer "$1}' | clipboard

    echo 'A new token is copied to the Clipboard!'
    ```

    And make sure you replace `<your-identity-server-url>` with your identity server URL.

5. Now you can run the script. Just call: `./copy-token.sh <myusername> <mypassword>` and have the token in your clipboard!

I just wanted to show an example of how bash scripting allows gluing tools together and automating boring tasks.

This wasn't a long blog post, but surely a time-consuming instruction for you. So I'll describe each step of the bash code [in the part 2](/be-productive-using-bash-scripts-on-windows-part-2/).