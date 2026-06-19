/* Initialization */
#include "GeneratorPQ_model.h"
#include "GeneratorPQ_16dae.h"
#include "GeneratorPQ_11mix.h"
#include "GeneratorPQ_12jac.h"
#if defined(__cplusplus)
extern "C" {
#endif

void GeneratorPQ_functionInitialEquations_0(DATA *data, threadData_t *threadData);

/*
equation index: 1
type: SIMPLE_ASSIGN
$DER.generator.deltaPmRefPu.value = 0.0
*/
void GeneratorPQ_eqFunction_1(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1};
  (data->localData[0]->realVars[4] /* der(generator.deltaPmRefPu.value) STATE_DER */) = 0.0;
  TRACE_POP
}

/*
equation index: 2
type: SIMPLE_ASSIGN
$DER.generator.terminal.V.re = 0.0
*/
void GeneratorPQ_eqFunction_2(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,2};
  (data->localData[0]->realVars[7] /* der(generator.terminal.V.re) STATE_DER */) = 0.0;
  TRACE_POP
}

/*
equation index: 3
type: SIMPLE_ASSIGN
$DER.generator.terminal.V.im = 0.0
*/
void GeneratorPQ_eqFunction_3(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3};
  (data->localData[0]->realVars[6] /* der(generator.terminal.V.im) STATE_DER */) = 0.0;
  TRACE_POP
}

/*
equation index: 4
type: SIMPLE_ASSIGN
$DER.generator.omegaRefPu.value = 0.0
*/
void GeneratorPQ_eqFunction_4(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4};
  (data->localData[0]->realVars[5] /* der(generator.omegaRefPu.value) STATE_DER */) = 0.0;
  TRACE_POP
}

/*
equation index: 5
type: SIMPLE_ASSIGN
$PRE.generator.state = $START.generator.state
*/
void GeneratorPQ_eqFunction_5(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,5};
  (data->simulationInfo->integerVarsPre[2] /* generator.state DISCRETE */) = (data->modelData->integerVarsData[2] /* generator.state DISCRETE */).attribute .start;
  TRACE_POP
}

/*
equation index: 6
type: SIMPLE_ASSIGN
generator.state = $PRE.generator.state
*/
void GeneratorPQ_eqFunction_6(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,6};
  (data->localData[0]->integerVars[2] /* generator.state DISCRETE */) = (data->simulationInfo->integerVarsPre[2] /* generator.state DISCRETE */);
  TRACE_POP
}

/*
equation index: 7
type: SIMPLE_ASSIGN
generator.converter.u = Integer(generator.state)
*/
void GeneratorPQ_eqFunction_7(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,7};
  (data->localData[0]->integerVars[0] /* generator.converter.u DISCRETE */) = ((modelica_integer)((data->localData[0]->integerVars[2] /* generator.state DISCRETE */)));
  TRACE_POP
}

/*
equation index: 8
type: SIMPLE_ASSIGN
generator.genState = (*Real*)(generator.converter.u)
*/
void GeneratorPQ_eqFunction_8(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,8};
  (data->localData[0]->realVars[13] /* generator.genState variable */) = ((modelica_real)(data->localData[0]->integerVars[0] /* generator.converter.u DISCRETE */));
  TRACE_POP
}

/*
equation index: 9
type: SIMPLE_ASSIGN
$PRE.generator.switchOffSignal1.value = $START.generator.switchOffSignal1.value
*/
void GeneratorPQ_eqFunction_9(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,9};
  (data->simulationInfo->booleanVarsPre[10] /* generator.switchOffSignal1.value DISCRETE */) = (data->modelData->booleanVarsData[10] /* generator.switchOffSignal1.value DISCRETE */).attribute .start;
  TRACE_POP
}

/*
equation index: 10
type: SIMPLE_ASSIGN
generator.switchOffSignal1.value = $PRE.generator.switchOffSignal1.value
*/
void GeneratorPQ_eqFunction_10(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,10};
  (data->localData[0]->booleanVars[10] /* generator.switchOffSignal1.value DISCRETE */) = (data->simulationInfo->booleanVarsPre[10] /* generator.switchOffSignal1.value DISCRETE */);
  TRACE_POP
}

