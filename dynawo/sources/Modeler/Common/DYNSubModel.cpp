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
 * @file  DYNSubModel.cpp
 *
 * @brief implementation file
 *
 */
#include <iomanip>
#include <iostream>
#include <fstream>
#include <algorithm>  // std::find, std::copy
#ifdef _DEBUG_
#include <assert.h>
#endif
#include <boost/pointer_cast.hpp>
#include <boost/algorithm/string/split.hpp>
#include <boost/algorithm/string.hpp>

#include "TLTimeline.h"
#include "CSTRConstraintsCollection.h"
#include "CRVCurve.h"
#include "PARParametersSet.h"
#include "PARParameter.h"

#include "DYNSubModel.h"
#include "DYNVariableNative.h"
#include "DYNVariableAlias.h"
#include "DYNParameterModeler.h"
#include "DYNModel.h"
#include "DYNSparseMatrix.h"
#include "DYNSubModelFactory.h"
#include "DYNTrace.h"
#include "DYNMacrosMessage.h"
#include "DYNElement.h"
#include "DYNTimer.h"
#include "DYNDataInterface.h"

using std::ofstream;
using std::stringstream;
using std::vector;
using std::map;
using boost::unordered_map;
using std::string;
using boost::shared_ptr;
using boost::dynamic_pointer_cast;

using timeline::Timeline;
using constraints::ConstraintsCollection;
using curves::Curve;

