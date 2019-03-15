/* DAE residuals */
#include "GeneratorPQ_model.h"
#include "GeneratorPQ_16dae.h"
#include "simulation/solver/dae_mode.h"

#ifdef __cplusplus
extern "C" {
#endif

/*residual equations*/

/*
equation index: 63
type: SIMPLE_ASSIGN
generator._UPu = (generator.terminal.V.re ^ 2.0 + generator.terminal.V.im ^ 2.0) ^ 0.5
*/
void GeneratorPQ_eqFunction_63(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,63};
  modelica_real tmp0;
  modelica_real tmp1;
  modelica_real tmp2;
  tmp0 = data->localData[0]->realVars[2] /* generator.terminal.V.re STATE(1) */;
  tmp1 = data->localData[0]->realVars[1] /* generator.terminal.V.im STATE(1) */;
  data->localData[0]->realVars[11] /* generator.UPu variable */ = sqrt((tmp0 * tmp0) + (tmp1 * tmp1));
  TRACE_POP
}
/*
equation index: 64
type: SIMPLE_ASSIGN
$whenCondition10 = generator.UPu >= 0.0001 + generator.UMaxPu and pre(generator.qStatus) <> Dynawo.Electrical.Machines.GeneratorPQ.QStatus.AbsorptionMax
*/
void GeneratorPQ_eqFunction_64(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,64};
  modelica_boolean tmp3;
  RELATIONHYSTERESIS(tmp3, data->localData[0]->realVars[11] /* generator.UPu variable */, 0.0001 + data->simulationInfo->realParameter[8] /* generator.UMaxPu PARAM */, 5, GreaterEq);
  data->localData[0]->booleanVars[1] /* $whenCondition10 DISCRETE */ = (tmp3 && (data->simulationInfo->integerVarsPre[1] /* generator.qStatus DISCRETE */ != 2));
  TRACE_POP
}
/*
equation index: 65
type: SIMPLE_ASSIGN
$whenCondition9 = generator.UPu <= -0.0001 + generator.UMinPu and pre(generator.qStatus) <> Dynawo.Electrical.Machines.GeneratorPQ.QStatus.GenerationMax
*/
void GeneratorPQ_eqFunction_65(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,65};
  modelica_boolean tmp5;
  RELATIONHYSTERESIS(tmp5, data->localData[0]->realVars[11] /* generator.UPu variable */, -0.0001 + data->simulationInfo->realParameter[9] /* generator.UMinPu PARAM */, 6, LessEq);
  data->localData[0]->booleanVars[9] /* $whenCondition9 DISCRETE */ = (tmp5 && (data->simulationInfo->integerVarsPre[1] /* generator.qStatus DISCRETE */ != 3));
  TRACE_POP
}
/*
equation index: 66
type: SIMPLE_ASSIGN
$whenCondition8 = generator.UPu < -0.0001 + generator.UMaxPu and pre(generator.qStatus) == Dynawo.Electrical.Machines.GeneratorPQ.QStatus.AbsorptionMax or generator.UPu > 0.0001 + generator.UMinPu and pre(generator.qStatus) == Dynawo.Electrical.Machines.GeneratorPQ.QStatus.GenerationMax
*/
void GeneratorPQ_eqFunction_66(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,66};
  modelica_boolean tmp7;
  modelica_boolean tmp9;
  RELATIONHYSTERESIS(tmp7, data->localData[0]->realVars[11] /* generator.UPu variable */, -0.0001 + data->simulationInfo->realParameter[8] /* generator.UMaxPu PARAM */, 7, Less);
  RELATIONHYSTERESIS(tmp9, data->localData[0]->realVars[11] /* generator.UPu variable */, 0.0001 + data->simulationInfo->realParameter[9] /* generator.UMinPu PARAM */, 8, Greater);
  data->localData[0]->booleanVars[8] /* $whenCondition8 DISCRETE */ = ((tmp7 && (data->simulationInfo->integerVarsPre[1] /* generator.qStatus DISCRETE */ == 2)) || (tmp9 && (data->simulationInfo->integerVarsPre[1] /* generator.qStatus DISCRETE */ == 3)));
  TRACE_POP
}
/*
equation index: 67
type: WHEN

when {$whenCondition10} then
  generator._qStatus = Dynawo.Electrical.Machines.GeneratorPQ.QStatus.AbsorptionMax;
end when;
*/
void GeneratorPQ_eqFunction_67(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,67};
  if((data->localData[0]->booleanVars[1] /* $whenCondition10 DISCRETE */ && !data->simulationInfo->booleanVarsPre[1] /* $whenCondition10 DISCRETE */ /* edge */))
  {
    data->localData[0]->integerVars[1] /* generator.qStatus DISCRETE */ = 2;
  }
  else if((data->localData[0]->booleanVars[9] /* $whenCondition9 DISCRETE */ && !data->simulationInfo->booleanVarsPre[9] /* $whenCondition9 DISCRETE */ /* edge */))
  {
    data->localData[0]->integerVars[1] /* generator.qStatus DISCRETE */ = 3;
  }
  else if((data->localData[0]->booleanVars[8] /* $whenCondition8 DISCRETE */ && !data->simulationInfo->booleanVarsPre[8] /* $whenCondition8 DISCRETE */ /* edge */))
  {
    data->localData[0]->integerVars[1] /* generator.qStatus DISCRETE */ = 1;
  }
  TRACE_POP
}
/*
equation index: 70
type: SIMPLE_ASSIGN
$DAEres2 = der(generator.omegaRefPu.value)
*/
void GeneratorPQ_eqFunction_70(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,70};
  $P$DAEres2 = data->localData[0]->realVars[3] /* der(generator.omegaRefPu.value) STATE_DER */;
  TRACE_POP
}
/*
equation index: 71
type: SIMPLE_ASSIGN
$DAEres1 = der(generator.terminal.V.im)
*/
void GeneratorPQ_eqFunction_71(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,71};
  $P$DAEres1 = data->localData[0]->realVars[4] /* der(generator.terminal.V.im) STATE_DER */;
  TRACE_POP
}
/*
equation index: 72
type: SIMPLE_ASSIGN
$DAEres0 = der(generator.terminal.V.re)
*/
void GeneratorPQ_eqFunction_72(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,72};
  $P$DAEres0 = data->localData[0]->realVars[5] /* der(generator.terminal.V.re) STATE_DER */;
  TRACE_POP
}
/*
equation index: 73
type: SIMPLE_ASSIGN
$whenCondition1 = time > 999999.0
*/
void GeneratorPQ_eqFunction_73(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,73};
  modelica_boolean tmp11;
  RELATIONHYSTERESIS(tmp11, data->localData[0]->timeValue, 999999.0, 0, Greater);
  data->localData[0]->booleanVars[0] /* $whenCondition1 DISCRETE */ = tmp11;
  TRACE_POP
}
/*
equation index: 74
type: WHEN

when {$whenCondition1} then
  generator._switchOffSignal3._value = false;
end when;
*/
void GeneratorPQ_eqFunction_74(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,74};
  if((data->localData[0]->booleanVars[0] /* $whenCondition1 DISCRETE */ && !data->simulationInfo->booleanVarsPre[0] /* $whenCondition1 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[13] /* generator.switchOffSignal3.value DISCRETE */ = 0;
  }
  TRACE_POP
}
/*
equation index: 75
type: WHEN

when {$whenCondition1} then
  generator._switchOffSignal2._value = false;
end when;
*/
void GeneratorPQ_eqFunction_75(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,75};
  if((data->localData[0]->booleanVars[0] /* $whenCondition1 DISCRETE */ && !data->simulationInfo->booleanVarsPre[0] /* $whenCondition1 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[12] /* generator.switchOffSignal2.value DISCRETE */ = 0;
  }
  TRACE_POP
}
/*
equation index: 76
type: WHEN

when {$whenCondition1} then
  generator._switchOffSignal1._value = false;
end when;
*/
void GeneratorPQ_eqFunction_76(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,76};
  if((data->localData[0]->booleanVars[0] /* $whenCondition1 DISCRETE */ && !data->simulationInfo->booleanVarsPre[0] /* $whenCondition1 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[11] /* generator.switchOffSignal1.value DISCRETE */ = 0;
  }
  TRACE_POP
}
/*
equation index: 77
type: SIMPLE_ASSIGN
$whenCondition6 = generator.switchOffSignal1.value or generator.switchOffSignal2.value or generator.switchOffSignal3.value and pre(generator.running.value)
*/
void GeneratorPQ_eqFunction_77(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,77};
  data->localData[0]->booleanVars[6] /* $whenCondition6 DISCRETE */ = ((data->localData[0]->booleanVars[11] /* generator.switchOffSignal1.value DISCRETE */ || data->localData[0]->booleanVars[12] /* generator.switchOffSignal2.value DISCRETE */) || (data->localData[0]->booleanVars[13] /* generator.switchOffSignal3.value DISCRETE */ && data->simulationInfo->booleanVarsPre[10] /* generator.running.value DISCRETE */));
  TRACE_POP
}
/*
equation index: 78
type: WHEN

when {$whenCondition6} then
  generator._running._value = false;
end when;
*/
void GeneratorPQ_eqFunction_78(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,78};
  if((data->localData[0]->booleanVars[6] /* $whenCondition6 DISCRETE */ && !data->simulationInfo->booleanVarsPre[6] /* $whenCondition6 DISCRETE */ /* edge */))
  {
    data->localData[0]->booleanVars[10] /* generator.running.value DISCRETE */ = 0;
  }
  TRACE_POP
}
/*
equation index: 79
type: SIMPLE_ASSIGN
$whenCondition7 = not generator.running.value
*/
void GeneratorPQ_eqFunction_79(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,79};
  data->localData[0]->booleanVars[7] /* $whenCondition7 DISCRETE */ = (!data->localData[0]->booleanVars[10] /* generator.running.value DISCRETE */);
  TRACE_POP
}
/*
equation index: 80
type: WHEN

when {$whenCondition7} then
  generator._state = Dynawo.Electrical.Constants.state.Open;
end when;
*/
void GeneratorPQ_eqFunction_80(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,80};
  if((data->localData[0]->booleanVars[7] /* $whenCondition7 DISCRETE */ && !data->simulationInfo->booleanVarsPre[7] /* $whenCondition7 DISCRETE */ /* edge */))
  {
    data->localData[0]->integerVars[2] /* generator.state DISCRETE */ = 1;
  }
  TRACE_POP
}
/*
equation index: 81
type: SIMPLE_ASSIGN
generator._PGenRawPu = if generator.running.value then generator.PGen0Pu + generator.AlphaPu * (1.0 - generator.omegaRefPu.value) else 0.0
*/
void GeneratorPQ_eqFunction_81(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,81};
  modelica_boolean tmp12;
  modelica_real tmp13;
  tmp12 = (modelica_boolean)data->localData[0]->booleanVars[10] /* generator.running.value DISCRETE */;
  if(tmp12)
  {
    tmp13 = data->simulationInfo->realParameter[1] /* generator.PGen0Pu PARAM */ + (data->simulationInfo->realParameter[0] /* generator.AlphaPu PARAM */) * (1.0 - data->localData[0]->realVars[0] /* generator.omegaRefPu.value STATE(1) */);
  }
  else
  {
    tmp13 = 0.0;
  }
  data->localData[0]->realVars[7] /* generator.PGenRawPu variable */ = tmp13;
  TRACE_POP
}
/*
equation index: 82
type: SIMPLE_ASSIGN
$whenCondition5 = generator.PGenRawPu >= generator.PMaxPu and pre(generator.pStatus) <> Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMax
*/
void GeneratorPQ_eqFunction_82(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,82};
  modelica_boolean tmp14;
  RELATIONHYSTERESIS(tmp14, data->localData[0]->realVars[7] /* generator.PGenRawPu variable */, data->simulationInfo->realParameter[2] /* generator.PMaxPu PARAM */, 1, GreaterEq);
  data->localData[0]->booleanVars[5] /* $whenCondition5 DISCRETE */ = (tmp14 && (data->simulationInfo->integerVarsPre[0] /* generator.pStatus DISCRETE */ != 3));
  TRACE_POP
}
/*
equation index: 83
type: SIMPLE_ASSIGN
$whenCondition4 = generator.PGenRawPu <= generator.PMinPu and pre(generator.pStatus) <> Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMin
*/
void GeneratorPQ_eqFunction_83(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,83};
  modelica_boolean tmp16;
  RELATIONHYSTERESIS(tmp16, data->localData[0]->realVars[7] /* generator.PGenRawPu variable */, data->simulationInfo->realParameter[3] /* generator.PMinPu PARAM */, 2, LessEq);
  data->localData[0]->booleanVars[4] /* $whenCondition4 DISCRETE */ = (tmp16 && (data->simulationInfo->integerVarsPre[0] /* generator.pStatus DISCRETE */ != 2));
  TRACE_POP
}
/*
equation index: 84
type: SIMPLE_ASSIGN
$whenCondition3 = generator.PGenRawPu > generator.PMinPu and pre(generator.pStatus) == Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMin
*/
void GeneratorPQ_eqFunction_84(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,84};
  modelica_boolean tmp18;
  RELATIONHYSTERESIS(tmp18, data->localData[0]->realVars[7] /* generator.PGenRawPu variable */, data->simulationInfo->realParameter[3] /* generator.PMinPu PARAM */, 3, Greater);
  data->localData[0]->booleanVars[3] /* $whenCondition3 DISCRETE */ = (tmp18 && (data->simulationInfo->integerVarsPre[0] /* generator.pStatus DISCRETE */ == 2));
  TRACE_POP
}
/*
equation index: 85
type: SIMPLE_ASSIGN
$whenCondition2 = generator.PGenRawPu < generator.PMaxPu and pre(generator.pStatus) == Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMax
*/
void GeneratorPQ_eqFunction_85(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,85};
  modelica_boolean tmp20;
  RELATIONHYSTERESIS(tmp20, data->localData[0]->realVars[7] /* generator.PGenRawPu variable */, data->simulationInfo->realParameter[2] /* generator.PMaxPu PARAM */, 4, Less);
  data->localData[0]->booleanVars[2] /* $whenCondition2 DISCRETE */ = (tmp20 && (data->simulationInfo->integerVarsPre[0] /* generator.pStatus DISCRETE */ == 3));
  TRACE_POP
}
/*
equation index: 86
type: WHEN

when {$whenCondition5} then
  generator._pStatus = Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMax;
end when;
*/
void GeneratorPQ_eqFunction_86(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,86};
  if((data->localData[0]->booleanVars[5] /* $whenCondition5 DISCRETE */ && !data->simulationInfo->booleanVarsPre[5] /* $whenCondition5 DISCRETE */ /* edge */))
  {
    data->localData[0]->integerVars[0] /* generator.pStatus DISCRETE */ = 3;
  }
  else if((data->localData[0]->booleanVars[4] /* $whenCondition4 DISCRETE */ && !data->simulationInfo->booleanVarsPre[4] /* $whenCondition4 DISCRETE */ /* edge */))
  {
    data->localData[0]->integerVars[0] /* generator.pStatus DISCRETE */ = 2;
  }
  else if((data->localData[0]->booleanVars[3] /* $whenCondition3 DISCRETE */ && !data->simulationInfo->booleanVarsPre[3] /* $whenCondition3 DISCRETE */ /* edge */))
  {
    data->localData[0]->integerVars[0] /* generator.pStatus DISCRETE */ = 1;
  }
  else if((data->localData[0]->booleanVars[2] /* $whenCondition2 DISCRETE */ && !data->simulationInfo->booleanVarsPre[2] /* $whenCondition2 DISCRETE */ /* edge */))
  {
    data->localData[0]->integerVars[0] /* generator.pStatus DISCRETE */ = 1;
  }
  TRACE_POP
}
/*
equation index: 90
type: SIMPLE_ASSIGN
generator._PGenPu = if generator.running.value then if generator.pStatus == Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMax then generator.PMaxPu else if generator.pStatus == Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMin then generator.PMinPu else generator.PGenRawPu else 0.0
*/
void GeneratorPQ_eqFunction_90(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,90};
  modelica_boolean tmp24;
  modelica_real tmp25;
  modelica_boolean tmp26;
  modelica_real tmp27;
  modelica_boolean tmp28;
  modelica_real tmp29;
  tmp28 = (modelica_boolean)data->localData[0]->booleanVars[10] /* generator.running.value DISCRETE */;
  if(tmp28)
  {
    tmp26 = (modelica_boolean)((modelica_integer)data->localData[0]->integerVars[0] /* generator.pStatus DISCRETE */ == 3);
    if(tmp26)
    {
      tmp27 = data->simulationInfo->realParameter[2] /* generator.PMaxPu PARAM */;
    }
    else
    {
      tmp24 = (modelica_boolean)((modelica_integer)data->localData[0]->integerVars[0] /* generator.pStatus DISCRETE */ == 2);
      if(tmp24)
      {
        tmp25 = data->simulationInfo->realParameter[3] /* generator.PMinPu PARAM */;
      }
      else
      {
        tmp25 = data->localData[0]->realVars[7] /* generator.PGenRawPu variable */;
      }
      tmp27 = tmp25;
    }
    tmp29 = tmp27;
  }
  else
  {
    tmp29 = 0.0;
  }
  data->localData[0]->realVars[6] /* generator.PGenPu variable */ = tmp29;
  TRACE_POP
}
/*
equation index: 91
type: SIMPLE_ASSIGN
generator._SGenPu._re = generator.PGenPu
*/
void GeneratorPQ_eqFunction_91(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,91};
  data->localData[0]->realVars[10] /* generator.SGenPu.re variable */ = data->localData[0]->realVars[6] /* generator.PGenPu variable */;
  TRACE_POP
}
/*
equation index: 92
type: SIMPLE_ASSIGN
$DAEres3 = (-generator.terminal.V.re) * generator.terminal.i.re - generator.SGenPu.re - generator.terminal.V.im * generator.terminal.i.im
*/
void GeneratorPQ_eqFunction_92(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,92};
  $P$DAEres3 = ((-data->localData[0]->realVars[2] /* generator.terminal.V.re STATE(1) */)) * (data->localData[0]->realVars[13] /* generator.terminal.i.re variable */) - data->localData[0]->realVars[10] /* generator.SGenPu.re variable */ - ((data->localData[0]->realVars[1] /* generator.terminal.V.im STATE(1) */) * (data->localData[0]->realVars[12] /* generator.terminal.i.im variable */));
  TRACE_POP
}
/*
equation index: 93
type: SIMPLE_ASSIGN
generator._QGenPu = if generator.running.value then if pre(generator.qStatus) == Dynawo.Electrical.Machines.GeneratorPQ.QStatus.AbsorptionMax then generator.QMaxPu else if pre(generator.qStatus) == Dynawo.Electrical.Machines.GeneratorPQ.QStatus.GenerationMax then generator.QMinPu else generator.QGen0Pu else 0.0
*/
void GeneratorPQ_eqFunction_93(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,93};
  modelica_boolean tmp32;
  modelica_real tmp33;
  modelica_boolean tmp34;
  modelica_real tmp35;
  modelica_boolean tmp36;
  modelica_real tmp37;
  tmp36 = (modelica_boolean)data->localData[0]->booleanVars[10] /* generator.running.value DISCRETE */;
  if(tmp36)
  {
    tmp34 = (modelica_boolean)(data->simulationInfo->integerVarsPre[1] /* generator.qStatus DISCRETE */ == 2);
    if(tmp34)
    {
      tmp35 = data->simulationInfo->realParameter[5] /* generator.QMaxPu PARAM */;
    }
    else
    {
      tmp32 = (modelica_boolean)(data->simulationInfo->integerVarsPre[1] /* generator.qStatus DISCRETE */ == 3);
      if(tmp32)
      {
        tmp33 = data->simulationInfo->realParameter[6] /* generator.QMinPu PARAM */;
      }
      else
      {
        tmp33 = data->simulationInfo->realParameter[4] /* generator.QGen0Pu PARAM */;
      }
      tmp35 = tmp33;
    }
    tmp37 = tmp35;
  }
  else
  {
    tmp37 = 0.0;
  }
  data->localData[0]->realVars[8] /* generator.QGenPu variable */ = tmp37;
  TRACE_POP
}
/*
equation index: 94
type: SIMPLE_ASSIGN
generator._SGenPu._im = generator.QGenPu
*/
void GeneratorPQ_eqFunction_94(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,94};
  data->localData[0]->realVars[9] /* generator.SGenPu.im variable */ = data->localData[0]->realVars[8] /* generator.QGenPu variable */;
  TRACE_POP
}
/*
equation index: 95
type: SIMPLE_ASSIGN
$DAEres4 = generator.terminal.V.re * generator.terminal.i.im + (-generator.terminal.V.im) * generator.terminal.i.re - generator.SGenPu.im
*/
void GeneratorPQ_eqFunction_95(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,95};
  $P$DAEres4 = (data->localData[0]->realVars[2] /* generator.terminal.V.re STATE(1) */) * (data->localData[0]->realVars[12] /* generator.terminal.i.im variable */) + ((-data->localData[0]->realVars[1] /* generator.terminal.V.im STATE(1) */)) * (data->localData[0]->realVars[13] /* generator.terminal.i.re variable */) - data->localData[0]->realVars[9] /* generator.SGenPu.im variable */;
  TRACE_POP
}
/*
equation index: 101
type: WHEN

when {$whenCondition10} then
  noReturnCall(Dynawo.NonElectrical.Logs.Timeline.logEvent1(58))%>);
end when;
*/
void GeneratorPQ_eqFunction_101(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,101};
  if((data->localData[0]->booleanVars[1] /* $whenCondition10 DISCRETE */ && !data->simulationInfo->booleanVarsPre[1] /* $whenCondition10 DISCRETE */ /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1(threadData, ((modelica_integer) 58));
  }
  else if((data->localData[0]->booleanVars[9] /* $whenCondition9 DISCRETE */ && !data->simulationInfo->booleanVarsPre[9] /* $whenCondition9 DISCRETE */ /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1(threadData, ((modelica_integer) 29));
  }
  else if((data->localData[0]->booleanVars[8] /* $whenCondition8 DISCRETE */ && !data->simulationInfo->booleanVarsPre[8] /* $whenCondition8 DISCRETE */ /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1(threadData, ((modelica_integer) 48));
  }
  TRACE_POP
}
/*
equation index: 100
type: WHEN

when {$whenCondition7} then
  noReturnCall(Dynawo.NonElectrical.Logs.Timeline.logEvent1(54))%>);
end when;
*/
void GeneratorPQ_eqFunction_100(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,100};
  if((data->localData[0]->booleanVars[7] /* $whenCondition7 DISCRETE */ && !data->simulationInfo->booleanVarsPre[7] /* $whenCondition7 DISCRETE */ /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1(threadData, ((modelica_integer) 54));
  }
  TRACE_POP
}
/*
equation index: 96
type: WHEN

when {$whenCondition5} then
  noReturnCall(Dynawo.NonElectrical.Logs.Timeline.logEvent1(23))%>);
end when;
*/
void GeneratorPQ_eqFunction_96(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,96};
  if((data->localData[0]->booleanVars[5] /* $whenCondition5 DISCRETE */ && !data->simulationInfo->booleanVarsPre[5] /* $whenCondition5 DISCRETE */ /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1(threadData, ((modelica_integer) 23));
  }
  else if((data->localData[0]->booleanVars[4] /* $whenCondition4 DISCRETE */ && !data->simulationInfo->booleanVarsPre[4] /* $whenCondition4 DISCRETE */ /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1(threadData, ((modelica_integer) 15));
  }
  else if((data->localData[0]->booleanVars[3] /* $whenCondition3 DISCRETE */ && !data->simulationInfo->booleanVarsPre[3] /* $whenCondition3 DISCRETE */ /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1(threadData, ((modelica_integer) 68));
  }
  else if((data->localData[0]->booleanVars[2] /* $whenCondition2 DISCRETE */ && !data->simulationInfo->booleanVarsPre[2] /* $whenCondition2 DISCRETE */ /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1(threadData, ((modelica_integer) 10));
  }
  TRACE_POP
}

/* for residuals DAE variables */
OMC_DISABLE_OPT
int GeneratorPQ_evaluateDAEResiduals(DATA *data, threadData_t *threadData, int currentEvalStage)
{
  TRACE_PUSH
  int evalStages;
  data->simulationInfo->callStatistics.functionEvalDAE++;

  evalStages = 0+2+4+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_63(data, threadData);
  evalStages = 0+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_64(data, threadData);
  evalStages = 0+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_65(data, threadData);
  evalStages = 0+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_66(data, threadData);
  evalStages = 0+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(1):0))
    GeneratorPQ_eqFunction_67(data, threadData);
  evalStages = 0+1+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_70(data, threadData);
  evalStages = 0+1+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_71(data, threadData);
  evalStages = 0+1+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_72(data, threadData);
  evalStages = 0+1+2+4+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_73(data, threadData);
  evalStages = 0+1+2+4+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(1):0))
    GeneratorPQ_eqFunction_74(data, threadData);
  evalStages = 0+1+2+4+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(1):0))
    GeneratorPQ_eqFunction_75(data, threadData);
  evalStages = 0+1+2+4+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(1):0))
    GeneratorPQ_eqFunction_76(data, threadData);
  evalStages = 0+1+2+4+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_77(data, threadData);
  evalStages = 0+1+2+4+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(1):0))
    GeneratorPQ_eqFunction_78(data, threadData);
  evalStages = 0+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_79(data, threadData);
  evalStages = 0+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(1):0))
    GeneratorPQ_eqFunction_80(data, threadData);
  evalStages = 0+1+2+4+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_81(data, threadData);
  evalStages = 0+1+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_82(data, threadData);
  evalStages = 0+1+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_83(data, threadData);
  evalStages = 0+1+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_84(data, threadData);
  evalStages = 0+1+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_85(data, threadData);
  evalStages = 0+1+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(1):0))
    GeneratorPQ_eqFunction_86(data, threadData);
  evalStages = 0+1+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_90(data, threadData);
  evalStages = 0+1+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_91(data, threadData);
  evalStages = 0+1+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_92(data, threadData);
  evalStages = 0+1+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_93(data, threadData);
  evalStages = 0+1+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_94(data, threadData);
  evalStages = 0+1+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_95(data, threadData);
  evalStages = 0;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_101(data, threadData);
  evalStages = 0;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_100(data, threadData);
  evalStages = 0;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_eqFunction_96(data, threadData);
  
  TRACE_POP
  return 0;
}

