FROM python:3.8-slim-buster

COPY requirements.txt ./requirements.txt
COPY /templates ./templates
COPY app.py ./app.py

RUN pip install -r requirements.txt

CMD ["python3", "-m", "flask", "run", "--host=0.0.0.0", "--port=80"]