#!/bin/bash

cd ${WORKSPACE}
git clone https://github.com/VirtualFlyBrain/VFB_owl.git
cd ${WORKSPACE}/VFB_owl
git checkout tags/${VFB_OWL_VERSION}
cd ${WORKSPACE}/VFB_owl
find . -name '*.gz' -exec pigz -dvf '{}' \;


cd ${WORKSPACE}/OLS
echo '** loading vfb to OLS **'
java -Xmx2g -jar -Dspring.profiles.active=vfb -Dols.home=${WORKSPACE} ols-apps/ols-neo4j-app/target/ols-neo4j-app.jar

echo ''
echo '** loading fbdv to OLS **'

java -Xmx2g -jar -Dspring.profiles.active=fbdv -Dols.home=${WORKSPACE} ols-apps/ols-neo4j-app/target/ols-neo4j-app.jar


echo ''
echo '** loading fbcv to OLS **'

java -Xmx2g -jar -Dspring.profiles.active=fbcv -Dols.home=${WORKSPACE} ols-apps/ols-neo4j-app/target/ols-neo4j-app.jar

echo ''
echo '** loading fbbi to OLS **'

java -Xmx2g -jar -Dspring.profiles.active=fbbi -Dols.home=${WORKSPACE} ols-apps/ols-neo4j-app/target/ols-neo4j-app.jar
chmod -R 777 ${WORKSPACE}/neo4j

mv ${WORKSPACE}/neo4j /data/
