FROM node:20-alpine AS tailwind-builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build:css

FROM python:3.11

WORKDIR /app

RUN pip install --upgrade pip

COPY requirements.txt .

RUN pip install -r requirements.txt
COPY . .
COPY --from=tailwind-builder /app/static /app/static

EXPOSE 8000

CMD ["sh", "-c", "python manage.py migrate && python manage.py collectstatic --noinput && gunicorn job_board.wsgi:application --bind 0.0.0.0:8000 --workers 2"]