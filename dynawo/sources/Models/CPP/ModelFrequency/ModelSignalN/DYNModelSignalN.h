//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
 * @file  DYNModelSignalN.h
 *
 * @brief SignalN model header
 *
 */

#ifndef MODELS_CPP_MODELFREQUENCY_MODELSIGNALN_DYNMODELSIGNALN_H_
#define MODELS_CPP_MODELFREQUENCY_MODELSIGNALN_DYNMODELSIGNALN_H_

#include "DYNModelCPPImpl.h"
#include "DYNSubModelFactory.h"

namespace DYN {
class DataInterface;

/**
 * @brief SignalN factory
 *
 * Implementation of @p SubModelFactory template for SignalN model
 */
class ModelSignalNFactory : public SubModelFactory {
 public:
  /**
   * @brief default constructor
   *
   */
  ModelSignalNFactory() { }

  /**
   * @brief default destructor
   *
   */
  ~ModelSignalNFactory() { }
  /**
   * @brief ModelSignalN getter
   *
   * @return A pointer to a new instance of ModelSignalN
   */
  SubModel* create() const;

  /**
   * @brief ModelSignalN destroy
   */
  void destroy(SubModel*) const;
};

/**
 * @brief SignalN model class
 *
 *
 *
 */
class ModelSignalN : public ModelCPP::Impl {
 public:
  /**
   * @brief define type of calculated variables
   *
   */
  typedef enum {
    nbCalculatedVars_ = 0
  } CalculatedVars_t;
  /**
   * @brief SignalN model default constructor
   *
   *
   */
  ModelSignalN();

  /**
   * @brief SignalN model default destructor
   *
   *
   */
  ~ModelSignalN() { }
  /**
   * @brief SignalN model initialization
   * @param t0 : initial time of the simulation
   */
  void init(const double& t0);

  /**
   * @brief SignalN model's sizes getter
   *
   * Get the sizes of the vectors and matrices used by the solver to simulate
   * ModelSignalN instance. Used by @p ModelMulti to generate right size matrices
   * and vector for the solver.
   */
  void getSize();
  /**
   * @brief SignalN F(t,y,y') function evaluation
   *
   * Get the residues' values at a certain instant time with given state variables,
   * state variables derivatives
   *
   * @param t Simulation instant
   * @param[in] type type of the residues to compute (algebraic, differential or both)
   */
  void evalF(double t, propertyF_t type);
  /**
   * @brief SignalN G(t,y,y') function evaluation
   *
   * Get the root's value
   *
   * @param t Simulation instant
   */
  void evalG(const double & t);
  /**
   * @brief SignalN discrete variables evaluation
   *
   * Get the discrete variables' value depending on current simulation instant and
   * current state variables values.
   *
   * @param t Simulation instant
   */
  void evalZ(const double & t);
  /**
   * @brief set the silent flag for discrete variables
   * @param silentZTable flag table
   */
  void collectSilentZ(bool* silentZTable);
  /**
   * @brief Model mode change type evaluation
   *
   * Set the mode change type value depending on current simulation instant and
   * current state variables values.
   * @param[in] t Simulation instant
   * @return mode change type value
   */
  modeChangeType_t evalMode(const double &t);
  /**
   * @brief SignalN transposed jacobian evaluation
   *
   * Get the sparse transposed jacobian \f$ Jt=@F/@y + cj*@F/@y' \f$
   *
   * @param t Simulation instant
   * @param cj Jacobian prime coefficient
   * @param jt jacobian matrix to fullfill
   * @param rowOffset offset to use to identify the row where data should be added
   */
  void evalJt(const double &t, const double & cj, SparseMatrix& jt, const int& rowOffset);
  /**
   * @brief  SignalN transposed jacobian evaluation
   *
   * Get the sparse transposed jacobian \f$ Jt=@F/@y' \f$
   *
   * @param t Simulation instant
   * @param cj Jacobian prime coefficient
   * @param jt jacobian matrix to fullfill
   * @param rowOffset offset to use to identify the row where data should be added
   */
  void evalJtPrim(const double &t, const double & cj, SparseMatrix& jt, const int& rowOffset);
  /**
   * @brief calculate calculated variables
   */
  void evalCalculatedVars();