/*
equation index: 11
type: SIMPLE_ASSIGN
$PRE.generator.switchOffSignal2.value = $START.generator.switchOffSignal2.value
*/
void GeneratorPQ_eqFunction_11(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,11};
  (data->simulationInfo->booleanVarsPre[11] /* generator.switchOffSignal2.value DISCRETE */) = (data->modelData->booleanVarsData[11] /* generator.switchOffSignal2.value DISCRETE */).attribute .start;
  TRACE_POP
}

/*
equation index: 12
type: SIMPLE_ASSIGN
generator.switchOffSignal2.value = $PRE.generator.switchOffSignal2.value
*/
void GeneratorPQ_eqFunction_12(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,12};
  (data->localData[0]->booleanVars[11] /* generator.switchOffSignal2.value DISCRETE */) = (data->simulationInfo->booleanVarsPre[11] /* generator.switchOffSignal2.value DISCRETE */);
  TRACE_POP
}

/*
equation index: 13
type: SIMPLE_ASSIGN
$PRE.generator.switchOffSignal3.value = $START.generator.switchOffSignal3.value
*/
void GeneratorPQ_eqFunction_13(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,13};
  (data->simulationInfo->booleanVarsPre[12] /* generator.switchOffSignal3.value DISCRETE */) = (data->modelData->booleanVarsData[12] /* generator.switchOffSignal3.value DISCRETE */).attribute .start;
  TRACE_POP
}

/*
equation index: 14
type: SIMPLE_ASSIGN
generator.switchOffSignal3.value = $PRE.generator.switchOffSignal3.value
*/
void GeneratorPQ_eqFunction_14(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,14};
  (data->localData[0]->booleanVars[12] /* generator.switchOffSignal3.value DISCRETE */) = (data->simulationInfo->booleanVarsPre[12] /* generator.switchOffSignal3.value DISCRETE */);
  TRACE_POP
}

/*
equation index: 15
type: SIMPLE_ASSIGN
$PRE.generator.running.value = $START.generator.running.value
*/
void GeneratorPQ_eqFunction_15(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,15};
  (data->simulationInfo->booleanVarsPre[9] /* generator.running.value DISCRETE */) = (data->modelData->booleanVarsData[9] /* generator.running.value DISCRETE */).attribute .start;
  TRACE_POP
}

/*
equation index: 16
type: SIMPLE_ASSIGN
generator.running.value = $PRE.generator.running.value
*/
void GeneratorPQ_eqFunction_16(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,16};
  (data->localData[0]->booleanVars[9] /* generator.running.value DISCRETE */) = (data->simulationInfo->booleanVarsPre[9] /* generator.running.value DISCRETE */);
  TRACE_POP
}

/*
equation index: 17
type: SIMPLE_ASSIGN
$whenCondition6 = not generator.running.value
*/
void GeneratorPQ_eqFunction_17(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,17};
  (data->localData[0]->booleanVars[5] /* $whenCondition6 DISCRETE */) = (!(data->localData[0]->booleanVars[9] /* generator.running.value DISCRETE */));
  TRACE_POP
}

/*
equation index: 18
type: SIMPLE_ASSIGN
$whenCondition7 = not generator.switchOffSignal1.value and not generator.switchOffSignal2.value and not generator.switchOffSignal3.value and not $PRE.generator.running.value
*/
void GeneratorPQ_eqFunction_18(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,18};
  (data->localData[0]->booleanVars[6] /* $whenCondition7 DISCRETE */) = ((((!(data->localData[0]->booleanVars[10] /* generator.switchOffSignal1.value DISCRETE */)) && (!(data->localData[0]->booleanVars[11] /* generator.switchOffSignal2.value DISCRETE */))) && (!(data->localData[0]->booleanVars[12] /* generator.switchOffSignal3.value DISCRETE */))) && (!(data->simulationInfo->booleanVarsPre[9] /* generator.running.value DISCRETE */)));
  TRACE_POP
}

/*
equation index: 19
type: SIMPLE_ASSIGN
$whenCondition8 = generator.switchOffSignal1.value or generator.switchOffSignal2.value or generator.switchOffSignal3.value and $PRE.generator.running.value
*/
void GeneratorPQ_eqFunction_19(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,19};
  (data->localData[0]->booleanVars[7] /* $whenCondition8 DISCRETE */) = (((data->localData[0]->booleanVars[10] /* generator.switchOffSignal1.value DISCRETE */) || (data->localData[0]->booleanVars[11] /* generator.switchOffSignal2.value DISCRETE */)) || ((data->localData[0]->booleanVars[12] /* generator.switchOffSignal3.value DISCRETE */) && (data->simulationInfo->booleanVarsPre[9] /* generator.running.value DISCRETE */)));
  TRACE_POP
}

