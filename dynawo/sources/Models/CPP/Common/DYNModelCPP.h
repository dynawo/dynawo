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

#include "DYNSparseMatrix.h"
#include "DYNSubModel.h"

namespace DYN {
/**
 * class ModelCPP
 */
class ModelCPP : public SubModel {
 public:
  /**
   * @brief Default constructor
   *
   */
  ModelCPP() {}

  /**
   * @brief constructor
   * @param modelType
   */
  explicit ModelCPP(const std::string& modelType);

  /**
   * @brief Default destructor
   *
   */
  virtual ~ModelCPP() {}

  /**
   * @brief parameters initiation
   *
   */
  virtual void initParams() = 0;

  /**
   * @brief initialize all the data for a sub model
   * @param t0: initial time of the simulation
   */
  virtual void init(const double& t0) = 0;

  /**
   * @brief get the global indexes of the variables used to compute a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param indexes vector to fill with the indexes
   *
   */
  virtual void getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const = 0;

  /**
   * @brief evaluate the jacobian associated to a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param res values of the jacobian
   */
  virtual void evalJCalculatedVarI(unsigned iCalculatedVar, std::vector<double>& res) const = 0;

  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   *
   * @return value of the calculated variable based on current continuous variables values
   */
  virtual double evalCalculatedVarI(unsigned iCalculatedVar) const = 0;

  /**
   * @brief get checksum
   * @return checksum string
   */
  virtual std::string getCheckSum() const = 0;

  /**
   * @copydoc SubModel::modelType
   */
  inline std::string modelType() const {
    return modelType_;
  }

  /**
   * @brief export the parameters of the sub model for dump
   *
   * @param mapParameters : map associating the file where parameters should be dumped with the stream of parameters
   */
  void dumpParameters(std::map<std::string, std::string>& mapParameters);

  /**
   * @brief export the variables values of the sub model for dump
   *
   * @param mapVariables : map associating the file where values should be dumped with the stream of values
   */
  void dumpVariables(std::map<std::string, std::string>& mapVariables);

  /**
   * @brief load the parameters values from a previous dump
   *
   * @param parameters : stream of values where the parameters were dumped
   */
  void loadParameters(const std::string& parameters);

  /**
   * @brief load the variables values from a previous dump
   *
   * @param variables : stream of values where the variables were dumped
   */
  void loadVariables(const std::string& variables);

  /**
   * @brief  CPP Model F(t,y,y') function evaluation
   *
   * Get the residues' values at a certain instant time with given state variables,
   * state variables derivatives
   * @param[in] t Simulation instant
   * @param[in] type type of the residues to compute (algebraic, differential or both)
   */
  virtual void evalF(double t, propertyF_t type) = 0;

  /**
   * @brief  CPP Model G(t,y,y') function evaluation
   *
   * Get the roots' value
   * @param[in] t Simulation instant
   */
  virtual void evalG(const double& t) = 0;

  /**
   * @brief  CPP Model discrete variables evaluation
   *
   * Get the discrete variables' value depending on current simulation instant and
   * current state variables values.
   * @param[in] t Simulation instant
   * @throws Error::MODELER typed @p Error. Shouldn't, but if it happens
   * it shows that there is a bug in the selection of activated shunt.
   */
  virtual void evalZ(const double& t) = 0;

  /**
   * @brief  CPP Model transposed jacobian evaluation
   *
   * Get the sparse transposed jacobian
   * @param[in] t Simulation instant
   * @param[in] cj Jacobian prime coefficient
   * @param jt jacobian matrix to fullfill
   * @param rowOffset offset to use to identify the row where data should be added
   */
  virtual void evalJt(const double& t, const double& cj, SparseMatrix& jt, const int& rowOffset) = 0;

  /**
   * @brief calculate jacobien prime matrix
   *
   * @param[in] t Simulation instant
   * @param[in] cj Jacobian prime coefficient
   * @param jt jacobian matrix to fullfill
   * @param rowOffset offset to use to identify the row where data should be added
   */
  virtual void evalJtPrim(const double& t, const double& cj, SparseMatrix& jt, const int& rowOffset) = 0;

  /**
   * @copydoc SubModel::evalMode(const double& t)
   */
  virtual modeChangeType_t evalMode(const double& t) = 0;

