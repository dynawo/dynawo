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
 * @file  DYNModelNetwork.h
 *
 * @brief Model Network header.
 *
 * Model Network is the container of all subModels who constitute a network
 * such as voltage levels, lines (AC or DC), transformers, etc..
 *
 */
#ifndef MODELS_CPP_MODELNETWORK_DYNMODELNETWORK_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELNETWORK_H_

#include <boost/shared_ptr.hpp>
#include <boost/core/noncopyable.hpp>

#include "DYNModelCPP.h"
#include "DYNSubModelFactory.h"

namespace DYN {
class ModelBusContainer;
class ModelSwitch;
class ModelVoltageLevel;
class NetworkComponent;
class DataInterface;

static const double maximumValueCurrentLimit = 5000;   ///< Maximum acceptable value for current limits

/**
 * @brief Network Model factory
 *
 * Implementation of @p SubModelFactory template for Network Model
 */
class ModelNetworkFactory : public SubModelFactory {
 public:
  /**
   * @brief default constructor
   */
  ModelNetworkFactory() { }

  /**
   * @brief ModelNetwork getter
   * @return A pointer to a new instance of Model Network
   */
  SubModel* create() const;

  /**
   * @brief ModelNetwork destroy
   */
  void destroy(SubModel*) const;
};

/**
 * @class ModelNetwork
 *
 * @brief Generic class for the standard AC network (described using C++ models)
 */
class ModelNetwork : public ModelCPP, private boost::noncopyable {
 public:
  /**
   * @brief default constructor
   */
  ModelNetwork();
  /**
   * @brief destructor
   */
  ~ModelNetwork() override;

 public:
  /**
   * @brief initialize the network model
   * @param t0 initial time of the simulation
   */
  void init(const double t0) override;

  /**
   * @brief get the index of variables used to define the Jacobian associated to a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param indexes vector to fill with the indexes
   */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const override;

  /**
   * @brief evaluate the Jacobian associated to a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param res values of the Jacobian
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
   * @brief evaluation F
   * @param[in] t Simulation instant
   * @param[in] type type of the residues to compute (algebraic, differential or both)
   */
  void evalF(double t, propertyF_t type) override;

  /**
   * @brief evaluation G
   * @param t : time to use
   */
  void evalG(const double t) override;

  /**
   * @brief evaluation Z
   * @param t : time to use
   */
  void evalZ(const double t) override;

  /**
   * @copydoc ModelCPP::evalJt (const double t,const double cj, SparseMatrix& jt, const int rowOffset)
   */
  void evalJt(const double t, const double cj, SparseMatrix& jt, const int rowOffset) override;

  /**
   * @copydoc ModelCPP::evalJtPrim(const double t, const double cj, SparseMatrix& jt, const int rowOffset)
   */
  void evalJtPrim(const double t, const double cj, SparseMatrix& jt, const int rowOffset) override;

  /**
   * @copydoc ModelCPP::evalMode(const double t)
   */
  modeChangeType_t evalMode(const double t) override;

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
  void evalDynamicYType() override;

  /**
   * @copydoc ModelCPP::evalStaticFType()
   */
  void evalStaticFType() override;

  /**
   * @copydoc ModelCPP::collectSilentZ()
   */
  void collectSilentZ(BitMask* silentZTable) override;

  /**
   * @copydoc ModelCPP::evalDynamicFType()
   */
  void evalDynamicFType() override;

  /**
   * @brief retrieve the size of the network
   *
   */
  void getSize() override;

  /**
   * @brief network submodels parameters setter
   */
  void setSubModelParameters() override;

  /**
   * @brief define elements
   * @param elements vector of elements
   * @param mapElement map of elements
   */
  void defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) override;

  /**
   * @brief evaluation of the calculated variables (for outputs)
   */
  void evalCalculatedVars() override;

