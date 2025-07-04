//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of
// simulation tools for power systems.
//

/**
 * @file  DYNModelCentralizedShuntsSectionControl.h
 *
 * @brief centralized model for shunt section control header
 *
 */

#ifndef MODELS_CPP_CONTROLS_SHUNTS_MODELCENTRALIZEDSHUNTSSECTIONCONTROL_DYNMODELCENTRALIZEDSHUNTSSECTIONCONTROL_H_
#define MODELS_CPP_CONTROLS_SHUNTS_MODELCENTRALIZEDSHUNTSSECTIONCONTROL_DYNMODELCENTRALIZEDSHUNTSSECTIONCONTROL_H_

#include "DYNModelCPP.h"
#include "DYNModelConstants.h"
#include "DYNSubModelFactory.h"

namespace DYN {
class DataInterface;
/**
 * @brief ModelCentralizedShuntsSectionControl factory
 *
 * Implementation of @p SubModelFactory template for
 * ModelCentralizedShuntsSectionControl model
 */
class ModelCentralizedShuntsSectionControlFactory : public SubModelFactory {
 public:
  /**
   * @brief default destructor
   *
   */
  ~ModelCentralizedShuntsSectionControlFactory() override = default;

  /**
   * @brief ModelCentralizedShuntsSectionControl getter
   *
   * @return A pointer to a new instance of ModelCentralizedShuntsSectionControl
   */
  SubModel* create() const override;

  /**
   * @brief ModelCentralizedShuntsSectionControl destroy
   */
  void destroy(SubModel*) const override;
};

/**
 * @brief ModelCentralizedShuntsSectionControl class
 */
class ModelCentralizedShuntsSectionControl : public ModelCPP {
 public:
  /**
   * @brief default constructor
   */
  ModelCentralizedShuntsSectionControl();

  /**
   * @brief get check sum number
   * @return the check sum number associated to the model
   */
  std::string getCheckSum() const override;

  /**
   * @brief  calculated variables type
   */
  typedef enum {
    nbCalculatedVariables_ = 0
  } CalculatedVars_t;

  /**
   * @brief define parameters
   * @param parameters vector to fill with the generic parameters
   */
  void defineParameters(std::vector<ParameterModeler> &parameters) override;

  /**
   * @brief ModelCentralizedShuntsSectionControl parameters setter
   */
  void setSubModelParameters() override;

  /**
   * @brief initialize variables of the model
   *
   * A variable is a structure which contained all information needed to
   * interact with the model
   * @param variables vector to fill with each variables
   */
  void defineVariables(std::vector<boost::shared_ptr<Variable> > &variables) override;

  /**
   * @brief ModelCentralizedShuntsSectionControl model initialization
   * @param t0 : initial time of the simulation
   */
  void init(double t0) override;

  /**
   * @brief set the silent flag for discrete variables
   * @param silentZTable flag table
   */
  void collectSilentZ(BitMask *silentZTable) override;

  /**
   * @brief ModelCentralizedShuntsSectionControl model's sizes getter
   *
   * Get the sizes of the vectors and matrices used by the solver to simulate
   * ModelCentralizedShuntsSectionControl instance. Used by @p ModelMulti to generate
   * right size matrices and vector for the solver.
   */
  void getSize() override;

  /**
   * @copydoc ModelCPP::evalStaticYType()
   */
  void evalStaticYType() override;

  /**
   * @copydoc ModelCPP::evalDynamicYType()
   */
  void evalDynamicYType() override { /* not needed */ }

  /**
   * @copydoc ModelCPP::evalStaticFType()
   */
  void evalStaticFType() override { /* not needed */ }

  /**
   * @copydoc ModelCPP::evalDynamicFType()
   */
  void evalDynamicFType() override { /* not needed */ }

  /**
   * @brief ModelCentralizedShuntsSectionControl F(t,y,y') function evaluation
   *
   * Get the residues' values at a certain instant time with given state
   * variables, state variables derivatives
   *
   * @param t Simulation instant
   * @param[in] type type of the residues to compute (algebraic, differential or
   * both)
   */
  void evalF(double t, propertyF_t type) override;

  /**
   * @copydoc ModelCPP::setFequations()
   */
  void setFequations() override { /* not need */ }

