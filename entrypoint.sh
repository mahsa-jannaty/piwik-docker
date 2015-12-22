#!/bin/bash
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
envsubst < /workdir/passwd.template > /tmp/passwd
export LD_PRELOAD=libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group

sed -i "s/ALLOWED_HOSTNAME/${ALLOWED_HOSTNAME}/g" /etc/nginx/conf.d/default.conf

if [ ! -f /var/www/piwik/index.php ]; then
  # Copy initial site
  mv /workdir/piwik/* /var/www/piwik/
fi

exec "/usr/bin/supervisord"
