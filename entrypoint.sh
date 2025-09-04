#!/bin/bash
# entrypoint.sh - wait for DB then apply migrations, collectstatic and start gunicorn

set -e

APP_DIR="/app"
PYTHON_BIN="/usr/local/bin/python"
MANAGE="$PYTHON_BIN manage.py"

# Wait for Postgres to be available (uses pg_isready via netcat alternative)
echo "Waiting for Postgres at ${POSTGRES_HOST}:${POSTGRES_PORT}..."
# simple wait loop using pg_isready is not available in slim; use python check:
python - <<PY
import os,sys, time
import socket
host = os.getenv('POSTGRES_HOST','${POSTGRES_DB}')
port = int(os.getenv('POSTGRES_PORT','${POSTGRES_PORT}'))
for i in range(60):
    try:
        s = socket.create_connection((host, port), 2)
        s.close()
        print("Postgres is reachable")
        sys.exit(0)
    except Exception:
        print("Waiting for postgres...", i)
        time.sleep(1)
print("Timed out waiting for postgres")
sys.exit(1)
PY

# Apply migrations and collect static
echo "Running migrations..."
$MANAGE migrate --noinput

echo "Collecting static..."
$MANAGE collectstatic --noinput

# Create superuser if env vars are present (optional)
if [ -n "$DJANGO_SUPERUSER_USERNAME" ] && [ -n "$DJANGO_SUPERUSER_EMAIL" ] && [ -n "$DJANGO_SUPERUSER_PASSWORD" ]; then
  echo "Creating superuser..."
  $MANAGE shell <<EOF
from django.contrib.auth import get_user_model
User = get_user_model()
username = "${DJANGO_SUPERUSER_USERNAME}"
email = "${DJANGO_SUPERUSER_EMAIL}"
password = "${DJANGO_SUPERUSER_PASSWORD}"
if not User.objects.filter(username=username).exists():
    User.objects.create_superuser(username, email, password)
    print("Superuser created:", username)
else:
    print("Superuser exists:", username)
EOF
fi

# Start server
echo "Starting gunicorn..."
exec gunicorn ${PROJECTNAME}.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 3 \
    --log-level info
