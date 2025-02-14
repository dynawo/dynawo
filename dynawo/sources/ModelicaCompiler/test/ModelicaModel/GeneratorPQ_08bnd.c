/* update bound parameters and variable attributes (start, nominal, min, max) */
#include "GeneratorPQ_model.h"
#include "GeneratorPQ_16dae.h"
#if defined(__cplusplus)
extern "C" {
#endif


/*
equation index: 49
type: SIMPLE_ASSIGN
$START.generator.switchOffSignal1.value = generator.SwitchOffSignal10
*/
static void GeneratorPQ_eqFunction_49(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,49};
  (data->modelData->booleanVarsData[10] /* generator.switchOffSignal1.value DISCRETE */).attribute .start = (data->simulationInfo->booleanParameter[1] /* generator.SwitchOffSignal10 PARAM */);
    (data->localData[0]->booleanVars[10] /* generator.switchOffSignal1.value DISCRETE */) = (data->modelData->booleanVarsData[10] /* generator.switchOffSignal1.value DISCRETE */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start=%d)", data->modelData->booleanVarsData[10].info /* generator.switchOffSignal1.value */.name, (modelica_boolean) (data->localData[0]->booleanVars[10] /* generator.switchOffSignal1.value DISCRETE */));
  TRACE_POP
}

/*
equation index: 50
type: SIMPLE_ASSIGN
$START.generator.switchOffSignal2.value = generator.SwitchOffSignal20
*/
static void GeneratorPQ_eqFunction_50(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,50};
  (data->modelData->booleanVarsData[11] /* generator.switchOffSignal2.value DISCRETE */).attribute .start = (data->simulationInfo->booleanParameter[2] /* generator.SwitchOffSignal20 PARAM */);
    (data->localData[0]->booleanVars[11] /* generator.switchOffSignal2.value DISCRETE */) = (data->modelData->booleanVarsData[11] /* generator.switchOffSignal2.value DISCRETE */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start=%d)", data->modelData->booleanVarsData[11].info /* generator.switchOffSignal2.value */.name, (modelica_boolean) (data->localData[0]->booleanVars[11] /* generator.switchOffSignal2.value DISCRETE */));
  TRACE_POP
}

/*
equation index: 51
type: SIMPLE_ASSIGN
$START.generator.switchOffSignal3.value = generator.SwitchOffSignal30
*/
static void GeneratorPQ_eqFunction_51(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,51};
  (data->modelData->booleanVarsData[12] /* generator.switchOffSignal3.value DISCRETE */).attribute .start = (data->simulationInfo->booleanParameter[3] /* generator.SwitchOffSignal30 PARAM */);
    (data->localData[0]->booleanVars[12] /* generator.switchOffSignal3.value DISCRETE */) = (data->modelData->booleanVarsData[12] /* generator.switchOffSignal3.value DISCRETE */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start=%d)", data->modelData->booleanVarsData[12].info /* generator.switchOffSignal3.value */.name, (modelica_boolean) (data->localData[0]->booleanVars[12] /* generator.switchOffSignal3.value DISCRETE */));
  TRACE_POP
}

/*
equation index: 52
type: SIMPLE_ASSIGN
$START.generator.running.value = generator.Running0
*/
static void GeneratorPQ_eqFunction_52(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,52};
  (data->modelData->booleanVarsData[9] /* generator.running.value DISCRETE */).attribute .start = (data->simulationInfo->booleanParameter[0] /* generator.Running0 PARAM */);
    (data->localData[0]->booleanVars[9] /* generator.running.value DISCRETE */) = (data->modelData->booleanVarsData[9] /* generator.running.value DISCRETE */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start=%d)", data->modelData->booleanVarsData[9].info /* generator.running.value */.name, (modelica_boolean) (data->localData[0]->booleanVars[9] /* generator.running.value DISCRETE */));
  TRACE_POP
}

