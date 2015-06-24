#!/bin/bash
# Copyright (c) 2015 Spinpunch, Inc. All Rights Reserved.
# See License.txt for license information.

mkdir -p web/static/js

#echo "127.0.0.1 dockerhost" >> /etc/hosts
#/etc/init.d/networking restart

echo configuring mysql

# SQL!!!
set -e

get_option () {
	local section=$1
	local option=$2
	local default=$3
	ret=$(my_print_defaults $section | grep '^--'${option}'=' | cut -d= -f2-)
	[ -z $ret ] && ret=$default
	echo $ret
}

# ------------------------

#echo starting postfix
#/etc/init.d/postfix restart

#echo starting redis
#redis-server &

echo starting react processor	
cd /go/src/github.com/mattermost/platform/web/react && npm start &

echo starting go web server
cd /go/src/github.com/mattermost/platform/; go run mattermost.go -config=config_docker.json &

echo starting compass watch
cd /go/src/github.com/mattermost/platform/web/sass-files && compass watch
