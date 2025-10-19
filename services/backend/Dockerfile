FROM python:3.9-slim as builder

WORKDIR /app

COPY requirements.txt .
RUN pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt


FROM python:3.9-slim

WORKDIR /app


RUN useradd --create-home appuser
USER appuser


COPY --from=builder /wheels /wheels


RUN pip install --no-cache /wheels/*


COPY . .


EXPOSE 8080
CMD ["python", "app.py"]