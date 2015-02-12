#/bin/bash

set -eux

: "Configure S3"

s3config="/etc/s3conf/s3config.yml"
cat <<EOF > ${s3config}
aws_access_key_id: ${AWS_ACCESS_KEY_ID}
aws_secret_access_key: ${AWS_SECRET_ACCESS_KEY}
aws_calling_format: "SUBDOMAIN"
s3sync_native_charset: UTF-8
EOF

[ -v AWS_S3_HOST ] && echo "aws_s3_host: ${AWS_S3_HOST}" >> ${s3config}


