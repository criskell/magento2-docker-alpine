#!/usr/bin/env bash

if [ ! -s web/bin/magento ]; then
    echo "Waiting for MySQL..."

    curl -sSL https://raw.githubusercontent.com/eficode/wait-for/v2.2.3/wait-for | sh -s -- mysql:3306 -t 0

    composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition web

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
