---
layout: post
title: Be productive using bash scripts - On Windows!
---

Bash scripting comes handy when you have some repetitive routines, like obtainign a token when you want to test an `Authorization` header required API!

This instruction works for both Windows and Linux machines.

1. First, make sure you have [NodeJs](https://nodejs.org/en/download/) installed then run `npm install clipboard-cli`
2. Then install `jq`. You need it for parsing JSON responses. You can install it using [WinGet](https://github.com/microsoft/winget-cli) by running `winget install jq` or if you're on debian based linux, just run `sudo apt-get install jq`
4. Do you have `curl` installed? It cames with most linux distros but on Windows download and install it from [curl website](https://curl.se/windows/).
3. If you're on Windows, make sure you have GitBash installed. Then create a `copy-token.sh` file like this:

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

4. Now you can run the script. Just call: `./copy-token.sh <myusername> <mypassword>` and have the token in your clipboard!

I'll describe each step of the bash code later...