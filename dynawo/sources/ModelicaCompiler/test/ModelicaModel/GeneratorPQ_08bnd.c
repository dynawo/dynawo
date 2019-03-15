/* update bound parameters and variable attributes (start, nominal, min, max) */
#include "GeneratorPQ_model.h"
#include "GeneratorPQ_16dae.h"
#if defined(__cplusplus)
extern "C" {
#endif


/*
equation index: 50
type: SIMPLE_ASSIGN
$START._generator._state = generator.State0
*/
OMC_DISABLE_OPT
static void GeneratorPQ_eqFunction_50(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,50};
  data->modelData->integerVarsData[2].attribute /* generator.state DISCRETE */.start = (modelica_integer)data->simulationInfo->integerParameter[1] /* generator.State0 PARAM */;
    data->localData[0]->integerVars[2] /* generator.state DISCRETE */ = data->modelData->integerVarsData[2].attribute /* generator.state DISCRETE */.start;
    infoStreamPrint(LOG_INIT, 0, "updated start value: %s(start=%ld)", data->modelData->integerVarsData[2].info /* generator.state */.name, (modelica_integer) data->localData[0]->integerVars[2] /* generator.state DISCRETE */);
  TRACE_POP
}

/*
equation index: 51
type: SIMPLE_ASSIGN
$START._$PRE._generator._state = generator.State0
*/
OMC_DISABLE_OPT
static void GeneratorPQ_eqFunction_51(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,51};
  data->modelData->integerVarsData[2].attribute /* generator.state DISCRETE */.start = (modelica_integer)data->simulationInfo->integerParameter[1] /* generator.State0 PARAM */;
    data->simulationInfo->integerVarsPre[2] /* generator.state DISCRETE */ = data->modelData->integerVarsData[2].attribute /* generator.state DISCRETE */.start;
    infoStreamPrint(LOG_INIT, 0, "updated start value: %s(start=%ld)", data->modelData->realVarsData[-2].info /* ERROR_cref2simvar_failed $PRE.generator.state */.name, (modelica_integer) data->simulationInfo->integerVarsPre[2] /* generator.state DISCRETE */);
  TRACE_POP
}

/*
equation index: 49
type: SIMPLE_ASSIGN
$START._der(generator._terminal._V._re) = generator.u0Pu.re
*/
OMC_DISABLE_OPT
static void GeneratorPQ_eqFunction_49(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,49};
  data->modelData->realVarsData[5].attribute /* der(generator.terminal.V.re) STATE_DER */.start = data->simulationInfo->realParameter[13] /* generator.u0Pu.re PARAM */;
    data->localData[0]->realVars[5] /* der(generator.terminal.V.re) STATE_DER */ = data->modelData->realVarsData[5].attribute /* der(generator.terminal.V.re) STATE_DER */.start;
    infoStreamPrint(LOG_INIT, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[5].info /* der(generator.terminal.V.re) */.name, (modelica_real) data->localData[0]->realVars[5] /* der(generator.terminal.V.re) STATE_DER */);
  TRACE_POP
}

/*
equation index: 48
type: SIMPLE_ASSIGN
$START._der(generator._terminal._V._im) = generator.u0Pu.im
*/
OMC_DISABLE_OPT
static void GeneratorPQ_eqFunction_48(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,48};
  data->modelData->realVarsData[4].attribute /* der(generator.terminal.V.im) STATE_DER */.start = data->simulationInfo->realParameter[12] /* generator.u0Pu.im PARAM */;
    data->localData[0]->realVars[4] /* der(generator.terminal.V.im) STATE_DER */ = data->modelData->realVarsData[4].attribute /* der(generator.terminal.V.im) STATE_DER */.start;
    infoStreamPrint(LOG_INIT, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[4].info /* der(generator.terminal.V.im) */.name, (modelica_real) data->localData[0]->realVars[4] /* der(generator.terminal.V.im) STATE_DER */);
  TRACE_POP
}

/*
equation index: 38
type: SIMPLE_ASSIGN
$START._generator._PGenRawPu = generator.PGen0Pu
*/
OMC_DISABLE_OPT
static void GeneratorPQ_eqFunction_38(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,38};
  data->modelData->realVarsData[7].attribute /* generator.PGenRawPu variable */.start = data->simulationInfo->realParameter[1] /* generator.PGen0Pu PARAM */;
    data->localData[0]->realVars[7] /* generator.PGenRawPu variable */ = data->modelData->realVarsData[7].attribute /* generator.PGenRawPu variable */.start;
    infoStreamPrint(LOG_INIT, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[7].info /* generator.PGenRawPu */.name, (modelica_real) data->localData[0]->realVars[7] /* generator.PGenRawPu variable */);
  TRACE_POP
}

