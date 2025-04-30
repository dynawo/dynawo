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
 * @file  DYNConnectorCalculatedVariable.h
 *
 * @brief Connector to use when connecting to a calculated variable
 *
 */

#ifndef MODELER_COMMON_DYNCONNECTORCALCULATEDVARIABLE_H_
#define MODELER_COMMON_DYNCONNECTORCALCULATEDVARIABLE_H_

#include <boost/shared_ptr.hpp>
#include "DYNSubModel.h"

namespace DYN {
class SubModel;
class DataInterface;

/**
 * class ConnectorCalculatedVariable
 */
class ConnectorCalculatedVariable : public SubModel {
 public:
  /**
   * @brief default constructor
   */
  ConnectorCalculatedVariable();

  /**
   * @copydoc SubModel::initializeStaticData()
   */
  void initializeStaticData() { /*no static data*/ }

  /**
   * @copydoc SubModel::init(const double t0)
   */
  void init(const double t0);

  /**
   * @copydoc SubModel::getSize()
   */
  void getSize();

  /**
   * @copydoc SubModel::evalF(double t, propertyF_t type)
   */
  void evalF(double t, propertyF_t type);

  /**
   * @copydoc SubModel::evalG(const double t)
   */
  void evalG(const double t);

  /**
   * @copydoc SubModel::evalZ(const double t)
   */
  void evalZ(const double t);

  /**
   * @copydoc SubModel::evalMode(const double t)
   */
  modeChangeType_t evalMode(const double t);

  /**
   * @copydoc SubModel::evalCalculatedVars()
   */
  void evalCalculatedVars();

  /**
   * @copydoc SubModel::evalJt(const double t, const double cj, SparseMatrix& Jt, const int rowOffset)
   */
  void evalJt(const double t, const double cj, SparseMatrix& Jt, const int rowOffset);

  /**
   * @copydoc SubModel::evalJtPrim(const double t, const double cj, SparseMatrix& Jt, const int rowOffset)
   */
  void evalJtPrim(const double t, const double cj, SparseMatrix& Jt, const int rowOffset);

  /**
   * @copydoc SubModel::initParams()
   */
  void initParams() { /*no parameter*/ }

  /**
   * @copydoc SubModel::evalStaticFType()
   */
  void evalStaticFType();

  /**
   * @copydoc SubModel::collectSilentZ()
   */
  void collectSilentZ(BitMask* silentZTable);

  /**
   * @copydoc SubModel::evalDynamicFType()
   */
  void evalDynamicFType() { /* not needed */ }

  /**
   * @brief get the global indexes of the variables used to compute a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param indexes vector to fill with the indexes
   *
   */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const;

  /**
   * @brief evaluate the jacobian associated to a calculated variable based on the current values of continuous variables
   *
   * @param iCalculatedVar index of the calculated variable
   * @param res values of the jacobian
   */
  void evalJCalculatedVarI(unsigned iCalculatedVar, std::vector<double>& res) const;

  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @return value of the calculated variable based on the current values of continuous variables
   */
  double evalCalculatedVarI(unsigned iCalculatedVar) const;

  /**
   * @copydoc SubModel::getY0()
   */
  void getY0();

  /**
   * @copydoc SubModel::evalStaticYType()
   */
  void evalStaticYType();

  /**
   * @copydoc SubModel::evalDynamicYType()
   */
  void evalDynamicYType() { /* not needed */ }

  /**
   * @copydoc SubModel::dumpParameters(std::map<std::string, std::string > & mapParameters)
   */
  void dumpParameters(std::map<std::string, std::string >& mapParameters);

  /**
  * @brief retrieve the value of a parameter
  *
  * @param nameParameter name of a parameter to found
  * @param value value of the parameter
  * @param found @b true if the parameter exist, @b false else
  */
  void getSubModelParameterValue(const std::string& nameParameter, std::string& value, bool& found);

  /**
   * @copydoc SubModel::dumpVariables(std::map<std::string, std::string >& mapVariables)
   */
  void dumpVariables(std::map<std::string, std::string >& mapVariables);