  /**
   * @brief  CPP Model initial state variables' evaluation
   *
   * Set the initial value of model's state variables, state variables derivatives
   * and discrete variables.
   */
  virtual void getY0() = 0;

  /**
   * @brief calculate calculated variables
   */
  virtual void evalCalculatedVars() = 0;

  /**
   * @brief evaluate variables' properties
   */
  virtual void evalYType() = 0;

  /**
   * @brief update variables' properties during the simulation
   */
  virtual void updateYType() = 0;

  /**
   * @brief evaluate residual functions' properties
   */
  virtual void evalFType() = 0;

  /**
   * @brief set the silent flag for discrete variables
   * @param silentZTable flag table
   */
  virtual void collectSilentZ(BitMask* silentZTable) = 0;

  /**
   * @brief update residual functions' properties during the simulation
   */
  virtual void updateFType() = 0;

  /**
   * @brief  CPP Model model's sizes getter
   *
   * Get the sizes of the vectors and matrixes used by the solver to simulate
   * Model CPP Model instance. Used by @p ModelMulti to generate right size matrixes
   * and vector for the solver.
   */
  virtual void getSize() = 0;

  /**
   * @copydoc SubModel::setSubModelParameters()
   */
  virtual void setSubModelParameters() = 0;

  /**
   * @copydoc SubModel::setSharedParametersDefaultValues()
   */
  virtual void setSharedParametersDefaultValues() { /* no parameter */
  }

  /**
   * @copydoc SubModel::setSharedParametersDefaultValuesInit()
   */
  virtual void setSharedParametersDefaultValuesInit() { /* no parameter */
  }

  /**
   * @brief  CPP Model elements initializer
   *
   * Define  CPP Model elements (connection variables for output and other models).
   * @param[out] elements Reference to elements' vector
   * @param[out] mapElement Map associating each element index in the elements vector to its name
   */
  //---------------------------------------------------------------------
  virtual void defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) = 0;

  /**
   * @brief initialze static data
   *
   */
  virtual void initializeStaticData() = 0;

  /**
   * @brief write initial values of a model in a file
   *
   * @param directory directory where the file should be printed
   */
  void printInitValues(const std::string& directory);

  /**
   * @brief rotate buffers
   *
   */
  void rotateBuffers() {
    /* not needed */
  }

  /**
   * @copydoc SubModel::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables)
   */
  virtual void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) = 0;

  /**
   * @copydoc SubModel::defineParameters(std::vector<ParameterModeler>& parameters)
   */
  virtual void defineParameters(std::vector<ParameterModeler>& parameters) = 0;

  /**
   * @copydoc SubModel::defineVariablesInit(std::vector<boost::shared_ptr<Variable> >& variables)
   */
  void defineVariablesInit(std::vector<boost::shared_ptr<Variable> >& variables);

  /**
   * @copydoc SubModel::defineParametersInit(std::vector<ParameterModeler>& parameters)
   */
  void defineParametersInit(std::vector<ParameterModeler>& parameters);

  /**
   * @copydoc SubModel::checkDataCoherence(const double& t)
   */
  void checkDataCoherence(const double& t);

  /**
   * @copydoc SubModel::checkParametersCoherence() const
   */
  void checkParametersCoherence() const;

  /**
   * @copydoc SubModel::setFequations()
   */
  virtual void setFequations() = 0;

  /**
   * @copydoc SubModel::setGequations()
   */
  virtual void setGequations() = 0;

  /**
   * @copydoc SubModel::setFequationsInit()
   */
  virtual void setFequationsInit() { /* no init model for most of CPP models */
  }

  /**
   * @copydoc SubModel::setGequationsInit()
   */
  virtual void setGequationsInit() { /* no init model for CPP models */
  }

  /**
   * @copydoc SubModel::initSubBuffers()
   */
  virtual void initSubBuffers() { /* no internal buffers for CPP models excepted the network model */
  }

  /**
   * @copydoc SubModel::notifyTimeStep()
   */
  void notifyTimeStep() {
    // do nothing
  }

 private:
  std::string modelType_;  ///< model type
};

}  // namespace DYN

#endif  // MODELS_CPP_COMMON_DYNMODELCPP_H_
