#!/bin/sh

set -eux

mkdir -p /config
touch /config/config.php
ln -s /config/config.php /var/www/html/gnusocial/config.php

exec apache2-foreground