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
  static const char *res[] = {"time > 999999.0",
  "generator.PGenRawPu >= generator.PMaxPu and pre(generator.pStatus) <> Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMax",
  "generator.PGenRawPu <= generator.PMinPu and pre(generator.pStatus) <> Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMin",
  "generator.PGenRawPu > generator.PMinPu and pre(generator.pStatus) == Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMin",
  "generator.PGenRawPu < generator.PMaxPu and pre(generator.pStatus) == Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMax",
  "generator.UPu >= 0.0001 + generator.UMaxPu and pre(generator.qStatus) <> Dynawo.Electrical.Machines.GeneratorPQ.QStatus.AbsorptionMax",
  "generator.UPu <= -0.0001 + generator.UMinPu and pre(generator.qStatus) <> Dynawo.Electrical.Machines.GeneratorPQ.QStatus.GenerationMax",
  "generator.UPu < -0.0001 + generator.UMaxPu and pre(generator.qStatus) == Dynawo.Electrical.Machines.GeneratorPQ.QStatus.AbsorptionMax or generator.UPu > 0.0001 + generator.UMinPu and pre(generator.qStatus) == Dynawo.Electrical.Machines.GeneratorPQ.QStatus.GenerationMax"};
  static const int occurEqs0[] = {1,19};
  static const int occurEqs1[] = {1,20};
  static const int occurEqs2[] = {1,21};
  static const int occurEqs3[] = {1,22};
  static const int occurEqs4[] = {1,23};
  static const int occurEqs5[] = {1,26};
  static const int occurEqs6[] = {1,27};
  static const int occurEqs7[] = {1,28};
  static const int *occurEqs[] = {occurEqs0,occurEqs1,occurEqs2,occurEqs3,occurEqs4,occurEqs5,occurEqs6,occurEqs7};
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
  modelica_boolean tmp0;
  modelica_boolean tmp1;
  modelica_boolean tmp3;
  modelica_boolean tmp5;
  modelica_boolean tmp7;
  modelica_boolean tmp9;
  modelica_boolean tmp11;
  modelica_boolean tmp13;
  modelica_boolean tmp15;
  
  data->simulationInfo->callStatistics.functionZeroCrossings++;
  
  tmp0 = GreaterZC(data->localData[0]->timeValue, 999999.0, data->simulationInfo->storedRelations[0]);
  gout[0] = (tmp0) ? 1 : -1;
  tmp1 = GreaterEqZC(data->localData[0]->realVars[7] /* generator.PGenRawPu variable */, data->simulationInfo->realParameter[2] /* generator.PMaxPu PARAM */, data->simulationInfo->storedRelations[1]);
  gout[1] = ((tmp1 && (data->simulationInfo->integerVarsPre[0] /* generator.pStatus DISCRETE */ != 3))) ? 1 : -1;
  tmp3 = LessEqZC(data->localData[0]->realVars[7] /* generator.PGenRawPu variable */, data->simulationInfo->realParameter[3] /* generator.PMinPu PARAM */, data->simulationInfo->storedRelations[2]);
  gout[2] = ((tmp3 && (data->simulationInfo->integerVarsPre[0] /* generator.pStatus DISCRETE */ != 2))) ? 1 : -1;
  tmp5 = GreaterZC(data->localData[0]->realVars[7] /* generator.PGenRawPu variable */, data->simulationInfo->realParameter[3] /* generator.PMinPu PARAM */, data->simulationInfo->storedRelations[3]);
  gout[3] = ((tmp5 && (data->simulationInfo->integerVarsPre[0] /* generator.pStatus DISCRETE */ == 2))) ? 1 : -1;
  tmp7 = LessZC(data->localData[0]->realVars[7] /* generator.PGenRawPu variable */, data->simulationInfo->realParameter[2] /* generator.PMaxPu PARAM */, data->simulationInfo->storedRelations[4]);
  gout[4] = ((tmp7 && (data->simulationInfo->integerVarsPre[0] /* generator.pStatus DISCRETE */ == 3))) ? 1 : -1;
  tmp9 = GreaterEqZC(data->localData[0]->realVars[11] /* generator.UPu variable */, 0.0001 + data->simulationInfo->realParameter[8] /* generator.UMaxPu PARAM */, data->simulationInfo->storedRelations[5]);
  gout[5] = ((tmp9 && (data->simulationInfo->integerVarsPre[1] /* generator.qStatus DISCRETE */ != 2))) ? 1 : -1;
  tmp11 = LessEqZC(data->localData[0]->realVars[11] /* generator.UPu variable */, -0.0001 + data->simulationInfo->realParameter[9] /* generator.UMinPu PARAM */, data->simulationInfo->storedRelations[6]);
  gout[6] = ((tmp11 && (data->simulationInfo->integerVarsPre[1] /* generator.qStatus DISCRETE */ != 3))) ? 1 : -1;
  tmp13 = LessZC(data->localData[0]->realVars[11] /* generator.UPu variable */, -0.0001 + data->simulationInfo->realParameter[8] /* generator.UMaxPu PARAM */, data->simulationInfo->storedRelations[7]);
  tmp15 = GreaterZC(data->localData[0]->realVars[11] /* generator.UPu variable */, 0.0001 + data->simulationInfo->realParameter[9] /* generator.UMinPu PARAM */, data->simulationInfo->storedRelations[8]);
  gout[7] = (((tmp13 && (data->simulationInfo->integerVarsPre[1] /* generator.qStatus DISCRETE */ == 2)) || (tmp15 && (data->simulationInfo->integerVarsPre[1] /* generator.qStatus DISCRETE */ == 3)))) ? 1 : -1;
  
  TRACE_POP
  return 0;
}

