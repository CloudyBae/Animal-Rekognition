FROM python:3.8-slim-buster
WORKDIR /app
RUN pip3 install Flask boto3 pillow
COPY app/templates/ app/templates/
COPY app.py app.py
ENV FLASK_APP=app
CMD ["python3", "-m", "flask", "run", "--host=0.0.0.0", "--port=80"]