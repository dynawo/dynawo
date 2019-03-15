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
$PRE._generator._switchOffSignal3._value = $START.generator.switchOffSignal3.value
*/
void GeneratorPQ_eqFunction_1(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1};
  data->simulationInfo->booleanVarsPre[13] /* generator.switchOffSignal3.value DISCRETE */ = data->modelData->booleanVarsData[13].attribute /* generator.switchOffSignal3.value DISCRETE */.start;
  TRACE_POP
}

/*
equation index: 2
type: SIMPLE_ASSIGN
$PRE._generator._switchOffSignal2._value = $START.generator.switchOffSignal2.value
*/
void GeneratorPQ_eqFunction_2(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,2};
  data->simulationInfo->booleanVarsPre[12] /* generator.switchOffSignal2.value DISCRETE */ = data->modelData->booleanVarsData[12].attribute /* generator.switchOffSignal2.value DISCRETE */.start;
  TRACE_POP
}

/*
equation index: 3
type: SIMPLE_ASSIGN
$PRE._generator._qStatus = $START.generator.qStatus
*/
void GeneratorPQ_eqFunction_3(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,3};
  data->simulationInfo->integerVarsPre[1] /* generator.qStatus DISCRETE */ = (modelica_integer)data->modelData->integerVarsData[1].attribute /* generator.qStatus DISCRETE */.start;
  TRACE_POP
}

/*
equation index: 4
type: SIMPLE_ASSIGN
$PRE._generator._pStatus = $START.generator.pStatus
*/
void GeneratorPQ_eqFunction_4(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,4};
  data->simulationInfo->integerVarsPre[0] /* generator.pStatus DISCRETE */ = (modelica_integer)data->modelData->integerVarsData[0].attribute /* generator.pStatus DISCRETE */.start;
  TRACE_POP
}

/*
equation index: 5
type: SIMPLE_ASSIGN
generator._omegaRefPu._value = $START.generator.omegaRefPu.value
*/
void GeneratorPQ_eqFunction_5(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,5};
  data->localData[0]->realVars[0] /* generator.omegaRefPu.value STATE(1) */ = data->modelData->realVarsData[0].attribute /* generator.omegaRefPu.value STATE(1) */.start;
  TRACE_POP
}

/*
equation index: 6
type: SIMPLE_ASSIGN
generator._terminal._V._im = $START.generator.terminal.V.im
*/
void GeneratorPQ_eqFunction_6(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,6};
  data->localData[0]->realVars[1] /* generator.terminal.V.im STATE(1) */ = data->modelData->realVarsData[1].attribute /* generator.terminal.V.im STATE(1) */.start;
  TRACE_POP
}

/*
equation index: 7
type: SIMPLE_ASSIGN
generator._terminal._V._re = $START.generator.terminal.V.re
*/
void GeneratorPQ_eqFunction_7(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,7};
  data->localData[0]->realVars[2] /* generator.terminal.V.re STATE(1) */ = data->modelData->realVarsData[2].attribute /* generator.terminal.V.re STATE(1) */.start;
  TRACE_POP
}

/*
equation index: 8
type: SIMPLE_ASSIGN
$PRE._generator._running._value = $START.generator.running.value
*/
void GeneratorPQ_eqFunction_8(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,8};
  data->simulationInfo->booleanVarsPre[10] /* generator.running.value DISCRETE */ = data->modelData->booleanVarsData[10].attribute /* generator.running.value DISCRETE */.start;
  TRACE_POP
}

/*
equation index: 9
type: SIMPLE_ASSIGN
$PRE._generator._switchOffSignal1._value = $START.generator.switchOffSignal1.value
*/
void GeneratorPQ_eqFunction_9(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,9};
  data->simulationInfo->booleanVarsPre[11] /* generator.switchOffSignal1.value DISCRETE */ = data->modelData->booleanVarsData[11].attribute /* generator.switchOffSignal1.value DISCRETE */.start;
  TRACE_POP
}

