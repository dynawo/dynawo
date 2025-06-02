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
 * @file  DYNModelVariationArea.h
 *
 * @brief
 *
 */
#ifndef MODELS_CPP_EVENTS_MODELVARIATIONAREA_DYNMODELVARIATIONAREA_H_
#define MODELS_CPP_EVENTS_MODELVARIATIONAREA_DYNMODELVARIATIONAREA_H_

#include "DYNModelCPP.h"
#include "DYNSubModelFactory.h"

namespace DYN {

/**
 * @brief ModelVariationAreaFactory Model factory
 *
 * Implementation of @p SubModelFactory template for ModelVariationAreaFactory Model
 */
class ModelVariationAreaFactory : public SubModelFactory {
 public:
  /**
   * @brief default constructor
   *
   */
  ModelVariationAreaFactory() { }

  /**
   * @brief Model VariationArea getter
   *
   * @return A pointer to a new instance of Model VariationArea
   */
  SubModel* create() const override;

  /**
   * @brief Model VariationArea destroy
   */
  void destroy(SubModel*) const override;
};

/**
 * class ModelVariationArea
 */
class ModelVariationArea : public ModelCPP {
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
   * Creates a new ModelVariationArea instance.
   */
  ModelVariationArea();

  // instantiate virtual methods of the Model class

  /**
   * @brief  VariationArea model initialization routine
   * @param t0 : initial time of the simulation
   */
  void init(double t0) override;

  /**
   * @brief  VariationArea model's sizes getter
   *
   * Get the sizes of the vectors and matrixs used by the solver to simulate
   * Model VariationArea instance. Used by @p ModelMulti to generate right size matrixs
   * and vector for the solver.
   */
  void getSize() override;

  /**
   * @brief  VariationArea F(t,y,y') function evaluation
   *
   * Get the residues' values at a certain instant time with given state variables,
   * state variables derivatives
   * @param[in] t Simulation instant
   * @param[in] type type of the residues to compute (algebraic, differential or both)
   */
  void evalF(double t, propertyF_t type) override;

  /**
   * @brief  VariationArea G(t,y,y') function evaluation
   *
   * Get the roots' value
   * @param[in] t Simulation instant
   */
  void evalG(double t) override;

  /**
   * @brief  VariationArea discrete variables evaluation
   *
   * Get the discrete variables' value depending on current simulation instant and
   * current state variables values.
   * @param[in] t Simulation instant
   */
  void evalZ(double t) override;

  /**
   * @copydoc SubModel::collectSilentZ()
   */
  void collectSilentZ(BitMask* silentZTable) override;

  /**
   * @copydoc ModelCPP::evalMode(double t)
   */
  modeChangeType_t evalMode(double t) override;

  /**
   * @brief calculate calculated variables
   */
  void evalCalculatedVars() override;

  /**
   * @brief  VariationArea transposed jacobian evaluation
   *
   * Get the sparse transposed jacobian
   * @param[in] t Simulation instant
   * @param[in] cj Jacobian prime coefficient
   * @param rowOffset offset to use to identify the row where data should be added
   * @param jt jacobian matrix to fullfill
   */
  void evalJt(double t, double cj, int rowOffset, SparseMatrix& jt) override;

  /**
   * @brief calculate jacobien prime matrix
   *
   * @param[in] t Simulation instant
   * @param[in] cj Jacobian prime coefficient
   * @param rowOffset offset to use to identify the row where data should be added
   * @param jtPrim jacobian matrix to fullfill
   */
  void evalJtPrim(double t, double cj, int rowOffset, SparseMatrix& jtPrim) override;

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
   * @brief  VariationArea parameters setter
   */
  void setSubModelParameters() override;

  /**
   * @brief  VariationArea elements initializer
   *
   * Define  VariationArea elements (connection variables for output and other models).
   * @param[out] elements Reference to elements' vector
   * @param[out] mapElement Map associating each element index in the elements vector to its name
   */
  void defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) override;

  /**
   * @copydoc SubModel::dumpUserReadableElementList()
   */
  void dumpUserReadableElementList(const std::string& nameElement) const override;

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

 private:
  // parameters
  std::vector<double> deltaP_;  ///< load variations for active power
  std::vector<double> deltaQ_;  ///< load variations for reactive power
  double startTime_;  ///< start time
  double stopTime_;  ///< stop time
  int nbLoads_;  ///< number of loads
  double timeModeOnGoingRaised_;  ///< true if the mode change indicating the start of the slope has been done
  double timeModeFinishedRaised_;  ///< true if the mode change indicating the end of the slope has been done

  /**
   * @brief enum to represent the current state of the variation
   */
  typedef enum {
    NOT_STARTED = 0,
    ON_GOING = 1,
    FINISHED = 2
  } variationState_t;
  variationState_t stateVariationArea_;  ///< equal to 1 if activated, 2 if ended, 0 either
};

}  // namespace DYN

#endif  // MODELS_CPP_EVENTS_MODELVARIATIONAREA_DYNMODELVARIATIONAREA_H_