/*
equation index: 53
type: SIMPLE_ASSIGN
$START.generator.terminal.i.re = generator.i0Pu.re
*/
static void GeneratorPQ_eqFunction_53(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,53};
  (data->modelData->realVarsData[15] /* generator.terminal.i.re variable */).attribute .start = (data->simulationInfo->realParameter[11] /* generator.i0Pu.re PARAM */);
    (data->localData[0]->realVars[15] /* generator.terminal.i.re variable */) = (data->modelData->realVarsData[15] /* generator.terminal.i.re variable */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[15].info /* generator.terminal.i.re */.name, (modelica_real) (data->localData[0]->realVars[15] /* generator.terminal.i.re variable */));
  TRACE_POP
}

/*
equation index: 54
type: SIMPLE_ASSIGN
$START.generator.terminal.i.im = generator.i0Pu.im
*/
static void GeneratorPQ_eqFunction_54(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,54};
  (data->modelData->realVarsData[14] /* generator.terminal.i.im variable */).attribute .start = (data->simulationInfo->realParameter[10] /* generator.i0Pu.im PARAM */);
    (data->localData[0]->realVars[14] /* generator.terminal.i.im variable */) = (data->modelData->realVarsData[14] /* generator.terminal.i.im variable */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[14].info /* generator.terminal.i.im */.name, (modelica_real) (data->localData[0]->realVars[14] /* generator.terminal.i.im variable */));
  TRACE_POP
}

/*
equation index: 55
type: SIMPLE_ASSIGN
$START.generator.PGen = 100.0 * generator.PGen0Pu
*/
static void GeneratorPQ_eqFunction_55(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,55};
  (data->modelData->realVarsData[8] /* generator.PGen variable */).attribute .start = (100.0) * ((data->simulationInfo->realParameter[2] /* generator.PGen0Pu PARAM */));
    (data->localData[0]->realVars[8] /* generator.PGen variable */) = (data->modelData->realVarsData[8] /* generator.PGen variable */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[8].info /* generator.PGen */.name, (modelica_real) (data->localData[0]->realVars[8] /* generator.PGen variable */));
  TRACE_POP
}

/*
equation index: 56
type: SIMPLE_ASSIGN
$START.generator.PGenPu = generator.PGen0Pu
*/
static void GeneratorPQ_eqFunction_56(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,56};
  (data->modelData->realVarsData[9] /* generator.PGenPu variable */).attribute .start = (data->simulationInfo->realParameter[2] /* generator.PGen0Pu PARAM */);
    (data->localData[0]->realVars[9] /* generator.PGenPu variable */) = (data->modelData->realVarsData[9] /* generator.PGenPu variable */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[9].info /* generator.PGenPu */.name, (modelica_real) (data->localData[0]->realVars[9] /* generator.PGenPu variable */));
  TRACE_POP
}

/*
equation index: 57
type: SIMPLE_ASSIGN
$START.generator.SGenPu.im = generator.QGen0Pu
*/
static void GeneratorPQ_eqFunction_57(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,57};
  (data->modelData->realVarsData[11] /* generator.SGenPu.im variable */).attribute .start = (data->simulationInfo->realParameter[8] /* generator.QGen0Pu PARAM */);
    (data->localData[0]->realVars[11] /* generator.SGenPu.im variable */) = (data->modelData->realVarsData[11] /* generator.SGenPu.im variable */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[11].info /* generator.SGenPu.im */.name, (modelica_real) (data->localData[0]->realVars[11] /* generator.SGenPu.im variable */));
  TRACE_POP
}

/*
equation index: 58
type: SIMPLE_ASSIGN
$START.generator.UPu = generator.U0Pu
*/
static void GeneratorPQ_eqFunction_58(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,58};
  (data->modelData->realVarsData[12] /* generator.UPu variable */).attribute .start = (data->simulationInfo->realParameter[9] /* generator.U0Pu PARAM */);
    (data->localData[0]->realVars[12] /* generator.UPu variable */) = (data->modelData->realVarsData[12] /* generator.UPu variable */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[12].info /* generator.UPu */.name, (modelica_real) (data->localData[0]->realVars[12] /* generator.UPu variable */));
  TRACE_POP
}