  /**
   * @brief ModelCentralizedShuntsSectionControl transposed jacobian evaluation
   *
   * Get the sparse transposed jacobian \f$ Jt=@F/@y + cj*@F/@y' \f$
   *
   * @param t Simulation instant
   * @param cj Jacobian prime coefficient
   * @param rowOffset offset to use to identify the row where data should be
   * added
   * @param jt jacobian matrix to fullfill
   */
  void evalJt(double t, double cj, int rowOffset, SparseMatrix& jt) override;

  /**
   * @brief ModelCentralizedShuntsSectionControl G(t,y,y') function evaluation
   *
   * Get the root's value
   *
   * @param t Simulation instant
   */
  void evalG(double t) override;

  /**
   * @brief ModelCentralizedShuntsSectionControl discrete variables evaluation
   *
   * Get the discrete variables' value depending on current simulation instant
   * and current state variables values.
   *
   * @param t Simulation instant
   */
  void evalZ(double t) override;

  /**
   * @copydoc ModelCPP::getY0()
   */
  void getY0() override;

  /**
   * @copydoc ModelCPP::initParams()
   */
  void initParams() override { /* not needed */ }

  /**
   * @brief initialize the model from data interface
   *
   * @param data data interface to use to initialize the model
   */
  void initializeFromData(const boost::shared_ptr<DataInterface>& data) override;

  /**
   * @copydoc ModelCPP::initializeStaticData()
   */
  void initializeStaticData() override { /* not needed */ }

  /**
   * @brief calculate calculated variables
   */
  void evalCalculatedVars() override { /* not need */ }

  /**
   * @brief evaluate the jacobian associated to a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param res values of the jacobian
   */
  void evalJCalculatedVarI(unsigned iCalculatedVar, std::vector<double>& res) const override;

  /**
   * @brief  ModelCentralizedShuntsSectionControl transposed jacobian evaluation
   *
   * Get the sparse transposed jacobian \f$ Jt=@F/@y' \f$
   *
   * @param t Simulation instant
   * @param cj Jacobian prime coefficient
   * @param rowOffset offset to use to identify the row where data should be
   * added
   * @param jtPrim jacobian matrix to fullfill
   */
  void evalJtPrim(double t, double cj, int rowOffset, SparseMatrix& jtPrim) override;

  /**
   * @brief Model mode change type evaluation
   *
   * Set the mode change type value depending on current simulation instant and
   * current state variables values.
   * @param[in] t Simulation instant
   * @return mode change type value
   */
  modeChangeType_t evalMode(double t) override;

  /**
   * @brief get the global indexes of the variables used to compute a calculated
   * variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param indexes vector to fill with the indexes
   *
   */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int> &indexes) const override;

  /**
   * @copydoc ModelCPP::setGequations()
   */
  void setGequations() override;

  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   *
   * @return value of the calculated variable
   */
  double evalCalculatedVarI(unsigned iCalculatedVar) const override;

  /**
   * @brief ModelCentralizedShuntsSectionControl elements initializer
   *
   * Define elements for this model (elements to be seen by other models)
   *
   * @param elements  Reference to elements' vector
   * @param mapElement Map associating each element index in the elements vector
   * to its name
   */
  void defineElements(std::vector<Element> &elements, std::map<std::string, int> &mapElement) override;

 private:
  int nbShunts_;                  ///< number of shunts
  std::vector<int> sections0_;    ///< initial section values of each shunt
  std::vector<int> sectionsMin_;  ///< minimum section values of each shunt
  std::vector<int> sectionsMax_;  ///< maximum section values of each shunt
  std::vector<double> deadBandsUPu_;  ///< deadband value of the section control in pu (base UNom) of each shunt
  std::vector<bool> isSelf_;  ///< booleans that state if the shunts are selfs (true) or condensers (false)
  double URef0Pu_;    ///< voltage regulation set point in pu (base UNom)
  int changingShunt;  ///< index of the shunt changing section
  double whenUp_;     ///< when the monitored voltage reached a value above the threshold
  double whenDown_;   ///< when the monitored voltage reached a value below the threshold
  double tNext_;      ///< time to wait before changing of section
  double lastTime_;   ///< last time a section was changed
};

}  // namespace DYN

#endif  // MODELS_CPP_CONTROLS_SHUNTS_MODELCENTRALIZEDSHUNTSSECTIONCONTROL_DYNMODELCENTRALIZEDSHUNTSSECTIONCONTROL_H_
