FROM alpine:latest

ARG TIMEZONE
RUN echo $TIMEZONE > /etc/timezone

RUN apk update && apk upgrade && apk add \
    zip unzip curl wget git bash \
    busybox-suid \
    php82 \
    php82-gd php82-zlib php82-zip php82-curl \
    php82-mysqli php82-pdo_mysql \
    php82-phar php82-pecl-xdebug \
    php82-mbstring php82-tokenizer \
    php82-xml php82-intl php82-xmlwriter php82-xmlreader php82-simplexml php82-iconv \
    php82-bcmath \
    php82-sockets php82-soap php82-xsl php82-sodium \
    php82-fileinfo \
    php82-session \
    php82-ctype

RUN wget https://getcomposer.org/composer-stable.phar -O /usr/local/bin/composer && chmod +x /usr/local/bin/composer
RUN wget https://raw.githubusercontent.com/eficode/wait-for/v2.2.3/wait-for -O /usr/local/bin/wait-for && chmod +x /usr/local/bin/wait-for

RUN sed -i "s/bin\/ash/bin\/bash/g" /etc/passwd

COPY conf/php.ini-development /etc/php82/php.ini
COPY conf/xdebug.ini /etc/php82/conf.d/xdebug.ini
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