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
 * @file  DYNModelCPP.h
 *
 * @brief Class Interface to describe a c++ model : header file
 *
 */
#ifndef MODELS_CPP_COMMON_DYNMODELCPP_H_
#define MODELS_CPP_COMMON_DYNMODELCPP_H_

#include "DYNSubModel.h"

#include <map>
#include <set>
#include <vector>

namespace DYN {
class SparseMatrix;

/**
 * @brief CPP model
 */
class ModelCPP : public SubModel {
 public:
  /**
   * @brief Default constructor
   *
   */
  ModelCPP();

  /**
   * @brief constructor
   * @param modelType model's type
   */
  explicit ModelCPP(std::string modelType);

  /**
   * @brief Destructor
   */
  ~ModelCPP() override = default;

 public:
  /**
   * @brief initialize all the data for a sub model
   * @param t0 initial time of the simulation
   */
  void init(const double t0) override = 0;

  /**
   * @brief get the global indexes of the variables used to compute a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param indexes vector to fill with the indexes
   *
   */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const override = 0;

  /**
   * @brief evaluate the jacobian associated to a calculated variable based on the current values of continuous variables
   *
   * @param iCalculatedVar index of the calculated variable
   * @param res values of the jacobian
   */
  void evalJCalculatedVarI(unsigned iCalculatedVar, std::vector<double>& res) const override = 0;

  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @return value of the calculated variable based on the current values of continuous variables
   */
  double evalCalculatedVarI(unsigned iCalculatedVar) const override = 0;

  /**
   * @copydoc SubModel::dumpParameters(std::map< std::string, std::string >& mapParameters)
   */
  void dumpParameters(std::map< std::string, std::string >& mapParameters) override;

  /**
   * @copydoc SubModel::dumpVariables(std::map< std::string, std::string >& mapVariables)
   */
  void dumpVariables(std::map< std::string, std::string >& mapVariables) override;

  /**
   * @brief  CPP Model F(t,y,y') function evaluation
   *
   * Get the residues' values at a certain instant time with given state variables,
   * state variables derivatives
   * @param[in] t Simulation instant
   * @param[in] type type of the residues to compute (algebraic, differential or both)
   */
  void evalF(double t, propertyF_t type) override = 0;

  /**
   * @brief  CPP Model G(t,y,y') function evaluation
   *
   * Get the roots' value
   * @param[in] t Simulation instant
   */
  void evalG(const double t) override = 0;

  /**
   * @brief  CPP Model discrete variables evaluation
   *
   * Get the discrete variables' value depending on current simulation instant and
   * current state variables values.
   * @param[in] t Simulation instant
   * @throws Error::MODELER typed @p Error. Shouldn't, but if it happens
   * it shows that there is a bug in the selection of activated shunt.
   */
  void evalZ(const double t) override = 0;

  /**
   * @brief  CPP Model transposed jacobian evaluation
   *
   * Get the sparse transposed jacobian
   * @param[in] t Simulation instant
   * @param[in] cj Jacobian prime coefficient
   * @param jt jacobian matrix to fullfill
   * @param rowOffset offset to use to identify the row where data should be added
   */
  void evalJt(const double t, const double cj, SparseMatrix& jt, const int rowOffset) override = 0;

  /**
   * @brief calculate jacobien prime matrix
   *
   * @param[in] t Simulation instant
   * @param[in] cj Jacobian prime coefficient
   * @param jt jacobian matrix to fullfill
   * @param rowOffset offset to use to identify the row where data should be added
   */
  void evalJtPrim(const double t, const double cj, SparseMatrix& jt, const int rowOffset) override = 0;

  /**
   * @copydoc SubModel::evalMode(const double t)
   */
  modeChangeType_t evalMode(const double t) override = 0;

  /**
   * @brief  CPP Model initial state variables' evaluation
   *
   * Set the initial value of model's state variables, state variables derivatives
   * and discrete variables.
   */
  void getY0() override = 0;

  /**
   * @brief calculate calculated variables
   */
  void evalCalculatedVars() override = 0;

  /**
   * @brief evaluate the properties of the variables that won't change during simulation
   * (algebraic, differential, external or external optional variables)
   *
   */
  void evalStaticYType() override = 0;

  /**
   * @brief update during the simulation the properties of the variables that depends on others variables values
   *
   */
  void evalDynamicYType() override = 0;

  /**
   * @brief evaluate the properties of the residual function  that won't change during simulation (algebraic or differential equation)
   *
   */
  void evalStaticFType() override = 0;

