# copy to .

import os
from celery import Celery

# set default Django settings
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "kindle.settings")

app = Celery("kindle")

# load settings from Django settings file using CELERY namespace
app.config_from_object("django.conf:settings", namespace="CELERY")

# auto-discover tasks.py in each app
app.autodiscover_tasks()
