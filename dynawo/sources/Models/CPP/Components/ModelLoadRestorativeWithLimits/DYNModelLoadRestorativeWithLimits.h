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
 * @file  DYNModelLoadRestorativeWithLimits.h
 *
 * @brief Load restorative with limits model header
 *
 */

#ifndef MODELS_CPP_COMPONENTS_MODELLOADRESTORATIVEWITHLIMITS_DYNMODELLOADRESTORATIVEWITHLIMITS_H_
#define MODELS_CPP_COMPONENTS_MODELLOADRESTORATIVEWITHLIMITS_DYNMODELLOADRESTORATIVEWITHLIMITS_H_

#include "DYNModelCPPImpl.h"
#include "DYNModelConstants.h"
#include "DYNSubModelFactory.h"

namespace DYN {
class DataInterface;
/**
* @brief ModelLoadRestorativeWithLimits factory
*
* Implementation of @p SubModelFactory template for ModelLoadRestorativeWithLimits model
*/
class ModelLoadRestorativeWithLimitsFactory : public SubModelFactory {
 public:
  /**
  * @brief default constructor
  *
  */
  ModelLoadRestorativeWithLimitsFactory() { }
  /**
  * @brief default destructor
  *
  */
  virtual ~ModelLoadRestorativeWithLimitsFactory() { }
  /**
  * @brief ModelLoadRestorativeWithLimits getter
  *
  * @return A pointer to a new instance of ModelLoadRestorativeWithLimits
  */
  SubModel* create() const;
  /**
  * @brief ModelLoadRestorativeWithLimits destroy
  */
  void destroy(SubModel*) const;
};

/**
* @brief ModelLoadRestorativeWithLimits class
*/
class ModelLoadRestorativeWithLimits : public ModelCPP::Impl {
 public:
  /**
  * @brief default constructor
  */
  ModelLoadRestorativeWithLimits();
  /**
  * @brief destructor
  */
  virtual ~ModelLoadRestorativeWithLimits() { }
  /**
   * @brief get check sum number
   * @return the check sum number associated to the model
   */
  std::string getCheckSum() const;
  /**
  * @brief  calculated variables type
  */
  typedef enum {
    loadStateNum_ = 0,
    nbCalculatedVariables_ = 1
  } CalculatedVariables_t;
  /**
  * @brief define parameters
  * @param parameters: vector to fill with the generic parameters
  */
  void defineParameters(std::vector<ParameterModeler>& parameters);
  /**
  * @brief ModelLoadRestorativeWithLimits parameters setter
  */
  void setSubModelParameters();
  /**
  * @brief ModelLoadRestorativeWithLimits model initialization
  * @param t0 : initial time of the simulation
  */
  void init(const double& t0);
  /**
  * @brief get the connection status of the load
  * @return connection status
  */
  inline State getConnected() const {
    return connectionState_;
  }
  /**
  * @brief set the load connection status
  * @param state
  */
  void setConnected(State state) {
    connectionState_ = state;
  }
  /**
  * @brief check whether the load is connected to the bus
  * @return @b True if the load is connected, @b false else
  */
  inline bool isConnected() const {
    return (connectionState_ == CLOSED);
  }
  /**
  * @brief set the silent flag for discrete variables
  * @param silentZTable flag table
  */
  void collectSilentZ(BitMask* silentZTable);
  /**
  * @brief ModelLoadRestorativeWithLimits model's sizes getter
  *
  * Get the sizes of the vectors and matrices used by the solver to simulate
  * ModelLoadRestorativeWithLimits instance. Used by @p ModelMulti to generate right size matrices
  * and vector for the solver.
  */
  void getSize();
  /**
  * @copydoc ModelCPP::evalStaticYType()
  */
  void evalStaticYType();
  /**
   * @copydoc ModelCPP::evalDynamicYType()
   */
  void evalDynamicYType() { /* not needed */}
  /**
  * @copydoc ModelCPP::evalStaticFType()
  */
  void evalStaticFType();
  /**
   * @copydoc ModelCPP::evalDynamicFType()
   */
  void evalDynamicFType() { /* not needed */}
  /**
  * @brief initialize variables of the model
  *
  * A variable is a structure which contained all information needed to interact with the model
  * @param variables vector to fill with each variables
  */
  void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables);
  /**
  * @brief ModelLoadRestorativeWithLimits F(t,y,y') function evaluation
  *
  * Get the residues' values at a certain instant time with given state variables,
  * state variables derivatives
  *
  * @param t Simulation instant
  * @param[in] type type of the residues to compute (algebraic, differential or both)
  */
  void evalF(double t, propertyF_t type);
  /**
  * @copydoc ModelCPP::setFequations()
  */
  void setFequations();
  /**
  * @brief ModelLoadRestorativeWithLimits transposed jacobian evaluation
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
  * @brief ModelLoadRestorativeWithLimits G(t,y,y') function evaluation
  *
  * Get the root's value
  *
  * @param t Simulation instant
  */
  void evalG(const double & t);
  /**
  * @copydoc ModelCPP::setGequations()
  */
  void setGequations();
  /**
  * @brief  ModelLoadRestorativeWithLimits transposed jacobian evaluation
  *
  * Get the sparse transposed jacobian \f$ Jt=@F/@y' \f$
  *
  * @param t Simulation instant
  * @param cj Jacobian prime coefficient
  * @param jt jacobian matrix to fullfill
  * @param rowOffset offset to use to identify the row where data should be added
  */
  void evalJtPrim(const double & t, const double & cj, SparseMatrix& jt, const int& rowOffset);
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
  * @copydoc ModelCPP::getY0()
  */
  void getY0();
  /**
  * @copydoc ModelCPP::initParams()
  */
  void initParams() { /* not needed */ }
  /**
  * @brief initialize the model from data interface
  *
  * @param data data interface to use to initialize the model
  */
  void initializeFromData(const boost::shared_ptr<DataInterface>& data);
  /**
  * @copydoc ModelCPP::initializeStaticData()
  */
  void initializeStaticData() { /* not needed */ }
  /**
  * @brief evaluate the value of a calculated variable
  *
  * @param iCalculatedVar index of the calculated variable
  *
  * @return value of the calculated variable
  */
  double evalCalculatedVarI(unsigned iCalculatedVar) const;
  /**
  * @brief calculate calculated variables
  */
  void evalCalculatedVars();
  /**
  * @brief evaluate the jacobian associated to a calculated variable
  *
  * @param iCalculatedVar index of the calculated variable
  * @param res values of the jacobian
  */
  void evalJCalculatedVarI(unsigned iCalculatedVar, std::vector<double>& res) const;
  /**
  * @brief get the global indexes of the variables used to compute a calculated variable
  *
  * @param iCalculatedVar index of the calculated variable
  * @param indexes vector to fill with the indexes
  *
  */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const;
  /**
  * @brief ModelLoadRestorativeWithLimits elements initializer
  *
  * Define elements for this model (elements to be seen by other models)
  *
  * @param elements  Reference to elements' vector
  * @param mapElement Map associating each element index in the elements vector to its name
  */
  void defineElements(std::vector<Element> &elements, std::map<std::string, int >& mapElement);
  /**
  * @brief ModelLoadRestorativeWithLimits discrete variables evaluation
  *
  * Get the discrete variables' value depending on current simulation instant and
  * current state variables values.
  *
  * @param t Simulation instant
  */
  void evalZ(const double & t);

