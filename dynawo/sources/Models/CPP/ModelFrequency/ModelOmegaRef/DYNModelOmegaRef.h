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
 * @file  DYNModelOmegaRef.h
 *
 * @brief Reference frequency model header
 *
 */

#ifndef MODELS_CPP_MODELFREQUENCY_MODELOMEGAREF_DYNMODELOMEGAREF_H_
#define MODELS_CPP_MODELFREQUENCY_MODELOMEGAREF_DYNMODELOMEGAREF_H_


#include "DYNModelCPP.h"
#include "DYNSubModelFactory.h"

namespace DYN {
class DataInterface;

/**
 * @brief Reference frequency factory
 *
 * Implementation of @p SubModelFactory template for Reference frequency Model
 */
class ModelOmegaRefFactory : public SubModelFactory {
 public:
  /**
   * @brief default constructor
   *
   */
  ModelOmegaRefFactory() { }
  /**
   * @brief ModelOmegaRef getter
   *
   * @return A pointer to a new instance of ModelOmegaRef
   */
  SubModel* create() const override;

  /**
   * @brief ModelOmegaRef destroy
   */
  void destroy(SubModel*) const override;
};

/**
 * @brief Reference frequency model class
 *
 *
 *
 */
class ModelOmegaRef : public ModelCPP {
 public:
  /**
   * @brief define type of calculated variables
   *
   */
  typedef enum {
    nbCalculatedVars_ = 0
  } CalculatedVars_t;
  /**
   * @brief Reference frequency model default constructor
   *
   *
   */
  ModelOmegaRef();

  /**
   * @brief Reference frequency model initialization
   * @param t0 : initial time of the simulation
   */
  void init(double t0) override;

  /**
   * @brief Reference Frequency model's sizes getter
   *
   * Get the sizes of the vectors and matrices used by the solver to simulate
   * ModelOmegaRef instance. Used by @p ModelMulti to generate right size matrices
   * and vector for the solver.
   */
  void getSize() override;

  /**
   * @brief Reference Frequency F(t,y,y') function evaluation
   *
   * Get the residues' values at a certain instant time with given state variables,
   * state variables derivatives
   *
   * @param t Simulation instant
   * @param[in] type type of the residues to compute (algebraic, differential or both)
   */
  void evalF(double t, propertyF_t type) override;

  /**
   * @brief Reference frequency G(t,y,y') function evaluation
   *
   * Get the root's value
   *
   * @param t Simulation instant
   */
  void evalG(double t) override;

  /**
   * @brief Reference frequency discrete variables evaluation
   *
   * Get the discrete variables' value depending on current simulation instant and
   * current state variables values.
   *
   * @param t Simulation instant
   */
  void evalZ(double t) override;

  /**
   * @brief set the silent flag for discrete variables
   * @param silentZTable flag table
   */
  void collectSilentZ(BitMask* silentZTable) override;

  /**
   * @copydoc ModelCPP::evalMode(const double t)
   */
  modeChangeType_t evalMode(double t) override;

  /**
   * @brief Reference frequency transposed jacobian evaluation
   *
   * Get the sparse transposed jacobian \f$ Jt=@F/@y + cj*@F/@y' \f$
   *
   * @param t Simulation instant
   * @param cj Jacobian prime coefficient
   * @param rowOffset offset to use to identify the row where data should be added
   * @param jt jacobian matrix to fullfill
   */
  void evalJt(double t, double cj, int rowOffset, SparseMatrix& jt) override;
  /**
   * @brief  Reference frequency transposed jacobian evaluation
   *
   * Get the sparse transposed jacobian \f$ Jt=@F/@y' \f$
   *
   * @param t Simulation instant
   * @param cj Jacobian prime coefficient
   * @param rowOffset offset to use to identify the row where data should be added
   * @param jtPrim jacobian matrix to fullfill
   */
  void evalJtPrim(double t, double cj, int rowOffset, SparseMatrix& jtPrim) override;

  /**
   * @brief calculate calculated variables
   */
  void evalCalculatedVars() override;

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

  // output management
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
   * @brief Reference frequency parameters setter
   */
  void setSubModelParameters() override;

  /**
   * @brief Reference frequency elements initializer
   *
   * Define elements for this model( elements to be seen by other models)
   *
   * @param elements  Reference to elements' vector
   * @param mapElement Map associating each element index in the elements vector to its name
   */
  void defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) override;

  /**
   * @copydoc SubModel::dumpUserReadableElementList()
   */
  void dumpUserReadableElementList(const std::string& nameElement) const override;

  /**
   * @brief initialize variables of the model
   *
   * A variable is a structure which contained all information needed to interact with the model
   * @param variables vector to fill with each variables
   */
  void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) override;

  /**
   * @brief define parameters
   * @param parameters vector to fill with each parameters
   */
  void defineParameters(std::vector<ParameterModeler>& parameters) override;

  /**
   * @brief get check sum number
   * @return the check sum number associated to the model
   */
  std::string getCheckSum() const override;

  /**
   * @copydoc ModelCPP::initializeStaticData()
   */
  void initializeStaticData() override { /* not needed */ }

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
  void setGequations() override { /* not needed */ }

  /**
   * @copydoc ModelCPP::initParams()
   */
  void initParams() override { /* not needed */ }

  /**
   * @copydoc ModelCPP::checkDataCoherence(const double t)
   */
  void checkDataCoherence(double t) override;

  /**
   * @copydoc SubModel::hasDataCheckCoherence() const
   */
  static bool hasCheckDataCoherence() { return true; }

 private:
  /**
   * @brief Sort every generator by num of subNetwork
   *
   *
   */
  void sortGenByCC();

  /**
   * @brief calculate the initial state of the omegaref model
   *
   */
  void calculateInitialState();

  void evalStaticYTypeLinearize() override;
  void evalDynamicYTypeLinearize() override;
  void evalStaticFTypeLinearize() override;
  void evalDynamicFTypeLinearize() override;
  void getSizeLinearize() override;
  void defineVariablesLinearize(std::vector<boost::shared_ptr<Variable> >& variables) override;
  void defineParametersLinearize(std::vector<ParameterModeler>& parameters) override;

 private:
  static int col1stOmegaRef_;  ///< offset to find the first row the residual functions about omegaRef
  static int col1stOmega_;  ///< offset to find the first row the residual functions about omega
  int col1stOmegaRefGrp_;  ///< offset to find the first row the residual functions about omegaRef for each generators

  bool firstState_;  ///< @b true if the initial state must be calculated

  std::vector<double> weights_;  ///< weight use to calculate the centroid of omega (omegaref value)
  std::vector<int> numCCNode_;  ///< index of the network for each generators
  std::vector<double> runningGrp_;  ///< @b true if the generator is on
  std::vector<double> omegaRef0_;  ///< initial values for omegaref
  std::map<int, double > sumWeightByCC_;  ///< sum of weight for each network
  std::map<int, std::vector<int> >genByCC_;  ///< list of generators for each network
  std::vector<int> numCCNodeOld_;  ///< save of the index of the network for each generators
  std::vector<double> runningGrpOld_;  ///< save of the states for each generators

  int nbGen_;  ///< number of generators
  int nbCC_;  ///< number of connected components
  int nbOmega_;  ///< number of generators with positive weight
  std::vector<int> indexOmega_;  ///< index for each omega inside the local buffer
  double omegaRefMin_;  ///< minimum acceptable value for omegaref
  double omegaRefMax_;  ///< maximum acceptable value for omegaref
};

}  // namespace DYN

#endif  // MODELS_CPP_MODELFREQUENCY_MODELOMEGAREF_DYNMODELOMEGAREF_H_
