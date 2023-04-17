FROM python:3.9
WORKDIR /app
RUN pip install --upgrade pip
RUN pip install flask
RUN pip install boto3
RUN pip install --upgrade Pillow
COPY . .
ENV FLASK_APP=app
CMD ["python","app/app.py"]