/*
equation index: 10
type: SIMPLE_ASSIGN
generator._UPu = (generator.terminal.V.re ^ 2.0 + generator.terminal.V.im ^ 2.0) ^ 0.5
*/
void GeneratorPQ_eqFunction_10(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,10};
  modelica_real tmp0;
  modelica_real tmp1;
  modelica_real tmp2;
  tmp0 = data->localData[0]->realVars[2] /* generator.terminal.V.re STATE(1) */;
  tmp1 = data->localData[0]->realVars[1] /* generator.terminal.V.im STATE(1) */;
  data->localData[0]->realVars[11] /* generator.UPu variable */ = sqrt((tmp0 * tmp0) + (tmp1 * tmp1));
  TRACE_POP
}

/*
equation index: 11
type: SIMPLE_ASSIGN
$whenCondition10 = generator.UPu >= 0.0001 + generator.UMaxPu and $PRE.generator.qStatus <> Dynawo.Electrical.Machines.GeneratorPQ.QStatus.AbsorptionMax
*/
void GeneratorPQ_eqFunction_11(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,11};
  modelica_boolean tmp3;
  tmp3 = GreaterEq(data->localData[0]->realVars[11] /* generator.UPu variable */,0.0001 + data->simulationInfo->realParameter[8] /* generator.UMaxPu PARAM */);
  data->localData[0]->booleanVars[1] /* $whenCondition10 DISCRETE */ = (tmp3 && ((modelica_integer)data->simulationInfo->integerVarsPre[1] /* generator.qStatus DISCRETE */ != 2));
  TRACE_POP
}

/*
equation index: 12
type: SIMPLE_ASSIGN
$whenCondition9 = generator.UPu <= -0.0001 + generator.UMinPu and $PRE.generator.qStatus <> Dynawo.Electrical.Machines.GeneratorPQ.QStatus.GenerationMax
*/
void GeneratorPQ_eqFunction_12(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,12};
  modelica_boolean tmp5;
  tmp5 = LessEq(data->localData[0]->realVars[11] /* generator.UPu variable */,-0.0001 + data->simulationInfo->realParameter[9] /* generator.UMinPu PARAM */);
  data->localData[0]->booleanVars[9] /* $whenCondition9 DISCRETE */ = (tmp5 && ((modelica_integer)data->simulationInfo->integerVarsPre[1] /* generator.qStatus DISCRETE */ != 3));
  TRACE_POP
}

/*
equation index: 13
type: SIMPLE_ASSIGN
$whenCondition8 = generator.UPu < -0.0001 + generator.UMaxPu and $PRE.generator.qStatus == Dynawo.Electrical.Machines.GeneratorPQ.QStatus.AbsorptionMax or generator.UPu > 0.0001 + generator.UMinPu and $PRE.generator.qStatus == Dynawo.Electrical.Machines.GeneratorPQ.QStatus.GenerationMax
*/
void GeneratorPQ_eqFunction_13(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,13};
  modelica_boolean tmp7;
  modelica_boolean tmp9;
  tmp7 = Less(data->localData[0]->realVars[11] /* generator.UPu variable */,-0.0001 + data->simulationInfo->realParameter[8] /* generator.UMaxPu PARAM */);
  tmp9 = Greater(data->localData[0]->realVars[11] /* generator.UPu variable */,0.0001 + data->simulationInfo->realParameter[9] /* generator.UMinPu PARAM */);
  data->localData[0]->booleanVars[8] /* $whenCondition8 DISCRETE */ = ((tmp7 && ((modelica_integer)data->simulationInfo->integerVarsPre[1] /* generator.qStatus DISCRETE */ == 2)) || (tmp9 && ((modelica_integer)data->simulationInfo->integerVarsPre[1] /* generator.qStatus DISCRETE */ == 3)));
  TRACE_POP
}

/*
equation index: 14
type: SIMPLE_ASSIGN
generator._switchOffSignal1._value = $PRE.generator.switchOffSignal1.value
*/
void GeneratorPQ_eqFunction_14(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,14};
  data->localData[0]->booleanVars[11] /* generator.switchOffSignal1.value DISCRETE */ = data->simulationInfo->booleanVarsPre[11] /* generator.switchOffSignal1.value DISCRETE */;
  TRACE_POP
}

