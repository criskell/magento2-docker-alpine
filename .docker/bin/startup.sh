#!/usr/bin/env bash

if [ ! -s web/bin/magento ]; then
    composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition web

    installerPath=web/setup/src/Magento/Setup/Model/Installer.php

    # This checks takes all of my RAM.
    cp $installerPath $installerPath.bkp
    sed -i "/\s*\$script\[\] = \['File permissions check...', 'checkInstallationFilePermissions', \[\]\];/d" $installerPath
    sed -i "/\s*\$script\[\] = \['Required extensions check...', 'checkExtensions', \[\]\];/d" $installerPath

    bin/magento module:status | grep -v Magento | grep -v List | grep -v None | grep -v -e '^$'| xargs php bin/magento module:disable
    bin/magento cache:clean
    bin/magento setup:upgrade

    web/bin/magento setup:install --base-url=http://0.0.0.0:8080/ \
    --db-host=mysql --db-name=magento \
    --db-user=magento --db-password=magento \
    --admin-firstname=Magento --admin-lastname=Magento --admin-email=magento@example.com \
    --admin-user=magento --admin-password=magento123 --language=en_US \
    --currency=BRL --timezone=${TIMEZONE:-UTC} --cleanup-database \
    --sales-order-increment-prefix="ORD$" --session-save=db --use-rewrites=1
fi

cd web

php -S 0.0.0.0:80 -t ./pub/ ./phpserver/router.php
