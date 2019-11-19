#include <limits>
#include <cassert>
#include <set>
#include <iostream>
#include <string>
#include <vector>
#include <math.h>

#include "DYNElement.h"

#include "GeneratorPQ_Init.h"
#include "GeneratorPQ_Init_definition.h"
#include "GeneratorPQ_Init_literal.h"


namespace DYN {


void ModelGeneratorPQ_Init::initData(DYNDATA *d)
{
  setData(d);
  setupDataStruc();
  initializeDataStruc();
}

void ModelGeneratorPQ_Init::setupDataStruc()
{

  data->modelData = (MODEL_DATA *)calloc(1,sizeof(MODEL_DATA));
  data->simulationInfo = (SIMULATION_INFO *)calloc(1,sizeof(SIMULATION_INFO));
  data->simulationInfo->daeModeData = (DAEMODE_DATA *)calloc(1,sizeof(DAEMODE_DATA));
  data->nbDummy = 0;
  data->modelData->nStates = 0;
  data->modelData->nVariablesReal = 8;
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
  data->modelData->nAliasReal = 0 - 0 /* Remove const aliases */;
  data->modelData->nAliasInteger = 0 - 0 /* Remove const aliases */;
  data->modelData->nAliasBoolean = 0 - 0 /* Remove const aliases */;
  data->modelData->nAliasString = 0;
  data->modelData->nZeroCrossings = 0 + 0 + 0;
  data->modelData->nSamples = 0;
  data->modelData->nRelations = 0 + 0;
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
  data->simulationInfo->daeModeData->nAuxiliaryVars = 2;

  data->nbVars =8;
  data->nbF = 8;
  data->nbModes = 0;
  data->nbZ = 0;
  data->nbCalculatedVars = 0;
  data->constCalcVars.resize(0, 0.);
}

void ModelGeneratorPQ_Init::initializeDataStruc()
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

  data->simulationInfo->discreteCall = 0;
 
}

void ModelGeneratorPQ_Init::deInitializeDataStruc()
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
  // buffer for DAE mode data structures
  free(data->simulationInfo->daeModeData->residualVars);
  free(data->simulationInfo->daeModeData->auxiliaryVars);
  free(data->simulationInfo->daeModeData);
  // buffer for all relation values
  free(data->simulationInfo->relations);
  free(data->simulationInfo->relationsPre);
  free(data->simulationInfo);
  free(data->modelData);

}

void ModelGeneratorPQ_Init::initRpar()
{
  /* Setting shared and external parameters */
  data->simulationInfo->realParameter[0] /* generator.P0Pu */ = generator_P0Pu_;
  data->simulationInfo->realParameter[1] /* generator.Q0Pu */ = generator_Q0Pu_;
  data->simulationInfo->realParameter[2] /* generator.U0Pu */ = generator_U0Pu_;
  data->simulationInfo->realParameter[3] /* generator.UPhase0 */ = generator_UPhase0_;

  // Setting internal parameters 

  return;
}

