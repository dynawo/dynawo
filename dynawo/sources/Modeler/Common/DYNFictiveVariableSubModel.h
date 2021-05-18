//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file  DYNFictiveVariableSubModel.h
 *
 * @brief Submodel for fictive variable header : defines a sub model used only when creating a connectedSubmodel with a fictive variable refering
 to an external variable. This model aims only to have one variable, with any logical operation
 *
 */

#ifndef MODELER_COMMON_DYNFICTIVEVARIABLESUBMODEL_H_
#define MODELER_COMMON_DYNFICTIVEVARIABLESUBMODEL_H_

#include "DYNConnector.h"
#include "DYNEnumUtils.h"
#include "DYNSubModel.h"
#include "DYNVariable.h"

#include <boost/shared_ptr.hpp>

namespace DYN {

/**
 * @brief Sub model for fictive variable
 *
 * This sub model aims to handle a native variable connected to an external variable. This aims to re-introduce into the optimization
 * problem connected external variables which do not have a reference native variable and threfore cannot be connected throught the buffers
 * like regular external variables
 */
class FictiveVariableSubModel : public SubModel {
 public:
  /**
   * @brief Constructor
   *
   * @param connectedModel the reference model containing the reference external variable
   */
  explicit FictiveVariableSubModel(const connectedSubModel& connectedModel);

  /**
   * @copydoc SubModel::initializeStaticData()
   */
  void initializeStaticData() { /*no static data*/
  }

  /**
   * @brief initialize all the data for a sub model
   */
  void init(const double) {}

  /**
   * @copydoc SubModel::getSize()
   */
  void getSize();

  /**
   * @brief Model F(t,y,y') function evaluation
   */
  void evalF(double, propertyF_t) {}

  /**
   * @brief Model G(t,y,y') function evaluation
   */
  void evalG(const double) {}

  /**
   * @brief Model discrete variables evaluation
   */
  void evalZ(const double) {}

  /**
   * @brief Model mode change type evaluation
   * @returns NO_MODE
   */
  modeChangeType_t evalMode(const double) {
    return NO_MODE;
  }

  /**
   * @copydoc SubModel::evalCalculatedVars()
   */
  void evalCalculatedVars() {}

  /**
   * @brief compute the transpose jacobian of the sub model \f$ J = @F/@x + cj * @F/@x' \f$
   */
  void evalJt(const double, const double, SparseMatrix&, const int) {}

  /**
   * @brief compute the transpose prim jacobian of the sub model \f$ J'= @F/@x' \f$
   */
  void evalJtPrim(const double, const double, SparseMatrix&, const int) {}

  /**
   * @copydoc SubModel::initParams()
   */
  void initParams() { /*no parameter*/
  }

  /**
   * @copydoc SubModel::evalStaticFType()
   */
  void evalStaticFType() {}

  /**
   * @brief set the silent flag for discrete variables
   */
  void collectSilentZ(BitMask*) {}

  /**
   * @copydoc SubModel::evalDynamicFType()
   */
  void evalDynamicFType() { /* not needed */
  }

  /**
   * @brief get the global indexes of the variables used to compute a calculated variable
   */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned, std::vector<int>&, std::vector<int>&) const {}

  /**
   * @brief evaluate the jacobian associated to a calculated variable based on the current values of continuous variables
   */
  void evalJCalculatedVarI(unsigned, std::vector<double>&) const {}

  /**
   * @copydoc SubModel::evalCalculatedVarI(unsigned iCalculatedVar) const
   */
  double evalCalculatedVarI(unsigned iCalculatedVar) const;

  /**
   * @copydoc SubModel::getY0()
   */
  void getY0();

  /**
   * @copydoc SubModel::getY0External(unsigned int numVarEx, double& value) const
   */
  void getY0External(unsigned int numVarEx, double& value) const;

  /**
   * @copydoc SubModel::evalStaticYType()
   */
  void evalStaticYType();

  /**
   * @copydoc SubModel::evalDynamicYType()
   */
  void evalDynamicYType() { /* not needed */
  }

  /**
   * @brief export the parameters of the sub model for dump
   */
  void dumpParameters(std::map<std::string, std::string>&) {}

  /**
   * @brief retrieve the value of a parameter
   */
  void getSubModelParameterValue(const std::string&, double&, bool&) {}

  /**
   * @brief export the variables values of the sub model for dump
   */
  void dumpVariables(std::map<std::string, std::string>&) {}

  /**
   * @brief load variables from a previous save
   */
  void loadParameters(const std::string&) {}

  /**
   * @brief load the variables values from a previous dump
   */
  void loadVariables(const std::string&) {}

  /**
   * @brief write initial values of a model in a file
   */
  void printInitValues(const std::string&) {}

  /**
   * @copydoc SubModel::rotateBuffers()
   */
  void rotateBuffers() { /*not needed*/
  }

  /**
   * @copydoc SubModel::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables)
   */
  void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables);

  /**
   * @brief define each parameters of the model
   */
  void defineParameters(std::vector<ParameterModeler>&) {}

  /**
   * @brief define each variables of the init model
   */
  void defineVariablesInit(std::vector<boost::shared_ptr<Variable> >&) {}

  /**
   * @brief define each parameters of the init model
   */
  void defineParametersInit(std::vector<ParameterModeler>&) {}

  /**
   * @brief set the silent flag for discrete variables
   */
  void checkDataCoherence(const double) {}

  /**
   * @copydoc SubModel::checkParametersCoherence () const
   */
  void checkParametersCoherence() const {}

  /**
   * @copydoc SubModel::setFequations()
   */
  void setFequations() {}

  /**
   * @copydoc SubModel::setGequations()
   */
  void setGequations() { /*no G equation*/
  }

  /**
   * @copydoc SubModel::setFequationsInit()
   */
  void setFequationsInit() { /*no F equation*/
  }

  /**
   * @copydoc SubModel::setGequationsInit()
   */
  void setGequationsInit() { /*no G equation*/
  }

  /**
   * @brief initialize the model from data interface
   */
  void initializeFromData(const boost::shared_ptr<DataInterface>&) {}

  /**
   * @copydoc SubModel::initSubBuffers()
   */
  void initSubBuffers() {}

  /**
   * @copydoc SubModel::modelType() const
   */
  std::string modelType() const {
    return "FictiveVariableSubModel";
  }

  /**
   * @copydoc SubModel::setSubModelParameters()
   */
  void setSubModelParameters() {}

  /**
   * @copydoc SubModel::setSharedParametersDefaultValues()
   */
  void setSharedParametersDefaultValues() {}

  /**
   * @copydoc SubModel::setSharedParametersDefaultValuesInit()
   */
  void setSharedParametersDefaultValuesInit() {}

  /**
   * @brief Model elements initializer
   */
  void defineElements(std::vector<Element>&, std::map<std::string, int>&) {
    // do nothing
  }

  /**
   * @copydoc SubModel::notifyTimeStep()
   */
  void notifyTimeStep() {
    // do nothing
  }

  /**
   * @copydoc SubModel::isFictiveVariableModel()
   */
  bool isFictiveVariableModel() const {
    return true;
  }

 private:
  const connectedSubModel& referenceConnectedModel_;  ///< the model and variable handled by the fictiounous variabled
};
}  // namespace DYN

#endif  // MODELER_COMMON_DYNFICTIVEVARIABLESUBMODEL_H_