  /**
   * @brief Coherence check on data (asserts, min/max values, sanity checks)
   */
  void checkDataCoherence(const double& /*t*/) { /* not needed */ }

 private:
  State connectionState_;  ///< "internal" load connection status
  State preConnectionState_;  ///< "internal" load connection status at previous timestamp
  unsigned int UfRawYNum_;  ///< local Y index for UfRaw
  unsigned int UfYNum_;  ///< local Y index for Uf
  unsigned int UrYNum_;  ///< local Y index for Ur
  unsigned int UiYNum_;  ///< local Y index for Ui
  unsigned int IrYNum_;  ///< local Y index for Ir
  unsigned int IiYNum_;  ///< local Y index for Ii
  unsigned int PYNum_;  ///< local Y index for P
  unsigned int QYNum_;  ///< local Y index for Q

  double u0Pu_;  ///< initial voltage
  double UfRawprim0_;  ///< initial value of derivative of UfRaw
  double Tf_;  ///< Time constant of the load restoration
  double P0Pu_;  ///< initial active power
  double Q0Pu_;  ///< initial reactive power
  double alpha_;   ///< active power exponential sensitivity to voltage
  double beta_;   ///< reactive power exponential sensitivity to voltage
  double angleO_;  ///< initial phase
  double UMinPu_;  ///< Minimum value of the voltage amplitude at terminal in p.u (base UNom) that ensures the P/Q restoration
  double UMaxPu_;  ///< Maximum value of the voltage amplitude at terminal in p.u (base UNom) that ensures the P/Q restoration
  bool UMinPuReached_;  ///< true if UMinPu limit is reached by UfRaw
  bool UMaxPuReached_;  ///< true if UMaxPu limit is reached by UfRaw
};

}  // namespace DYN

#endif  // MODELS_CPP_COMPONENTS_MODELLOADRESTORATIVEWITHLIMITS_DYNMODELLOADRESTORATIVEWITHLIMITS_H_
