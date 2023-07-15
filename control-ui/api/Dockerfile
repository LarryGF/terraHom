ARG version=python3.11
FROM tiangolo/uvicorn-gunicorn-fastapi:${version} as api
COPY ./api/app /app
ENV LOG_LEVEL=warning
RUN pip install -r /app/requirements.txt
