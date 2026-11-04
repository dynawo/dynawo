/* Events: Sample, Zero Crossings, Relations, Discrete Changes */
#include "GeneratorPQ_model.h"
#include "GeneratorPQ_16dae.h"
#if defined(__cplusplus)
extern "C" {
#endif

/* Initializes the raw time events of the simulation using the now
   calcualted parameters. */
void GeneratorPQ_function_initSample(DATA *data, threadData_t *threadData)
{
  long i=0;
}

const char *GeneratorPQ_zeroCrossingDescription(int i, int **out_EquationIndexes)
{
  static const char *res[] = {"generator.PGenRawPu >= generator.PMaxPu and pre(generator.pStatus) <> generator.PStatus.LimitPMax",
  "generator.PGenRawPu <= generator.PMinPu and pre(generator.pStatus) <> generator.PStatus.LimitPMin",
  "generator.PGenRawPu > generator.PMinPu and pre(generator.pStatus) == generator.PStatus.LimitPMin",
  "generator.PGenRawPu < generator.PMaxPu and pre(generator.pStatus) == generator.PStatus.LimitPMax",
  "time > 999999.0"};
  static const int occurEqs0[] = {1,20};
  static const int occurEqs1[] = {1,21};
  static const int occurEqs2[] = {1,22};
  static const int occurEqs3[] = {1,23};
  static const int occurEqs4[] = {1,28};
  static const int *occurEqs[] = {occurEqs0,occurEqs1,occurEqs2,occurEqs3,occurEqs4};
  *out_EquationIndexes = (int*) occurEqs[i];
  return res[i];
}

/* forwarded equations */

int GeneratorPQ_function_ZeroCrossingsEquations(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  data->simulationInfo->callStatistics.functionZeroCrossingsEquations++;

  
  TRACE_POP
  return 0;
}

int GeneratorPQ_function_ZeroCrossings(DATA *data, threadData_t *threadData, double *gout)
{
  TRACE_PUSH
  const int *equationIndexes = NULL;

  modelica_boolean tmp12;
  modelica_real tmp13;
  modelica_real tmp14;
  modelica_boolean tmp15;
  modelica_real tmp16;
  modelica_real tmp17;
  modelica_boolean tmp18;
  modelica_real tmp19;
  modelica_real tmp20;
  modelica_boolean tmp21;
  modelica_real tmp22;
  modelica_real tmp23;
  modelica_boolean tmp24;
  modelica_real tmp25;
  modelica_real tmp26;

#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_tick(SIM_TIMER_ZC);
#endif
  data->simulationInfo->callStatistics.functionZeroCrossings++;

  tmp13 = 1.0;
  tmp14 = fabs((data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */));
  tmp12 = GreaterEqZC((data->localData[0]->realVars[10] /* generator.PGenRawPu variable */), (data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */), tmp13, tmp14, data->simulationInfo->storedRelations[0]);
  gout[0] = ((tmp12 && ((data->simulationInfo->integerVarsPre[1] /* generator.pStatus DISCRETE */) != 3))) ? 1 : -1;

  tmp16 = 1.0;
  tmp17 = fabs((data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */));
  tmp15 = LessEqZC((data->localData[0]->realVars[10] /* generator.PGenRawPu variable */), (data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */), tmp16, tmp17, data->simulationInfo->storedRelations[1]);
  gout[1] = ((tmp15 && ((data->simulationInfo->integerVarsPre[1] /* generator.pStatus DISCRETE */) != 2))) ? 1 : -1;

  tmp19 = 1.0;
  tmp20 = fabs((data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */));
  tmp18 = GreaterZC((data->localData[0]->realVars[10] /* generator.PGenRawPu variable */), (data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */), tmp19, tmp20, data->simulationInfo->storedRelations[2]);
  gout[2] = ((tmp18 && ((data->simulationInfo->integerVarsPre[1] /* generator.pStatus DISCRETE */) == 2))) ? 1 : -1;

  tmp22 = 1.0;
  tmp23 = fabs((data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */));
  tmp21 = LessZC((data->localData[0]->realVars[10] /* generator.PGenRawPu variable */), (data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */), tmp22, tmp23, data->simulationInfo->storedRelations[3]);
  gout[3] = ((tmp21 && ((data->simulationInfo->integerVarsPre[1] /* generator.pStatus DISCRETE */) == 3))) ? 1 : -1;

  tmp25 = 1.0;
  tmp26 = 999999.0;
  tmp24 = GreaterZC(data->localData[0]->timeValue, 999999.0, tmp25, tmp26, data->simulationInfo->storedRelations[4]);
  gout[4] = (tmp24) ? 1 : -1;

#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_accumulate(SIM_TIMER_ZC);
#endif

  TRACE_POP
  return 0;
}

const char *GeneratorPQ_relationDescription(int i)
{
  const char *res[] = {"generator.PGenRawPu >= generator.PMaxPu",
  "generator.PGenRawPu <= generator.PMinPu",
  "generator.PGenRawPu > generator.PMinPu",
  "generator.PGenRawPu < generator.PMaxPu",
  "time > 999999.0"};
  return res[i];
}

int GeneratorPQ_function_updateRelations(DATA *data, threadData_t *threadData, int evalforZeroCross)
{
  TRACE_PUSH
  const int *equationIndexes = NULL;

  modelica_boolean tmp27;
  modelica_real tmp28;
  modelica_real tmp29;
  modelica_boolean tmp30;
  modelica_real tmp31;
  modelica_real tmp32;
  modelica_boolean tmp33;
  modelica_real tmp34;
  modelica_real tmp35;
  modelica_boolean tmp36;
  modelica_real tmp37;
  modelica_real tmp38;
  modelica_boolean tmp39;
  modelica_real tmp40;
  modelica_real tmp41;
  
  if(evalforZeroCross) {
    tmp28 = 1.0;
    tmp29 = fabs((data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */));
    tmp27 = GreaterEqZC((data->localData[0]->realVars[10] /* generator.PGenRawPu variable */), (data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */), tmp28, tmp29, data->simulationInfo->storedRelations[0]);
    data->simulationInfo->relations[0] = tmp27;

    tmp31 = 1.0;
    tmp32 = fabs((data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */));
    tmp30 = LessEqZC((data->localData[0]->realVars[10] /* generator.PGenRawPu variable */), (data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */), tmp31, tmp32, data->simulationInfo->storedRelations[1]);
    data->simulationInfo->relations[1] = tmp30;

    tmp34 = 1.0;
    tmp35 = fabs((data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */));
    tmp33 = GreaterZC((data->localData[0]->realVars[10] /* generator.PGenRawPu variable */), (data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */), tmp34, tmp35, data->simulationInfo->storedRelations[2]);
    data->simulationInfo->relations[2] = tmp33;

    tmp37 = 1.0;
    tmp38 = fabs((data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */));
    tmp36 = LessZC((data->localData[0]->realVars[10] /* generator.PGenRawPu variable */), (data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */), tmp37, tmp38, data->simulationInfo->storedRelations[3]);
    data->simulationInfo->relations[3] = tmp36;

    tmp40 = 1.0;
    tmp41 = 999999.0;
    tmp39 = GreaterZC(data->localData[0]->timeValue, 999999.0, tmp40, tmp41, data->simulationInfo->storedRelations[4]);
    data->simulationInfo->relations[4] = tmp39;
  } else {
    data->simulationInfo->relations[0] = ((data->localData[0]->realVars[10] /* generator.PGenRawPu variable */) >= (data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */));

    data->simulationInfo->relations[1] = ((data->localData[0]->realVars[10] /* generator.PGenRawPu variable */) <= (data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */));

    data->simulationInfo->relations[2] = ((data->localData[0]->realVars[10] /* generator.PGenRawPu variable */) > (data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */));

    data->simulationInfo->relations[3] = ((data->localData[0]->realVars[10] /* generator.PGenRawPu variable */) < (data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */));

    data->simulationInfo->relations[4] = (data->localData[0]->timeValue > 999999.0);
  }
  
  TRACE_POP
  return 0;
}

#if defined(__cplusplus)
}
#endif

