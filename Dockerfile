FROM tusproject/tusd:f46d6600731a1d70115950498bb4fc3dc21ba45b

RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

RUN apk add --no-cache --update python3-dev openssl-dev libffi-dev musl-dev make gcc

RUN pip install pyjwt

RUN apk update && \
    apk add nginx && \
    adduser -D -g 'www' www && \
    mkdir /www && \
    mkdir /run/nginx && \
    chown -R www:www /var/lib/nginx && \
    chown -R www:www /www && \
    printf "user                            www;\n" > /etc/nginx/nginx.conf && \
    printf "worker_processes                auto;\n" >> /etc/nginx/nginx.conf && \
    printf "error_log                       /var/log/nginx/error.log warn;\n" >> /etc/nginx/nginx.conf && \
    printf "events {\n" >> /etc/nginx/nginx.conf && \
    printf "    worker_connections          1024;\n" >> /etc/nginx/nginx.conf && \
    printf "}\n" >> /etc/nginx/nginx.conf && \
    printf "http {\n" >> /etc/nginx/nginx.conf && \
    printf "    server {\n" >> /etc/nginx/nginx.conf && \
    printf "        listen 8888;\n" >> /etc/nginx/nginx.conf && \
    printf "        location / {\n" >> /etc/nginx/nginx.conf && \
    printf "             proxy_set_header Host \$host;\n" >> /etc/nginx/nginx.conf && \
    printf "             proxy_set_header X-Forwarded-Host \$host;\n" >> /etc/nginx/nginx.conf && \
    printf "             proxy_pass_request_headers      on;\n" >> /etc/nginx/nginx.conf && \
    printf "             add_header Allow \"HEAD, POST, PUT, PATCH, OPTIONS, LOCK, UNLOCK\" always;\n" >> /etc/nginx/nginx.conf && \
    printf "             limit_except HEAD POST PUT PATCH OPTIONS LOCK UNLOCK {\n" >> /etc/nginx/nginx.conf && \
    printf "                 deny all;\n" >> /etc/nginx/nginx.conf && \
    printf "             }\n" >> /etc/nginx/nginx.conf && \
    printf "             proxy_pass http://127.0.0.1:1080/;\n" >> /etc/nginx/nginx.conf && \
    printf "        }\n" >> /etc/nginx/nginx.conf && \
    printf "    }\n" >> /etc/nginx/nginx.conf && \
    printf "}\n" >> /etc/nginx/nginx.conf
RUN nginx -t
RUN apk update && apk add bridge openrc
COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x entrypoint.sh

RUN touch /var/lib/nginx/logs/error.log && \
    chmod -R 777 /var/lib/nginx && \ 
    chmod -R 777 /var/log/nginx && \
    chmod -R 777 /run/nginx
ENTRYPOINT "./entrypoint.sh"
EXPOSE 8888