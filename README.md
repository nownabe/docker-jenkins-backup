jenkins-backup
==============

This jenkins-backup is a Docker image to backup jenkins and to upload backups to S3.
jenkins-backup use [jenkins-backup-script](https://github.com/sue445/jenkins-backup-script) to backup jenkins and [s3sync](http://s3sync.net/) to upload backups to S3.

# Usage
Run docker container.

## Volumes
Make sure that required volumes are mounted.

* Mount Jenkins home directory to `/jenkins_backup/jenkins_home`.
* Mount the directory to store backups to `/jenkins_backup/backups`.

## Environment variables

There are required environments variables:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `BACKUP_BUCKET`

And optional variables are:

* `AWS_S3_HOST`: default is null.
* `BACKUP_PREFIX`: default is `""`. Note that using `BACKUP_PREFIX` make sure end is `"/"`. (e.g. `BACKUP_PREFIX=jenkins/`)
* `BACKUP_EXPIRE`: default is `30`.
* `TIMEZONE`: default is null.

## Run container

```bash
sudo docker run \
  -v /var/lib/jenkins:/jenkins_backup/jenkins_home \
  -v /backup:/jenkins_backup/backups \
  -e AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY \
  -e AWS_SECRET_ACCESS_KEY=YOUR_SECRET_KEY \
  -e AWS_S3_HOST=ds.jp-east.idcfcloud.com \
  -e BACKUP_BUCKET=backups.mydomain \
  -e BACKUP_PREFIX=jenkins/ \
  -e BACKUP_EXPIRE=90 \
  -e TIMEZONE=Japan \
  nownabe/jenkins-backup
```