/*
equation index: 59
type: SIMPLE_ASSIGN
$START.generator.PGenRawPu = generator.PGen0Pu
*/
static void GeneratorPQ_eqFunction_59(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,59};
  (data->modelData->realVarsData[10] /* generator.PGenRawPu variable */).attribute .start = (data->simulationInfo->realParameter[2] /* generator.PGen0Pu PARAM */);
    (data->localData[0]->realVars[10] /* generator.PGenRawPu variable */) = (data->modelData->realVarsData[10] /* generator.PGenRawPu variable */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[10].info /* generator.PGenRawPu */.name, (modelica_real) (data->localData[0]->realVars[10] /* generator.PGenRawPu variable */));
  TRACE_POP
}

/*
equation index: 60
type: SIMPLE_ASSIGN
$START.generator.terminal.V.im = generator.u0Pu.im
*/
static void GeneratorPQ_eqFunction_60(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,60};
  (data->modelData->realVarsData[2] /* generator.terminal.V.im STATE(1) */).attribute .start = (data->simulationInfo->realParameter[12] /* generator.u0Pu.im PARAM */);
    (data->localData[0]->realVars[2] /* generator.terminal.V.im STATE(1) */) = (data->modelData->realVarsData[2] /* generator.terminal.V.im STATE(1) */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[2].info /* generator.terminal.V.im */.name, (modelica_real) (data->localData[0]->realVars[2] /* generator.terminal.V.im STATE(1) */));
  TRACE_POP
}

/*
equation index: 61
type: SIMPLE_ASSIGN
$START.generator.terminal.V.re = generator.u0Pu.re
*/
static void GeneratorPQ_eqFunction_61(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,61};
  (data->modelData->realVarsData[3] /* generator.terminal.V.re STATE(1) */).attribute .start = (data->simulationInfo->realParameter[13] /* generator.u0Pu.re PARAM */);
    (data->localData[0]->realVars[3] /* generator.terminal.V.re STATE(1) */) = (data->modelData->realVarsData[3] /* generator.terminal.V.re STATE(1) */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[3].info /* generator.terminal.V.re */.name, (modelica_real) (data->localData[0]->realVars[3] /* generator.terminal.V.re STATE(1) */));
  TRACE_POP
}

/*
equation index: 62
type: SIMPLE_ASSIGN
$START.$PRE.generator.running.value = generator.Running0
*/
static void GeneratorPQ_eqFunction_62(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,62};
  (data->modelData->booleanVarsData[9] /* generator.running.value DISCRETE */).attribute .start = (data->simulationInfo->booleanParameter[0] /* generator.Running0 PARAM */);
    (data->simulationInfo->booleanVarsPre[9] /* generator.running.value DISCRETE */) = (data->modelData->booleanVarsData[9] /* generator.running.value DISCRETE */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start=%d)", data->modelData->realVarsData[-2].info /* ERROR_cref2simvar_failed $PRE.generator.running.value */.name, (modelica_boolean) (data->simulationInfo->booleanVarsPre[9] /* generator.running.value DISCRETE */));
  TRACE_POP
}

/*
equation index: 63
type: SIMPLE_ASSIGN
$START.$PRE.generator.switchOffSignal3.value = generator.SwitchOffSignal30
*/
static void GeneratorPQ_eqFunction_63(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,63};
  (data->modelData->booleanVarsData[12] /* generator.switchOffSignal3.value DISCRETE */).attribute .start = (data->simulationInfo->booleanParameter[3] /* generator.SwitchOffSignal30 PARAM */);
    (data->simulationInfo->booleanVarsPre[12] /* generator.switchOffSignal3.value DISCRETE */) = (data->modelData->booleanVarsData[12] /* generator.switchOffSignal3.value DISCRETE */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start=%d)", data->modelData->realVarsData[-2].info /* ERROR_cref2simvar_failed $PRE.generator.switchOffSignal3.value */.name, (modelica_boolean) (data->simulationInfo->booleanVarsPre[12] /* generator.switchOffSignal3.value DISCRETE */));
  TRACE_POP
}