  /**
   * @brief define variables
   * @param variables variables
   */
  void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) override;

  /**
   * @copydoc SubModel::defineVariablesInit(std::vector<boost::shared_ptr<Variable> >& variables)
   */
  void defineVariablesInit(std::vector<boost::shared_ptr<Variable> >& variables) override;

  /**
   * @brief fill calculated variable and index for one component
   * @param component for which to add calculated variables
   */
  void fillCalculatedVarsComponentAndIndex(const boost::shared_ptr<NetworkComponent>& component);

  /**
   * @brief define parameters
   * @param parameters parameters
   */
  void defineParameters(std::vector<ParameterModeler>& parameters) override;

  /**
   * @brief get check sum number
   * @return checksum string
   */
  std::string getCheckSum() const override;

  /**
   * @brief initialize the static (IIDM) data
   */
  void initializeStaticData() override;

  /**
   * @brief init from data
   * @param data data
   */
  void initializeFromData(const boost::shared_ptr<DataInterface>& data) override;

  /**
   * @copydoc ModelCPP::setFequations()
   */
  void setFequations() override;

   /**
   * @copydoc ModelCPP::setFequationsInit()
   */
  void setFequationsInit() override;

  /**
   * @copydoc ModelCPP::setGequations()
   */
  void setGequations() override;

  /**
   * @brief get whether the current process is the initialization process
   * @return whether the current process is the initialization process
   */
  inline bool isInit() const {
    return isInit_;
  }

  /**
   * @brief get whether the current model is the init one
   * @return whether the current model is the init one
   */
  inline bool isInitModel() const {
    return isInitModel_;
  }

  /**
   * @brief get whether the current model is the init one
   * @param isInitModel whether the current model is the init one
   */
  inline void setIsInitModel(bool isInitModel) {
    isInitModel_ = isInitModel;
  }

  /**
   * @copydoc ModelCPP::initParams()
   */
  void initParams() override;

   /**
   * @copydoc ModelCPP::initSubBuffers()
   */
  void initSubBuffers() override;

  /**
   * @copydoc SubModel::printModel() const
   */
  void printModel() const override;

  /**
   * @brief load the variables values from a previous dump
   *
   * @param variables : stream of values where the variables were dumped
   */
  void loadVariables(const std::string& variables) override;

  /**
   * @brief export the variables values of the sub model for dump
   *
   * @param mapVariables : map associating the file where values should be dumped with the stream of values
   */
  void dumpVariables(std::map< std::string, std::string >& mapVariables) override;

  /**
   * @brief export the internal variables values of the sub model for dump in a stream
   *
   * @param streamVariables : map associating the file where values should be dumped with the stream of values
   */
  void dumpInternalVariables(boost::archive::binary_oarchive& streamVariables) const override;

  /**
   * @brief load the internal variables values from a previous dump
   *
   * @param streamVariables : stream of values where the variables were dumped
   */
  void loadInternalVariables(boost::archive::binary_iarchive& streamVariables) override;

 protected:
  /**
  * @copydoc SubModel::dumpUserReadableElementList()
  */
  void dumpUserReadableElementList(const std::string& nameElement) const override;

  // Specific methods for ModelNetwork class
  // ---------------------------------------------
 private:
  /**
   * @brief calculate Y matrix
   */
  void evalYMat();

  /**
   * @brief break Model Switch Loops
   *
   */
  void breakModelSwitchLoops();

  /**
   * @brief scan through the AC network to find AC-connected components
   * @param t : time to use (only used for log purpose)
   */
  void computeComponents(double t);

  /**
   * @brief analyze AC-connected components in network and keep the one with the most buses
   *
   */
  void analyseComponents();

  /**
   * @brief initialize the network : compute the current in each switch
   */
  void computeSwitchesCurrent();

  /**
   * @brief get the network components depending on the model used (init or not)
   * @return the vector of network component modeled
   */
  inline const std::vector<boost::shared_ptr<NetworkComponent> >& getComponents() const {
    return isInitModel_ ?  initComponents_ : components_;
  }

  /**
   * @brief get the voltage levels depending on the model used (init or not)
   * @return the vector of voltage levels modeled
   */
  inline const std::vector<boost::shared_ptr<ModelVoltageLevel> >& getVoltageLevels() const {
    return isInitModel_ ?  vLevelInitComponents_ : vLevelComponents_;
  }

  /**
   * @brief print network statistics into network log
   * @param data network data
   */
  void printStats(const boost::shared_ptr<DataInterface>& data) const;

  /**
   * @brief print a component statistics into network log
   * @param message message to display
   * @param nbStatic number of components without dynamic model
   * @param nbDynamic number of components with dynamic model
   */
  void printComponentStats(KeyLog_t::value message, unsigned nbStatic, unsigned nbDynamic) const;

  /**
  * @brief write initial values internal parameters of a model in a file
  *
  * @param fstream the file to stream parameters to
  */
  void printInternalParameters(std::ofstream& fstream) const override;

 private:
  double * calculatedVarBuffer_;  ///< calculated variable buffer

  bool isInit_;  ///< whether the current process is the initialization process
  bool isInitModel_;  ///< whether the current model used is the init one
  bool withNodeBreakerTopology_;  ///< whether at least one voltageLevel has node breaker topology view

  boost::shared_ptr<ModelBusContainer> busContainer_;  ///< all network buses
  std::vector<boost::shared_ptr<ModelVoltageLevel> > vLevelComponents_;  ///< all voltage level components
  std::vector<boost::shared_ptr<ModelVoltageLevel> > vLevelInitComponents_;  ///< all voltage level components  (used for init model)
  std::vector<boost::shared_ptr<NetworkComponent> > components_;  ///< all network components without dynamic Model
  std::vector<boost::shared_ptr<NetworkComponent> > initComponents_;  ///< all network components even components with dynamic model
  std::vector<int> componentIndexByCalculatedVar_;  ///< index of component for each calculated variable
};

}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNMODELNETWORK_H_
