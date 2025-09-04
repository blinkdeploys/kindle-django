#!/bin/bash


#***************** 


# project name
source .env


# read -p "Enter project name: " projectname
projectname=$PROJECTNAME
# project directory
projectdir="${PWD##*/}"
port=$HOST_PORT


#***************** 


# check python version - upgrade if less than version 3.01
echo "Updating python ..."
if ! python3 --version | grep -q 'Python 3.10'; then
  brew install python
fi


# setup dependencies
python3 -m venv venv
source venv/bin/activate


#***************** 


# install django
if ! ls -la | grep -q ' manage.py'; then

  # upgrade pip and install Django
  pip install --upgrade pip setuptools wheel
  # pip install django psycopg2-binary
  pip install -r requirements.txt
  # create a Django project
  django-admin startproject $projectname .
  # run the development server
  python manage.py migrate

  # staticfiles modes
  if ! ls -la | grep -q ' staticfiles'; then
    mkdir ./staticfiles
  else
    chmod -R 755 ./staticfiles
  fi
  # edit the settings file
  # ...

  # celery mods
  # ...



else

  echo "\nApp $projectname already exists."

fi




#***************** 


if [ "$1" == "-r" ]; then
  
  # free up port
  echo "\nEnsuring port $port is free..."
  if lsof -i :$port >/dev/null; then
    echo "Port $port is in use. Killing process..."
    kill -9 $(lsof -ti :$port)
  fi


  # running server...
  echo "\nRunning server..."

  python manage.py runserver 0.0.0.0:$port &
  sleep 3
  # open app in browser
  open "http://127.0.0.1:$port"
  wait

fi

#***************** 

# create superuser
# python manage.py createsuperuser


# Then log into http://127.0.0.1:$port/admin.
