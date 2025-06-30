/* update bound parameters and variable attributes (start, nominal, min, max) */
#include "GeneratorPQ_INIT_model.h"
#include "GeneratorPQ_INIT_16dae.h"
#if defined(__cplusplus)
extern "C" {
#endif


/*
equation index: 4
type: SIMPLE_ASSIGN
$START.generator.i0Pu.re = generator.iStart0Pu.re
*/
static void GeneratorPQ_INIT_eqFunction_4(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4};
  (data->modelData->realVarsData[1] /* generator.i0Pu.re variable */).attribute .start = (data->simulationInfo->realParameter[5] /* generator.iStart0Pu.re PARAM */);
    (data->localData[0]->realVars[1] /* generator.i0Pu.re variable */) = (data->modelData->realVarsData[1] /* generator.i0Pu.re variable */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[1].info /* generator.i0Pu.re */.name, (modelica_real) (data->localData[0]->realVars[1] /* generator.i0Pu.re variable */));
  TRACE_POP
}
OMC_DISABLE_OPT
int GeneratorPQ_INIT_updateBoundVariableAttributes(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  /* min ******************************************************** */
  infoStreamPrint(LOG_INIT, 1, "updating min-values");
  if (ACTIVE_STREAM(LOG_INIT)) messageClose(LOG_INIT);
  
  /* max ******************************************************** */
  infoStreamPrint(LOG_INIT, 1, "updating max-values");
  if (ACTIVE_STREAM(LOG_INIT)) messageClose(LOG_INIT);
  
  /* nominal **************************************************** */
  infoStreamPrint(LOG_INIT, 1, "updating nominal-values");
  if (ACTIVE_STREAM(LOG_INIT)) messageClose(LOG_INIT);
  
  /* start ****************************************************** */
  infoStreamPrint(LOG_INIT, 1, "updating primary start-values");
  GeneratorPQ_INIT_eqFunction_4(data, threadData);
  if (ACTIVE_STREAM(LOG_INIT)) messageClose(LOG_INIT);
  
  TRACE_POP
  return 0;
}

void GeneratorPQ_INIT_updateBoundParameters_0(DATA *data, threadData_t *threadData);

/*
equation index: 5
type: SIMPLE_ASSIGN
generator.u0Pu.im = generator.U0Pu * sin(generator.UPhase0)
*/
OMC_DISABLE_OPT
static void GeneratorPQ_INIT_eqFunction_5(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,5};
  (data->localData[0]->realVars[2] /* generator.u0Pu.im variable */) = ((data->simulationInfo->realParameter[2] /* generator.U0Pu PARAM */)) * (sin((data->simulationInfo->realParameter[3] /* generator.UPhase0 PARAM */)));
  TRACE_POP
}

/*
equation index: 6
type: SIMPLE_ASSIGN
generator.u0Pu.re = generator.U0Pu * cos(generator.UPhase0)
*/
OMC_DISABLE_OPT
static void GeneratorPQ_INIT_eqFunction_6(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,6};
  (data->localData[0]->realVars[3] /* generator.u0Pu.re variable */) = ((data->simulationInfo->realParameter[2] /* generator.U0Pu PARAM */)) * (cos((data->simulationInfo->realParameter[3] /* generator.UPhase0 PARAM */)));
  TRACE_POP
}
OMC_DISABLE_OPT
void GeneratorPQ_INIT_updateBoundParameters_0(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  GeneratorPQ_INIT_eqFunction_5(data, threadData);
  GeneratorPQ_INIT_eqFunction_6(data, threadData);
  TRACE_POP
}
OMC_DISABLE_OPT
int GeneratorPQ_INIT_updateBoundParameters(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  GeneratorPQ_INIT_updateBoundParameters_0(data, threadData);
  TRACE_POP
  return 0;
}

#if defined(__cplusplus)
}
#endif

