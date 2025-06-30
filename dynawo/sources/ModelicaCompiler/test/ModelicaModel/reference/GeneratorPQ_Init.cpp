#include <limits>
#include <cassert>
#include <set>
#include <iostream>
#include <string>
#include <vector>
#include <math.h>

#include "DYNElement.h"
#include "PARParametersSetFactory.h"

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
  data->modelData->nVariablesReal = 2;
  data->modelData->nDiscreteReal = 0;
  data->modelData->nVariablesInteger = 0;
  data->modelData->nVariablesBoolean = 0;
  data->modelData->nVariablesString = 0;
  data->modelData->nParametersReal = 6;
  data->modelData->nParametersInteger = 0;
  data->modelData->nParametersBoolean = 0;
  data->modelData->nParametersString = 0;
  data->modelData->nInputVars = 0;
  data->modelData->nOutputVars = 0;
  data->modelData->nAliasReal = 4 - 4 /* Remove const aliases */;
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
  data->modelData->nJacobians = 6;
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
  data->simulationInfo->daeModeData->nResidualVars = 2;
  data->simulationInfo->daeModeData->nAuxiliaryVars = 0;

  data->nbVars =2;
  data->nbF = 2;
  data->nbModes = 2;
  data->nbZ = 0;
  data->nbCalculatedVars = 6;
  data->nbDelays = 0;
  data->constCalcVars.resize(2, 0.);
}

void ModelGeneratorPQ_Init::initializeDataStruc()
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

void ModelGeneratorPQ_Init::deInitializeDataStruc()
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

void ModelGeneratorPQ_Init::initRpar()
{
  /* Setting shared and external parameters */
  data->simulationInfo->realParameter[0] /* generator.P0Pu */ = generator_P0Pu_;
  data->simulationInfo->realParameter[1] /* generator.Q0Pu */ = generator_Q0Pu_;
  data->simulationInfo->realParameter[2] /* generator.U0Pu */ = generator_U0Pu_;
  data->simulationInfo->realParameter[3] /* generator.UPhase0 */ = generator_UPhase0_;
  data->simulationInfo->realParameter[4] /* generator.iStart0Pu.im */ = generator_iStart0Pu_im_;
  data->simulationInfo->realParameter[5] /* generator.iStart0Pu.re */ = generator_iStart0Pu_re_;

  // Setting internal parameters 

  return;
}

void ModelGeneratorPQ_Init::setFomc(double * f, propertyF_t type)
{
  if (type != DIFFERENTIAL_EQ) {
  {
  // ----- GeneratorPQ_INIT_eqFunction_7 -----
  (data->simulationInfo->daeModeData->residualVars[1]) /* $DAEres1 DAE_RESIDUAL_VAR */ = ((data->constCalcVars[0] /* generator.u0Pu.im variable */)) * ((data->localData[0]->realVars[0] /* generator.i0Pu.im variable */)) + ((data->constCalcVars[1] /* generator.u0Pu.re variable */)) * ((data->localData[0]->realVars[1] /* generator.i0Pu.re variable */)) - (data->simulationInfo->realParameter[0] /* generator.P0Pu PARAM */);
    f[0] = data->simulationInfo->daeModeData->residualVars[1] /* $DAEres1 DAE_RESIDUAL_VAR */;

  }


  {
  // ----- GeneratorPQ_INIT_eqFunction_8 -----
  (data->simulationInfo->daeModeData->residualVars[0]) /* $DAEres0 DAE_RESIDUAL_VAR */ = ((data->constCalcVars[0] /* generator.u0Pu.im variable */)) * ((data->localData[0]->realVars[1] /* generator.i0Pu.re variable */)) + ((-(data->constCalcVars[1] /* generator.u0Pu.re variable */))) * ((data->localData[0]->realVars[0] /* generator.i0Pu.im variable */)) - (data->simulationInfo->realParameter[1] /* generator.Q0Pu PARAM */);
    f[1] = data->simulationInfo->daeModeData->residualVars[0] /* $DAEres0 DAE_RESIDUAL_VAR */;

  }


  }
}

modeChangeType_t ModelGeneratorPQ_Init::evalMode(const double t) const
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

void ModelGeneratorPQ_Init::collectSilentZ(BitMask* silentZTable)
{
}

void ModelGeneratorPQ_Init::setY0omc()
{
  data->localData[0]->realVars[0] /* generator.i0Pu.im */ = 0.0;
  data->localData[0]->realVars[1] /* generator.i0Pu.re */ = (data->simulationInfo->realParameter[5] /* generator.iStart0Pu.re PARAM */);
    (data->constCalcVars[0] /* generator.u0Pu.im variable */) = ((data->simulationInfo->realParameter[2] /* generator.U0Pu PARAM */)) * (sin((data->simulationInfo->realParameter[3] /* generator.UPhase0 PARAM */)));
    (data->constCalcVars[1] /* generator.u0Pu.re variable */) = ((data->simulationInfo->realParameter[2] /* generator.U0Pu PARAM */)) * (cos((data->simulationInfo->realParameter[3] /* generator.UPhase0 PARAM */)));
}

