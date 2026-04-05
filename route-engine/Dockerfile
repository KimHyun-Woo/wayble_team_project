FROM python:3.12-slim
WORKDIR /usr/src/app
RUN pip install Flask
RUN apt-get update && apt-get install -y wget
RUN wget https://raw.githubusercontent.com/KimHyun-Woo/wayble_team_project/refs/heads/route-engine/route-engine/hello.py
EXPOSE 5000
ENTRYPOINT ["python", "hello.py"]