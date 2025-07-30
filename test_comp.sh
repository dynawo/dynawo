#!/bin/bash
export DYNAWO_HOME=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
export DYNAWO_RTE_HOME=$DYNAWO_HOME/../dynawo-rte

cd $DYNAWO_HOME
#./myEnvDynawo.sh clean-build-models HvdcPVDiagramPQEmulationSetRpcl2Side1 HvdcPQPropDiagramPQ HvdcPVDiagramPQRpcl2Side1
#./myEnvDynawo.sh clean-build-models HvdcPVDiagramPQRpcl2Side1
./myEnvDynawo.sh clean-build-models InfiniteBus TransformerFixedRatio
./myEnvDynawo.sh build-dynawo-core
./myEnvDynawo.sh deploy
cd ../dynawo-algorithms/
./myEnvDynawoAlgorithms.sh clean-build-all
./myEnvDynawoAlgorithms.sh deploy
cd $DYNAWO_RTE_HOME
./myEnvDynawoRTE.sh build-dynawo-rte-core
#rm -rf $DYNAWO_RTE_HOME/distributions/dynawo-rte/
#rm $DYNAWO_RTE_HOME/distributions/DynawoRTE_headers_V1.8.0.zip
#./myEnvDynawoRTE.sh distrib-headers
#cd $DYNAWO_RTE_HOME/distributions/
#unzip DynawoRTE_headers_V1.8.0.zip
#cd ../../dynaflow-launcher
#./myEnvDFL.sh clean-build-all
cd $DYNAWO_HOME
