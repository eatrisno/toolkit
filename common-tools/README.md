# server access toolkit
this app can help you access your server with shortcut easly

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
web	web.host.com	ubuntu	~/.ssh/key.pem
webalto	web.website.com	ubuntu	~/.ssh/key.pem
demo	demo.website.com	centos	~/.ssh/key.pem
```

run the app
alto #shortcut

```
alto demo
```

