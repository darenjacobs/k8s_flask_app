FROM python:3.11

WORKDIR /app

COPY requirements.txt .
ADD app/* /app/

RUN pip install --no-cache-dir -r requirements.txt

# run the app with the daemon user for better security
USER daemon
CMD ["python", "app.py"]