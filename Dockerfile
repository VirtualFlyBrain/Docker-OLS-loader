FROM virtualflybrain/docker-ols-loader:latest

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y build-essential
RUN apt-get purge -y git
RUN apt-get update -y && apt-get install -y git
RUN apt-get clean all

