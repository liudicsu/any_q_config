#!/bin/bash
cd $(dirname $0)
ps axu|grep supervisord|grep -v grep |awk '{print $2}'|xargs -n 1 kill -9
supervisord -c supervisord.conf
