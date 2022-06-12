#!/bin/bash
echo "Stunnel starting up.."
port=""
desthost=""

if [ -n "$DESTINTATION" ]; then
	DEST_PORT=$DESTINTATION
fi

if [ -n "$DEST_PORT" ]; then

    if [[ $DEST_PORT == tcp* ]]; then

        desthost=$(echo "$DEST_PORT"| awk -F\: '{print $2}'|cut -c3-55)
        port=$(echo "$DEST_PORT"| awk -F\: '{print $3}')
    else

        desthost=$(echo "$DEST_PORT"| awk -F\: '{print $1}')
        port=$(echo "$DEST_PORT"| awk -F\: '{print $2}')

    fi

     if [ -n "$DESTINATION_PORT" ]; then
     	port=$DESTINATION_PORT
     fi
else
    echo "use host IP"
    if [ -n "$DESTINATION_PORT" ]; then
    	port=$DESTINATION_PORT
    	desthost=$(/sbin/ip route|awk '/default/ { print $3 }')
    else
    	echo "Assuming destination is hostmachine, but DESTINATION_PORT is required.. " 1>&2
    fi

fi

rm -rf /etc/stunnel/wildcard.*
rm -rf /etc/stunnel/pem.all
rm -rf /etc/stunnel/stunnel.conf
mkdir -p /etc/stunnel

if [[ -n "$COMMONNAME" ]]; then
     echo "Create a self-signed certificate with openssl"
     openssl req -new -newkey rsa:4096 -days 365 -nodes -x509     -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=$COMMONNAME"     -keyout /etc/stunnel/autokey.txt  -out /etc/stunnel/autokey.cert
     cat /etc/stunnel/autokey.txt > /etc/stunnel/pem.all
     cat /etc/stunnel/autokey.cert >> /etc/stunnel/pem.all
     chmod 600 /etc/stunnel/pem.all
else
    if [ -n "$CERTS" ]; then
        echo "Use old logic to create a certificate"
        echo $CERTS|base64 -d > /etc/stunnel/pem.all
        /usr/bin/chmod 600 /etc/stunnel/pem.all
    fi
fi



echo "Installing new certs"

echo "#Stunnel server configuration file
        key=/etc/stunnel/pem.all
        cert=/etc/stunnel/pem.all
        CAfile=/etc/stunnel/pem.all
        sslVersionMax=TLSv1.3
        sslVersionMin=TLSv1.2
        ciphers = HIGH:MEDIUM


        #up this number to 7 to get full log details
        #leave it at 3 to just get critical error messages
        debug=3

        [stunnel]
        accept=443
        connect=$desthost:$port

" > /etc/stunnel/stunnel.conf

if [ -n "$STUNNEL_CONFIG" ]; then
    echo $STUNNEL_CONFIG|base64 -d > /etc/stunnel/stunnel.conf
fi

echo "Bringing stunel up.. watch out."

echo "foreground=yes" > /etc/stunnel/stunnelF.conf
echo "output=/dev/stdout" >> /etc/stunnel/stunnelF.conf
cat /etc/stunnel/stunnel.conf >> /etc/stunnel/stunnelF.conf

rm /etc/stunnel/stunnel.conf

echo "STUNNEL CONFIGURATION ***"
cat /etc/stunnel/stunnelF.conf
echo "END OF STUNNEL CONFIGURATION"

/usr/bin/stunnel  /etc/stunnel/stunnelF.conf