void ModelGeneratorPQ_Init::callCustomParametersConstructors()
{
}

std::shared_ptr<parameters::ParametersSet> ModelGeneratorPQ_Init::setSharedParametersDefaultValues()
{

   // Propagating shared parameters default value 

   // This value may be updated later on through *.par/*.iidm data 
  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("SharedModelicaParameters");
  double generator_P0Pu_internal;
  double generator_Q0Pu_internal;
  double generator_U0Pu_internal;
  double generator_UPhase0_internal;
  double generator_iStart0Pu_im_internal;
  double generator_iStart0Pu_re_internal;

  generator_P0Pu_internal = 0.0; 
  parametersSet->createParameter("generator_P0Pu", generator_P0Pu_internal);
  generator_Q0Pu_internal = 0.0; 
  parametersSet->createParameter("generator_Q0Pu", generator_Q0Pu_internal);
  generator_U0Pu_internal = 0.0; 
  parametersSet->createParameter("generator_U0Pu", generator_U0Pu_internal);
  generator_UPhase0_internal = 0.0; 
  parametersSet->createParameter("generator_UPhase0", generator_UPhase0_internal);
  generator_iStart0Pu_im_internal = 0.0; 
  parametersSet->createParameter("generator_iStart0Pu_im", generator_iStart0Pu_im_internal);
  generator_iStart0Pu_re_internal = 0.0; 
  parametersSet->createParameter("generator_iStart0Pu_re", generator_iStart0Pu_re_internal);
  return parametersSet;
}

void ModelGeneratorPQ_Init::setParameters( std::shared_ptr<parameters::ParametersSet> params )
{
  generator_P0Pu_ = params->getParameter("generator_P0Pu")->getDouble();
  generator_Q0Pu_ = params->getParameter("generator_Q0Pu")->getDouble();
  generator_U0Pu_ = params->getParameter("generator_U0Pu")->getDouble();
  generator_UPhase0_ = params->getParameter("generator_UPhase0")->getDouble();
  generator_iStart0Pu_im_ = params->getParameter("generator_iStart0Pu_im")->getDouble();
  generator_iStart0Pu_re_ = params->getParameter("generator_iStart0Pu_re")->getDouble();
}

void ModelGeneratorPQ_Init::defineElements(std::vector<Element>& elements, std::map<std::string, int >& mapElement)
{


}