/*
equation index: 20
type: SIMPLE_ASSIGN
$whenCondition5 = generator.running.value and not $PRE.generator.running.value
*/
void GeneratorPQ_eqFunction_20(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,20};
  (data->localData[0]->booleanVars[4] /* $whenCondition5 DISCRETE */) = ((data->localData[0]->booleanVars[9] /* generator.running.value DISCRETE */) && (!(data->simulationInfo->booleanVarsPre[9] /* generator.running.value DISCRETE */)));
  TRACE_POP
}

/*
equation index: 21
type: SIMPLE_ASSIGN
generator.terminal.V.re = $START.generator.terminal.V.re
*/
void GeneratorPQ_eqFunction_21(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,21};
  (data->localData[0]->realVars[3] /* generator.terminal.V.re STATE(1) */) = (data->modelData->realVarsData[3] /* generator.terminal.V.re STATE(1) */).attribute .start;
  TRACE_POP
}

/*
equation index: 22
type: SIMPLE_ASSIGN
generator.terminal.V.im = $START.generator.terminal.V.im
*/
void GeneratorPQ_eqFunction_22(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,22};
  (data->localData[0]->realVars[2] /* generator.terminal.V.im STATE(1) */) = (data->modelData->realVarsData[2] /* generator.terminal.V.im STATE(1) */).attribute .start;
  TRACE_POP
}

/*
equation index: 23
type: SIMPLE_ASSIGN
generator.UPu = if generator.running.value then (generator.terminal.V.re ^ 2.0 + generator.terminal.V.im ^ 2.0) ^ 0.5 else 0.0
*/
void GeneratorPQ_eqFunction_23(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,23};
  modelica_real tmp0;
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_boolean tmp3;
  modelica_real tmp4;
  tmp3 = (modelica_boolean)(data->localData[0]->booleanVars[9] /* generator.running.value DISCRETE */);
  if(tmp3)
  {
    tmp0 = (data->localData[0]->realVars[3] /* generator.terminal.V.re STATE(1) */);
    tmp1 = (data->localData[0]->realVars[2] /* generator.terminal.V.im STATE(1) */);
    tmp4 = sqrt((tmp0 * tmp0) + (tmp1 * tmp1));
  }
  else
  {
    tmp4 = 0.0;
  }
  (data->localData[0]->realVars[12] /* generator.UPu variable */) = tmp4;
  TRACE_POP
}

/*
equation index: 24
type: SIMPLE_ASSIGN
generator.deltaPmRefPu.value = $START.generator.deltaPmRefPu.value
*/
void GeneratorPQ_eqFunction_24(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,24};
  (data->localData[0]->realVars[0] /* generator.deltaPmRefPu.value STATE(1) */) = (data->modelData->realVarsData[0] /* generator.deltaPmRefPu.value STATE(1) */).attribute .start;
  TRACE_POP
}

/*
equation index: 25
type: SIMPLE_ASSIGN
$PRE.generator.pStatus = $START.generator.pStatus
*/
void GeneratorPQ_eqFunction_25(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,25};
  (data->simulationInfo->integerVarsPre[1] /* generator.pStatus DISCRETE */) = (data->modelData->integerVarsData[1] /* generator.pStatus DISCRETE */).attribute .start;
  TRACE_POP
}

/*
equation index: 26
type: SIMPLE_ASSIGN
generator.pStatus = $PRE.generator.pStatus
*/
void GeneratorPQ_eqFunction_26(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,26};
  (data->localData[0]->integerVars[1] /* generator.pStatus DISCRETE */) = (data->simulationInfo->integerVarsPre[1] /* generator.pStatus DISCRETE */);
  TRACE_POP
}

/*
equation index: 27
type: SIMPLE_ASSIGN
generator.omegaRefPu.value = $START.generator.omegaRefPu.value
*/
void GeneratorPQ_eqFunction_27(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,27};
  (data->localData[0]->realVars[1] /* generator.omegaRefPu.value STATE(1) */) = (data->modelData->realVarsData[1] /* generator.omegaRefPu.value STATE(1) */).attribute .start;
  TRACE_POP
}

