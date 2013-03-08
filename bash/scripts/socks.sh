#! /bin/bash
# sveiki@gmail.com
#
# Currently, this script will activate and deactivate an already-specified SOCKS proxy server
# (for forwarding web traffic, especially useful through an SSH tunnel). Other types of proxies can be used
# but you'll have to figure it out yourself with the 'scutil' and 'networksetup' command-line tools
################################

###
# Network device to be managed.
# more options exist other than these, run 'networksetup -listallnetworkservices' from the terminal
###
device="Airport"
#device="Built-in Ethernet"

if [[ `scutil --proxy | grep HTTPEnable | awk '{ print $3 }'` == "1" ]]; then
	proxyState="enabled"
else
	proxyState="disabled"
fi

if [[ "$proxyState" == "enabled" ]]; then
	networksetup -setwebproxystate "$device" off
	proxyState="disabled"
	imagepath="${1}Contents/Resources/proxy_disconnected.icns"
else
	networksetup -setwebproxystate "$device" on
	proxyState="enabled"
	imagepath="${1}/Contents/Resources/proxy_connected.icns"
fi

capProxyState=`echo "${proxyState:0:1}" | tr a-z A-Z`
capProxyState=$capProxyState${proxyState:1}

if [[ -e /usr/local/bin/growlnotify ]]; then
	/usr/local/bin/growlnotify --image "$imagepath" -m "Proxy Server is now $proxyState." -t "Proxy Server $capProxyState"
else
	echo "$proxyState"
fi
