FROM python:3.8-slim
WORKDIR /usr/src/app
RUN pip install --upgrade pip
COPY polybot/requirements.txt .
RUN pip install -r requirements.txt

COPY polybot/app.py .
COPY polybot/bot.py .
COPY /polybot/YOURPUBLIC.pem .

CMD ["python", "app.py"]
