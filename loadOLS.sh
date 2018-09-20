#!/bin/bash

cd ${WORKSPACE}
git clone https://github.com/VirtualFlyBrain/VFB_owl.git
cd ${WORKSPACE}/VFB_owl
git checkout tags/${VFB_OWL_VERSION}
cd ${WORKSPACE}/VFB_owl
find . -name '*.gz' -exec gzip -dvf '{}' \;


cd ${WORKSPACE}/OLS
echo '** loading vfb to OLS **'
java -jar -Dspring.profiles.active=vfb -Dols.home=${WORKSPACE} ols-apps/ols-neo4j-app/target/ols-neo4j-app.jar

echo ''
echo '** loading fbdv to OLS **'

java -jar -Dspring.profiles.active=fbdv -Dols.home=${WORKSPACE} ols-apps/ols-neo4j-app/target/ols-neo4j-app.jar


echo ''
echo '** loading fbcv to OLS **'

java -jar -Dspring.profiles.active=fbcv -Dols.home=${WORKSPACE} ols-apps/ols-neo4j-app/target/ols-neo4j-app.jar

echo ''
echo '** loading so to OLS **'

java -jar -Dspring.profiles.active=so -Dols.home=${WORKSPACE} ols-apps/ols-neo4j-app/target/ols-neo4j-app.jar

echo ''
echo '** loading geno to OLS **'

java -jar -Dspring.profiles.active=geno -Dols.home=${WORKSPACE} ols-apps/ols-neo4j-app/target/ols-neo4j-app.jar

echo ''
echo '** loading fbbi to OLS **'

java -jar -Dspring.profiles.active=fbbi -Dols.home=${WORKSPACE} ols-apps/ols-neo4j-app/target/ols-neo4j-app.jar
chmod -R 777 ${WORKSPACE}/neo4j

cp -r ${WORKSPACE}/neo4j /data/