/*
equation index: 15
type: SIMPLE_ASSIGN
generator._switchOffSignal2._value = $PRE.generator.switchOffSignal2.value
*/
void GeneratorPQ_eqFunction_15(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,15};
  data->localData[0]->booleanVars[12] /* generator.switchOffSignal2.value DISCRETE */ = data->simulationInfo->booleanVarsPre[12] /* generator.switchOffSignal2.value DISCRETE */;
  TRACE_POP
}

/*
equation index: 16
type: SIMPLE_ASSIGN
generator._switchOffSignal3._value = $PRE.generator.switchOffSignal3.value
*/
void GeneratorPQ_eqFunction_16(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,16};
  data->localData[0]->booleanVars[13] /* generator.switchOffSignal3.value DISCRETE */ = data->simulationInfo->booleanVarsPre[13] /* generator.switchOffSignal3.value DISCRETE */;
  TRACE_POP
}

/*
equation index: 17
type: SIMPLE_ASSIGN
$whenCondition6 = generator.switchOffSignal1.value or generator.switchOffSignal2.value or generator.switchOffSignal3.value and $PRE.generator.running.value
*/
void GeneratorPQ_eqFunction_17(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,17};
  data->localData[0]->booleanVars[6] /* $whenCondition6 DISCRETE */ = ((data->localData[0]->booleanVars[11] /* generator.switchOffSignal1.value DISCRETE */ || data->localData[0]->booleanVars[12] /* generator.switchOffSignal2.value DISCRETE */) || (data->localData[0]->booleanVars[13] /* generator.switchOffSignal3.value DISCRETE */ && data->simulationInfo->booleanVarsPre[10] /* generator.running.value DISCRETE */));
  TRACE_POP
}

/*
equation index: 18
type: SIMPLE_ASSIGN
generator._pStatus = $PRE.generator.pStatus
*/
void GeneratorPQ_eqFunction_18(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,18};
  data->localData[0]->integerVars[0] /* generator.pStatus DISCRETE */ = data->simulationInfo->integerVarsPre[0] /* generator.pStatus DISCRETE */;
  TRACE_POP
}

/*
equation index: 19
type: SIMPLE_ASSIGN
generator._running._value = $PRE.generator.running.value
*/
void GeneratorPQ_eqFunction_19(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,19};
  data->localData[0]->booleanVars[10] /* generator.running.value DISCRETE */ = data->simulationInfo->booleanVarsPre[10] /* generator.running.value DISCRETE */;
  TRACE_POP
}

/*
equation index: 20
type: SIMPLE_ASSIGN
$whenCondition7 = not generator.running.value
*/
void GeneratorPQ_eqFunction_20(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,20};
  data->localData[0]->booleanVars[7] /* $whenCondition7 DISCRETE */ = (!data->localData[0]->booleanVars[10] /* generator.running.value DISCRETE */);
  TRACE_POP
}

/*
equation index: 21
type: SIMPLE_ASSIGN
generator._PGenRawPu = if generator.running.value then generator.PGen0Pu + generator.AlphaPu * (1.0 - generator.omegaRefPu.value) else 0.0
*/
void GeneratorPQ_eqFunction_21(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,21};
  modelica_boolean tmp11;
  modelica_real tmp12;
  tmp11 = (modelica_boolean)data->localData[0]->booleanVars[10] /* generator.running.value DISCRETE */;
  if(tmp11)
  {
    tmp12 = data->simulationInfo->realParameter[1] /* generator.PGen0Pu PARAM */ + (data->simulationInfo->realParameter[0] /* generator.AlphaPu PARAM */) * (1.0 - data->localData[0]->realVars[0] /* generator.omegaRefPu.value STATE(1) */);
  }
  else
  {
    tmp12 = 0.0;
  }
  data->localData[0]->realVars[7] /* generator.PGenRawPu variable */ = tmp12;
  TRACE_POP
}

