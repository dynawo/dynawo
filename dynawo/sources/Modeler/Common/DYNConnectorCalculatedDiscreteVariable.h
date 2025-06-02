//
// Copyright (c) 2022, RTE (http://www.rte-france.com)
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
 * @file  DYNConnectorCalculatedDiscreteVariable.h
 *
 * @brief This class builds a connector submodel related to a discrete calculated variable
 *
 */

#ifndef MODELER_COMMON_DYNCONNECTORCALCULATEDDISCRETEVARIABLE_H_
#define MODELER_COMMON_DYNCONNECTORCALCULATEDDISCRETEVARIABLE_H_

#include <boost/shared_ptr.hpp>
#include "DYNSubModel.h"

namespace DYN {
class SubModel;
class DataInterface;

/**
 * @brief this class builds a connector submodel related to a discrete calculated variable
 */
class ConnectorCalculatedDiscreteVariable : public SubModel {
 public:
  /**
   * @brief default constructor
   */
  ConnectorCalculatedDiscreteVariable();

  /**
   * @copydoc SubModel::initializeStaticData()
   */
  void initializeStaticData() override { /*no static data*/ }

  /**
   * @copydoc SubModel::init(const double t0)
   */
  void init(double t0) override;

  /**
   * @copydoc SubModel::getSize()
   */
  void getSize() override;

  /**
   * @copydoc SubModel::evalF(double t, propertyF_t type)
   */
  void evalF(double t, propertyF_t type) override;

  /**
   * @copydoc SubModel::evalG(double t)
   */
  void evalG(double t) override;

  /**
   * @copydoc SubModel::evalZ(double t)
   */
  void evalZ(double t) override;

  /**
   * @copydoc SubModel::evalMode(double t)
   */
  modeChangeType_t evalMode(double t) override;

  /**
   * @copydoc SubModel::evalCalculatedVars()
   */
  void evalCalculatedVars() override { /* not needed */ }

  /**
   * @copydoc SubModel::evalJt(double t, double cj, int rowOffset, SparseMatrix& jt)
   */
  void evalJt(double t, double cj, int rowOffset, SparseMatrix& jt) override;

  /**
   * @copydoc SubModel::evalJtPrim(double t, double cj, int rowOffset,  SparseMatrix& jtPrim)
   */
  void evalJtPrim(double t, double cj, int rowOffset,  SparseMatrix& jtPrim) override;

  /**
   * @copydoc SubModel::initParams()
   */
  void initParams() override { /*no parameter*/ }

  /**
   * @copydoc SubModel::evalStaticFType()
   */
  void evalStaticFType() override { /* not needed */ }

  /**
   * @copydoc SubModel::collectSilentZ()
   */
  void collectSilentZ(BitMask* silentZTable) override;

  /**
   * @copydoc SubModel::evalDynamicFType()
   */
  void evalDynamicFType() override { /* not needed */ }

  /**
   * @brief get the global indexes of the variables used to compute a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param indexes vector to fill with the indexes
   *
   */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const override;

  /**
   * @brief evaluate the jacobian associated to a calculated variable based on the current values of continuous variables
   *
   * @param iCalculatedVar index of the calculated variable
   * @param res values of the jacobian
   */
  void evalJCalculatedVarI(unsigned iCalculatedVar, std::vector<double>& res) const override;

  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @return value of the calculated variable based on the current values of continuous variables
   */
  double evalCalculatedVarI(unsigned iCalculatedVar) const override;

  /**
   * @copydoc SubModel::getY0()
   */
  void getY0() override;

  /**
   * @copydoc SubModel::evalStaticYType()
   */
  void evalStaticYType() override { /* not needed */ }

  /**
   * @copydoc SubModel::evalDynamicYType()
   */
  void evalDynamicYType() override { /* not needed */ }

  /**
   * @copydoc SubModel::dumpParameters(std::map<std::string, std::string > & mapParameters)
   */
  void dumpParameters(std::map<std::string, std::string >& mapParameters) override;

  /**
  * @brief retrieve the value of a parameter
  *
  * @param nameParameter name of a parameter to found
  * @param value value of the parameter
  * @param found @b true if the parameter exist, @b false else
  */
  void getSubModelParameterValue(const std::string& nameParameter, std::string& value, bool& found) override;

