#include <limits>
#include <cassert>
#include <set>
#include <iostream>
#include <string>
#include <vector>
#include <math.h>

#include "DYNElement.h"

#include "TestSilentZ_Dyn.h"
#include "TestSilentZ_Dyn_definition.h"
#include "TestSilentZ_Dyn_literal.h"


namespace DYN {


void ModelTestSilentZ_Dyn::initData(DYNDATA *d)
{
  setData(d);
  setupDataStruc();
  initializeDataStruc();
}

void ModelTestSilentZ_Dyn::setupDataStruc()
{

  data->modelData = (MODEL_DATA *)calloc(1,sizeof(MODEL_DATA));
  data->simulationInfo = (SIMULATION_INFO *)calloc(1,sizeof(SIMULATION_INFO));
  data->simulationInfo->daeModeData = (DAEMODE_DATA *)calloc(1,sizeof(DAEMODE_DATA));
  data->nbDummy = 0;
  data->modelData->nStates = 1;
  data->modelData->nVariablesReal = 1;
  data->modelData->nDiscreteReal = 1;
  data->modelData->nVariablesInteger = 2;
  data->modelData->nVariablesBoolean = 0;
  data->modelData->nVariablesString = 0;
  data->modelData->nParametersReal = 0 + 0; // 0 boolean emulated as real parameter
  data->modelData->nParametersInteger = 0;
  data->modelData->nParametersBoolean = 0; // all boolean parameters emulated as real parameters
  data->modelData->nParametersString = 0;
  data->modelData->nInputVars = 0;
  data->modelData->nOutputVars = 0;
  data->modelData->nAliasReal = 0 - 0 /* Remove const aliases */;
  data->modelData->nAliasInteger = 1 - 0 /* Remove const aliases */;
  data->modelData->nAliasBoolean = 0 - 0 /* Remove const aliases */;
  data->modelData->nAliasString = 0;
  data->modelData->nZeroCrossings = 1 + 0 + 0;
  data->modelData->nSamples = 0;
  data->modelData->nRelations = 1 + 0;
  data->modelData->nMathEvents = 0;
  data->modelData->nExtObjs = 0;
  data->modelData->nMixedSystems = 0;
  data->modelData->nLinearSystems = 0;
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
  data->simulationInfo->daeModeData->nResidualVars = 1;
  data->simulationInfo->daeModeData->nAuxiliaryVars = 0;

  data->nbVars =1;
  data->nbF = 1;
  data->nbModes = 0;
  data->nbZ = 1;
  data->nbCalculatedVars = 1;
  data->nbDelays = 0;
  data->constCalcVars.resize(0, 0.);
}

void ModelTestSilentZ_Dyn::initializeDataStruc()
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

void ModelTestSilentZ_Dyn::deInitializeDataStruc()
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

void ModelTestSilentZ_Dyn::initRpar()
{
  /* Setting shared and external parameters */

  // Setting internal parameters 

  return;
}

void ModelTestSilentZ_Dyn::setFomc(double * f, propertyF_t type)
{
  if (type != ALGEBRAIC_EQ) {
  {
  // ----- TestSilentZ.TestSilentZ_eqFunction_11 -----
  $P$DAEres0 = 5.0 - data->localData[0]->derivativesVars[0] /* der(u) STATE_DER */;
  f[0] = $P$DAEres0;

  }


  }
}

modeChangeType_t ModelTestSilentZ_Dyn::evalMode(const double t) const
{
  modeChangeType_t modeChangeType = NO_MODE;
 

  return modeChangeType;
}

void ModelTestSilentZ_Dyn::setZomc()
{
  data->simulationInfo->discreteCall = 1;

  // -------------------- b ---------------------
  data->localData[0]->discreteVars[0] /* b DISCRETE */ = fromNativeBool ( ((modelica_integer)data->localData[0]->integerDoubleVars[0] /* z2 DISCRETE */ == ((modelica_integer) 2)));

  // -------------------- z2 ---------------------
  modelica_boolean tmp3;
  modelica_boolean tmp4;
  modelica_integer tmp5;
  RELATIONHYSTERESIS(tmp3, data->localData[0]->timeValue, 2.0, 0, Greater);
  tmp4 = (modelica_boolean)tmp3;
  if(tmp4)
  {
    tmp5 = ((modelica_integer) 2);
  }
  else
  {
    tmp5 = ((modelica_integer) 1);
  }
  data->localData[0]->integerDoubleVars[0] /* z2 DISCRETE */ = tmp5;

  // -------------------- z3 ---------------------
  modelica_boolean tmp0;
  modelica_boolean tmp1;
  modelica_integer tmp2;
  RELATIONHYSTERESIS(tmp0, data->localData[0]->timeValue, 2.0, 0, Greater);
  tmp1 = (modelica_boolean)tmp0;
  if(tmp1)
  {
    tmp2 = ((modelica_integer) 2);
  }
  else
  {
    tmp2 = ((modelica_integer) 1);
  }
  data->localData[0]->integerDoubleVars[1] /* z3 DISCRETE */ = tmp2;
  data->simulationInfo->discreteCall = 0;
}

void ModelTestSilentZ_Dyn::collectSilentZ(BitMask* silentZTable)
{
  silentZTable[2].setFlags(NotUsedInDiscreteEquations | NotUsedInContinuousEquations) /*z3 */;
  silentZTable[0].setFlags(NotUsedInDiscreteEquations | NotUsedInContinuousEquations) /*b */;
  silentZTable[1].setFlags(NotUsedInContinuousEquations) /*z2 */;
}

void ModelTestSilentZ_Dyn::setGomc(state_g * gout)
{
  data->simulationInfo->discreteCall = 1;
  modelica_boolean tmp_zc0;
  
  
  tmp_zc0 = GreaterZC(data->localData[0]->timeValue, 2.0, data->simulationInfo->storedRelations[0]);
  

  gout[0] = (tmp_zc0) ? ROOT_UP : ROOT_DOWN;
  data->simulationInfo->discreteCall = 0;
}

void ModelTestSilentZ_Dyn::setY0omc()
{
  data->localData[0]->realVars[0] /* u */ = 1.0;
  data->localData[0]->integerDoubleVars[1] /* z3 */ = 1;
  data->localData[0]->integerDoubleVars[0] /* z2 */ = 1;
  {
    data->localData[0]->discreteVars[0] /* b DISCRETE */ = fromNativeBool ( ((modelica_integer)data->localData[0]->integerDoubleVars[0] /* z2 DISCRETE */ == ((modelica_integer) 2)));
  }
}

void ModelTestSilentZ_Dyn::callCustomParametersConstructors()
{
}

void ModelTestSilentZ_Dyn::evalStaticYType_omc(propertyContinuousVar_t* yType)
{
   yType[ 0 ] = DIFFERENTIAL;   /* u (rSta)  */
}

void ModelTestSilentZ_Dyn::evalDynamicYType_omc(propertyContinuousVar_t* yType)
{
}

void ModelTestSilentZ_Dyn::evalStaticFType_omc(propertyF_t* fType)
{
   fType[ 0 ] = DIFFERENTIAL_EQ;
}

void ModelTestSilentZ_Dyn::evalDynamicFType_omc(propertyF_t* fType)
{
}

boost::shared_ptr<parameters::ParametersSet> ModelTestSilentZ_Dyn::setSharedParametersDefaultValues()
{

   // Propagating shared parameters default value 

   // This value may be updated later on through *.par/*.iidm data 
  boost::shared_ptr<parameters::ParametersSet> parametersSet = boost::shared_ptr<parameters::ParametersSet>(new parameters::ParametersSet("SharedModelicaParameters"));

  return parametersSet;
}

void ModelTestSilentZ_Dyn::setParameters( boost::shared_ptr<parameters::ParametersSet> params )
{
}

void ModelTestSilentZ_Dyn::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables)
{
  variables.push_back (VariableNativeFactory::createState ("u", CONTINUOUS, false));
  variables.push_back (VariableNativeFactory::createState ("z2", INTEGER, false));
  variables.push_back (VariableNativeFactory::createState ("z3", INTEGER, false));
  variables.push_back (VariableAliasFactory::create ("z1", "z2", INTEGER, false));
  variables.push_back (VariableNativeFactory::createState ("b", BOOLEAN, false));
  variables.push_back (VariableNativeFactory::createCalculated ("x", CONTINUOUS, false));
}

