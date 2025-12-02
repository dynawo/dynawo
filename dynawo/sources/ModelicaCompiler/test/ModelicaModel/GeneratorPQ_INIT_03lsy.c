/* Linear Systems */
#include "GeneratorPQ_INIT_model.h"
#include "GeneratorPQ_INIT_16dae.h"
#include "GeneratorPQ_INIT_12jac.h"
#if defined(__cplusplus)
extern "C" {
#endif

/* linear systems */
OMC_DISABLE_OPT
void setLinearMatrixA3(DATA* data, threadData_t* threadData, LINEAR_SYSTEM_DATA* linearSystemData)
{
  const int equationIndexes[2] = {1,3};
  linearSystemData->setAElement(0, 0, (data->localData[0]->realVars[3] /* generator.u0Pu.re variable */), 0, linearSystemData, threadData);
  linearSystemData->setAElement(0, 1, (-(data->localData[0]->realVars[2] /* generator.u0Pu.im variable */)), 1, linearSystemData, threadData);
  linearSystemData->setAElement(1, 0, (-(data->localData[0]->realVars[2] /* generator.u0Pu.im variable */)), 2, linearSystemData, threadData);
  linearSystemData->setAElement(1, 1, (-(data->localData[0]->realVars[3] /* generator.u0Pu.re variable */)), 3, linearSystemData, threadData);
}
OMC_DISABLE_OPT
void setLinearVectorb3(DATA* data, threadData_t* threadData, LINEAR_SYSTEM_DATA* linearSystemData)
{
  const int equationIndexes[2] = {1,3};
  linearSystemData->setBElement(0, (-(data->simulationInfo->realParameter[1] /* generator.Q0Pu PARAM */)), linearSystemData, threadData);
  linearSystemData->setBElement(1, (-(data->simulationInfo->realParameter[0] /* generator.P0Pu PARAM */)), linearSystemData, threadData);
}
OMC_DISABLE_OPT
void initializeStaticLSData3(DATA* data, threadData_t* threadData, LINEAR_SYSTEM_DATA* linearSystemData, modelica_boolean initSparsePattern)
{
  const int indices[2] = {
    0 /* generator.i0Pu.im */,
    1 /* generator.i0Pu.re */
  };
  for (int i = 0; i < 2; ++i) {
    linearSystemData->nominal[i] = data->modelData->realVarsData[indices[i]].attribute.nominal;
    linearSystemData->min[i]     = data->modelData->realVarsData[indices[i]].attribute.min;
    linearSystemData->max[i]     = data->modelData->realVarsData[indices[i]].attribute.max;
  }
}

/* Prototypes for the strict sets (Dynamic Tearing) */

/* Global constraints for the casual sets */
/* function initialize linear systems */
void GeneratorPQ_INIT_initialLinearSystem(int nLinearSystems, LINEAR_SYSTEM_DATA* linearSystemData)
{
  /* linear systems */
  assertStreamPrint(NULL, nLinearSystems > 0, "Internal Error: nLinearSystems mismatch!");
  linearSystemData[0].equationIndex = 3;
  linearSystemData[0].size = 2;
  linearSystemData[0].nnz = 4;
  linearSystemData[0].method = 0;   /* No symbolic Jacobian available */
  linearSystemData[0].strictTearingFunctionCall = NULL;
  linearSystemData[0].setA = setLinearMatrixA3;
  linearSystemData[0].setb = setLinearVectorb3;
  linearSystemData[0].initializeStaticLSData = initializeStaticLSData3;
}

#if defined(__cplusplus)
}
#endif

