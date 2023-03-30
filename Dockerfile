# FROM tusproject/tusd:b1a657049e9d11d05886bb328174c7b6741eaf4f

FROM tusproject/tusd:v1.10.1

USER root

RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

RUN apk add --no-cache --update python3-dev openssl-dev libffi-dev musl-dev make gcc

RUN pip install pyjwt


COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT "./entrypoint.sh"
EXPOSE 1080