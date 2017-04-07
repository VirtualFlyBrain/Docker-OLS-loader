FROM openjdk:8-jdk

RUN echo Building OLS && \
git clone https://github.com/EBISPOT/OLS.git && \
mvn clean package

CMD ['/bin/bash']
