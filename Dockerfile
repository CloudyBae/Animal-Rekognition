FROM python:3.8-slim-buster
RUN pip3 install Flask boto3 pillow
COPY /templates /templates
COPY app.py app.py
CMD ["python3", "-m", "flask", "run", "--host=0.0.0.0", "--port=80"]