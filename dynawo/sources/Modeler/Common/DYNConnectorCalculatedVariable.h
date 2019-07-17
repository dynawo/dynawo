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
  /**
   * enum to define the type of calculated variables
   */
  typedef enum {
    valueNum_ = 0,
    nbCalculatedVars_ = 1
  } CalculatedVars_t;

 public:
  /**
   * @brief default constructor
   */
  ConnectorCalculatedVariable();

  /**
   * @brief default destructor
   */
  ~ConnectorCalculatedVariable() { }

  /**
   * @copydoc SubModel::initializeStaticData()
   */
  void initializeStaticData() { /*no static data*/ }

  /**
   * @copydoc SubModel::init(const double& t0)
   */
  void init(const double& t0);

  /**
   * @copydoc SubModel::getSize()
   */
  void getSize();

  /**
   * @copydoc SubModel::evalF(const double & t)
   */
  void evalF(const double& t);

  /**
   * @copydoc SubModel::evalG(const double & t)
   */
  void evalG(const double& t);

  /**
   * @copydoc SubModel::evalZ(const double & t)
   */
  void evalZ(const double& t);

  /**
   * @copydoc SubModel::evalMode(const double & t)
   */
  modeChangeType_t evalMode(const double& t);

  /**
   * @copydoc SubModel::evalCalculatedVars()
   */
  void evalCalculatedVars();

  /**
   * @copydoc SubModel::evalJt(const double& t, const double& cj, SparseMatrix& Jt, const int& rowOffset)
   */
  void evalJt(const double& t, const double& cj, SparseMatrix& Jt, const int& rowOffset);

  /**
   * @copydoc SubModel::evalJtPrim(const double& t, const double& cj, SparseMatrix& Jt, const int& rowOffset)
   */
  void evalJtPrim(const double& t, const double& cj, SparseMatrix& Jt, const int& rowOffset);

  /**
   * @copydoc SubModel::initParams()
   */
  void initParams() { /*no parameter*/ }

  /**
   * @copydoc SubModel::evalFType()
   */
  void evalFType();

  /**
   * @copydoc SubModel::getDefJCalculatedVarI( int iCalculatedVar)
   */
  std::vector<int> getDefJCalculatedVarI(int iCalculatedVar);

  /**
   * @copydoc SubModel::evalJCalculatedVarI()
   */
  void evalJCalculatedVarI(int iCalculatedVar, double* y, double* yp, std::vector<double>& res);

  /**
   * @copydoc SubModel::evalCalculatedVarI(int iCalculatedVar, double* y, double* yp)
   */
  double evalCalculatedVarI(int iCalculatedVar, double* y, double* yp);

  /**
   * @copydoc SubModel::getY0()
   */
  void getY0();

  /**
   * @copydoc SubModel::evalYType()
   */
  void evalYType();

  /**
   * @copydoc SubModel::dumpParameters(std::map<std::string, std::string > & mapParameters)
   */
  void dumpParameters(std::map<std::string, std::string >& mapParameters);

  /**
   * @copydoc SubModel::getSubModelParameterValue(const std::string& nameParameter, double& value, bool& found)
   */
  void getSubModelParameterValue(const std::string& nameParameter, double& value, bool& found);

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
   * @copydoc SubModel::printInitValues(const std::string& directory)
   */
  void printInitValues(const std::string& directory);

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
   * @copydoc SubModel::checkDataCoherence (const double& t)
   */
  void checkDataCoherence(const double& t);

  /**
   * @copydoc SubModel::setFequations()
   */
  void setFequations() { /*no F equation*/ }

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
  void setParams(const boost::shared_ptr<SubModel>& model, const int& indexCalculatedVariable);

  /**
   * @copydoc SubModel::initSubBuffers()
   */
  void initSubBuffers() { /*not needed*/ }

  /**
   * @brief get the index of the row for the definition of \f$( @F/@(calculatedVariable) )\f$
   * @return index of the row
   */
  inline int col1stYModelExt() {
    return col1stYModelExt_;
  }

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

 private:
  // !!! We assume that the model variables starts at yLocal_[1] and ypLocal_[1]
  boost::shared_ptr<SubModel> model_;  ///< Model where the calculated variable is located.
  int indexCalculatedVariable_;  ///< Index of the calculated variable inside the list calculated variables in the model
  int nbVarExt_;  ///< Number of variables of which depends the calculated variable

  static const int colCalculatedVariable_;  ///< index of the row for the definition of \f$( @F/@(calculatedVariable) )\f$
  static const int col1stYModelExt_;  ///< index of the first row for the definition of \f$( @F/@(dependVariable) )\f$
};
}  // namespace DYN

#endif  // MODELER_COMMON_DYNCONNECTORCALCULATEDVARIABLE_H_
