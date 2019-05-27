#include <limits>
#include <cassert>
#include <set>
#include <string>
#include <vector>
#include <math.h>

#include "DYNElement.h"

#include "MACHINE_PQ_Init.h"
#include "MACHINE_PQ_Init_definition.h"
#include "MACHINE_PQ_Init_literal.h"


namespace DYN {


void ModelMACHINE_PQ_Init::initData(DYNDATA *d)
{
  setData(d);
  setupDataStruc();
  initializeDataStruc();
}

void ModelMACHINE_PQ_Init::setupDataStruc()
{

  data->modelData = (MODEL_DATA *)calloc(1,sizeof(MODEL_DATA));
  data->simulationInfo = (SIMULATION_INFO *)calloc(1,sizeof(SIMULATION_INFO));
  data->nbDummy = 0;
  data->modelData->nStates = 0;
  data->modelData->nVariablesReal = 0+8+0 + 0;
  data->modelData->nDiscreteReal = 0;
  data->modelData->nVariablesInteger = 0;
  data->modelData->nVariablesBoolean = 0;
  data->modelData->nVariablesString = 0;
  data->modelData->nParametersReal = 4;
  data->modelData->nParametersInteger = 0;
  data->modelData->nParametersBoolean = 0;
  data->modelData->nParametersString = 0;
  data->modelData->nInputVars = 0;
  data->modelData->nOutputVars = 0;
  data->modelData->nAliasReal = 0;
  data->modelData->nAliasInteger = 0;
  data->modelData->nAliasBoolean = 0;
  data->modelData->nAliasString = 0;
  data->modelData->nZeroCrossings = 0 + 0;
  data->modelData->nSamples = 0;
  data->modelData->nRelations = 0;
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

  data->nbVars =8;
  data->nbF = 8;
  data->nbModes = 0; 
  data->nbZ = 0;
}

void ModelMACHINE_PQ_Init::initializeDataStruc()
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

void ModelMACHINE_PQ_Init::deInitializeDataStruc()
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

void ModelMACHINE_PQ_Init::initRpar()
{
  /* Setting shared and external parameters */
  $PMACHINE$PP0Pu = MACHINE_P0Pu_;
  $PMACHINE$PQ0Pu = MACHINE_Q0Pu_;
  $PMACHINE$PU0Pu = MACHINE_U0Pu_;
  $PMACHINE$PUPhase0 = MACHINE_UPhase0_;

  // Setting internal parameters 

  return;
}

void ModelMACHINE_PQ_Init::setFomc(double * f)
{
  // ----- MACHINE_PQ_INIT_eqFunction_8 -----
  f[0] = $PMACHINE$Ps0Pu$Pim - ( $PMACHINE$PQ0Pu );


  // ----- MACHINE_PQ_INIT_eqFunction_9 -----
  f[1] = $PMACHINE$Ps0Pu$Pre - ( $PMACHINE$PP0Pu );


  // ----- MACHINE_PQ_INIT_eqFunction_10 -----
  f[2] = $PMACHINE$Pu0Pu$Pre - ( ($PMACHINE$PU0Pu) * (cos($PMACHINE$PUPhase0)) );


  // ----- MACHINE_PQ_INIT_eqFunction_11 -----
  f[3] = $PMACHINE$Pu0Pu$Pim - ( ($PMACHINE$PU0Pu) * (sin($PMACHINE$PUPhase0)) );


  // ----- setLinearMatrixA12 -----
  f[4] = ((-$PMACHINE$Pu0Pu$Pim))*($PMACHINE$Pi0Pu$Pre) + ($PMACHINE$Pu0Pu$Pre)*($PMACHINE$Pi0Pu$Pim) - ( (-$PMACHINE$Ps0Pu$Pim) );

  // ----- setLinearMatrixA12 -----
  f[5] = ((-$PMACHINE$Pu0Pu$Pre))*($PMACHINE$Pi0Pu$Pre) + ((-$PMACHINE$Pu0Pu$Pim))*($PMACHINE$Pi0Pu$Pim) - ( (-$PMACHINE$Ps0Pu$Pre) );

  // ----- MACHINE_PQ_INIT_eqFunction_13 -----
  f[6] = $PMACHINE$PPGen0Pu - ( (-$PMACHINE$PP0Pu) );


  // ----- MACHINE_PQ_INIT_eqFunction_14 -----
  f[7] = $PMACHINE$PQGen0Pu - ( (-$PMACHINE$PQ0Pu) );


}

bool ModelMACHINE_PQ_Init::evalMode(const double & t) const
{
  // modes may either be due to
  // - a change in network topology (currently forbidden for Modelica models)
  // - a Modelica reinit command
  // no mode triggered => return false
  return false;
}

void ModelMACHINE_PQ_Init::setGomc(state_g * gout)
{
  
  
  
}

void ModelMACHINE_PQ_Init::setZomc()
{
}

void ModelMACHINE_PQ_Init::setY0omc()
{
    $PMACHINE$Pi0Pu$Pim = 0.0;
    $PMACHINE$Pi0Pu$Pre = 0.0;
  {
    $PMACHINE$Pu0Pu$Pim = ($PMACHINE$PU0Pu) * (sin($PMACHINE$PUPhase0));
  }
  {
    $PMACHINE$Pu0Pu$Pre = ($PMACHINE$PU0Pu) * (cos($PMACHINE$PUPhase0));
  }
  {
    $PMACHINE$Ps0Pu$Pre = $PMACHINE$PP0Pu;
  }
  {
    $PMACHINE$Ps0Pu$Pim = $PMACHINE$PQ0Pu;
  }
  {
    $PMACHINE$PPGen0Pu = (-$PMACHINE$PP0Pu);
  }
  {
    $PMACHINE$PQGen0Pu = (-$PMACHINE$PQ0Pu);
  }
}

boost::shared_ptr<parameters::ParametersSet> ModelMACHINE_PQ_Init::setSharedParametersDefaultValues()
{

   // Propagating shared parameters default value 

   // This value may be updated later on through *.par/*.iidm data 
  boost::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newInstance("SharedModelicaParameters");

  return parametersSet;
}

void ModelMACHINE_PQ_Init::setParameters( boost::shared_ptr<parameters::ParametersSet> params )
{
  MACHINE_P0Pu_ = params->getParameter("MACHINE_P0Pu")->getDouble();
  MACHINE_Q0Pu_ = params->getParameter("MACHINE_Q0Pu")->getDouble();
  MACHINE_U0Pu_ = params->getParameter("MACHINE_U0Pu")->getDouble();
  MACHINE_UPhase0_ = params->getParameter("MACHINE_UPhase0")->getDouble();
}

void ModelMACHINE_PQ_Init::defineElements(std::vector<Element>& elements, std::map<std::string, int >& mapElement)
{


}

void ModelMACHINE_PQ_Init::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables)
{
  variables.push_back (VariableNativeFactory::createState ("MACHINE_PGen0Pu", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_QGen0Pu", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_i0Pu_im", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_i0Pu_re", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_s0Pu_im", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_s0Pu_re", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_u0Pu_im", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("MACHINE_u0Pu_re", CONTINUOUS, false));
}

void ModelMACHINE_PQ_Init::defineParameters(std::vector<ParameterModeler>& parameters)
{
  parameters.push_back(ParameterModeler("MACHINE_P0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("MACHINE_Q0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("MACHINE_U0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("MACHINE_UPhase0", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
}

#ifdef _ADEPT_
void ModelMACHINE_PQ_Init::evalFAdept(const std::vector<adept::adouble> & x,
                              const std::vector<adept::adouble> & xd,
                              std::vector<adept::adouble> & res)
{
  /*
    MACHINE_PGen0Pu : x[0]
    MACHINE_QGen0Pu : x[1]
    MACHINE_i0Pu_im : x[2]
    MACHINE_i0Pu_re : x[3]
    MACHINE_s0Pu_im : x[4]
    MACHINE_s0Pu_re : x[5]
    MACHINE_u0Pu_im : x[6]
    MACHINE_u0Pu_re : x[7]

  */
  // ----- MACHINE_PQ_INIT_eqFunction_8 -----
  res[0] = x[4] - ( $PMACHINE$PQ0Pu );


  // ----- MACHINE_PQ_INIT_eqFunction_9 -----
  res[1] = x[5] - ( $PMACHINE$PP0Pu );


  // ----- MACHINE_PQ_INIT_eqFunction_10 -----
  res[2] = x[7] - ( ($PMACHINE$PU0Pu) * (cos($PMACHINE$PUPhase0)) );


  // ----- MACHINE_PQ_INIT_eqFunction_11 -----
  res[3] = x[6] - ( ($PMACHINE$PU0Pu) * (sin($PMACHINE$PUPhase0)) );


  // ----- setLinearMatrixA12 -----
  res[4] = ((-x[6]))*(x[3]) + (x[7])*(x[2]) - ( (-x[4]) );

  // ----- setLinearMatrixA12 -----
  res[5] = ((-x[7]))*(x[3]) + ((-x[6]))*(x[2]) - ( (-x[5]) );

  // ----- MACHINE_PQ_INIT_eqFunction_13 -----
  res[6] = x[0] - ( (-$PMACHINE$PP0Pu) );


  // ----- MACHINE_PQ_INIT_eqFunction_14 -----
  res[7] = x[1] - ( (-$PMACHINE$PQ0Pu) );


}
#endif

void ModelMACHINE_PQ_Init::checkDataCoherence()
{
}

void ModelMACHINE_PQ_Init::setFequations(std::map<int,std::string>& fEquationIndex)
{
  //Note: fictive equations are not added. fEquationIndex.size() = sizeF() - Nunmber of fictive equations.
  fEquationIndex[0] = "MACHINE._s0Pu._im = MACHINE.Q0Pu";//equation_index_omc:8
  fEquationIndex[1] = "MACHINE._s0Pu._re = MACHINE.P0Pu";//equation_index_omc:9
  fEquationIndex[2] = "MACHINE._u0Pu._re = MACHINE.U0Pu * cos(MACHINE.UPhase0)";//equation_index_omc:10
  fEquationIndex[3] = "MACHINE._u0Pu._im = MACHINE.U0Pu * sin(MACHINE.UPhase0)";//equation_index_omc:11
  fEquationIndex[4] = "<equations> <var>MACHINE._i0Pu._re</var> <var>MACHINE._i0Pu._im</var> <row> <cell>-MACHINE.s0Pu.re</cell> <cell>-MACHINE.s0Pu.im</cell> </row> <matrix> <cell row='0' col='0'> <residual>-MACHINE.u0Pu.re</residual> </cell><cell row='0' col='1'> <residual>-MACHINE.u0Pu.im</residual> </cell><cell row='1' col='0'> <residual>-MACHINE.u0Pu.im</residual> </cell><cell row='1' col='1'> <residual>MACHINE.u0Pu.re</residual> </cell> </matrix> </equations>";//equation_index_omc:12
  fEquationIndex[5] = "<equations> <var>MACHINE._i0Pu._re</var> <var>MACHINE._i0Pu._im</var> <row> <cell>-MACHINE.s0Pu.re</cell> <cell>-MACHINE.s0Pu.im</cell> </row> <matrix> <cell row='0' col='0'> <residual>-MACHINE.u0Pu.re</residual> </cell><cell row='0' col='1'> <residual>-MACHINE.u0Pu.im</residual> </cell><cell row='1' col='0'> <residual>-MACHINE.u0Pu.im</residual> </cell><cell row='1' col='1'> <residual>MACHINE.u0Pu.re</residual> </cell> </matrix> </equations>";//equation_index_omc:12
  fEquationIndex[6] = "MACHINE._PGen0Pu = -MACHINE.P0Pu";//equation_index_omc:13
  fEquationIndex[7] = "MACHINE._QGen0Pu = -MACHINE.Q0Pu";//equation_index_omc:14
}

void ModelMACHINE_PQ_Init::setGequations(std::map<int,std::string>& gEquationIndex)
{
// ---------------- boolean conditions -------------
// -----------------------------
}

void ModelMACHINE_PQ_Init::setYType_omc(propertyContinuousVar_t* yType)
{
   yType[ 0 ] = ALGEBRIC;   /* MACHINE_PGen0Pu (rAlg)  */
   yType[ 1 ] = ALGEBRIC;   /* MACHINE_QGen0Pu (rAlg)  */
   yType[ 2 ] = ALGEBRIC;   /* MACHINE_i0Pu_im (rAlg)  */
   yType[ 3 ] = ALGEBRIC;   /* MACHINE_i0Pu_re (rAlg)  */
   yType[ 4 ] = ALGEBRIC;   /* MACHINE_s0Pu_im (rAlg)  */
   yType[ 5 ] = ALGEBRIC;   /* MACHINE_s0Pu_re (rAlg)  */
   yType[ 6 ] = ALGEBRIC;   /* MACHINE_u0Pu_im (rAlg)  */
   yType[ 7 ] = ALGEBRIC;   /* MACHINE_u0Pu_re (rAlg)  */
}

void ModelMACHINE_PQ_Init::setFType_omc(propertyF_t* fType)
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

}