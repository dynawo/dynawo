//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file DYNModelManager.cpp
 *
 */

#include <cmath>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <vector>

#include <boost/archive/binary_iarchive.hpp>
#include <boost/archive/binary_oarchive.hpp>
#include <boost/serialization/vector.hpp>

#include "PARParametersSetFactory.h"
#include "PARParameter.h"

#include "DYNCommon.h"
#include "DYNMacrosMessage.h"
#include "DYNElement.h"
#include "DYNFileSystemUtils.h"
#include "DYNModelManager.h"

#include "DYNParameterModeler.h"
#include "DYNModelManagerCommon.h"
#include "DYNModelModelica.h"
#include "DYNSolverKINSubModel.h"
#include "DYNSparseMatrix.h"
#include "DYNTimer.h"
#include "DYNTrace.h"

using std::ifstream;
using std::map;
using std::ofstream;
using std::string;
using std::stringstream;
using std::vector;

using boost::dynamic_pointer_cast;
using boost::shared_ptr;

using parameters::ParametersSet;
using parameters::ParametersSetFactory;

namespace DYN {

ModelManager::ModelManager() :
SubModel(),
modelInit_(NULL),
modelDyn_(NULL),
dataInit_(new DYNDATA),
dataDyn_(new DYNDATA),
modelInitUsed_(false) { }

ModelManager::~ModelManager() {
  delete dataInit_;
  delete dataDyn_;
}

DYNDATA *
ModelManager::data() const {
  if (modelInitUsed_)
    return dataInit_;
  else
    return dataDyn_;
}

MODEL_DATA *
ModelManager::modelData() const {
  return data()->modelData;
}

SIMULATION_INFO *
ModelManager::simulationInfo() const {
  return data()->simulationInfo;
}

ModelModelica *
ModelManager::modelModelicaInit() const {
  if (hasInit())
    return modelInit_;
  else
    throw DYNError(Error::MODELER, NoInitModel, modelType(), name());
}

ModelModelica *
ModelManager::modelModelicaDynamic() const {
  return modelDyn_;
}

ModelModelica *
ModelManager::modelModelica() const {
  if (hasInit() && modelInitUsed_)
    return modelModelicaInit();
  else
    return modelModelicaDynamic();
}

void
ModelManager::initializeStaticData() {
  if (hasInit())
    modelInit_->initData(dataInit_);

  modelDyn_->initData(dataDyn_);
}

void
ModelManager::createParametersValueSet(const boost::unordered_map<string, ParameterModeler>& parameters, shared_ptr<ParametersSet> parametersSet) {
  for (ParamIterator it = parameters.begin(), itEnd = parameters.end(); it != itEnd; ++it) {
    const ParameterModeler& parameter = it->second;
    const string& parameterName = parameter.getName();

    if (parameter.hasValue()) {
      switch (parameter.getValueType()) {
        case VAR_TYPE_DOUBLE: {
          parametersSet->createParameter(parameterName, parameter.getValue<double>());
          break;
        }
        case VAR_TYPE_INT: {
          parametersSet->createParameter(parameterName, parameter.getValue<int>());
          break;
        }
        case VAR_TYPE_BOOL: {
          parametersSet->createParameter(parameterName, parameter.getValue<bool>());
          break;
        }
        case VAR_TYPE_STRING: {
          parametersSet->createParameter(parameterName, parameter.getValue<string>());
          break;
        }
        default:
        {
          throw DYNError(Error::MODELER, ParameterBadType, name());
        }
      }
    }
  }
}

void
ModelManager::initSubBuffers() {
  associateBuffers();
}

void
ModelManager::init(const double& t0) {
  // initialization of the dynamic model
  shared_ptr<ParametersSet> mergedParametersSet(ParametersSetFactory::newInstance("merged_" + name()));

  const boost::unordered_map<string, ParameterModeler>& parameters = getParametersDynamic();

  createParametersValueSet(parameters, mergedParametersSet);

  modelModelica()->setParameters(mergedParametersSet);

  // parameters (number and order = those of the .mo file)
  // --------------------------------------------------
  // apparently problem of scheduling of inits in WTO
  for (int i = 0; i < 2; ++i) {
    modelModelica()->initRpar();
  }

  getSize();

  setManagerTime(t0);
}

void
ModelManager::associateBuffers() {
  if (modelInitUsed_) {
    yLocalInit_.resize(dataInit_->nbVars);
    ypLocalInit_.resize(dataInit_->nbVars);
    zLocalInit_.resize(dataInit_->nbZ + dataInit_->modelData->nVariablesInteger);
    fLocalInit_.resize(dataInit_->nbF);

    dataInit_->localData[0]->realVars = static_cast<modelica_real*>(0);
    dataInit_->localData[0]->derivativesVars = static_cast<modelica_real*>(0);
    dataInit_->localData[0]->discreteVars = static_cast<modelica_real*>(0);

    if (!yLocalInit_.empty())
      dataInit_->localData[0]->realVars = &(yLocalInit_[0]);
    if (!ypLocalInit_.empty())
      dataInit_->localData[0]->derivativesVars = &(ypLocalInit_[0]);
    if (!zLocalInit_.empty())
      dataInit_->localData[0]->discreteVars = &(zLocalInit_[0]);

    if (dataInit_->modelData->nVariablesInteger > 0) {
      int offset = dataInit_->nbZ;
      dataInit_->localData[0]->integerDoubleVars = &(zLocalInit_[offset]);
    }
  } else {
    dataDyn_->localData[0]->realVars = &(yLocal_[0]);

    dataDyn_->localData[0]->derivativesVars = &(ypLocal_[0]);
    dataDyn_->localData[0]->discreteVars = &(zLocal_[0]);

    if (dataDyn_->modelData->nVariablesInteger > 0) {
      int offset = dataDyn_->nbZ;
      dataDyn_->localData[0]->integerDoubleVars = &(zLocal_[offset]);
    }
  }
}

void
ModelManager::getSize() {
  sizeF_ = data()->nbF;
  sizeZ_ = data()->nbZ + modelData()->nVariablesInteger;  ///< Z in dynawo = Z in Modelica + I in Modelica
  sizeG_ = modelData()->nZeroCrossings;
  sizeMode_ = data()->nbModes;
  sizeY_ = data()->nbVars;
  sizeCalculatedVar_ = data()->nbCalculatedVars;
  if (calculatedVars_.empty() && !modelInitUsed_)
    calculatedVars_.assign(sizeCalculatedVar_, 0);
}

void
ModelManager::evalF(double t, propertyF_t type) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelManager::evalF");
#endif
  setManagerTime(t);