  /**
   * @copydoc SubModel::loadParameters(const std::string& parameters)
   */
  void loadParameters(const std::string& parameters);

  /**
   * @copydoc SubModel::loadVariables(const std::string& variables)
   */
  void loadVariables(const std::string& variables);


  /**
   * @copydoc SubModel::rotateBuffers()
   */
  void rotateBuffers() { /*not needed*/ }

  /**
   * @copydoc SubModel::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables)
   */
  void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables);

  /**
   * @copydoc SubModel::defineParameters(std::vector<ParameterModeler>& parameters)
   */
  void defineParameters(std::vector<ParameterModeler>& parameters);

  /**
   * @copydoc SubModel::defineVariablesInit(std::vector<boost::shared_ptr<Variable> >& variables)
   */
  void defineVariablesInit(std::vector<boost::shared_ptr<Variable> >& variables);

  /**
   * @copydoc SubModel::defineParametersInit(std::vector<ParameterModeler>& parameters)
   */
  void defineParametersInit(std::vector<ParameterModeler>& parameters);

  /**
   * @copydoc SubModel::checkParametersCoherence () const
   */
  void checkParametersCoherence() const;

  /**
   * @copydoc SubModel::setFequations()
   */
  void setFequations();

  /**
   * @copydoc SubModel::setGequations()
   */
  void setGequations() { /*no G equation*/ }

  /**
   * @copydoc SubModel::setFequationsInit()
   */
  void setFequationsInit() { /*no F equation*/ }

  /**
   * @copydoc SubModel::setGequationsInit()
   */
  void setGequationsInit() { /*no G equation*/ }

  /**
   * @copydoc SubModel::initializeFromData(const boost::shared_ptr<DataInterface>& data)
   */
  void initializeFromData(const boost::shared_ptr<DataInterface>& data);

  /**
   * @brief set the parameters for the connector
   *
   * @param model model where is located the calculated variable
   * @param indexCalculatedVariable index of the calculated variable inside the model
   */
  void setParams(const boost::shared_ptr<SubModel>& model, const int indexCalculatedVariable);

  /**
   * @copydoc SubModel::initSubBuffers()
   */
  void initSubBuffers() { /*not needed*/ }

  /**
   * @copydoc SubModel::modelType() const
   */
  std::string modelType() const {
    return "ConnectorCalculatedVariable";
  }

  /**
   * @copydoc SubModel::setSubModelParameters()
   */
  inline void setSubModelParameters() { /*no parameter*/ }

  /**
   * @copydoc SubModel::setSharedParametersDefaultValues()
   */
  inline void setSharedParametersDefaultValues() { /*no parameter*/ }

  /**
   * @copydoc SubModel::setSharedParametersDefaultValuesInit()
   */
  inline void setSharedParametersDefaultValuesInit() { /*no parameter*/ }

  /**
   * @copydoc SubModel::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement)
   */
  void defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement);

  /**
   * @copydoc SubModel::notifyTimeStep()
   */
  void notifyTimeStep() {
    // do nothing
  }

   /**
    * @brief setter for the variable name
    *
    * @param variableName name of the calculated variable in the reference model
    */
  void setVariableName(std::string variableName) {
    variableName_ = variableName;
  }

  /**
   * @brief update parameter of model
   * @param name name of the parameter
   */
  void updateParameter(const std::string& name, double value) override;

 private:
  // !!! We assume that the model variables starts at yLocal_[1] and ypLocal_[1]
  boost::shared_ptr<SubModel> model_;  ///< Model where the calculated variable is located.
  std::string variableName_;  ///< Name of the calculated variable from the model
  int indexCalculatedVariable_;  ///< Index of the calculated variable inside the list calculated variables in the model
  std::vector<int> varExtIndexes_;  ///< Indexes of variables on which depends the calculated variable
};
}  // namespace DYN

#endif  // MODELER_COMMON_DYNCONNECTORCALCULATEDVARIABLE_H_
