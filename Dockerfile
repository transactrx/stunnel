FROM centos:7

COPY entrypoint.sh /opt/entrypoint.sh

RUN /usr/bin/chmod +x /opt/entrypoint.sh && \
	/usr/bin/yum -y install stunnel.x86_64

EXPOSE 443

ENTRYPOINT ["/opt/entrypoint.sh"] 
