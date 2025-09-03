#!/bin/bash


source .env

projectname=$PROJECTNAME
venvfolder="venv"

if ls -la | grep -q " $projectname"; then
  rm -rf $projectname
fi

if ls -la | grep -q " $venvfolder"; then
  rm -rf $venvfolder
fi

if ls -la | grep -q ' db.sqlite3'; then
  rm -rf __pycache__
fi

if ls -la | grep -q ' db.sqlite3'; then
  rm db.sqlite3
fi

if ls -la | grep -q ' manage.py'; then
  rm manage.py
fi


