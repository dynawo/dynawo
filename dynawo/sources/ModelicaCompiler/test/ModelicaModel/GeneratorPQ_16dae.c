/* DAE residuals */
#include "GeneratorPQ_model.h"
#include "GeneratorPQ_16dae.h"
#include "simulation/solver/dae_mode.h"

#ifdef __cplusplus
extern "C" {
#endif

/*residual equations*/

/*
equation index: 73
type: SIMPLE_ASSIGN
generator.PGen = 100.0 * generator.PGenPu
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_73(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,73};
  (data->localData[0]->realVars[8] /* generator.PGen variable */) = (100.0) * ((data->localData[0]->realVars[9] /* generator.PGenPu variable */));
  TRACE_POP
}
/*
equation index: 74
type: SIMPLE_ASSIGN
$DAEres6 = generator.terminal.V.re * generator.terminal.i.im + (-generator.terminal.V.im) * generator.terminal.i.re - generator.SGenPu.im
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_74(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,74};
  (data->simulationInfo->daeModeData->residualVars[6]) /* $DAEres6 DAE_RESIDUAL_VAR */ = ((data->localData[0]->realVars[3] /* generator.terminal.V.re STATE(1) */)) * ((data->localData[0]->realVars[14] /* generator.terminal.i.im variable */)) + ((-(data->localData[0]->realVars[2] /* generator.terminal.V.im STATE(1) */))) * ((data->localData[0]->realVars[15] /* generator.terminal.i.re variable */)) - (data->localData[0]->realVars[11] /* generator.SGenPu.im variable */);
  TRACE_POP
}
/*
equation index: 75
type: SIMPLE_ASSIGN
$DAEres4 = (-generator.terminal.V.re) * generator.terminal.i.re - generator.PGenPu - generator.terminal.V.im * generator.terminal.i.im
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_75(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,75};
  (data->simulationInfo->daeModeData->residualVars[4]) /* $DAEres4 DAE_RESIDUAL_VAR */ = ((-(data->localData[0]->realVars[3] /* generator.terminal.V.re STATE(1) */))) * ((data->localData[0]->realVars[15] /* generator.terminal.i.re variable */)) - (data->localData[0]->realVars[9] /* generator.PGenPu variable */) - (((data->localData[0]->realVars[2] /* generator.terminal.V.im STATE(1) */)) * ((data->localData[0]->realVars[14] /* generator.terminal.i.im variable */)));
  TRACE_POP
}
/*
equation index: 76
type: SIMPLE_ASSIGN
$DAEres3 = der(generator.deltaPmRefPu.value)
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_76(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,76};
  (data->simulationInfo->daeModeData->residualVars[3]) /* $DAEres3 DAE_RESIDUAL_VAR */ = (data->localData[0]->realVars[4] /* der(generator.deltaPmRefPu.value) STATE_DER */);
  TRACE_POP
}
/*
equation index: 77
type: SIMPLE_ASSIGN
$DAEres2 = der(generator.terminal.V.re)
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_77(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,77};
  (data->simulationInfo->daeModeData->residualVars[2]) /* $DAEres2 DAE_RESIDUAL_VAR */ = (data->localData[0]->realVars[7] /* der(generator.terminal.V.re) STATE_DER */);
  TRACE_POP
}
/*
equation index: 78
type: SIMPLE_ASSIGN
$DAEres1 = der(generator.terminal.V.im)
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_78(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,78};
  (data->simulationInfo->daeModeData->residualVars[1]) /* $DAEres1 DAE_RESIDUAL_VAR */ = (data->localData[0]->realVars[6] /* der(generator.terminal.V.im) STATE_DER */);
  TRACE_POP
}
/*
equation index: 79
type: SIMPLE_ASSIGN
$DAEres0 = der(generator.omegaRefPu.value)
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_79(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,79};
  (data->simulationInfo->daeModeData->residualVars[0]) /* $DAEres0 DAE_RESIDUAL_VAR */ = (data->localData[0]->realVars[5] /* der(generator.omegaRefPu.value) STATE_DER */);
  TRACE_POP
}
/*
equation index: 80
type: SIMPLE_ASSIGN
$whenCondition9 = time > 999999.0
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_80(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,80};
  modelica_boolean tmp0;
  modelica_real tmp1;
  modelica_real tmp2;
  tmp1 = 1.0;
  tmp2 = 999999.0;
  relationhysteresis(data, &tmp0, data->localData[0]->timeValue, 999999.0, tmp1, tmp2, 4, Greater, GreaterZC);
  (data->localData[0]->booleanVars[8] /* $whenCondition9 DISCRETE */) = tmp0;
  TRACE_POP
}
/*
equation index: 81
type: WHEN

when {$whenCondition9} then
  generator.switchOffSignal1.value = false;
end when;
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_81(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,81};
  if(((data->localData[0]->booleanVars[8] /* $whenCondition9 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[8] /* $whenCondition9 DISCRETE */) /* edge */))
  {
    (data->localData[0]->booleanVars[10] /* generator.switchOffSignal1.value DISCRETE */) = 0 /* false */;
  }
  TRACE_POP
}
/*
equation index: 82
type: WHEN

when {$whenCondition9} then
  generator.switchOffSignal2.value = false;
end when;
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_82(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,82};
  if(((data->localData[0]->booleanVars[8] /* $whenCondition9 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[8] /* $whenCondition9 DISCRETE */) /* edge */))
  {
    (data->localData[0]->booleanVars[11] /* generator.switchOffSignal2.value DISCRETE */) = 0 /* false */;
  }
  TRACE_POP
}
/*
equation index: 83
type: WHEN

when {$whenCondition9} then
  generator.switchOffSignal3.value = false;
end when;
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_83(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,83};
  if(((data->localData[0]->booleanVars[8] /* $whenCondition9 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[8] /* $whenCondition9 DISCRETE */) /* edge */))
  {
    (data->localData[0]->booleanVars[12] /* generator.switchOffSignal3.value DISCRETE */) = 0 /* false */;
  }
  TRACE_POP
}
/*
equation index: 84
type: SIMPLE_ASSIGN
$whenCondition8 = generator.switchOffSignal1.value or generator.switchOffSignal2.value or generator.switchOffSignal3.value and pre(generator.running.value)
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_84(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,84};
  (data->localData[0]->booleanVars[7] /* $whenCondition8 DISCRETE */) = (((data->localData[0]->booleanVars[10] /* generator.switchOffSignal1.value DISCRETE */) || (data->localData[0]->booleanVars[11] /* generator.switchOffSignal2.value DISCRETE */)) || ((data->localData[0]->booleanVars[12] /* generator.switchOffSignal3.value DISCRETE */) && (data->simulationInfo->booleanVarsPre[9] /* generator.running.value DISCRETE */)));
  TRACE_POP
}
/*
equation index: 85
type: SIMPLE_ASSIGN
$whenCondition7 = not generator.switchOffSignal1.value and not generator.switchOffSignal2.value and not generator.switchOffSignal3.value and not pre(generator.running.value)
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_85(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,85};
  (data->localData[0]->booleanVars[6] /* $whenCondition7 DISCRETE */) = ((((!(data->localData[0]->booleanVars[10] /* generator.switchOffSignal1.value DISCRETE */)) && (!(data->localData[0]->booleanVars[11] /* generator.switchOffSignal2.value DISCRETE */))) && (!(data->localData[0]->booleanVars[12] /* generator.switchOffSignal3.value DISCRETE */))) && (!(data->simulationInfo->booleanVarsPre[9] /* generator.running.value DISCRETE */)));
  TRACE_POP
}
/*
equation index: 86
type: WHEN

when {$whenCondition8} then
  generator.running.value = false;
end when;
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_86(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,86};
  if(((data->localData[0]->booleanVars[7] /* $whenCondition8 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[7] /* $whenCondition8 DISCRETE */) /* edge */))
  {
    (data->localData[0]->booleanVars[9] /* generator.running.value DISCRETE */) = 0 /* false */;
  }
  else if(((data->localData[0]->booleanVars[6] /* $whenCondition7 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[6] /* $whenCondition7 DISCRETE */) /* edge */))
  {
    (data->localData[0]->booleanVars[9] /* generator.running.value DISCRETE */) = 1 /* true */;
  }
  TRACE_POP
}
/*
equation index: 88
type: SIMPLE_ASSIGN
generator.UPu = if generator.running.value then (generator.terminal.V.re ^ 2.0 + generator.terminal.V.im ^ 2.0) ^ 0.5 else 0.0
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_88(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,88};
  modelica_real tmp3;
  modelica_real tmp4;
  modelica_real tmp5;
  modelica_boolean tmp6;
  modelica_real tmp7;
  tmp6 = (modelica_boolean)(data->localData[0]->booleanVars[9] /* generator.running.value DISCRETE */);
  if(tmp6)
  {
    tmp3 = (data->localData[0]->realVars[3] /* generator.terminal.V.re STATE(1) */);
    tmp4 = (data->localData[0]->realVars[2] /* generator.terminal.V.im STATE(1) */);
    tmp7 = sqrt((tmp3 * tmp3) + (tmp4 * tmp4));
  }
  else
  {
    tmp7 = 0.0;
  }
  (data->localData[0]->realVars[12] /* generator.UPu variable */) = tmp7;
  TRACE_POP
}
/*
equation index: 89
type: SIMPLE_ASSIGN
generator.PGenRawPu = if generator.running.value then generator.PGen0Pu - (-0.01) * generator.deltaPmRefPu.value * generator.PNom - generator.AlphaPu * (generator.omegaRefPu.value - 1.0) else 0.0
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_89(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,89};
  modelica_boolean tmp8;
  modelica_real tmp9;
  tmp8 = (modelica_boolean)(data->localData[0]->booleanVars[9] /* generator.running.value DISCRETE */);
  if(tmp8)
  {
    tmp9 = (data->simulationInfo->realParameter[2] /* generator.PGen0Pu PARAM */) - ((-0.01) * (((data->localData[0]->realVars[0] /* generator.deltaPmRefPu.value STATE(1) */)) * ((data->simulationInfo->realParameter[7] /* generator.PNom PARAM */)))) - (((data->simulationInfo->realParameter[0] /* generator.AlphaPu PARAM */)) * ((data->localData[0]->realVars[1] /* generator.omegaRefPu.value STATE(1) */) - 1.0));
  }
  else
  {
    tmp9 = 0.0;
  }
  (data->localData[0]->realVars[10] /* generator.PGenRawPu variable */) = tmp9;
  TRACE_POP
}
/*
equation index: 90
type: SIMPLE_ASSIGN
$whenCondition4 = generator.PGenRawPu >= generator.PMaxPu and pre(generator.pStatus) <> generator.PStatus.LimitPMax
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_90(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,90};
  modelica_boolean tmp10;
  modelica_real tmp11;
  modelica_real tmp12;
  tmp11 = 1.0;
  tmp12 = fabs((data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */));
  relationhysteresis(data, &tmp10, (data->localData[0]->realVars[10] /* generator.PGenRawPu variable */), (data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */), tmp11, tmp12, 0, GreaterEq, GreaterEqZC);
  (data->localData[0]->booleanVars[3] /* $whenCondition4 DISCRETE */) = (tmp10 && ((data->simulationInfo->integerVarsPre[1] /* generator.pStatus DISCRETE */) != 3));
  TRACE_POP
}
/*
equation index: 91
type: SIMPLE_ASSIGN
$whenCondition3 = generator.PGenRawPu <= generator.PMinPu and pre(generator.pStatus) <> generator.PStatus.LimitPMin
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_91(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,91};
  modelica_boolean tmp13;
  modelica_real tmp14;
  modelica_real tmp15;
  tmp14 = 1.0;
  tmp15 = fabs((data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */));
  relationhysteresis(data, &tmp13, (data->localData[0]->realVars[10] /* generator.PGenRawPu variable */), (data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */), tmp14, tmp15, 1, LessEq, LessEqZC);
  (data->localData[0]->booleanVars[2] /* $whenCondition3 DISCRETE */) = (tmp13 && ((data->simulationInfo->integerVarsPre[1] /* generator.pStatus DISCRETE */) != 2));
  TRACE_POP
}
/*
equation index: 92
type: SIMPLE_ASSIGN
$whenCondition2 = generator.PGenRawPu > generator.PMinPu and pre(generator.pStatus) == generator.PStatus.LimitPMin
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_92(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,92};
  modelica_boolean tmp16;
  modelica_real tmp17;
  modelica_real tmp18;
  tmp17 = 1.0;
  tmp18 = fabs((data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */));
  relationhysteresis(data, &tmp16, (data->localData[0]->realVars[10] /* generator.PGenRawPu variable */), (data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */), tmp17, tmp18, 2, Greater, GreaterZC);
  (data->localData[0]->booleanVars[1] /* $whenCondition2 DISCRETE */) = (tmp16 && ((data->simulationInfo->integerVarsPre[1] /* generator.pStatus DISCRETE */) == 2));
  TRACE_POP
}
/*
equation index: 93
type: SIMPLE_ASSIGN
$whenCondition1 = generator.PGenRawPu < generator.PMaxPu and pre(generator.pStatus) == generator.PStatus.LimitPMax
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_93(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,93};
  modelica_boolean tmp19;
  modelica_real tmp20;
  modelica_real tmp21;
  tmp20 = 1.0;
  tmp21 = fabs((data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */));
  relationhysteresis(data, &tmp19, (data->localData[0]->realVars[10] /* generator.PGenRawPu variable */), (data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */), tmp20, tmp21, 3, Less, LessZC);
  (data->localData[0]->booleanVars[0] /* $whenCondition1 DISCRETE */) = (tmp19 && ((data->simulationInfo->integerVarsPre[1] /* generator.pStatus DISCRETE */) == 3));
  TRACE_POP
}
/*
equation index: 94
type: WHEN

when {$whenCondition4} then
  generator.pStatus = generator.PStatus.LimitPMax;
end when;
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_94(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,94};
  if(((data->localData[0]->booleanVars[3] /* $whenCondition4 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[3] /* $whenCondition4 DISCRETE */) /* edge */))
  {
    (data->localData[0]->integerVars[1] /* generator.pStatus DISCRETE */) = 3;
  }
  else if(((data->localData[0]->booleanVars[2] /* $whenCondition3 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[2] /* $whenCondition3 DISCRETE */) /* edge */))
  {
    (data->localData[0]->integerVars[1] /* generator.pStatus DISCRETE */) = 2;
  }
  else if(((data->localData[0]->booleanVars[1] /* $whenCondition2 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[1] /* $whenCondition2 DISCRETE */) /* edge */))
  {
    (data->localData[0]->integerVars[1] /* generator.pStatus DISCRETE */) = 1;
  }
  else if(((data->localData[0]->booleanVars[0] /* $whenCondition1 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[0] /* $whenCondition1 DISCRETE */) /* edge */))
  {
    (data->localData[0]->integerVars[1] /* generator.pStatus DISCRETE */) = 1;
  }
  TRACE_POP
}
/*
equation index: 98
type: SIMPLE_ASSIGN
$whenCondition6 = not generator.running.value
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_98(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,98};
  (data->localData[0]->booleanVars[5] /* $whenCondition6 DISCRETE */) = (!(data->localData[0]->booleanVars[9] /* generator.running.value DISCRETE */));
  TRACE_POP
}
/*
equation index: 99
type: SIMPLE_ASSIGN
$whenCondition5 = generator.running.value and not pre(generator.running.value)
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_99(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,99};
  (data->localData[0]->booleanVars[4] /* $whenCondition5 DISCRETE */) = ((data->localData[0]->booleanVars[9] /* generator.running.value DISCRETE */) && (!(data->simulationInfo->booleanVarsPre[9] /* generator.running.value DISCRETE */)));
  TRACE_POP
}
/*
equation index: 100
type: WHEN

when {$whenCondition6} then
  generator.state = Dynawo.Electrical.Constants.state.Open;
end when;
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_100(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,100};
  if(((data->localData[0]->booleanVars[5] /* $whenCondition6 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[5] /* $whenCondition6 DISCRETE */) /* edge */))
  {
    (data->localData[0]->integerVars[2] /* generator.state DISCRETE */) = 1;
  }
  else if(((data->localData[0]->booleanVars[4] /* $whenCondition5 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[4] /* $whenCondition5 DISCRETE */) /* edge */))
  {
    (data->localData[0]->integerVars[2] /* generator.state DISCRETE */) = 2;
  }
  TRACE_POP
}
/*
equation index: 102
type: SIMPLE_ASSIGN
generator.converter.u = Integer(generator.state)
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_102(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,102};
  (data->localData[0]->integerVars[0] /* generator.converter.u DISCRETE */) = ((modelica_integer)((data->localData[0]->integerVars[2] /* generator.state DISCRETE */)));
  TRACE_POP
}
/*
equation index: 103
type: SIMPLE_ASSIGN
generator.genState = (*Real*)(generator.converter.u)
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_103(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,103};
  (data->localData[0]->realVars[13] /* generator.genState variable */) = ((modelica_real)(data->localData[0]->integerVars[0] /* generator.converter.u DISCRETE */));
  TRACE_POP
}
/*
equation index: 104
type: SIMPLE_ASSIGN
$DAEres5 = if generator.running.value then generator.SGenPu.im - generator.QGen0Pu else generator.terminal.i.im
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_104(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,104};
  modelica_boolean tmp22;
  modelica_real tmp23;
  tmp22 = (modelica_boolean)(data->localData[0]->booleanVars[9] /* generator.running.value DISCRETE */);
  if(tmp22)
  {
    tmp23 = (data->localData[0]->realVars[11] /* generator.SGenPu.im variable */) - (data->simulationInfo->realParameter[8] /* generator.QGen0Pu PARAM */);
  }
  else
  {
    tmp23 = (data->localData[0]->realVars[14] /* generator.terminal.i.im variable */);
  }
  (data->simulationInfo->daeModeData->residualVars[5]) /* $DAEres5 DAE_RESIDUAL_VAR */ = tmp23;
  TRACE_POP
}
/*
equation index: 105
type: SIMPLE_ASSIGN
$DAEres7 = if generator.running.value then generator.PGenPu - (if generator.pStatus == generator.PStatus.LimitPMax then generator.PMaxPu else if generator.pStatus == generator.PStatus.LimitPMin then generator.PMinPu else generator.PGenRawPu) else generator.terminal.i.re
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_105(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,105};
  modelica_boolean tmp24;
  modelica_real tmp25;
  modelica_boolean tmp26;
  modelica_real tmp27;
  modelica_boolean tmp28;
  modelica_real tmp29;
  tmp28 = (modelica_boolean)(data->localData[0]->booleanVars[9] /* generator.running.value DISCRETE */);
  if(tmp28)
  {
    tmp26 = (modelica_boolean)((data->localData[0]->integerVars[1] /* generator.pStatus DISCRETE */) == 3);
    if(tmp26)
    {
      tmp27 = (data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */);
    }
    else
    {
      tmp24 = (modelica_boolean)((data->localData[0]->integerVars[1] /* generator.pStatus DISCRETE */) == 2);
      if(tmp24)
      {
        tmp25 = (data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */);
      }
      else
      {
        tmp25 = (data->localData[0]->realVars[10] /* generator.PGenRawPu variable */);
      }
      tmp27 = tmp25;
    }
    tmp29 = (data->localData[0]->realVars[9] /* generator.PGenPu variable */) - (tmp27);
  }
  else
  {
    tmp29 = (data->localData[0]->realVars[15] /* generator.terminal.i.re variable */);
  }
  (data->simulationInfo->daeModeData->residualVars[7]) /* $DAEres7 DAE_RESIDUAL_VAR */ = tmp29;
  TRACE_POP
}
/*
equation index: 110
type: WHEN

when {$whenCondition6} then
  noReturnCall(Dynawo.NonElectrical.Logs.Timeline.logEvent1(28))%>);
end when;
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_110(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,110};
  if(((data->localData[0]->booleanVars[5] /* $whenCondition6 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[5] /* $whenCondition6 DISCRETE */) /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1(threadData, ((modelica_integer) 28));
  }
  else if(((data->localData[0]->booleanVars[4] /* $whenCondition5 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[4] /* $whenCondition5 DISCRETE */) /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1(threadData, ((modelica_integer) 27));
  }
  TRACE_POP
}
/*
equation index: 106
type: WHEN

when {$whenCondition4} then
  noReturnCall(Dynawo.NonElectrical.Logs.Timeline.logEvent1(0))%>);
end when;
*/
OMC_DISABLE_OPT
void GeneratorPQ_eqFunction_106(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,106};
  if(((data->localData[0]->booleanVars[3] /* $whenCondition4 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[3] /* $whenCondition4 DISCRETE */) /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1(threadData, ((modelica_integer) 0));
  }
  else if(((data->localData[0]->booleanVars[2] /* $whenCondition3 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[2] /* $whenCondition3 DISCRETE */) /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1(threadData, ((modelica_integer) 1));
  }
  else if(((data->localData[0]->booleanVars[1] /* $whenCondition2 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[1] /* $whenCondition2 DISCRETE */) /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1(threadData, ((modelica_integer) 21));
  }
  else if(((data->localData[0]->booleanVars[0] /* $whenCondition1 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[0] /* $whenCondition1 DISCRETE */) /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1(threadData, ((modelica_integer) 20));
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

#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_tick(SIM_TIMER_DAE);
#endif

  evalStages = 0+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_73(data, threadData);
    threadData->lastEquationSolved = 73;
  }
  evalStages = 0+1+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_74(data, threadData);
    threadData->lastEquationSolved = 74;
  }
  evalStages = 0+1+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_75(data, threadData);
    threadData->lastEquationSolved = 75;
  }
  evalStages = 0+1+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_76(data, threadData);
    threadData->lastEquationSolved = 76;
  }
  evalStages = 0+1+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_77(data, threadData);
    threadData->lastEquationSolved = 77;
  }
  evalStages = 0+1+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_78(data, threadData);
    threadData->lastEquationSolved = 78;
  }
  evalStages = 0+1+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_79(data, threadData);
    threadData->lastEquationSolved = 79;
  }
  evalStages = 0+1+2+4+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_80(data, threadData);
    threadData->lastEquationSolved = 80;
  }
  evalStages = 0+1+2+4+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(1):0)) {
    GeneratorPQ_eqFunction_81(data, threadData);
    threadData->lastEquationSolved = 81;
  }
  evalStages = 0+1+2+4+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(1):0)) {
    GeneratorPQ_eqFunction_82(data, threadData);
    threadData->lastEquationSolved = 82;
  }
  evalStages = 0+1+2+4+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(1):0)) {
    GeneratorPQ_eqFunction_83(data, threadData);
    threadData->lastEquationSolved = 83;
  }
  evalStages = 0+1+2+4+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_84(data, threadData);
    threadData->lastEquationSolved = 84;
  }
  evalStages = 0+1+2+4+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_85(data, threadData);
    threadData->lastEquationSolved = 85;
  }
  evalStages = 0+1+2+4+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(1):0)) {
    GeneratorPQ_eqFunction_86(data, threadData);
    threadData->lastEquationSolved = 86;
  }
  evalStages = 0+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_88(data, threadData);
    threadData->lastEquationSolved = 88;
  }
  evalStages = 0+1+2+4+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_89(data, threadData);
    threadData->lastEquationSolved = 89;
  }
  evalStages = 0+1+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_90(data, threadData);
    threadData->lastEquationSolved = 90;
  }
  evalStages = 0+1+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_91(data, threadData);
    threadData->lastEquationSolved = 91;
  }
  evalStages = 0+1+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_92(data, threadData);
    threadData->lastEquationSolved = 92;
  }
  evalStages = 0+1+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_93(data, threadData);
    threadData->lastEquationSolved = 93;
  }
  evalStages = 0+1+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(1):0)) {
    GeneratorPQ_eqFunction_94(data, threadData);
    threadData->lastEquationSolved = 94;
  }
  evalStages = 0+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_98(data, threadData);
    threadData->lastEquationSolved = 98;
  }
  evalStages = 0+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_99(data, threadData);
    threadData->lastEquationSolved = 99;
  }
  evalStages = 0+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(1):0)) {
    GeneratorPQ_eqFunction_100(data, threadData);
    threadData->lastEquationSolved = 100;
  }
  evalStages = 0+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_102(data, threadData);
    threadData->lastEquationSolved = 102;
  }
  evalStages = 0+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_103(data, threadData);
    threadData->lastEquationSolved = 103;
  }
  evalStages = 0+1+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_104(data, threadData);
    threadData->lastEquationSolved = 104;
  }
  evalStages = 0+1+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_105(data, threadData);
    threadData->lastEquationSolved = 105;
  }
  evalStages = 0+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_110(data, threadData);
    threadData->lastEquationSolved = 110;
  }
  evalStages = 0+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_eqFunction_106(data, threadData);
    threadData->lastEquationSolved = 106;
  }