/*
equation index: 22
type: SIMPLE_ASSIGN
$whenCondition2 = generator.PGenRawPu < generator.PMaxPu and $PRE.generator.pStatus == Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMax
*/
void GeneratorPQ_eqFunction_22(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,22};
  modelica_boolean tmp13;
  tmp13 = Less(data->localData[0]->realVars[7] /* generator.PGenRawPu variable */,data->simulationInfo->realParameter[2] /* generator.PMaxPu PARAM */);
  data->localData[0]->booleanVars[2] /* $whenCondition2 DISCRETE */ = (tmp13 && ((modelica_integer)data->simulationInfo->integerVarsPre[0] /* generator.pStatus DISCRETE */ == 3));
  TRACE_POP
}

/*
equation index: 23
type: SIMPLE_ASSIGN
$whenCondition3 = generator.PGenRawPu > generator.PMinPu and $PRE.generator.pStatus == Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMin
*/
void GeneratorPQ_eqFunction_23(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,23};
  modelica_boolean tmp15;
  tmp15 = Greater(data->localData[0]->realVars[7] /* generator.PGenRawPu variable */,data->simulationInfo->realParameter[3] /* generator.PMinPu PARAM */);
  data->localData[0]->booleanVars[3] /* $whenCondition3 DISCRETE */ = (tmp15 && ((modelica_integer)data->simulationInfo->integerVarsPre[0] /* generator.pStatus DISCRETE */ == 2));
  TRACE_POP
}

/*
equation index: 24
type: SIMPLE_ASSIGN
$whenCondition4 = generator.PGenRawPu <= generator.PMinPu and $PRE.generator.pStatus <> Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMin
*/
void GeneratorPQ_eqFunction_24(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,24};
  modelica_boolean tmp17;
  tmp17 = LessEq(data->localData[0]->realVars[7] /* generator.PGenRawPu variable */,data->simulationInfo->realParameter[3] /* generator.PMinPu PARAM */);
  data->localData[0]->booleanVars[4] /* $whenCondition4 DISCRETE */ = (tmp17 && ((modelica_integer)data->simulationInfo->integerVarsPre[0] /* generator.pStatus DISCRETE */ != 2));
  TRACE_POP
}

/*
equation index: 25
type: SIMPLE_ASSIGN
$whenCondition5 = generator.PGenRawPu >= generator.PMaxPu and $PRE.generator.pStatus <> Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMax
*/
void GeneratorPQ_eqFunction_25(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,25};
  modelica_boolean tmp19;
  tmp19 = GreaterEq(data->localData[0]->realVars[7] /* generator.PGenRawPu variable */,data->simulationInfo->realParameter[2] /* generator.PMaxPu PARAM */);
  data->localData[0]->booleanVars[5] /* $whenCondition5 DISCRETE */ = (tmp19 && ((modelica_integer)data->simulationInfo->integerVarsPre[0] /* generator.pStatus DISCRETE */ != 3));
  TRACE_POP
}

/*
equation index: 26
type: SIMPLE_ASSIGN
generator._PGenPu = if generator.running.value then if generator.pStatus == Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMax then generator.PMaxPu else if generator.pStatus == Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMin then generator.PMinPu else generator.PGenRawPu else 0.0
*/
void GeneratorPQ_eqFunction_26(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,26};
  modelica_boolean tmp23;
  modelica_real tmp24;
  modelica_boolean tmp25;
  modelica_real tmp26;
  modelica_boolean tmp27;
  modelica_real tmp28;
  tmp27 = (modelica_boolean)data->localData[0]->booleanVars[10] /* generator.running.value DISCRETE */;
  if(tmp27)
  {
    tmp25 = (modelica_boolean)((modelica_integer)data->localData[0]->integerVars[0] /* generator.pStatus DISCRETE */ == 3);
    if(tmp25)
    {
      tmp26 = data->simulationInfo->realParameter[2] /* generator.PMaxPu PARAM */;
    }
    else
    {
      tmp23 = (modelica_boolean)((modelica_integer)data->localData[0]->integerVars[0] /* generator.pStatus DISCRETE */ == 2);
      if(tmp23)
      {
        tmp24 = data->simulationInfo->realParameter[3] /* generator.PMinPu PARAM */;
      }
      else
      {
        tmp24 = data->localData[0]->realVars[7] /* generator.PGenRawPu variable */;
      }
      tmp26 = tmp24;
    }
    tmp28 = tmp26;
  }
  else
  {
    tmp28 = 0.0;
  }
  data->localData[0]->realVars[6] /* generator.PGenPu variable */ = tmp28;
  TRACE_POP
}