  /**
   * @copydoc SubModel::dumpVariables(std::map<std::string, std::string >& mapVariables)
   */
  void dumpVariables(std::map<std::string, std::string >& mapVariables) override;

  /**
   * @copydoc SubModel::loadParameters(const std::string& parameters)
   */
  void loadParameters(const std::string& parameters) override;

  /**
   * @copydoc SubModel::loadVariables(const std::string& variables)
   */
  void loadVariables(const std::string& variables) override;


  /**
   * @copydoc SubModel::rotateBuffers()
   */
  void rotateBuffers() override { /*not needed*/ }

  /**
   * @copydoc SubModel::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables)
   */
  void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) override;

  /**
   * @copydoc SubModel::defineParameters(std::vector<ParameterModeler>& parameters)
   */
  void defineParameters(std::vector<ParameterModeler>& parameters) override;

  /**
   * @copydoc SubModel::defineVariablesInit(std::vector<boost::shared_ptr<Variable> >& variables)
   */
  void defineVariablesInit(std::vector<boost::shared_ptr<Variable> >& variables) override;

  /**
   * @copydoc SubModel::defineParametersInit(std::vector<ParameterModeler>& parameters)
   */
  void defineParametersInit(std::vector<ParameterModeler>& parameters) override;

  /**
   * @copydoc SubModel::checkParametersCoherence () const
   */
  void checkParametersCoherence() const override { /* not needed */ }

  /**
   * @copydoc SubModel::setFequations()
   */
  void setFequations() override { /* not needed */ }

  /**
   * @copydoc SubModel::setGequations()
   */
  void setGequations() override;

  /**
   * @copydoc SubModel::setFequationsInit()
   */
  void setFequationsInit() override { /*no F equation*/ }

  /**
   * @copydoc SubModel::setGequationsInit()
   */
  void setGequationsInit() override { /* not needed */ }

  /**
   * @copydoc SubModel::initializeFromData(const boost::shared_ptr<DataInterface>& data)
   */
  void initializeFromData(const boost::shared_ptr<DataInterface>& data) override;

  /**
   * @brief set the parameters for the connector
   *
   * @param model model where is located the calculated variable
   * @param indexCalculatedVariable index of the calculated variable inside the model
   */
  void setParams(const boost::shared_ptr<SubModel>& model, int indexCalculatedVariable);

  /**
   * @copydoc SubModel::initSubBuffers()
   */
  void initSubBuffers() override { /*not needed*/ }

  /**
   * @copydoc SubModel::modelType() const
   */
  const std::string& modelType() const override {
    static std::string modelType = "ConnectorCalculatedDiscreteVariable";
    return modelType;
  }

  /**
   * @copydoc SubModel::setSubModelParameters()
   */
  inline void setSubModelParameters() override { /*no parameter*/ }

  /**
   * @copydoc SubModel::setSharedParametersDefaultValues()
   */
  inline void setSharedParametersDefaultValues() override { /*no parameter*/ }

  /**
   * @copydoc SubModel::setSharedParametersDefaultValuesInit()
   */
  inline void setSharedParametersDefaultValuesInit() override { /*no parameter*/ }

  /**
   * @copydoc SubModel::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement)
   */
  void defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) override;

  /**
   * @copydoc SubModel::notifyTimeStep()
   */
  void notifyTimeStep() override {
    // do nothing
  }

   /**
    * @brief setter for the variable name
    *
    * @param variableName name of the calculated variable in the reference model
    */
  void setVariableName(const std::string& variableName) {
    variableName_ = variableName;
  }

 private:
  boost::shared_ptr<SubModel> model_;  ///< Model where the calculated variable is located.
  std::string variableName_;  ///< Name of the calculated variable from the model
  int indexCalculatedVariable_;  ///< Index of the calculated variable inside the list calculated variables in the model
  double prevZValue_;  ///< previous value of the discrete calculated variable
};
}  // namespace DYN

#endif  // MODELER_COMMON_DYNCONNECTORCALCULATEDDISCRETEVARIABLE_H_