/*
equation index: 28
type: SIMPLE_ASSIGN
generator.PGenRawPu = if generator.running.value then generator.PGen0Pu - (-0.01) * generator.deltaPmRefPu.value * generator.PNom - generator.AlphaPu * (generator.omegaRefPu.value - 1.0) else 0.0
*/
void GeneratorPQ_eqFunction_28(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,28};
  modelica_boolean tmp5;
  modelica_real tmp6;
  tmp5 = (modelica_boolean)(data->localData[0]->booleanVars[9] /* generator.running.value DISCRETE */);
  if(tmp5)
  {
    tmp6 = (data->simulationInfo->realParameter[2] /* generator.PGen0Pu PARAM */) - ((-0.01) * (((data->localData[0]->realVars[0] /* generator.deltaPmRefPu.value STATE(1) */)) * ((data->simulationInfo->realParameter[7] /* generator.PNom PARAM */)))) - (((data->simulationInfo->realParameter[0] /* generator.AlphaPu PARAM */)) * ((data->localData[0]->realVars[1] /* generator.omegaRefPu.value STATE(1) */) - 1.0));
  }
  else
  {
    tmp6 = 0.0;
  }
  (data->localData[0]->realVars[10] /* generator.PGenRawPu variable */) = tmp6;
  TRACE_POP
}

/*
equation index: 29
type: SIMPLE_ASSIGN
$whenCondition1 = generator.PGenRawPu < generator.PMaxPu and $PRE.generator.pStatus == generator.PStatus.LimitPMax
*/
void GeneratorPQ_eqFunction_29(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,29};
  modelica_boolean tmp7;
  tmp7 = Less((data->localData[0]->realVars[10] /* generator.PGenRawPu variable */),(data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */));
  (data->localData[0]->booleanVars[0] /* $whenCondition1 DISCRETE */) = (tmp7 && ((data->simulationInfo->integerVarsPre[1] /* generator.pStatus DISCRETE */) == 3));
  TRACE_POP
}

/*
equation index: 30
type: SIMPLE_ASSIGN
$whenCondition2 = generator.PGenRawPu > generator.PMinPu and $PRE.generator.pStatus == generator.PStatus.LimitPMin
*/
void GeneratorPQ_eqFunction_30(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,30};
  modelica_boolean tmp8;
  tmp8 = Greater((data->localData[0]->realVars[10] /* generator.PGenRawPu variable */),(data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */));
  (data->localData[0]->booleanVars[1] /* $whenCondition2 DISCRETE */) = (tmp8 && ((data->simulationInfo->integerVarsPre[1] /* generator.pStatus DISCRETE */) == 2));
  TRACE_POP
}

/*
equation index: 31
type: SIMPLE_ASSIGN
$whenCondition3 = generator.PGenRawPu <= generator.PMinPu and $PRE.generator.pStatus <> generator.PStatus.LimitPMin
*/
void GeneratorPQ_eqFunction_31(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,31};
  modelica_boolean tmp9;
  tmp9 = LessEq((data->localData[0]->realVars[10] /* generator.PGenRawPu variable */),(data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */));
  (data->localData[0]->booleanVars[2] /* $whenCondition3 DISCRETE */) = (tmp9 && ((data->simulationInfo->integerVarsPre[1] /* generator.pStatus DISCRETE */) != 2));
  TRACE_POP
}

/*
equation index: 32
type: SIMPLE_ASSIGN
$whenCondition4 = generator.PGenRawPu >= generator.PMaxPu and $PRE.generator.pStatus <> generator.PStatus.LimitPMax
*/
void GeneratorPQ_eqFunction_32(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,32};
  modelica_boolean tmp10;
  tmp10 = GreaterEq((data->localData[0]->realVars[10] /* generator.PGenRawPu variable */),(data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */));
  (data->localData[0]->booleanVars[3] /* $whenCondition4 DISCRETE */) = (tmp10 && ((data->simulationInfo->integerVarsPre[1] /* generator.pStatus DISCRETE */) != 3));
  TRACE_POP
}