void ModelTestSilentZ_Dyn::defineParameters(std::vector<ParameterModeler>& parameters)
{
}

void ModelTestSilentZ_Dyn::defineElements(std::vector<Element>& elements, std::map<std::string, int >& mapElement)
{
  elements.push_back(Element("b","b",Element::TERMINAL));
  elements.push_back(Element("z3","z3",Element::TERMINAL));
  elements.push_back(Element("z2","z2",Element::TERMINAL));
  elements.push_back(Element("z1","z1",Element::TERMINAL));
  elements.push_back(Element("x","x",Element::TERMINAL));
  elements.push_back(Element("u","u",Element::TERMINAL));


  mapElement["b"] = 0;
  mapElement["z3"] = 1;
  mapElement["z2"] = 2;
  mapElement["z1"] = 3;
  mapElement["x"] = 4;
  mapElement["u"] = 5;
}

#ifdef _ADEPT_
void ModelTestSilentZ_Dyn::evalFAdept(const std::vector<adept::adouble> & x,
                              const std::vector<adept::adouble> & xd,
                              std::vector<adept::adouble> & res)
{
  /*
    u : x[0]
    der(u) : xd[0]

  */
  adept::adouble $DAEres0;
  // ----- TestSilentZ.TestSilentZ_eqFunction_11 -----
  {
  $DAEres0 = 5.0 - xd[0];
  res[0] = $DAEres0;

  }


}
#endif

