# 🚀 Django + PostgreSQL + Redis + Docker Turnkey Setup

This repository contains a **production-ready Django stack** with:

- **Django** (with Gunicorn for serving the app)
- **PostgreSQL** (as the database)
- **Redis** (for caching and Celery task queue)
- **Celery worker** (optional, for background tasks)
- **Docker & docker-compose** for containerized development/production
- **GitHub Actions** for CI/CD (build, test, push image, deploy)

With this setup, you can spin up a use-ready Django application in minutes.

---


## 📂 Project Structure
```
start-django
├── Dockerfile
├── docker-compose.yml
├── .env
├── entrypoint.sh
├── wait-for-it.sh
├── requirements.txt
├── .dockerignore
├── .github/workflows/ci-cd.yml
├── project/
│   ├── settings.py
│   └── wsgi.py
└── README.md
```

---



## ⚙️ Quickstart

### 1. Clone the repository

```bash
git clone https://github.com/blinkwiki/start-django.git
cd start-django
```


### 2. Create a `.env` file

Copy the example below and adjust values:

```dotenv
DEBUG=0
SECRET_KEY=replace-with-a-very-secret-key
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1

POSTGRES_DB=django_db
POSTGRES_USER=django
POSTGRES_PASSWORD=django_password
POSTGRES_HOST=db
POSTGRES_PORT=5432

REDIS_HOST=redis
REDIS_PORT=6379

HOST_PORT=8000
```

⚠️ Do not commit `.env` to version control — it contains secrets.



### 3. Build & run

```bash
docker compose up --build
```


Your app will be live at `http://localhost:8000`.



## 🛠️ Development Notes

`entrypoint.sh` waits for Postgres, runs migrations, collects static files, and starts Gunicorn.

A superuser can be auto-created if you add these vars to `.env`:

```dotenv
DJANGO_SUPERUSER_USERNAME=admin
DJANGO_SUPERUSER_EMAIL=admin@example.com
DJANGO_SUPERUSER_PASSWORD=changeme
```

* Celery is included for background tasks. Remove the `celery` service from `docker-compose.yml` if not needed.



## 📦 Useful Commands

Run inside the `web` container:

```bash
# Open a Django shell
docker compose exec web python manage.py shell

# Create migrations
docker compose exec web python manage.py makemigrations

# Run tests
docker compose exec web python manage.py test
```

Stop all services:

```bash
docker compose down
```



## 🚀 Deployment with GitHub Actions

A workflow is included at `.github/workflows/ci-cd.yml` that:

1. Runs Django tests
2. Builds a Docker image
3. Pushes the image to **GitHub Container Registry (GHCR)** (or Docker Hub if you modify the config)
4. Deploys to a remote server via SSH (`docker-compose pull && up -d`)



### Required Secrets

Add these in your repository **Settings → Secrets and variables → Actions**:

* `GHCR_TOKEN` – personal access token with `write:packages`
* `DEPLOY_HOST` – IP/hostname of your server
* `DEPLOY_USER` – SSH user
* `SSH_PRIVATE_KEY` – private key for SSH authentication
* `DEPLOY_PORT` – SSH port (default: `22`)



## 🌍 Production Notes

* Set `DEBUG=0` and update `DJANGO_ALLOWED_HOSTS`.
* Configure HTTPS (via Nginx or reverse proxy).
* Use a production-ready `.env` with strong secrets.
* Optionally use `docker-compose.prod.yml` (included in docs) that references pre-built images from GHCR/Docker Hub instead of building locally.



## 🧰 Stack Versions

* Python 3.11 (slim)
* Django 4.2+
* PostgreSQL 15 (alpine)
* Redis 7 (alpine)
* Celery 5.3+
* Gunicorn 20+



## 📜 License

MIT License. See LICENSE for details.



#### 🤝 Contributing

PRs and issues are welcome! Fork this repo, make your changes, and open a PR.



---
