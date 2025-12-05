FROM debian:latest

# 1. Обновление и установка nginx
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y nginx psmisc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Подготовка сайта
RUN rm -rf /var/www/* && \
    mkdir -p /var/www/company.com/img

COPY index.html /var/www/company.com/
COPY img.jpg /var/www/company.com/img/

RUN chmod -R 755 /var/www/company.com

# 3. Создаём пользователя и группу
RUN useradd farrukh && \
    groupadd ryan && \
    usermod -aG ryan farrukh

# 4. Назначаем владельцев
RUN chown -R farrukh:ryan /var/www/company.com && \
    chown -R farrukh:ryan /var/log/nginx

# 5. Меняем путь к сайту
RUN sed -i 's#/var/www/html#/var/www/company.com#g' /etc/nginx/sites-enabled/default

# 6. Меняем пользователя nginx
RUN sed -i 's/user www-data;/user farrukh;/' /etc/nginx/nginx.conf

# 7. Открываем порт
EXPOSE 80

# 8. Запуск nginx в переднем плане
CMD ["nginx", "-g", "daemon off;"]
