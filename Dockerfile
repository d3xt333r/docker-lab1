FROM debian:latest

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y nginx psmisc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN rm -rf /var/www/* && \
    mkdir -p /var/www/company.com/img

COPY index.html /var/www/company.com/
COPY img.jpg /var/www/company.com/img/

RUN chmod -R 755 /var/www/company.com

RUN useradd farrukh && \
    groupadd ryan && \
    usermod -aG ryan farrukh

RUN chown -R farrukh:ryan /var/www/company.com && \
    chown -R farrukh:ryan /var/log/nginx

RUN sed -i 's#/var/www/html#/var/www/company.com#g' /etc/nginx/sites-enabled/default

RUN sed -i 's/user www-data;/user farrukh;/' /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
