/* Linear Systems */
#include "GeneratorPQ_model.h"
#include "GeneratorPQ_16dae.h"
#include "GeneratorPQ_12jac.h"
#if defined(__cplusplus)
extern "C" {
#endif

/* linear systems */

/*
equation index: 33
type: SIMPLE_ASSIGN
generator.PGenPu = (-generator.terminal.V.re) * generator.terminal.i.re - generator.terminal.V.im * generator.terminal.i.im
*/
void GeneratorPQ_eqFunction_33(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,33};
  (data->localData[0]->realVars[9] /* generator.PGenPu variable */) = ((-(data->localData[0]->realVars[3] /* generator.terminal.V.re STATE(1) */))) * ((data->localData[0]->realVars[15] /* generator.terminal.i.re variable */)) - (((data->localData[0]->realVars[2] /* generator.terminal.V.im STATE(1) */)) * ((data->localData[0]->realVars[14] /* generator.terminal.i.im variable */)));
  TRACE_POP
}
/*
equation index: 34
type: SIMPLE_ASSIGN
generator.SGenPu.im = generator.terminal.V.re * generator.terminal.i.im - generator.terminal.V.im * generator.terminal.i.re
*/
void GeneratorPQ_eqFunction_34(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,34};
  (data->localData[0]->realVars[11] /* generator.SGenPu.im variable */) = ((data->localData[0]->realVars[3] /* generator.terminal.V.re STATE(1) */)) * ((data->localData[0]->realVars[14] /* generator.terminal.i.im variable */)) - (((data->localData[0]->realVars[2] /* generator.terminal.V.im STATE(1) */)) * ((data->localData[0]->realVars[15] /* generator.terminal.i.re variable */)));
  TRACE_POP
}

void residualFunc41(RESIDUAL_USERDATA* userData, const double* xloc, double* res, const int* iflag)
{
  TRACE_PUSH
  DATA *data = userData->data;
  threadData_t *threadData = userData->threadData;
  const int equationIndexes[2] = {1,41};
  ANALYTIC_JACOBIAN* jacobian = NULL;
  modelica_boolean tmp0;
  modelica_real tmp1;
  modelica_boolean tmp2;
  modelica_real tmp3;
  modelica_boolean tmp4;
  modelica_real tmp5;
  modelica_boolean tmp6;
  modelica_real tmp7;
  (data->localData[0]->realVars[14] /* generator.terminal.i.im variable */) = xloc[0];
  (data->localData[0]->realVars[15] /* generator.terminal.i.re variable */) = xloc[1];
  /* local constraints */
  GeneratorPQ_eqFunction_33(data, threadData);

  /* local constraints */
  GeneratorPQ_eqFunction_34(data, threadData);
  tmp0 = (modelica_boolean)(data->localData[0]->booleanVars[9] /* generator.running.value DISCRETE */);
  if(tmp0)
  {
    tmp1 = (data->localData[0]->realVars[11] /* generator.SGenPu.im variable */) - (data->simulationInfo->realParameter[8] /* generator.QGen0Pu PARAM */);
  }
  else
  {
    tmp1 = (data->localData[0]->realVars[14] /* generator.terminal.i.im variable */);
  }
  res[0] = tmp1;

  tmp6 = (modelica_boolean)(data->localData[0]->booleanVars[9] /* generator.running.value DISCRETE */);
  if(tmp6)
  {
    tmp4 = (modelica_boolean)((data->localData[0]->integerVars[1] /* generator.pStatus DISCRETE */) == 3);
    if(tmp4)
    {
      tmp5 = (data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */);
    }
    else
    {
      tmp2 = (modelica_boolean)((data->localData[0]->integerVars[1] /* generator.pStatus DISCRETE */) == 2);
      if(tmp2)
      {
        tmp3 = (data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */);
      }
      else
      {
        tmp3 = (data->localData[0]->realVars[10] /* generator.PGenRawPu variable */);
      }
      tmp5 = tmp3;
    }
    tmp7 = (data->localData[0]->realVars[9] /* generator.PGenPu variable */) - (tmp5);
  }
  else
  {
    tmp7 = (data->localData[0]->realVars[15] /* generator.terminal.i.re variable */);
  }
  res[1] = tmp7;
  TRACE_POP
}
OMC_DISABLE_OPT
void initializeStaticLSData41(DATA* data, threadData_t* threadData, LINEAR_SYSTEM_DATA* linearSystemData, modelica_boolean initSparsePattern)
{
  const int indices[2] = {
    14 /* generator.terminal.i.im */,
    15 /* generator.terminal.i.re */
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
void GeneratorPQ_initialLinearSystem(int nLinearSystems, LINEAR_SYSTEM_DATA* linearSystemData)
{
  /* linear systems */
  assertStreamPrint(NULL, nLinearSystems > 0, "Internal Error: indexlinearSystem mismatch!");
  linearSystemData[0].equationIndex = 41;
  linearSystemData[0].size = 2;
  linearSystemData[0].nnz = 0;
  linearSystemData[0].method = 1;   /* Symbolic Jacobian available */
  linearSystemData[0].residualFunc = residualFunc41;
  linearSystemData[0].strictTearingFunctionCall = NULL;
  linearSystemData[0].analyticalJacobianColumn = GeneratorPQ_functionJacLSJac0_column;
  linearSystemData[0].initialAnalyticalJacobian = GeneratorPQ_initialAnalyticJacobianLSJac0;
  linearSystemData[0].jacobianIndex = 0 /*jacInx*/;
  linearSystemData[0].setA = NULL;  //setLinearMatrixA41;
  linearSystemData[0].setb = NULL;  //setLinearVectorb41;
  linearSystemData[0].initializeStaticLSData = initializeStaticLSData41;
}

#if defined(__cplusplus)
}
#endif