/*
equation index: 39
type: SIMPLE_ASSIGN
$START._generator._UPu = generator.U0Pu
*/
OMC_DISABLE_OPT
static void GeneratorPQ_eqFunction_39(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,39};
  data->modelData->realVarsData[11].attribute /* generator.UPu variable */.start = data->simulationInfo->realParameter[7] /* generator.U0Pu PARAM */;
    data->localData[0]->realVars[11] /* generator.UPu variable */ = data->modelData->realVarsData[11].attribute /* generator.UPu variable */.start;
    infoStreamPrint(LOG_INIT, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[11].info /* generator.UPu */.name, (modelica_real) data->localData[0]->realVars[11] /* generator.UPu variable */);
  TRACE_POP
}

/*
equation index: 40
type: SIMPLE_ASSIGN
$START._generator._QGenPu = generator.QGen0Pu
*/
OMC_DISABLE_OPT
static void GeneratorPQ_eqFunction_40(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,40};
  data->modelData->realVarsData[8].attribute /* generator.QGenPu variable */.start = data->simulationInfo->realParameter[4] /* generator.QGen0Pu PARAM */;
    data->localData[0]->realVars[8] /* generator.QGenPu variable */ = data->modelData->realVarsData[8].attribute /* generator.QGenPu variable */.start;
    infoStreamPrint(LOG_INIT, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[8].info /* generator.QGenPu */.name, (modelica_real) data->localData[0]->realVars[8] /* generator.QGenPu variable */);
  TRACE_POP
}

/*
equation index: 41
type: SIMPLE_ASSIGN
$START._generator._PGenPu = generator.PGen0Pu
*/
OMC_DISABLE_OPT
static void GeneratorPQ_eqFunction_41(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,41};
  data->modelData->realVarsData[6].attribute /* generator.PGenPu variable */.start = data->simulationInfo->realParameter[1] /* generator.PGen0Pu PARAM */;
    data->localData[0]->realVars[6] /* generator.PGenPu variable */ = data->modelData->realVarsData[6].attribute /* generator.PGenPu variable */.start;
    infoStreamPrint(LOG_INIT, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[6].info /* generator.PGenPu */.name, (modelica_real) data->localData[0]->realVars[6] /* generator.PGenPu variable */);
  TRACE_POP
}

/*
equation index: 42
type: SIMPLE_ASSIGN
$START._generator._SGenPu._im = generator.QGen0Pu
*/
OMC_DISABLE_OPT
static void GeneratorPQ_eqFunction_42(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,42};
  data->modelData->realVarsData[9].attribute /* generator.SGenPu.im variable */.start = data->simulationInfo->realParameter[4] /* generator.QGen0Pu PARAM */;
    data->localData[0]->realVars[9] /* generator.SGenPu.im variable */ = data->modelData->realVarsData[9].attribute /* generator.SGenPu.im variable */.start;
    infoStreamPrint(LOG_INIT, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[9].info /* generator.SGenPu.im */.name, (modelica_real) data->localData[0]->realVars[9] /* generator.SGenPu.im variable */);
  TRACE_POP
}

/*
equation index: 43
type: SIMPLE_ASSIGN
$START._generator._SGenPu._re = generator.PGen0Pu
*/
OMC_DISABLE_OPT
static void GeneratorPQ_eqFunction_43(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,43};
  data->modelData->realVarsData[10].attribute /* generator.SGenPu.re variable */.start = data->simulationInfo->realParameter[1] /* generator.PGen0Pu PARAM */;
    data->localData[0]->realVars[10] /* generator.SGenPu.re variable */ = data->modelData->realVarsData[10].attribute /* generator.SGenPu.re variable */.start;
    infoStreamPrint(LOG_INIT, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[10].info /* generator.SGenPu.re */.name, (modelica_real) data->localData[0]->realVars[10] /* generator.SGenPu.re variable */);
  TRACE_POP
}

/*
equation index: 44
type: SIMPLE_ASSIGN
$START._generator._terminal._i._im = generator.i0Pu.im
*/
OMC_DISABLE_OPT
static void GeneratorPQ_eqFunction_44(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,44};
  data->modelData->realVarsData[12].attribute /* generator.terminal.i.im variable */.start = data->simulationInfo->realParameter[10] /* generator.i0Pu.im PARAM */;
    data->localData[0]->realVars[12] /* generator.terminal.i.im variable */ = data->modelData->realVarsData[12].attribute /* generator.terminal.i.im variable */.start;
    infoStreamPrint(LOG_INIT, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[12].info /* generator.terminal.i.im */.name, (modelica_real) data->localData[0]->realVars[12] /* generator.terminal.i.im variable */);
  TRACE_POP
}

