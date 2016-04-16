#!/bin/sh

GMR_INIT_SCRIPT=/etc/init.d/gmediarenderer
DEFAULT_LOGFILE=/tmp/gmrender.log 		# Default logfile

for i in "$@"
do
case $i in
    --logfile=*)
    DEFAULT_LOGFILE="${i#*=}"
    ;;
esac
done

# Replace the DEFAULT_LOGFILE variable in gmr_ev.sh with specified logfile
sed -i -e 's|DEFAULT_LOGFILE=\(.*\)|DEFAULT_LOGFILE='"$DEFAULT_LOGFILE"'|g' gmr_ev.sh

# Install gmr_ev script
chmod +x ./gmr_ev.sh
cp ./gmr_ev.sh /usr/local/sbin/

# Add cronjob
crontab -l | { cat; echo "@reboot /usr/local/sbin/gmr_ev"; } | crontab -

DEFAULT_LOGFILE=$(echo "$DEFAULT_LOGFILE" | sed 's/\//\\\//g')
if grep -q 'logfile' $GMR_INIT_SCRIPT; then
	prev_logfile=$(grep --only-matching "logfile=.*" $GMR_INIT_SCRIPT | awk -F\= '{gsub(/"/,"",$2);print $2}')
	prev_logfile=$(echo "$prev_logfile" | sed 's/\//\\\//g')
    if [ "$prev_logfile" != "$DEFAULT_LOGFILE" ]; then
    	echo "Logfile already set to $prev_logfile..."
    	exit
    fi
else
	# Set gmediarender's logfile as specified logfile
	sed -i -e '/--gstout-initial-volume-db=$INITIAL_VOLUME_DB/ s/$/ --logfile='"$DEFAULT_LOGFILE"'/' $GMR_INIT_SCRIPT
fi