void ModelTestSilentZ_Dyn::checkDataCoherence()
{
}

void ModelTestSilentZ_Dyn::checkParametersCoherence() const
{
}

void ModelTestSilentZ_Dyn::setFequations(std::map<int,std::string>& fEquationIndex)
{
  //Note: fictive equations are not added. fEquationIndex.size() = sizeF() - Nunmber of fictive equations.
  fEquationIndex[0] = "$DAEres0 = 5.0 - der(u)";//equation_index_omc:11
}

void ModelTestSilentZ_Dyn::setGequations(std::map<int,std::string>& gEquationIndex)
{
// ---------------- boolean conditions -------------
  static const char *res[] = {"time > 2.0"};
  gEquationIndex[0] =  res[0]  ;
// -----------------------------
}

void ModelTestSilentZ_Dyn::evalCalculatedVars(std::vector<double>& calculatedVars)
{
  {
    modelica_boolean tmp7;
    modelica_real tmp8;
    tmp7 = (modelica_boolean)(toNativeBool (data->localData[0]->discreteVars[0] /* b DISCRETE */));
    if(tmp7)
    {
      tmp8 = data->localData[0]->realVars[0] /* u STATE(1) */;
    }
    else
    {
      tmp8 = (((modelica_real)((modelica_integer)data->localData[0]->integerDoubleVars[1] /* z3 DISCRETE */))) * (data->localData[0]->realVars[0] /* u STATE(1) */);
    }
      calculatedVars[0] /* x*/ = tmp8;
  }
}

double ModelTestSilentZ_Dyn::evalCalculatedVarI(unsigned iCalculatedVar) const
{
  if (iCalculatedVar == 0)  /* x */
  {
    modelica_boolean tmp7;
    modelica_real tmp8;
    tmp7 = (modelica_boolean)(toNativeBool (data->localData[0]->discreteVars[0] /* b DISCRETE */));
    if(tmp7)
    {
      tmp8 = data->localData[0]->realVars[0] /* u STATE(1) */;
    }
    else
    {
      tmp8 = (((modelica_real)((modelica_integer)data->localData[0]->integerDoubleVars[1] /* z3 DISCRETE */))) * (data->localData[0]->realVars[0] /* u STATE(1) */);
    }
      return tmp8;
  }
  throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);
}

#ifdef _ADEPT_
adept::adouble ModelTestSilentZ_Dyn::evalCalculatedVarIAdept(unsigned iCalculatedVar, unsigned indexOffset, const std::vector<adept::adouble> &x, const std::vector<adept::adouble> &xd) const
{
  if (iCalculatedVar == 0)  /* x */
  {
    modelica_boolean tmp7;
    adept::adouble tmp8;
    tmp7 = (modelica_boolean)(toNativeBool (data->localData[0]->discreteVars[0] /* b DISCRETE */));
    if(tmp7)
    {
      tmp8 = x[indexOffset +0];
    }
    else
    {
      tmp8 = (((modelica_real)((modelica_integer)data->localData[0]->integerDoubleVars[1] /* z3 DISCRETE */))) * (x[indexOffset +0]);
    }
      return tmp8;
  }


  throw DYNError(Error::MODELER, UndefCalculatedVarI, iCalculatedVar);
}
#endif

void ModelTestSilentZ_Dyn::getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const
{
  if (iCalculatedVar == 0)  /* x */ {
    indexes.push_back(0);
  }
}

}