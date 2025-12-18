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
  data->modelData->nStates = 3;
  data->modelData->nVariablesReal = 11;
  data->modelData->nDiscreteReal = 4;
  data->modelData->nVariablesInteger = 3;
  data->modelData->nVariablesBoolean = 10;
  data->modelData->nVariablesString = 0;
  data->modelData->nParametersReal = 14 + 0; // 0 boolean emulated as real parameter
  data->modelData->nParametersInteger = 2;
  data->modelData->nParametersBoolean = 0; // all boolean parameters emulated as real parameters
  data->modelData->nParametersString = 0;
  data->modelData->nInputVars = 0;
  data->modelData->nOutputVars = 0;
  data->modelData->nAliasReal = 0 - 0 /* Remove const aliases */;
  data->modelData->nAliasInteger = 0 - 0 /* Remove const aliases */;
  data->modelData->nAliasBoolean = 0 - 0 /* Remove const aliases */;
  data->modelData->nAliasString = 0;
  data->modelData->nZeroCrossings = 7 + 2 + 0;
  data->modelData->nSamples = 0;
  data->modelData->nRelations = 9 + 0;
  data->modelData->nMathEvents = 0;
  data->modelData->nExtObjs = 0;
  data->modelData->nMixedSystems = 0;
  data->modelData->nLinearSystems = 1;
  data->modelData->nNonLinearSystems = 0;
  data->modelData->nStateSets = 0;
  data->modelData->nJacobians = 4;
  data->modelData->nOptimizeConstraints = 0;
  data->modelData->nOptimizeFinalConstraints = 0;
  data->modelData->nDelayExpressions = 0;
  data->modelData->nClocks = 0;
  data->modelData->nSubClocks = 0;
  data->modelData->nSensitivityVars = 0;
  data->modelData->nSensitivityParamVars = 0;
  data->simulationInfo->daeModeData->nResidualVars = 2;
  data->simulationInfo->daeModeData->nAuxiliaryVars = 0;

  data->nbVars =11;
  data->nbF = 8;
  data->nbModes = 3;
  data->nbZ = 4;
  data->nbCalculatedVars = 0;
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
  data->simulationInfo->realParameter[0] /* generator.AlphaPu */ = generator_AlphaPu_;
  data->simulationInfo->realParameter[1] /* generator.PGen0Pu */ = generator_PGen0Pu_;
  data->simulationInfo->realParameter[2] /* generator.PMaxPu */ = generator_PMaxPu_;
  data->simulationInfo->realParameter[3] /* generator.PMinPu */ = generator_PMinPu_;
  data->simulationInfo->realParameter[4] /* generator.QGen0Pu */ = generator_QGen0Pu_;
  data->simulationInfo->realParameter[5] /* generator.QMaxPu */ = generator_QMaxPu_;
  data->simulationInfo->realParameter[6] /* generator.QMinPu */ = generator_QMinPu_;
  data->simulationInfo->realParameter[7] /* generator.U0Pu */ = generator_U0Pu_;
  data->simulationInfo->realParameter[8] /* generator.UMaxPu */ = generator_UMaxPu_;
  data->simulationInfo->realParameter[9] /* generator.UMinPu */ = generator_UMinPu_;
  data->simulationInfo->realParameter[10] /* generator.i0Pu.im */ = generator_i0Pu_im_;
  data->simulationInfo->realParameter[11] /* generator.i0Pu.re */ = generator_i0Pu_re_;
  data->simulationInfo->realParameter[12] /* generator.u0Pu.im */ = generator_u0Pu_im_;
  data->simulationInfo->realParameter[13] /* generator.u0Pu.re */ = generator_u0Pu_re_;
  data->simulationInfo->integerParameter[0] /* generator.NbSwitchOffSignals */ = generator_NbSwitchOffSignals_;
  data->simulationInfo->integerParameter[1] /* generator.State0 */ = generator_State0_;

  // Setting internal parameters 

  return;
}

