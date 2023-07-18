FROM alpine:latest

ARG TIMEZONE
RUN echo $TIMEZONE > /etc/timezone

RUN apk update && apk upgrade && apk add \
    zip unzip curl wget git bash \
    php81 \
    php81-gd php81-zlib php81-zip php81-curl \
    php81-mysqli php81-pdo_mysql \
    php81-phar php81-pecl-xdebug \
    php81-mbstring php81-tokenizer \
    php81-xml php81-intl php81-xmlwriter php81-xmlreader php81-simplexml php81-iconv \
    php81-bcmath \
    php81-sockets php81-soap php81-xsl php81-sodium \
    php81-fileinfo \
    php81-session

RUN wget https://getcomposer.org/composer-stable.phar -O /usr/local/bin/composer && chmod +x /usr/local/bin/composer

RUN sed -i "s/bin\/ash/bin\/bash/g" /etc/passwd

COPY conf/php.ini-development /etc/php81/php.ini
COPY conf/xdebug.ini /etc/php81/conf.d/xdebug.ini
COPY bin/startup.sh /usr/local/bin/startup.sh

ARG USER_ID
ARG GROUP_ID

RUN addgroup -S app --gid $GROUP_ID && \
    adduser -S app -G app --uid $USER_ID && \
    mkdir /home/app/workspace

USER app
WORKDIR /home/app/workspace
EXPOSE 80

CMD ["bash", "/usr/local/bin/startup.sh"]