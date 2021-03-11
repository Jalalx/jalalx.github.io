---
layout: post
title: Be productive using bash scripts on Windows! - Part 2
author: jalal
categories: [ bash, windows ]
description: "Bash scripting comes handy when you have some repetitive routines, like obtainign a token when you want to test an `Authorization` header required API! In this blog post, I'm going to explain in details how the script works."
---


Bash scripting comes handy when you have some repetitive routines, like obtainign a token when you want to test an `Authorization` header required API!

### WARNING: Copying sensitive data like production environemnt access tokens to clipboard using automated tools is a risky thing. Consider checking the clipboard tool source code to make sure it does only what it meant to do. Also, remember to use these pranctices for development environment only.


In the [previous post](/be-productive-using-bash-scripts-on-windows-part-1/) we had a script that gets username and password and automatically obtains an `access_token` and writes it to the system's clipboard. But how it actually works?

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

Let's start with the first line. The `#!/bin/sh` is a symbolic link to `sh` (or `bash` on debian linux distributions) and specifies that this file is a shell script. You can also use `#!/bin/bash`. There are some small difference and you can read more about it here: [What is the difference between #!/bin/sh and #!/bin/bash?
](https://askubuntu.com/questions/141928/)

The second line simply prints the message using `echo` command.

In the lines 4 and 5, it defines two variables and initial them with two parameters we pass through as `$1` and `$2`. So when We run `./some-script.sh foo bar` the `$1` is `foo` and the `$2` is `bar`. Easy, right?

Using variables in the previous step, in the line 7, it creates a new variable `REQUEST_BODY` which contains a JSON string containing the passed email and password. But notice to the `"'"`. It's because we want to make JSON surround passed variables in double-quotations.

And finally, the actual thing happens at line 12. `curl` is a famous cross-platform tool to make http calls using command line. It actually does alot more but in here, We simply want to make a `HTTP POST` request. the `-s` makes a silet request. The `--location` makes it follow the HTTP 3XX redirects but it won't send the credentials to the redirected location for security reasons. You can read moe about it in the [`--location` man page](https://curl.se/docs/manpage.html#-L). `--request POST` makes a HTTP `POST` request to the given url and `--header 'Content-Type: application/json'` sets the `Content-Type` header value. And finally the `--data-raw` sends the specified data as a request body.

You can call the first part of the command to see the output. Remeber to replace the `<...>` placeholders with actuall values:
```sh
curl -s --location --request POST 'http://<your-identity-server-url>/api/v1/account/token' --header 'Content-Type: application/json' --data-raw '{"email":"<username>","password": "<password>"}" 
```

Lets say the output will be something like this:
```json
{
    "result": {
        "access_token": "<generated token>",
        "expires_in: <a number>"
    }
}
```

But all we want is the `access_token` value. So we use `jq` tool to get it! `jq` can provide filtering on JSON data. It gets data from standard input and writes the filtered result into standard output. So piping `jq  -j .result.access_token` to the previous command will filter the `curl` JSON response to just the `access_token` value. the `-j` option (or `--join-output`) in the `jq` command will not append a new line to the `jq` result.

And now `awk`. It's actually a scripting language mostly used for pattern scanning and processing. Piping the `access_token` value to `awk '{print "Bearer "$1}'` will result in an output like `Bearer <generated token>`. The `print` command writes the specified string literal to the standard output. The `"Bearer "` is a constant literal concatinated to to the `$1` which is the string value obtained from execution of the previous `jq` command.

And finally, `clipboard` part. [Clipboard](https://www.npmjs.com/package/clipboard-cli) is a NodeJs based tool. It simply reads the standard input that is written by the `awk` command and writes it to the clipboard memory. So all you have to do is just press one of the most useful shortcut key combinations of all time, the `Ctrl+V`!