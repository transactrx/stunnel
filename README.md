# Stunnel HTTPS Appliance

### Easy way to add SSL to your webapps

The first thing you need to do is to load all of your certs into an environment variable which we'll call CERTS. Since the PEM format contains spaces and carriage returns, it is necessary base64 encode the certs.  All of this is very simple, here is and example:

```bash
cat server.key > combined.pem
cat ca.cert >> combined.pem
cat ca.cert2 >> combined.pem
cat server.cert >> combined.pem
export CERTS=$(cat combined.pem |base64)

```
Now you can use the env variable $CERTS in the docker commands like examples below:

##### Environment Variables in the container.  All optional when used to link to a different container.
```bash	
DESTINATION_PORT="" #You can be used to help determine the correct port when linked container exposes multiple ports. 
DESTINATION= "tcp://xxxx.xxx.xxx.xxx:PORT"
```

##### Using variable:
```bash
#In this example we are listening on port 443, and then connect to the locally running docker host on port 8080.
docker run -it -d -p 443:443 --name ssltunnel -e "DESTINATION_PORT=8080" -e "CERTS=$CERTS" melaraj/stunnel
#Here we are listening on port 443 encrypted and then out to myserver.mydomain.com on port 8080
docker run -it -d -p 443:443 --name sslForRemote -e "DESTINATION=tcp://myserver.mydomain.com:8080" melaraj/stunnel
```

##### Linking to other containers:
```bash
docker run -d -it --name webapp tomcat:8-jre8
docker run --link webapp:dest -d -it --name ssltunnel -p 443:443 -e "CERTS=$CERTS" melaraj/stunnel
```
Stunnel is now listening on port 443 and forwarding to port 8080 on tomcat.

Enjoy! 