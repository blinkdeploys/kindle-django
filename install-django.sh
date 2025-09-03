#!/bin/bash


# 1. Check your Python version:
# If it’s below 3.10, install the latest using Homebrew:
echo "Updating python ..."
if ! python3 --version | grep -q 'Python 3.10'; then
  brew install python
fi


# 2. Project name
read -p "Enter project name: " projectname


# 3. Create a project folder
mkdir $projectname && cd $projectname


# 4. Set up a Virtual Environment This keeps dependencies clean and separate:
# (When done later, you can exit with deactivate.)
python3 -m venv venv
source venv/bin/activate


# 5. Upgrade pip and install Django
pip install --upgrade pip
pip install django psycopg2-binary


# 6. Create a Django project
django-admin startproject $projectname .


# 7. Run the development server
python manage.py migrate
python manage.py runserver

# 8. Open your browser at and you should see the Django welcome page 🎉.
open "http://127.0.0.1:8000"


# 9. Create a superuser (for the admin panel)
python manage.py createsuperuser


# Then log into http://127.0.0.1:8000/admin.