/*
equation index: 64
type: SIMPLE_ASSIGN
$START.$PRE.generator.switchOffSignal2.value = generator.SwitchOffSignal20
*/
static void GeneratorPQ_eqFunction_64(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,64};
  (data->modelData->booleanVarsData[11] /* generator.switchOffSignal2.value DISCRETE */).attribute .start = (data->simulationInfo->booleanParameter[2] /* generator.SwitchOffSignal20 PARAM */);
    (data->simulationInfo->booleanVarsPre[11] /* generator.switchOffSignal2.value DISCRETE */) = (data->modelData->booleanVarsData[11] /* generator.switchOffSignal2.value DISCRETE */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start=%d)", data->modelData->realVarsData[-2].info /* ERROR_cref2simvar_failed $PRE.generator.switchOffSignal2.value */.name, (modelica_boolean) (data->simulationInfo->booleanVarsPre[11] /* generator.switchOffSignal2.value DISCRETE */));
  TRACE_POP
}

/*
equation index: 65
type: SIMPLE_ASSIGN
$START.$PRE.generator.switchOffSignal1.value = generator.SwitchOffSignal10
*/
static void GeneratorPQ_eqFunction_65(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,65};
  (data->modelData->booleanVarsData[10] /* generator.switchOffSignal1.value DISCRETE */).attribute .start = (data->simulationInfo->booleanParameter[1] /* generator.SwitchOffSignal10 PARAM */);
    (data->simulationInfo->booleanVarsPre[10] /* generator.switchOffSignal1.value DISCRETE */) = (data->modelData->booleanVarsData[10] /* generator.switchOffSignal1.value DISCRETE */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start=%d)", data->modelData->realVarsData[-2].info /* ERROR_cref2simvar_failed $PRE.generator.switchOffSignal1.value */.name, (modelica_boolean) (data->simulationInfo->booleanVarsPre[10] /* generator.switchOffSignal1.value DISCRETE */));
  TRACE_POP
}

/*
equation index: 46
type: SIMPLE_ASSIGN
$START.generator.state = generator.State0
*/
static void GeneratorPQ_eqFunction_46(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,46};
  (data->modelData->integerVarsData[2] /* generator.state DISCRETE */).attribute .start = (data->simulationInfo->integerParameter[1] /* generator.State0 PARAM */);
    (data->localData[0]->integerVars[2] /* generator.state DISCRETE */) = (data->modelData->integerVarsData[2] /* generator.state DISCRETE */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start="OMC_INT_FORMAT")", data->modelData->integerVarsData[2].info /* generator.state */.name, (modelica_integer) (data->localData[0]->integerVars[2] /* generator.state DISCRETE */));
  TRACE_POP
}

/*
equation index: 47
type: SIMPLE_ASSIGN
$START.generator.genState = (*Real*)(Integer(generator.State0))
*/
static void GeneratorPQ_eqFunction_47(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,47};
  (data->modelData->realVarsData[13] /* generator.genState variable */).attribute .start = ((modelica_real)((modelica_integer)((data->simulationInfo->integerParameter[1] /* generator.State0 PARAM */))));
    (data->localData[0]->realVars[13] /* generator.genState variable */) = (data->modelData->realVarsData[13] /* generator.genState variable */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[13].info /* generator.genState */.name, (modelica_real) (data->localData[0]->realVars[13] /* generator.genState variable */));
  TRACE_POP
}

/*
equation index: 48
type: SIMPLE_ASSIGN
$START.$PRE.generator.state = generator.State0
*/
static void GeneratorPQ_eqFunction_48(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,48};
  (data->modelData->integerVarsData[2] /* generator.state DISCRETE */).attribute .start = (data->simulationInfo->integerParameter[1] /* generator.State0 PARAM */);
    (data->simulationInfo->integerVarsPre[2] /* generator.state DISCRETE */) = (data->modelData->integerVarsData[2] /* generator.state DISCRETE */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start="OMC_INT_FORMAT")", data->modelData->realVarsData[-2].info /* ERROR_cref2simvar_failed $PRE.generator.state */.name, (modelica_integer) (data->simulationInfo->integerVarsPre[2] /* generator.state DISCRETE */));
  TRACE_POP
}

