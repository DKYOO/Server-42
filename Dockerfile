FROM debian:buster

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y	nginx\
						mariadb-server\
						php7.3\
						php-mysql\
						php-fpm\
						php-gd\
						php-mbstring\
						php-xml\
						wget

ADD https://wordpress.org/latest.tar.gz /var/www/html
ADD https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-english.tar.gz /var/www/html

RUN cd /var/www/html && tar -xf latest.tar.gz && tar -xf phpMyAdmin-5.1.0-english.tar.gz && rm -rf latest.tar.gz && rm -rf phpMyAdmin-5.1.0-english.tar.gz

COPY ./srcs/default /etc/nginx/sites-available
COPY ./srcs/gosuka.sh /
COPY ./srcs/autoindex.sh /
COPY ./srcs/config.inc.php /var/www/html/phpMyAdmin-5.1.0-english
COPY ./srcs/wp-config.php /var/www/html/wordpress

RUN openssl req -x509 -nodes -days 365 -subj "/C=RU/ST=Moscow/L=Moscow/O=43,6/OU=21Moscow/CN=tpatti" -newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt;

RUN chown -R www-data:www-data var/www/html
RUN chmod -R 755 /var/www/*

CMD bash gosuka.sh