void ModelGeneratorPQ_Dyn::setFomc(double * f, propertyF_t type)
{
  if (type != DIFFERENTIAL_EQ) {
  {
  // ----- GeneratorPQ_eqFunction_63 -----
  modelica_real tmp0;
  modelica_real tmp1;
  modelica_real tmp2;
  tmp0 = data->localData[0]->realVars[2] /* generator.terminal.V.re STATE(1) */;
  tmp1 = data->localData[0]->realVars[1] /* generator.terminal.V.im STATE(1) */;
  f[0] = data->localData[0]->realVars[8] /*  generator.UPu variable  */ - ( sqrt((tmp0 * tmp0) + (tmp1 * tmp1)) );

  }


  {
  // ----- GeneratorPQ_eqFunction_81 -----
  modelica_boolean tmp12;
  modelica_real tmp13;
  tmp12 = (modelica_boolean)(toNativeBool (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */));
  if(tmp12)
  {
    tmp13 = data->simulationInfo->realParameter[1] /* generator.PGen0Pu PARAM */ + (data->simulationInfo->realParameter[0] /* generator.AlphaPu PARAM */) * (1.0 - data->localData[0]->realVars[0] /* generator.omegaRefPu.value STATE(1) */);
  }
  else
  {
    tmp13 = 0.0;
  }
  f[1] = data->localData[0]->realVars[4] /*  generator.PGenRawPu variable  */ - ( tmp13 );

  }


  {
  // ----- GeneratorPQ_eqFunction_90 -----
  modelica_boolean tmp24;
  modelica_real tmp25;
  modelica_boolean tmp26;
  modelica_real tmp27;
  modelica_boolean tmp28;
  modelica_real tmp29;
  tmp28 = (modelica_boolean)(toNativeBool (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */));
  if(tmp28)
  {
    tmp26 = (modelica_boolean)((modelica_integer)data->localData[0]->integerDoubleVars[0] /* generator.pStatus DISCRETE */ == 3);
    if(tmp26)
    {
      tmp27 = data->simulationInfo->realParameter[2] /* generator.PMaxPu PARAM */;
    }
    else
    {
      tmp24 = (modelica_boolean)((modelica_integer)data->localData[0]->integerDoubleVars[0] /* generator.pStatus DISCRETE */ == 2);
      if(tmp24)
      {
        tmp25 = data->simulationInfo->realParameter[3] /* generator.PMinPu PARAM */;
      }
      else
      {
        tmp25 = data->localData[0]->realVars[4] /* generator.PGenRawPu variable */;
      }
      tmp27 = tmp25;
    }
    tmp29 = tmp27;
  }
  else
  {
    tmp29 = 0.0;
  }
  f[2] = data->localData[0]->realVars[3] /*  generator.PGenPu variable  */ - ( tmp29 );

  }


  {
  // ----- GeneratorPQ_eqFunction_91 -----
  f[3] = data->localData[0]->realVars[7] /*  generator.SGenPu.re variable  */ - ( data->localData[0]->realVars[3] /* generator.PGenPu variable */ );

  }


  {
  // ----- GeneratorPQ_eqFunction_92 -----
  $P$DAEres3 = ((-data->localData[0]->realVars[2] /* generator.terminal.V.re STATE(1) */)) * (data->localData[0]->realVars[10] /* generator.terminal.i.re variable */) - data->localData[0]->realVars[7] /* generator.SGenPu.re variable */ - ((data->localData[0]->realVars[1] /* generator.terminal.V.im STATE(1) */) * (data->localData[0]->realVars[9] /* generator.terminal.i.im variable */));
  f[4] = $P$DAEres3;

  }


  {
  // ----- GeneratorPQ_eqFunction_93 -----
  modelica_boolean tmp32;
  modelica_real tmp33;
  modelica_boolean tmp34;
  modelica_real tmp35;
  modelica_boolean tmp36;
  modelica_real tmp37;
  tmp36 = (modelica_boolean)(toNativeBool (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */));
  if(tmp36)
  {
    tmp34 = (modelica_boolean)(data->simulationInfo->integerDoubleVarsPre[1] /* generator.qStatus DISCRETE */ == 2);
    if(tmp34)
    {
      tmp35 = data->simulationInfo->realParameter[5] /* generator.QMaxPu PARAM */;
    }
    else
    {
      tmp32 = (modelica_boolean)(data->simulationInfo->integerDoubleVarsPre[1] /* generator.qStatus DISCRETE */ == 3);
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
  f[5] = data->localData[0]->realVars[5] /*  generator.QGenPu variable  */ - ( tmp37 );

  }


  {
  // ----- GeneratorPQ_eqFunction_94 -----
  f[6] = data->localData[0]->realVars[6] /*  generator.SGenPu.im variable  */ - ( data->localData[0]->realVars[5] /* generator.QGenPu variable */ );

  }


  {
  // ----- GeneratorPQ_eqFunction_95 -----
  $P$DAEres4 = (data->localData[0]->realVars[2] /* generator.terminal.V.re STATE(1) */) * (data->localData[0]->realVars[9] /* generator.terminal.i.im variable */) + ((-data->localData[0]->realVars[1] /* generator.terminal.V.im STATE(1) */)) * (data->localData[0]->realVars[10] /* generator.terminal.i.re variable */) - data->localData[0]->realVars[6] /* generator.SGenPu.im variable */;
  f[7] = $P$DAEres4;

  }


  }
}

modeChangeType_t ModelGeneratorPQ_Dyn::evalMode(const double t) const
{
  modeChangeType_t modeChangeType = NO_MODE;
 

  // ----- Mode for GeneratorPQ_eqFunction_90 --------- 
  // generator.pStatus != pre(generator.pStatus)
  if (doubleNotEquals(data->localData[0]->integerDoubleVars[0], data->simulationInfo->integerDoubleVarsPre[0])) {
      modeChangeType = ALGEBRAIC_MODE;
  }

  // ----- Mode for GeneratorPQ_eqFunction_93 --------- 
  // generator.qStatus != pre(generator.qStatus)
  if (doubleNotEquals(data->localData[0]->integerDoubleVars[1], data->simulationInfo->integerDoubleVarsPre[1])) {
      modeChangeType = ALGEBRAIC_MODE;
  }

  // ----- Mode for GeneratorPQ_eqFunction_81 --------- 
  // ----- Mode for GeneratorPQ_eqFunction_90 --------- 
  // ----- Mode for GeneratorPQ_eqFunction_93 --------- 
  // generator.running.value != pre(generator.running.value)
  if (doubleNotEquals(data->localData[0]->discreteVars[0], data->simulationInfo->discreteVarsPre[0])) {
    return ALGEBRAIC_J_J_UPDATE_MODE;
  }

  return modeChangeType;
}

void ModelGeneratorPQ_Dyn::setZomc()
{
  data->simulationInfo->discreteCall = 1;

  // -------------------- $whenCondition10 ---------------------
  modelica_boolean tmp3;
  RELATIONHYSTERESIS(tmp3, data->localData[0]->realVars[8] /* generator.UPu variable */, 0.0001 + data->simulationInfo->realParameter[8] /* generator.UMaxPu PARAM */, 5, GreaterEq);
  data->localData[0]->booleanVars[1] /* $whenCondition10 DISCRETE */ = (tmp3 && (data->simulationInfo->integerDoubleVarsPre[1] /* generator.qStatus DISCRETE */ != 2));
 

  // -------------------- $whenCondition2 ---------------------
  modelica_boolean tmp20;
  RELATIONHYSTERESIS(tmp20, data->localData[0]->realVars[4] /* generator.PGenRawPu variable */, data->simulationInfo->realParameter[2] /* generator.PMaxPu PARAM */, 4, Less);
  data->localData[0]->booleanVars[2] /* $whenCondition2 DISCRETE */ = (tmp20 && (data->simulationInfo->integerDoubleVarsPre[0] /* generator.pStatus DISCRETE */ == 3));
 

  // -------------------- $whenCondition3 ---------------------
  modelica_boolean tmp18;
  RELATIONHYSTERESIS(tmp18, data->localData[0]->realVars[4] /* generator.PGenRawPu variable */, data->simulationInfo->realParameter[3] /* generator.PMinPu PARAM */, 3, Greater);
  data->localData[0]->booleanVars[3] /* $whenCondition3 DISCRETE */ = (tmp18 && (data->simulationInfo->integerDoubleVarsPre[0] /* generator.pStatus DISCRETE */ == 2));
 

  // -------------------- $whenCondition4 ---------------------
  modelica_boolean tmp16;
  RELATIONHYSTERESIS(tmp16, data->localData[0]->realVars[4] /* generator.PGenRawPu variable */, data->simulationInfo->realParameter[3] /* generator.PMinPu PARAM */, 2, LessEq);
  data->localData[0]->booleanVars[4] /* $whenCondition4 DISCRETE */ = (tmp16 && (data->simulationInfo->integerDoubleVarsPre[0] /* generator.pStatus DISCRETE */ != 2));
 

  // -------------------- $whenCondition5 ---------------------
  modelica_boolean tmp14;
  RELATIONHYSTERESIS(tmp14, data->localData[0]->realVars[4] /* generator.PGenRawPu variable */, data->simulationInfo->realParameter[2] /* generator.PMaxPu PARAM */, 1, GreaterEq);
  data->localData[0]->booleanVars[5] /* $whenCondition5 DISCRETE */ = (tmp14 && (data->simulationInfo->integerDoubleVarsPre[0] /* generator.pStatus DISCRETE */ != 3));
 

  // -------------------- $whenCondition8 ---------------------
  modelica_boolean tmp7;
  modelica_boolean tmp9;
  RELATIONHYSTERESIS(tmp7, data->localData[0]->realVars[8] /* generator.UPu variable */, -0.0001 + data->simulationInfo->realParameter[8] /* generator.UMaxPu PARAM */, 7, Less);
  RELATIONHYSTERESIS(tmp9, data->localData[0]->realVars[8] /* generator.UPu variable */, 0.0001 + data->simulationInfo->realParameter[9] /* generator.UMinPu PARAM */, 8, Greater);
  data->localData[0]->booleanVars[8] /* $whenCondition8 DISCRETE */ = ((tmp7 && (data->simulationInfo->integerDoubleVarsPre[1] /* generator.qStatus DISCRETE */ == 2)) || (tmp9 && (data->simulationInfo->integerDoubleVarsPre[1] /* generator.qStatus DISCRETE */ == 3)));
 

  // -------------------- $whenCondition9 ---------------------
  modelica_boolean tmp5;
  RELATIONHYSTERESIS(tmp5, data->localData[0]->realVars[8] /* generator.UPu variable */, -0.0001 + data->simulationInfo->realParameter[9] /* generator.UMinPu PARAM */, 6, LessEq);
  data->localData[0]->booleanVars[9] /* $whenCondition9 DISCRETE */ = (tmp5 && (data->simulationInfo->integerDoubleVarsPre[1] /* generator.qStatus DISCRETE */ != 3));
 

  // -------------------- generator.running.value ---------------------
  if((data->localData[0]->booleanVars[6] /* $whenCondition6 DISCRETE */ && !data->simulationInfo->booleanVarsPre[6] /* $whenCondition6 DISCRETE */ /* edge */))
  {
    data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */ = fromNativeBool ( 0);
  }

  // -------------------- generator.pStatus ---------------------
  if((data->localData[0]->booleanVars[5] /* $whenCondition5 DISCRETE */ && !data->simulationInfo->booleanVarsPre[5] /* $whenCondition5 DISCRETE */ /* edge */))
  {
    data->localData[0]->integerDoubleVars[0] /* generator.pStatus DISCRETE */ = 3;
  }
  else if((data->localData[0]->booleanVars[4] /* $whenCondition4 DISCRETE */ && !data->simulationInfo->booleanVarsPre[4] /* $whenCondition4 DISCRETE */ /* edge */))
  {
    data->localData[0]->integerDoubleVars[0] /* generator.pStatus DISCRETE */ = 2;
  }
  else if((data->localData[0]->booleanVars[3] /* $whenCondition3 DISCRETE */ && !data->simulationInfo->booleanVarsPre[3] /* $whenCondition3 DISCRETE */ /* edge */))
  {
    data->localData[0]->integerDoubleVars[0] /* generator.pStatus DISCRETE */ = 1;
  }
  else if((data->localData[0]->booleanVars[2] /* $whenCondition2 DISCRETE */ && !data->simulationInfo->booleanVarsPre[2] /* $whenCondition2 DISCRETE */ /* edge */))
  {
    data->localData[0]->integerDoubleVars[0] /* generator.pStatus DISCRETE */ = 1;
  }

  // -------------------- generator.qStatus ---------------------
  if((data->localData[0]->booleanVars[1] /* $whenCondition10 DISCRETE */ && !data->simulationInfo->booleanVarsPre[1] /* $whenCondition10 DISCRETE */ /* edge */))
  {
    data->localData[0]->integerDoubleVars[1] /* generator.qStatus DISCRETE */ = 2;
  }
  else if((data->localData[0]->booleanVars[9] /* $whenCondition9 DISCRETE */ && !data->simulationInfo->booleanVarsPre[9] /* $whenCondition9 DISCRETE */ /* edge */))
  {
    data->localData[0]->integerDoubleVars[1] /* generator.qStatus DISCRETE */ = 3;
  }
  else if((data->localData[0]->booleanVars[8] /* $whenCondition8 DISCRETE */ && !data->simulationInfo->booleanVarsPre[8] /* $whenCondition8 DISCRETE */ /* edge */))
  {
    data->localData[0]->integerDoubleVars[1] /* generator.qStatus DISCRETE */ = 1;
  }

  // -------------------- generator.state ---------------------
  if((data->localData[0]->booleanVars[7] /* $whenCondition7 DISCRETE */ && !data->simulationInfo->booleanVarsPre[7] /* $whenCondition7 DISCRETE */ /* edge */))
  {
    data->localData[0]->integerDoubleVars[2] /* generator.state DISCRETE */ = 1;
  }


  // -------------- call functions ----------
{
  if((data->localData[0]->booleanVars[1] /* $whenCondition10 DISCRETE */ && !data->simulationInfo->booleanVarsPre[1] /* $whenCondition10 DISCRETE */ /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( ((modelica_integer) 58));
  }
  else if((data->localData[0]->booleanVars[9] /* $whenCondition9 DISCRETE */ && !data->simulationInfo->booleanVarsPre[9] /* $whenCondition9 DISCRETE */ /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( ((modelica_integer) 29));
  }
  else if((data->localData[0]->booleanVars[8] /* $whenCondition8 DISCRETE */ && !data->simulationInfo->booleanVarsPre[8] /* $whenCondition8 DISCRETE */ /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( ((modelica_integer) 48));
  }
}
{
  if((data->localData[0]->booleanVars[7] /* $whenCondition7 DISCRETE */ && !data->simulationInfo->booleanVarsPre[7] /* $whenCondition7 DISCRETE */ /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( ((modelica_integer) 54));
  }
}
{
  if((data->localData[0]->booleanVars[5] /* $whenCondition5 DISCRETE */ && !data->simulationInfo->booleanVarsPre[5] /* $whenCondition5 DISCRETE */ /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( ((modelica_integer) 23));
  }
  else if((data->localData[0]->booleanVars[4] /* $whenCondition4 DISCRETE */ && !data->simulationInfo->booleanVarsPre[4] /* $whenCondition4 DISCRETE */ /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( ((modelica_integer) 15));
  }
  else if((data->localData[0]->booleanVars[3] /* $whenCondition3 DISCRETE */ && !data->simulationInfo->booleanVarsPre[3] /* $whenCondition3 DISCRETE */ /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( ((modelica_integer) 68));
  }
  else if((data->localData[0]->booleanVars[2] /* $whenCondition2 DISCRETE */ && !data->simulationInfo->booleanVarsPre[2] /* $whenCondition2 DISCRETE */ /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( ((modelica_integer) 10));
  }
}


  data->simulationInfo->discreteCall = 0;
}

void ModelGeneratorPQ_Dyn::collectSilentZ(BitMask* silentZTable)
{
  silentZTable[6].setFlags(NotUsedInDiscreteEquations | NotUsedInContinuousEquations) /*generator.state */;
  silentZTable[1].setFlags(NotUsedInContinuousEquations) /*generator.switchOffSignal1.value */;
  silentZTable[2].setFlags(NotUsedInContinuousEquations) /*generator.switchOffSignal2.value */;
  silentZTable[3].setFlags(NotUsedInContinuousEquations) /*generator.switchOffSignal3.value */;
}

void ModelGeneratorPQ_Dyn::setGomc(state_g * gout)
{
  data->simulationInfo->discreteCall = 1;
  // ------------- $whenCondition6 ------------
  data->localData[0]->booleanVars[6] /* $whenCondition6 DISCRETE */ = (((toNativeBool (data->localData[0]->discreteVars[1] /* generator.switchOffSignal1.value DISCRETE */)) || (toNativeBool (data->localData[0]->discreteVars[2] /* generator.switchOffSignal2.value DISCRETE */))) || ((toNativeBool (data->localData[0]->discreteVars[3] /* generator.switchOffSignal3.value DISCRETE */)) && (toNativeBool (data->simulationInfo->discreteVarsPre[0] /* generator.running.value DISCRETE */))));
 
  // ------------- $whenCondition7 ------------
  data->localData[0]->booleanVars[7] /* $whenCondition7 DISCRETE */ = (!(toNativeBool (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */)));
 
  modelica_boolean tmp_zc1;
  modelica_boolean tmp_zc3;
  modelica_boolean tmp_zc5;
  modelica_boolean tmp_zc7;
  modelica_boolean tmp_zc9;
  modelica_boolean tmp_zc11;
  modelica_boolean tmp_zc13;
  modelica_boolean tmp_zc15;
  
  
  tmp_zc1 = GreaterEqZC(data->localData[0]->realVars[4] /* generator.PGenRawPu variable */, data->simulationInfo->realParameter[2] /* generator.PMaxPu PARAM */, data->simulationInfo->storedRelations[1]);
  tmp_zc3 = LessEqZC(data->localData[0]->realVars[4] /* generator.PGenRawPu variable */, data->simulationInfo->realParameter[3] /* generator.PMinPu PARAM */, data->simulationInfo->storedRelations[2]);
  tmp_zc5 = GreaterZC(data->localData[0]->realVars[4] /* generator.PGenRawPu variable */, data->simulationInfo->realParameter[3] /* generator.PMinPu PARAM */, data->simulationInfo->storedRelations[3]);
  tmp_zc7 = LessZC(data->localData[0]->realVars[4] /* generator.PGenRawPu variable */, data->simulationInfo->realParameter[2] /* generator.PMaxPu PARAM */, data->simulationInfo->storedRelations[4]);
  tmp_zc9 = GreaterEqZC(data->localData[0]->realVars[8] /* generator.UPu variable */, 0.0001 + data->simulationInfo->realParameter[8] /* generator.UMaxPu PARAM */, data->simulationInfo->storedRelations[5]);
  tmp_zc11 = LessEqZC(data->localData[0]->realVars[8] /* generator.UPu variable */, -0.0001 + data->simulationInfo->realParameter[9] /* generator.UMinPu PARAM */, data->simulationInfo->storedRelations[6]);
  tmp_zc13 = LessZC(data->localData[0]->realVars[8] /* generator.UPu variable */, -0.0001 + data->simulationInfo->realParameter[8] /* generator.UMaxPu PARAM */, data->simulationInfo->storedRelations[7]);
  tmp_zc15 = GreaterZC(data->localData[0]->realVars[8] /* generator.UPu variable */, 0.0001 + data->simulationInfo->realParameter[9] /* generator.UMinPu PARAM */, data->simulationInfo->storedRelations[8]);
  

  gout[0] = ((tmp_zc1 && (data->simulationInfo->integerDoubleVarsPre[0] /* generator.pStatus DISCRETE */ != 3))) ? ROOT_UP : ROOT_DOWN;
  gout[1] = ((tmp_zc3 && (data->simulationInfo->integerDoubleVarsPre[0] /* generator.pStatus DISCRETE */ != 2))) ? ROOT_UP : ROOT_DOWN;
  gout[2] = ((tmp_zc5 && (data->simulationInfo->integerDoubleVarsPre[0] /* generator.pStatus DISCRETE */ == 2))) ? ROOT_UP : ROOT_DOWN;
  gout[3] = ((tmp_zc7 && (data->simulationInfo->integerDoubleVarsPre[0] /* generator.pStatus DISCRETE */ == 3))) ? ROOT_UP : ROOT_DOWN;
  gout[4] = ((tmp_zc9 && (data->simulationInfo->integerDoubleVarsPre[1] /* generator.qStatus DISCRETE */ != 2))) ? ROOT_UP : ROOT_DOWN;
  gout[5] = ((tmp_zc11 && (data->simulationInfo->integerDoubleVarsPre[1] /* generator.qStatus DISCRETE */ != 3))) ? ROOT_UP : ROOT_DOWN;
  gout[6] = (((tmp_zc13 && (data->simulationInfo->integerDoubleVarsPre[1] /* generator.qStatus DISCRETE */ == 2)) || (tmp_zc15 && (data->simulationInfo->integerDoubleVarsPre[1] /* generator.qStatus DISCRETE */ == 3)))) ? ROOT_UP : ROOT_DOWN;
  gout[7] = ( data->localData[0]->booleanVars[6] ) ? ROOT_UP : ROOT_DOWN;
  gout[8] = ( data->localData[0]->booleanVars[7] ) ? ROOT_UP : ROOT_DOWN;
  data->simulationInfo->discreteCall = 0;
}

void ModelGeneratorPQ_Dyn::setY0omc()
{
  data->localData[0]->realVars[0] /* generator.omegaRefPu.value */ = 0.0;
  data->localData[0]->realVars[1] /* generator.terminal.V.im */ = data->simulationInfo->realParameter[12] /* generator.u0Pu.im PARAM */;
  data->localData[0]->realVars[2] /* generator.terminal.V.re */ = data->simulationInfo->realParameter[13] /* generator.u0Pu.re PARAM */;
  data->localData[0]->realVars[9] /* generator.terminal.i.im */ = data->simulationInfo->realParameter[10] /* generator.i0Pu.im PARAM */;
  data->localData[0]->realVars[10] /* generator.terminal.i.re */ = data->simulationInfo->realParameter[11] /* generator.i0Pu.re PARAM */;
  data->localData[0]->realVars[8] /* generator.UPu */ = data->simulationInfo->realParameter[7] /* generator.U0Pu PARAM */;
  data->localData[0]->discreteVars[1] /* generator.switchOffSignal1.value */ = fromNativeBool ( false);
  data->localData[0]->discreteVars[2] /* generator.switchOffSignal2.value */ = fromNativeBool ( false);
  data->localData[0]->discreteVars[3] /* generator.switchOffSignal3.value */ = fromNativeBool ( false);
  data->localData[0]->integerDoubleVars[0] /* generator.pStatus */ = 1;
  data->localData[0]->discreteVars[0] /* generator.running.value */ = fromNativeBool ( true);
  data->localData[0]->realVars[4] /* generator.PGenRawPu */ = data->simulationInfo->realParameter[1] /* generator.PGen0Pu PARAM */;
  data->localData[0]->realVars[3] /* generator.PGenPu */ = data->simulationInfo->realParameter[1] /* generator.PGen0Pu PARAM */;
  data->localData[0]->realVars[7] /* generator.SGenPu.re */ = data->simulationInfo->realParameter[1] /* generator.PGen0Pu PARAM */;
  data->localData[0]->realVars[5] /* generator.QGenPu */ = data->simulationInfo->realParameter[4] /* generator.QGen0Pu PARAM */;
  data->localData[0]->realVars[6] /* generator.SGenPu.im */ = data->simulationInfo->realParameter[4] /* generator.QGen0Pu PARAM */;
  data->localData[0]->integerDoubleVars[1] /* generator.qStatus */ = 1;
  data->localData[0]->integerDoubleVars[2] /* generator.state */ = (modelica_integer)data->simulationInfo->integerParameter[1] /* generator.State0 PARAM */;
}

void ModelGeneratorPQ_Dyn::callCustomParametersConstructors()
{
}

void ModelGeneratorPQ_Dyn::evalStaticYType_omc(propertyContinuousVar_t* yType)
{
   yType[ 0 ] = EXTERNAL;   /* generator_omegaRefPu_value (rSta) - external variables */
   yType[ 1 ] = EXTERNAL;   /* generator_terminal_V_im (rSta) - external variables */
   yType[ 2 ] = EXTERNAL;   /* generator_terminal_V_re (rSta) - external variables */
   yType[ 3 ] = ALGEBRAIC;   /* generator_PGenPu (rAlg)  */
   yType[ 4 ] = ALGEBRAIC;   /* generator_PGenRawPu (rAlg)  */
   yType[ 5 ] = ALGEBRAIC;   /* generator_QGenPu (rAlg)  */
   yType[ 6 ] = ALGEBRAIC;   /* generator_SGenPu_im (rAlg)  */
   yType[ 7 ] = ALGEBRAIC;   /* generator_SGenPu_re (rAlg)  */
   yType[ 8 ] = ALGEBRAIC;   /* generator_UPu (rAlg)  */
   yType[ 9 ] = ALGEBRAIC;   /* generator_terminal_i_im (rAlg)  */
   yType[ 10 ] = ALGEBRAIC;   /* generator_terminal_i_re (rAlg)  */
}

void ModelGeneratorPQ_Dyn::evalDynamicYType_omc(propertyContinuousVar_t* yType)
{
}

void ModelGeneratorPQ_Dyn::evalStaticFType_omc(propertyF_t* fType)
{
   fType[ 0 ] = ALGEBRAIC_EQ;
   fType[ 1 ] = ALGEBRAIC_EQ;
   fType[ 2 ] = ALGEBRAIC_EQ;
   fType[ 3 ] = ALGEBRAIC_EQ;
   fType[ 4 ] = ALGEBRAIC_EQ;
   fType[ 5 ] = ALGEBRAIC_EQ;
   fType[ 6 ] = ALGEBRAIC_EQ;
   fType[ 7 ] = ALGEBRAIC_EQ;
}

void ModelGeneratorPQ_Dyn::evalDynamicFType_omc(propertyF_t* fType)
{
}

std::shared_ptr<parameters::ParametersSet> ModelGeneratorPQ_Dyn::setSharedParametersDefaultValues()
{

   // Propagating shared parameters default value 

   // This value may be updated later on through *.par/*.iidm data 
  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("SharedModelicaParameters");
  int generator_NbSwitchOffSignals_internal;
  int generator_State0_internal;

  generator_NbSwitchOffSignals_internal = 3; 
  parametersSet->createParameter("generator_NbSwitchOffSignals", generator_NbSwitchOffSignals_internal);
  generator_State0_internal = 2; 
  parametersSet->createParameter("generator_State0", generator_State0_internal);
  return parametersSet;
}

void ModelGeneratorPQ_Dyn::setParameters( std::shared_ptr<parameters::ParametersSet> params )
{
  generator_AlphaPu_ = params->getParameter("generator_AlphaPu")->getDouble();
  generator_PGen0Pu_ = params->getParameter("generator_PGen0Pu")->getDouble();
  generator_PMaxPu_ = params->getParameter("generator_PMaxPu")->getDouble();
  generator_PMinPu_ = params->getParameter("generator_PMinPu")->getDouble();
  generator_QGen0Pu_ = params->getParameter("generator_QGen0Pu")->getDouble();
  generator_QMaxPu_ = params->getParameter("generator_QMaxPu")->getDouble();
  generator_QMinPu_ = params->getParameter("generator_QMinPu")->getDouble();
  generator_U0Pu_ = params->getParameter("generator_U0Pu")->getDouble();
  generator_UMaxPu_ = params->getParameter("generator_UMaxPu")->getDouble();
  generator_UMinPu_ = params->getParameter("generator_UMinPu")->getDouble();
  generator_i0Pu_im_ = params->getParameter("generator_i0Pu_im")->getDouble();
  generator_i0Pu_re_ = params->getParameter("generator_i0Pu_re")->getDouble();
  generator_u0Pu_im_ = params->getParameter("generator_u0Pu_im")->getDouble();
  generator_u0Pu_re_ = params->getParameter("generator_u0Pu_re")->getDouble();
  generator_NbSwitchOffSignals_ = params->getParameter("generator_NbSwitchOffSignals")->getInt();
  generator_State0_ = params->getParameter("generator_State0")->getInt();
}

void ModelGeneratorPQ_Dyn::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables)
{
  variables.push_back (VariableNativeFactory::createState ("generator_omegaRefPu_value", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_terminal_V_im", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_terminal_V_re", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_PGenPu", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_PGenRawPu", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_QGenPu", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_SGenPu_im", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_SGenPu_re", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_UPu", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_terminal_i_im", FLOW, false));
  variables.push_back (VariableNativeFactory::createState ("generator_terminal_i_re", FLOW, false));
  variables.push_back (VariableNativeFactory::createState ("generator_pStatus", INTEGER, false));
  variables.push_back (VariableNativeFactory::createState ("generator_qStatus", INTEGER, false));
  variables.push_back (VariableNativeFactory::createState ("generator_state", INTEGER, false));
  variables.push_back (VariableNativeFactory::createState ("generator_running_value", BOOLEAN, false));
  variables.push_back (VariableNativeFactory::createState ("generator_switchOffSignal1_value", BOOLEAN, false));
  variables.push_back (VariableNativeFactory::createState ("generator_switchOffSignal2_value", BOOLEAN, false));
  variables.push_back (VariableNativeFactory::createState ("generator_switchOffSignal3_value", BOOLEAN, false));
}

void ModelGeneratorPQ_Dyn::defineParameters(std::vector<ParameterModeler>& parameters)
{
  using ParameterModelerTuple = std::tuple<std::string, DYN::typeVarC_t, DYN::parameterScope_t>;
  std::array<ParameterModelerTuple, 16> parameterModelerArray = {
    std::make_tuple("generator_AlphaPu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER),
    std::make_tuple("generator_PGen0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER),
    std::make_tuple("generator_PMaxPu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER),
    std::make_tuple("generator_PMinPu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER),
    std::make_tuple("generator_QGen0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER),
    std::make_tuple("generator_QMaxPu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER),
    std::make_tuple("generator_QMinPu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER),
    std::make_tuple("generator_U0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER),
    std::make_tuple("generator_UMaxPu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER),
    std::make_tuple("generator_UMinPu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER),
    std::make_tuple("generator_i0Pu_im", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER),
    std::make_tuple("generator_i0Pu_re", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER),
    std::make_tuple("generator_u0Pu_im", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER),
    std::make_tuple("generator_u0Pu_re", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER),
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
  std::array<ElementTuple, 28> elementArray1 = {
    std::make_tuple("generator", "generator", Element::STRUCTURE),
    std::make_tuple("switchOffSignal3", "generator_switchOffSignal3", Element::STRUCTURE),
    std::make_tuple("value", "generator_switchOffSignal3_value", Element::TERMINAL),
    std::make_tuple("switchOffSignal2", "generator_switchOffSignal2", Element::STRUCTURE),
    std::make_tuple("value", "generator_switchOffSignal2_value", Element::TERMINAL),
    std::make_tuple("omegaRefPu", "generator_omegaRefPu", Element::STRUCTURE),
    std::make_tuple("value", "generator_omegaRefPu_value", Element::TERMINAL),
    std::make_tuple("terminal", "generator_terminal", Element::STRUCTURE),
    std::make_tuple("i", "generator_terminal_i", Element::STRUCTURE),
    std::make_tuple("im", "generator_terminal_i_im", Element::TERMINAL),
    std::make_tuple("re", "generator_terminal_i_re", Element::TERMINAL),
    std::make_tuple("running", "generator_running", Element::STRUCTURE),
    std::make_tuple("value", "generator_running_value", Element::TERMINAL),
    std::make_tuple("switchOffSignal1", "generator_switchOffSignal1", Element::STRUCTURE),
    std::make_tuple("value", "generator_switchOffSignal1_value", Element::TERMINAL),
    std::make_tuple("qStatus", "generator_qStatus", Element::TERMINAL),
    std::make_tuple("pStatus", "generator_pStatus", Element::TERMINAL),
    std::make_tuple("PGenRawPu", "generator_PGenRawPu", Element::TERMINAL),
    std::make_tuple("UPu", "generator_UPu", Element::TERMINAL),
    std::make_tuple("QGenPu", "generator_QGenPu", Element::TERMINAL),
    std::make_tuple("PGenPu", "generator_PGenPu", Element::TERMINAL),
    std::make_tuple("SGenPu", "generator_SGenPu", Element::STRUCTURE),
    std::make_tuple("im", "generator_SGenPu_im", Element::TERMINAL),
    std::make_tuple("re", "generator_SGenPu_re", Element::TERMINAL),
    std::make_tuple("V", "generator_terminal_V", Element::STRUCTURE),
    std::make_tuple("im", "generator_terminal_V_im", Element::TERMINAL),
    std::make_tuple("re", "generator_terminal_V_re", Element::TERMINAL),
    std::make_tuple("state", "generator_state", Element::TERMINAL),
  };
  for (size_t elementsIndex1 = 0; elementsIndex1 < elementArray1.size(); ++elementsIndex1)
  {
    elements.push_back(Element(std::get<0>(elementArray1[elementsIndex1]), std::get<1>(elementArray1[elementsIndex1]), std::get<2>(elementArray1[elementsIndex1])));
  }

  elements[0].subElementsNum().push_back(1);
  elements[0].subElementsNum().push_back(3);
  elements[0].subElementsNum().push_back(5);
  elements[0].subElementsNum().push_back(7);
  elements[0].subElementsNum().push_back(11);
  elements[0].subElementsNum().push_back(13);
  elements[0].subElementsNum().push_back(15);
  elements[0].subElementsNum().push_back(16);
  elements[0].subElementsNum().push_back(17);
  elements[0].subElementsNum().push_back(18);
  elements[0].subElementsNum().push_back(19);
  elements[0].subElementsNum().push_back(20);
  elements[0].subElementsNum().push_back(21);
  elements[0].subElementsNum().push_back(27);
  elements[1].subElementsNum().push_back(2);
  elements[3].subElementsNum().push_back(4);
  elements[5].subElementsNum().push_back(6);
  elements[7].subElementsNum().push_back(8);
  elements[7].subElementsNum().push_back(24);
  elements[8].subElementsNum().push_back(9);
  elements[8].subElementsNum().push_back(10);
  elements[11].subElementsNum().push_back(12);
  elements[13].subElementsNum().push_back(14);
  elements[21].subElementsNum().push_back(22);
  elements[21].subElementsNum().push_back(23);
  elements[24].subElementsNum().push_back(25);
  elements[24].subElementsNum().push_back(26);

  std::array<std::pair<std::string, int>, 28> mapElementArray = {
    std::make_pair("generator", 0),
    std::make_pair("generator_switchOffSignal3", 1),
    std::make_pair("generator_switchOffSignal3_value", 2),
    std::make_pair("generator_switchOffSignal2", 3),
    std::make_pair("generator_switchOffSignal2_value", 4),
    std::make_pair("generator_omegaRefPu", 5),
    std::make_pair("generator_omegaRefPu_value", 6),
    std::make_pair("generator_terminal", 7),
    std::make_pair("generator_terminal_i", 8),
    std::make_pair("generator_terminal_i_im", 9),
    std::make_pair("generator_terminal_i_re", 10),
    std::make_pair("generator_running", 11),
    std::make_pair("generator_running_value", 12),
    std::make_pair("generator_switchOffSignal1", 13),
    std::make_pair("generator_switchOffSignal1_value", 14),
    std::make_pair("generator_qStatus", 15),
    std::make_pair("generator_pStatus", 16),
    std::make_pair("generator_PGenRawPu", 17),
    std::make_pair("generator_UPu", 18),
    std::make_pair("generator_QGenPu", 19),
    std::make_pair("generator_PGenPu", 20),
    std::make_pair("generator_SGenPu", 21),
    std::make_pair("generator_SGenPu_im", 22),
    std::make_pair("generator_SGenPu_re", 23),
    std::make_pair("generator_terminal_V", 24),
    std::make_pair("generator_terminal_V_im", 25),
    std::make_pair("generator_terminal_V_re", 26),
    std::make_pair("generator_state", 27),
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
    generator_omegaRefPu_value : x[0]
    generator_terminal_V_im : x[1]
    generator_terminal_V_re : x[2]
    generator_PGenPu : x[3]
    generator_PGenRawPu : x[4]
    generator_QGenPu : x[5]
    generator_SGenPu_im : x[6]
    generator_SGenPu_re : x[7]
    generator_UPu : x[8]
    generator_terminal_i_im : x[9]
    generator_terminal_i_re : x[10]
    der(generator_omegaRefPu_value) : xd[0]
    der(generator_terminal_V_im) : xd[1]
    der(generator_terminal_V_re) : xd[2]

  */
  adept::adouble $DAEres3;
  adept::adouble $DAEres4;
  // ----- GeneratorPQ_eqFunction_63 -----
  {
  adept::adouble tmp0;
  adept::adouble tmp1;
  adept::adouble tmp2;
  tmp0 = x[2];
  tmp1 = x[1];
  res[0] = x[8] - ( sqrt((tmp0 * tmp0) + (tmp1 * tmp1)) );

  }


  // ----- GeneratorPQ_eqFunction_81 -----
  {
  modelica_boolean tmp12;
  adept::adouble tmp13;
  tmp12 = (modelica_boolean)(toNativeBool (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */));
  if(tmp12)
  {
    tmp13 = data->simulationInfo->realParameter[1] /* generator.PGen0Pu PARAM */ + (data->simulationInfo->realParameter[0] /* generator.AlphaPu PARAM */) * (1.0 - x[0]);
  }
  else
  {
    tmp13 = 0.0;
  }
  res[1] = x[4] - ( tmp13 );

  }


  // ----- GeneratorPQ_eqFunction_90 -----
  {
  modelica_boolean tmp24;
  adept::adouble tmp25;
  modelica_boolean tmp26;
  adept::adouble tmp27;
  modelica_boolean tmp28;
  adept::adouble tmp29;
  tmp28 = (modelica_boolean)(toNativeBool (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */));
  if(tmp28)
  {
    tmp26 = (modelica_boolean)((modelica_integer)data->localData[0]->integerDoubleVars[0] /* generator.pStatus DISCRETE */ == 3);
    if(tmp26)
    {
      tmp27 = data->simulationInfo->realParameter[2] /* generator.PMaxPu PARAM */;
    }
    else
    {
      tmp24 = (modelica_boolean)((modelica_integer)data->localData[0]->integerDoubleVars[0] /* generator.pStatus DISCRETE */ == 2);
      if(tmp24)
      {
        tmp25 = data->simulationInfo->realParameter[3] /* generator.PMinPu PARAM */;
      }
      else
      {
        tmp25 = x[4];
      }
      tmp27 = tmp25;
    }
    tmp29 = tmp27;
  }
  else
  {
    tmp29 = 0.0;
  }
  res[2] = x[3] - ( tmp29 );

  }


  // ----- GeneratorPQ_eqFunction_91 -----
  {
  res[3] = x[7] - ( x[3] );

  }


  // ----- GeneratorPQ_eqFunction_92 -----
  {
  $DAEres3 = ((-x[2])) * (x[10]) - x[7] - ((x[1]) * (x[9]));
  res[4] = $DAEres3;

  }


  // ----- GeneratorPQ_eqFunction_93 -----
  {
  modelica_boolean tmp32;
  adept::adouble tmp33;
  modelica_boolean tmp34;
  adept::adouble tmp35;
  modelica_boolean tmp36;
  adept::adouble tmp37;
  tmp36 = (modelica_boolean)(toNativeBool (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */));
  if(tmp36)
  {
    tmp34 = (modelica_boolean)(data->simulationInfo->integerDoubleVarsPre[1] /* generator.qStatus DISCRETE */ == 2);
    if(tmp34)
    {
      tmp35 = data->simulationInfo->realParameter[5] /* generator.QMaxPu PARAM */;
    }
    else
    {
      tmp32 = (modelica_boolean)(data->simulationInfo->integerDoubleVarsPre[1] /* generator.qStatus DISCRETE */ == 3);
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
  res[5] = x[5] - ( tmp37 );

  }


  // ----- GeneratorPQ_eqFunction_94 -----
  {
  res[6] = x[6] - ( x[5] );

  }


  // ----- GeneratorPQ_eqFunction_95 -----
  {
  $DAEres4 = (x[2]) * (x[9]) + ((-x[1])) * (x[10]) - x[6];
  res[7] = $DAEres4;

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
  static int tmp4 = 0;
 modelica_string tmpMeta[1];
  if(!tmp4)
  {
    tmp0 = GreaterEq((modelica_integer)data->simulationInfo->integerParameter[0] /* generator.NbSwitchOffSignals PARAM */,((modelica_integer) 1));
    tmp1 = LessEq((modelica_integer)data->simulationInfo->integerParameter[0] /* generator.NbSwitchOffSignals PARAM */,((modelica_integer) 3));
    if(!(tmp0 && tmp1))
    {
      tmp3 = modelica_integer_to_modelica_string_format((modelica_integer)data->simulationInfo->integerParameter[0] /* generator.NbSwitchOffSignals PARAM */, mmc_strings_len1(100));
      tmpMeta[0] = stringAppend((tmp2),tmp3);
      {
        omc_assert_warning("The following assertion has been violated %sat time %f\ngenerator.NbSwitchOffSignals >= 1 and generator.NbSwitchOffSignals <= 3", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(equationIndexes, (tmpMeta[0]));
      }
      tmp4 = 1;
    }
  }
}


}
{
{
  modelica_boolean tmp5;
  modelica_boolean tmp6;
  const modelica_string   tmp7 = "Variable violating min/max constraint: Dynawo.Electrical.Constants.state.Open <= generator.State0 <= Dynawo.Electrical.Constants.state.Undefined has value: ";
  modelica_string tmp8;
  static int tmp9 = 0;
 modelica_string tmpMeta[1];
  if(!tmp9)
  {
    tmp5 = GreaterEq((modelica_integer)data->simulationInfo->integerParameter[1] /* generator.State0 PARAM */,1);
    tmp6 = LessEq((modelica_integer)data->simulationInfo->integerParameter[1] /* generator.State0 PARAM */,6);
    if(!(tmp5 && tmp6))
    {
      tmp8 = modelica_integer_to_modelica_string_format((modelica_integer)data->simulationInfo->integerParameter[1] /* generator.State0 PARAM */, mmc_strings_len1(100));
      tmpMeta[0] = stringAppend((tmp7),tmp8);
      {
        omc_assert_warning("The following assertion has been violated %sat time %f\ngenerator.State0 >= Dynawo.Electrical.Constants.state.Open and generator.State0 <= Dynawo.Electrical.Constants.state.Undefined", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(equationIndexes, (tmpMeta[0]));
      }
      tmp9 = 1;
    }
  }
}


}
}

void ModelGeneratorPQ_Dyn::setFequations(std::map<int,std::string>& fEquationIndex)
{
  //Note: fictive equations are not added. fEquationIndex.size() = sizeF() - Nunmber of fictive equations.
  fEquationIndex[0] = "generator._UPu = (generator.terminal.V.re ^ 2.0 + generator.terminal.V.im ^ 2.0) ^ 0.5";//equation_index_omc:63
  fEquationIndex[1] = "generator._PGenRawPu = if generator.running.value then generator.PGen0Pu + generator.AlphaPu * (1.0 - generator.omegaRefPu.value) else 0.0";//equation_index_omc:81
  fEquationIndex[2] = "generator._PGenPu = if generator.running.value then if generator.pStatus == Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMax then generator.PMaxPu else if generator.pStatus == Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMin then generator.PMinPu else generator.PGenRawPu else 0.0";//equation_index_omc:90
  fEquationIndex[3] = "generator._SGenPu._re = generator.PGenPu";//equation_index_omc:91
  fEquationIndex[4] = "$DAEres3 = (-generator.terminal.V.re) * generator.terminal.i.re - generator.SGenPu.re - generator.terminal.V.im * generator.terminal.i.im";//equation_index_omc:92
  fEquationIndex[5] = "generator._QGenPu = if generator.running.value then if pre(generator.qStatus) == Dynawo.Electrical.Machines.GeneratorPQ.QStatus.AbsorptionMax then generator.QMaxPu else if pre(generator.qStatus) == Dynawo.Electrical.Machines.GeneratorPQ.QStatus.GenerationMax then generator.QMinPu else generator.QGen0Pu else 0.0";//equation_index_omc:93
  fEquationIndex[6] = "generator._SGenPu._im = generator.QGenPu";//equation_index_omc:94
  fEquationIndex[7] = "$DAEres4 = generator.terminal.V.re * generator.terminal.i.im + (-generator.terminal.V.im) * generator.terminal.i.re - generator.SGenPu.im";//equation_index_omc:95
}

void ModelGeneratorPQ_Dyn::setGequations(std::map<int,std::string>& gEquationIndex)
{
// ---------------- boolean conditions -------------
  static const char *res[] = {  "generator.PGenRawPu >= generator.PMaxPu and pre(generator.pStatus) <> Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMax",
  "generator.PGenRawPu <= generator.PMinPu and pre(generator.pStatus) <> Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMin",
  "generator.PGenRawPu > generator.PMinPu and pre(generator.pStatus) == Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMin",
  "generator.PGenRawPu < generator.PMaxPu and pre(generator.pStatus) == Dynawo.Electrical.Machines.GeneratorPQ.PStatus.LimitPMax",
  "generator.UPu >= 0.0001 + generator.UMaxPu and pre(generator.qStatus) <> Dynawo.Electrical.Machines.GeneratorPQ.QStatus.AbsorptionMax",
  "generator.UPu <= -0.0001 + generator.UMinPu and pre(generator.qStatus) <> Dynawo.Electrical.Machines.GeneratorPQ.QStatus.GenerationMax",
  "generator.UPu < -0.0001 + generator.UMaxPu and pre(generator.qStatus) == Dynawo.Electrical.Machines.GeneratorPQ.QStatus.AbsorptionMax or generator.UPu > 0.0001 + generator.UMinPu and pre(generator.qStatus) == Dynawo.Electrical.Machines.GeneratorPQ.QStatus.GenerationMax"};
  gEquationIndex[0] =  res[0]  ;
  gEquationIndex[1] =  res[1]  ;
  gEquationIndex[2] =  res[2]  ;
  gEquationIndex[3] =  res[3]  ;
  gEquationIndex[4] =  res[4]  ;
  gEquationIndex[5] =  res[5]  ;
  gEquationIndex[6] =  res[6]  ;
// -----------------------------
  // ------------- $whenCondition6 ------------
  gEquationIndex[7] = " $whenCondition6:  data->localData[0]->booleanVars[6] /* $whenCondition6 DISCRETE */ = (((toNativeBool (data->localData[0]->discreteVars[1] /* generator.switchOffSignal1.value DISCRETE */)) || (toNativeBool (data->localData[0]->discreteVars[2] /* generator.switchOffSignal2.value DISCRETE */))) || ((toNativeBool (data->localData[0]->discreteVars[3] /* generator.switchOffSignal3.value DISCRETE */)) && (toNativeBool (data->simulationInfo->discreteVarsPre[0] /* generator.running.value DISCRETE */)))); " ;
 
  // ------------- $whenCondition7 ------------
  gEquationIndex[8] = " $whenCondition7:  data->localData[0]->booleanVars[7] /* $whenCondition7 DISCRETE */ = (!(toNativeBool (data->localData[0]->discreteVars[0] /* generator.running.value DISCRETE */))); " ;
 
}

void ModelGeneratorPQ_Dyn::evalCalculatedVars(std::vector<double>& calculatedVars)
{
}

double ModelGeneratorPQ_Dyn::evalCalculatedVarI(unsigned iCalculatedVar) const
{
  throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);
}

#ifdef _ADEPT_
adept::adouble ModelGeneratorPQ_Dyn::evalCalculatedVarIAdept(unsigned iCalculatedVar, unsigned indexOffset, const std::vector<adept::adouble> &x, const std::vector<adept::adouble> &xd) const
{
  throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);
}
#endif

void ModelGeneratorPQ_Dyn::getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const
{
}

}