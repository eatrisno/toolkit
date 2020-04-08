# Databases toolkit
### install
```
curl -sSk https://raw.githubusercontent.com/eatrisno/toolkit/master/common-tools/install.sh | bash
```
### uninstall
```
curl -sSk https://raw.githubusercontent.com/eatrisno/toolkit/master/common-tools/uninstall.sh | bash
```
access server with config file server.list
### edit your server.list
```
nano /usr/local/opt/altoshift/common-tools/server.list
```

shortcut	host	user	keyfile

sample:
```
es001	es001.altoshift.com	ubuntu	~/.ssh/New-Altoshift-Prod.pem
demo	demo.altoshift.com	ubuntu	~/.ssh/New-Altoshift-Dev.pem
staging	staging.altoshift.com	ubuntu	~/.ssh/New-Altoshift-Dev.pem
prod	client.altoshift.com	ubuntu	~/.ssh/New-Altoshift-Prod.pem
web	altoshift.com	ubuntu	~/.ssh/New-Altoshift-Dev.pem
```

run the app
alto #shortcut

```
alto demo
```