/*
equation index: 27
type: SIMPLE_ASSIGN
generator._SGenPu._re = generator.PGenPu
*/
void GeneratorPQ_eqFunction_27(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,27};
  data->localData[0]->realVars[10] /* generator.SGenPu.re variable */ = data->localData[0]->realVars[6] /* generator.PGenPu variable */;
  TRACE_POP
}

/*
equation index: 28
type: SIMPLE_ASSIGN
generator._QGenPu = if generator.running.value then if $PRE.generator.qStatus == Dynawo.Electrical.Machines.GeneratorPQ.QStatus.AbsorptionMax then generator.QMaxPu else if $PRE.generator.qStatus == Dynawo.Electrical.Machines.GeneratorPQ.QStatus.GenerationMax then generator.QMinPu else generator.QGen0Pu else 0.0
*/
void GeneratorPQ_eqFunction_28(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,28};
  modelica_boolean tmp31;
  modelica_real tmp32;
  modelica_boolean tmp33;
  modelica_real tmp34;
  modelica_boolean tmp35;
  modelica_real tmp36;
  tmp35 = (modelica_boolean)data->localData[0]->booleanVars[10] /* generator.running.value DISCRETE */;
  if(tmp35)
  {
    tmp33 = (modelica_boolean)((modelica_integer)data->simulationInfo->integerVarsPre[1] /* generator.qStatus DISCRETE */ == 2);
    if(tmp33)
    {
      tmp34 = data->simulationInfo->realParameter[5] /* generator.QMaxPu PARAM */;
    }
    else
    {
      tmp31 = (modelica_boolean)((modelica_integer)data->simulationInfo->integerVarsPre[1] /* generator.qStatus DISCRETE */ == 3);
      if(tmp31)
      {
        tmp32 = data->simulationInfo->realParameter[6] /* generator.QMinPu PARAM */;
      }
      else
      {
        tmp32 = data->simulationInfo->realParameter[4] /* generator.QGen0Pu PARAM */;
      }
      tmp34 = tmp32;
    }
    tmp36 = tmp34;
  }
  else
  {
    tmp36 = 0.0;
  }
  data->localData[0]->realVars[8] /* generator.QGenPu variable */ = tmp36;
  TRACE_POP
}

/*
equation index: 29
type: SIMPLE_ASSIGN
generator._SGenPu._im = generator.QGenPu
*/
void GeneratorPQ_eqFunction_29(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,29};
  data->localData[0]->realVars[9] /* generator.SGenPu.im variable */ = data->localData[0]->realVars[8] /* generator.QGenPu variable */;
  TRACE_POP
}

