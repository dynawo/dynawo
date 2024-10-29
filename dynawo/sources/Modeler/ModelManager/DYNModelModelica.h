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
 * @file  DYNModelModelica.h
 *
 * @brief Generic class for native Modelica models
 *
 */

#ifndef MODELER_MODELMANAGER_DYNMODELMODELICA_H_
#define MODELER_MODELMANAGER_DYNMODELMODELICA_H_

#include <string>
#include <map>
#include <vector>


#include "DYNModelManagerCommon.h"  // DYNDATA
#include "DYNSubModel.h"

#ifdef _ADEPT_
#include "adept.h"
#endif  // MODELER_MODELMANAGER_DYNMODELMODELICA_H_
namespace parameters {
class ParametersSet;
}  // namespace parameters

namespace DYN {
class ParameterModeler;
class Element;
class ModelManager;
class Variable;

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @brief ModelModelica
 *
 * Generic class for native Modelica models
 */
class ModelModelica {
 public:
  /**
   * @brief default destructor
   */
  virtual ~ModelModelica() = default;

 public:
  /**
   * @brief initialise the dyn data structure
   *
   * @param data dyn data to initialize
   */
  virtual void initData(DYNDATA* data) = 0;

  /**
   * @brief initialize the parameters of the model
   *
   */
  virtual void initRpar() = 0;

  /**
   * @brief calculates the residual functions of the model
   *
   * @param f local buffer to fill
   * @param  type type of the residues to compute (algebraic, differential or both)
   */
  virtual void setFomc(double* f, propertyF_t type) = 0;

  /**
   * @brief  calculates the roots of the model
   *
   * @param g local buffer to fill
   */
  virtual void setGomc(state_g* g) = 0;

  /**
   * @brief check whether a mode has been triggered
   *
   * @param t the time for which to check
   * @return @b true if a mode has been trigered, @b false otherwise (for use by ModelManager)
   */
  virtual modeChangeType_t evalMode(const double t) const = 0;

  /**
   * @brief calculates the discrete values of the model
   *
   */
  virtual void setZomc() = 0;

  /**
   * @brief set the silent flag for discrete variables
   * @param silentZTable flag table
   */
  virtual void collectSilentZ(BitMask* silentZTable) = 0;

  /**
   * @brief calculates the initial values (discrete and continuous) of the model
   *
   */
  virtual void setY0omc() = 0;

  /**
   * @brief call the constructors of objects that need a custom build based on parameters values
   *
   */
  virtual void callCustomParametersConstructors() = 0;

  /**
   * @brief set the values of the parameters of the model
   *
   * @param params set of parameters where to read the values of the model's parameters
   */
  virtual void setParameters(std::shared_ptr<parameters::ParametersSet> params) = 0;

  /**
   * @brief defines the variables of the model
   *
   * @param variables vector to fill
   */
  virtual void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) = 0;

  /**
   * @brief defines the parameters of the model
   *
   * @param parameters vector to fill
   */
  virtual void defineParameters(std::vector<ParameterModeler>& parameters) = 0;


  /**
   * @brief defines the checkSum of the model (in order to check whether it was modified)
   *
   * @param checkSum value of the checkSum
   */
  virtual void checkSum(std::string& checkSum) = 0;

#ifdef _ADEPT_
  /**
   * @brief compute the F function based on the ADEPT library
   *
   * @param y values of the continuous variable
   * @param yp values of the derivatives of the continuous variable
   * @param F computes values of the residual functions
   */
  virtual void evalFAdept(const std::vector<adept::adouble>& y, const std::vector<adept::adouble>& yp, std::vector<adept::adouble>& F) = 0;
#endif

  /**
   * @brief ensure data coherence (asserts, min/max, sanity checks...)
   *
   */
  virtual void checkDataCoherence() = 0;

  /**
   * @brief ensure parameters coherence (min/max, sanity checks...)
   */
  virtual void checkParametersCoherence() const = 0;

  /**
   * @brief set formula for modelica model's equation
   * @param fEquationIndex map of equation's formula by idnex as it key
   */
  virtual void setFequations(std::map<int, std::string>& fEquationIndex) = 0;

  /**
   * @brief set formula for modelica model's root equation
   * @param gEquationIndex map of root equation's formula by idnex as it key
   */
  virtual void setGequations(std::map<int, std::string>& gEquationIndex) = 0;

  /**
   * @brief defines the model type of the model
   *
   * @param modelType model type to set
   */
  virtual void setModelType(std::string modelType) = 0;

  /**
   * @brief get the current model manager used
   *
   * @return the current model manager used
   */
  virtual ModelManager* getModelManager() const = 0;

  /**
   * @brief set the current model manager used
   *
   * @param model current model manager used
   */
  virtual void setModelManager(ModelManager* model) = 0;

  /**
   * @brief defines the property of each continuous variable with constant type
   *
   * @param yType local buffer to fill
   */
  virtual void evalStaticYType_omc(propertyContinuousVar_t* yType) = 0;

  /**
   * @brief defines the property of each residual function with constant type
   *
   * @param fType local buffer to fill
   */
  virtual void evalStaticFType_omc(propertyF_t* fType) = 0;

  /**
   * @brief defines the property of each continuous variable with dynamic type
   *
   * @param yType local buffer to fill
   */
  virtual void evalDynamicYType_omc(propertyContinuousVar_t* yType) = 0;

  /**
   * @brief defines the property of each residual function with dynamic type
   *
   * @param fType local buffer to fill
   */
  virtual void evalDynamicFType_omc(propertyF_t* fType) = 0;

  /**
   * @brief define the elements of the model
   *
   * @param elements vector of each elements contains in the model
   * @param mapElement map associating an element and the index of the elements contains in it
   */
  virtual void defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) = 0;

  /**
   * @brief set shared parameters default values
   *
   * @return a parameters set filled with default values
   */
  virtual std::shared_ptr<parameters::ParametersSet> setSharedParametersDefaultValues() = 0;

  /**
   * @brief compute the value of calculated variables
   *
   * @param calculatedVars calculated variables vector
   */
  virtual void evalCalculatedVars(std::vector<double>& calculatedVars) = 0;
  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   *
   * @return value of the calculated variable based on current continuous variables values
   */
  virtual double evalCalculatedVarI(unsigned iCalculatedVar) const = 0;

#ifdef _ADEPT_
  /**
   * @brief evaluate the value of a calculated variable with ADEPT library
   *
   * @param iCalculatedVar index of the calculated variable
   * @param indexOffset offset to read the first variable in y and yp
   * @param y values of the continuous variable
   * @param yp values of the derivatives of the continuous variable
   * @return value of the calculated variable
   */
  virtual adept::adouble evalCalculatedVarIAdept(unsigned iCalculatedVar, unsigned indexOffset, const std::vector<adept::adouble>& y,
      const std::vector<adept::adouble>& yp) const = 0;
#endif

/**
   * @brief get the index of variables used to define the jacobian associated to a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param indexes vector to fill with the indexes
   */
  virtual void getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const = 0;

  /**
   * @brief is the internal modelica structure initialized
   *
   * @return true if data struct is initialized
   */
  virtual bool isDataStructInitialized() const = 0;

  /**
   * @brief Determines if the sub model has a data check coherence operation (non-empty function)
   * @return true if the sub model has a data check coherence operation, false if not
   */
  inline bool hasCheckDataCoherence() const { return hasCheckDataCoherence_; }

 protected:
  bool hasCheckDataCoherence_;  ///< Determines if the modelica model has a data check coherence operation
};

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace DYN

#endif  // MODELER_MODELMANAGER_DYNMODELMODELICA_H_
