# To test run

From terminal, run:

```bash
celery -A projectname worker --loglevel=info
```

and from Django shell:

```python
python manage.py shell

from myapp.tasks import add
add.delay(4, 6)
```