/*
equation index: 30
type: LINEAR

<var>generator._terminal._i._im</var>
<var>generator._terminal._i._re</var>
<row>
  <cell>-generator.SGenPu.im</cell>
  <cell>-generator.SGenPu.re</cell>
</row>
<matrix>
  <cell row="0" col="0">
    <residual>-generator.terminal.V.re</residual>
  </cell><cell row="0" col="1">
    <residual>generator.terminal.V.im</residual>
  </cell><cell row="1" col="0">
    <residual>generator.terminal.V.im</residual>
  </cell><cell row="1" col="1">
    <residual>generator.terminal.V.re</residual>
  </cell>
</matrix>
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_30(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,30};
  /* Linear equation system */
  int retValue;
  double aux_x[2] = { data->localData[1]->realVars[12] /* generator.terminal.i.im variable */,data->localData[1]->realVars[13] /* generator.terminal.i.re variable */ };
  if(ACTIVE_STREAM(LOG_DT))
  {
    infoStreamPrint(LOG_DT, 1, "Solving linear system 30 (STRICT TEARING SET if tearing enabled) at time = %18.10e", data->localData[0]->timeValue);
    messageClose(LOG_DT);
  }
  retValue = solve_linear_system(data, threadData, 0, &aux_x[0]);
  
  /* check if solution process was successful */
  if (retValue > 0){
    const int indexes[2] = {1,30};
    throwStreamPrintWithEquationIndexes(threadData, indexes, "Solving linear system 30 failed at time=%.15g.\nFor more information please use -lv LOG_LS.", data->localData[0]->timeValue);
  }
  /* write solution */
  data->localData[0]->realVars[12] /* generator.terminal.i.im variable */ = aux_x[0];
  data->localData[0]->realVars[13] /* generator.terminal.i.re variable */ = aux_x[1];
  TRACE_POP
}

/*
equation index: 31
type: SIMPLE_ASSIGN
generator._qStatus = $PRE.generator.qStatus
*/
void GeneratorPQ_eqFunction_31(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,31};
  data->localData[0]->integerVars[1] /* generator.qStatus DISCRETE */ = data->simulationInfo->integerVarsPre[1] /* generator.qStatus DISCRETE */;
  TRACE_POP
}

/*
equation index: 32
type: SIMPLE_ASSIGN
der(generator._omegaRefPu._value) = 0.0
*/
void GeneratorPQ_eqFunction_32(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,32};
  data->localData[0]->realVars[3] /* der(generator.omegaRefPu.value) STATE_DER */ = 0.0;
  TRACE_POP
}

/*
equation index: 33
type: SIMPLE_ASSIGN
der(generator._terminal._V._im) = 0.0
*/
void GeneratorPQ_eqFunction_33(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,33};
  data->localData[0]->realVars[4] /* der(generator.terminal.V.im) STATE_DER */ = 0.0;
  TRACE_POP
}

/*
equation index: 34
type: SIMPLE_ASSIGN
der(generator._terminal._V._re) = 0.0
*/
void GeneratorPQ_eqFunction_34(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,34};
  data->localData[0]->realVars[5] /* der(generator.terminal.V.re) STATE_DER */ = 0.0;
  TRACE_POP
}

/*
equation index: 35
type: SIMPLE_ASSIGN
$whenCondition1 = time > 999999.0
*/
void GeneratorPQ_eqFunction_35(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,35};
  modelica_boolean tmp37;
  tmp37 = Greater(data->localData[0]->timeValue,999999.0);
  data->localData[0]->booleanVars[0] /* $whenCondition1 DISCRETE */ = tmp37;
  TRACE_POP
}

/*
equation index: 36
type: SIMPLE_ASSIGN
$PRE._generator._state = $START.generator.state
*/
void GeneratorPQ_eqFunction_36(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,36};
  data->simulationInfo->integerVarsPre[2] /* generator.state DISCRETE */ = (modelica_integer)data->modelData->integerVarsData[2].attribute /* generator.state DISCRETE */.start;
  TRACE_POP
}

/*
equation index: 37
type: SIMPLE_ASSIGN
generator._state = $PRE.generator.state
*/
void GeneratorPQ_eqFunction_37(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,37};
  data->localData[0]->integerVars[2] /* generator.state DISCRETE */ = data->simulationInfo->integerVarsPre[2] /* generator.state DISCRETE */;
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
  GeneratorPQ_eqFunction_33(data, threadData);
  GeneratorPQ_eqFunction_34(data, threadData);
  GeneratorPQ_eqFunction_35(data, threadData);
  GeneratorPQ_eqFunction_36(data, threadData);
  GeneratorPQ_eqFunction_37(data, threadData);
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


int GeneratorPQ_functionInitialEquations_lambda0(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  data->simulationInfo->discreteCall = 1;
  data->simulationInfo->discreteCall = 0;
  
  TRACE_POP
  return 0;
}
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

