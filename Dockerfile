FROM maven:3-jdk-8

ENV VFB_OWL_VERSION=Current

ENV WORKSPACE=/opt/VFB

VOLUME /data

RUN echo Building OLS && \
mkdir -p ${WORKSPACE} && \
cd ${WORKSPACE} && \
git clone https://github.com/VirtualFlyBrain/OLS_configs.git && \
git clone https://github.com/EBISPOT/OLS.git && \
cp ${WORKSPACE}/OLS_configs/*.properties ${WORKSPACE}/OLS/ols-apps/ols-neo4j-app/src/main/resources/ && \
cd ${WORKSPACE}/OLS && \
mvn clean package

COPY loadOLS.sh ${WORKSPACE}/loadOLS.sh

RUN chmod +x ${WORKSPACE}/loadOLS.sh

ENTRYPOINT ['${WORKSPACE}/loadOLS.sh']