void ModelGeneratorPQ_Init::setFomc(double * f)
{
  {
  // ----- GeneratorPQ_INIT_eqFunction_8 -----
  f[0] = data->localData[0]->realVars[1] /*  generator.QGen0Pu variable  */ - ( (-data->simulationInfo->realParameter[1] /* generator.Q0Pu PARAM */) );

  }


  {
  // ----- GeneratorPQ_INIT_eqFunction_9 -----
  f[1] = data->localData[0]->realVars[0] /*  generator.PGen0Pu variable  */ - ( (-data->simulationInfo->realParameter[0] /* generator.P0Pu PARAM */) );

  }


  {
  // ----- GeneratorPQ_INIT_eqFunction_10 -----
  f[2] = data->localData[0]->realVars[5] /*  generator.s0Pu.re variable  */ - ( data->simulationInfo->realParameter[0] /* generator.P0Pu PARAM */ );

  }


  {
  // ----- GeneratorPQ_INIT_eqFunction_11 -----
  f[3] = data->localData[0]->realVars[4] /*  generator.s0Pu.im variable  */ - ( data->simulationInfo->realParameter[1] /* generator.Q0Pu PARAM */ );

  }


  {
  // ----- GeneratorPQ_INIT_eqFunction_12 -----
  $P$cse2 = cos(data->simulationInfo->realParameter[3] /* generator.UPhase0 PARAM */);

  }


  {
  // ----- GeneratorPQ_INIT_eqFunction_13 -----
  f[4] = data->localData[0]->realVars[7] /*  generator.u0Pu.re variable  */ - ( (data->simulationInfo->realParameter[2] /* generator.U0Pu PARAM */) * ($P$cse2) );

  }


  {
  // ----- GeneratorPQ_INIT_eqFunction_14 -----
  $P$cse1 = sin(data->simulationInfo->realParameter[3] /* generator.UPhase0 PARAM */);

  }


  {
  // ----- GeneratorPQ_INIT_eqFunction_15 -----
  f[5] = data->localData[0]->realVars[6] /*  generator.u0Pu.im variable  */ - ( (data->simulationInfo->realParameter[2] /* generator.U0Pu PARAM */) * ($P$cse1) );

  }


  {
  // ----- GeneratorPQ_INIT_eqFunction_16 -----
  $P$DAEres0 = (data->localData[0]->realVars[6] /* generator.u0Pu.im variable */) * (data->localData[0]->realVars[3] /* generator.i0Pu.re variable */) + ((-data->localData[0]->realVars[7] /* generator.u0Pu.re variable */)) * (data->localData[0]->realVars[2] /* generator.i0Pu.im variable */) - data->localData[0]->realVars[4] /* generator.s0Pu.im variable */;
  f[6] = $P$DAEres0;

  }


  {
  // ----- GeneratorPQ_INIT_eqFunction_17 -----
  $P$DAEres1 = (data->localData[0]->realVars[6] /* generator.u0Pu.im variable */) * (data->localData[0]->realVars[2] /* generator.i0Pu.im variable */) + (data->localData[0]->realVars[7] /* generator.u0Pu.re variable */) * (data->localData[0]->realVars[3] /* generator.i0Pu.re variable */) - data->localData[0]->realVars[5] /* generator.s0Pu.re variable */;
  f[7] = $P$DAEres1;

  }


}

modeChangeType_t ModelGeneratorPQ_Init::evalMode(const double & t) const
{
  modeChangeType_t modeChangeType = NO_MODE;
 

  return modeChangeType;
}

void ModelGeneratorPQ_Init::setGomc(state_g * gout)
{
  data->simulationInfo->discreteCall = 1;
  
  
  

  data->simulationInfo->discreteCall = 0;
}

void ModelGeneratorPQ_Init::setZomc()
{
}

void ModelGeneratorPQ_Init::setY0omc()
{
  data->localData[0]->realVars[2] /* generator.i0Pu.im */ = 0.0;
  data->localData[0]->realVars[3] /* generator.i0Pu.re */ = 0.0;
  {
    data->localData[0]->realVars[6] /* generator.u0Pu.im variable */ = (data->simulationInfo->realParameter[2] /* generator.U0Pu PARAM */) * (sin(data->simulationInfo->realParameter[3] /* generator.UPhase0 PARAM */));
  }
  {
    data->localData[0]->realVars[7] /* generator.u0Pu.re variable */ = (data->simulationInfo->realParameter[2] /* generator.U0Pu PARAM */) * (cos(data->simulationInfo->realParameter[3] /* generator.UPhase0 PARAM */));
  }
  {
    data->localData[0]->realVars[5] /* generator.s0Pu.re variable */ = data->simulationInfo->realParameter[0] /* generator.P0Pu PARAM */;
  }
  {
    data->localData[0]->realVars[4] /* generator.s0Pu.im variable */ = data->simulationInfo->realParameter[1] /* generator.Q0Pu PARAM */;
  }
  {
    data->localData[0]->realVars[0] /* generator.PGen0Pu variable */ = (-data->simulationInfo->realParameter[0] /* generator.P0Pu PARAM */);
  }
  {
    data->localData[0]->realVars[1] /* generator.QGen0Pu variable */ = (-data->simulationInfo->realParameter[1] /* generator.Q0Pu PARAM */);
  }
}

