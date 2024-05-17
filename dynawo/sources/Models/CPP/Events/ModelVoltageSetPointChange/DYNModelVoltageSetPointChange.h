//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file  DYNModelVoltageSetPointChange.h
 *
 * @brief Model to handle a voltage set point change on loads
 *
 */
#ifndef MODELS_CPP_EVENTS_MODELVOLTAGESETPOINTCHANGE_DYNMODELVOLTAGESETPOINTCHANGE_H_
#define MODELS_CPP_EVENTS_MODELVOLTAGESETPOINTCHANGE_DYNMODELVOLTAGESETPOINTCHANGE_H_

#include "DYNModelCPP.h"
#include "DYNSubModelFactory.h"

namespace DYN {

/**
 * @brief ModelVoltageSetPointChangeFactory Model factory
 *
 * Implementation of @p SubModelFactory template for ModelVoltageSetPointChangeFactory Model
 */
class ModelVoltageSetPointChangeFactory : public SubModelFactory {
 public:
  /**
   * @brief default constructor
   *
   */
  ModelVoltageSetPointChangeFactory() { }

  /**
   * @brief Model VoltageSetPointChange getter
   *
   * @return A pointer to a new instance of Model VoltageSetPointChange
   */
  SubModel* create() const;

  /**
   * @brief Model VoltageSetPointChange destroy
   */
  void destroy(SubModel*) const;
};

/**
 * class ModelVoltageSetPointChange
 */
class ModelVoltageSetPointChange : public ModelCPP {
 public:
  /**
   * @brief define type of calculated variables
   *
   */
  typedef enum {
    nbCalculatedVars_ = 0
  } CalculatedVars_t;

  /**
   * @brief Default constructor
   *
   * Creates a new ModelVoltageSetPointChange instance.
   */
  ModelVoltageSetPointChange();

  /**
   * @brief  VoltageSetPointChange model initialization routine
   * @param t0 : initial time of the simulation
   */
  void init(const double t0);

  /**
   * @brief  VoltageSetPointChange model's sizes getter
   *
   * Get the sizes of the vectors and matrixs used by the solver to simulate
   * Model VoltageSetPointChange instance. Used by @p ModelMulti to generate right size matrixs
   * and vector for the solver.
   */
  void getSize();

  /**
   * @brief  VoltageSetPointChange F(t,y,y') function evaluation
   *
   * Get the residues' values at a certain instant time with given state variables,
   * state variables derivatives
   * @param[in] t Simulation instant
   * @param[in] type type of the residues to compute (algebraic, differential or both)
   */
  void evalF(double t, propertyF_t type);

  /**
   * @brief  VoltageSetPointChange G(t,y,y') function evaluation
   *
   * Get the roots' value
   * @param[in] t Simulation instant
   */
  void evalG(const double t);

  /**
   * @brief  VoltageSetPointChange discrete variables evaluation
   *
   * Get the discrete variables' value depending on current simulation instant and
   * current state variables values.
   * @param[in] t Simulation instant
   * @throws Error::MODELER typed @p Error. Shouldn't, but if it happens
   * it shows that there is a bug in the selection of activated shunt.
   */
  void evalZ(const double t);

  /**
   * @copydoc SubModel::collectSilentZ()
   */
  void collectSilentZ(BitMask* silentZTable);

  /**
   * @copydoc ModelCPP::evalMode(const double t)
   */
  modeChangeType_t evalMode(const double t);

  /**
   * @brief calculate calculated variables
   */
  void evalCalculatedVars();

  /**
   * @brief  VoltageSetPointChange transposed jacobian evaluation
   *
   * Get the sparse transposed jacobian
   * @param[in] t Simulation instant
   * @param[in] cj Jacobian prime coefficient
   * @param jt jacobian matrix to fullfill
   * @param rowOffset offset to use to identify the row where data should be added
   */
  void evalJt(const double t, const double cj, SparseMatrix& jt, const int rowOffset);

  /**
   * @brief calculate jacobien prime matrix
   *
   * @param[in] t Simulation instant
   * @param[in] cj Jacobian prime coefficient
   * @param jt jacobian matrix to fullfill
   * @param rowOffset offset to use to identify the row where data should be added
   */
  void evalJtPrim(const double t, const double cj, SparseMatrix& jt, const int rowOffset);

  /**
   * @copydoc ModelCPP::evalStaticFType()
   */
  void evalStaticFType();

  /**
   * @copydoc ModelCPP::evalDynamicFType()
   */
  void evalDynamicFType() { /* not needed */}

  /**
   * @copydoc ModelCPP::getY0()
   */
  void getY0();

  /**
   * @copydoc ModelCPP::evalStaticYType()
   */
  void evalStaticYType();

  /**
   * @copydoc ModelCPP::evalDynamicYType()
   */
  void evalDynamicYType() { /* not needed */}

  /**
   * @brief get the index of variables used to define the jacobian associated to a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param indexes vector to fill with the indexes
   */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const;

  /**
   * @brief evaluate the jacobian associated to a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param res values of the jacobian
   */
  void evalJCalculatedVarI(unsigned iCalculatedVar, std::vector<double>& res)const;

  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   *
   * @return value of the calculated variable
   */
  double evalCalculatedVarI(unsigned iCalculatedVar) const;

  /**
   * @brief  VoltageSetPointChange parameters setter
   */
  void setSubModelParameters();

  /**
   * @brief  VoltageSetPointChange elements initializer
   *
   * Define  VoltageSetPointChange elements (connection variables for output and other models).
   * @param[out] elements Reference to elements' vector
   * @param[out] mapElement Map associating each element index in the elements vector to its name
   */
  void defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement);

  /**
   * @copydoc SubModel::dumpUserReadableElementList()
   */
  void dumpUserReadableElementList(const std::string& nameElement) const;

  /**
   * @copydoc ModelCPP::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables)
   */
  void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables);

  /**
   * @copydoc ModelCPP::defineParameters(std::vector<ParameterModeler>& parameters)
   */
  void defineParameters(std::vector<ParameterModeler>& parameters);

  /**
   * @brief get check sum number
   * @return checksum string
   */
  std::string getCheckSum() const;

  /**
   * @copydoc ModelCPP::initializeStaticData()
   */
  void initializeStaticData();

  /**
   * @copydoc ModelCPP::initializeFromData(const boost::shared_ptr<DataInterface> &data)
   */
  void initializeFromData(const boost::shared_ptr<DataInterface>& data);

  /**
   * @copydoc ModelCPP::setFequations()
   */
  void setFequations();

  /**
   * @copydoc ModelCPP::setGequations()
   */
  void setGequations();

  /**
   * @copydoc ModelCPP::initParams()
   */
  void initParams() { /* not needed */ }

 private:
  double startTime_;  ///< start time
  double stopTime_;  ///< stop time
  double voltageSetPointChange_;  ///< value of the voltage change point change
  int numLoads_;  ///< number of loads
  bool startTimelineAdded_;  ///< true if the timeline indicating the start of the voltage set point was added
  bool endTimelineAdded_;  ///< true if the timeline indicating the end of the voltage set point was added
};

}  // namespace DYN

#endif  // MODELS_CPP_EVENTS_MODELVOLTAGESETPOINTCHANGE_DYNMODELVOLTAGESETPOINTCHANGE_H_
