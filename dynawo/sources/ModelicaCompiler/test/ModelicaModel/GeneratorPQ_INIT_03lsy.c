/* Linear Systems */
#include "GeneratorPQ_INIT_model.h"
#include "GeneratorPQ_INIT_16dae.h"
#include "GeneratorPQ_INIT_12jac.h"
#if defined(__cplusplus)
extern "C" {
#endif

/* linear systems */
OMC_DISABLE_OPT
void setLinearMatrixA5(void *inData, threadData_t *threadData, void *systemData)
{
  const int equationIndexes[2] = {1,5};
  DATA* data = (DATA*) inData;
  LINEAR_SYSTEM_DATA* linearSystemData = (LINEAR_SYSTEM_DATA*) systemData;
  linearSystemData->setAElement(0, 0, (-data->localData[0]->realVars[6] /* generator.u0Pu.im variable */), 0, linearSystemData, threadData);
  linearSystemData->setAElement(0, 1, (-data->localData[0]->realVars[7] /* generator.u0Pu.re variable */), 1, linearSystemData, threadData);
  linearSystemData->setAElement(1, 0, data->localData[0]->realVars[7] /* generator.u0Pu.re variable */, 2, linearSystemData, threadData);
  linearSystemData->setAElement(1, 1, (-data->localData[0]->realVars[6] /* generator.u0Pu.im variable */), 3, linearSystemData, threadData);
}
OMC_DISABLE_OPT
void setLinearVectorb5(void *inData, threadData_t *threadData, void *systemData)
{
  const int equationIndexes[2] = {1,5};
  DATA* data = (DATA*) inData;
  LINEAR_SYSTEM_DATA* linearSystemData = (LINEAR_SYSTEM_DATA*) systemData;
  linearSystemData->setBElement(0, (-data->localData[0]->realVars[5] /* generator.s0Pu.re variable */), linearSystemData, threadData);
  linearSystemData->setBElement(1, (-data->localData[0]->realVars[4] /* generator.s0Pu.im variable */), linearSystemData, threadData);
}
OMC_DISABLE_OPT
void initializeStaticLSData5(void *inData, threadData_t *threadData, void *systemData)
{
  DATA* data = (DATA*) inData;
  LINEAR_SYSTEM_DATA* linearSystemData = (LINEAR_SYSTEM_DATA*) systemData;
  int i=0;
  /* static ls data for generator.i0Pu.im */
  linearSystemData->nominal[i] = data->modelData->realVarsData[2].attribute /* generator.i0Pu.im */.nominal;
  linearSystemData->min[i]     = data->modelData->realVarsData[2].attribute /* generator.i0Pu.im */.min;
  linearSystemData->max[i++]   = data->modelData->realVarsData[2].attribute /* generator.i0Pu.im */.max;
  /* static ls data for generator.i0Pu.re */
  linearSystemData->nominal[i] = data->modelData->realVarsData[3].attribute /* generator.i0Pu.re */.nominal;
  linearSystemData->min[i]     = data->modelData->realVarsData[3].attribute /* generator.i0Pu.re */.min;
  linearSystemData->max[i++]   = data->modelData->realVarsData[3].attribute /* generator.i0Pu.re */.max;
}

/* Prototypes for the strict sets (Dynamic Tearing) */

/* Global constraints for the casual sets */
/* function initialize linear systems */
void GeneratorPQ_INIT_initialLinearSystem(int nLinearSystems, LINEAR_SYSTEM_DATA* linearSystemData)
{
  /* linear systems */
  assertStreamPrint(NULL, nLinearSystems > 0, "Internal Error: nLinearSystems mismatch!");
  linearSystemData[0].equationIndex = 5;
  linearSystemData[0].size = 2;
  linearSystemData[0].nnz = 4;
  linearSystemData[0].method = 0;
  linearSystemData[0].strictTearingFunctionCall = NULL;
  linearSystemData[0].setA = setLinearMatrixA5;
  linearSystemData[0].setb = setLinearVectorb5;
  linearSystemData[0].initializeStaticLSData = initializeStaticLSData5;
  linearSystemData[0].parentJacobian = NULL;
}

#if defined(__cplusplus)
}
#endif

