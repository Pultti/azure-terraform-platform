FROM python:3.13-slim

WORKDIR /app

COPY app.py .

RUN useradd --create-home appuser
USER appuser

EXPOSE 8080

CMD ["python", "app.py"]