FROM virtualflybrain/docker-ols-loader:latest

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y build-essential
RUN apt-get purge git
RUN apt-get install git
RUN apt-get clean all