/*
equation index: 41
type: LINEAR

<var>generator.terminal.i.im</var>
<var>generator.terminal.i.re</var>
<row>

</row>
<matrix>
</matrix>
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_41(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,41};
  /* Linear equation system */
  int retValue;
  double aux_x[2] = { (data->localData[1]->realVars[14] /* generator.terminal.i.im variable */),(data->localData[1]->realVars[15] /* generator.terminal.i.re variable */) };
  if(ACTIVE_STREAM(LOG_DT))
  {
    infoStreamPrint(LOG_DT, 1, "Solving linear system 41 (STRICT TEARING SET if tearing enabled) at time = %18.10e", data->localData[0]->timeValue);
    messageClose(LOG_DT);
  }

  retValue = solve_linear_system(data, threadData, 0, &aux_x[0]);

  /* check if solution process was successful */
  if (retValue > 0){
    const int indexes[2] = {1,41};
    throwStreamPrintWithEquationIndexes(threadData, omc_dummyFileInfo, indexes, "Solving linear system 41 failed at time=%.15g.\nFor more information please use -lv LOG_LS.", data->localData[0]->timeValue);
  }
  /* write solution */
  (data->localData[0]->realVars[14] /* generator.terminal.i.im variable */) = aux_x[0];
  (data->localData[0]->realVars[15] /* generator.terminal.i.re variable */) = aux_x[1];

  TRACE_POP
}

/*
equation index: 42
type: SIMPLE_ASSIGN
generator.PGen = 100.0 * generator.PGenPu
*/
void GeneratorPQ_eqFunction_42(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,42};
  (data->localData[0]->realVars[8] /* generator.PGen variable */) = (100.0) * ((data->localData[0]->realVars[9] /* generator.PGenPu variable */));
  TRACE_POP
}

/*
equation index: 43
type: SIMPLE_ASSIGN
$whenCondition9 = time > 999999.0
*/
void GeneratorPQ_eqFunction_43(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,43};
  modelica_boolean tmp11;
  tmp11 = Greater(data->localData[0]->timeValue,999999.0);
  (data->localData[0]->booleanVars[8] /* $whenCondition9 DISCRETE */) = tmp11;
  TRACE_POP
}
OMC_DISABLE_OPT
void GeneratorPQ_functionInitialEquations_0(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  GeneratorPQ_eqFunction_1(data, threadData);
  GeneratorPQ_eqFunction_2(data, threadData);
  GeneratorPQ_eqFunction_3(data, threadData);
  GeneratorPQ_eqFunction_4(data, threadData);
  GeneratorPQ_eqFunction_5(data, threadData);
  GeneratorPQ_eqFunction_6(data, threadData);
  GeneratorPQ_eqFunction_7(data, threadData);
  GeneratorPQ_eqFunction_8(data, threadData);
  GeneratorPQ_eqFunction_9(data, threadData);
  GeneratorPQ_eqFunction_10(data, threadData);
  GeneratorPQ_eqFunction_11(data, threadData);
  GeneratorPQ_eqFunction_12(data, threadData);
  GeneratorPQ_eqFunction_13(data, threadData);
  GeneratorPQ_eqFunction_14(data, threadData);
  GeneratorPQ_eqFunction_15(data, threadData);
  GeneratorPQ_eqFunction_16(data, threadData);
  GeneratorPQ_eqFunction_17(data, threadData);
  GeneratorPQ_eqFunction_18(data, threadData);
  GeneratorPQ_eqFunction_19(data, threadData);
  GeneratorPQ_eqFunction_20(data, threadData);
  GeneratorPQ_eqFunction_21(data, threadData);
  GeneratorPQ_eqFunction_22(data, threadData);
  GeneratorPQ_eqFunction_23(data, threadData);
  GeneratorPQ_eqFunction_24(data, threadData);
  GeneratorPQ_eqFunction_25(data, threadData);
  GeneratorPQ_eqFunction_26(data, threadData);
  GeneratorPQ_eqFunction_27(data, threadData);
  GeneratorPQ_eqFunction_28(data, threadData);
  GeneratorPQ_eqFunction_29(data, threadData);
  GeneratorPQ_eqFunction_30(data, threadData);
  GeneratorPQ_eqFunction_31(data, threadData);
  GeneratorPQ_eqFunction_32(data, threadData);
  GeneratorPQ_eqFunction_41(data, threadData);
  GeneratorPQ_eqFunction_42(data, threadData);
  GeneratorPQ_eqFunction_43(data, threadData);
  TRACE_POP
}

int GeneratorPQ_functionInitialEquations(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  data->simulationInfo->discreteCall = 1;
  GeneratorPQ_functionInitialEquations_0(data, threadData);
  data->simulationInfo->discreteCall = 0;
  
  TRACE_POP
  return 0;
}

/* No GeneratorPQ_functionInitialEquations_lambda0 function */

int GeneratorPQ_functionRemovedInitialEquations(DATA *data, threadData_t *threadData)
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