  modelModelica()->setFomc(fLocal_, type);
}

void
ModelManager::checkDataCoherence(const double & t) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelManager::checkDataCoherence");
#endif

  setManagerTime(t);

  modelModelica()->checkDataCoherence();
}

void
ModelManager::checkParametersCoherence() const {
  modelModelica()->checkParametersCoherence();
}

void
ModelManager::setFequations() {
  modelModelicaDynamic()->setFequations(fEquationIndex_);
}

void
ModelManager::setGequations() {
  modelModelicaDynamic()->setGequations(gEquationIndex_);
}

void
ModelManager::setFequationsInit() {
  if (hasInit())
    modelModelicaInit()->setFequations(fEquationInitIndex_);
}

void
ModelManager::setGequationsInit() {
  if (hasInit())
    modelModelicaInit()->setGequations(gEquationInitIndex_);
}


#ifdef _ADEPT_

void
ModelManager::evalF(const double & t, const vector<adept::adouble> &y,
        const vector<adept::adouble> &yp, vector<adept::adouble> &f) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelManager::evalF adept");
#endif
  setManagerTime(t);

  modelModelica()->evalFAdept(y, yp, f);
#ifdef _DEBUG_
  for (unsigned int i = 0; i < sizeF(); i++) {
    double term = f[i].value();
    if (isnan(term) || isinf(term)) {
       throw DYNError(Error::MODELER, ResidualWithNanInf, name(), modelType(), staticId(), i, getFequationByLocalIndex(i));  // i is local index
    }
  }
#endif
}

void
ModelManager::evalJtAdept(const double& t, double *y, double * yp, const double & cj, SparseMatrix &Jt, const int& rowOffset, bool complete) {
  if (sizeY() == 0)
    return;

  try {
    const int nbInput = sizeY() + sizeY();  // Y and Y '
    const int nbOutput = sizeY();
    const int coeff = (complete) ? 1: 0;  // complete => jacobian @F/@y + cj.@F/@Y' else @F/@Y'
    vector<double> jac(nbInput * nbOutput);

    adept::Stack stack;
    stack.activate();
    vector<adept::adouble> x(sizeY());
    adept::set_values(&x[0], sizeY(), y);

    vector<adept::adouble> xp(sizeY());
    adept::set_values(&xp[0], sizeY(), yp);

    stack.new_recording();
    vector<adept::adouble> output(nbOutput);
    evalF(t, x, xp, output);
    stack.independent(&x[0], x.size());
    stack.independent(&xp[0], xp.size());
    stack.dependent(&output[0], nbOutput);
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
    Timer * timer1 = new Timer("zzz reading");
#endif
    stack.jacobian(&jac[0]);
    stack.pause_recording();
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
    delete timer1;
#endif

    int offsetJPrim = sizeY() * sizeY();
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
    Timer * timer3 = new Timer("zzz filling");
#endif

    for (unsigned int i = 0; i < sizeF(); ++i) {
      Jt.changeCol();
      for (unsigned int j = 0; j < sizeY(); ++j) {
        int indice = i + j * sizeY();
        double term = coeff * jac[indice] + cj * jac[indice + offsetJPrim];
#ifdef _DEBUG_
        if (isnan(term) || isinf(term)) {
          throw DYNError(Error::MODELER, JacobianWithNanInf, name(), modelType(), staticId(), i, getFequationByLocalIndex(i), j);   // i is local index
        }
#endif
        Jt.addTerm(j + rowOffset, term);
      }
    }

#if defined(_DEBUG_) || defined(PRINT_TIMERS)
    delete timer3;
#endif
  } catch (adept::stack_already_active & e) {
    std::cerr << "Error :" << e.what() << std::endl;
    throw DYNError(DYN::Error::MODELER, AdeptFailure);
  } catch (adept::autodiff_exception & e) {
    std::cerr << "Error :" << e.what() << std::endl;
    throw DYNError(DYN::Error::MODELER, AdeptFailure);
  }
}
#endif

void
ModelManager::evalG(const double & t) {
  setManagerTime(t);

  modelModelica()->setGomc(gLocal_);
}

void
ModelManager::evalJt(const double &t, const double & cj, SparseMatrix& jt, const int& rowOffset) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelManager::evalJ");
#endif

#if _ADEPT_
  evalJtAdept(t, yLocal_, ypLocal_, cj, jt, rowOffset, true);
#else
  // Assert when Adept wasn't used
  assert(0 && "evalJt : Adept not used");
#endif
}

void
ModelManager::evalJtPrim(const double &t, const double & cj, SparseMatrix& jt, const int& rowOffset) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelManager::evalJPrim");
#endif

#ifdef _ADEPT_
  evalJtAdept(t, yLocal_, ypLocal_, cj, jt, rowOffset, false);
#else
  // Assert when Adept wasn't used
  assert(0 && "evalJt : Adept not used");
#endif
}

void
ModelManager::evalZ(const double &t) {
  if (sizeZ() > 0) {
    setManagerTime(t);

    modelModelica()->setZomc();
  }
}

modeChangeType_t
ModelManager::evalMode(const double & t) {
  return modelModelica()->evalMode(t);
}

void
ModelManager::getY0() {
  simulationInfo()->initial = true;

  setManagerTime(getCurrentTime());

  if (!withLoadedVariables_) {
    modelModelica()->setY0omc();
  }
  simulationInfo()->initial = false;
}

void
ModelManager::evalYType() {
  modelModelica()->setYType_omc(yType_);
}

void
ModelManager::evalFType() {
  modelModelica()->setFType_omc(fType_);
}


void
ModelManager::collectSilentZ(bool* silentZTable) {
  modelModelica()->collectSilentZ(silentZTable);
}

