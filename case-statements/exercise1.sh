#!/bin/bash

case "$1" in
    start)  
        /tmp/sleepwalkingserver &
        echo $! > /tmp/sleepwalkingserver.pid
    ;;
    stop)
        kill $(cat /tmp/sleepwalkingserver.pid)
    ;;
    *)
        echo "Usage sleepwalking start|stop"
    ;;
esac