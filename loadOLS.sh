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
echo '** loading fbbi to OLS **'

java -jar -Dspring.profiles.active=fbbi -Dols.home=${WORKSPACE} ols-apps/ols-neo4j-app/target/ols-neo4j-app.jar
chmod -R 777 ${WORKSPACE}/neo4j

sleep 30s

echo ''
echo '** Side loading from vfb owl: add_annonymous types **'

export PYTHONPATH=${WORKSPACE}/VFB_owl/src/code/mod/:${WORKSPACE}/VFB_owl/src/code/owl2neo/:${WORKSPACE}/VFB_owl/src/code/db_maintenance/:${WORKSPACE}/VFB_owl/src/code/entity_checks/:${WORKSPACE}/VFB_owl/src/code/export/:${WORKSPACE}/VFB_owl/src/code/owl_gen/:${WORKSPACE}/VFB_owl/src/code/unit_tests/

sleep 10

java -cp ${WORKSPACE}/VFB_owl/lib/*:/partition/bocian/VFBTools/jython/jython-2.7.0/jython.jar org.python.util.jython -Dpython.path=$PYTHONPATH ${WORKSPACE}/VFB_owl/src/code/owl2neo/add_anonymous_types.py http://localhost:7474 neo4j neo4j ${WORKSPACE}/VFB_owl/src/owl/vfb.owl

sleep 10


echo ''
echo '** Side loading from vfb owl: add refs **'

java -cp ${WORKSPACE}/VFB_owl/lib/*:/partition/bocian/VFBTools/jython/jython-2.7.0/jython.jar org.python.util.jython -Dpython.path=$PYTHONPATH ${WORKSPACE}/VFB_owl/src/code/owl2neo/add_refs_for_anat.py http://localhost:7474 neo4j neo4j ${WORKSPACE}/VFB_owl/src/owl/vfb.owl

sleep 10

export PYTHONPATH=${WORKSPACE}/VFB_neo4j/src/

echo ''
echo '** Loading from FB : import pub data **'

python3 ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/flybase2neo/import_pub_data.py http://localhost:7474 neo4j neo4j

sleep 10


echo ''
echo '** Denormalization: Make named edges **'

python3 ${WORKSPACE}/VFB_neo4j/src/uk/ac/ebi/vfb/neo4j/neo2neo/make_named_edges.py http://localhost:7474 neo4j neo4j

sleep 10


cp -r ${WORKSPACE}/neo4j /data/