namespace DYN {

SubModel::SubModel() {
  yDeb_ = 0;
  zDeb_ = 0;
  modeDeb_ = 0;
  fDeb_ = 0;
  gDeb_ = 0;
  initialized_ = false;
  fLocal_ = NULL;
  yLocal_ = NULL;
  ypLocal_ = NULL;
  gLocal_ = NULL;
  zLocal_ = NULL;
  variables_.clear();
  parametersDynamic_.clear();
  variablesInit_.clear();
  parametersInit_.clear();
  withLoadedParameters_ = false;
  withLoadedVariables_ = false;
  sizeG_ = 0;
  sizeGSave_ = 0;
  gLocalSave_ = NULL;
  sizeF_ = 0;
  sizeFSave_ = 0;
  fLocalSave_ = NULL;
  fType_ = NULL;
  sizeYSave_ = 0;
  yType_ = NULL;
  yLocalSave_ = NULL;
  sizeY_ = 0;
  ypLocalSave_ = NULL;
  zLocalSave_ = NULL;
  sizeZ_ = 0;
  sizeZSave_ = 0;
  sizeCalculatedVar_ = 0;
  sizeCalculatedVarSave_ = 0;
  isInitProcess_ = false;
  sizeMode_ = 0;
  sizeModeSave_ = 0;
  currentTime_ = 0.;
  modeChange_ = false;
  modeChangeType_ = NO_MODE;
}

SubModel::~SubModel() {
}

void
SubModel::initStaticData() {
  initializeStaticData();
}

void
SubModel::initFromData(const shared_ptr<DataInterface>& data) {
  initializeFromData(data);
}

void
SubModel::setTimeline(const shared_ptr<Timeline>& timeline) {
  timeline_ = timeline;
}

void
SubModel::setConstraints(const shared_ptr<ConstraintsCollection>& constraints) {
  constraints_ = constraints;
}

void
SubModel::setWorkingDirectory(const string& workingDirectory) {
  workingDirectory_ = workingDirectory;
}

void
SubModel::saveData() {
  sizeFSave_ = sizeF_;
  sizeZSave_ = sizeZ_;
  sizeGSave_ = sizeG_;
  sizeModeSave_ = sizeMode_;
  sizeYSave_ = sizeY_;
  sizeCalculatedVarSave_ = sizeCalculatedVar_;
  fLocalSave_ = fLocal_;
  gLocalSave_ = gLocal_;
  yLocalSave_ = yLocal_;
  ypLocalSave_ = ypLocal_;
  zLocalSave_ = zLocal_;
}

void
SubModel::restoreData() {
  sizeF_ = sizeFSave_;
  sizeZ_ = sizeZSave_;
  sizeG_ = sizeGSave_;
  sizeMode_ = sizeModeSave_;
  sizeY_ = sizeYSave_;
  sizeCalculatedVar_ = sizeCalculatedVarSave_;
  fLocal_ = fLocalSave_;
  gLocal_ = gLocalSave_;
  yLocal_ = yLocalSave_;
  ypLocal_ = ypLocalSave_;
  zLocal_ = zLocalSave_;
}

void
SubModel::initSub(const double& t0) {
  setCurrentTime(t0);

  if (!withLoadedParameters_) {
    saveData();
    initParams();
    restoreData();
  }

  init(t0);

#ifdef _DEBUG_
  if (readPARParameters_) {
    vector<string> unusedParamNameList = readPARParameters_->getParamsUnused();
    for (vector<string>::iterator it = unusedParamNameList.begin();
            it != unusedParamNameList.end();
            ++it) {
      Trace::debug() << DYNLog(ParamUnused, *it, name()) << Trace::endline;
    }
  }
#endif
}

void
SubModel::setPARParameters(const boost::shared_ptr<parameters::ParametersSet>& params) {
  readPARParameters_ = params;
}

void
SubModel::loadParameters(const map< string, string > & mapParameters) {
  map<string, string >::const_iterator iter = mapParameters.find(parametersFileName());

  if (iter != mapParameters.end()) {
    withLoadedParameters_ = true;
    loadParameters(iter->second);
  }
}

void
SubModel::loadVariables(const map<string, string>& mapVariables) {
  map<string, string >::const_iterator iter = mapVariables.find(variablesFileName());

  if (iter != mapVariables.end()) {
    withLoadedVariables_ = true;
    loadVariables(iter->second);
  }
}

void
SubModel::initSize(int &sizeYGlob, int &sizeZGlob, int& sizeModeGlob, int & sizeFGlob, int & sizeGGlob) {
  getSize();

  yDeb_ = sizeYGlob;
  zDeb_ = sizeZGlob;
  modeDeb_ = sizeModeGlob;
  fDeb_ = sizeFGlob;
  gDeb_ = sizeGGlob;

  sizeYGlob += sizeY_;
  sizeZGlob += sizeZ_;
  sizeModeGlob += sizeMode_;
  sizeFGlob += sizeF_;
  sizeGGlob += sizeG_;
}

void
SubModel::defineElements() {
  elements_.clear();
  mapElement_.clear();
  defineElements(elements_, mapElement_);
}

void
SubModel::releaseElements() {
  vector<Element >().swap(elements_);  /// clear erase elements, but do not reduce size
  mapElement_.clear();
}

vector<Element>
SubModel::getElements(const string &nameElement) {
  map<std::string, int>::iterator iter = mapElement_.find(nameElement);
  if (iter == mapElement_.end()) {
    throw DYNError(Error::MODELER, SubModelUnknownElement, name(), modelType(), nameElement);
  } else {
    vector<Element> elements;
    Element element = elements_[iter->second];
    if (element.getTypeElement() == Element::STRUCTURE) {
      vector<Element> subElements = getSubElements(element);
      elements.insert(elements.begin(), subElements.begin(), subElements.end());
    } else {
      elements.push_back(element);
    }
    return elements;
  }
}

vector<Element>
SubModel::getSubElements(const Element& element) {
  vector<Element> elements;
  for (unsigned int i = 0; i < element.subElementsNum().size(); ++i) {
    Element sub = elements_[element.subElementsNum()[i]];
    if (sub.getTypeElement() == Element::STRUCTURE) {
      vector<Element> subElements = getSubElements(sub);
      elements.insert(elements.begin(), subElements.begin(), subElements.end());
    } else {
      elements.push_back(sub);
    }
  }
  return elements;
}

bool
SubModel::hasVariable(const string& nameVariable) const {
  return ( variablesByName_.find(nameVariable) != variablesByName_.end());
}

bool
SubModel::hasVariableInit(const string& nameVariable) const {
  return ( variablesByNameInit_.find(nameVariable) != variablesByNameInit_.end());
}

shared_ptr <Variable>
SubModel::getVariable(const std::string & variableName) const {
  map<string, shared_ptr<Variable> >::const_iterator iter = variablesByName_.find(variableName);
  if (iter == variablesByName_.end()) {
    throw DYNError(Error::MODELER, SubModelUnknownElement, name(), modelType(), variableName);
  }
  return iter->second;
}

double
SubModel::getVariableValue(const boost::shared_ptr <Variable> variable) const {
#ifdef _DEBUG_
  assert(variable && "SubModel::getVariableValue variable not found");
#endif
  const int varNum = variable->getIndex();
  const typeVar_t typeVar = variable->getType();
  const bool negated = variable->getNegated();
  const bool isState = variable->isState();

  double value;
  if (!isState) {
    value = calculatedVars_[varNum];
  } else {
    switch (typeVar) {
      case CONTINUOUS:
      case FLOW: {
        value = yLocal_[varNum];
        break;
      }
      case DISCRETE:
      case INTEGER: {  // Z vector contains DISCRETE variables and then INTEGER variables
        value = zLocal_[varNum];
        break;
      }
      case BOOLEAN: {
        if (toNativeBool(zLocal_[varNum]))
          value = 1;
        else
          value = 0;
        break;
      }
      case UNDEFINED_TYPE: {
        throw DYNError(Error::MODELER, ModelFuncError, "Unsupported variable type");
      }
      default: {
        throw DYNError(Error::MODELER, SubModelUnknownVariable, name(), modelType(), variable->getName());
      }
    }
  }

  if (negated)
    value = -1 * value;

  return value;
}

int
SubModel::getVariableIndexGlobal(const shared_ptr <Variable> variable) const {
  const int varNum = variable->getIndex();
  const typeVar_t typeVar = variable->getType();
  const bool isState = variable->isState();

  // global variable indexes are only defined for state variables
  if (!isState) {
    throw DYNError(Error::MODELER, SubModelBadVariableTypeForVariableIndex, name(), modelType(), variable->getName());
  }

  switch (typeVar) {
    case CONTINUOUS:
    case FLOW: {
      return yDeb() + varNum;
    }
    case DISCRETE:
    case BOOLEAN:
    case INTEGER: {  // Z vector contains DISCRETE variables and then INTEGER variables
      return zDeb() + varNum;
    }
    case UNDEFINED_TYPE:
    {
      throw DYNError(Error::MODELER, ModelFuncError, "Unsupported variable type");
    }
  }
  throw DYNError(Error::MODELER, SubModelBadVariableTypeForVariableIndex, name(), modelType(), variable->getName());
}

double
SubModel::getVariableValue(const string& nameVariable) const {
  return getVariableValue(getVariable(nameVariable));
}

bool
SubModel::hasParameter(const string & nameParameter, const bool isInitParam) {
  const unordered_map<std::string, ParameterModeler>& parameters = getParameters(isInitParam);
  return (parameters.find(nameParameter) != parameters.end());
}

void
SubModel::defineVariables() {
  variables_.clear();
  variablesByName_.clear();
  defineVariables(variables_);
  // sort variable by name
  for (unsigned int i = 0; i < variables_.size(); ++i) {
    variablesByName_[variables_[i]->getName()] = variables_[i];
  }

  // define alias
  for (unsigned int i = 0; i < variables_.size(); ++i) {
    if (variables_[i]->isAlias()) {
      shared_ptr <VariableAlias> variable = dynamic_pointer_cast<VariableAlias> (variables_[i]);
      if (!variable->referenceVariableSet()) {
        map<string, shared_ptr<Variable> >::const_iterator iter = variablesByName_.find(variable->getReferenceVariableName());
        if (iter == variablesByName_.end()) {
          throw DYNError(Error::MODELER, AliasNotFound, name(), variable->getReferenceVariableName());
        } else {
          variable->setReferenceVariable(dynamic_pointer_cast<VariableNative> (iter->second));
          if (iter->second->isState() && (iter->second->getType() == DISCRETE || iter->second->getType() == BOOLEAN))
            zAliasesNames_.push_back(std::make_pair(variable->getName(), iter->first));
          else if (iter->second->isState() && (iter->second->getType() == CONTINUOUS || iter->second->getType() == FLOW))
            xAliasesNames_.push_back(std::make_pair(variable->getName(), iter->first));
        }
      }
    }
  }
}

void
SubModel::instantiateNonUnitaryParameters(const bool isInitParam) {
  typedef std::map<std::string, ParameterModeler>::const_iterator ParamIterator;
  const unordered_map<std::string, ParameterModeler>& parametersUMap = getParameters(isInitParam);
  // Sorting
  std::map<std::string, ParameterModeler> parameters;
  parameters.insert(parametersUMap.begin(), parametersUMap.end());
  for (ParamIterator it = parameters.begin(), itEnd = parameters.end(); it != itEnd; ++it) {
    const ParameterModeler& parameter = it->second;
    const string paramName = parameter.getName();
    if (!parameter.isUnitary()) {
      const string cardinalityInformatorName = parameter.getCardinalityInformator();
      if (!hasParameter(cardinalityInformatorName, isInitParam)) {
        throw DYNError(Error::MODELER, ParameterCardinalityNotDefined, paramName, cardinalityInformatorName);
      }
      const ParameterModeler& cardinaliyInformator = findParameter(cardinalityInformatorName, isInitParam);
      if (!cardinaliyInformator.hasValue()) {
        throw DYNError(Error::MODELER, ParameterCardinalityNotDefined, paramName, cardinalityInformatorName);
      } else if (cardinaliyInformator.getValueType() != VAR_TYPE_INT) {
        throw DYNError(Error::MODELER, ParameterCardinalityBadType, paramName, cardinalityInformatorName, typeVarC2Str(cardinaliyInformator.getValueType()));
      }
      const int cardinalityValue = cardinaliyInformator.getValue<int>();
      for (int index = 0; index < cardinalityValue; ++index) {
        stringstream ss;
        ss << index;
        const string& indexAsString = ss.str();
        const string& newName = paramName + "_" + indexAsString;
        ParameterModeler newParameter = ParameterModeler(newName, parameter.getValueType(), parameter.getScope());
        newParameter.setIsNonUnitaryParameterInstance(true);
        addParameter(newParameter, isInitParam);
      }
    }
  }
}

void
SubModel::setParameterFromSet(const string& parName, const boost::shared_ptr<parameters::ParametersSet> parametersSet,
                              const parameterOrigin_t& origin, const bool isInitParam) {
  if (parametersSet) {
    const ParameterModeler& parameter = findParameter(parName, isInitParam);

     // Check that parameter cardinality is unitary
    if (!parameter.isUnitary())
      throw DYNError(Error::MODELER, ParameterNotUnitary, parName);

     // Check if parameter is present in set
    if (parametersSet->hasParameter(parName)) {
      // Set the parameter value with the information given in PAR file
      switch (parameter.getValueType()) {
        case VAR_TYPE_BOOL: {
          const bool value = parametersSet->getParameter(parName)->getBool();
          setParameterValue(parName, origin, value, isInitParam);
          Trace::debug("PARAMETERS") << DYNLog(ParamValueInOrigin, parName, origin2Str(origin), value) << Trace::endline;
          break;
        }
        case VAR_TYPE_INT: {
          const int value = parametersSet->getParameter(parName)->getInt();
          setParameterValue(parName, origin, value, isInitParam);
          Trace::debug("PARAMETERS") << DYNLog(ParamValueInOrigin, parName, origin2Str(origin), value) << Trace::endline;
          break;
        }
        case VAR_TYPE_DOUBLE: {
          const double& value = parametersSet->getParameter(parName)->getDouble();
          setParameterValue(parName, origin, value, isInitParam);
          Trace::debug("PARAMETERS") << DYNLog(ParamValueInOrigin, parName, origin2Str(origin), value) << Trace::endline;
          break;
        }
        case VAR_TYPE_STRING: {
          const string& value = parametersSet->getParameter(parName)->getString();
          setParameterValue(parName, origin, value, isInitParam);
          Trace::debug("PARAMETERS") << DYNLog(ParamValueInOrigin, parName, origin2Str(origin), value) << Trace::endline;
          break;
        }
        default:
        {
          throw DYNError(Error::MODELER, ParameterNoTypeDetected, parName);
        }
      }
    } else {
      Trace::debug("PARAMETERS") << DYNLog(ParamNoValueInOriginData, parName, origin2Str(origin)) << Trace::endline;
    }
  }
}

void
SubModel::setParametersFromPARFile(const bool isInitParam) {
  typedef unordered_map<std::string, ParameterModeler>::const_iterator ParamIterator;
  const unordered_map<std::string, ParameterModeler>& parameters = getParameters(isInitParam);

  // Set values of parameters with unitary cardinality
  for (ParamIterator it = parameters.begin(), itEnd = parameters.end(); it != itEnd; ++it) {
    const ParameterModeler& currentParameter = it->second;
    if ((currentParameter.isUnitary()) && (!currentParameter.isFullyInternal())) {
      setParameterFromPARFile(currentParameter.getName(), isInitParam);
    }
  }

  // Set values of parameters with multiple cardinality
  // Requires first setting all unitary parameters (to compute cardinality)
  // For these parameters, the name is not the same in parameters and readPARParameters_
  // Example with OmegaRef:
  //    -name of multiple parameter: weight_gen
  //    -name in multiple parameter instances: weight_gen_0, weight_gen_1, ...weight_gen_nbGen
  instantiateNonUnitaryParameters(isInitParam);

  // set the unitary parameters coming from not-unitary parameters instantiation
  for (ParamIterator  it = parameters.begin(), itEnd = parameters.end(); it != itEnd; ++it) {
    const ParameterModeler& currentParameter = it->second;
    if ((currentParameter.getIsNonUnitaryParameterInstance()) && (!currentParameter.isFullyInternal())) {
      setParameterFromPARFile(currentParameter.getName(), isInitParam);
    }
  }
}

void
SubModel::setParametersFromPARFile() {
  // set initial parameters from .par file
  setParametersFromPARFile(true);

  // set dynamic parameters from .par file
  setParametersFromPARFile(false);
}

const ParameterModeler&
SubModel::findParameter(const string& name, const bool isInitParam) const {
  const unordered_map<std::string, ParameterModeler>& parameters = getParameters(isInitParam);
  const unordered_map<std::string, ParameterModeler>::const_iterator indexIterator = parameters.find(name);

  if (indexIterator == parameters.end()) {
    throw DYNError(Error::MODELER, ParameterNotDefined, name);
  }
  return indexIterator->second;
}

ParameterModeler&
SubModel::findParameterReference(const string& name, const bool isInitParam) {
  // Cannot use getParameters as we are not const here
  unordered_map<std::string, ParameterModeler>& parameters = (isInitParam ? parametersInit_ : parametersDynamic_);
  const unordered_map<std::string, ParameterModeler>::iterator indexIterator = parameters.find(name);

  if (indexIterator == parameters.end()) {
    throw DYNError(Error::MODELER, ParameterNotDefined, name);
  }
  return indexIterator->second;
}

const unordered_map<std::string, ParameterModeler>&
SubModel::getParametersDynamic() const {
  return parametersDynamic_;
}

const unordered_map<std::string, ParameterModeler>&
SubModel::getParametersInit() const {
  return parametersInit_;
}

void
SubModel::addParameters(const vector<ParameterModeler>& parameters, const bool isInitParam) {
  for (unsigned int i = 0; i < parameters.size(); ++i) {
    if (!hasParameter(parameters[i].getName(), isInitParam)) {
      addParameter(parameters[i], isInitParam);
    }
  }
}

void
SubModel::addParameter(const ParameterModeler& parameter, const bool isInitParam) {
  if (hasParameter(parameter.getName(), isInitParam)) {
    throw DYNError(Error::MODELER, ParameterAlreadyExists, parameter.getName());
  }
  ParameterModeler parameterToAdd = ParameterModeler(parameter);
  if (isInitParam) {
    parameterToAdd.setIndex(parametersInit_.size());
    parametersInit_.insert(std::make_pair(parameterToAdd.getName(), parameterToAdd));
  } else {
    parameterToAdd.setIndex(parametersDynamic_.size());
    parametersDynamic_.insert(std::make_pair(parameterToAdd.getName(), parameterToAdd));
  }
}

void
SubModel::resetParameters(const bool isInitParam) {
  if (isInitParam)
    parametersInit_.clear();
  else
    parametersDynamic_.clear();
}

void
SubModel::defineVariablesInit() {
  variablesInit_.clear();
  variablesByNameInit_.clear();
  defineVariablesInit(variablesInit_);
  // sort variable by name
  for (unsigned int i = 0; i < variablesInit_.size(); ++i)
    variablesByNameInit_[variablesInit_[i]->getName()] = variablesInit_[i];

  // define alias
  for (unsigned int i = 0; i < variablesInit_.size(); ++i) {
    if (variablesInit_[i]->isAlias()) {
      shared_ptr <VariableAlias> variableInit = dynamic_pointer_cast<VariableAlias> (variablesInit_[i]);
      if (!variableInit->referenceVariableSet()) {
        map<string, shared_ptr<Variable> >::const_iterator iter = variablesByNameInit_.find(variableInit->getReferenceVariableName());
        if (iter == variablesByNameInit_.end())
          throw DYNError(Error::MODELER, AliasNotFound, name(), variableInit->getReferenceVariableName());
        else
          variableInit->setReferenceVariable(dynamic_pointer_cast<VariableNative> (iter->second));
      }
    }
  }
}

void
SubModel::defineParameters(const bool isInitParam) {
  resetParameters(isInitParam);

  vector<ParameterModeler> parameters;
  if (isInitParam) {
    defineParametersInit(parameters);
  } else {
    defineParameters(parameters);
  }

  addParameters(parameters, isInitParam);
}

void SubModel::defineNamesImpl(vector<shared_ptr<Variable> >& variables, vector<string>& zNames,
                               vector<string>& xNames, vector<string>& calculatedVarNames) {
  zNames.clear();
  xNames.clear();
  calculatedVarNames.clear();
  vector <std::pair <string, int> > integer_variables;  // integer variables have to be dealt with last

#ifdef _DEBUG_
  // sanity check : integer variables should always be stored after all other discrete variables
  int minIntegerIndex = 99999;  // minimum index of integer variables
  int maxOtherDiscreteVarIndex = -1;  // maximum index of other discrete variables
#endif

  for (unsigned int i = 0; i < variables.size(); ++i) {
    shared_ptr<Variable> currentVariable = variables[i];
    const typeVar_t type = currentVariable->getType();
    const string name = currentVariable->getName();
    const bool isState = currentVariable->isState();
    int index = -1;

    if (currentVariable->isAlias())  // no alias in names vector
      continue;

    shared_ptr <VariableNative> nativeVariable = dynamic_pointer_cast<VariableNative> (currentVariable);
    if (!isState) {
      index = calculatedVarNames.size();
      calculatedVarNames.push_back(name);
      nativeVariable->setIndex(index);
    } else {
      switch (type) {
        case CONTINUOUS:
        case FLOW: {
          index = xNames.size();
          xNames.push_back(name);
          break;
        }
        case DISCRETE:
        case BOOLEAN: {
          index = zNames.size();
          zNames.push_back(name);
#ifdef _DEBUG_
          maxOtherDiscreteVarIndex = std::max(maxOtherDiscreteVarIndex, index);
#endif
          break;
        }
        case INTEGER: {  // Z vector contains DISCRETE variables and then INTEGER variables
          integer_variables.push_back(make_pair(name, i));
          break;
        }
        case UNDEFINED_TYPE:
        {
          throw DYNError(Error::MODELER, ModelFuncError, "Unsupported variable type");
        }
      }
      // only set non-integer variables (integer variables will be set later on)
      if (type != INTEGER)
        nativeVariable->setIndex(index);
    }
  }

  // set integer variables after all other variables have been set
  for (unsigned int i = 0; i < integer_variables.size(); ++i) {
    int equation_index = zNames.size();  // variable index within equations
    const string& name = integer_variables[i].first;
    const int& var_index = integer_variables[i].second;   // variable index within the variables_ table

    zNames.push_back(name);
    shared_ptr <VariableNative> nativeVariable = dynamic_pointer_cast<VariableNative> (variables[var_index]);
    nativeVariable->setIndex(equation_index);

#ifdef _DEBUG_
    minIntegerIndex = std::min(minIntegerIndex, equation_index);
#endif
  }

#ifdef _DEBUG_
  if (maxOtherDiscreteVarIndex != -1 && !integer_variables.empty()) {
    assert(minIntegerIndex > maxOtherDiscreteVarIndex && "bad variables table : integer variables should be at the very end of the discrete variables table");
  }
#endif
}

void
SubModel::evalZSub(const double & t) {
  setCurrentTime(t);
  if (sizeZ() > 0) {
    // compute each sub-model Z
    evalZ(t);
  }
}

void
SubModel::setBufferFType(propertyF_t* fType, const int & offsetFType) {
  fType_ = static_cast<propertyF_t*>(0);
  if (fType)
    fType_ = &(fType[offsetFType]);
}

void
SubModel::setBufferYType(propertyContinuousVar_t* yType, const int & offsetYType) {
  yType_ = static_cast<propertyContinuousVar_t*>(0);
  if (yType)
    yType_ = &(yType[offsetYType]);
}

void
SubModel::setBufferF(double* f, const int & offsetF) {
  fLocal_ = static_cast<double*>(0);
  if (f)
    fLocal_ = &(f[offsetF]);
}

void
SubModel::setBufferG(state_g* g, const int & offsetG) {
  gLocal_ = static_cast<state_g*>(0);
  if (g)
    gLocal_ = &(g[offsetG]);
}

void
SubModel::setBufferY(double* y, double* yp, const int & offsetY) {
  yLocal_ = static_cast<double*>(0);
  if (y)
    yLocal_ = &(y[offsetY]);
  ypLocal_ = static_cast<double*>(0);
  if (yp)
    ypLocal_ = &(yp[offsetY]);
}

void
SubModel::setBufferZ(double* z, const int & offsetZ) {
  zLocal_ = static_cast<double*>(0);
  if (z)
    zLocal_ = &(z[offsetZ]);
}

void
SubModel::evalFSub(const double & t) {
  setCurrentTime(t);
  // computing f for the sub-model
  evalF(t);

#ifdef _DEBUG_
  // test NAN
  for (unsigned int i = 0; i < sizeF(); ++i) {
    if (std::isnan(fLocal_[i])) {
      throw DYNError(Error::MODELER, NanValue, i, name());
    }
  }
#endif
}

void
SubModel::evalGSub(const double & t) {
  setCurrentTime(t);
  // evaluation of the submodel g functions
  evalG(t);
}

void
SubModel::evalCalculatedVariablesSub(const double & t) {
  setCurrentTime(t);
  // evaluation of the submodel calculated variables
  evalCalculatedVars();
}

double
SubModel::getCalculatedVar(int indexCalculatedVar) {
  return calculatedVars_[indexCalculatedVar];
}

void
SubModel::evalJtSub(const double & t, const double & cj, SparseMatrix& Jt, int& rowOffset) {
  setCurrentTime(t);
  evalJt(t, cj, Jt, rowOffset);
  rowOffset += sizeY();
}

void
SubModel::evalJtPrimSub(const double & t, const double & cj, SparseMatrix& Jt, int& rowOffset) {
  setCurrentTime(t);
  evalJtPrim(t, cj, Jt, rowOffset);
  rowOffset += sizeY();
}

modeChangeType_t
SubModel::evalModeSub(const double & t) {
  setCurrentTime(t);
  // evaluation of the submodel modes
  modeChange_ = false;
  modeChangeType_t modeChangeType = evalMode(t);
  if (modeChangeType > modeChangeType_) {
    modeChange_ = true;
    modeChangeType_ = modeChangeType;
    Trace::debug() << DYNLog(ModeChange, modeChangeType2Str(modeChangeType), name_) << Trace::endline;
  }
  return modeChangeType;
}

// check data coherence for a sub-model

void
SubModel::checkDataCoherenceSub(const double & t) {
  bool doCheck = true;
  // when loaded variables and parameters are used, do not check the init model coherence because it is not used
  if (isInitProcess_ && withLoadedParameters_ && withLoadedVariables_) {
    doCheck = false;
  }

  if (doCheck) {
    setCurrentTime(t);
    checkDataCoherence(t);
  }
}

void
SubModel::setFequationsSub() {
  setFequations();
  setFequationsInit();
}

void
SubModel::setGequationsSub() {
  setGequations();
  setGequationsInit();
}

void
SubModel::getY0Sub() {
  // get y0 , yp0, and z0  values of the subModel
  // external values are also included in y0
  if (!initialized_) {
    getY0();
    initialized_ = true;
  }
}

void
SubModel::getY0Values(vector<double>& y0, vector<double>& yp0, vector<double>& z0) {
  getY0Sub();
  std::copy(yLocal_, yLocal_ + sizeY_, y0.begin());
  std::copy(ypLocal_, ypLocal_ + sizeY_, yp0.begin());
  std::copy(zLocal_, zLocal_ + sizeZ_, z0.begin());
}

void
SubModel::addCurve(shared_ptr<curves::Curve>& curve) {
  const string variableName = curve->getFoundVariableName();
  const shared_ptr <Variable> variable = getVariable(variableName);
  const int varNum = variable->getIndex();
  const typeVar_t typeVar = variable->getType();
  const bool negated = variable->getNegated();
  const bool isState = variable->isState();

  double* buffer = NULL;

  if (!isState) {
    buffer = &(calculatedVars_[varNum]);
    curve->setCurveType(Curve::CALCULATED_VARIABLE);
  } else {
    switch (typeVar) {
      case CONTINUOUS:
      case FLOW: {
        buffer = &(yLocal_[varNum]);
        curve->setCurveType(Curve::CONTINUOUS_VARIABLE);
        curve->setGlobalIndex(yDeb() + varNum);
        break;
      }
      case DISCRETE:
      case BOOLEAN:  // @todo : use (double) toNativeBool for the buffer ?
      case INTEGER: {  // Z vector contains DISCRETE variables and then INTEGER variables
        buffer = &(zLocal_[varNum]);
        curve->setCurveType(Curve::DISCRETE_VARIABLE);
        curve->setGlobalIndex(zDeb() + varNum);
        break;
      }
      case UNDEFINED_TYPE:
      {
        throw DYNError(Error::MODELER, ModelFuncError, "Unsupported variable type");
      }
    }
  }

  curve->setBuffer(buffer);
  curve->setNegated(negated);
}

void
SubModel::updateCalculatedVarForCurve(boost::shared_ptr<curves::Curve>& curve, double* y, double* yp) {
#ifdef _DEBUG_
  Timer timer("SubModel::updateCalculatedVarForCurve");
  assert(curve);
#endif
  if (curve->getCurveType() != Curve::CALCULATED_VARIABLE) return;
  const string variableName = curve->getFoundVariableName();
  if (!hasVariable(variableName)) return;

  const shared_ptr <Variable> variable = getVariable(variableName);

  const int varNum = variable->getIndex();
  std::vector<int> numVars = getDefJCalculatedVarI(varNum);
  size_t nbVar = numVars.size();
  std::vector<double> yLocal(nbVar);
  std::vector<double> ypLocal(nbVar);
  for (size_t i = 0, iEnd = nbVar; i < iEnd; ++i) {
    yLocal[i] = y[numVars[i]];
    ypLocal[i] = yp[numVars[i]];
  }
  calculatedVars_[varNum] = evalCalculatedVarI(varNum, (nbVar > 0)?&yLocal[0]:NULL, (nbVar > 0)?&ypLocal[0]:NULL);
}

void
SubModel::addParameterCurve(shared_ptr<curves::Curve>& curve) {
  curve->setBuffer(NULL);
  curve->setNegated(false);
}

void
SubModel::printModel() {
  Trace::debug("MODELER") << DYNLog(ModelName) << std::setw(25) << std::left << modelType() << "=>" << name() << Trace::endline;
  Trace::debug("MODELER") << "         Y : [" << std::setw(6) << yDeb_ << " ; " << std::setw(6) << yDeb_ + sizeY() << "[" << Trace::endline;
  Trace::debug("MODELER") << "         F : [" << std::setw(6) << fDeb_ << " ; " << std::setw(6) << fDeb_ + sizeF() << "[" << Trace::endline;

  if (sizeZ() != 0) {
    Trace::debug("MODELER") << "         Z : [" << std::setw(6) << zDeb_ << " ; " << std::setw(6) << zDeb_ + sizeZ() << "[" << Trace::endline;
  }
  if (sizeMode() != 0) {
    Trace::debug("MODELER") << "      mode : [" << std::setw(6) << modeDeb_ << " ; " << std::setw(6) << modeDeb_ + sizeMode() << "[" << Trace::endline;
  }


  if (sizeG() != 0) {
    Trace::debug("MODELER") << "         G : [" << std::setw(6) << gDeb_ << " ; " << std::setw(6) << gDeb_ + sizeG() << "[" << Trace::endline;
  }

  Trace::debug("MODELER") << Trace::endline;
}

void
SubModel::getZ(vector<double>& z) {
  z.assign(zLocal_, zLocal_ + sizeZ());
}

void
SubModel::printMessages() {
  std::list<string>::const_iterator iter;
  for (iter = messages_.begin(); iter != messages_.end(); ++iter)
    Trace::debug() << getCurrentTime() << " | " << name() << " : " << *iter << Trace::endline;

  messages_.clear();
}

void
SubModel::addMessage(const string& message) {
  // sometimes, many evalZ may happen for the same time step => only keep non-duplicate messages
  std::list<string>::iterator iter;
  iter = std::find(messages_.begin(), messages_.end(), message);

  if (iter == messages_.end())
    messages_.push_back(message);
}

void
SubModel::addEvent(const string& modelName, const MessageTimeline& messageTimeline) {
  timeline_->addEvent(getCurrentTime(), modelName, messageTimeline.str(), messageTimeline.priority());
}

void
SubModel::addConstraint(const string& modelName, bool begin, const Message& description) {
  constraints::Type_t type = constraints::CONSTRAINT_UNDEFINED;
  if (begin)
    type = constraints::CONSTRAINT_BEGIN;
  else
    type = constraints::CONSTRAINT_END;

  constraints_->addConstraint(modelName, description.str(), getCurrentTime(), type);
}

string
SubModel::getFequationByLocalIndex(const int& index) {
  map<int, string>::const_iterator it = fEquationIndex().find(index);
  if (it != fEquationIndex().end()) {
    return it->second;
  } else {
    Trace::warn() << DYNLog(SubModelFeqFormulaNotExist, name(), index) << Trace::endline;
    return "";
  }
}

string
SubModel::getGequationByLocalIndex(const int& index) {
  map<int, string>::const_iterator it = gEquationIndex().find(index);
  if (it != gEquationIndex().end()) {
    return it->second;
  } else {
    Trace::warn() << DYNLog(SubModelGeqFormulaNotExist, name(), index) << Trace::endline;
    return "";
  }
}

map<int, string>&
SubModel::fEquationIndex() {
  if (isInitProcess_)
    return fEquationInitIndex_;
  else
    return fEquationIndex_;
}

map<int, string>&
SubModel::gEquationIndex() {
  if (isInitProcess_)
    return gEquationInitIndex_;
  else
    return gEquationIndex_;
}

void SubModel::getSubModelParameterValue(const string& nameParameter, double& value, bool& found) {
  const bool isInitParam = false;
  const ParameterModeler& parameter = findParameter(nameParameter, isInitParam);
  if (!parameter.hasValue()) {
    found = false;
  } else {
    found = true;
    value = parameter.getDoubleValue();
  }
}

}  // namespace DYN