void ModelGeneratorPQ_Init::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables)
{
  variables.push_back (VariableNativeFactory::createState ("generator_i0Pu_im", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("generator_i0Pu_re", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createCalculated ("generator_u0Pu_im", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createCalculated ("generator_u0Pu_re", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createCalculated ("generator_PGen0Pu", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createCalculated ("generator_QGen0Pu", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createCalculated ("generator_s0Pu_im", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createCalculated ("generator_s0Pu_re", CONTINUOUS, false));
}

void ModelGeneratorPQ_Init::defineParameters(std::vector<ParameterModeler>& parameters)
{
  parameters.push_back(ParameterModeler("generator_P0Pu", VAR_TYPE_DOUBLE, SHARED_PARAMETER));
  parameters.push_back(ParameterModeler("generator_Q0Pu", VAR_TYPE_DOUBLE, SHARED_PARAMETER));
  parameters.push_back(ParameterModeler("generator_U0Pu", VAR_TYPE_DOUBLE, SHARED_PARAMETER));
  parameters.push_back(ParameterModeler("generator_UPhase0", VAR_TYPE_DOUBLE, SHARED_PARAMETER));
  parameters.push_back(ParameterModeler("generator_iStart0Pu_im", VAR_TYPE_DOUBLE, SHARED_PARAMETER));
  parameters.push_back(ParameterModeler("generator_iStart0Pu_re", VAR_TYPE_DOUBLE, SHARED_PARAMETER));
}

#ifdef _ADEPT_
void ModelGeneratorPQ_Init::evalFAdept(const std::vector<adept::adouble> & x,
                              const std::vector<adept::adouble> & xd,
                              std::vector<adept::adouble> & res)
{
  /*
    generator_i0Pu_im : x[0]
    generator_i0Pu_re : x[1]

  */
  adept::adouble $DAEres0;
  adept::adouble $DAEres1;
  // ----- GeneratorPQ_INIT_eqFunction_7 -----
  {
    res[0] = ((data->constCalcVars[0] /* generator.u0Pu.im variable */)) * (x[0]) + ((data->constCalcVars[1] /* generator.u0Pu.re variable */)) * (x[1]) - (data->simulationInfo->realParameter[0] /* generator.P0Pu PARAM */);

  }


  // ----- GeneratorPQ_INIT_eqFunction_8 -----
  {
    res[1] = ((data->constCalcVars[0] /* generator.u0Pu.im variable */)) * (x[1]) + ((-(data->constCalcVars[1] /* generator.u0Pu.re variable */))) * (x[0]) - (data->simulationInfo->realParameter[1] /* generator.Q0Pu PARAM */);

  }


}
#endif

void ModelGeneratorPQ_Init::checkDataCoherence()
{
}

void ModelGeneratorPQ_Init::checkParametersCoherence() const
{
}

void ModelGeneratorPQ_Init::setFequations(std::map<int,std::string>& fEquationIndex)
{
  //Note: fictive equations are not added. fEquationIndex.size() = sizeF() - Nunmber of fictive equations.
  fEquationIndex[0] = "$DAEres1 = generator.u0Pu.im * generator.i0Pu.im + generator.u0Pu.re * generator.i0Pu.re - generator.P0Pu";//equation_index_omc:7
  fEquationIndex[1] = "$DAEres0 = generator.u0Pu.im * generator.i0Pu.re + (-generator.u0Pu.re) * generator.i0Pu.im - generator.Q0Pu";//equation_index_omc:8
}

void ModelGeneratorPQ_Init::setGequations(std::map<int,std::string>& gEquationIndex)
{
// ---------------- boolean conditions -------------
// -----------------------------
}

void ModelGeneratorPQ_Init::evalStaticYType_omc(propertyContinuousVar_t* yType)
{
   yType[ 0 ] = ALGEBRAIC;   /* generator_i0Pu_im (rAlg)  */
   yType[ 1 ] = ALGEBRAIC;   /* generator_i0Pu_re (rAlg)  */
}

void ModelGeneratorPQ_Init::evalDynamicYType_omc(propertyContinuousVar_t* /*yType*/)
{
}

void ModelGeneratorPQ_Init::evalStaticFType_omc(propertyF_t* fType)
{
   fType[ 0 ] = ALGEBRAIC_EQ;
   fType[ 1 ] = ALGEBRAIC_EQ;
}

void ModelGeneratorPQ_Init::evalDynamicFType_omc(propertyF_t* /*fType*/)
{
}

void ModelGeneratorPQ_Init::evalCalculatedVars(std::vector<double>& calculatedVars)
{
  calculatedVars[0] /* generator.u0Pu.im*/ = data->constCalcVars[0];
  calculatedVars[1] /* generator.u0Pu.re*/ = data->constCalcVars[1];
  calculatedVars[2] /* generator.PGen0Pu*/ = -data->simulationInfo->realParameter[0] /* generator.P0Pu*/;
  calculatedVars[3] /* generator.QGen0Pu*/ = -data->simulationInfo->realParameter[1] /* generator.Q0Pu*/;
  calculatedVars[4] /* generator.s0Pu.im*/ = data->simulationInfo->realParameter[1] /* generator.Q0Pu*/;
  calculatedVars[5] /* generator.s0Pu.re*/ = data->simulationInfo->realParameter[0] /* generator.P0Pu*/;
}

double ModelGeneratorPQ_Init::evalCalculatedVarI(unsigned iCalculatedVar) const
{
  if (iCalculatedVar == 0)  /* generator.u0Pu.im */
    return data->constCalcVars[0];
  if (iCalculatedVar == 1)  /* generator.u0Pu.re */
    return data->constCalcVars[1];
  if (iCalculatedVar == 2)  /* generator.PGen0Pu */
    return -data->simulationInfo->realParameter[0] /* generator.P0Pu*/;
  if (iCalculatedVar == 3)  /* generator.QGen0Pu */
    return -data->simulationInfo->realParameter[1] /* generator.Q0Pu*/;
  if (iCalculatedVar == 4)  /* generator.s0Pu.im */
    return data->simulationInfo->realParameter[1] /* generator.Q0Pu*/;
  if (iCalculatedVar == 5)  /* generator.s0Pu.re */
    return data->simulationInfo->realParameter[0] /* generator.P0Pu*/;
  throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);
}

#ifdef _ADEPT_
adept::adouble ModelGeneratorPQ_Init::evalCalculatedVarIAdept(unsigned iCalculatedVar, unsigned indexOffset, const std::vector<adept::adouble> &x, const std::vector<adept::adouble> &xd) const
{
  if (iCalculatedVar == 0)  /* generator.u0Pu.im */
     return data->constCalcVars[0];

  if (iCalculatedVar == 1)  /* generator.u0Pu.re */
     return data->constCalcVars[1];

  if (iCalculatedVar == 2)  /* generator.PGen0Pu */
     return -data->simulationInfo->realParameter[0] /* generator.P0Pu*/;

  if (iCalculatedVar == 3)  /* generator.QGen0Pu */
     return -data->simulationInfo->realParameter[1] /* generator.Q0Pu*/;

  if (iCalculatedVar == 4)  /* generator.s0Pu.im */
     return data->simulationInfo->realParameter[1] /* generator.Q0Pu*/;

  if (iCalculatedVar == 5)  /* generator.s0Pu.re */
     return data->simulationInfo->realParameter[0] /* generator.P0Pu*/;

  throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);
}
#endif

void ModelGeneratorPQ_Init::getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const
{
}

}