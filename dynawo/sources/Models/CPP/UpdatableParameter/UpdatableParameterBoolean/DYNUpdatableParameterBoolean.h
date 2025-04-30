//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file  DYNUpdatableParameterBoolean.h
 *
 * @brief Continuous updatable parameter header
 *
 */

#ifndef MODELS_CPP_UPDATABLEPARAMETER_UPDATABLEPARAMETERBOOLEAN_DYNUPDATABLEPARAMETERBOOLEAN_H_
#define MODELS_CPP_UPDATABLEPARAMETER_UPDATABLEPARAMETERBOOLEAN_DYNUPDATABLEPARAMETERBOOLEAN_H_

#include "DYNModelCPP.h"
#include "DYNModelConstants.h"
#include "DYNSubModelFactory.h"
#include "PARParametersSet.h"

namespace DYN {
class DataInterface;
/**
* @brief UpdatableParameterBoolean factory
*
* Implementation of @p SubModelFactory template for UpdatableParameterBoolean model
*/
class UpdatableParameterBooleanFactory : public SubModelFactory {
 public:
  /**
  * @brief default constructor
  *
  */
  UpdatableParameterBooleanFactory() { }
  /**
  * @brief default destructor
  *
  */
  virtual ~UpdatableParameterBooleanFactory() = default;
  /**
  * @brief UpdatableParameterBoolean getter
  *
  * @return A pointer to a new instance of UpdatableParameterBoolean
  */
  SubModel* create() const;
  /**
  * @brief UpdatableParameterBoolean destroy
  */
  void destroy(SubModel*) const;
};

/**
 * class UpdatableParameterBoolean
 */
class UpdatableParameterBoolean : public ModelCPP {
 public:
   /**
    * @brief define type of calculated variables
    *
    */
  typedef enum {
    inputValueIdx_ = 0,
    nbCalculatedVars_ = 1
  } CalculatedVars_t;
  /**
   * @brief Default constructor
   *
   * Creates a new UpdatableParameterBoolean instance.
   */
  UpdatableParameterBoolean();
  // instantiate virtual methods of the Model class
  /**
   * @brief  UpdatableParameterBoolean model initialization routine
   * @param t0 : initial time of the simulation
   */
  void init(const double t0) override;
  /**
   * @brief  UpdatableParameterBoolean model's sizes getter
   *
   * Get the sizes of the vectors and matrixs used by the solver to simulate
   * Model UpdatableParameterBoolean instance. Used by @p ModelMulti to generate right size matrixs
   * and vector for the solver.
   */
  void getSize() override;
  /**
   * @brief  UpdatableParameterBoolean F(t,y,y') function evaluation
   *
   * Get the residues' values at a certain instant time with given state variables,
   * state variables derivatives
   * @param[in] t Simulation instant
   * @param[in] type type of the residues to compute (algebraic, differential or both)
   */
  void evalF(double t, propertyF_t type) override;
  /**
   * @brief  UpdatableParameterBoolean G(t,y,y') function evaluation
   *
   * Get the roots' value
   * @param[in] t Simulation instant
   */
  void evalG(const double t) override;
  /**
   * @brief  UpdatableParameterBoolean discrete variables evaluation
   *
   * Get the discrete variables' value depending on current simulation instant and
   * current state variables values.
   * @param[in] t Simulation instant
   */
  void evalZ(const double t) override;
  /**
   * @copydoc SubModel::collectSilentZ()
   */
  void collectSilentZ(BitMask* silentZTable) override;
  /**
   * @copydoc ModelCPP::evalMode(const double t)
   */
  modeChangeType_t evalMode(const double t) override;
  /**
   * @brief calculate calculated variables
   */
  void evalCalculatedVars() override;
  /**
   * @brief  UpdatableParameterBoolean transposed jacobian evaluation
   *
   * Get the sparse transposed jacobian
   * @param[in] t Simulation instant
   * @param[in] cj Jacobian prime coefficient
   * @param jt jacobian matrix to fullfill
   * @param rowOffset offset to use to identify the row where data should be added
   */
  void evalJt(const double t, const double cj, SparseMatrix& jt, const int rowOffset) override;
  /**
   * @brief calculate jacobien prime matrix
   *
   * @param[in] t Simulation instant
   * @param[in] cj Jacobian prime coefficient
   * @param jt jacobian matrix to fullfill
   * @param rowOffset offset to use to identify the row where data should be added
   */
  void evalJtPrim(const double t, const double cj, SparseMatrix& jt, const int rowOffset) override;
  /**
   * @copydoc ModelCPP::evalStaticFType()
   */
  void evalStaticFType() override;
  /**
   * @copydoc ModelCPP::evalDynamicFType()
   */
  void evalDynamicFType() override { /* not needed */}
  /**
   * @copydoc ModelCPP::getY0()
   */
  void getY0() override;
  /**
   * @copydoc ModelCPP::evalStaticYType()
   */
  void evalStaticYType() override;
  /**
   * @copydoc ModelCPP::evalDynamicYType()
   */
  void evalDynamicYType() override { /* not needed */}
  /**
   * @brief get the index of variables used to define the jacobian associated to a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param indexes vector to fill with the indexes
   */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const override;
  /**
   * @brief evaluate the jacobian associated to a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param res values of the jacobian
   */
  void evalJCalculatedVarI(unsigned iCalculatedVar, std::vector<double>& res) const override;
  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   *
   * @return value of the calculated variable
   */
  double evalCalculatedVarI(unsigned iCalculatedVar) const override;
  /**
   * @brief  UpdatableParameterBoolean parameters setter
   */
  void setSubModelParameters() override;
  /**
   * @brief  UpdatableParameterBoolean elements initializer
   *
   * Define  UpdatableParameterBoolean elements (connection variables for output and other models).
   * @param[out] elements Reference to elements' vector
   * @param[out] mapElement Map associating each element index in the elements vector to its name
   */
  //---------------------------------------------------------------------
  void defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) override;
  /**
   * @copydoc ModelCPP::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables)
   */
  void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) override;
  /**
   * @copydoc ModelCPP::defineParameters(std::vector<ParameterModeler>& parameters)
   */
  void defineParameters(std::vector<ParameterModeler>& parameters) override;
  /**
   * @brief get check sum number
   * @return checksum string
   */
  std::string getCheckSum() const override;
  /**
   * @copydoc ModelCPP::initializeStaticData()
   */
  void initializeStaticData() override;
  /**
   * @copydoc ModelCPP::initializeFromData(const boost::shared_ptr<DataInterface> &data)
   */
  void initializeFromData(const boost::shared_ptr<DataInterface>& data) override;
  /**
   * @copydoc ModelCPP::setFequations()
   */
  void setFequations() override;
  /**
   * @copydoc ModelCPP::setGequations()
   */
  void setGequations() override;
  /**
   * @copydoc ModelCPP::initParams()
   */
  void initParams() override { /* not needed */ }
  /**
  * @brief update parameter
  * @param parameterSet ParametersSet filled with external values
  */
  void updateParameters(std::shared_ptr<parameters::ParametersSet>& parametersSet) override;
  /**
   * @brief update parameter of model
   * @param name name of the parameter
   */
  void updateParameter(const std::string& name, double value) override;

 private:
  double inputValue_;      ///< updatable value
  bool updated_;           ///< @b true if updated from external input
};

}  // namespace DYN

#endif  // MODELS_CPP_UPDATABLEPARAMETER_UPDATABLEPARAMETERBOOLEAN_DYNUPDATABLEPARAMETERBOOLEAN_H_