/*
equation index: 45
type: SIMPLE_ASSIGN
$START.$DER.generator.terminal.V.im = generator.u0Pu.im
*/
static void GeneratorPQ_eqFunction_45(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,45};
  (data->modelData->realVarsData[6] /* der(generator.terminal.V.im) STATE_DER */).attribute .start = (data->simulationInfo->realParameter[12] /* generator.u0Pu.im PARAM */);
    (data->localData[0]->realVars[6] /* der(generator.terminal.V.im) STATE_DER */) = (data->modelData->realVarsData[6] /* der(generator.terminal.V.im) STATE_DER */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[6].info /* der(generator.terminal.V.im) */.name, (modelica_real) (data->localData[0]->realVars[6] /* der(generator.terminal.V.im) STATE_DER */));
  TRACE_POP
}

/*
equation index: 44
type: SIMPLE_ASSIGN
$START.$DER.generator.terminal.V.re = generator.u0Pu.re
*/
static void GeneratorPQ_eqFunction_44(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,44};
  (data->modelData->realVarsData[7] /* der(generator.terminal.V.re) STATE_DER */).attribute .start = (data->simulationInfo->realParameter[13] /* generator.u0Pu.re PARAM */);
    (data->localData[0]->realVars[7] /* der(generator.terminal.V.re) STATE_DER */) = (data->modelData->realVarsData[7] /* der(generator.terminal.V.re) STATE_DER */).attribute .start;
    infoStreamPrint(LOG_INIT_V, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[7].info /* der(generator.terminal.V.re) */.name, (modelica_real) (data->localData[0]->realVars[7] /* der(generator.terminal.V.re) STATE_DER */));
  TRACE_POP
}
OMC_DISABLE_OPT
int GeneratorPQ_updateBoundVariableAttributes(DATA *data, threadData_t *threadData)
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
  GeneratorPQ_eqFunction_49(data, threadData);

  GeneratorPQ_eqFunction_50(data, threadData);

  GeneratorPQ_eqFunction_51(data, threadData);

  GeneratorPQ_eqFunction_52(data, threadData);

  GeneratorPQ_eqFunction_53(data, threadData);

  GeneratorPQ_eqFunction_54(data, threadData);

  GeneratorPQ_eqFunction_55(data, threadData);

  GeneratorPQ_eqFunction_56(data, threadData);

  GeneratorPQ_eqFunction_57(data, threadData);

  GeneratorPQ_eqFunction_58(data, threadData);

  GeneratorPQ_eqFunction_59(data, threadData);

  GeneratorPQ_eqFunction_60(data, threadData);

  GeneratorPQ_eqFunction_61(data, threadData);

  GeneratorPQ_eqFunction_62(data, threadData);

  GeneratorPQ_eqFunction_63(data, threadData);

  GeneratorPQ_eqFunction_64(data, threadData);

  GeneratorPQ_eqFunction_65(data, threadData);

  GeneratorPQ_eqFunction_46(data, threadData);

  GeneratorPQ_eqFunction_47(data, threadData);

  GeneratorPQ_eqFunction_48(data, threadData);

  GeneratorPQ_eqFunction_45(data, threadData);

  GeneratorPQ_eqFunction_44(data, threadData);
  if (ACTIVE_STREAM(LOG_INIT)) messageClose(LOG_INIT);
  
  TRACE_POP
  return 0;
}

void GeneratorPQ_updateBoundParameters_0(DATA *data, threadData_t *threadData);

/*
equation index: 67
type: SIMPLE_ASSIGN
generator.Running0 = not (generator.SwitchOffSignal10 or generator.SwitchOffSignal20 or generator.SwitchOffSignal30)
*/
OMC_DISABLE_OPT
static void GeneratorPQ_eqFunction_67(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,67};
  (data->simulationInfo->booleanParameter[0] /* generator.Running0 PARAM */) = (!(((data->simulationInfo->booleanParameter[1] /* generator.SwitchOffSignal10 PARAM */) || (data->simulationInfo->booleanParameter[2] /* generator.SwitchOffSignal20 PARAM */)) || (data->simulationInfo->booleanParameter[3] /* generator.SwitchOffSignal30 PARAM */)));
  TRACE_POP
}