const char *GeneratorPQ_relationDescription(int i)
{
  const char *res[] = {"time > 999999.0",
  "generator.PGenRawPu >= generator.PMaxPu",
  "generator.PGenRawPu <= generator.PMinPu",
  "generator.PGenRawPu > generator.PMinPu",
  "generator.PGenRawPu < generator.PMaxPu",
  "generator.UPu >= 0.0001 + generator.UMaxPu",
  "generator.UPu <= -0.0001 + generator.UMinPu",
  "generator.UPu < -0.0001 + generator.UMaxPu",
  "generator.UPu > 0.0001 + generator.UMinPu"};
  return res[i];
}

int GeneratorPQ_function_updateRelations(DATA *data, threadData_t *threadData, int evalforZeroCross)
{
  TRACE_PUSH
  modelica_boolean tmp17;
  modelica_boolean tmp18;
  modelica_boolean tmp19;
  modelica_boolean tmp20;
  modelica_boolean tmp21;
  modelica_boolean tmp22;
  modelica_boolean tmp23;
  modelica_boolean tmp24;
  modelica_boolean tmp25;
  
  if(evalforZeroCross) {
    tmp17 = GreaterZC(data->localData[0]->timeValue, 999999.0, data->simulationInfo->storedRelations[0]);
    data->simulationInfo->relations[0] = tmp17;
    tmp18 = GreaterEqZC(data->localData[0]->realVars[7] /* generator.PGenRawPu variable */, data->simulationInfo->realParameter[2] /* generator.PMaxPu PARAM */, data->simulationInfo->storedRelations[1]);
    data->simulationInfo->relations[1] = tmp18;
    tmp19 = LessEqZC(data->localData[0]->realVars[7] /* generator.PGenRawPu variable */, data->simulationInfo->realParameter[3] /* generator.PMinPu PARAM */, data->simulationInfo->storedRelations[2]);
    data->simulationInfo->relations[2] = tmp19;
    tmp20 = GreaterZC(data->localData[0]->realVars[7] /* generator.PGenRawPu variable */, data->simulationInfo->realParameter[3] /* generator.PMinPu PARAM */, data->simulationInfo->storedRelations[3]);
    data->simulationInfo->relations[3] = tmp20;
    tmp21 = LessZC(data->localData[0]->realVars[7] /* generator.PGenRawPu variable */, data->simulationInfo->realParameter[2] /* generator.PMaxPu PARAM */, data->simulationInfo->storedRelations[4]);
    data->simulationInfo->relations[4] = tmp21;
    tmp22 = GreaterEqZC(data->localData[0]->realVars[11] /* generator.UPu variable */, 0.0001 + data->simulationInfo->realParameter[8] /* generator.UMaxPu PARAM */, data->simulationInfo->storedRelations[5]);
    data->simulationInfo->relations[5] = tmp22;
    tmp23 = LessEqZC(data->localData[0]->realVars[11] /* generator.UPu variable */, -0.0001 + data->simulationInfo->realParameter[9] /* generator.UMinPu PARAM */, data->simulationInfo->storedRelations[6]);
    data->simulationInfo->relations[6] = tmp23;
    tmp24 = LessZC(data->localData[0]->realVars[11] /* generator.UPu variable */, -0.0001 + data->simulationInfo->realParameter[8] /* generator.UMaxPu PARAM */, data->simulationInfo->storedRelations[7]);
    data->simulationInfo->relations[7] = tmp24;
    tmp25 = GreaterZC(data->localData[0]->realVars[11] /* generator.UPu variable */, 0.0001 + data->simulationInfo->realParameter[9] /* generator.UMinPu PARAM */, data->simulationInfo->storedRelations[8]);
    data->simulationInfo->relations[8] = tmp25;
  } else {
    data->simulationInfo->relations[0] = (data->localData[0]->timeValue > 999999.0);
    data->simulationInfo->relations[1] = (data->localData[0]->realVars[7] /* generator.PGenRawPu variable */ >= data->simulationInfo->realParameter[2] /* generator.PMaxPu PARAM */);
    data->simulationInfo->relations[2] = (data->localData[0]->realVars[7] /* generator.PGenRawPu variable */ <= data->simulationInfo->realParameter[3] /* generator.PMinPu PARAM */);
    data->simulationInfo->relations[3] = (data->localData[0]->realVars[7] /* generator.PGenRawPu variable */ > data->simulationInfo->realParameter[3] /* generator.PMinPu PARAM */);
    data->simulationInfo->relations[4] = (data->localData[0]->realVars[7] /* generator.PGenRawPu variable */ < data->simulationInfo->realParameter[2] /* generator.PMaxPu PARAM */);
    data->simulationInfo->relations[5] = (data->localData[0]->realVars[11] /* generator.UPu variable */ >= 0.0001 + data->simulationInfo->realParameter[8] /* generator.UMaxPu PARAM */);
    data->simulationInfo->relations[6] = (data->localData[0]->realVars[11] /* generator.UPu variable */ <= -0.0001 + data->simulationInfo->realParameter[9] /* generator.UMinPu PARAM */);
    data->simulationInfo->relations[7] = (data->localData[0]->realVars[11] /* generator.UPu variable */ < -0.0001 + data->simulationInfo->realParameter[8] /* generator.UMaxPu PARAM */);
    data->simulationInfo->relations[8] = (data->localData[0]->realVars[11] /* generator.UPu variable */ > 0.0001 + data->simulationInfo->realParameter[9] /* generator.UMinPu PARAM */);
  }
  
  TRACE_POP
  return 0;
}

#if defined(__cplusplus)
}
#endif

