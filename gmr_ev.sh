#!/bin/sh

LOGFILE=


# Setup custom notifications here
function notify_play() {
    echo "> Event: PLAYING!"
}

function notify_pause() {
    echo "> Event: PAUSED!"
}

function notify_stop() {
    echo "> Event: STOPPED!"
}


if [ -z "$LOGFILE" ]; then
    echo "You must run the install script first!"
    exit
fi

# Wait till logfile is available
if [ ! -f $LOGFILE ]; then
    echo "$LOGFILE doesn't exist! Waiting for it to be created..."
    while [ ! -f $LOGFILE ]; do sleep 1; done
fi

tail -Fn0 $LOGFILE | \
while read log ; do
    echo "$log" | grep -q "TransportState: "
    if [ $? = 0 ]
    then

    	# Playing 
    	echo "$log" | grep -q "PLAYING"
    	if [ $? = 0 ]
    	then
    		notify_play
    	fi

    	# Paused 
    	echo "$log" | grep -q "PAUSED_PLAYBACK"
    	if [ $? = 0 ]
    	then
            notify_pause
    	fi

    	# Stopped 
    	echo "$log" | grep -q "STOPPED"
    	if [ $? = 0 ]
    	then
    		notify_stop
    	fi

    fi
done