  /**
   * @copydoc ModelCPP::evalFType()
   */
  void evalFType();

  /**
   * @copydoc ModelCPP::updateFType()
   */
  void updateFType() { /* not needed */ }

  /**
   * @copydoc ModelCPP::getY0()
   */
  void getY0();

  /**
   * @copydoc ModelCPP::evalYType()
   */
  void evalYType();

  /**
   * @copydoc ModelCPP::updateYType()
   */
  void updateYType() { /* not needed */ }

  // output management
  /**
   * @brief get the global indexes of the variables used to compute a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param indexes vector to fill with the indexes
   *
   */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const;

  /**
   * @brief evaluate the jacobian associated to a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param res values of the jacobian
   */
  void evalJCalculatedVarI(unsigned iCalculatedVar, std::vector<double>& res) const;

  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   *
   * @return value of the calculated variable
   */
  double evalCalculatedVarI(unsigned iCalculatedVar) const;

  /**
   * @brief SignalN parameters setter
   */
  void setSubModelParameters();
  /**
   * @brief SignalN elements initializer
   *
   * Define elements for this model (elements to be seen by other models)
   *
   * @param elements  Reference to elements' vector
   * @param mapElement Map associating each element index in the elements vector to its name
   */
  void defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement);
  /**
   * @brief initialize variables of the model
   *
   * A variable is a structure which contained all information needed to interact with the model
   * @param variables vector to fill with each variables
   */
  void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables);
  /**
   * @brief define parameters
   * @param parameters vector to fill with each parameters
   */
  void defineParameters(std::vector<ParameterModeler>& parameters);
  /**
   * @brief get check sum number
   * @return the check sum number associated to the model
   */
  std::string getCheckSum() const;

  /**
   * @copydoc ModelCPP::initializeStaticData()
   */
  void initializeStaticData() { /* not needed */ }

  /**
   * @brief initialize the model from data interface
   *
   * @param data data interface to use to initialize the model
   */
  void initializeFromData(const boost::shared_ptr<DataInterface>& data);

  /**
   * @copydoc ModelCPP::setFequations()
   */
  void setFequations();

  /**
   * @copydoc ModelCPP::setGequations()
   */
  void setGequations() { /* not needed */ }

  /**
   * @copydoc ModelCPP::initParams()
   */
  void initParams() { /* not needed */ }

 private:
  /**
   * @brief Sort every generator by num of subNetwork
   *
   *
   */
  void sortGenByCC();
  /**
   * @brief calculate the initial state of the smacc automaton
   *
   */
  void calculateInitialState();

 private:
  static int col1stN_;  ///< offset to find the first row the residual functions about n
  static int col1stNGrp_;  ///< offset to find the first row the residual functions about n for each generator
  static int col1stTetaRef_;  ///< offset to find the first row the residual functions about tetaRef
  static int col1stAlphaSum_;  ///< offset to find the first row the residual functions about alphaSum
  static int col1stAlpha_;  ///< offset to find the first row the residual functions about alpha
  static int col1stAlphaSumGrp_;  ///< offset to find the first row the residual functions about alphaSum for each generators

  bool firstState_;  ///< @b true if the initial state must be calculated

  std::vector<int> numCCNode_;  ///< index of the network for each generators
  std::vector<double> alphaSum0_;  ///< initial values for alphaSum
  boost::unordered_map<int, std::vector<int> > genByCC_;  ///< list of generators for each network
  std::vector<int> numCCNodeOld_;  ///< save of the index of the network for each generators

  int nbGen_;  ///< number of generators
  int nbCC_;  ///< number of connected components
  std::vector<int> indexAlpha_;  ///< index for each alpha inside the local buffer
};

}  // namespace DYN

#endif  // MODELS_CPP_MODELFREQUENCY_MODELSIGNALN_DYNMODELSIGNALN_H_
