#include <limits>
#include <cassert>
#include <set>
#include <string>
#include <vector>
#include <math.h>

#include "DYNElement.h"

#include "MACHINE_PQ_Dyn.h"
#include "MACHINE_PQ_Dyn_definition.h"
#include "MACHINE_PQ_Dyn_literal.h"


namespace DYN {


void ModelMACHINE_PQ_Dyn::initData(DYNDATA *d)
{
  setData(d);
  setupDataStruc();
  initializeDataStruc();
}

void ModelMACHINE_PQ_Dyn::setupDataStruc()
{

  data->modelData = (MODEL_DATA *)calloc(1,sizeof(MODEL_DATA));
  data->simulationInfo = (SIMULATION_INFO *)calloc(1,sizeof(SIMULATION_INFO));
  data->nbDummy = 0;
  data->modelData->nStates = 3;
  data->modelData->nVariablesReal = 3+8+0 + 0;
  data->modelData->nDiscreteReal = 0 + 4; // 4 booleans emulated as discrete real variables
  data->modelData->nVariablesInteger = 3;
  data->modelData->nVariablesBoolean = 14 - 4; // 4 booleans emulated as discrete real variables
  data->modelData->nVariablesString = 0;
  data->modelData->nParametersReal = 14 + 0; // 0 boolean emulated as real parameter
  data->modelData->nParametersInteger = 2;
  data->modelData->nParametersBoolean = 0; // all boolean parameters emulated as real parameters
  data->modelData->nParametersString = 0;
  data->modelData->nInputVars = 0;
  data->modelData->nOutputVars = 0;
  data->modelData->nAliasReal = 0;
  data->modelData->nAliasInteger = 0;
  data->modelData->nAliasBoolean = 0;
  data->modelData->nAliasString = 0;
  data->modelData->nZeroCrossings = 7 + 9;
  data->modelData->nSamples = 0;
  data->modelData->nRelations = 9;
  data->modelData->nMathEvents = 0;
  data->modelData->nExtObjs = 0;
  data->modelData->nMixedSystems = 0;
  data->modelData->nLinearSystems = 2;
  data->modelData->nNonLinearSystems = 0;
  data->modelData->nStateSets = 0;
  data->modelData->nJacobians = 4;
  data->modelData->nOptimizeConstraints = 0;
  data->modelData->nOptimizeFinalConstraints = 0;
  data->modelData->nDelayExpressions = 0;
  data->modelData->nClocks = 0;
  data->modelData->nSubClocks = 0;

  data->nbVars =11;
  data->nbF = 8;
  data->nbModes = 0; 
  data->nbZ = 4;
}

void ModelMACHINE_PQ_Dyn::initializeDataStruc()
{

  dataStructIsInitialized_ = true;
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


  // buffer for all parameters values
  nb = (data->modelData->nParametersReal > 0) ? data->modelData->nParametersReal : 0;
  data->simulationInfo->realParameter = (modelica_real*) calloc(nb, sizeof(modelica_real));

  nb = (data->modelData->nParametersBoolean > 0) ? data->modelData->nParametersBoolean : 0;
  data->simulationInfo->booleanParameter = (modelica_boolean*) calloc(nb, sizeof(modelica_boolean));

  nb = (data->modelData->nParametersInteger > 0) ? data->modelData->nParametersInteger : 0;
  data->simulationInfo->integerParameter = (modelica_integer*) calloc(nb, sizeof(modelica_integer));

  nb = (data->modelData->nParametersString > 0) ? data->modelData->nParametersString : 0;
  data->simulationInfo->stringParameter = (modelica_string*) calloc(nb, sizeof(modelica_string));

}

void ModelMACHINE_PQ_Dyn::deInitializeDataStruc()
{

  if(! dataStructIsInitialized_)
    return;

  dataStructIsInitialized_ = false;
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
  free(data->simulationInfo);
  free(data->modelData);

}

void ModelMACHINE_PQ_Dyn::initRpar()
{
  /* Setting shared and external parameters */
  $PMACHINE$PAlphaPu = MACHINE_AlphaPu_;
  $PMACHINE$PPGen0Pu = MACHINE_PGen0Pu_;
  $PMACHINE$PPMaxPu = MACHINE_PMaxPu_;
  $PMACHINE$PPMinPu = MACHINE_PMinPu_;
  $PMACHINE$PQGen0Pu = MACHINE_QGen0Pu_;
  $PMACHINE$PQMaxPu = MACHINE_QMaxPu_;
  $PMACHINE$PQMinPu = MACHINE_QMinPu_;
  $PMACHINE$PU0Pu = MACHINE_U0Pu_;
  $PMACHINE$PUMaxPu = MACHINE_UMaxPu_;
  $PMACHINE$PUMinPu = MACHINE_UMinPu_;
  $PMACHINE$Pi0Pu$Pim = MACHINE_i0Pu_im_;
  $PMACHINE$Pi0Pu$Pre = MACHINE_i0Pu_re_;
  $PMACHINE$Pu0Pu$Pim = MACHINE_u0Pu_im_;
  $PMACHINE$Pu0Pu$Pre = MACHINE_u0Pu_re_;
  $PMACHINE$PNbSwitchOffSignals = MACHINE_NbSwitchOffSignals_;
  $PMACHINE$PState0 = MACHINE_State0_;

  // Setting internal parameters 

  return;
}

void ModelMACHINE_PQ_Dyn::setFomc(double * f)
{
  // ----- MACHINE_PQ_eqFunction_49 -----
  modelica_boolean tmp29;
  modelica_real tmp30;
  tmp29 = (modelica_boolean)(toNativeBool ($PMACHINE$Prunning$Pvalue));
  if(tmp29)
  {
    tmp30 = $PMACHINE$PPGen0Pu + ($PMACHINE$PAlphaPu) * (1.0 - $PMACHINE$PomegaRefPu$Pvalue);
  }
  else
  {
    tmp30 = 0.0;
  }
  f[0] = $PMACHINE$PPGenRawPu - ( tmp30 );


  // ----- MACHINE_PQ_eqFunction_58 -----
  modelica_boolean tmp41;
  modelica_real tmp42;
  modelica_boolean tmp43;
  modelica_real tmp44;
  modelica_boolean tmp45;
  modelica_real tmp46;
  tmp45 = (modelica_boolean)(toNativeBool ($PMACHINE$Prunning$Pvalue));
  if(tmp45)
  {
    tmp43 = (modelica_boolean)((modelica_integer)$PMACHINE$PpStatus == 3);
    if(tmp43)
    {
      tmp44 = $PMACHINE$PPMaxPu;
    }
    else
    {
      tmp41 = (modelica_boolean)((modelica_integer)$PMACHINE$PpStatus == 2);
      if(tmp41)
      {
        tmp42 = $PMACHINE$PPMinPu;
      }
      else
      {
        tmp42 = $PMACHINE$PPGenRawPu;
      }
      tmp44 = tmp42;
    }
    tmp46 = tmp44;
  }
  else
  {
    tmp46 = 0.0;
  }
  f[1] = $PMACHINE$PPGenPu - ( tmp46 );


  // ----- MACHINE_PQ_eqFunction_59 -----
  modelica_real tmp47;
  modelica_real tmp48;
  modelica_real tmp49;
  tmp47 = $PMACHINE$Pterminal$PV$Pre;
  tmp48 = $PMACHINE$Pterminal$PV$Pim;
  f[2] = $PMACHINE$PUPu - ( sqrt((tmp47 * tmp47) + (tmp48 * tmp48)) );


  // ----- MACHINE_PQ_eqFunction_66 -----
  f[3] = $PMACHINE$PSGenPu$Pre - ( $PMACHINE$PPGenPu );


  // ----- MACHINE_PQ_eqFunction_67 -----
  modelica_boolean tmp60;
  modelica_real tmp61;
  modelica_boolean tmp62;
  modelica_real tmp63;
  modelica_boolean tmp64;
  modelica_real tmp65;
  tmp64 = (modelica_boolean)(toNativeBool ($PMACHINE$Prunning$Pvalue));
  if(tmp64)
  {
    tmp62 = (modelica_boolean)($P$PRE$PMACHINE$PqStatus == 2);
    if(tmp62)
    {
      tmp63 = $PMACHINE$PQMaxPu;
    }
    else
    {
      tmp60 = (modelica_boolean)($P$PRE$PMACHINE$PqStatus == 3);
      if(tmp60)
      {
        tmp61 = $PMACHINE$PQMinPu;
      }
      else
      {
        tmp61 = $PMACHINE$PQGen0Pu;
      }
      tmp63 = tmp61;
    }
    tmp65 = tmp63;
  }
  else
  {
    tmp65 = 0.0;
  }
  f[4] = $PMACHINE$PQGenPu - ( tmp65 );


  // ----- MACHINE_PQ_eqFunction_68 -----
  f[5] = $PMACHINE$PSGenPu$Pim - ( $PMACHINE$PQGenPu );


  // ----- setLinearMatrixA69 -----
  f[6] = ((-$PMACHINE$Pterminal$PV$Pre))*($PMACHINE$Pterminal$Pi$Pim) + ($PMACHINE$Pterminal$PV$Pim)*($PMACHINE$Pterminal$Pi$Pre) - ( (-$PMACHINE$PSGenPu$Pim) );

  // ----- setLinearMatrixA69 -----
  f[7] = ($PMACHINE$Pterminal$PV$Pim)*($PMACHINE$Pterminal$Pi$Pim) + ($PMACHINE$Pterminal$PV$Pre)*($PMACHINE$Pterminal$Pi$Pre) - ( (-$PMACHINE$PSGenPu$Pre) );

}

bool ModelMACHINE_PQ_Dyn::evalMode(const double & t) const
{
  // modes may either be due to
  // - a change in network topology (currently forbidden for Modelica models)
  // - a Modelica reinit command
  // no mode triggered => return false
  return false;
}

void ModelMACHINE_PQ_Dyn::setZomc()
{

  // -------------------- MACHINE.running.value ---------------------
  if(($P$whenCondition6 && !$P$PRE$P$whenCondition6 /* edge */))
  {
    $PMACHINE$Prunning$Pvalue = fromNativeBool ( 0);
  }

  // -------------------- MACHINE.pStatus ---------------------
  if(($P$whenCondition5 && !$P$PRE$P$whenCondition5 /* edge */))
  {
    $PMACHINE$PpStatus = 3;
  }
  else if(($P$whenCondition4 && !$P$PRE$P$whenCondition4 /* edge */))
  {
    $PMACHINE$PpStatus = 2;
  }
  else if(($P$whenCondition3 && !$P$PRE$P$whenCondition3 /* edge */))
  {
    $PMACHINE$PpStatus = 1;
  }
  else if(($P$whenCondition2 && !$P$PRE$P$whenCondition2 /* edge */))
  {
    $PMACHINE$PpStatus = 1;
  }

  // -------------------- MACHINE.qStatus ---------------------
  if(($P$whenCondition10 && !$P$PRE$P$whenCondition10 /* edge */))
  {
    $PMACHINE$PqStatus = 2;
  }
  else if(($P$whenCondition9 && !$P$PRE$P$whenCondition9 /* edge */))
  {
    $PMACHINE$PqStatus = 3;
  }
  else if(($P$whenCondition8 && !$P$PRE$P$whenCondition8 /* edge */))
  {
    $PMACHINE$PqStatus = 1;
  }

  // -------------------- MACHINE.state ---------------------
  if(($P$whenCondition7 && !$P$PRE$P$whenCondition7 /* edge */))
  {
    $PMACHINE$Pstate = 1;
  }


  // -------------- call functions ----------
{
  if(($P$whenCondition6 && !$P$PRE$P$whenCondition6 /* edge */))
  {
    $PMACHINE$Prunning$Pvalue = fromNativeBool ( 0);
  }
}
{
  if(($P$whenCondition7 && !$P$PRE$P$whenCondition7 /* edge */))
  {
    $PMACHINE$Pstate = 1;
  }
}
{
  if(($P$whenCondition5 && !$P$PRE$P$whenCondition5 /* edge */))
  {
    $PMACHINE$PpStatus = 3;
  }
  else if(($P$whenCondition4 && !$P$PRE$P$whenCondition4 /* edge */))
  {
    $PMACHINE$PpStatus = 2;
  }
  else if(($P$whenCondition3 && !$P$PRE$P$whenCondition3 /* edge */))
  {
    $PMACHINE$PpStatus = 1;
  }
  else if(($P$whenCondition2 && !$P$PRE$P$whenCondition2 /* edge */))
  {
    $PMACHINE$PpStatus = 1;
  }
}
{
  if(($P$whenCondition10 && !$P$PRE$P$whenCondition10 /* edge */))
  {
    $PMACHINE$PqStatus = 2;
  }
  else if(($P$whenCondition9 && !$P$PRE$P$whenCondition9 /* edge */))
  {
    $PMACHINE$PqStatus = 3;
  }
  else if(($P$whenCondition8 && !$P$PRE$P$whenCondition8 /* edge */))
  {
    $PMACHINE$PqStatus = 1;
  }
}
{
  if(($P$whenCondition10 && !$P$PRE$P$whenCondition10 /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( ((modelica_integer) 58));
  }
  else if(($P$whenCondition9 && !$P$PRE$P$whenCondition9 /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( ((modelica_integer) 29));
  }
  else if(($P$whenCondition8 && !$P$PRE$P$whenCondition8 /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( ((modelica_integer) 48));
  }
}
{
  if(($P$whenCondition7 && !$P$PRE$P$whenCondition7 /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( ((modelica_integer) 54));
  }
}
{
  if(($P$whenCondition5 && !$P$PRE$P$whenCondition5 /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( ((modelica_integer) 23));
  }
  else if(($P$whenCondition4 && !$P$PRE$P$whenCondition4 /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( ((modelica_integer) 15));
  }
  else if(($P$whenCondition3 && !$P$PRE$P$whenCondition3 /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( ((modelica_integer) 68));
  }
  else if(($P$whenCondition2 && !$P$PRE$P$whenCondition2 /* edge */))
  {
    omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( ((modelica_integer) 10));
  }
}


}

void ModelMACHINE_PQ_Dyn::setGomc(state_g * gout)
{
  // ------------- $whenCondition10 ------------
  modelica_boolean tmp50;
  RELATIONHYSTERESIS(tmp50, $PMACHINE$PUPu, 0.0001 + $PMACHINE$PUMaxPu, 5, GreaterEq);
  $P$whenCondition10 = (tmp50 && ($P$PRE$PMACHINE$PqStatus != 2));
 
  // ------------- $whenCondition2 ------------
  modelica_boolean tmp37;
  RELATIONHYSTERESIS(tmp37, $PMACHINE$PPGenRawPu, $PMACHINE$PPMaxPu, 4, Less);
  $P$whenCondition2 = (tmp37 && ($P$PRE$PMACHINE$PpStatus == 3));
 
  // ------------- $whenCondition3 ------------
  modelica_boolean tmp35;
  RELATIONHYSTERESIS(tmp35, $PMACHINE$PPGenRawPu, $PMACHINE$PPMinPu, 3, Greater);
  $P$whenCondition3 = (tmp35 && ($P$PRE$PMACHINE$PpStatus == 2));
 
  // ------------- $whenCondition4 ------------
  modelica_boolean tmp33;
  RELATIONHYSTERESIS(tmp33, $PMACHINE$PPGenRawPu, $PMACHINE$PPMinPu, 2, LessEq);
  $P$whenCondition4 = (tmp33 && ($P$PRE$PMACHINE$PpStatus != 2));
 
  // ------------- $whenCondition5 ------------
  modelica_boolean tmp31;
  RELATIONHYSTERESIS(tmp31, $PMACHINE$PPGenRawPu, $PMACHINE$PPMaxPu, 1, GreaterEq);
  $P$whenCondition5 = (tmp31 && ($P$PRE$PMACHINE$PpStatus != 3));
 
  // ------------- $whenCondition6 ------------
  $P$whenCondition6 = (((toNativeBool ($PMACHINE$PswitchOffSignal1$Pvalue)) || (toNativeBool ($PMACHINE$PswitchOffSignal2$Pvalue))) || ((toNativeBool ($PMACHINE$PswitchOffSignal3$Pvalue)) && (toNativeBool ($P$PRE$PMACHINE$Prunning$Pvalue))));
 
  // ------------- $whenCondition7 ------------
  $P$whenCondition7 = (!(toNativeBool ($PMACHINE$Prunning$Pvalue)));
 
  // ------------- $whenCondition8 ------------
  modelica_boolean tmp54;
  modelica_boolean tmp56;
  RELATIONHYSTERESIS(tmp54, $PMACHINE$PUPu, -0.0001 + $PMACHINE$PUMaxPu, 7, Less);
  RELATIONHYSTERESIS(tmp56, $PMACHINE$PUPu, 0.0001 + $PMACHINE$PUMinPu, 8, Greater);
  $P$whenCondition8 = ((tmp54 && ($P$PRE$PMACHINE$PqStatus == 2)) || (tmp56 && ($P$PRE$PMACHINE$PqStatus == 3)));
 
  // ------------- $whenCondition9 ------------
  modelica_boolean tmp52;
  RELATIONHYSTERESIS(tmp52, $PMACHINE$PUPu, -0.0001 + $PMACHINE$PUMinPu, 6, LessEq);
  $P$whenCondition9 = (tmp52 && ($P$PRE$PMACHINE$PqStatus != 3));
 
  modelica_boolean tmp1054;
  modelica_boolean tmp1056;
  modelica_boolean tmp1058;
  modelica_boolean tmp1060;
  modelica_boolean tmp1062;
  modelica_boolean tmp1064;
  modelica_boolean tmp1066;
  modelica_boolean tmp1068;
  
  
  tmp1054 = GreaterEqZC($PMACHINE$PPGenRawPu, $PMACHINE$PPMaxPu, data->simulationInfo->storedRelations[1]);
  tmp1056 = LessEqZC($PMACHINE$PPGenRawPu, $PMACHINE$PPMinPu, data->simulationInfo->storedRelations[2]);
  tmp1058 = GreaterZC($PMACHINE$PPGenRawPu, $PMACHINE$PPMinPu, data->simulationInfo->storedRelations[3]);
  tmp1060 = LessZC($PMACHINE$PPGenRawPu, $PMACHINE$PPMaxPu, data->simulationInfo->storedRelations[4]);
  tmp1062 = GreaterEqZC($PMACHINE$PUPu, 0.0001 + $PMACHINE$PUMaxPu, data->simulationInfo->storedRelations[5]);
  tmp1064 = LessEqZC($PMACHINE$PUPu, -0.0001 + $PMACHINE$PUMinPu, data->simulationInfo->storedRelations[6]);
  tmp1066 = LessZC($PMACHINE$PUPu, -0.0001 + $PMACHINE$PUMaxPu, data->simulationInfo->storedRelations[7]);
  tmp1068 = GreaterZC($PMACHINE$PUPu, 0.0001 + $PMACHINE$PUMinPu, data->simulationInfo->storedRelations[8]);
  
  gout[0] = ((tmp1054 && ($P$PRE$PMACHINE$PpStatus != 3))) ? ROOT_UP : ROOT_DOWN;
  gout[1] = ((tmp1056 && ($P$PRE$PMACHINE$PpStatus != 2))) ? ROOT_UP : ROOT_DOWN;
  gout[2] = ((tmp1058 && ($P$PRE$PMACHINE$PpStatus == 2))) ? ROOT_UP : ROOT_DOWN;
  gout[3] = ((tmp1060 && ($P$PRE$PMACHINE$PpStatus == 3))) ? ROOT_UP : ROOT_DOWN;
  gout[4] = ((tmp1062 && ($P$PRE$PMACHINE$PqStatus != 2))) ? ROOT_UP : ROOT_DOWN;
  gout[5] = ((tmp1064 && ($P$PRE$PMACHINE$PqStatus != 3))) ? ROOT_UP : ROOT_DOWN;
  gout[6] = (((tmp1066 && ($P$PRE$PMACHINE$PqStatus == 2)) || (tmp1068 && ($P$PRE$PMACHINE$PqStatus == 3)))) ? ROOT_UP : ROOT_DOWN;
  gout[0 + 7] = ( $P$whenCondition10 ) ? ROOT_UP : ROOT_DOWN;
  gout[1 + 7] = ( $P$whenCondition2 ) ? ROOT_UP : ROOT_DOWN;
  gout[2 + 7] = ( $P$whenCondition3 ) ? ROOT_UP : ROOT_DOWN;
  gout[3 + 7] = ( $P$whenCondition4 ) ? ROOT_UP : ROOT_DOWN;
  gout[4 + 7] = ( $P$whenCondition5 ) ? ROOT_UP : ROOT_DOWN;
  gout[5 + 7] = ( $P$whenCondition6 ) ? ROOT_UP : ROOT_DOWN;
  gout[6 + 7] = ( $P$whenCondition7 ) ? ROOT_UP : ROOT_DOWN;
  gout[7 + 7] = ( $P$whenCondition8 ) ? ROOT_UP : ROOT_DOWN;
  gout[8 + 7] = ( $P$whenCondition9 ) ? ROOT_UP : ROOT_DOWN;
}

void ModelMACHINE_PQ_Dyn::setY0omc()
{
    $PMACHINE$PomegaRefPu$Pvalue = 0.0;
    $PMACHINE$Pterminal$PV$Pim = $PMACHINE$Pu0Pu$Pim;
    $PMACHINE$Pterminal$PV$Pre = $PMACHINE$Pu0Pu$Pre;
    $PMACHINE$Pterminal$Pi$Pim = $PMACHINE$Pi0Pu$Pim;
    $PMACHINE$Pterminal$Pi$Pre = $PMACHINE$Pi0Pu$Pre;
    $PMACHINE$Prunning$Pvalue = fromNativeBool ( true);
    $PMACHINE$PswitchOffSignal1$Pvalue = fromNativeBool ( false);
    $PMACHINE$PswitchOffSignal2$Pvalue = fromNativeBool ( false);
    $PMACHINE$PswitchOffSignal3$Pvalue = fromNativeBool ( false);
    $PMACHINE$PpStatus = 1;
    $PMACHINE$PqStatus = 1;
    $PMACHINE$Pstate = 2;
    $PMACHINE$PUPu = $PMACHINE$PU0Pu;
    $PMACHINE$PPGenRawPu = $PMACHINE$PPGen0Pu;
    $PMACHINE$PPGenPu = $PMACHINE$PPGen0Pu;
    $PMACHINE$PSGenPu$Pre = $PMACHINE$PPGen0Pu;
    $PMACHINE$PQGenPu = $PMACHINE$PQGen0Pu;
    $PMACHINE$PSGenPu$Pim = $PMACHINE$PQGen0Pu;
}

void ModelMACHINE_PQ_Dyn::setYType_omc(propertyContinuousVar_t* yType)
{
   yType[ 0 ] = EXTERNAL;   /* MACHINE_omegaRefPu_value (rSta) - external variables */
   yType[ 1 ] = EXTERNAL;   /* MACHINE_terminal_V_im (rSta) - external variables */
   yType[ 2 ] = EXTERNAL;   /* MACHINE_terminal_V_re (rSta) - external variables */
   yType[ 3 ] = ALGEBRIC;   /* MACHINE_PGenPu (rAlg)  */
   yType[ 4 ] = ALGEBRIC;   /* MACHINE_PGenRawPu (rAlg)  */
   yType[ 5 ] = ALGEBRIC;   /* MACHINE_QGenPu (rAlg)  */
   yType[ 6 ] = ALGEBRIC;   /* MACHINE_SGenPu_im (rAlg)  */
   yType[ 7 ] = ALGEBRIC;   /* MACHINE_SGenPu_re (rAlg)  */
   yType[ 8 ] = ALGEBRIC;   /* MACHINE_UPu (rAlg)  */
   yType[ 9 ] = ALGEBRIC;   /* MACHINE_terminal_i_im (rAlg)  */
   yType[ 10 ] = ALGEBRIC;   /* MACHINE_terminal_i_re (rAlg)  */
}

void ModelMACHINE_PQ_Dyn::setFType_omc(propertyF_t* fType)
{
   fType[ 0 ] = ALGEBRIC_EQ;
   fType[ 1 ] = ALGEBRIC_EQ;
   fType[ 2 ] = ALGEBRIC_EQ;
   fType[ 3 ] = ALGEBRIC_EQ;
   fType[ 4 ] = ALGEBRIC_EQ;
   fType[ 5 ] = ALGEBRIC_EQ;
   fType[ 6 ] = ALGEBRIC_EQ;
   fType[ 7 ] = ALGEBRIC_EQ;
}

boost::shared_ptr<parameters::ParametersSet> ModelMACHINE_PQ_Dyn::setSharedParametersDefaultValues()
{

   // Propagating shared parameters default value 

   // This value may be updated later on through *.par/*.iidm data 
  boost::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newInstance("SharedModelicaParameters");
  int $PMACHINE$PNbSwitchOffSignals_internal;
  int $PMACHINE$PState0_internal;

  $PMACHINE$PNbSwitchOffSignals_internal = 3; 
  parametersSet->createParameter("MACHINE_NbSwitchOffSignals", $PMACHINE$PNbSwitchOffSignals_internal);
  $PMACHINE$PState0_internal = 2; 
  parametersSet->createParameter("MACHINE_State0", $PMACHINE$PState0_internal);
  return parametersSet;
}

void ModelMACHINE_PQ_Dyn::setParameters( boost::shared_ptr<parameters::ParametersSet> params )
{
  MACHINE_AlphaPu_ = params->getParameter("MACHINE_AlphaPu")->getDouble();
  MACHINE_PGen0Pu_ = params->getParameter("MACHINE_PGen0Pu")->getDouble();
  MACHINE_PMaxPu_ = params->getParameter("MACHINE_PMaxPu")->getDouble();
  MACHINE_PMinPu_ = params->getParameter("MACHINE_PMinPu")->getDouble();
  MACHINE_QGen0Pu_ = params->getParameter("MACHINE_QGen0Pu")->getDouble();
  MACHINE_QMaxPu_ = params->getParameter("MACHINE_QMaxPu")->getDouble();
  MACHINE_QMinPu_ = params->getParameter("MACHINE_QMinPu")->getDouble();
  MACHINE_U0Pu_ = params->getParameter("MACHINE_U0Pu")->getDouble();
  MACHINE_UMaxPu_ = params->getParameter("MACHINE_UMaxPu")->getDouble();
  MACHINE_UMinPu_ = params->getParameter("MACHINE_UMinPu")->getDouble();
  MACHINE_i0Pu_im_ = params->getParameter("MACHINE_i0Pu_im")->getDouble();
  MACHINE_i0Pu_re_ = params->getParameter("MACHINE_i0Pu_re")->getDouble();
  MACHINE_u0Pu_im_ = params->getParameter("MACHINE_u0Pu_im")->getDouble();
  MACHINE_u0Pu_re_ = params->getParameter("MACHINE_u0Pu_re")->getDouble();
  MACHINE_NbSwitchOffSignals_ = params->getParameter("MACHINE_NbSwitchOffSignals")->getInt();
  MACHINE_State0_ = params->getParameter("MACHINE_State0")->getInt();
}

void ModelMACHINE_PQ_Dyn::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables)
{
  variables.push_back (VariableNativeFactory::createState ("MACHINE_omegaRefPu_value", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_terminal_V_im", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_terminal_V_re", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_PGenPu", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_PGenRawPu", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_QGenPu", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_SGenPu_im", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_SGenPu_re", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_UPu", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_terminal_i_im", FLOW, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_terminal_i_re", FLOW, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_pStatus", INTEGER, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_qStatus", INTEGER, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_state", INTEGER, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_running_value", BOOLEAN, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_switchOffSignal1_value", BOOLEAN, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_switchOffSignal2_value", BOOLEAN, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_switchOffSignal3_value", BOOLEAN, false));
}

void ModelMACHINE_PQ_Dyn::defineParameters(std::vector<ParameterModeler>& parameters)
{
  parameters.push_back(ParameterModeler("MACHINE_AlphaPu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("MACHINE_PGen0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("MACHINE_PMaxPu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("MACHINE_PMinPu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("MACHINE_QGen0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("MACHINE_QMaxPu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("MACHINE_QMinPu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("MACHINE_U0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("MACHINE_UMaxPu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("MACHINE_UMinPu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("MACHINE_i0Pu_im", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("MACHINE_i0Pu_re", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("MACHINE_u0Pu_im", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("MACHINE_u0Pu_re", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("MACHINE_NbSwitchOffSignals", VAR_TYPE_INT, SHARED_PARAMETER));
  parameters.push_back(ParameterModeler("MACHINE_State0", VAR_TYPE_INT, SHARED_PARAMETER));
}

void ModelMACHINE_PQ_Dyn::defineElements(std::vector<Element>& elements, std::map<std::string, int >& mapElement)
{
  elements.push_back(Element("MACHINE","MACHINE",Element::STRUCTURE));
  elements.push_back(Element("switchOffSignal3","MACHINE_switchOffSignal3",Element::STRUCTURE));
  elements.push_back(Element("value","MACHINE_switchOffSignal3_value",Element::TERMINAL));
  elements.push_back(Element("switchOffSignal2","MACHINE_switchOffSignal2",Element::STRUCTURE));
  elements.push_back(Element("value","MACHINE_switchOffSignal2_value",Element::TERMINAL));
  elements.push_back(Element("omegaRefPu","MACHINE_omegaRefPu",Element::STRUCTURE));
  elements.push_back(Element("value","MACHINE_omegaRefPu_value",Element::TERMINAL));
  elements.push_back(Element("terminal","MACHINE_terminal",Element::STRUCTURE));
  elements.push_back(Element("i","MACHINE_terminal_i",Element::STRUCTURE));
  elements.push_back(Element("im","MACHINE_terminal_i_im",Element::TERMINAL));
  elements.push_back(Element("re","MACHINE_terminal_i_re",Element::TERMINAL));
  elements.push_back(Element("running","MACHINE_running",Element::STRUCTURE));
  elements.push_back(Element("value","MACHINE_running_value",Element::TERMINAL));
  elements.push_back(Element("switchOffSignal1","MACHINE_switchOffSignal1",Element::STRUCTURE));
  elements.push_back(Element("value","MACHINE_switchOffSignal1_value",Element::TERMINAL));
  elements.push_back(Element("qStatus","MACHINE_qStatus",Element::TERMINAL));
  elements.push_back(Element("pStatus","MACHINE_pStatus",Element::TERMINAL));
  elements.push_back(Element("PGenRawPu","MACHINE_PGenRawPu",Element::TERMINAL));
  elements.push_back(Element("UPu","MACHINE_UPu",Element::TERMINAL));
  elements.push_back(Element("QGenPu","MACHINE_QGenPu",Element::TERMINAL));
  elements.push_back(Element("PGenPu","MACHINE_PGenPu",Element::TERMINAL));
  elements.push_back(Element("SGenPu","MACHINE_SGenPu",Element::STRUCTURE));
  elements.push_back(Element("im","MACHINE_SGenPu_im",Element::TERMINAL));
  elements.push_back(Element("re","MACHINE_SGenPu_re",Element::TERMINAL));
  elements.push_back(Element("V","MACHINE_terminal_V",Element::STRUCTURE));
  elements.push_back(Element("im","MACHINE_terminal_V_im",Element::TERMINAL));
  elements.push_back(Element("re","MACHINE_terminal_V_re",Element::TERMINAL));
  elements.push_back(Element("state","MACHINE_state",Element::TERMINAL));

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

  mapElement["MACHINE"] = 0;
  mapElement["MACHINE_switchOffSignal3"] = 1;
  mapElement["MACHINE_switchOffSignal3_value"] = 2;
  mapElement["MACHINE_switchOffSignal2"] = 3;
  mapElement["MACHINE_switchOffSignal2_value"] = 4;
  mapElement["MACHINE_omegaRefPu"] = 5;
  mapElement["MACHINE_omegaRefPu_value"] = 6;
  mapElement["MACHINE_terminal"] = 7;
  mapElement["MACHINE_terminal_i"] = 8;
  mapElement["MACHINE_terminal_i_im"] = 9;
  mapElement["MACHINE_terminal_i_re"] = 10;
  mapElement["MACHINE_running"] = 11;
  mapElement["MACHINE_running_value"] = 12;
  mapElement["MACHINE_switchOffSignal1"] = 13;
  mapElement["MACHINE_switchOffSignal1_value"] = 14;
  mapElement["MACHINE_qStatus"] = 15;
  mapElement["MACHINE_pStatus"] = 16;
  mapElement["MACHINE_PGenRawPu"] = 17;
  mapElement["MACHINE_UPu"] = 18;
  mapElement["MACHINE_QGenPu"] = 19;
  mapElement["MACHINE_PGenPu"] = 20;
  mapElement["MACHINE_SGenPu"] = 21;
  mapElement["MACHINE_SGenPu_im"] = 22;
  mapElement["MACHINE_SGenPu_re"] = 23;
  mapElement["MACHINE_terminal_V"] = 24;
  mapElement["MACHINE_terminal_V_im"] = 25;
  mapElement["MACHINE_terminal_V_re"] = 26;
  mapElement["MACHINE_state"] = 27;
}

#ifdef _ADEPT_
void ModelMACHINE_PQ_Dyn::evalFAdept(const std::vector<adept::adouble> & x,
                              const std::vector<adept::adouble> & xd,
                              std::vector<adept::adouble> & res)
{
  /*
    MACHINE_omegaRefPu_value : x[0]
    MACHINE_terminal_V_im : x[1]
    MACHINE_terminal_V_re : x[2]
    MACHINE_PGenPu : x[3]
    MACHINE_PGenRawPu : x[4]
    MACHINE_QGenPu : x[5]
    MACHINE_SGenPu_im : x[6]
    MACHINE_SGenPu_re : x[7]
    MACHINE_UPu : x[8]
    MACHINE_terminal_i_im : x[9]
    MACHINE_terminal_i_re : x[10]
    der(MACHINE_omegaRefPu_value) : xd[0]
    der(MACHINE_terminal_V_im) : xd[1]
    der(MACHINE_terminal_V_re) : xd[2]

  */
  // ----- MACHINE_PQ_eqFunction_49 -----
  modelica_boolean tmp29;
  adept::adouble tmp30;
  tmp29 = (modelica_boolean)(toNativeBool ($PMACHINE$Prunning$Pvalue));
  if(tmp29)
  {
    tmp30 = $PMACHINE$PPGen0Pu + ($PMACHINE$PAlphaPu) * (1.0 - x[0]);
  }
  else
  {
    tmp30 = 0.0;
  }
  res[0] = x[4] - ( tmp30 );


  // ----- MACHINE_PQ_eqFunction_58 -----
  modelica_boolean tmp41;
  adept::adouble tmp42;
  modelica_boolean tmp43;
  adept::adouble tmp44;
  modelica_boolean tmp45;
  adept::adouble tmp46;
  tmp45 = (modelica_boolean)(toNativeBool ($PMACHINE$Prunning$Pvalue));
  if(tmp45)
  {
    tmp43 = (modelica_boolean)((modelica_integer)$PMACHINE$PpStatus == 3);
    if(tmp43)
    {
      tmp44 = $PMACHINE$PPMaxPu;
    }
    else
    {
      tmp41 = (modelica_boolean)((modelica_integer)$PMACHINE$PpStatus == 2);
      if(tmp41)
      {
        tmp42 = $PMACHINE$PPMinPu;
      }
      else
      {
        tmp42 = x[4];
      }
      tmp44 = tmp42;
    }
    tmp46 = tmp44;
  }
  else
  {
    tmp46 = 0.0;
  }
  res[1] = x[3] - ( tmp46 );


  // ----- MACHINE_PQ_eqFunction_59 -----
  adept::adouble tmp47;
  adept::adouble tmp48;
  adept::adouble tmp49;
  tmp47 = x[2];
  tmp48 = x[1];
  res[2] = x[8] - ( sqrt((tmp47 * tmp47) + (tmp48 * tmp48)) );


  // ----- MACHINE_PQ_eqFunction_66 -----
  res[3] = x[7] - ( x[3] );


  // ----- MACHINE_PQ_eqFunction_67 -----
  modelica_boolean tmp60;
  adept::adouble tmp61;
  modelica_boolean tmp62;
  adept::adouble tmp63;
  modelica_boolean tmp64;
  adept::adouble tmp65;
  tmp64 = (modelica_boolean)(toNativeBool ($PMACHINE$Prunning$Pvalue));
  if(tmp64)
  {
    tmp62 = (modelica_boolean)($P$PRE$PMACHINE$PqStatus == 2);
    if(tmp62)
    {
      tmp63 = $PMACHINE$PQMaxPu;
    }
    else
    {
      tmp60 = (modelica_boolean)($P$PRE$PMACHINE$PqStatus == 3);
      if(tmp60)
      {
        tmp61 = $PMACHINE$PQMinPu;
      }
      else
      {
        tmp61 = $PMACHINE$PQGen0Pu;
      }
      tmp63 = tmp61;
    }
    tmp65 = tmp63;
  }
  else
  {
    tmp65 = 0.0;
  }
  res[4] = x[5] - ( tmp65 );


  // ----- MACHINE_PQ_eqFunction_68 -----
  res[5] = x[6] - ( x[5] );


  // ----- setLinearMatrixA69 -----
  res[6] = ((-x[2]))*(x[9]) + (x[1])*(x[10]) - ( (-x[6]) );

  // ----- setLinearMatrixA69 -----
  res[7] = (x[1])*(x[9]) + (x[2])*(x[10]) - ( (-x[7]) );

}
#endif

void ModelMACHINE_PQ_Dyn::checkDataCoherence()
{
{
  modelica_boolean tmp0;
  modelica_boolean tmp1;
  const modelica_string   tmp2 = "Variable MACHINE.NbSwitchOffSignals out of [min max] interval: MACHINE.NbSwitchOffSignals >= 1 and MACHINE.NbSwitchOffSignals <= 3 has value: ";
  modelica_string tmp3;
  static int tmp4 = 0;
 modelica_string tmpMeta[1];
  if(!tmp4)
  {
    tmp0 = GreaterEq((modelica_integer)$PMACHINE$PNbSwitchOffSignals,((modelica_integer) 1));
    tmp1 = LessEq((modelica_integer)$PMACHINE$PNbSwitchOffSignals,((modelica_integer) 3));
    if(!(tmp0 && tmp1))
    {
      tmp3 = modelica_integer_to_modelica_string_format((modelica_integer)$PMACHINE$PNbSwitchOffSignals, mmc_strings_len1(100));
      tmpMeta[0] = stringAppend((tmp2),tmp3);
      {
        omc_assert_warning("The following assertion has been violated %sat time %f\nMACHINE.NbSwitchOffSignals >= 1 and MACHINE.NbSwitchOffSignals <= 3", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(equationIndexes, (tmpMeta[0]));
      }
      tmp4 = 1;
    }
  }


}
{
  modelica_boolean tmp5;
  modelica_boolean tmp6;
  const modelica_string   tmp7 = "Variable MACHINE.State0 out of [min max] interval: MACHINE.State0 >= Dynawo.Electrical.Constants.state.OPEN and MACHINE.State0 <= Dynawo.Electrical.Constants.state.UNDEFINED has value: ";
  modelica_string tmp8;
  static int tmp9 = 0;
 modelica_string tmpMeta[1];
  if(!tmp9)
  {
    tmp5 = GreaterEq((modelica_integer)$PMACHINE$PState0,1);
    tmp6 = LessEq((modelica_integer)$PMACHINE$PState0,6);
    if(!(tmp5 && tmp6))
    {
      tmp8 = modelica_integer_to_modelica_string_format((modelica_integer)$PMACHINE$PState0, mmc_strings_len1(100));
      tmpMeta[0] = stringAppend((tmp7),tmp8);
      {
        omc_assert_warning("The following assertion has been violated %sat time %f\nMACHINE.State0 >= Dynawo.Electrical.Constants.state.OPEN and MACHINE.State0 <= Dynawo.Electrical.Constants.state.UNDEFINED", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(equationIndexes, (tmpMeta[0]));
      }
      tmp9 = 1;
    }
  }


}
}

void ModelMACHINE_PQ_Dyn::setFequations(std::map<int,std::string>& fEquationIndex)
{
  //Note: fictive equations are not added. fEquationIndex.size() = sizeF() - Nunmber of fictive equations.
  fEquationIndex[0] = "MACHINE._PGenRawPu = if MACHINE.running.value then MACHINE.PGen0Pu + MACHINE.AlphaPu * (1.0 - MACHINE.omegaRefPu.value) else 0.0";//equation_index_omc:49
  fEquationIndex[1] = "MACHINE._PGenPu = if MACHINE.running.value then if MACHINE.pStatus == Dynawo.Electrical.Machines.GeneratorPQ.PStatus.limitPMax then MACHINE.PMaxPu else if MACHINE.pStatus == Dynawo.Electrical.Machines.GeneratorPQ.PStatus.limitPMin then MACHINE.PMinPu else MACHINE.PGenRawPu else 0.0";//equation_index_omc:58
  fEquationIndex[2] = "MACHINE._UPu = (MACHINE.terminal.V.re ^ 2.0 + MACHINE.terminal.V.im ^ 2.0) ^ 0.5";//equation_index_omc:59
  fEquationIndex[3] = "MACHINE._SGenPu._re = MACHINE.PGenPu";//equation_index_omc:66
  fEquationIndex[4] = "MACHINE._QGenPu = if MACHINE.running.value then if pre(MACHINE.qStatus) == Dynawo.Electrical.Machines.GeneratorPQ.QStatus.absorptionMax then MACHINE.QMaxPu else if pre(MACHINE.qStatus) == Dynawo.Electrical.Machines.GeneratorPQ.QStatus.generationMax then MACHINE.QMinPu else MACHINE.QGen0Pu else 0.0";//equation_index_omc:67
  fEquationIndex[5] = "MACHINE._SGenPu._im = MACHINE.QGenPu";//equation_index_omc:68
  fEquationIndex[6] = "<equations> <var>MACHINE._terminal._i._im</var> <var>MACHINE._terminal._i._re</var> <row> <cell>-MACHINE.SGenPu.im</cell> <cell>-MACHINE.SGenPu.re</cell> </row> <matrix> <cell row='0' col='0'> <residual>-MACHINE.terminal.V.re</residual> </cell><cell row='0' col='1'> <residual>MACHINE.terminal.V.im</residual> </cell><cell row='1' col='0'> <residual>MACHINE.terminal.V.im</residual> </cell><cell row='1' col='1'> <residual>MACHINE.terminal.V.re</residual> </cell> </matrix> </equations>";//equation_index_omc:69
  fEquationIndex[7] = "<equations> <var>MACHINE._terminal._i._im</var> <var>MACHINE._terminal._i._re</var> <row> <cell>-MACHINE.SGenPu.im</cell> <cell>-MACHINE.SGenPu.re</cell> </row> <matrix> <cell row='0' col='0'> <residual>-MACHINE.terminal.V.re</residual> </cell><cell row='0' col='1'> <residual>MACHINE.terminal.V.im</residual> </cell><cell row='1' col='0'> <residual>MACHINE.terminal.V.im</residual> </cell><cell row='1' col='1'> <residual>MACHINE.terminal.V.re</residual> </cell> </matrix> </equations>";//equation_index_omc:69
}

void ModelMACHINE_PQ_Dyn::setGequations(std::map<int,std::string>& gEquationIndex)
{
// ---------------- boolean conditions -------------
  static const char *res[] = {  "MACHINE.PGenRawPu >= MACHINE.PMaxPu and pre(MACHINE.pStatus) <> Dynawo.Electrical.Machines.GeneratorPQ.PStatus.limitPMax",
  "MACHINE.PGenRawPu <= MACHINE.PMinPu and pre(MACHINE.pStatus) <> Dynawo.Electrical.Machines.GeneratorPQ.PStatus.limitPMin",
  "MACHINE.PGenRawPu > MACHINE.PMinPu and pre(MACHINE.pStatus) == Dynawo.Electrical.Machines.GeneratorPQ.PStatus.limitPMin",
  "MACHINE.PGenRawPu < MACHINE.PMaxPu and pre(MACHINE.pStatus) == Dynawo.Electrical.Machines.GeneratorPQ.PStatus.limitPMax",
  "MACHINE.UPu >= 0.0001 + MACHINE.UMaxPu and pre(MACHINE.qStatus) <> Dynawo.Electrical.Machines.GeneratorPQ.QStatus.absorptionMax",
  "MACHINE.UPu <= -0.0001 + MACHINE.UMinPu and pre(MACHINE.qStatus) <> Dynawo.Electrical.Machines.GeneratorPQ.QStatus.generationMax",
  "MACHINE.UPu < -0.0001 + MACHINE.UMaxPu and pre(MACHINE.qStatus) == Dynawo.Electrical.Machines.GeneratorPQ.QStatus.absorptionMax or MACHINE.UPu > 0.0001 + MACHINE.UMinPu and pre(MACHINE.qStatus) == Dynawo.Electrical.Machines.GeneratorPQ.QStatus.generationMax"};
  gEquationIndex[0] =  res[0]  ;
  gEquationIndex[1] =  res[1]  ;
  gEquationIndex[2] =  res[2]  ;
  gEquationIndex[3] =  res[3]  ;
  gEquationIndex[4] =  res[4]  ;
  gEquationIndex[5] =  res[5]  ;
  gEquationIndex[6] =  res[6]  ;
// -----------------------------
  // ------------- $whenCondition10 ------------
  gEquationIndex[0 + 7] = " $whenCondition10:  modelica_boolean tmp50;  RELATIONHYSTERESIS(tmp50, $PMACHINE$PUPu, 0.0001 + $PMACHINE$PUMaxPu, 5, GreaterEq);  $P$whenCondition10 = (tmp50 && ($P$PRE$PMACHINE$PqStatus != 2)); " ;
 
  // ------------- $whenCondition2 ------------
  gEquationIndex[1 + 7] = " $whenCondition2:  modelica_boolean tmp37;  RELATIONHYSTERESIS(tmp37, $PMACHINE$PPGenRawPu, $PMACHINE$PPMaxPu, 4, Less);  $P$whenCondition2 = (tmp37 && ($P$PRE$PMACHINE$PpStatus == 3)); " ;
 
  // ------------- $whenCondition3 ------------
  gEquationIndex[2 + 7] = " $whenCondition3:  modelica_boolean tmp35;  RELATIONHYSTERESIS(tmp35, $PMACHINE$PPGenRawPu, $PMACHINE$PPMinPu, 3, Greater);  $P$whenCondition3 = (tmp35 && ($P$PRE$PMACHINE$PpStatus == 2)); " ;
 
  // ------------- $whenCondition4 ------------
  gEquationIndex[3 + 7] = " $whenCondition4:  modelica_boolean tmp33;  RELATIONHYSTERESIS(tmp33, $PMACHINE$PPGenRawPu, $PMACHINE$PPMinPu, 2, LessEq);  $P$whenCondition4 = (tmp33 && ($P$PRE$PMACHINE$PpStatus != 2)); " ;
 
  // ------------- $whenCondition5 ------------
  gEquationIndex[4 + 7] = " $whenCondition5:  modelica_boolean tmp31;  RELATIONHYSTERESIS(tmp31, $PMACHINE$PPGenRawPu, $PMACHINE$PPMaxPu, 1, GreaterEq);  $P$whenCondition5 = (tmp31 && ($P$PRE$PMACHINE$PpStatus != 3)); " ;
 
  // ------------- $whenCondition6 ------------
  gEquationIndex[5 + 7] = " $whenCondition6:  $P$whenCondition6 = (((toNativeBool ($PMACHINE$PswitchOffSignal1$Pvalue)) || (toNativeBool ($PMACHINE$PswitchOffSignal2$Pvalue))) || ((toNativeBool ($PMACHINE$PswitchOffSignal3$Pvalue)) && (toNativeBool ($P$PRE$PMACHINE$Prunning$Pvalue)))); " ;
 
  // ------------- $whenCondition7 ------------
  gEquationIndex[6 + 7] = " $whenCondition7:  $P$whenCondition7 = (!(toNativeBool ($PMACHINE$Prunning$Pvalue))); " ;
 
  // ------------- $whenCondition8 ------------
  gEquationIndex[7 + 7] = " $whenCondition8:  modelica_boolean tmp54;  modelica_boolean tmp56;  RELATIONHYSTERESIS(tmp54, $PMACHINE$PUPu, -0.0001 + $PMACHINE$PUMaxPu, 7, Less);  RELATIONHYSTERESIS(tmp56, $PMACHINE$PUPu, 0.0001 + $PMACHINE$PUMinPu, 8, Greater);  $P$whenCondition8 = ((tmp54 && ($P$PRE$PMACHINE$PqStatus == 2)) || (tmp56 && ($P$PRE$PMACHINE$PqStatus == 3))); " ;
 
  // ------------- $whenCondition9 ------------
  gEquationIndex[8 + 7] = " $whenCondition9:  modelica_boolean tmp52;  RELATIONHYSTERESIS(tmp52, $PMACHINE$PUPu, -0.0001 + $PMACHINE$PUMinPu, 6, LessEq);  $P$whenCondition9 = (tmp52 && ($P$PRE$PMACHINE$PqStatus != 3)); " ;
 
}

}