boost::shared_ptr<parameters::ParametersSet> ModelGeneratorPQ_Init::setSharedParametersDefaultValues()
{

   // Propagating shared parameters default value 

   // This value may be updated later on through *.par/*.iidm data 
  boost::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newInstance("SharedModelicaParameters");

  return parametersSet;
}

void ModelGeneratorPQ_Init::setParameters( boost::shared_ptr<parameters::ParametersSet> params )
{
  generator_P0Pu_ = params->getParameter("generator_P0Pu")->getDouble();
  generator_Q0Pu_ = params->getParameter("generator_Q0Pu")->getDouble();
  generator_U0Pu_ = params->getParameter("generator_U0Pu")->getDouble();
  generator_UPhase0_ = params->getParameter("generator_UPhase0")->getDouble();
}

void ModelGeneratorPQ_Init::defineElements(std::vector<Element>& elements, std::map<std::string, int >& mapElement)
{


}

void ModelGeneratorPQ_Init::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables)
{
  variables.push_back (VariableNativeFactory::createState ("generator_PGen0Pu", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_QGen0Pu", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_i0Pu_im", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_i0Pu_re", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_s0Pu_im", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_s0Pu_re", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_u0Pu_im", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_u0Pu_re", CONTINUOUS, false));
}

void ModelGeneratorPQ_Init::defineParameters(std::vector<ParameterModeler>& parameters)
{
  parameters.push_back(ParameterModeler("generator_P0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("generator_Q0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("generator_U0Pu", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("generator_UPhase0", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
}

#ifdef _ADEPT_
void ModelGeneratorPQ_Init::evalFAdept(const std::vector<adept::adouble> & x,
                              const std::vector<adept::adouble> & xd,
                              std::vector<adept::adouble> & res)
{
  /*
    generator_PGen0Pu : x[0]
    generator_QGen0Pu : x[1]
    generator_i0Pu_im : x[2]
    generator_i0Pu_re : x[3]
    generator_s0Pu_im : x[4]
    generator_s0Pu_re : x[5]
    generator_u0Pu_im : x[6]
    generator_u0Pu_re : x[7]

  */
  adept::adouble $cse1;
  adept::adouble $cse2;
  adept::adouble $DAEres0;
  adept::adouble $DAEres1;
  // ----- GeneratorPQ_INIT_eqFunction_8 -----
  {
  res[0] = x[1] - ( (-data->simulationInfo->realParameter[1] /* generator.Q0Pu PARAM */) );

  }


  // ----- GeneratorPQ_INIT_eqFunction_9 -----
  {
  res[1] = x[0] - ( (-data->simulationInfo->realParameter[0] /* generator.P0Pu PARAM */) );

  }


  // ----- GeneratorPQ_INIT_eqFunction_10 -----
  {
  res[2] = x[5] - ( data->simulationInfo->realParameter[0] /* generator.P0Pu PARAM */ );

  }


  // ----- GeneratorPQ_INIT_eqFunction_11 -----
  {
  res[3] = x[4] - ( data->simulationInfo->realParameter[1] /* generator.Q0Pu PARAM */ );

  }


  // ----- GeneratorPQ_INIT_eqFunction_12 -----
  {
  $cse2 = cos(data->simulationInfo->realParameter[3] /* generator.UPhase0 PARAM */);

  }


  // ----- GeneratorPQ_INIT_eqFunction_13 -----
  {
  res[4] = x[7] - ( (data->simulationInfo->realParameter[2] /* generator.U0Pu PARAM */) * ($cse2) );

  }


  // ----- GeneratorPQ_INIT_eqFunction_14 -----
  {
  $cse1 = sin(data->simulationInfo->realParameter[3] /* generator.UPhase0 PARAM */);

  }


  // ----- GeneratorPQ_INIT_eqFunction_15 -----
  {
  res[5] = x[6] - ( (data->simulationInfo->realParameter[2] /* generator.U0Pu PARAM */) * ($cse1) );

  }


  // ----- GeneratorPQ_INIT_eqFunction_16 -----
  {
  $DAEres0 = (x[6]) * (x[3]) + ((-x[7])) * (x[2]) - x[4];
  res[6] = $DAEres0;

  }


  // ----- GeneratorPQ_INIT_eqFunction_17 -----
  {
  $DAEres1 = (x[6]) * (x[2]) + (x[7]) * (x[3]) - x[5];
  res[7] = $DAEres1;

  }


}
#endif

void ModelGeneratorPQ_Init::checkDataCoherence()
{
}

void ModelGeneratorPQ_Init::setFequations(std::map<int,std::string>& fEquationIndex)
{
  //Note: fictive equations are not added. fEquationIndex.size() = sizeF() - Nunmber of fictive equations.
  fEquationIndex[0] = "generator._QGen0Pu = -generator.Q0Pu";//equation_index_omc:8
  fEquationIndex[1] = "generator._PGen0Pu = -generator.P0Pu";//equation_index_omc:9
  fEquationIndex[2] = "generator._s0Pu._re = generator.P0Pu";//equation_index_omc:10
  fEquationIndex[3] = "generator._s0Pu._im = generator.Q0Pu";//equation_index_omc:11
  fEquationIndex[4] = "generator._u0Pu._re = generator.U0Pu * $cse2";//equation_index_omc:13
  fEquationIndex[5] = "generator._u0Pu._im = generator.U0Pu * $cse1";//equation_index_omc:15
  fEquationIndex[6] = "$DAEres0 = generator.u0Pu.im * generator.i0Pu.re + (-generator.u0Pu.re) * generator.i0Pu.im - generator.s0Pu.im";//equation_index_omc:16
  fEquationIndex[7] = "$DAEres1 = generator.u0Pu.im * generator.i0Pu.im + generator.u0Pu.re * generator.i0Pu.re - generator.s0Pu.re";//equation_index_omc:17
}

void ModelGeneratorPQ_Init::setGequations(std::map<int,std::string>& gEquationIndex)
{
// ---------------- boolean conditions -------------
// -----------------------------
}

void ModelGeneratorPQ_Init::setYType_omc(propertyContinuousVar_t* yType)
{
   yType[ 0 ] = ALGEBRIC;   /* generator_PGen0Pu (rAlg)  */
   yType[ 1 ] = ALGEBRIC;   /* generator_QGen0Pu (rAlg)  */
   yType[ 2 ] = ALGEBRIC;   /* generator_i0Pu_im (rAlg)  */
   yType[ 3 ] = ALGEBRIC;   /* generator_i0Pu_re (rAlg)  */
   yType[ 4 ] = ALGEBRIC;   /* generator_s0Pu_im (rAlg)  */
   yType[ 5 ] = ALGEBRIC;   /* generator_s0Pu_re (rAlg)  */
   yType[ 6 ] = ALGEBRIC;   /* generator_u0Pu_im (rAlg)  */
   yType[ 7 ] = ALGEBRIC;   /* generator_u0Pu_re (rAlg)  */
}

void ModelGeneratorPQ_Init::setFType_omc(propertyF_t* fType)
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

void ModelGeneratorPQ_Init::evalCalculatedVars(std::vector<double>& calculatedVars)
{
}

double ModelGeneratorPQ_Init::evalCalculatedVarI(int iCalculatedVar, double* y, double* yp)
{
  throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);
}

void ModelGeneratorPQ_Init::evalJCalculatedVarI(int iCalculatedVar, double* y, double* yp, std::vector<double> & res)
{
  // not needed
}

std::vector<int> ModelGeneratorPQ_Init::getDefJCalculatedVarI(int iCalculatedVar)
{
  return std::vector<int>();
}

}