void
ModelManager::setSharedParametersDefaultValues(const bool isInit, const parameterOrigin_t& origin) {
  ModelModelica * model = isInit ? modelModelicaInit() : modelModelicaDynamic();
  const shared_ptr<parameters::ParametersSet> sharedParametersInitialValues = model->setSharedParametersDefaultValues();
  const boost::unordered_map<string, ParameterModeler>& parameters = isInit ? getParametersInit() : getParametersDynamic();

  for (ParamIterator it = parameters.begin(), itEnd = parameters.end(); it != itEnd; ++it) {
    const ParameterModeler& currentParameter = it->second;
    const string& paramName = currentParameter.getName();

    if (currentParameter.isUnitary() && sharedParametersInitialValues->hasParameter(paramName)) {
      switch (currentParameter.getValueType()) {
      case VAR_TYPE_BOOL:
      {
        const bool value = sharedParametersInitialValues->getParameter(paramName)->getBool();
        setParameterValue(paramName, origin, value, isInit);
        break;
      }
      case VAR_TYPE_INT:
      {
        const int value = sharedParametersInitialValues->getParameter(paramName)->getInt();
        setParameterValue(paramName, origin, value, isInit);
        break;
      }
      case VAR_TYPE_DOUBLE:
      {
        const double& value = sharedParametersInitialValues->getParameter(paramName)->getDouble();
        setParameterValue(paramName, origin, value, isInit);
        break;
      }
      case VAR_TYPE_STRING:
      {
        const string& value = sharedParametersInitialValues->getParameter(paramName)->getString();
        setParameterValue(paramName, origin, value, isInit);
        break;
      }
      }
    }
  }
}

void
ModelManager::initParams() {
  if (!hasInit()) {
    modelInitUsed_ = false;
    return;  // no init model => nothing to do
  } else {
    modelInitUsed_ = true;
  }

  shared_ptr<ParametersSet> mergedParametersSet(ParametersSetFactory::newInstance("merged_" + name()));
  const boost::unordered_map<string, ParameterModeler>& parametersInit = getParametersInit();
  createParametersValueSet(parametersInit, mergedParametersSet);

  modelModelica()->setParameters(mergedParametersSet);

  // apparently problem of scheduling of inits in OMC
  for (int i = 0; i < 2; ++i) {
    modelModelica()->initRpar();
  }

  // init local sizes for init values
  getSize();

  // block init for calculation
  setManagerTime(getCurrentTime());

  associateBuffers();
  // call the parameter calculation method
  solveParameters();
  try {
    checkDataCoherence(getCurrentTime());
    checkParametersCoherence();
  } catch (const MessageError& Msg) {
    Trace::error() << Msg.what() << Trace::endline;
    throw DYNError(Error::MODELER, ErrorInit, modelType(), name());
  } catch (const Terminate& Msg) {
    Trace::error() << Msg.what() << Trace::endline;
    throw DYNError(Error::MODELER, ErrorInit, modelType(), name());
  } catch (const Error& Msg) {
    Trace::error() << Msg.what() << Trace::endline;
    throw DYNError(Error::MODELER, ErrorInit, modelType(), name());
  }

  modelInitUsed_ = false;
}

void
ModelManager::dumpParameters(map< string, string > & mapParameters) {
  stringstream parameters;
  boost::archive::binary_oarchive os(parameters);

  string cSum = "";
  string cSumInit = "";
  if (hasInit()) {
    modelModelicaInit()->checkSum(cSumInit);
  }

  modelModelicaDynamic()->checkSum(cSum);

  unsigned int nb = modelData()->nParametersReal;
  vector<double> params(nb, 0.);
  std::copy(simulationInfo()->realParameter, simulationInfo()->realParameter + nb, params.begin());

  nb = modelData()->nParametersBoolean;
  vector<bool> paramsBool(nb, false);
  std::copy(simulationInfo()->booleanParameter, simulationInfo()->booleanParameter + nb, paramsBool.begin());

  nb = modelData()->nParametersInteger;
  vector<int> paramsInt(nb, 0);
  std::copy(simulationInfo()->integerParameter, simulationInfo()->integerParameter + nb, paramsInt.begin());

  // same method can't be applied to string due to the implicit cast from
  // modelica_string to string
  vector<string> paramsString;
  for (unsigned int i = 0; i < modelData()->nParametersString; ++i)
    paramsString.push_back(simulationInfo()->stringParameter[i]);

  os << cSum;
  os << cSumInit;
  os << params;
  os << paramsBool;
  os << paramsInt;
  os << paramsString;

  mapParameters[ parametersFileName() ] = parameters.str();
}

void ModelManager::writeParametersFinalValues() {
  const boost::unordered_map<string, ParameterModeler>& parameters = getParametersDynamic();
  // in the OpenModelica-generated code
  // parameters are ordered as real first, then boolean, then integer
  const unsigned int nbParamsReal = modelData()->nParametersReal;
  const unsigned int nbParamsBool = modelData()->nParametersBoolean;
  const unsigned int nbParamsInt = modelData()->nParametersInteger;
  for (ParamIterator it = parameters.begin(), itEnd = parameters.end(); it != itEnd; ++it) {
    const ParameterModeler& currentParameter = it->second;
    unsigned int i = currentParameter.getIndex();
    const string& currentParameterName = currentParameter.getName();
    if (i < nbParamsReal) {
      const unsigned int localRealIndex = i;
      switch (currentParameter.getValueType()) {
        case VAR_TYPE_DOUBLE:
        {
          setFinalParameter(currentParameterName, simulationInfo()->realParameter[localRealIndex]);
          break;
        }
        case VAR_TYPE_INT:
        {
          setFinalParameter(currentParameterName, static_cast<int> (simulationInfo()->realParameter[localRealIndex]));
          break;
        }
        case VAR_TYPE_BOOL:
        {
          setFinalParameter(currentParameterName, toNativeBool(simulationInfo()->realParameter[localRealIndex]));
          break;
        }
        case VAR_TYPE_STRING:
        {
          throw DYNError(Error::MODELER, ParameterInvalidTypeRequested, currentParameter.getName(), typeVarC2Str(currentParameter.getValueType()), "DOUBLE");
        }
      }
    } else if (i < nbParamsReal + nbParamsBool) {
      const unsigned int localBooleanIndex = i - nbParamsReal;
      assert(localBooleanIndex < nbParamsBool);
      if (currentParameter.getValueType() != VAR_TYPE_BOOL)
        throw DYNError(Error::MODELER, ParameterInvalidTypeRequested, currentParameter.getName(), typeVarC2Str(currentParameter.getValueType()), "BOOL");

      setFinalParameter(currentParameterName, simulationInfo()->booleanParameter[localBooleanIndex]);
    } else if (i < nbParamsReal + nbParamsBool + nbParamsInt) {
      const unsigned int localIntegerIndex = i - nbParamsReal - nbParamsBool;
      assert(localIntegerIndex < nbParamsInt);
      if (currentParameter.getValueType() != VAR_TYPE_INT)
        throw DYNError(Error::MODELER, ParameterInvalidTypeRequested, currentParameter.getName(), typeVarC2Str(currentParameter.getValueType()), "INT");

      setFinalParameter(currentParameterName, simulationInfo()->integerParameter[localIntegerIndex]);
    }
  }
}