  /**
   * @brief set the silent flag for discrete variables
   * @param silentZTable flag table
   */
  void collectSilentZ(BitMask* silentZTable) override = 0;

  /**
   * @brief update during the simulation the properties of the residual functions that depends on others variables values
   */
  void evalDynamicFType() override = 0;

  /**
   * @brief  CPP Model model's sizes getter
   *
   * Get the sizes of the vectors and matrixes used by the solver to simulate
   * Model CPP Model instance. Used by @p ModelMulti to generate right size matrixes
   * and vector for the solver.
   */
  void getSize() override = 0;

  /**
   * @copydoc SubModel::setSubModelParameters()
   */
  void setSubModelParameters() override = 0;

  /**
   * @copydoc SubModel::setSharedParametersDefaultValues()
   */
  void setSharedParametersDefaultValues() override { /* no parameter */ }

  /**
   * @copydoc SubModel::setSharedParametersDefaultValuesInit()
   */
  void setSharedParametersDefaultValuesInit() override { /* no parameter */ }

  /**
   * @brief  CPP Model elements initializer
   *
   * Define  CPP Model elements (connection variables for output and other models).
   * @param[out] elements Reference to elements' vector
   * @param[out] mapElement Map associating each element index in the elements vector to its name
   */
  void defineElements(std::vector<Element>& elements, std::map<std::string, int >& mapElement) override = 0;

  /**
   * @brief get checksum
   * @return checksum string
   */
  virtual std::string getCheckSum() const = 0;

  /**
   * @brief initialze static data
   *
   */
  void initializeStaticData() override = 0;


  /**
   * @copydoc SubModel::setFequationsInit()
   */
  void setFequationsInit() override { /* no init model for most of CPP models */ }

  /**
   * @copydoc SubModel::setGequationsInit()
   */
  void setGequationsInit() override { /* no init model for CPP models */ }

  /**
   * @copydoc SubModel::initSubBuffers()
   */
  void initSubBuffers() override { /* no internal buffers for CPP models excepted the network model */ }

  /**
   * @copydoc SubModel::notifyTimeStep()
   */
  void notifyTimeStep() override {
    // do nothing
  }

  /**
   * @brief get model type
   * @return model type
   */
  inline std::string modelType() const override {
    return modelType_;
  }

  /**
   * @copydoc SubModel::loadVariables(const std::string& variables)
   */
  void loadVariables(const std::string& variables) override;

  /**
   * @copydoc SubModel::loadParameters(const std::string& parameters)
   */
  void loadParameters(const std::string& parameters) override;

  /**
   * @copydoc SubModel::checkParametersCoherence() const
   */
  void checkParametersCoherence() const override;

  /**
   * @brief rotate buffers
   */
  void rotateBuffers() override { /* not needed */ }

  /**
   * @copydoc SubModel::defineVariablesInit(std::vector<boost::shared_ptr<Variable> >& variables)
   */
  void defineVariablesInit(std::vector<boost::shared_ptr<Variable> >& variables) override;

  /**
   * @copydoc SubModel::defineParametersInit(std::vector<ParameterModeler>& parameters)
   */
  void defineParametersInit(std::vector<ParameterModeler>& parameters) override;

  /**
   * @brief define the indexes and names of all parameters and variables of a dynamic sub-model
   *
   * @param variables variables vector
   * @param zNames vector linking discrete variables with names
   * @param xNames vector linking continuous (possibly flow) variables with names
   * @param calculatedVarNames vector linking calculated variables with names
   */
  void defineNamesImpl(std::vector<boost::shared_ptr<Variable> >& variables, std::vector<std::string>& zNames,
                       std::vector<std::string>& xNames, std::vector<std::string>& calculatedVarNames) override;

  /**
   * @brief get whether the model is starting from dumped values
   * @return get whether the model is starting from dumped values
   */
  inline bool isStartingFromDump() const {
    return isStartingFromDump_;
  }

 protected:
   /**
   * @brief export the variables values of the sub model for dump in a stream
   *
   * @param streamVariables : map associating the file where values should be dumped with the stream of values
   */
  virtual void dumpVariablesInStream(std::stringstream& streamVariables);

  /**
   * @brief load the variables values from a previous dump
   * @param streamVariables : stream of values where the variables were dumped
   */
  virtual void loadVariablesFromStream(std::stringstream& streamVariables);

 private:
  std::string modelType_;  ///< model type
  bool isStartingFromDump_;  ///< whether the model is starting from dumped values
};

}  // namespace DYN

#endif  // MODELS_CPP_COMMON_DYNMODELCPP_H_
