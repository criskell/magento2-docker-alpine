#!/usr/bin/env bash

if [ ! -s web/bin/magento ]; then
    installerPath=web/setup/src/Magento/Setup/Model/Installer.php

    # This checks takes all of my RAM.
    cp $installerPath $installerPath.bkp
    sed -i "/\s*\$script\[\] = \['File permissions check...', 'checkInstallationFilePermissions', \[\]\];/d" $installerPath
    sed -i "/\s*\$script\[\] = \['Required extensions check...', 'checkExtensions', \[\]\];/d" $installerPath

    web/bin/magento setup:install --base-url=http://0.0.0.0:80/ \
    --db-host=mysql --db-name=magento \
    --db-user=magento --db-password=magento \
    --admin-firstname=Magento --admin-lastname=Magento --admin-email=magento@example.com \
    --admin-user=magento --admin-password=magento123 --language=en_US \
    --currency=BRL --timezone=${TIMEZONE:-UTC} --cleanup-database \
    --sales-order-increment-prefix="ORD$" --session-save=db --use-rewrites=1
fi

cd web

php -S 0.0.0.0:80 -t ./pub/ ./phpserver/router.php