/*
equation index: 68
type: SIMPLE_ASSIGN
generator.PMinPu = 0.01 * generator.PMin
*/
OMC_DISABLE_OPT
static void GeneratorPQ_eqFunction_68(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,68};
  (data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */) = (0.01) * ((data->simulationInfo->realParameter[5] /* generator.PMin PARAM */));
  TRACE_POP
}

/*
equation index: 69
type: SIMPLE_ASSIGN
generator.PMaxPu = 0.01 * generator.PMax
*/
OMC_DISABLE_OPT
static void GeneratorPQ_eqFunction_69(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,69};
  (data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */) = (0.01) * ((data->simulationInfo->realParameter[3] /* generator.PMax PARAM */));
  TRACE_POP
}

/*
equation index: 70
type: SIMPLE_ASSIGN
generator.AlphaPu = 0.01 * generator.AlphaPuPNom * generator.PNom
*/
OMC_DISABLE_OPT
static void GeneratorPQ_eqFunction_70(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,70};
  (data->simulationInfo->realParameter[0] /* generator.AlphaPu PARAM */) = (0.01) * (((data->simulationInfo->realParameter[1] /* generator.AlphaPuPNom PARAM */)) * ((data->simulationInfo->realParameter[7] /* generator.PNom PARAM */)));
  TRACE_POP
}

