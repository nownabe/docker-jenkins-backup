#!/bin/bash

set -eux

jenkins_home="/jenkins_backup/jenkins_home"
backup_dir="/jenkins_backup/backups"
s3_url=${BACKUP_BUCKET}:${BACKUP_PREFIX:-""}

: "Configure S3"
s3config="/etc/s3conf/s3config.yml"
cat <<EOF > ${s3config}
aws_access_key_id: ${AWS_ACCESS_KEY_ID}
aws_secret_access_key: ${AWS_SECRET_ACCESS_KEY}
aws_calling_format: "SUBDOMAIN"
s3sync_native_charset: UTF-8
EOF

#[ -v AWS_S3_HOST ] && echo "aws_s3_host: ${AWS_S3_HOST}" >> ${s3config}
[ "${AWS_S3_HOST:-UNDEF}" = "UNDEF" ] || echo "aws_s3_host: ${AWS_S3_HOST}" >> ${s3config}

: "Download Backups"
/opt/s3sync/s3sync.rb -r ${s3_url} ${backup_dir}

: "Backup Jenkins and remove old backups"
/usr/local/bin/jenkins-backup ${jenkins_home} \
        ${backup_dir}/jenkins-backup_`date +%Y%m%d%H%M%S`.tar.gz
find ${backup_dir} -type f \
        -name "jenkins-backup_*.tar.gz" \
        -daystart -mtime +${BACKUP_EXPIRE:=30} \
        | xargs rm -f

: "Sync Backups to S3"
/opt/s3sync/s3sync.rb -r --delete ${backup_dir} ${s3_url}


