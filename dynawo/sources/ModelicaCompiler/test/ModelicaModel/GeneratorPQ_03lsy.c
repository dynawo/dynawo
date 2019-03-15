/* Linear Systems */
#include "GeneratorPQ_model.h"
#include "GeneratorPQ_16dae.h"
#include "GeneratorPQ_12jac.h"
#if defined(__cplusplus)
extern "C" {
#endif

/* linear systems */
OMC_DISABLE_OPT
void setLinearMatrixA30(void *inData, threadData_t *threadData, void *systemData)
{
  const int equationIndexes[2] = {1,30};
  DATA* data = (DATA*) inData;
  LINEAR_SYSTEM_DATA* linearSystemData = (LINEAR_SYSTEM_DATA*) systemData;
  linearSystemData->setAElement(0, 0, (-data->localData[0]->realVars[2] /* generator.terminal.V.re STATE(1) */), 0, linearSystemData, threadData);
  linearSystemData->setAElement(0, 1, data->localData[0]->realVars[1] /* generator.terminal.V.im STATE(1) */, 1, linearSystemData, threadData);
  linearSystemData->setAElement(1, 0, data->localData[0]->realVars[1] /* generator.terminal.V.im STATE(1) */, 2, linearSystemData, threadData);
  linearSystemData->setAElement(1, 1, data->localData[0]->realVars[2] /* generator.terminal.V.re STATE(1) */, 3, linearSystemData, threadData);
}
OMC_DISABLE_OPT
void setLinearVectorb30(void *inData, threadData_t *threadData, void *systemData)
{
  const int equationIndexes[2] = {1,30};
  DATA* data = (DATA*) inData;
  LINEAR_SYSTEM_DATA* linearSystemData = (LINEAR_SYSTEM_DATA*) systemData;
  linearSystemData->setBElement(0, (-data->localData[0]->realVars[9] /* generator.SGenPu.im variable */), linearSystemData, threadData);
  linearSystemData->setBElement(1, (-data->localData[0]->realVars[10] /* generator.SGenPu.re variable */), linearSystemData, threadData);
}
OMC_DISABLE_OPT
void initializeStaticLSData30(void *inData, threadData_t *threadData, void *systemData)
{
  DATA* data = (DATA*) inData;
  LINEAR_SYSTEM_DATA* linearSystemData = (LINEAR_SYSTEM_DATA*) systemData;
  int i=0;
  /* static ls data for generator.terminal.i.im */
  linearSystemData->nominal[i] = data->modelData->realVarsData[12].attribute /* generator.terminal.i.im */.nominal;
  linearSystemData->min[i]     = data->modelData->realVarsData[12].attribute /* generator.terminal.i.im */.min;
  linearSystemData->max[i++]   = data->modelData->realVarsData[12].attribute /* generator.terminal.i.im */.max;
  /* static ls data for generator.terminal.i.re */
  linearSystemData->nominal[i] = data->modelData->realVarsData[13].attribute /* generator.terminal.i.re */.nominal;
  linearSystemData->min[i]     = data->modelData->realVarsData[13].attribute /* generator.terminal.i.re */.min;
  linearSystemData->max[i++]   = data->modelData->realVarsData[13].attribute /* generator.terminal.i.re */.max;
}

/* Prototypes for the strict sets (Dynamic Tearing) */

/* Global constraints for the casual sets */
/* function initialize linear systems */
void GeneratorPQ_initialLinearSystem(int nLinearSystems, LINEAR_SYSTEM_DATA* linearSystemData)
{
  /* linear systems */
  assertStreamPrint(NULL, nLinearSystems > 0, "Internal Error: nLinearSystems mismatch!");
  linearSystemData[0].equationIndex = 30;
  linearSystemData[0].size = 2;
  linearSystemData[0].nnz = 4;
  linearSystemData[0].method = 0;
  linearSystemData[0].strictTearingFunctionCall = NULL;
  linearSystemData[0].setA = setLinearMatrixA30;
  linearSystemData[0].setb = setLinearVectorb30;
  linearSystemData[0].initializeStaticLSData = initializeStaticLSData30;
  linearSystemData[0].parentJacobian = NULL;
}

#if defined(__cplusplus)
}
#endif

