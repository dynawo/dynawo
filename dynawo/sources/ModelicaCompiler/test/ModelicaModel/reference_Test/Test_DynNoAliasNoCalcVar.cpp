#include <limits>
#include <cassert>
#include <set>
#include <iostream>
#include <string>
#include <vector>
#include <math.h>

#include "DYNElement.h"
#include "PARParametersSetFactory.h"

#include "Test_Dyn.h"
#include "Test_Dyn_definition.h"
#include "Test_Dyn_literal.h"


namespace DYN {


void ModelTest_Dyn::initData(DYNDATA *d)
{
  setData(d);
  setupDataStruc();
  initializeDataStruc();
}

void ModelTest_Dyn::setupDataStruc()
{

  data->modelData = (MODEL_DATA *)calloc(1,sizeof(MODEL_DATA));
  data->simulationInfo = (SIMULATION_INFO *)calloc(1,sizeof(SIMULATION_INFO));
  data->simulationInfo->daeModeData = (DAEMODE_DATA *)calloc(1,sizeof(DAEMODE_DATA));
  data->nbDummy = 0;
  data->modelData->nStates = 1;
  data->modelData->nVariablesReal = 4;
  data->modelData->nDiscreteReal = 0;
  data->modelData->nVariablesInteger = 0;
  data->modelData->nVariablesBoolean = 0;
  data->modelData->nVariablesString = 0;
  data->modelData->nParametersReal = 2;
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
  data->modelData->nLinearSystems = 0;
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
  data->simulationInfo->daeModeData->nResidualVars = 1;
  data->simulationInfo->daeModeData->nAuxiliaryVars = 0;

  data->nbVars =4;
  data->nbF = 4;
  data->nbModes = 0;
  data->nbZ = 0;
  data->nbCalculatedVars = 0;
  data->nbDelays = 0;
  data->constCalcVars.resize(0, 0.);
}

void ModelTest_Dyn::initializeDataStruc()
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

void ModelTest_Dyn::deInitializeDataStruc()
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

void ModelTest_Dyn::initRpar()
{
  /* Setting shared and external parameters */
  data->simulationInfo->realParameter[0] /* a */ = a_;
  data->simulationInfo->realParameter[1] /* b */ = b_;

  // Setting internal parameters 

  return;
}

void ModelTest_Dyn::setFomc(double * f, propertyF_t type)
{
  if (type != DIFFERENTIAL_EQ) {
  {
  // ----- Test.Test_eqFunction_7 -----
  f[1] = data->localData[0]->realVars[1] /*  x variable  */ - ( (2.0) * ((data->localData[0]->realVars[0] /* u STATE(1) */)) );

  }


  {
  // ----- Test.Test_eqFunction_8 -----
  f[2] = data->localData[0]->realVars[2] /*  y variable  */ - ( (data->localData[0]->realVars[1] /* x variable */) );

  }


  {
  // ----- Test.Test_eqFunction_9 -----
  f[3] = data->localData[0]->realVars[3] /*  z variable  */ - ( (4.0) * (((data->localData[0]->realVars[1] /* x variable */)) * ((data->localData[0]->realVars[0] /* u STATE(1) */))) );

  }


  }
  if (type != ALGEBRAIC_EQ) {
  {
  // ----- Test.Test_eqFunction_6 -----
  (data->simulationInfo->daeModeData->residualVars[0]) /* $DAEres0 DAE_RESIDUAL_VAR */ = ((-(data->simulationInfo->realParameter[1] /* b PARAM */))) * ((data->localData[0]->realVars[0] /* u STATE(1) */)) - (((data->simulationInfo->realParameter[0] /* a PARAM */)) * ((data->localData[0]->derivativesVars[0] /* der(u) STATE_DER */)));
    f[0] = data->simulationInfo->daeModeData->residualVars[0] /* $DAEres0 DAE_RESIDUAL_VAR */;

  }


  }
}

modeChangeType_t ModelTest_Dyn::evalMode(const double t) const
{
  modeChangeType_t modeChangeType = NO_MODE;
 

  return modeChangeType;
}

void ModelTest_Dyn::setZomc()
{
}

void ModelTest_Dyn::collectSilentZ(BitMask* silentZTable)
{
}

void ModelTest_Dyn::setGomc(state_g * gout)
{
  data->simulationInfo->discreteCall = 1;






  data->simulationInfo->discreteCall = 0;
}

void ModelTest_Dyn::setY0omc()
{
  data->localData[0]->realVars[0] /* u */ = 1.0;
  {
    (data->localData[0]->realVars[1] /* x variable */) = (2.0) * ((data->localData[0]->realVars[0] /* u STATE(1) */));
  }
  {
    (data->localData[0]->realVars[3] /* z variable */) = (4.0) * (((data->localData[0]->realVars[1] /* x variable */)) * ((data->localData[0]->realVars[0] /* u STATE(1) */)));
  }
  {
    (data->localData[0]->realVars[2] /* y variable */) = (data->localData[0]->realVars[1] /* x variable */);
  }
}

void ModelTest_Dyn::callCustomParametersConstructors()
{
}

void ModelTest_Dyn::evalStaticYType_omc(propertyContinuousVar_t* yType)
{
   yType[ 0 ] = DIFFERENTIAL;   /* u (rSta)  */
   yType[ 1 ] = ALGEBRAIC;   /* x (rAlg)  */
   yType[ 2 ] = ALGEBRAIC;   /* y (rAlg)  */
   yType[ 3 ] = ALGEBRAIC;   /* z (rAlg)  */
}

void ModelTest_Dyn::evalDynamicYType_omc(propertyContinuousVar_t* yType)
{
}

void ModelTest_Dyn::evalStaticFType_omc(propertyF_t* fType)
{
   fType[ 0 ] = DIFFERENTIAL_EQ;
   fType[ 1 ] = ALGEBRAIC_EQ;
   fType[ 2 ] = ALGEBRAIC_EQ;
   fType[ 3 ] = ALGEBRAIC_EQ;
}

void ModelTest_Dyn::evalDynamicFType_omc(propertyF_t* fType)
{
}

std::shared_ptr<parameters::ParametersSet> ModelTest_Dyn::setSharedParametersDefaultValues()
{

   // Propagating shared parameters default value 

   // This value may be updated later on through *.par/*.iidm data 
  std::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newParametersSet("SharedModelicaParameters");
  double a_internal;
  double b_internal;

  a_internal = 1.0; 
  parametersSet->createParameter("a", a_internal);
  b_internal = 2.0; 
  parametersSet->createParameter("b", b_internal);
  return parametersSet;
}

void ModelTest_Dyn::setParameters( std::shared_ptr<parameters::ParametersSet> params )
{
  a_ = params->getParameter("a")->getDouble();
  b_ = params->getParameter("b")->getDouble();
}

void ModelTest_Dyn::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables)
{
  variables.push_back (VariableNativeFactory::createState ("u", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("x", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("y", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("z", CONTINUOUS, false));
}

void ModelTest_Dyn::defineParameters(std::vector<ParameterModeler>& parameters)
{
  parameters.push_back(ParameterModeler("a", VAR_TYPE_DOUBLE, SHARED_PARAMETER));
  parameters.push_back(ParameterModeler("b", VAR_TYPE_DOUBLE, SHARED_PARAMETER));
}

void ModelTest_Dyn::defineElements(std::vector<Element>& elements, std::map<std::string, int >& mapElement)
{
  elements.push_back(Element("z","z",Element::TERMINAL));
  elements.push_back(Element("y","y",Element::TERMINAL));
  elements.push_back(Element("x","x",Element::TERMINAL));
  elements.push_back(Element("u","u",Element::TERMINAL));


  mapElement["z"] = 0;
  mapElement["y"] = 1;
  mapElement["x"] = 2;
  mapElement["u"] = 3;
}

#ifdef _ADEPT_
void ModelTest_Dyn::evalFAdept(const std::vector<adept::adouble> & x,
                              const std::vector<adept::adouble> & xd,
                              std::vector<adept::adouble> & res)
{
  /*
    u : x[0]
    x : x[1]
    y : x[2]
    z : x[3]
    der(u) : xd[0]

  */
  adept::adouble $DAEres0;
  // ----- Test.Test_eqFunction_6 -----
  {
    res[0] = ((-(data->simulationInfo->realParameter[1] /* b PARAM */))) * (x[0]) - (((data->simulationInfo->realParameter[0] /* a PARAM */)) * (xd[0]));

  }


  // ----- Test.Test_eqFunction_7 -----
  {
  res[1] = x[1] - ( (2.0) * (x[0]) );

  }


  // ----- Test.Test_eqFunction_8 -----
  {
  res[2] = x[2] - ( x[1] );

  }


  // ----- Test.Test_eqFunction_9 -----
  {
  res[3] = x[3] - ( (4.0) * ((x[1]) * (x[0])) );

  }


}
#endif

void ModelTest_Dyn::checkDataCoherence()
{
}

void ModelTest_Dyn::checkParametersCoherence() const
{
}

void ModelTest_Dyn::setFequations(std::map<int,std::string>& fEquationIndex)
{
  //Note: fictive equations are not added. fEquationIndex.size() = sizeF() - Nunmber of fictive equations.
  fEquationIndex[0] = "$DAEres0 = (-b) * u - a * der(u)";//equation_index_omc:6
  fEquationIndex[1] = "x = 2.0 * u";//equation_index_omc:7
  fEquationIndex[2] = "y = x";//equation_index_omc:8
  fEquationIndex[3] = "z = 4.0 * x * u";//equation_index_omc:9
}

void ModelTest_Dyn::setGequations(std::map<int,std::string>& gEquationIndex)
{
// ---------------- boolean conditions -------------
// -----------------------------
}

void ModelTest_Dyn::evalCalculatedVars(std::vector<double>& calculatedVars)
{
}

double ModelTest_Dyn::evalCalculatedVarI(unsigned iCalculatedVar) const
{
  throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);
}

#ifdef _ADEPT_
adept::adouble ModelTest_Dyn::evalCalculatedVarIAdept(unsigned iCalculatedVar, unsigned indexOffset, const std::vector<adept::adouble> &x, const std::vector<adept::adouble> &xd) const
{
  throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);
}
#endif

void ModelTest_Dyn::getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const
{
}

}