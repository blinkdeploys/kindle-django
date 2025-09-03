# Dockerfile - production-ready-ish Django app image
FROM python:3.11-slim

# system deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    libpq-dev \
    curl \
 && rm -rf /var/lib/apt/lists/*

# create app user
ENV APP_HOME=/app
RUN useradd --create-home appuser
WORKDIR $APP_HOME

# install python deps
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt $APP_HOME/requirements.txt
RUN pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt

# copy project
COPY . $APP_HOME

# make entrypoint executable
RUN chmod +x /app/entrypoint.sh
RUN chmod +x /app/wait-for-it.sh

# expose port used by gunicorn
EXPOSE 8000

# default env (can be overridden in docker-compose/.env)
ENV DJANGO_SETTINGS_MODULE=project.settings
ENV PORT=8000

USER appuser

CMD ["/app/entrypoint.sh"]
