FROM python:3.9
WORKDIR /app
COPY src/ .
RUN pip install flask
CMD ["python", "app.py"]
