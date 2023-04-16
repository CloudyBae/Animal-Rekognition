FROM python:3.9
WORKDIR /app
RUN pip install --upgrade pip
RUN pip install flask
COPY . .
ENV FLASK_APP=app
CMD ["python","app/app.py"]