void ModelManager::getSubModelParameterValue(const string & nameParameter, double & value, bool & found) {
  found = hasParameterDynamic(nameParameter);
  if (found) {
    const ParameterModeler& parameter = findParameterDynamic(nameParameter);
    // check that the final parameters values have been filled : if not, fill them
    if (!parameter.hasOrigin(FINAL)) {
      writeParametersFinalValues();
    }

    value = parameter.getDoubleValue();
  }
}

void
ModelManager::dumpVariables(map< string, string > & mapVariables) {
  stringstream values;
  boost::archive::binary_oarchive os(values);

  string cSum = "";
  string cSumInit = "";
  if (hasInit()) {
    modelModelicaInit()->checkSum(cSumInit);
  }
  modelModelicaDynamic()->checkSum(cSum);

  unsigned int nb = modelData()->nVariablesReal;
  vector<double> valuesReal(nb, 0.);
  std::copy(data()->localData[0]->realVars, data()->localData[0]->realVars + nb, valuesReal.begin());

  vector<double> valuesDerivatives(nb, 0.);
  std::copy(data()->localData[0]->derivativesVars, data()->localData[0]->derivativesVars + nb, valuesDerivatives.begin());

  nb = modelData()->nVariablesBoolean;
  vector<bool> valuesBool(nb, false);
  std::copy(data()->localData[0]->booleanVars, data()->localData[0]->booleanVars + nb, valuesBool.begin());

  nb = modelData()->nVariablesInteger;
  vector<double> valuesInt(nb, 0);
  std::copy(data()->localData[0]->integerDoubleVars, data()->localData[0]->integerDoubleVars + nb, valuesInt.begin());

  nb = data()->nbZ;
  vector<double> valuesDiscreteReal(nb, 0.);
  std::copy(data()->localData[0]->discreteVars, data()->localData[0]->discreteVars + nb, valuesDiscreteReal.begin());

  vector<double> constCalcVars(data()->constCalcVars.size(), 0.);
  std::copy(data()->constCalcVars.begin(), data()->constCalcVars.end(), constCalcVars.begin());

  os << cSum;
  os << cSumInit;
  os << valuesReal;
  os << valuesBool;
  os << valuesInt;
  os << valuesDiscreteReal;
  os << valuesDerivatives;
  os << constCalcVars;

  mapVariables[ variablesFileName() ] = values.str();
}

void
ModelManager::loadVariables(const string &variables) {
  setManagerTime(getCurrentTime());
  stringstream vars(variables);

  boost::archive::binary_iarchive is(vars);
  string cSumRead;
  string cSumInitRead;
  string cSumInit;
  string cSum;
  vector<double> valuesReal;
  vector<bool> valuesBool;
  vector<double> valuesInt;
  vector<double> valuesDiscreteReal;
  vector<double> valuesDerivatives;
  vector<double> constCalcVars;

  is >> cSumRead;
  is >> cSumInitRead;

  is >> valuesReal;
  is >> valuesBool;
  is >> valuesInt;
  is >> valuesDiscreteReal;
  is >> valuesDerivatives;
  is >> constCalcVars;

  if (hasInit()) {
    modelModelicaInit()->checkSum(cSumInit);
  }
  modelModelicaDynamic()->checkSum(cSum);

  if (cSumRead != cSum || cSumInitRead != cSumInit)
    throw DYNError(Error::MODELER, WrongCheckSum, variablesFileName().c_str());

  if (static_cast<unsigned>(modelData()->nVariablesReal) != valuesReal.size())
    throw DYNError(Error::MODELER, WrongDataNum, variablesFileName().c_str());

  if (static_cast<unsigned>(modelData()->nVariablesInteger) != valuesInt.size())
    throw DYNError(Error::MODELER, WrongDataNum, variablesFileName().c_str());

  if (static_cast<unsigned>(modelData()->nVariablesBoolean) != valuesBool.size())
    throw DYNError(Error::MODELER, WrongDataNum, variablesFileName().c_str());

  if (static_cast<unsigned>(data()->nbZ) != valuesDiscreteReal.size())
    throw DYNError(Error::MODELER, WrongDataNum, variablesFileName().c_str());

  if (data()->constCalcVars.size() != constCalcVars.size())
    throw DYNError(Error::MODELER, WrongDataNum, variablesFileName().c_str());

  std::copy(valuesReal.begin(), valuesReal.end(), data()->localData[0]->realVars);
  std::copy(valuesDerivatives.begin(), valuesDerivatives.end(), data()->localData[0]->derivativesVars);
  std::copy(valuesInt.begin(), valuesInt.end(), data()->localData[0]->integerDoubleVars);
  std::copy(valuesBool.begin(), valuesBool.end(), data()->localData[0]->booleanVars);
  std::copy(valuesDiscreteReal.begin(), valuesDiscreteReal.end(), data()->localData[0]->discreteVars);
  std::copy(constCalcVars.begin(), constCalcVars.end(), data()->constCalcVars.begin());
}