/*
equation index: 45
type: SIMPLE_ASSIGN
$START._generator._terminal._i._re = generator.i0Pu.re
*/
OMC_DISABLE_OPT
static void GeneratorPQ_eqFunction_45(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,45};
  data->modelData->realVarsData[13].attribute /* generator.terminal.i.re variable */.start = data->simulationInfo->realParameter[11] /* generator.i0Pu.re PARAM */;
    data->localData[0]->realVars[13] /* generator.terminal.i.re variable */ = data->modelData->realVarsData[13].attribute /* generator.terminal.i.re variable */.start;
    infoStreamPrint(LOG_INIT, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[13].info /* generator.terminal.i.re */.name, (modelica_real) data->localData[0]->realVars[13] /* generator.terminal.i.re variable */);
  TRACE_POP
}

/*
equation index: 46
type: SIMPLE_ASSIGN
$START._generator._terminal._V._im = generator.u0Pu.im
*/
OMC_DISABLE_OPT
static void GeneratorPQ_eqFunction_46(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,46};
  data->modelData->realVarsData[1].attribute /* generator.terminal.V.im STATE(1) */.start = data->simulationInfo->realParameter[12] /* generator.u0Pu.im PARAM */;
    data->localData[0]->realVars[1] /* generator.terminal.V.im STATE(1) */ = data->modelData->realVarsData[1].attribute /* generator.terminal.V.im STATE(1) */.start;
    infoStreamPrint(LOG_INIT, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[1].info /* generator.terminal.V.im */.name, (modelica_real) data->localData[0]->realVars[1] /* generator.terminal.V.im STATE(1) */);
  TRACE_POP
}

/*
equation index: 47
type: SIMPLE_ASSIGN
$START._generator._terminal._V._re = generator.u0Pu.re
*/
OMC_DISABLE_OPT
static void GeneratorPQ_eqFunction_47(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,47};
  data->modelData->realVarsData[2].attribute /* generator.terminal.V.re STATE(1) */.start = data->simulationInfo->realParameter[13] /* generator.u0Pu.re PARAM */;
    data->localData[0]->realVars[2] /* generator.terminal.V.re STATE(1) */ = data->modelData->realVarsData[2].attribute /* generator.terminal.V.re STATE(1) */.start;
    infoStreamPrint(LOG_INIT, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[2].info /* generator.terminal.V.re */.name, (modelica_real) data->localData[0]->realVars[2] /* generator.terminal.V.re STATE(1) */);
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
  GeneratorPQ_eqFunction_50(data, threadData);

  GeneratorPQ_eqFunction_51(data, threadData);

  GeneratorPQ_eqFunction_49(data, threadData);

  GeneratorPQ_eqFunction_48(data, threadData);

  GeneratorPQ_eqFunction_38(data, threadData);

  GeneratorPQ_eqFunction_39(data, threadData);

  GeneratorPQ_eqFunction_40(data, threadData);

  GeneratorPQ_eqFunction_41(data, threadData);

  GeneratorPQ_eqFunction_42(data, threadData);

  GeneratorPQ_eqFunction_43(data, threadData);

  GeneratorPQ_eqFunction_44(data, threadData);

  GeneratorPQ_eqFunction_45(data, threadData);

  GeneratorPQ_eqFunction_46(data, threadData);

  GeneratorPQ_eqFunction_47(data, threadData);
  if (ACTIVE_STREAM(LOG_INIT)) messageClose(LOG_INIT);
  
  TRACE_POP
  return 0;
}

void GeneratorPQ_updateBoundParameters_0(DATA *data, threadData_t *threadData);