#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_accumulate(SIM_TIMER_DAE);
#endif

  TRACE_POP
  return 0;
}

/* initialize the daeMode variables */
OMC_DISABLE_OPT
int GeneratorPQ_initializeDAEmodeData(DATA* data, DAEMODE_DATA* daeModeData)
{
  TRACE_PUSH
  /* sparse patterns */
  const int colPtrIndex[1+8] = {0,2,2,3,3,2,2,3,3};
  const int rowIndex[20] = {3,7,0,7,1,4,6,2,4,6,4,7,5,6,4,5,6,4,6,7};
  const int algIndexes[4] = {9,11,14,15};
  int i = 0;
  
  daeModeData->nResidualVars = 8;
  daeModeData->nAlgebraicDAEVars = 4;
  daeModeData->nAuxiliaryVars = 0;
  
  daeModeData->residualVars = (double*) malloc(sizeof(double)*8);
  daeModeData->auxiliaryVars = (double*) malloc(sizeof(double)*0);
  
  /* set the function pointer */
  daeModeData->evaluateDAEResiduals = GeneratorPQ_evaluateDAEResiduals;
  
  /* prepare algebraic indexes */
  daeModeData->algIndexes = (int*) malloc(sizeof(int)*4);
  memcpy(daeModeData->algIndexes, algIndexes, 4*sizeof(int));
  /* intialize sparse pattern */
  daeModeData->sparsePattern = allocSparsePattern(8, 20, 5);
  
  /* write lead index of compressed sparse column */
  memcpy(daeModeData->sparsePattern->leadindex, colPtrIndex, (1+8)*sizeof(int));
  /* makek CRS compatible */
  for(i=2;i<8+1;++i)
    daeModeData->sparsePattern->leadindex[i] += daeModeData->sparsePattern->leadindex[i-1];
  /* call sparse index */
  memcpy(daeModeData->sparsePattern->index, rowIndex, 20*sizeof(int));
  
  /* write color array */
  /* color 1 with 1 columns */
  const int indices_1[1] = {6};
  for(i=0; i<1; i++)
    daeModeData->sparsePattern->colorCols[indices_1[i]] = 1;

  /* color 2 with 2 columns */
  const int indices_2[2] = {5, 4};
  for(i=0; i<2; i++)
    daeModeData->sparsePattern->colorCols[indices_2[i]] = 2;

  /* color 3 with 1 columns */
  const int indices_3[1] = {7};
  for(i=0; i<1; i++)
    daeModeData->sparsePattern->colorCols[indices_3[i]] = 3;

  /* color 4 with 2 columns */
  const int indices_4[2] = {2, 1};
  for(i=0; i<2; i++)
    daeModeData->sparsePattern->colorCols[indices_4[i]] = 4;

  /* color 5 with 2 columns */
  const int indices_5[2] = {0, 3};
  for(i=0; i<2; i++)
    daeModeData->sparsePattern->colorCols[indices_5[i]] = 5;
  TRACE_POP
  return 0;
}

#ifdef __cplusplus
}
#endif