/*
equation index: 71
type: ALGORITHM

  assert(generator.NbSwitchOffSignals >= 1 and generator.NbSwitchOffSignals <= 3, "Variable violating min/max constraint: 1 <= generator.NbSwitchOffSignals <= 3, has value: " + String(generator.NbSwitchOffSignals, "d"));
*/
OMC_DISABLE_OPT
static void GeneratorPQ_eqFunction_71(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,71};
  modelica_boolean tmp0;
  modelica_boolean tmp1;
  static const MMC_DEFSTRINGLIT(tmp2,90,"Variable violating min/max constraint: 1 <= generator.NbSwitchOffSignals <= 3, has value: ");
  modelica_string tmp3;
  modelica_metatype tmpMeta4;
  static int tmp5 = 0;
  if(!tmp5)
  {
    tmp0 = GreaterEq((data->simulationInfo->integerParameter[0] /* generator.NbSwitchOffSignals PARAM */),((modelica_integer) 1));
    tmp1 = LessEq((data->simulationInfo->integerParameter[0] /* generator.NbSwitchOffSignals PARAM */),((modelica_integer) 3));
    if(!(tmp0 && tmp1))
    {
      tmp3 = modelica_integer_to_modelica_string_format((data->simulationInfo->integerParameter[0] /* generator.NbSwitchOffSignals PARAM */), (modelica_string) mmc_strings_len1[100]);
      tmpMeta4 = stringAppend(MMC_REFSTRINGLIT(tmp2),tmp3);
      {
        const char* assert_cond = "(generator.NbSwitchOffSignals >= 1 and generator.NbSwitchOffSignals <= 3)";
        if (data->simulationInfo->noThrowAsserts) {
          FILE_INFO info = {"/home/rosiereflo/Projects/dynawo_bis/dynawo/install/gcc11/2292_om_1.24.4/Debug/shared/dynawo/ddb/Dynawo/Electrical/Controls/Basics/SwitchOff/SwitchOffLogic.mo",18,3,18,119,0};
          infoStreamPrintWithEquationIndexes(LOG_ASSERT, info, 0, equationIndexes, "The following assertion has been violated %sat time %f\n(%s) --> \"%s\"", initial() ? "during initialization " : "", data->localData[0]->timeValue, assert_cond, MMC_STRINGDATA(tmpMeta4));
        } else {
          FILE_INFO info = {"/home/rosiereflo/Projects/dynawo_bis/dynawo/install/gcc11/2292_om_1.24.4/Debug/shared/dynawo/ddb/Dynawo/Electrical/Controls/Basics/SwitchOff/SwitchOffLogic.mo",18,3,18,119,0};
          omc_assert_warning_withEquationIndexes(info, equationIndexes, "The following assertion has been violated %sat time %f\n(%s) --> \"%s\"", initial() ? "during initialization " : "", data->localData[0]->timeValue, assert_cond, MMC_STRINGDATA(tmpMeta4));
        }
      }
      tmp5 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 72
type: ALGORITHM

  assert(generator.State0 >= Dynawo.Electrical.Constants.state.Open and generator.State0 <= Dynawo.Electrical.Constants.state.Undefined, "Variable violating min/max constraint: Dynawo.Electrical.Constants.state.Open <= generator.State0 <= Dynawo.Electrical.Constants.state.Undefined, has value: " + String(generator.State0, "d"));
*/
OMC_DISABLE_OPT
static void GeneratorPQ_eqFunction_72(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,72};
  modelica_boolean tmp6;
  modelica_boolean tmp7;
  static const MMC_DEFSTRINGLIT(tmp8,157,"Variable violating min/max constraint: Dynawo.Electrical.Constants.state.Open <= generator.State0 <= Dynawo.Electrical.Constants.state.Undefined, has value: ");
  modelica_string tmp9;
  modelica_metatype tmpMeta10;
  static int tmp11 = 0;
  if(!tmp11)
  {
    tmp6 = GreaterEq((data->simulationInfo->integerParameter[1] /* generator.State0 PARAM */),1);
    tmp7 = LessEq((data->simulationInfo->integerParameter[1] /* generator.State0 PARAM */),6);
    if(!(tmp6 && tmp7))
    {
      tmp9 = modelica_integer_to_modelica_string_format((data->simulationInfo->integerParameter[1] /* generator.State0 PARAM */), (modelica_string) mmc_strings_len1[100]);
      tmpMeta10 = stringAppend(MMC_REFSTRINGLIT(tmp8),tmp9);
      {
        const char* assert_cond = "(generator.State0 >= Dynawo.Electrical.Constants.state.Open and generator.State0 <= Dynawo.Electrical.Constants.state.Undefined)";
        if (data->simulationInfo->noThrowAsserts) {
          FILE_INFO info = {"/home/rosiereflo/Projects/dynawo_bis/dynawo/install/gcc11/2292_om_1.24.4/Debug/shared/dynawo/ddb/Dynawo/Electrical/Controls/Basics/SwitchOff/SwitchOffGenerator.mo",29,3,29,94,0};
          infoStreamPrintWithEquationIndexes(LOG_ASSERT, info, 0, equationIndexes, "The following assertion has been violated %sat time %f\n(%s) --> \"%s\"", initial() ? "during initialization " : "", data->localData[0]->timeValue, assert_cond, MMC_STRINGDATA(tmpMeta10));
        } else {
          FILE_INFO info = {"/home/rosiereflo/Projects/dynawo_bis/dynawo/install/gcc11/2292_om_1.24.4/Debug/shared/dynawo/ddb/Dynawo/Electrical/Controls/Basics/SwitchOff/SwitchOffGenerator.mo",29,3,29,94,0};
          omc_assert_warning_withEquationIndexes(info, equationIndexes, "The following assertion has been violated %sat time %f\n(%s) --> \"%s\"", initial() ? "during initialization " : "", data->localData[0]->timeValue, assert_cond, MMC_STRINGDATA(tmpMeta10));
        }
      }
      tmp11 = 1;
    }
  }
  TRACE_POP
}
OMC_DISABLE_OPT
void GeneratorPQ_updateBoundParameters_0(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  GeneratorPQ_eqFunction_67(data, threadData);
  GeneratorPQ_eqFunction_68(data, threadData);
  GeneratorPQ_eqFunction_69(data, threadData);
  GeneratorPQ_eqFunction_70(data, threadData);
  GeneratorPQ_eqFunction_71(data, threadData);
  GeneratorPQ_eqFunction_72(data, threadData);
  TRACE_POP
}
OMC_DISABLE_OPT
int GeneratorPQ_updateBoundParameters(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  (data->simulationInfo->integerParameter[0]/* generator.NbSwitchOffSignals PARAM */) = ((modelica_integer) 3);
  data->modelData->integerParameterData[0].time_unvarying = 1;
  GeneratorPQ_updateBoundParameters_0(data, threadData);
  TRACE_POP
  return 0;
}

#if defined(__cplusplus)
}
#endif

