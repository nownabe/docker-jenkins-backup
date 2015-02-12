FROM centos:6.6
MAINTAINER nownabe <nownabe@idcf.jp>

VOLUME ["/jenkins", "/backup"]

# Update
RUN yum -yq update && yum clean all

# Install packages
RUN yum -yq install tar && yum clean all

# Install Ruby
RUN yum -yq install ruby && yum clean all

# Install s3sync
RUN curl -s http://s3.amazonaws.com/ServEdge_pub/s3sync/s3sync.tar.gz | tar zx -C /opt
RUN mkdir /etc/s3conf

# Install jenkins-backup-script
RUN curl -s -o /usr/local/bin/jenkins-backup-script https://raw.githubusercontent.com/sue445/jenkins-backup-script/master/jenkins-backup.sh && \
  chmod +x /usr/local/bin/jenkins-backup-script

# Add backup script
ADD backup.sh /usr/local/bin/backup
RUN chmod +x /usr/local/bin/backup

CMD ["/usr/local/bin/backup"]
