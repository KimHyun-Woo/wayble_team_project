FROM python:3.12-slim
WORKDIR /usr/src/app
RUN pip install Flask
COPY app/ .
EXPOSE 5000
ENTRYPOINT [ "python", "hello.py" ]