void
ModelManager::loadParameters(const string & parameters) {
  stringstream params(parameters);

  boost::archive::binary_iarchive is(params);

  string cSumRead;
  string cSumInitRead;
  vector<double> parameterDoubleValues;
  vector<bool> parameterBoolValues;
  vector<int> parameterIntValues;
  vector<string> parameterStringValues;
  is >> cSumRead;
  is >> cSumInitRead;

  is >> parameterDoubleValues;
  is >> parameterBoolValues;
  is >> parameterIntValues;
  is >> parameterStringValues;

  string cSum = "";
  string cSumInit = "";
  if (hasInit()) {
    modelModelicaInit()->checkSum(cSumInit);
  }

  modelModelicaDynamic()->checkSum(cSum);

  if (cSumRead != cSum || cSumInitRead != cSumInit)
    throw DYNError(Error::MODELER, WrongCheckSum, parametersFileName().c_str());

  if (parameterDoubleValues.size() != static_cast<unsigned>(modelData()->nParametersReal))
    throw DYNError(Error::MODELER, WrongDataNum, parametersFileName().c_str());

  if (parameterBoolValues.size() != static_cast<unsigned>(modelData()->nParametersBoolean))
    throw DYNError(Error::MODELER, WrongDataNum, parametersFileName().c_str());

  if (parameterIntValues.size() != static_cast<unsigned>(modelData()->nParametersInteger))
    throw DYNError(Error::MODELER, WrongDataNum, parametersFileName().c_str());

  if (parameterStringValues.size() != static_cast<unsigned>(modelData()->nParametersString))
    throw DYNError(Error::MODELER, WrongDataNum, parametersFileName().c_str());

  // loading of read parameters
  for (unsigned int i = 0; i < parameterStringValues.size(); ++i)
    simulationInfo()->stringParameter[i] = parameterStringValues[i].c_str();

  // copy of loaded parameters in the map
  const boost::unordered_map<string, ParameterModeler>& parametersMap = (this)->getParametersDynamic();
  // We need ordered parameters as Modelica structures are ordered in a certain way and we want to stick to this order to recover the param
  vector<ParameterModeler> parametersList(parametersMap.size(), ParameterModeler("TMP", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  for (ParamIterator it = parametersMap.begin(), itEnd = parametersMap.end(); it != itEnd; ++it) {
    const ParameterModeler& currentParameter = it->second;
    parametersList[currentParameter.getIndex()] = currentParameter;
  }
  for (unsigned int i = 0; i < modelData()->nParametersReal; ++i) {
    const ParameterModeler& currentParameter = parametersList[i];
    switch (currentParameter.getValueType()) {
      case VAR_TYPE_DOUBLE:
      {
        setLoadedParameter(currentParameter.getName(), parameterDoubleValues[i]);
        break;
      }
      case VAR_TYPE_INT:
      {
        setLoadedParameter(currentParameter.getName(), static_cast<int> (parameterDoubleValues[i]));
        break;
      }
      case VAR_TYPE_BOOL:
      {
        setLoadedParameter(currentParameter.getName(), toNativeBool(parameterDoubleValues[i]));
        break;
      }
      case VAR_TYPE_STRING:
      {
        throw DYNError(Error::MODELER, ParameterInvalidTypeRequested, currentParameter.getName(), typeVarC2Str(currentParameter.getValueType()), "DOUBLE");
      }
    }
  }
  unsigned int offset = modelData()->nParametersReal;
  for (unsigned int i = 0; i < modelData()->nParametersBoolean; ++i) {
    setLoadedParameter(parametersList[i + offset].getName(), parameterBoolValues[i]);
  }
  offset += modelData()->nParametersBoolean;
  for (unsigned int i = 0; i < modelData()->nParametersInteger; ++i) {
    setLoadedParameter(parametersList[i + offset].getName(), parameterIntValues[i]);
  }
  offset += modelData()->nParametersInteger;
  for (unsigned int i = 0; i < modelData()->nParametersString; ++i) {
    setLoadedParameter(parametersList[i + offset].getName(), parameterStringValues[i]);
  }
}

void
ModelManager::solveParameters() {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("ModelManager::solveParameters");
#endif
  Trace::debug() << "------------------------------" << Trace::endline;
  Trace::debug() << DYNLog(SolveParameters, name()) << Trace::endline;

  // values recovery and modes initialization
  double t0 = getCurrentTime();
  vector<double> zSave(sizeZ(), 0.);
  double* y = static_cast<double*>(0);
  double* yp = static_cast<double*>(0);
  double* z = static_cast<double*>(0);
  bool* zConnected = static_cast<bool*>(0);
  double* f = static_cast<double*>(0);
  if (!yLocalInit_.empty())
    y = &yLocalInit_[0];
  if (!ypLocalInit_.empty())
    yp = &ypLocalInit_[0];
  if (!zLocalInit_.empty())
    z = &zLocalInit_[0];
  if (!fLocalInit_.empty())
    f = &fLocalInit_[0];
  setBufferY(y, yp, 0);
  setBufferZ(z, zConnected, 0);
  setBufferF(f, 0);
  getY0();

  // computation of initial jroot, allow to find the correct value initial value of Z
  vector<state_g> g0(sizeG(), NO_ROOT);
  vector<state_g> g1(sizeG(), NO_ROOT);
  state_g* g0Safe = static_cast<state_g*>(0);
  state_g* g1Safe = static_cast<state_g*>(0);
  if (!g0.empty())
    g0Safe = &g0[0];
  if (!g1.empty())
    g1Safe = &g1[0];
  setBufferG(g0Safe, 0);

  evalG(t0);

  // computation of Z values
  evalZ(t0);

  // we loop until we find stable initial values (handle of dependencies Z->Y, Y->Z)
  bool stableRoot = true;
  bool zChange = false;
  int compteur = 0;

  // test init model size
  if (sizeY() != sizeF())
    throw DYNError(Error::MODELER, SolverSubModelYvsF, name(), sizeY(), sizeF());

  SolverKINSubModel solver;
  solver.init(this, t0, y, f);
  int flag = KIN_SUCCESS;
  do {
    zSave = zLocalInit_;
    if (sizeMode() > 0)
      evalMode(t0);

    setBufferG(g0Safe, 0);
    evalG(t0);

    try {
      flag = solver.solve();
    } catch (const MessageError& Msg) {
      Trace::error() << Msg.what() << Trace::endline;
      throw DYNError(Error::MODELER, ErrorInit, modelType(), name());
    } catch (const Terminate& Msg) {
      Trace::error() << Msg.what() << Trace::endline;
      throw DYNError(Error::MODELER, ErrorInit, modelType(), name());
    } catch (const Error& Msg) {
      Trace::error() << Msg.what() << Trace::endline;
      throw DYNError(Error::MODELER, ErrorInit, modelType(), name());
    }

    // Detection of potential root crossing
    setBufferG(g1Safe, 0);
    // Root evaluation after reinitialization
    // ---------------------------------------------
    evalG(t0);

    // Detection of potential root crossing
    // ----------------------------------------------
    stableRoot = std::equal(g0.begin(), g0.end(), g1.begin());
#ifdef _DEBUG_
    if (!stableRoot) {
      vector<state_g>::const_iterator iG0(g0.begin());
      vector<state_g>::const_iterator iG1(g1.begin());
      int i = 0;
      for (; iG0 < g0.end(); ++iG0, ++iG1) {
        ++i;
        if ((*iG0) != (*iG1)) {
          Trace::debug() << DYNLog(UnstableRoot, i) << Trace::endline;
        }
      }
    }
#endif

    // if a root crossing is detected, update z and modes
    // -------------------------------------------------
    if (!stableRoot) {
      Trace::debug() << DYNLog(UnstableRootFound) << Trace::endline;
      evalZ(t0);

      if (sizeMode() > 0) {
        evalMode(t0);
      }
    } else {
      // case of function to compute discrete variables (used to transform for example)
      evalZ(t0);
    }

    zChange = (zSave != zLocalInit_);

    ++compteur;
    if ( compteur >= 10)
      throw  DYNError(Error::MODELER, UnstableRoots);
  } while (!stableRoot || zChange);
  if (flag < 0)
    Trace::warn() << DYNLog(SolveParametersError, name()) << Trace::endline;

#ifdef _DEBUG_
  setFequationsInit();
  double tolerance = 1e-4;
  const unsigned nbErr = 10;

  map<double, int> fErr;
  for (unsigned int i = 0; i < fLocalInit_.size(); ++i) {
    if (fabs(f[i]) > tolerance) {
      fErr.insert(std::make_pair(f[i], i));
    }
  }

  if (fErr.size() > 0) {
    unsigned i = 0;
    for (map<double, int>::const_iterator it = fErr.begin(); it != fErr.end() && i < nbErr; ++it, ++i) {
      Trace::debug() << DYNLog(SolveParametersFError, tolerance, it->second, it->first,
                                 getFequationByLocalIndex(it->second)) << Trace::endline;
    }
  }
#endif

  // copy of computed values in the parameters
  vector<double> calculatedVars(sizeCalculatedVar_, 0);
  modelModelica()->evalCalculatedVars(calculatedVars);
  setCalculatedParameters(yLocalInit_, zLocalInit_, calculatedVars);
  solver.clean();

  Trace::debug() << DYNLog(SolveParametersOK, name()) << Trace::endline;
}

void
ModelManager::setCalculatedParameters(vector<double>& y, vector<double>& z, const vector<double>& calculatedVars) {
  // Creates reversed alias map
  map<string, vector< shared_ptr <VariableAlias> > > reversedAlias;
  for (map<string, shared_ptr<Variable> >::const_iterator it = variablesByNameInit_.begin();
          it != variablesByNameInit_.end();
          ++it) {
    // map of nativeVarName -> aliasNames
    if (it->second->isAlias()) {
      const shared_ptr <VariableAlias> variable = dynamic_pointer_cast <VariableAlias> (it->second);
      const string& referenceVariableName = variable->getReferenceVariableName();
      if (reversedAlias.find(referenceVariableName) == reversedAlias.end()) {
        // First time the alias name is seen
        reversedAlias[referenceVariableName] = vector< shared_ptr <VariableAlias> >(1, variable);
      } else {
        // Alias value already exists
        reversedAlias[referenceVariableName].push_back(variable);
      }
    }
  }
  // Set calculated parameters
  setYCalculatedParameters(y, reversedAlias);
  setZCalculatedParameters(z, reversedAlias);
  createCalculatedParametersFromInitialCalculatedVariables(calculatedVars, reversedAlias);
  setInitialCalculatedParameters();
}

void
ModelManager::setYCalculatedParameters(vector<double>& y,
    const map<string, vector< shared_ptr <VariableAlias> > >& reversedAlias) {
  const vector<string>& xNamesInitial = xNamesInit();

  assert(xNamesInitial.size() == y.size());
  for (unsigned int i = 0; i < xNamesInitial.size(); ++i) {
    setCalculatedParameter(xNamesInitial[i], y[i]);
    // Export alias
    if (reversedAlias.find(xNamesInitial[i]) != reversedAlias.end()) {
      vector< shared_ptr <VariableAlias> > variables = reversedAlias.find(xNamesInitial[i])->second;
      for (vector< shared_ptr <VariableAlias> >::const_iterator it = variables.begin();
          it != variables.end();
          ++it) {
        if (!(*it)->getNegated()) {  // Usual alias
          setCalculatedParameter((*it)->getName(), y[i]);
        } else {  // Negated alias
          setCalculatedParameter((*it)->getName(), -y[i]);
        }
      }
    }
  }
}

void
ModelManager::setZCalculatedParameters(vector<double>& z,
    const map<string, vector< shared_ptr <VariableAlias> > >& reversedAlias) {
  const vector<string>& zNamesInitial = zNamesInit();

  const map<string, shared_ptr<Variable> >& initVariables = variablesByNameInit();

  assert(zNamesInitial.size() == z.size());
  for (unsigned int i = 0; i < zNamesInitial.size(); ++i) {
    bool toConvertToBool = false;  // whether the variable is a Modelica boolean (described through discrete Real) and should be converted back to C++ boolean
    bool toConvertToInt = false;  // whether the variable is a Modelica integer
    const string& varName = zNamesInitial[i];

    // check whether the variable is an alias (in order to determine whether it is a boolean variable)
    string varNameForCheck = varName;
    if ((initVariables.find(varName) == initVariables.end()) && (reversedAlias.find(varName) != reversedAlias.end())) {
      vector< shared_ptr <VariableAlias> > variables = reversedAlias.find(varName)->second;
      for (vector< shared_ptr <VariableAlias> >::const_iterator it = variables.begin();
          it != variables.end();
          ++it) {
        const string& tmpVarName = (*it)->getName();
        if (initVariables.find(tmpVarName) != initVariables.end()) {
          varNameForCheck = tmpVarName;
          break;
        }
      }
    }

    // Check whether there is a need to convert the variable to native boolean or to an integer
    if (initVariables.find(varNameForCheck) != initVariables.end()) {
      const shared_ptr <Variable> var = initVariables.find(varNameForCheck)->second;
      toConvertToBool = (var->getType() == BOOLEAN);
      toConvertToInt = (var->getType() == INTEGER);
    }

    // a ternary operator does not work here, because the types of toNativeBool(z[i]) and z[i] are different
    // as a result, toNativeBool(z[i]) would be cast as a double, leading to a downstream error ("expected bool, got double")
    if (toConvertToBool) {
      setCalculatedParameter(varName, toNativeBool(z[i]));
    } else if (toConvertToInt) {
      setCalculatedParameter(varName, static_cast<int> (z[i]));
    } else {
      setCalculatedParameter(varName, z[i]);
    }


    // Export alias
    if (reversedAlias.find(varName) != reversedAlias.end()) {
      vector< shared_ptr <VariableAlias> > variables = reversedAlias.find(varName)->second;
      for (vector< shared_ptr <VariableAlias> >::const_iterator it = variables.begin();
          it != variables.end();
          ++it) {
        const double zVal = (*it)->getNegated() ? - z[i] : z[i];
        if (toConvertToBool) {
          setCalculatedParameter((*it)->getName(), toNativeBool(zVal));
        } else if (toConvertToInt) {
          setCalculatedParameter((*it)->getName(), static_cast<int> (zVal));
        } else {
          setCalculatedParameter((*it)->getName(), zVal);
        }
      }
    }
  }
}

void
ModelManager::setInitialCalculatedParameters() {
  const boost::unordered_map<string, ParameterModeler>& parametersMap = getParametersInit();
  // We need ordered parameters as Modelica structures are ordered in a certain way and we want to stick to this order to recover the param
  vector<ParameterModeler> parametersInitial(parametersMap.size(), ParameterModeler("TMP", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  for (ParamIterator it = parametersMap.begin(), itEnd = parametersMap.end(); it != itEnd; ++it) {
    const ParameterModeler& currentParameter = it->second;
    parametersInitial[currentParameter.getIndex()] = currentParameter;
  }
  // Copy init parameters
  assert(parametersInitial.size() == (unsigned int) (modelData()->nParametersReal + modelData()->nParametersBoolean + modelData()->nParametersInteger + modelData()->nParametersString));   // NOLINT(whitespace/line_length)
  for (unsigned int i = 0; i < modelData()->nParametersReal; ++i) {
    const string& parName = parametersInitial[i].getName();

    if (hasParameterDynamic(parName)) {
      const ParameterModeler& parameter = findParameterDynamic(parName);
      if (!parameter.isFullyInternal()) {
        // ternary operator does not work here (because the boolean would be implicitly converted to double, leading to a downstream parameter type error)
        switch (parameter.getValueType()) {
        case VAR_TYPE_DOUBLE:
        {
          setCalculatedParameter(parName, simulationInfo()->realParameter[i]);
          break;
        }
        case VAR_TYPE_INT:
        {
          setCalculatedParameter(parName, static_cast<int> (simulationInfo()->realParameter[i]));
          break;
        }
        case VAR_TYPE_BOOL:
        {
          setCalculatedParameter(parName, toNativeBool(simulationInfo()->realParameter[i]));
          break;
        }
        case VAR_TYPE_STRING:
        {
          throw DYNError(Error::MODELER, ParameterInvalidTypeRequested, parName, typeVarC2Str(parameter.getValueType()), "DOUBLE");
        }
        }
      }
    }
  }
  int offset = modelData()->nParametersReal;
  for (unsigned int i = 0; i < modelData()->nParametersBoolean; ++i) {
    const string& parName = parametersInitial[i + offset].getName();
    if (hasParameterDynamic(parName)) {
      const ParameterModeler& parameter = findParameterDynamic(parName);
      if (!parameter.isFullyInternal()) {
        setCalculatedParameter(parName, simulationInfo()->booleanParameter[i]);
      }
    }
  }

  offset += modelData()->nParametersBoolean;
  for (unsigned int i = 0; i < modelData()->nParametersInteger; ++i) {
    const string& parName = parametersInitial[i + offset].getName();
    if (hasParameterDynamic(parName)) {
      const ParameterModeler& parameter = findParameterDynamic(parName);
      if (!parameter.isFullyInternal()) {
        setCalculatedParameter(parName, static_cast<int> (simulationInfo()->integerParameter[i]));
      }
    }
  }

  offset += modelData()->nParametersInteger;
  for (unsigned int i = 0; i < modelData()->nParametersString; ++i) {
    const string& parName = parametersInitial[i + offset].getName();
    if (hasParameterDynamic(parName)) {
      const ParameterModeler& parameter = findParameterDynamic(parName);
      if (!parameter.isFullyInternal()) {
        setCalculatedParameter(parName, simulationInfo()->stringParameter[i]);
      }
    }
  }
}

void
ModelManager::createCalculatedParametersFromInitialCalculatedVariables(const vector<double>& calculatedVars,
    const map<string, vector< shared_ptr <VariableAlias> > >& reversedAlias) {
  const vector<string>& calcVarInitial = getCalculatedVarNamesInit();

  assert(calcVarInitial.size() == calculatedVars.size());
  for (unsigned int i = 0; i < calcVarInitial.size(); ++i) {
    setCalculatedParameter(calcVarInitial[i], calculatedVars[i]);
    // Export alias
    if (reversedAlias.find(calcVarInitial[i]) != reversedAlias.end()) {
      vector< shared_ptr <VariableAlias> > variables = reversedAlias.find(calcVarInitial[i])->second;
      for (vector< shared_ptr <VariableAlias> >::const_iterator it = variables.begin();
          it != variables.end();
          ++it) {
        if (!(*it)->getNegated()) {  // Usual alias
          setCalculatedParameter((*it)->getName(), calculatedVars[i]);
        } else {  // Negated alias
          setCalculatedParameter((*it)->getName(), -calculatedVars[i]);
        }
      }
    }
  }
}

void
ModelManager::printInitValues(const string & directory) {
  const string& fileName = absolute("dumpInitValues-" + name() + ".txt", directory);

  std::ofstream file;
  file.open(fileName.c_str());
  file << " ====== INIT VARIABLES VALUES ======\n";
  const vector<string>& xNames = (*this).xNames();
  for (unsigned int i = 0; i < sizeY(); ++i)
    file << std::setw(50) << std::left << xNames[i] << std::right << ": y =" << std::setw(15) << DYN::double2String(yLocal_[i])
      << " yp =" << std::setw(15) << DYN::double2String(ypLocal_[i]) << "\n";

  const vector<std::pair<string, string> >& xAliasesNames = (*this).xAliasesNames();
  for (unsigned int i = 0, iEnd = xAliasesNames.size(); i < iEnd; ++i)
    file << std::setw(50) << std::left << xAliasesNames[i].first << std::right << ": alias of " << xAliasesNames[i].second << "\n";

  if (sizeCalculatedVar() > 0) {
    evalCalculatedVars();
    file << " ====== INIT CALCULATED VARIABLES VALUES ======\n";
    const vector<string>& calculatedVarNames = (*this).getCalculatedVarNames();
    for (unsigned int i = 0, iEnd = sizeCalculatedVar(); i < iEnd; ++i)
      file << std::setw(50) << std::left << calculatedVarNames[i] << std::right << ": y ="
        << std::setw(15) << DYN::double2String(getCalculatedVar(i)) << "\n";
  }

  const vector<string>& zNames = (*this).zNames();
  file << " ====== INIT DISCRETE VARIABLES VALUES ======\n";
  for (unsigned int i = 0; i < sizeZ(); ++i)
    file << std::setw(50) << std::left << zNames[i] << std::right << ": z =" << std::setw(15) << DYN::double2String(zLocal_[i]) << "\n";

  const vector<std::pair<string, string> >& zAliasesNames = (*this).zAliasesNames();
  for (unsigned int i = 0, iEnd = zAliasesNames.size(); i < iEnd; ++i)
    file << std::setw(50) << std::left << zAliasesNames[i].first << std::right << ": alias of " << zAliasesNames[i].second << "\n";

  file << " ====== PARAMETERS VALUES ======\n";
  const boost::unordered_map<string, ParameterModeler>& parametersMap = (*this).getParametersDynamic();
  // We need ordered parameters as Modelica structures are ordered in a certain way and we want to stick to this order to recover the param
  vector<ParameterModeler> parameters(parametersMap.size(), ParameterModeler("TMP", VAR_TYPE_DOUBLE, EXTERNAL_PARAMETER));
  for (ParamIterator it = parametersMap.begin(), itEnd = parametersMap.end(); it != itEnd; ++it) {
    const ParameterModeler& currentParameter = it->second;
    parameters[currentParameter.getIndex()] = currentParameter;
  }

  // In Modelica models, parameters are ordered as follows : real, then boolean, integer and string
  for (unsigned int i = 0; i < modelData()->nParametersReal; ++i)
    file << std::setw(50) << std::left << parameters[i].getName() << std::right << " =" << std::setw(15)
      << DYN::double2String(simulationInfo()->realParameter[i]) << "\n";

  int offset = modelData()->nParametersReal;

  for (unsigned int i = 0; i < modelData()->nParametersBoolean; ++i)
    file << std::setw(50) << std::left << parameters[i + offset].getName() << std::right << " =" << std::setw(15)
    << std::boolalpha << static_cast<bool> (simulationInfo()->booleanParameter[i]) << "\n";

  offset += modelData()->nParametersBoolean;
  for (unsigned int i = 0; i < modelData()->nParametersInteger; ++i)
    file << std::setw(50) << std::left << parameters[i + offset].getName() << std::right << " =" << std::setw(15)
    << (simulationInfo()->integerParameter[i]) << "\n";

  offset += modelData()->nParametersInteger;
  for (unsigned int i = 0; i < modelData()->nParametersString; ++i)
    file << std::setw(50) << std::left << parameters[i + offset].getName() << std::right << " =" << std::setw(15)
    << (simulationInfo()->stringParameter[i]) << "\n";

  file.close();
}

string ModelManager::modelType() const {
  return modelType_;
}

void
ModelManager::rotateBuffers() {
  // copy data()->localData[0]->realVars -> simulationInfo()->realVarsPre
  if (modelData()->nVariablesReal > 0)
    memcpy(simulationInfo()->realVarsPre, data()->localData[0]->realVars, sizeof (data()->localData[0]->realVars[0]) * modelData()->nVariablesReal);

  // copy data()->localData[0]->booleanVars -> simulationInfo()->booleanVarsPre
  if ( modelData()->nVariablesBoolean > 0)
    memcpy(simulationInfo()->booleanVarsPre, data()->localData[0]->booleanVars, sizeof (data()->localData[0]->booleanVars[0]) * modelData()->nVariablesBoolean);

  // copy  data()->localData[0]->discreteVars -> simulationInfo()->discreteVarsPre
  if ( data()->nbZ > 0)
    memcpy(simulationInfo()->discreteVarsPre, data()->localData[0]->discreteVars, sizeof (data()->localData[0]->discreteVars[0]) * data()->nbZ);

  if ( modelData()->nVariablesInteger > 0)
    memcpy(simulationInfo()->integerDoubleVarsPre, data()->localData[0]->integerDoubleVars,
           sizeof (data()->localData[0]->integerDoubleVars[0]) * modelData()->nVariablesInteger);

  if (modelData()->nRelations > 0)
    memcpy(simulationInfo()->relationsPre, simulationInfo()->relations, sizeof (simulationInfo()->relations[0]) * modelData()->nRelations);
}

void
ModelManager::defineVariablesInit(vector<shared_ptr<Variable> >& variables) {
  if (!hasInit())
    return;
  modelInit_->defineVariables(variables);
}

void
ModelManager::defineParametersInit(vector<ParameterModeler>& parameters) {
  if (!hasInit())
    return;

  modelInit_->defineParameters(parameters);
}

void
ModelManager::defineVariables(vector<shared_ptr<Variable> >& variables) {
  modelDyn_->defineVariables(variables);
}

void
ModelManager::defineParameters(vector<ParameterModeler>& parameters) {
  modelDyn_->defineParameters(parameters);
}

void
ModelManager::defineElements(vector<Element> &elements, map<string, int>& mapElement) {
  modelDyn_->defineElements(elements, mapElement);
}

void
ModelManager::setManagerTime(const double & st) {
  data()->localData[0]->timeValue = st;
}

void
ModelManager::evalCalculatedVars() {
  modelModelica()->evalCalculatedVars(calculatedVars_);
}

double
ModelManager::evalCalculatedVarI(unsigned iCalculatedVar) const {
  return modelModelica()->evalCalculatedVarI(iCalculatedVar);
}

void
ModelManager::evalJCalculatedVarI(unsigned iCalculatedVar, std::vector<double>& res) const {
#if _ADEPT_
  try {
    std::vector<int> indexes;
    getIndexesOfVariablesUsedForCalculatedVarI(iCalculatedVar, indexes);
    size_t size = indexes.size();
    assert(res.size() == size);
    size_t nbInput = size;

    adept::Stack stack;
    stack.activate();
    vector<adept::adouble> x(nbInput);
    vector<adept::adouble> xp(nbInput);
    for (size_t i = 0; i < size; ++i) {
      x[i] = yLocal_[indexes[i]];
      xp[i] = ypLocal_[indexes[i]];
    }

    stack.new_recording();
    adept::adouble output = modelModelica()->evalCalculatedVarIAdept(iCalculatedVar, 0, x, xp);
    output.set_gradient(1.0);
    stack.compute_adjoint();
    for (size_t i = 0; i < size; ++i) {
      res[i] = x[i].get_gradient();
    }
    stack.pause_recording();
  } catch (adept::stack_already_active & e) {
    std::cerr << "Error :" << e.what() << std::endl;
    throw DYNError(DYN::Error::MODELER, AdeptFailure);
  } catch (adept::autodiff_exception & e) {
    std::cerr << "Error :" << e.what() << std::endl;
    throw DYNError(DYN::Error::MODELER, AdeptFailure);
  }
#else
  // Assert when Adept wasn't used
  assert(0 && "evalJCalculatedVarI : Adept not used");
#endif
}

void
ModelManager::getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const {
  return  modelModelica()->getIndexesOfVariablesUsedForCalculatedVarI(iCalculatedVar, indexes);
}

void
ModelManager::initializeFromData(const boost::shared_ptr<DataInterface>& /*data*/) {
  // not needed
}

}  // namespace DYN
