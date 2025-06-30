#include <limits>
#include <cassert>
#include <set>
#include <iostream>
#include <string>
#include <vector>
#include <math.h>

#include "DYNElement.h"
#include "PARParametersSetFactory.h"

#include "GeneratorPQ_Dyn.h"
#include "GeneratorPQ_Dyn_definition.h"
#include "GeneratorPQ_Dyn_literal.h"


namespace DYN {


void ModelGeneratorPQ_Dyn::initData(DYNDATA *d)
{
  setData(d);
  setupDataStruc();
  initializeDataStruc();
}

void ModelGeneratorPQ_Dyn::setupDataStruc()
{

  data->modelData = (MODEL_DATA *)calloc(1,sizeof(MODEL_DATA));
  data->simulationInfo = (SIMULATION_INFO *)calloc(1,sizeof(SIMULATION_INFO));
  data->simulationInfo->daeModeData = (DAEMODE_DATA *)calloc(1,sizeof(DAEMODE_DATA));
  data->nbDummy = 0;
  data->modelData->nStates = 4;
  data->modelData->nVariablesReal = 9;
  data->modelData->nDiscreteReal = 4;
  data->modelData->nVariablesInteger = 3;
  data->modelData->nVariablesBoolean = 9;
  data->modelData->nVariablesString = 0;
  data->modelData->nParametersReal = 14 + 4; // 4 booleans emulated as real parameters
  data->modelData->nParametersInteger = 2;
  data->modelData->nParametersBoolean = 0; // all boolean parameters emulated as real parameters
  data->modelData->nParametersString = 0;
  data->modelData->nInputVars = 0;
  data->modelData->nOutputVars = 0;
  data->modelData->nAliasReal = 3 - 0 /* Remove const aliases */;
  data->modelData->nAliasInteger = 0 - 0 /* Remove const aliases */;
  data->modelData->nAliasBoolean = 0 - 0 /* Remove const aliases */;
  data->modelData->nAliasString = 0;
  data->modelData->nZeroCrossings = 4 + 4 + 0;
  data->modelData->nSamples = 0;
  data->modelData->nRelations = 5 + 0;
  data->modelData->nMathEvents = 0;
  data->modelData->nExtObjs = 0;
  data->modelData->nMixedSystems = 0;
  data->modelData->nLinearSystems = 1;
  data->modelData->nNonLinearSystems = 0;
  data->modelData->nStateSets = 0;
  data->modelData->nJacobians = 7;
  data->modelData->nOptimizeConstraints = 0;
  data->modelData->nOptimizeFinalConstraints = 0;
  data->modelData->nDelayExpressions = 0;
  data->modelData->nBaseClocks = 0;
  data->modelData->nSpatialDistributions = 0;
  data->modelData->nSensitivityVars = 0;
  data->modelData->nSensitivityParamVars = 0;
  data->modelData->nSetcVars = 0;
  data->modelData->ndataReconVars = 0;
  data->modelData->nSetbVars = 0;
  data->modelData->nRelatedBoundaryConditions = 0;
  data->simulationInfo->daeModeData->nResidualVars = 5;
  data->simulationInfo->daeModeData->nAuxiliaryVars = 0;

  data->nbVars =9;
  data->nbF = 6;
  data->nbModes = 2;
  data->nbZ = 4;
  data->nbCalculatedVars = 3;
  data->nbDelays = 0;
  data->constCalcVars.resize(0, 0.);
}

void ModelGeneratorPQ_Dyn::initializeDataStruc()
{

  dataStructInitialized_ = true;
  data->localData = (SIMULATION_DATA**) calloc(1, sizeof(SIMULATION_DATA*));
  data->localData[0] = (SIMULATION_DATA*) calloc(1, sizeof(SIMULATION_DATA));

  // buffer for all variables
  int nb;
  nb = (data->modelData->nVariablesReal > 0) ? data->modelData->nVariablesReal : 0;
  data->simulationInfo->realVarsPre = (modelica_real*)calloc(nb, sizeof(modelica_real));

  nb = (data->modelData->nStates > 0) ? data->modelData->nStates  : 0;
  data->simulationInfo->derivativesVarsPre = (modelica_real*)calloc(nb, sizeof(modelica_real));

  nb = (data->modelData->nDiscreteReal >0) ? data->modelData->nDiscreteReal : 0;
  data->simulationInfo->discreteVarsPre = (modelica_real*)calloc(nb, sizeof(modelica_real));

  nb = (data->modelData->nVariablesBoolean > 0) ? data->modelData->nVariablesBoolean : 0;
  data->localData[0]->booleanVars = (modelica_boolean*) calloc(nb, sizeof(modelica_boolean));
  data->simulationInfo->booleanVarsPre = (modelica_boolean*)calloc(nb, sizeof(modelica_boolean));

  nb = (data->modelData->nVariablesInteger > 0) ? data->modelData->nVariablesInteger : 0;
  data->simulationInfo->integerDoubleVarsPre = (modelica_real*) calloc(nb, sizeof(modelica_real));

  nb = (data->modelData->nExtObjs > 0) ? data->modelData->nExtObjs : 0;
  data->simulationInfo->extObjs = (void**) calloc(nb, sizeof(void*));


  // buffer for all parameters values
  nb = (data->modelData->nParametersReal > 0) ? data->modelData->nParametersReal : 0;
  data->simulationInfo->realParameter = (modelica_real*) calloc(nb, sizeof(modelica_real));

  nb = (data->modelData->nParametersBoolean > 0) ? data->modelData->nParametersBoolean : 0;
  data->simulationInfo->booleanParameter = (modelica_boolean*) calloc(nb, sizeof(modelica_boolean));

  nb = (data->modelData->nParametersInteger > 0) ? data->modelData->nParametersInteger : 0;
  data->simulationInfo->integerParameter = (modelica_integer*) calloc(nb, sizeof(modelica_integer));

  nb = (data->modelData->nParametersString > 0) ? data->modelData->nParametersString : 0;
  data->simulationInfo->stringParameter = (modelica_string*) calloc(nb, sizeof(modelica_string));

  // buffer for DAE mode data structures
  nb = (data->simulationInfo->daeModeData->nResidualVars > 0) ? data->simulationInfo->daeModeData->nResidualVars : 0;
  data->simulationInfo->daeModeData->residualVars = (modelica_real*) calloc(nb, sizeof(modelica_real));

  nb = (data->simulationInfo->daeModeData->nAuxiliaryVars > 0) ? data->simulationInfo->daeModeData->nAuxiliaryVars : 0;
  data->simulationInfo->daeModeData->auxiliaryVars = (modelica_real*) calloc(nb, sizeof(modelica_real));

  for (unsigned i = 0; i < data->simulationInfo->daeModeData->nAuxiliaryVars; ++i)
    data->simulationInfo->daeModeData->auxiliaryVars[i] = 0;
  for (unsigned i = 0; i < data->simulationInfo->daeModeData->nResidualVars; ++i)
    data->simulationInfo->daeModeData->residualVars[i] = 0;

  // buffer for all relation values
  nb = (data->modelData->nRelations > 0) ? data->modelData->nRelations : 0;
  data->simulationInfo->relations = (modelica_boolean*) calloc(nb, sizeof(modelica_boolean));
  data->simulationInfo->relationsPre = (modelica_boolean*) calloc(nb, sizeof(modelica_boolean));

  // buffer for mathematical events
  data->simulationInfo->mathEventsValuePre = (modelica_real*) calloc(data->modelData->nMathEvents, sizeof(modelica_real));

  data->simulationInfo->discreteCall = 0;
 
}

void ModelGeneratorPQ_Dyn::deInitializeDataStruc()
{

  if(! dataStructInitialized_)
    return;

  dataStructInitialized_ = false;
  free(data->localData[0]->booleanVars);
  free(data->localData[0]);
  free(data->localData);
  // buffer for all variable pre values
  free(data->simulationInfo->derivativesVarsPre);
  free(data->simulationInfo->realVarsPre);
  free(data->simulationInfo->booleanVarsPre);
  free(data->simulationInfo->integerDoubleVarsPre);
  free(data->simulationInfo->discreteVarsPre);

  // buffer for all parameters values
  free(data->simulationInfo->realParameter);
  free(data->simulationInfo->booleanParameter);
  free(data->simulationInfo->integerParameter);
  free(data->simulationInfo->stringParameter);
  // buffer for DAE mode data structures
  free(data->simulationInfo->daeModeData->residualVars);
  free(data->simulationInfo->daeModeData->auxiliaryVars);
  free(data->simulationInfo->daeModeData);
  // buffer for all relation values
  free(data->simulationInfo->relations);
  free(data->simulationInfo->relationsPre);
  free(data->simulationInfo->mathEventsValuePre);
  free(data->simulationInfo);
  free(data->modelData);

}

void ModelGeneratorPQ_Dyn::initRpar()
{
  /* Setting shared and external parameters */
  data->simulationInfo->realParameter[1] /* generator.AlphaPuPNom */ = generator_AlphaPuPNom_;
  data->simulationInfo->realParameter[2] /* generator.PGen0Pu */ = generator_PGen0Pu_;
  data->simulationInfo->realParameter[3] /* generator.PMax */ = generator_PMax_;
  data->simulationInfo->realParameter[5] /* generator.PMin */ = generator_PMin_;
  data->simulationInfo->realParameter[7] /* generator.PNom */ = generator_PNom_;
  data->simulationInfo->realParameter[8] /* generator.QGen0Pu */ = generator_QGen0Pu_;
  data->simulationInfo->realParameter[9] /* generator.U0Pu */ = generator_U0Pu_;
  data->simulationInfo->realParameter[10] /* generator.i0Pu.im */ = generator_i0Pu_im_;
  data->simulationInfo->realParameter[11] /* generator.i0Pu.re */ = generator_i0Pu_re_;
  data->simulationInfo->realParameter[12] /* generator.u0Pu.im */ = generator_u0Pu_im_;
  data->simulationInfo->realParameter[13] /* generator.u0Pu.re */ = generator_u0Pu_re_;
  data->simulationInfo->realParameter[15] /* generator.SwitchOffSignal10 */ = fromNativeBool ( (toNativeBool (generator_SwitchOffSignal10_)));
  data->simulationInfo->realParameter[16] /* generator.SwitchOffSignal20 */ = fromNativeBool ( (toNativeBool (generator_SwitchOffSignal20_)));
  data->simulationInfo->realParameter[17] /* generator.SwitchOffSignal30 */ = fromNativeBool ( (toNativeBool (generator_SwitchOffSignal30_)));
  data->simulationInfo->integerParameter[0] /* generator.NbSwitchOffSignals */ = generator_NbSwitchOffSignals_;
  data->simulationInfo->integerParameter[1] /* generator.State0 */ = generator_State0_;

  // Setting internal parameters 
{
  (data->simulationInfo->realParameter[14] /* generator.Running0 PARAM */) = fromNativeBool ( (!((((toNativeBool (data->simulationInfo->realParameter[15] /* generator.SwitchOffSignal10 PARAM */))) || ((toNativeBool (data->simulationInfo->realParameter[16] /* generator.SwitchOffSignal20 PARAM */)))) || ((toNativeBool (data->simulationInfo->realParameter[17] /* generator.SwitchOffSignal30 PARAM */))))));
}
{
  (data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */) = (0.01) * ((data->simulationInfo->realParameter[5] /* generator.PMin PARAM */));
}
{
  (data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */) = (0.01) * ((data->simulationInfo->realParameter[3] /* generator.PMax PARAM */));
}
{
  (data->simulationInfo->realParameter[0] /* generator.AlphaPu PARAM */) = (0.01) * (((data->simulationInfo->realParameter[1] /* generator.AlphaPuPNom PARAM */)) * ((data->simulationInfo->realParameter[7] /* generator.PNom PARAM */)));
}

  return;
}

void ModelGeneratorPQ_Dyn::setFomc(double * f, propertyF_t type)
{
  if (type != DIFFERENTIAL_EQ) {
  {
  // ----- GeneratorPQ_eqFunction_74 -----
  (data->simulationInfo->daeModeData->residualVars[3]) /* $DAEres6 DAE_RESIDUAL_VAR */ = ((data->localData[0]->realVars[3] /* generator.terminal.V.re STATE(1) */)) * ((data->localData[0]->realVars[7] /* generator.terminal.i.im variable */)) + ((-(data->localData[0]->realVars[2] /* generator.terminal.V.im STATE(1) */))) * ((data->localData[0]->realVars[8] /* generator.terminal.i.re variable */)) - (data->localData[0]->realVars[6] /* generator.SGenPu.im variable */);
    f[0] = data->simulationInfo->daeModeData->residualVars[3] /* $DAEres6 DAE_RESIDUAL_VAR */;

  }


  {
  // ----- GeneratorPQ_eqFunction_75 -----
  (data->simulationInfo->daeModeData->residualVars[1]) /* $DAEres4 DAE_RESIDUAL_VAR */ = ((-(data->localData[0]->realVars[3] /* generator.terminal.V.re STATE(1) */))) * ((data->localData[0]->realVars[8] /* generator.terminal.i.re variable */)) - (data->localData[0]->realVars[4] /* generator.PGenPu variable */) - (((data->localData[0]->realVars[2] /* generator.terminal.V.im STATE(1) */)) * ((data->localData[0]->realVars[7] /* generator.terminal.i.im variable */)));
    f[1] = data->simulationInfo->daeModeData->residualVars[1] /* $DAEres4 DAE_RESIDUAL_VAR */;

  }


  {
  // ----- GeneratorPQ_eqFunction_89 -----
  modelica_boolean tmp8;
  modelica_real tmp9;
  tmp8 = (modelica_boolean)((toNativeBool (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */)));
  if(tmp8)
  {
    tmp9 = (data->simulationInfo->realParameter[2] /* generator.PGen0Pu PARAM */) - ((-0.01) * (((data->localData[0]->realVars[0] /* generator.deltaPmRefPu.value STATE(1) */)) * ((data->simulationInfo->realParameter[7] /* generator.PNom PARAM */)))) - (((data->simulationInfo->realParameter[0] /* generator.AlphaPu PARAM */)) * ((data->localData[0]->realVars[1] /* generator.omegaRefPu.value STATE(1) */) - 1.0));
  }
  else
  {
    tmp9 = 0.0;
  }
  f[3] = data->localData[0]->realVars[5] /*  generator.PGenRawPu variable  */ - ( tmp9 );

  }


  {
  // ----- GeneratorPQ_eqFunction_104 -----
  modelica_boolean tmp22;
  modelica_real tmp23;
  tmp22 = (modelica_boolean)((toNativeBool (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */)));
  if(tmp22)
  {
    tmp23 = (data->localData[0]->realVars[6] /* generator.SGenPu.im variable */) - (data->simulationInfo->realParameter[8] /* generator.QGen0Pu PARAM */);
  }
  else
  {
    tmp23 = (data->localData[0]->realVars[7] /* generator.terminal.i.im variable */);
  }
  (data->simulationInfo->daeModeData->residualVars[2]) /* $DAEres5 DAE_RESIDUAL_VAR */ = tmp23;
    f[4] = data->simulationInfo->daeModeData->residualVars[2] /* $DAEres5 DAE_RESIDUAL_VAR */;

  }


  {
  // ----- GeneratorPQ_eqFunction_105 -----
  modelica_boolean tmp24;
  modelica_real tmp25;
  modelica_boolean tmp26;
  modelica_real tmp27;
  modelica_boolean tmp28;
  modelica_real tmp29;
  tmp28 = (modelica_boolean)((toNativeBool (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */)));
  if(tmp28)
  {
    tmp26 = (modelica_boolean)((data->localData[0]->integerDoubleVars[1] /* generator.pStatus DISCRETE */) == 3);
    if(tmp26)
    {
      tmp27 = (data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */);
    }
    else
    {
      tmp24 = (modelica_boolean)((data->localData[0]->integerDoubleVars[1] /* generator.pStatus DISCRETE */) == 2);
      if(tmp24)
      {
        tmp25 = (data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */);
      }
      else
      {
        tmp25 = (data->localData[0]->realVars[5] /* generator.PGenRawPu variable */);
      }
      tmp27 = tmp25;
    }
    tmp29 = (data->localData[0]->realVars[4] /* generator.PGenPu variable */) - (tmp27);
  }
  else
  {
    tmp29 = (data->localData[0]->realVars[8] /* generator.terminal.i.re variable */);
  }
  (data->simulationInfo->daeModeData->residualVars[4]) /* $DAEres7 DAE_RESIDUAL_VAR */ = tmp29;
    f[5] = data->simulationInfo->daeModeData->residualVars[4] /* $DAEres7 DAE_RESIDUAL_VAR */;

  }


  }
  if (type != ALGEBRAIC_EQ) {
  {
  // ----- GeneratorPQ_eqFunction_76 -----
  (data->simulationInfo->daeModeData->residualVars[0]) /* $DAEres3 DAE_RESIDUAL_VAR */ = (data->localData[0]->derivativesVars[0] /* der(generator.deltaPmRefPu.value) STATE_DER */);
    f[2] = data->simulationInfo->daeModeData->residualVars[0] /* $DAEres3 DAE_RESIDUAL_VAR */;

  }


  }
}

modeChangeType_t ModelGeneratorPQ_Dyn::evalMode(const double t) const
{
  modeChangeType_t modeChangeType = NO_MODE;
 

  // ----- Mode for GeneratorPQ_eqFunction_105 --------- 
  // generator.pStatus != pre(generator.pStatus)
  if (doubleNotEquals(data->localData[0]->integerDoubleVars[1], data->simulationInfo->integerDoubleVarsPre[1])) {
      modeChangeType = ALGEBRAIC_MODE;
  }

  // ----- Mode for GeneratorPQ_eqFunction_89 --------- 
  // ----- Mode for GeneratorPQ_eqFunction_104 --------- 
  // ----- Mode for GeneratorPQ_eqFunction_105 --------- 
  // generator.running.value != pre(generator.running.value)
  if (doubleNotEquals(data->localData[0]->discreteVars[0], data->simulationInfo->discreteVarsPre[0])) {
    return ALGEBRAIC_J_UPDATE_MODE;
  }

  return modeChangeType;
}

void ModelGeneratorPQ_Dyn::setZomc()
{
  data->simulationInfo->discreteCall = 1;

  // -------------------- $whenCondition1 ---------------------
  modelica_boolean tmp19;
  modelica_real tmp20;
  modelica_real tmp21;
  tmp20 = 1.0;
  tmp21 = fabs((data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */));
  relationhysteresis(tmp19, (data->localData[0]->realVars[5] /* generator.PGenRawPu variable */), (data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */), tmp20, tmp21, 3, Less);
  (data->localData[0]->booleanVars[0] /* $whenCondition1 DISCRETE */) = (tmp19 && ((data->simulationInfo->integerDoubleVarsPre[1] /* generator.pStatus DISCRETE */) == 3));
 

  // -------------------- $whenCondition2 ---------------------
  modelica_boolean tmp16;
  modelica_real tmp17;
  modelica_real tmp18;
  tmp17 = 1.0;
  tmp18 = fabs((data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */));
  relationhysteresis(tmp16, (data->localData[0]->realVars[5] /* generator.PGenRawPu variable */), (data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */), tmp17, tmp18, 2, Greater);
  (data->localData[0]->booleanVars[1] /* $whenCondition2 DISCRETE */) = (tmp16 && ((data->simulationInfo->integerDoubleVarsPre[1] /* generator.pStatus DISCRETE */) == 2));
 

  // -------------------- $whenCondition3 ---------------------
  modelica_boolean tmp13;
  modelica_real tmp14;
  modelica_real tmp15;
  tmp14 = 1.0;
  tmp15 = fabs((data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */));
  relationhysteresis(tmp13, (data->localData[0]->realVars[5] /* generator.PGenRawPu variable */), (data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */), tmp14, tmp15, 1, LessEq);
  (data->localData[0]->booleanVars[2] /* $whenCondition3 DISCRETE */) = (tmp13 && ((data->simulationInfo->integerDoubleVarsPre[1] /* generator.pStatus DISCRETE */) != 2));
 

  // -------------------- $whenCondition4 ---------------------
  modelica_boolean tmp10;
  modelica_real tmp11;
  modelica_real tmp12;
  tmp11 = 1.0;
  tmp12 = fabs((data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */));
  relationhysteresis(tmp10, (data->localData[0]->realVars[5] /* generator.PGenRawPu variable */), (data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */), tmp11, tmp12, 0, GreaterEq);
  (data->localData[0]->booleanVars[3] /* $whenCondition4 DISCRETE */) = (tmp10 && ((data->simulationInfo->integerDoubleVarsPre[1] /* generator.pStatus DISCRETE */) != 3));
 

  // -------------------- generator.running.value ---------------------
  if(((data->localData[0]->booleanVars[7] /* $whenCondition8 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[7] /* $whenCondition8 DISCRETE */) /* edge */))
  {
    (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */) = fromNativeBool ( 0 /* false */);
  }
  else if(((data->localData[0]->booleanVars[6] /* $whenCondition7 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[6] /* $whenCondition7 DISCRETE */) /* edge */))
  {
    (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */) = fromNativeBool ( 1 /* true */);
  }

  // -------------------- generator.converter.u ---------------------
  (data->localData[0]->integerDoubleVars[0] /* generator.converter.u DISCRETE */) = ((modelica_integer)((data->localData[0]->integerDoubleVars[2] /* generator.state DISCRETE */)));

  // -------------------- generator.pStatus ---------------------
  if(((data->localData[0]->booleanVars[3] /* $whenCondition4 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[3] /* $whenCondition4 DISCRETE */) /* edge */))
  {
    (data->localData[0]->integerDoubleVars[1] /* generator.pStatus DISCRETE */) = 3;
  }
  else if(((data->localData[0]->booleanVars[2] /* $whenCondition3 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[2] /* $whenCondition3 DISCRETE */) /* edge */))
  {
    (data->localData[0]->integerDoubleVars[1] /* generator.pStatus DISCRETE */) = 2;
  }
  else if(((data->localData[0]->booleanVars[1] /* $whenCondition2 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[1] /* $whenCondition2 DISCRETE */) /* edge */))
  {
    (data->localData[0]->integerDoubleVars[1] /* generator.pStatus DISCRETE */) = 1;
  }
  else if(((data->localData[0]->booleanVars[0] /* $whenCondition1 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[0] /* $whenCondition1 DISCRETE */) /* edge */))
  {
    (data->localData[0]->integerDoubleVars[1] /* generator.pStatus DISCRETE */) = 1;
  }

  // -------------------- generator.state ---------------------
  if(((data->localData[0]->booleanVars[5] /* $whenCondition6 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[5] /* $whenCondition6 DISCRETE */) /* edge */))
  {
    (data->localData[0]->integerDoubleVars[2] /* generator.state DISCRETE */) = 1;
  }
  else if(((data->localData[0]->booleanVars[4] /* $whenCondition5 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[4] /* $whenCondition5 DISCRETE */) /* edge */))
  {
    (data->localData[0]->integerDoubleVars[2] /* generator.state DISCRETE */) = 2;
  }


  // -------------- call functions ----------
{
  if(((data->localData[0]->booleanVars[5] /* $whenCondition6 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[5] /* $whenCondition6 DISCRETE */) /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( ((modelica_integer) 28));
  }
  else if(((data->localData[0]->booleanVars[4] /* $whenCondition5 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[4] /* $whenCondition5 DISCRETE */) /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( ((modelica_integer) 27));
  }
}
{
  if(((data->localData[0]->booleanVars[3] /* $whenCondition4 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[3] /* $whenCondition4 DISCRETE */) /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( ((modelica_integer) 0));
  }
  else if(((data->localData[0]->booleanVars[2] /* $whenCondition3 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[2] /* $whenCondition3 DISCRETE */) /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( ((modelica_integer) 1));
  }
  else if(((data->localData[0]->booleanVars[1] /* $whenCondition2 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[1] /* $whenCondition2 DISCRETE */) /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( ((modelica_integer) 21));
  }
  else if(((data->localData[0]->booleanVars[0] /* $whenCondition1 DISCRETE */) && !(data->simulationInfo->booleanVarsPre[0] /* $whenCondition1 DISCRETE */) /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( ((modelica_integer) 20));
  }
}


  data->simulationInfo->discreteCall = 0;
}

void ModelGeneratorPQ_Dyn::collectSilentZ(BitMask* silentZTable)
{
  silentZTable[4].setFlags(NotUsedInDiscreteEquations | NotUsedInContinuousEquations) /*generator.converter.u */;
  silentZTable[6].setFlags(NotUsedInContinuousEquations) /*generator.state */;
  silentZTable[1].setFlags(NotUsedInContinuousEquations) /*generator.switchOffSignal1.value */;
  silentZTable[2].setFlags(NotUsedInContinuousEquations) /*generator.switchOffSignal2.value */;
  silentZTable[3].setFlags(NotUsedInContinuousEquations) /*generator.switchOffSignal3.value */;
}

void ModelGeneratorPQ_Dyn::setGomc(state_g * gout)
{
  data->simulationInfo->discreteCall = 1;
  // ------------- $whenCondition5 ------------
  (data->localData[0]->booleanVars[4] /* $whenCondition5 DISCRETE */) = (((toNativeBool (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */))) && (!((toNativeBool (data->simulationInfo->discreteVarsPre[0] /* generator.running.value DISCRETE */)))));
 
  // ------------- $whenCondition6 ------------
  (data->localData[0]->booleanVars[5] /* $whenCondition6 DISCRETE */) = (!((toNativeBool (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */))));
 
  // ------------- $whenCondition7 ------------
  (data->localData[0]->booleanVars[6] /* $whenCondition7 DISCRETE */) = ((((!((toNativeBool (data->localData[0]->discreteVars[1] /* generator.switchOffSignal1.value DISCRETE */)))) && (!((toNativeBool (data->localData[0]->discreteVars[2] /* generator.switchOffSignal2.value DISCRETE */))))) && (!((toNativeBool (data->localData[0]->discreteVars[3] /* generator.switchOffSignal3.value DISCRETE */))))) && (!((toNativeBool (data->simulationInfo->discreteVarsPre[0] /* generator.running.value DISCRETE */)))));
 
  // ------------- $whenCondition8 ------------
  (data->localData[0]->booleanVars[7] /* $whenCondition8 DISCRETE */) = ((((toNativeBool (data->localData[0]->discreteVars[1] /* generator.switchOffSignal1.value DISCRETE */))) || ((toNativeBool (data->localData[0]->discreteVars[2] /* generator.switchOffSignal2.value DISCRETE */)))) || (((toNativeBool (data->localData[0]->discreteVars[3] /* generator.switchOffSignal3.value DISCRETE */))) && ((toNativeBool (data->simulationInfo->discreteVarsPre[0] /* generator.running.value DISCRETE */)))));
 

  modelica_boolean tmp_zc12;
  modelica_real tmp_zc13;
  modelica_real tmp_zc14;
  modelica_boolean tmp_zc15;
  modelica_real tmp_zc16;
  modelica_real tmp_zc17;
  modelica_boolean tmp_zc18;
  modelica_real tmp_zc19;
  modelica_real tmp_zc20;
  modelica_boolean tmp_zc21;
  modelica_real tmp_zc22;
  modelica_real tmp_zc23;
  modelica_real tmp_zc25;
  modelica_real tmp_zc26;


  tmp_zc13 = 1.0;
  tmp_zc14 = fabs((data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */));
  tmp_zc12 = GreaterEqZC((data->localData[0]->realVars[5] /* generator.PGenRawPu variable */), (data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */), tmp_zc13, tmp_zc14, data->simulationInfo->storedRelations[0]);

  tmp_zc16 = 1.0;
  tmp_zc17 = fabs((data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */));
  tmp_zc15 = LessEqZC((data->localData[0]->realVars[5] /* generator.PGenRawPu variable */), (data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */), tmp_zc16, tmp_zc17, data->simulationInfo->storedRelations[1]);

  tmp_zc19 = 1.0;
  tmp_zc20 = fabs((data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */));
  tmp_zc18 = GreaterZC((data->localData[0]->realVars[5] /* generator.PGenRawPu variable */), (data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */), tmp_zc19, tmp_zc20, data->simulationInfo->storedRelations[2]);

  tmp_zc22 = 1.0;
  tmp_zc23 = fabs((data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */));
  tmp_zc21 = LessZC((data->localData[0]->realVars[5] /* generator.PGenRawPu variable */), (data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */), tmp_zc22, tmp_zc23, data->simulationInfo->storedRelations[3]);

  tmp_zc25 = 1.0;
  tmp_zc26 = 999999.0;



  gout[0] = ((tmp_zc12 && ((data->simulationInfo->integerDoubleVarsPre[1] /* generator.pStatus DISCRETE */) != 3))) ? ROOT_UP : ROOT_DOWN;
  gout[1] = ((tmp_zc15 && ((data->simulationInfo->integerDoubleVarsPre[1] /* generator.pStatus DISCRETE */) != 2))) ? ROOT_UP : ROOT_DOWN;
  gout[2] = ((tmp_zc18 && ((data->simulationInfo->integerDoubleVarsPre[1] /* generator.pStatus DISCRETE */) == 2))) ? ROOT_UP : ROOT_DOWN;
  gout[3] = ((tmp_zc21 && ((data->simulationInfo->integerDoubleVarsPre[1] /* generator.pStatus DISCRETE */) == 3))) ? ROOT_UP : ROOT_DOWN;
  gout[4] = ( data->localData[0]->booleanVars[4] ) ? ROOT_UP : ROOT_DOWN;
  gout[5] = ( data->localData[0]->booleanVars[5] ) ? ROOT_UP : ROOT_DOWN;
  gout[6] = ( data->localData[0]->booleanVars[6] ) ? ROOT_UP : ROOT_DOWN;
  gout[7] = ( data->localData[0]->booleanVars[7] ) ? ROOT_UP : ROOT_DOWN;
  data->simulationInfo->discreteCall = 0;
}

void ModelGeneratorPQ_Dyn::setY0omc()
{
  data->localData[0]->realVars[0] /* generator.deltaPmRefPu.value */ = 0.0;
  data->localData[0]->realVars[1] /* generator.omegaRefPu.value */ = 0.0;
  data->localData[0]->realVars[2] /* generator.terminal.V.im */ = (data->simulationInfo->realParameter[12] /* generator.u0Pu.im PARAM */);
  data->localData[0]->realVars[3] /* generator.terminal.V.re */ = (data->simulationInfo->realParameter[13] /* generator.u0Pu.re PARAM */);
  data->localData[0]->realVars[4] /* generator.PGenPu */ = (data->simulationInfo->realParameter[2] /* generator.PGen0Pu PARAM */);
  data->localData[0]->realVars[6] /* generator.SGenPu.im */ = (data->simulationInfo->realParameter[8] /* generator.QGen0Pu PARAM */);
  data->localData[0]->realVars[7] /* generator.terminal.i.im */ = (data->simulationInfo->realParameter[10] /* generator.i0Pu.im PARAM */);
  data->localData[0]->realVars[8] /* generator.terminal.i.re */ = (data->simulationInfo->realParameter[11] /* generator.i0Pu.re PARAM */);
  data->localData[0]->discreteVars[0] /* generator.running.value */ = fromNativeBool ( ((toNativeBool (data->simulationInfo->realParameter[14] /* generator.Running0 PARAM */))));
  data->localData[0]->discreteVars[1] /* generator.switchOffSignal1.value */ = fromNativeBool ( ((toNativeBool (data->simulationInfo->realParameter[15] /* generator.SwitchOffSignal10 PARAM */))));
  data->localData[0]->discreteVars[2] /* generator.switchOffSignal2.value */ = fromNativeBool ( ((toNativeBool (data->simulationInfo->realParameter[16] /* generator.SwitchOffSignal20 PARAM */))));
  data->localData[0]->discreteVars[3] /* generator.switchOffSignal3.value */ = fromNativeBool ( ((toNativeBool (data->simulationInfo->realParameter[17] /* generator.SwitchOffSignal30 PARAM */))));
  data->localData[0]->integerDoubleVars[1] /* generator.pStatus */ = 1;
  data->localData[0]->integerDoubleVars[2] /* generator.state */ = (data->simulationInfo->integerParameter[1] /* generator.State0 PARAM */);
  {
    (data->localData[0]->integerDoubleVars[0] /* generator.converter.u DISCRETE */) = ((modelica_integer)((data->localData[0]->integerDoubleVars[2] /* generator.state DISCRETE */)));
  }
  data->localData[0]->realVars[5] /* generator.PGenRawPu */ = (data->simulationInfo->realParameter[2] /* generator.PGen0Pu PARAM */);
}

void ModelGeneratorPQ_Dyn::callCustomParametersConstructors()
{
}

void ModelGeneratorPQ_Dyn::evalStaticYType_omc(propertyContinuousVar_t* yType)
{
   yType[ 0 ] = DIFFERENTIAL;   /* generator_deltaPmRefPu_value (rSta)  */
   yType[ 1 ] = EXTERNAL;   /* generator_omegaRefPu_value (rSta) - external variables */
   yType[ 2 ] = EXTERNAL;   /* generator_terminal_V_im (rSta) - external variables */
   yType[ 3 ] = EXTERNAL;   /* generator_terminal_V_re (rSta) - external variables */
   yType[ 4 ] = ALGEBRAIC;   /* generator_PGenPu (rAlg)  */
   yType[ 5 ] = ALGEBRAIC;   /* generator_PGenRawPu (rAlg)  */
   yType[ 6 ] = ALGEBRAIC;   /* generator_SGenPu_im (rAlg)  */
   yType[ 7 ] = ALGEBRAIC;   /* generator_terminal_i_im (rAlg)  */
   yType[ 8 ] = ALGEBRAIC;   /* generator_terminal_i_re (rAlg)  */
}

void ModelGeneratorPQ_Dyn::evalDynamicYType_omc(propertyContinuousVar_t* yType)
{
}

void ModelGeneratorPQ_Dyn::evalStaticFType_omc(propertyF_t* fType)
{
   fType[ 0 ] = ALGEBRAIC_EQ;
   fType[ 1 ] = ALGEBRAIC_EQ;
   fType[ 2 ] = DIFFERENTIAL_EQ;
   fType[ 3 ] = ALGEBRAIC_EQ;
   fType[ 4 ] = ALGEBRAIC_EQ;
   fType[ 5 ] = ALGEBRAIC_EQ;
}

void ModelGeneratorPQ_Dyn::evalDynamicFType_omc(propertyF_t* fType)
{
}

std::shared_ptr<parameters::ParametersSet> ModelGeneratorPQ_Dyn::setSharedParametersDefaultValues()
{

   // Propagating shared parameters default value 

   // This value may be updated later on through *.par/*.iidm data 
  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("SharedModelicaParameters");
  double generator_AlphaPuPNom_internal;
  double generator_PGen0Pu_internal;
  double generator_PMax_internal;
  double generator_PMin_internal;
  double generator_PNom_internal;
  double generator_QGen0Pu_internal;
  double generator_U0Pu_internal;
  double generator_i0Pu_im_internal;
  double generator_i0Pu_re_internal;
  double generator_u0Pu_im_internal;
  double generator_u0Pu_re_internal;
  bool generator_SwitchOffSignal10_internal;
  bool generator_SwitchOffSignal20_internal;
  bool generator_SwitchOffSignal30_internal;
  int generator_NbSwitchOffSignals_internal;
  int generator_State0_internal;

  generator_AlphaPuPNom_internal = 0.0; 
  parametersSet->createParameter("generator_AlphaPuPNom", generator_AlphaPuPNom_internal);
  generator_PGen0Pu_internal = 0.0; 
  parametersSet->createParameter("generator_PGen0Pu", generator_PGen0Pu_internal);
  generator_PMax_internal = 0.0; 
  parametersSet->createParameter("generator_PMax", generator_PMax_internal);
  generator_PMin_internal = 0.0; 
  parametersSet->createParameter("generator_PMin", generator_PMin_internal);
  generator_PNom_internal = 0.0; 
  parametersSet->createParameter("generator_PNom", generator_PNom_internal);
  generator_QGen0Pu_internal = 0.0; 
  parametersSet->createParameter("generator_QGen0Pu", generator_QGen0Pu_internal);
  generator_U0Pu_internal = 0.0; 
  parametersSet->createParameter("generator_U0Pu", generator_U0Pu_internal);
  generator_i0Pu_im_internal = 0.0; 
  parametersSet->createParameter("generator_i0Pu_im", generator_i0Pu_im_internal);
  generator_i0Pu_re_internal = 0.0; 
  parametersSet->createParameter("generator_i0Pu_re", generator_i0Pu_re_internal);
  generator_u0Pu_im_internal = 0.0; 
  parametersSet->createParameter("generator_u0Pu_im", generator_u0Pu_im_internal);
  generator_u0Pu_re_internal = 0.0; 
  parametersSet->createParameter("generator_u0Pu_re", generator_u0Pu_re_internal);
  generator_SwitchOffSignal10_internal = false; 
  parametersSet->createParameter("generator_SwitchOffSignal10", generator_SwitchOffSignal10_internal);
  generator_SwitchOffSignal20_internal = false; 
  parametersSet->createParameter("generator_SwitchOffSignal20", generator_SwitchOffSignal20_internal);
  generator_SwitchOffSignal30_internal = false; 
  parametersSet->createParameter("generator_SwitchOffSignal30", generator_SwitchOffSignal30_internal);
  generator_NbSwitchOffSignals_internal = 3; 
  parametersSet->createParameter("generator_NbSwitchOffSignals", generator_NbSwitchOffSignals_internal);
  generator_State0_internal = 2; 
  parametersSet->createParameter("generator_State0", generator_State0_internal);
  return parametersSet;
}

void ModelGeneratorPQ_Dyn::setParameters( std::shared_ptr<parameters::ParametersSet> params )
{
  generator_AlphaPuPNom_ = params->getParameter("generator_AlphaPuPNom")->getDouble();
  generator_PGen0Pu_ = params->getParameter("generator_PGen0Pu")->getDouble();
  generator_PMax_ = params->getParameter("generator_PMax")->getDouble();
  generator_PMin_ = params->getParameter("generator_PMin")->getDouble();
  generator_PNom_ = params->getParameter("generator_PNom")->getDouble();
  generator_QGen0Pu_ = params->getParameter("generator_QGen0Pu")->getDouble();
  generator_U0Pu_ = params->getParameter("generator_U0Pu")->getDouble();
  generator_i0Pu_im_ = params->getParameter("generator_i0Pu_im")->getDouble();
  generator_i0Pu_re_ = params->getParameter("generator_i0Pu_re")->getDouble();
  generator_u0Pu_im_ = params->getParameter("generator_u0Pu_im")->getDouble();
  generator_u0Pu_re_ = params->getParameter("generator_u0Pu_re")->getDouble();
  generator_SwitchOffSignal10_ = fromNativeBool ( params->getParameter("generator_SwitchOffSignal10")->getBool());
  generator_SwitchOffSignal20_ = fromNativeBool ( params->getParameter("generator_SwitchOffSignal20")->getBool());
  generator_SwitchOffSignal30_ = fromNativeBool ( params->getParameter("generator_SwitchOffSignal30")->getBool());
  generator_NbSwitchOffSignals_ = params->getParameter("generator_NbSwitchOffSignals")->getInt();
  generator_State0_ = params->getParameter("generator_State0")->getInt();
}

void ModelGeneratorPQ_Dyn::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables)
{
  variables.push_back (VariableNativeFactory::createState ("generator_deltaPmRefPu_value", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_omegaRefPu_value", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_terminal_V_im", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_terminal_V_re", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_PGenPu", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_PGenRawPu", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_SGenPu_im", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_terminal_i_im", FLOW, false));
  variables.push_back (VariableNativeFactory::createState ("generator_terminal_i_re", FLOW, false));
  variables.push_back (VariableAliasFactory::create ("generator_QGenPu", "generator_SGenPu_im", CONTINUOUS, false));
  variables.push_back (VariableAliasFactory::create ("generator_SGenPu_re", "generator_PGenPu", CONTINUOUS, false));
  variables.push_back (VariableAliasFactory::create ("generator_converter_y", "generator_genState", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_converter_u", INTEGER, false));
  variables.push_back (VariableNativeFactory::createState ("generator_pStatus", INTEGER, false));
  variables.push_back (VariableNativeFactory::createState ("generator_state", INTEGER, false));
  variables.push_back (VariableNativeFactory::createState ("generator_running_value", BOOLEAN, false));
  variables.push_back (VariableNativeFactory::createState ("generator_switchOffSignal1_value", BOOLEAN, false));
  variables.push_back (VariableNativeFactory::createState ("generator_switchOffSignal2_value", BOOLEAN, false));
  variables.push_back (VariableNativeFactory::createState ("generator_switchOffSignal3_value", BOOLEAN, false));
  variables.push_back (VariableNativeFactory::createCalculated ("generator_PGen", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createCalculated ("generator_UPu", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createCalculated ("generator_genState", CONTINUOUS, false));
}

void ModelGeneratorPQ_Dyn::defineParameters(std::vector<ParameterModeler>& parameters)
{
  using ParameterModelerTuple = std::tuple<std::string, DYN::typeVarC_t, DYN::parameterScope_t>;
  std::array<ParameterModelerTuple, 20> parameterModelerArray = {
    std::make_tuple("generator_AlphaPu", VAR_TYPE_DOUBLE, INTERNAL_PARAMETER),
    std::make_tuple("generator_AlphaPuPNom", VAR_TYPE_DOUBLE, SHARED_PARAMETER),
    std::make_tuple("generator_PGen0Pu", VAR_TYPE_DOUBLE, SHARED_PARAMETER),
    std::make_tuple("generator_PMax", VAR_TYPE_DOUBLE, SHARED_PARAMETER),
    std::make_tuple("generator_PMaxPu", VAR_TYPE_DOUBLE, INTERNAL_PARAMETER),
    std::make_tuple("generator_PMin", VAR_TYPE_DOUBLE, SHARED_PARAMETER),
    std::make_tuple("generator_PMinPu", VAR_TYPE_DOUBLE, INTERNAL_PARAMETER),
    std::make_tuple("generator_PNom", VAR_TYPE_DOUBLE, SHARED_PARAMETER),
    std::make_tuple("generator_QGen0Pu", VAR_TYPE_DOUBLE, SHARED_PARAMETER),
    std::make_tuple("generator_U0Pu", VAR_TYPE_DOUBLE, SHARED_PARAMETER),
    std::make_tuple("generator_i0Pu_im", VAR_TYPE_DOUBLE, SHARED_PARAMETER),
    std::make_tuple("generator_i0Pu_re", VAR_TYPE_DOUBLE, SHARED_PARAMETER),
    std::make_tuple("generator_u0Pu_im", VAR_TYPE_DOUBLE, SHARED_PARAMETER),
    std::make_tuple("generator_u0Pu_re", VAR_TYPE_DOUBLE, SHARED_PARAMETER),
    std::make_tuple("generator_Running0", VAR_TYPE_BOOL, INTERNAL_PARAMETER),
    std::make_tuple("generator_SwitchOffSignal10", VAR_TYPE_BOOL, SHARED_PARAMETER),
    std::make_tuple("generator_SwitchOffSignal20", VAR_TYPE_BOOL, SHARED_PARAMETER),
    std::make_tuple("generator_SwitchOffSignal30", VAR_TYPE_BOOL, SHARED_PARAMETER),
    std::make_tuple("generator_NbSwitchOffSignals", VAR_TYPE_INT, SHARED_PARAMETER),
    std::make_tuple("generator_State0", VAR_TYPE_INT, SHARED_PARAMETER),
  };
  for (size_t parameterModelerIndex = 0; parameterModelerIndex < parameterModelerArray.size(); ++parameterModelerIndex)
  {
    parameters.push_back(ParameterModeler(std::get<0>(parameterModelerArray[parameterModelerIndex]), std::get<1>(parameterModelerArray[parameterModelerIndex]), std::get<2>(parameterModelerArray[parameterModelerIndex])));
  }
}

void ModelGeneratorPQ_Dyn::defineElements(std::vector<Element>& elements, std::map<std::string, int >& mapElement)
{
  using ElementTuple = std::tuple<std::string, std::string, DYN::Element::typeElement>;
  std::array<ElementTuple, 34> elementArray1 = {
    std::make_tuple("generator", "generator", Element::STRUCTURE),
    std::make_tuple("omegaRefPu", "generator_omegaRefPu", Element::STRUCTURE),
    std::make_tuple("value", "generator_omegaRefPu_value", Element::TERMINAL),
    std::make_tuple("deltaPmRefPu", "generator_deltaPmRefPu", Element::STRUCTURE),
    std::make_tuple("value", "generator_deltaPmRefPu_value", Element::TERMINAL),
    std::make_tuple("UPu", "generator_UPu", Element::TERMINAL),
    std::make_tuple("QGenPu", "generator_QGenPu", Element::TERMINAL),
    std::make_tuple("terminal", "generator_terminal", Element::STRUCTURE),
    std::make_tuple("i", "generator_terminal_i", Element::STRUCTURE),
    std::make_tuple("im", "generator_terminal_i_im", Element::TERMINAL),
    std::make_tuple("re", "generator_terminal_i_re", Element::TERMINAL),
    std::make_tuple("V", "generator_terminal_V", Element::STRUCTURE),
    std::make_tuple("im", "generator_terminal_V_im", Element::TERMINAL),
    std::make_tuple("re", "generator_terminal_V_re", Element::TERMINAL),
    std::make_tuple("converter", "generator_converter", Element::STRUCTURE),
    std::make_tuple("y", "generator_converter_y", Element::TERMINAL),
    std::make_tuple("u", "generator_converter_u", Element::TERMINAL),
    std::make_tuple("running", "generator_running", Element::STRUCTURE),
    std::make_tuple("value", "generator_running_value", Element::TERMINAL),
    std::make_tuple("switchOffSignal3", "generator_switchOffSignal3", Element::STRUCTURE),
    std::make_tuple("value", "generator_switchOffSignal3_value", Element::TERMINAL),
    std::make_tuple("switchOffSignal2", "generator_switchOffSignal2", Element::STRUCTURE),
    std::make_tuple("value", "generator_switchOffSignal2_value", Element::TERMINAL),
    std::make_tuple("switchOffSignal1", "generator_switchOffSignal1", Element::STRUCTURE),
    std::make_tuple("value", "generator_switchOffSignal1_value", Element::TERMINAL),
    std::make_tuple("pStatus", "generator_pStatus", Element::TERMINAL),
    std::make_tuple("PGenRawPu", "generator_PGenRawPu", Element::TERMINAL),
    std::make_tuple("SGenPu", "generator_SGenPu", Element::STRUCTURE),
    std::make_tuple("im", "generator_SGenPu_im", Element::TERMINAL),
    std::make_tuple("re", "generator_SGenPu_re", Element::TERMINAL),
    std::make_tuple("PGenPu", "generator_PGenPu", Element::TERMINAL),
    std::make_tuple("PGen", "generator_PGen", Element::TERMINAL),
    std::make_tuple("genState", "generator_genState", Element::TERMINAL),
    std::make_tuple("state", "generator_state", Element::TERMINAL),
  };
  for (size_t elementsIndex1 = 0; elementsIndex1 < elementArray1.size(); ++elementsIndex1)
  {
    elements.push_back(Element(std::get<0>(elementArray1[elementsIndex1]), std::get<1>(elementArray1[elementsIndex1]), std::get<2>(elementArray1[elementsIndex1])));
  }

  elements[0].subElementsNum().push_back(1);
  elements[0].subElementsNum().push_back(3);
  elements[0].subElementsNum().push_back(5);
  elements[0].subElementsNum().push_back(6);
  elements[0].subElementsNum().push_back(7);
  elements[0].subElementsNum().push_back(14);
  elements[0].subElementsNum().push_back(17);
  elements[0].subElementsNum().push_back(19);
  elements[0].subElementsNum().push_back(21);
  elements[0].subElementsNum().push_back(23);
  elements[0].subElementsNum().push_back(25);
  elements[0].subElementsNum().push_back(26);
  elements[0].subElementsNum().push_back(27);
  elements[0].subElementsNum().push_back(30);
  elements[0].subElementsNum().push_back(31);
  elements[0].subElementsNum().push_back(32);
  elements[0].subElementsNum().push_back(33);
  elements[1].subElementsNum().push_back(2);
  elements[3].subElementsNum().push_back(4);
  elements[7].subElementsNum().push_back(8);
  elements[7].subElementsNum().push_back(11);
  elements[8].subElementsNum().push_back(9);
  elements[8].subElementsNum().push_back(10);
  elements[11].subElementsNum().push_back(12);
  elements[11].subElementsNum().push_back(13);
  elements[14].subElementsNum().push_back(15);
  elements[14].subElementsNum().push_back(16);
  elements[17].subElementsNum().push_back(18);
  elements[19].subElementsNum().push_back(20);
  elements[21].subElementsNum().push_back(22);
  elements[23].subElementsNum().push_back(24);
  elements[27].subElementsNum().push_back(28);
  elements[27].subElementsNum().push_back(29);

  std::array<std::pair<std::string, int>, 34> mapElementArray = {
    std::make_pair("generator", 0),
    std::make_pair("generator_omegaRefPu", 1),
    std::make_pair("generator_omegaRefPu_value", 2),
    std::make_pair("generator_deltaPmRefPu", 3),
    std::make_pair("generator_deltaPmRefPu_value", 4),
    std::make_pair("generator_UPu", 5),
    std::make_pair("generator_QGenPu", 6),
    std::make_pair("generator_terminal", 7),
    std::make_pair("generator_terminal_i", 8),
    std::make_pair("generator_terminal_i_im", 9),
    std::make_pair("generator_terminal_i_re", 10),
    std::make_pair("generator_terminal_V", 11),
    std::make_pair("generator_terminal_V_im", 12),
    std::make_pair("generator_terminal_V_re", 13),
    std::make_pair("generator_converter", 14),
    std::make_pair("generator_converter_y", 15),
    std::make_pair("generator_converter_u", 16),
    std::make_pair("generator_running", 17),
    std::make_pair("generator_running_value", 18),
    std::make_pair("generator_switchOffSignal3", 19),
    std::make_pair("generator_switchOffSignal3_value", 20),
    std::make_pair("generator_switchOffSignal2", 21),
    std::make_pair("generator_switchOffSignal2_value", 22),
    std::make_pair("generator_switchOffSignal1", 23),
    std::make_pair("generator_switchOffSignal1_value", 24),
    std::make_pair("generator_pStatus", 25),
    std::make_pair("generator_PGenRawPu", 26),
    std::make_pair("generator_SGenPu", 27),
    std::make_pair("generator_SGenPu_im", 28),
    std::make_pair("generator_SGenPu_re", 29),
    std::make_pair("generator_PGenPu", 30),
    std::make_pair("generator_PGen", 31),
    std::make_pair("generator_genState", 32),
    std::make_pair("generator_state", 33),
  };
  for (size_t mapElementIndex = 0; mapElementIndex < mapElementArray.size(); ++mapElementIndex)
  {
    mapElement[mapElementArray[mapElementIndex].first] = mapElementArray[mapElementIndex].second;
  }
}

#ifdef _ADEPT_
void ModelGeneratorPQ_Dyn::evalFAdept(const std::vector<adept::adouble> & x,
                              const std::vector<adept::adouble> & xd,
                              std::vector<adept::adouble> & res)
{
  /*
    generator_deltaPmRefPu_value : x[0]
    generator_omegaRefPu_value : x[1]
    generator_terminal_V_im : x[2]
    generator_terminal_V_re : x[3]
    generator_PGenPu : x[4]
    generator_PGenRawPu : x[5]
    generator_SGenPu_im : x[6]
    generator_terminal_i_im : x[7]
    generator_terminal_i_re : x[8]
    der(generator_deltaPmRefPu_value) : xd[0]
    der(generator_omegaRefPu_value) : xd[1]
    der(generator_terminal_V_im) : xd[2]
    der(generator_terminal_V_re) : xd[3]

  */
  adept::adouble $DAEres3;
  adept::adouble $DAEres4;
  adept::adouble $DAEres5;
  adept::adouble $DAEres6;
  adept::adouble $DAEres7;
  // ----- GeneratorPQ_eqFunction_74 -----
  {
    res[0] = (x[3]) * (x[7]) + ((-x[2])) * (x[8]) - x[6];

  }


  // ----- GeneratorPQ_eqFunction_75 -----
  {
    res[1] = ((-x[3])) * (x[8]) - x[4] - ((x[2]) * (x[7]));

  }


  // ----- GeneratorPQ_eqFunction_76 -----
  {
    res[2] = xd[0];

  }


  // ----- GeneratorPQ_eqFunction_89 -----
  {
  modelica_boolean tmp8;
  adept::adouble tmp9;
  tmp8 = (modelica_boolean)((toNativeBool (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */)));
  if(tmp8)
  {
    tmp9 = (data->simulationInfo->realParameter[2] /* generator.PGen0Pu PARAM */) - ((-0.01) * ((x[0]) * ((data->simulationInfo->realParameter[7] /* generator.PNom PARAM */)))) - (((data->simulationInfo->realParameter[0] /* generator.AlphaPu PARAM */)) * (x[1] - 1.0));
  }
  else
  {
    tmp9 = 0.0;
  }
  res[3] = x[5] - ( tmp9 );

  }


  // ----- GeneratorPQ_eqFunction_104 -----
  {
  modelica_boolean tmp22;
  adept::adouble tmp23;
  tmp22 = (modelica_boolean)((toNativeBool (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */)));
  if(tmp22)
  {
    tmp23 = x[6] - (data->simulationInfo->realParameter[8] /* generator.QGen0Pu PARAM */);
  }
  else
  {
    tmp23 = x[7];
  }
    res[4] = tmp23;

  }


  // ----- GeneratorPQ_eqFunction_105 -----
  {
  modelica_boolean tmp24;
  adept::adouble tmp25;
  modelica_boolean tmp26;
  adept::adouble tmp27;
  modelica_boolean tmp28;
  adept::adouble tmp29;
  tmp28 = (modelica_boolean)((toNativeBool (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */)));
  if(tmp28)
  {
    tmp26 = (modelica_boolean)((data->localData[0]->integerDoubleVars[1] /* generator.pStatus DISCRETE */) == 3);
    if(tmp26)
    {
      tmp27 = (data->simulationInfo->realParameter[4] /* generator.PMaxPu PARAM */);
    }
    else
    {
      tmp24 = (modelica_boolean)((data->localData[0]->integerDoubleVars[1] /* generator.pStatus DISCRETE */) == 2);
      if(tmp24)
      {
        tmp25 = (data->simulationInfo->realParameter[6] /* generator.PMinPu PARAM */);
      }
      else
      {
        tmp25 = x[5];
      }
      tmp27 = tmp25;
    }
    tmp29 = x[4] - (tmp27);
  }
  else
  {
    tmp29 = x[8];
  }
    res[5] = tmp29;

  }


}
#endif

void ModelGeneratorPQ_Dyn::checkDataCoherence()
{
}

void ModelGeneratorPQ_Dyn::checkParametersCoherence() const
{
{
{
  modelica_boolean tmp0;
  modelica_boolean tmp1;
  const modelica_string   tmp2 = "Variable violating min/max constraint: 1 <= generator.NbSwitchOffSignals <= 3 has value: ";
  modelica_string tmp3;
 modelica_string tmpMeta4;;
  static int tmp5 = 0;
  if(!tmp5)
  {
    tmp0 = GreaterEq((data->simulationInfo->integerParameter[0] /* generator.NbSwitchOffSignals PARAM */),((modelica_integer) 1));
    tmp1 = LessEq((data->simulationInfo->integerParameter[0] /* generator.NbSwitchOffSignals PARAM */),((modelica_integer) 3));
    if(!(tmp0 && tmp1))
    {
      tmp3 = modelica_integer_to_modelica_string_format((data->simulationInfo->integerParameter[0] /* generator.NbSwitchOffSignals PARAM */), mmc_strings_len1(100));
      tmpMeta4 = stringAppend((tmp2),tmp3);
      {
        const char* assert_cond = "(generator.NbSwitchOffSignals >= 1 and generator.NbSwitchOffSignals <= 3)";
        if (data->simulationInfo->noThrowAsserts) {
          throwStreamPrint(, "The following assertion has been violated %sat time %f\n(%s) --> \"%s\"", initial() ? "during initialization " : "", data->localData[0]->timeValue, assert_cond, (tmpMeta4));
        } else {
          omc_assert_warning_withEquationIndexes( equationIndexes, "The following assertion has been violated %sat time %f\n(%s) --> \"%s\"", initial() ? "during initialization " : "", data->localData[0]->timeValue, assert_cond, (tmpMeta4));
        }
      }
      tmp5 = 1;
    }
  }
}


}
{
{
  modelica_boolean tmp6;
  modelica_boolean tmp7;
  const modelica_string   tmp8 = "Variable violating min/max constraint: Dynawo.Electrical.Constants.state.Open <= generator.State0 <= Dynawo.Electrical.Constants.state.Undefined has value: ";
  modelica_string tmp9;
 modelica_string tmpMeta10;;
  static int tmp11 = 0;
  if(!tmp11)
  {
    tmp6 = GreaterEq((data->simulationInfo->integerParameter[1] /* generator.State0 PARAM */),1);
    tmp7 = LessEq((data->simulationInfo->integerParameter[1] /* generator.State0 PARAM */),6);
    if(!(tmp6 && tmp7))
    {
      tmp9 = modelica_integer_to_modelica_string_format((data->simulationInfo->integerParameter[1] /* generator.State0 PARAM */), mmc_strings_len1(100));
      tmpMeta10 = stringAppend((tmp8),tmp9);
      {
        const char* assert_cond = "(generator.State0 >= Dynawo.Electrical.Constants.state.Open and generator.State0 <= Dynawo.Electrical.Constants.state.Undefined)";
        if (data->simulationInfo->noThrowAsserts) {
          throwStreamPrint(, "The following assertion has been violated %sat time %f\n(%s) --> \"%s\"", initial() ? "during initialization " : "", data->localData[0]->timeValue, assert_cond, (tmpMeta10));
        } else {
          omc_assert_warning_withEquationIndexes( equationIndexes, "The following assertion has been violated %sat time %f\n(%s) --> \"%s\"", initial() ? "during initialization " : "", data->localData[0]->timeValue, assert_cond, (tmpMeta10));
        }
      }
      tmp11 = 1;
    }
  }
}


}
}

void ModelGeneratorPQ_Dyn::setFequations(std::map<int,std::string>& fEquationIndex)
{
  //Note: fictive equations are not added. fEquationIndex.size() = sizeF() - Nunmber of fictive equations.
  fEquationIndex[0] = "$DAEres6 = generator.terminal.V.re * generator.terminal.i.im + (-generator.terminal.V.im) * generator.terminal.i.re - generator.SGenPu.im";//equation_index_omc:74
  fEquationIndex[1] = "$DAEres4 = (-generator.terminal.V.re) * generator.terminal.i.re - generator.PGenPu - generator.terminal.V.im * generator.terminal.i.im";//equation_index_omc:75
  fEquationIndex[2] = "$DAEres3 = der(generator.deltaPmRefPu.value)";//equation_index_omc:76
  fEquationIndex[3] = "generator.PGenRawPu = if generator.running.value then generator.PGen0Pu - (-0.01) * generator.deltaPmRefPu.value * generator.PNom - generator.AlphaPu * (generator.omegaRefPu.value - 1.0) else 0.0";//equation_index_omc:89
  fEquationIndex[4] = "$DAEres5 = if generator.running.value then generator.SGenPu.im - generator.QGen0Pu else generator.terminal.i.im";//equation_index_omc:104
  fEquationIndex[5] = "$DAEres7 = if generator.running.value then generator.PGenPu - (if generator.pStatus == generator.PStatus.LimitPMax then generator.PMaxPu else if generator.pStatus == generator.PStatus.LimitPMin then generator.PMinPu else generator.PGenRawPu) else generator.terminal.i.re";//equation_index_omc:105
}

void ModelGeneratorPQ_Dyn::setGequations(std::map<int,std::string>& gEquationIndex)
{
// ---------------- boolean conditions -------------
  static const char *res[] = {"generator.PGenRawPu >= generator.PMaxPu and pre(generator.pStatus) <> generator.PStatus.LimitPMax",
  "generator.PGenRawPu <= generator.PMinPu and pre(generator.pStatus) <> generator.PStatus.LimitPMin",
  "generator.PGenRawPu > generator.PMinPu and pre(generator.pStatus) == generator.PStatus.LimitPMin",
  "generator.PGenRawPu < generator.PMaxPu and pre(generator.pStatus) == generator.PStatus.LimitPMax",
  };
  gEquationIndex[0] =  res[0]  ;
  gEquationIndex[1] =  res[1]  ;
  gEquationIndex[2] =  res[2]  ;
  gEquationIndex[3] =  res[3]  ;
// -----------------------------
  // ------------- $whenCondition5 ------------
  gEquationIndex[4] = " $whenCondition5:  (data->localData[0]->booleanVars[4] /* $whenCondition5 DISCRETE */) = (((toNativeBool (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */))) && (!((toNativeBool (data->simulationInfo->discreteVarsPre[0] /* generator.running.value DISCRETE */))))); " ;
 
  // ------------- $whenCondition6 ------------
  gEquationIndex[5] = " $whenCondition6:  (data->localData[0]->booleanVars[5] /* $whenCondition6 DISCRETE */) = (!((toNativeBool (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */)))); " ;
 
  // ------------- $whenCondition7 ------------
  gEquationIndex[6] = " $whenCondition7:  (data->localData[0]->booleanVars[6] /* $whenCondition7 DISCRETE */) = ((((!((toNativeBool (data->localData[0]->discreteVars[1] /* generator.switchOffSignal1.value DISCRETE */)))) && (!((toNativeBool (data->localData[0]->discreteVars[2] /* generator.switchOffSignal2.value DISCRETE */))))) && (!((toNativeBool (data->localData[0]->discreteVars[3] /* generator.switchOffSignal3.value DISCRETE */))))) && (!((toNativeBool (data->simulationInfo->discreteVarsPre[0] /* generator.running.value DISCRETE */))))); " ;
 
  // ------------- $whenCondition8 ------------
  gEquationIndex[7] = " $whenCondition8:  (data->localData[0]->booleanVars[7] /* $whenCondition8 DISCRETE */) = ((((toNativeBool (data->localData[0]->discreteVars[1] /* generator.switchOffSignal1.value DISCRETE */))) || ((toNativeBool (data->localData[0]->discreteVars[2] /* generator.switchOffSignal2.value DISCRETE */)))) || (((toNativeBool (data->localData[0]->discreteVars[3] /* generator.switchOffSignal3.value DISCRETE */))) && ((toNativeBool (data->simulationInfo->discreteVarsPre[0] /* generator.running.value DISCRETE */))))); " ;
 
}

void ModelGeneratorPQ_Dyn::evalCalculatedVars(std::vector<double>& calculatedVars)
{
  {
      calculatedVars[0] /* generator.PGen*/ = (100.0) * ((data->localData[0]->realVars[4] /* generator.PGenPu variable */));
  }
  {
    modelica_real tmp3;
    modelica_real tmp4;
    modelica_real tmp5;
    modelica_boolean tmp6;
    modelica_real tmp7;
    tmp6 = (modelica_boolean)((toNativeBool (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */)));
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
      calculatedVars[1] /* generator.UPu*/ = tmp7;
  }
  {
      calculatedVars[2] /* generator.genState*/ = ((modelica_real)(data->localData[0]->integerDoubleVars[0] /* generator.converter.u DISCRETE */));
  }
}

double ModelGeneratorPQ_Dyn::evalCalculatedVarI(unsigned iCalculatedVar) const
{
  if (iCalculatedVar == 0)  /* generator.PGen */
  {
      return (100.0) * ((data->localData[0]->realVars[4] /* generator.PGenPu variable */));
  }
  if (iCalculatedVar == 1)  /* generator.UPu */
  {
    modelica_real tmp3;
    modelica_real tmp4;
    modelica_real tmp5;
    modelica_boolean tmp6;
    modelica_real tmp7;
    tmp6 = (modelica_boolean)((toNativeBool (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */)));
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
      return tmp7;
  }
  if (iCalculatedVar == 2)  /* generator.genState */
  {
      return ((modelica_real)(data->localData[0]->integerDoubleVars[0] /* generator.converter.u DISCRETE */));
  }
  throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);
}

#ifdef _ADEPT_
adept::adouble ModelGeneratorPQ_Dyn::evalCalculatedVarIAdept(unsigned iCalculatedVar, unsigned indexOffset, const std::vector<adept::adouble> &x, const std::vector<adept::adouble> &xd) const
{
  if (iCalculatedVar == 0)  /* generator.PGen */
  {
      return (100.0) * (x[indexOffset +0]);
  }


  if (iCalculatedVar == 1)  /* generator.UPu */
  {
    adept::adouble tmp3;
    adept::adouble tmp4;
    adept::adouble tmp5;
    modelica_boolean tmp6;
    adept::adouble tmp7;
    tmp6 = (modelica_boolean)((toNativeBool (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */)));
    if(tmp6)
    {
      tmp3 = x[indexOffset +1];
      tmp4 = x[indexOffset +0];
      tmp7 = sqrt((tmp3 * tmp3) + (tmp4 * tmp4));
    }
    else
    {
      tmp7 = 0.0;
    }
      return tmp7;
  }


  if (iCalculatedVar == 2)  /* generator.genState */
  {
      return ((modelica_real)(data->localData[0]->integerDoubleVars[0] /* generator.converter.u DISCRETE */));
  }


  throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);
}
#endif

void ModelGeneratorPQ_Dyn::getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const
{
  if (iCalculatedVar == 0)  /* generator.PGen */ {
    indexes.push_back(4);
  }
  if (iCalculatedVar == 1)  /* generator.UPu */ {
    indexes.push_back(2);
    indexes.push_back(3);
  }
}

}