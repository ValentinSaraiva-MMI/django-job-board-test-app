#!/bin/sh

echo "1. Collecte des fichiers statiques locaux..."
python manage.py collectstatic --noinput

echo "2. Application des migrations de la base de données..."
python manage.py migrate

echo "3. Envoi des fichiers vers Azure Blob Storage..."
python initialize_azure.py

echo "4. Démarrage de Gunicorn..."
exec gunicorn job_board.wsgi:application --bind 0.0.0.0:8000 --workers 2