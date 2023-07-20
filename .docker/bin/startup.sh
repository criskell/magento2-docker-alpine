#!/usr/bin/env bash

echo "Waiting for MySQL..."
wait-for mysql:3306 -t 0

if [ ! -n $SEARCH_ENGINE_DISABLED ]; then
    echo "Waiting for Elasticsearch..."
    wait-for elasticsearch:9200 -t 0
fi

if [ ! -s web/bin/magento ]; then
    composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition web

    mkdir -p web/var/composer_home
    echo "{}" > web/var/composer_home/composer.json

    if [ -n "$SEARCH_ENGINE_DISABLED" ]; then
        composer require zepgram/module-disable-search-engine --working-dir=web --no-interaction
    fi

    magento_args="--base-url=$BASE_URL_UNSECURE --base-url-secure=$BASE_URL_SECURE \
    --db-host=mysql --db-name=magento \
    --db-user=magento --db-password=magento \
    --admin-firstname=Magento --admin-lastname=Magento --admin-email=magento@example.com \
    --admin-user=magento --admin-password=magento123 --language=en_US \
    --currency=BRL --timezone=${TIMEZONE:-UTC} --cleanup-database \
    --sales-order-increment-prefix=ORD$ --session-save=db --use-rewrites=0 \
    --magento-init-params=MAGE_MODE=developer \
    --backend-frontname=admin \
    --disable-modules=Magento_TwoFactorAuth,Magento_AdminAdobeImsTwoFactorAuth"

    if [ -n "$SEARCH_ENGINE_DISABLED" ]; then
        magento_args="$magento_args --enable-modules=Zepgram_DisableSearchEngine"
    else
        magento_args="$magento_args --search-engine=elasticsearch7 \
            --elasticsearch-host=elasticsearch \
            --elasticsearch-port=9200"
    fi

    web/bin/magento setup:install $magento_args
fi

if [ ! -n $SEARCH_ENGINE_DISABLED ]; then
    web/bin/magento cron:install
    web/bin/magento cron:run --group index
fi

php -S 0.0.0.0:80 -t ./web/pub/ ./router.php
