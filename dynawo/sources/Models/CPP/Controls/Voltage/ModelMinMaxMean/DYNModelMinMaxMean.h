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
 * @file  DYNModelMinMaxMean.h
 *
 * @brief model for voltage processing on local subnetworks
 *
 */

#ifndef MODELS_CPP_CONTROLS_VOLTAGE_MODELMINMAXMEAN_DYNMODELMINMAXMEAN_H_
#define MODELS_CPP_CONTROLS_VOLTAGE_MODELMINMAXMEAN_DYNMODELMINMAXMEAN_H_

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
class ModelMinMaxMeanFactory : public SubModelFactory {
 public:
  /**
   * @brief default constructor
   *
   */
  ModelMinMaxMeanFactory() {}
  /**
   * @brief default destructor
   *
   */
  virtual ~ModelMinMaxMeanFactory() {}
  /**
   * @brief ModelMinMaxMeanFactory getter
   *
   * @return A pointer to a new instance of ModelMinMaxMeanFactory
   */
  SubModel *create() const;
  /**
   * @brief ModelMinMaxMeanFactory destroy
   */
  void destroy(SubModel *) const;
};

/**
 * @brief Min-Max-Average model
 *
 *
 *
 */
class ModelMinMaxMean : public ModelCPP {
 public:
  /**
   * @brief define type of calculated variables
   *
   */
  typedef enum {
    minValIdx_ = 0,
    maxValIdx_ = 1,
    avgValIdx_ = 2,
    nbCalculatedVars_ = 3
  } CalculatedVars_t;
  /**
   * @brief MinMaxMean model default constructor
   *
   *
   */
  ModelMinMaxMean();

  /**
   * @brief MinMaxMean model default destructor
   *
   *
   */
  ~ModelMinMaxMean() { }
  /**
   * @brief MinMaxMean model initialization
   * @param t0 : initial time of the simulation
   */
  void init(const double t0);

  /**
   * @brief MinMaxMean model's sizes getter
   *
   * Get the sizes of the vectors and matrices used by the solver to simulate
   * ModelMinMaxMean instance. Used by @p ModelMulti to generate right size matrices
   * and vector for the solver.
   */
  void getSize();
  /**
   * @brief ModelMinMaxMean F(t,y,y') function evaluation
   *
   * Get the residues' values at a certain instant time with given state variables,
   * state variables derivatives
   *
   * @param t Simulation instant
   * @param[in] type type of the residues to compute (algebraic, differential or both)
   */
  void evalF(double t, propertyF_t type);
  /**
   * @brief ModelMinMaxMean G(t,y,y') function evaluation
   *
   * Get the root's value
   *
   * @param t Simulation instant
   */
  void evalG(const double t);
  /**
   * @brief ModelMinMaxMean discrete variables evaluation
   *
   * Get the discrete variables' value depending on current simulation instant and
   * current state variables values.
   *
   * @param t Simulation instant
   */
  void evalZ(const double t);

  /**
   * @brief set the silent flag for discrete variables
   * @param silentZTable flag table
   */
  void collectSilentZ(BitMask* silentZTable);

  /**
   * @copydoc ModelCPP::evalMode(const double t)
   */
  modeChangeType_t evalMode(const double t);
  /**
   * @brief MinMaxMean transposed jacobian evaluation
   *
   * Get the sparse transposed jacobian \f$ Jt=@F/@y + cj*@F/@y' \f$
   *
   * @param t Simulation instant
   * @param cj Jacobian prime coefficient
   * @param jt jacobian matrix to fullfill
   * @param rowOffset offset to use to identify the row where data should be added
   */
  void evalJt(const double t, const double cj, SparseMatrix& jt, const int rowOffset);
  /**
   * @brief  MinMaxMean transposed jacobian evaluation
   *
   * Get the sparse transposed jacobian \f$ Jt=@F/@y' \f$
   *
   * @param t Simulation instant
   * @param cj Jacobian prime coefficient
   * @param jt jacobian matrix to fullfill
   * @param rowOffset offset to use to identify the row where data should be added
   */
  void evalJtPrim(const double t, const double cj, SparseMatrix& jt, const int rowOffset);
  /**
   * @brief calculate calculated variables
   */
  void evalCalculatedVars();

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

  // output management
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
   * @brief MinMaxMean parameters setter
   */
  void setSubModelParameters();
  /**
   * @brief MinMaxMean elements initializer
   *
   * Define elements for this model( elements to be seen by other models)
   *
   * @param elements  Reference to elements' vector
   * @param mapElement Map associating each element index in the elements vector to its name
   */
  void defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement);
  /**
   * @copydoc SubModel::dumpUserReadableElementList()
   */
  void dumpUserReadableElementList(const std::string& nameElement) const;
  /**
   * @brief initialize variables of the model
   *
   * A variable is a structure which contains all information needed to interact with the model
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
  void setGequations() { /* not needed */ }

  /**
   * @copydoc ModelCPP::initParams()
   */
  void initParams() { /* not needed */ }

  /**
   * @copydoc ModelCPP::checkDataCoherence(const double t)
   */
  void checkDataCoherence(const double t);

  /**
   * @copydoc SubModel::hasDataCheckCoherence() const
   */
  bool hasCheckDataCoherence() const { return true; }

 private:
  /**
   * @brief updates the voltage value of a given asset
   */
  void updateAsset(const double &newVal, const int &assetId);

  /**
   * @brief re connect an asset to the subnetwork
   */
  void enableAsset(const double &newVal, const int &assetId);

  /**
   * @brief disables an asset but keeps it connected
   */
  void disableAsset(const int &id);

  /**
   * @brief gets the minimum value of the (connected and active) input voltages
   */
  double computeMin() const;

  /**
   * @brief gets the maximum value of the (connected and active) input voltages
   */
  double computeMax() const;

  /**
   * @brief gets the average value of the (connected and active) input voltages
   */
  double computeMean() const;

 private:
  // Inputs, which can be changed dynamically.
  std::vector<double> voltageInputs_;  ///< Voltages considered in the inputs
  std::vector<bool> isActive_;  ///< Keeps a flag if a given asset is active

  // State variables which we keep to be called at any time
  double minVal_;
  double maxVal_;
  double avgVal_;

  // We'll decide later if we need these:
  int idxMin_;  ///< Index of an entry reaching the minimum value
  int idxMax_;  ///< Index of an entry reaching the maximum value

  // A couple of useful variables to speed up computations in real time
  int nbCurActiveInputs_;  ///< Number of active inputs

  bool isInitialized_;
};

}  // namespace DYN

#endif  // MODELS_CPP_CONTROLS_VOLTAGE_MODELMINMAXMEAN_DYNMODELMINMAXMEAN_H_