/* initialize the daeMode variables */
OMC_DISABLE_OPT
int GeneratorPQ_initializeDAEmodeData(DATA *inData, DAEMODE_DATA* daeModeData)
{
  TRACE_PUSH
  DATA* data = ((DATA*)inData);
  /* sparse patterns */
  const int colPtrIndex[1+5] = {0,2,3,3,2,2};
  const int rowIndex[12] = {2,3,1,3,4,0,3,4,3,4,3,4};
  const int algIndexes[2] = {12,13};
  int i = 0;
  
  daeModeData->nResidualVars = 5;
  daeModeData->nAlgebraicDAEVars = 2;
  daeModeData->nAuxiliaryVars = 0;
  
  daeModeData->residualVars = (double*) malloc(sizeof(double)*5);
  daeModeData->auxiliaryVars = (double*) malloc(sizeof(double)*0);
  
  /* set the function pointer */
  daeModeData->evaluateDAEResiduals = GeneratorPQ_evaluateDAEResiduals;
  
  /* prepare algebraic indexes */
  daeModeData->algIndexes = (int*) malloc(sizeof(int)*2);
  memcpy(daeModeData->algIndexes, algIndexes, 2*sizeof(int));
  /* intialize sparse pattern */
  daeModeData->sparsePattern = (SPARSE_PATTERN*) malloc(sizeof(SPARSE_PATTERN));
  
  daeModeData->sparsePattern->leadindex = (unsigned int*) malloc((5+1)*sizeof(int));
  daeModeData->sparsePattern->index = (unsigned int*) malloc(12*sizeof(int));
  daeModeData->sparsePattern->numberOfNoneZeros = 12;
  daeModeData->sparsePattern->colorCols = (unsigned int*) malloc(5*sizeof(int));
  daeModeData->sparsePattern->maxColors = 5;
  
  /* write lead index of compressed sparse column */
  memcpy(daeModeData->sparsePattern->leadindex, colPtrIndex, (1+5)*sizeof(int));
  /* makek CRS compatible */
  for(i=2;i<5+1;++i)
    daeModeData->sparsePattern->leadindex[i] += daeModeData->sparsePattern->leadindex[i-1];
  /* call sparse index */
  memcpy(daeModeData->sparsePattern->index, rowIndex, 12*sizeof(int));
  
  /* write color array */
  daeModeData->sparsePattern->colorCols[3] = 1;
  daeModeData->sparsePattern->colorCols[4] = 2;
  daeModeData->sparsePattern->colorCols[2] = 3;
  daeModeData->sparsePattern->colorCols[1] = 4;
  daeModeData->sparsePattern->colorCols[0] = 5;
  TRACE_POP
  return 0;
}

#ifdef __cplusplus
}
#endif
