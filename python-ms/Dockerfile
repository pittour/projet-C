FROM python:3.8-slim-bullseye

RUN apt-get update && \
    apt-get clean && \
    apt-get install -y redis && \
    apt install -y wget && \
    apt install -y git && \
    apt install -y authbind

WORKDIR /drupal-brutal
ENV PROMETHEUS_MULTIPROC_DIR /tmp
ENV prometheus_multiproc_dir /tmp

ENV DATABASE_HOST localhost:3306

COPY . .

RUN groupadd -r drupal && useradd -r -g drupal drupal

# RUN pip3 install --no-cache-dir --upgrade pip setuptools

RUN pip3 install -r requirements.txt

RUN chown -R drupal:drupal /drupal-brutal
RUN touch /etc/authbind/byport/80
RUN chmod 500 /etc/authbind/byport/80
RUN chown drupal /etc/authbind/byport/80

EXPOSE 80

USER drupal
CMD ["sh", "-c", "redis-server & authbind gunicorn -c config-gunicorn.py --bind 0.0.0.0:80 app:app"]