/*
equation index: 61
type: ALGORITHM

  assert(generator.NbSwitchOffSignals >= 1 and generator.NbSwitchOffSignals <= 3, "Variable violating min/max constraint: 1 <= generator.NbSwitchOffSignals <= 3, has value: " + String(generator.NbSwitchOffSignals, "d"));
*/
OMC_DISABLE_OPT
static void GeneratorPQ_eqFunction_61(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,61};
  modelica_boolean tmp0;
  modelica_boolean tmp1;
  static const MMC_DEFSTRINGLIT(tmp2,90,"Variable violating min/max constraint: 1 <= generator.NbSwitchOffSignals <= 3, has value: ");
  modelica_string tmp3;
  static int tmp4 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp4)
  {
    tmp0 = GreaterEq((modelica_integer)data->simulationInfo->integerParameter[0] /* generator.NbSwitchOffSignals PARAM */,((modelica_integer) 1));
    tmp1 = LessEq((modelica_integer)data->simulationInfo->integerParameter[0] /* generator.NbSwitchOffSignals PARAM */,((modelica_integer) 3));
    if(!(tmp0 && tmp1))
    {
      tmp3 = modelica_integer_to_modelica_string_format((modelica_integer)data->simulationInfo->integerParameter[0] /* generator.NbSwitchOffSignals PARAM */, (modelica_string) mmc_strings_len1[100]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp2),tmp3);
      {
        FILE_INFO info = {"/home/rosiereflo/Projects/devBranch/dynawo/dynawo/install/gcc7/60_OM_1_13_2/Release/shared/dynawo/ddb/Dynawo/Electrical/Controls/Basics/SwitchOff.mo",30,5,30,122,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\ngenerator.NbSwitchOffSignals >= 1 and generator.NbSwitchOffSignals <= 3", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp4 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 62
type: ALGORITHM

  assert(generator.State0 >= Dynawo.Electrical.Constants.state.Open and generator.State0 <= Dynawo.Electrical.Constants.state.Undefined, "Variable violating min/max constraint: Dynawo.Electrical.Constants.state.Open <= generator.State0 <= Dynawo.Electrical.Constants.state.Undefined, has value: " + String(generator.State0, "d"));
*/
OMC_DISABLE_OPT
static void GeneratorPQ_eqFunction_62(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,62};
  modelica_boolean tmp5;
  modelica_boolean tmp6;
  static const MMC_DEFSTRINGLIT(tmp7,157,"Variable violating min/max constraint: Dynawo.Electrical.Constants.state.Open <= generator.State0 <= Dynawo.Electrical.Constants.state.Undefined, has value: ");
  modelica_string tmp8;
  static int tmp9 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp9)
  {
    tmp5 = GreaterEq((modelica_integer)data->simulationInfo->integerParameter[1] /* generator.State0 PARAM */,1);
    tmp6 = LessEq((modelica_integer)data->simulationInfo->integerParameter[1] /* generator.State0 PARAM */,6);
    if(!(tmp5 && tmp6))
    {
      tmp8 = modelica_integer_to_modelica_string_format((modelica_integer)data->simulationInfo->integerParameter[1] /* generator.State0 PARAM */, (modelica_string) mmc_strings_len1[100]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp7),tmp8);
      {
        FILE_INFO info = {"/home/rosiereflo/Projects/devBranch/dynawo/dynawo/install/gcc7/60_OM_1_13_2/Release/shared/dynawo/ddb/Dynawo/Electrical/Controls/Basics/SwitchOff.mo",64,5,64,97,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\ngenerator.State0 >= Dynawo.Electrical.Constants.state.Open and generator.State0 <= Dynawo.Electrical.Constants.state.Undefined", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp9 = 1;
    }
  }
  TRACE_POP
}
OMC_DISABLE_OPT
void GeneratorPQ_updateBoundParameters_0(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  GeneratorPQ_eqFunction_61(data, threadData);
  GeneratorPQ_eqFunction_62(data, threadData);
  TRACE_POP
}
OMC_DISABLE_OPT
int GeneratorPQ_updateBoundParameters(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  data->simulationInfo->integerParameter[0] /* generator.NbSwitchOffSignals PARAM */ = ((modelica_integer) 3);
  data->modelData->integerParameterData[0].time_unvarying = 1;
  data->simulationInfo->realParameter[1] /* generator.PGen0Pu PARAM */ = 0.0;
  data->modelData->realParameterData[1].time_unvarying = 1;
  data->simulationInfo->realParameter[4] /* generator.QGen0Pu PARAM */ = 0.0;
  data->modelData->realParameterData[4].time_unvarying = 1;
  data->simulationInfo->realParameter[7] /* generator.U0Pu PARAM */ = 0.0;
  data->modelData->realParameterData[7].time_unvarying = 1;
  data->simulationInfo->realParameter[10] /* generator.i0Pu.im PARAM */ = 0.0;
  data->modelData->realParameterData[10].time_unvarying = 1;
  data->simulationInfo->realParameter[11] /* generator.i0Pu.re PARAM */ = 0.0;
  data->modelData->realParameterData[11].time_unvarying = 1;
  data->simulationInfo->realParameter[12] /* generator.u0Pu.im PARAM */ = 0.0;
  data->modelData->realParameterData[12].time_unvarying = 1;
  data->simulationInfo->realParameter[13] /* generator.u0Pu.re PARAM */ = 0.0;
  data->modelData->realParameterData[13].time_unvarying = 1;
  data->simulationInfo->integerParameter[1] /* generator.State0 PARAM */ = 2;
  data->modelData->integerParameterData[1].time_unvarying = 1;
  GeneratorPQ_updateBoundParameters_0(data, threadData);
  TRACE_POP
  return 0;
}

#if defined(__cplusplus)
}
#endif

