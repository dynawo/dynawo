/* Initialization */
#include "GeneratorPQ_INIT_model.h"
#include "GeneratorPQ_INIT_16dae.h"
#include "GeneratorPQ_INIT_11mix.h"
#include "GeneratorPQ_INIT_12jac.h"
#if defined(__cplusplus)
extern "C" {
#endif

void GeneratorPQ_INIT_functionInitialEquations_0(DATA *data, threadData_t *threadData);

/*
equation index: 1
type: SIMPLE_ASSIGN
generator._u0Pu._im = generator.U0Pu * sin(generator.UPhase0)
*/
void GeneratorPQ_INIT_eqFunction_1(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1};
  data->localData[0]->realVars[6] /* generator.u0Pu.im variable */ = (data->simulationInfo->realParameter[2] /* generator.U0Pu PARAM */) * (sin(data->simulationInfo->realParameter[3] /* generator.UPhase0 PARAM */));
  TRACE_POP
}

/*
equation index: 2
type: SIMPLE_ASSIGN
generator._u0Pu._re = generator.U0Pu * cos(generator.UPhase0)
*/
void GeneratorPQ_INIT_eqFunction_2(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,2};
  data->localData[0]->realVars[7] /* generator.u0Pu.re variable */ = (data->simulationInfo->realParameter[2] /* generator.U0Pu PARAM */) * (cos(data->simulationInfo->realParameter[3] /* generator.UPhase0 PARAM */));
  TRACE_POP
}

/*
equation index: 3
type: SIMPLE_ASSIGN
generator._s0Pu._re = generator.P0Pu
*/
void GeneratorPQ_INIT_eqFunction_3(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3};
  data->localData[0]->realVars[5] /* generator.s0Pu.re variable */ = data->simulationInfo->realParameter[0] /* generator.P0Pu PARAM */;
  TRACE_POP
}

/*
equation index: 4
type: SIMPLE_ASSIGN
generator._s0Pu._im = generator.Q0Pu
*/
void GeneratorPQ_INIT_eqFunction_4(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4};
  data->localData[0]->realVars[4] /* generator.s0Pu.im variable */ = data->simulationInfo->realParameter[1] /* generator.Q0Pu PARAM */;
  TRACE_POP
}

/*
equation index: 5
type: LINEAR

<var>generator._i0Pu._im</var>
<var>generator._i0Pu._re</var>
<row>
  <cell>-generator.s0Pu.re</cell>
  <cell>-generator.s0Pu.im</cell>
</row>
<matrix>
  <cell row="0" col="0">
    <residual>-generator.u0Pu.im</residual>
  </cell><cell row="0" col="1">
    <residual>-generator.u0Pu.re</residual>
  </cell><cell row="1" col="0">
    <residual>generator.u0Pu.re</residual>
  </cell><cell row="1" col="1">
    <residual>-generator.u0Pu.im</residual>
  </cell>
</matrix>
*/
OMC_DISABLE_OPT
void GeneratorPQ_INIT_eqFunction_5(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,5};
  /* Linear equation system */
  int retValue;
  double aux_x[2] = { data->localData[1]->realVars[2] /* generator.i0Pu.im variable */,data->localData[1]->realVars[3] /* generator.i0Pu.re variable */ };
  if(ACTIVE_STREAM(LOG_DT))
  {
    infoStreamPrint(LOG_DT, 1, "Solving linear system 5 (STRICT TEARING SET if tearing enabled) at time = %18.10e", data->localData[0]->timeValue);
    messageClose(LOG_DT);
  }
  retValue = solve_linear_system(data, threadData, 0, &aux_x[0]);
  
  /* check if solution process was successful */
  if (retValue > 0){
    const int indexes[2] = {1,5};
    throwStreamPrintWithEquationIndexes(threadData, indexes, "Solving linear system 5 failed at time=%.15g.\nFor more information please use -lv LOG_LS.", data->localData[0]->timeValue);
  }
  /* write solution */
  data->localData[0]->realVars[2] /* generator.i0Pu.im variable */ = aux_x[0];
  data->localData[0]->realVars[3] /* generator.i0Pu.re variable */ = aux_x[1];
  TRACE_POP
}

/*
equation index: 6
type: SIMPLE_ASSIGN
generator._PGen0Pu = -generator.P0Pu
*/
void GeneratorPQ_INIT_eqFunction_6(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,6};
  data->localData[0]->realVars[0] /* generator.PGen0Pu variable */ = (-data->simulationInfo->realParameter[0] /* generator.P0Pu PARAM */);
  TRACE_POP
}

/*
equation index: 7
type: SIMPLE_ASSIGN
generator._QGen0Pu = -generator.Q0Pu
*/
void GeneratorPQ_INIT_eqFunction_7(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,7};
  data->localData[0]->realVars[1] /* generator.QGen0Pu variable */ = (-data->simulationInfo->realParameter[1] /* generator.Q0Pu PARAM */);
  TRACE_POP
}
OMC_DISABLE_OPT
void GeneratorPQ_INIT_functionInitialEquations_0(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  GeneratorPQ_INIT_eqFunction_1(data, threadData);
  GeneratorPQ_INIT_eqFunction_2(data, threadData);
  GeneratorPQ_INIT_eqFunction_3(data, threadData);
  GeneratorPQ_INIT_eqFunction_4(data, threadData);
  GeneratorPQ_INIT_eqFunction_5(data, threadData);
  GeneratorPQ_INIT_eqFunction_6(data, threadData);
  GeneratorPQ_INIT_eqFunction_7(data, threadData);
  TRACE_POP
}


int GeneratorPQ_INIT_functionInitialEquations(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  data->simulationInfo->discreteCall = 1;
  GeneratorPQ_INIT_functionInitialEquations_0(data, threadData);
  data->simulationInfo->discreteCall = 0;
  
  TRACE_POP
  return 0;
}


int GeneratorPQ_INIT_functionInitialEquations_lambda0(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  data->simulationInfo->discreteCall = 1;
  data->simulationInfo->discreteCall = 0;
  
  TRACE_POP
  return 0;
}
int GeneratorPQ_INIT_functionRemovedInitialEquations(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int *equationIndexes = NULL;
  double res = 0.0;

  
  TRACE_POP
  return 0;
}


#if defined(__cplusplus)
}
#endif

