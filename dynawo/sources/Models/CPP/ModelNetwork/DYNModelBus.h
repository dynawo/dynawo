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
 * @file  DYNModelBus.h
 *
 * @brief
 *
 */

#ifndef MODELS_CPP_MODELNETWORK_DYNMODELBUS_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELBUS_H_

#include <boost/optional.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/archive/binary_iarchive.hpp>
#include <boost/archive/binary_oarchive.hpp>

#include "DYNNetworkComponent.h"
#include "DYNBitMask.h"

namespace DYN {
class SubNetwork;  ///< AC-connected network
class BusInterface;
class BusDerivatives;
class ModelSwitch;
class ModelVoltageLevel;

/**
 * class ModelBus
 */
class ModelBus : public NetworkComponent {  ///< Generic AC network bus
 public:
  /**
   * @brief default constructor
   * @param bus bus data interface to use for the model
   * @param isNodeBreaker true if the voltage level is in NODE BREAKER
   */
  explicit ModelBus(const std::shared_ptr<BusInterface>& bus, bool isNodeBreaker);

  /**
   * @brief calculated variables type
   */
  typedef enum {
    upuNum_ = 0,
    phipuNum_ = 1,
    uNum_ = 2,
    phiNum_ = 3,
    nbCalculatedVariables_ = 4
  } CalculatedVariables_t;

  /**
   * @brief index variable type
   */
  typedef enum {
    urNum_ = 0,
    uiNum_ = 1,
    irNum_ = 2,
    iiNum_ = 3
  } IndexVariable_t;

  /**
   * @brief index discrete variable
   */
  typedef enum {
    numSubNetworkNum_ = 0,
    switchOffNum_ = 1,
    connectionStateNum_ = 2
  } IndexDiscreteVariable_t;

  /**
   * @brief Flags of the U calculation status for the current time step
   */
  typedef enum {
    NoCalculation = 0x00,
    U2Pu = 0x01,
    UPu = 0x02,
    U = 0x04
  } UStatusFlags;

  /**
   * @brief U calculation type requested (U², U in pu or U in S.I)
   */
  typedef enum {
    U2PuType_ = 0,
    UPuType_ = 1,
    UType_ = 2
  } UType_t;

  /**
   * @brief add a bus to the neighbors
   * @param bus bus to add
   */
  void addNeighbor(const std::shared_ptr<ModelBus>& bus);  // add a bus to the neighbors (i.e. AC-connected) list

  /**
   * @brief clear neighbors
   * reset the list of neighbors
   */
  void clearNeighbors() {
    neighbors_.clear();
  }

  /**
   * @brief define variables
   * @param variables variables
   */
  static void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables);

  /**
   * @brief instantiate variables
   * @param variables variables
   */
  void instantiateVariables(std::vector<boost::shared_ptr<Variable> >& variables) override;

  /**
   * @brief define parameters
   * @param parameters vector to fill with the generic parameters
   */
  static void defineParameters(std::vector<ParameterModeler>& parameters);

  /**
   * @brief define non generic parameters
   * @param parameters vector to fill with the non generic parameters
   */
  void defineNonGenericParameters(std::vector<ParameterModeler>& parameters) override;

  /**
   * @brief define elements
   * @param elements vector of elements
   * @param mapElement map of elements
   */
  void defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) override;

  /**
   * @brief evaluate node injection
   *
   */
  void evalNodeInjection() override { /* not needed */ }

  /**
   * @brief reset node injection
   */
  void resetNodeInjection();

  /**
   * @brief evaluate derivatives for J
   * @param cj Jacobian prime coefficient
   */
  void evalDerivatives(double cj) override;

  /**
   * @brief evaluate derivatives for J'
   */
  void evalDerivativesPrim() override { /* not needed */ }

  /**
   * @brief evaluate F
   * @param[in] type type of the residues to compute (algebraic, differential or both)
   */
  void evalF(propertyF_t type) override;

  /**
   * @copydoc NetworkComponent::evalZ()
   */
  StateChange_t evalZ(double t, bool deactivateZeroCrossingFunctions) override;

  /**
   * @brief compute the local G function
   * @param t time
   */
  void evalG(double t) override;

  /**
   * @brief evaluate calculated variables (for outputs)
   */
  void evalCalculatedVars() override;

  /**
   * @brief get the index of variables used to define the Jacobian associated to a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   *
   * @param numVars index of variables used to define the Jacobian
   */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned numCalculatedVar, std::vector<int>& numVars) const override;

  /**
   * @brief evaluate the Jacobian associated to a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   * @param res values of the Jacobian
   */
  void evalJCalculatedVarI(unsigned numCalculatedVar, std::vector<double>& res) const override;

  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param numCalculatedVar index of the calculated variable
   *
   * @return value of the calculated variable
   */
  double evalCalculatedVarI(unsigned numCalculatedVar) const override;

  /**
   * @copydoc NetworkComponent::evalStaticYType()
   */
  void evalStaticYType() override;

  /**
   * @copydoc NetworkComponent::evalDynamicYType()
   */
  void evalDynamicYType() override;

  /**
   * @copydoc NetworkComponent::evalStaticFType()
   */
  void evalStaticFType() override;

  /**
   * @copydoc NetworkComponent::collectSilentZ()
   */
  void collectSilentZ(BitMask* silentZTable) override;

  /**
   * @copydoc NetworkComponent::evalDynamicFType()
   */
  void evalDynamicFType() override;

  /**
   * @copydoc NetworkComponent::evalYMat()
   */
  void evalYMat() override { /* not needed*/ }

  /**
   * @copydoc NetworkComponent::init(int& yNum)
   */
  void init(int& yNum) override;

  /**
   * @copydoc NetworkComponent::getY0()
   */
  void getY0() override;

  /**
   * @copydoc NetworkComponent::setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params)
   */
  void setSubModelParameters(const std::unordered_map<std::string, ParameterModeler>& params) override;

  /**
   * @copydoc NetworkComponent::setFequations( std::map<int, std::string> & fEquationIndex)
   */
  void setFequations(std::map<int, std::string>& fEquationIndex) override;

  /**
   * @copydoc NetworkComponent::setGequations( std::map<int,std::string>& gEquationIndex )
   */
  void setGequations(std::map<int, std::string>& gEquationIndex) override;

  /**
   * @brief evaluate state
   * @param time time
   * @return state change type
   */
  StateChange_t evalState(double time) override;

  /**
   * @brief addBusNeighbors
   */
  void addBusNeighbors() override { /* not needed*/ }

  /**
   * @brief init size
   */
  void initSize() override;

  /**
   * @brief add a new real current to the sum of real currents
   * @param ir new real current to add to the sum of real current
   */
  void irAdd(double ir);

  /**
   * @brief add a new imaginary current to the sum of imaginary currents
   * @param ii new imaginary current to add to the sum of imaginary currents
   */
  void iiAdd(double ii);

  /**
   * @brief get the current requested value of U
   * @param currentURequested type of U requested
   * @return the current requested value of U
   */
  double getCurrentU(UType_t currentURequested);

  /**
   * @brief get initial angle of the bus
   * @return initial angle of the bus
   */
  inline double getAngle0() const {
    return angle0_;
  }

  std::vector<std::weak_ptr<ModelBus> > neighbors_;  ///< list of buses within the same AC-connected component

  /**
   * @brief  scan a subnetwork in order to find all neighboring buses
   * @param subNetwork subnetwork to scan
   * @param numSubNetwork number of components
   */
  void exploreNeighbors(int numSubNetwork, const boost::shared_ptr<SubNetwork>& subNetwork);  // scan a subnetwork to find all neighbouring buses

  /**
   * @brief set refIslands
   * @param refIsland refIslands
   */
  inline void setRefIslands(int refIsland) {
    refIslands_ = refIsland;
  }

  /**
   * @brief get refIslands
   * @return refIslands
   */
  inline int getRefIslands() const {
    return refIslands_;
  }

  /**
   * @brief init derivatives
   */
  void initDerivatives();

  /**
   * @brief get derivatives for J
   * @return the derivatives associated to the bus model for J
   */
  inline boost::shared_ptr<BusDerivatives> derivatives() const {
    return derivatives_;
  }

  /**
   * @brief get derivatives for J'
   * @return the derivatives associated to the bus model for J'
   */
  inline boost::shared_ptr<BusDerivatives> derivativesPrim() const {
    return derivativesPrim_;
  }

  /**
   * @brief  switch off the bus (and force the voltage to be set to 0)
   */
  void switchOff();

  /**
   * @brief switch on the bus
   */
  inline void switchOn() {
    assert(z_!= NULL);
    z_[switchOffNum_] = fromNativeBool(false);
  }

  /**
   * @brief get information about whether the bus is switched off
   * @return @b true if the bus is switched off, @b false otherwise
   */
  inline bool getSwitchOff() const {
    if (z_ == NULL) return false;  // Might happen when we initialize connection to calculated variables (done before model init)
    return toNativeBool(z_[switchOffNum_]);
  }  // get information about whether the bus is switched off

  /**
   * @brief get information about whether the bus is opened or closed
   * @return current state of the bus
   */
  inline State getConnectionState() const {
    return connectionState_;
  }

  /**
   * @brief get information about the minimum voltage
   * @return current minimum voltage
   */
  inline double getUMin() const {
    return uMin_;
  }

  /**
   * @brief get information about the maximum voltage
   * @return current maximum voltage
   */
  inline double getUMax() const {
    return uMax_;
  }

  /**
   * @copydoc NetworkComponent::evalJt(double cj, int rowOffset, SparseMatrix& jt)
   */
  void evalJt(double cj, int rowOffset, SparseMatrix& jt) override;

  /**
   * @copydoc NetworkComponent::evalJtPrim(int rowOffset,SparseMatrix& jtPrim)
   */
  void evalJtPrim(int rowOffset, SparseMatrix& jtPrim) override;

  /**
   * @brief retrieve the real part of the voltage
   * @return the real part of the voltage
   */
  double ur() const;

  /**
   * @brief retrieve the imaginary part of the voltage
   * @return the imaginary part of the voltage
   */
  double ui() const;

  /**
   * @brief retrieve the real part of the voltage
   * @return the real part of the voltage
   */
  double urp() const;

  /**
   * @brief retrieve the imaginary part of the voltage
   * @return the imaginary part of the voltage
   */
  double uip() const;

  /**
   * @brief set if the bus voltage variables are differential
   * @param hasDifferentialVoltages @b true if the bus voltages are differential
  **/
  inline void setHasDifferentialVoltages(const bool hasDifferentialVoltages) {
    hasDifferentialVoltages_ = hasDifferentialVoltages;
  }

  /**
   * @brief get urYNum
   * @return urYNum
   */
  inline int urYNum() const {
    return urYNum_;
  }

  /**
   * @brief get uiYNum
   * @return uiYNum
   */
  inline int uiYNum() const {
    return uiYNum_;
  }

  /**
   * @brief set the number of independent sub networks
   * @param num number of the sub network
   */
  inline void numSubNetwork(const int num) const {
    z_[numSubNetworkNum_] = num;
  }

  /**
   * @brief check whether the sub-network index has already been set
   * @return @b whether the sub-network index has already been set
   */
  bool numSubNetworkSet() const;

  /**
   * @brief clear the sub-network index
   */
  inline void clearNumSubNetwork() const {
    assert(z_ != NULL);
    z_[numSubNetworkNum_] = -1.;
  }

  /**
   * @brief get the number of independent sub networks
   * @return numSubNetwork_
   */
  inline int numSubNetwork() const {
    assert(z_ != NULL);
    assert(doubleNotEquals(z_[numSubNetworkNum_], -1.));
    return static_cast<int>(z_[numSubNetworkNum_]);
  }

  /**
   * @brief get nominal voltage
   * @return norminal voltage
   */
  inline double getVNom() const {
    return unom_;
  }

  /**
   * @brief setter for the voltage level that contains the bus
   * @param voltageLevel VoltageLevel model that contains the bus
   */
  inline void setVoltageLevel(const std::weak_ptr<ModelVoltageLevel>& voltageLevel) {
    modelVoltageLevel_ = voltageLevel;
  }

  /**
   * @brief getter for the voltage level that contains the bus
   * @return the voltage level that contains the bus
   */
  inline std::shared_ptr<ModelVoltageLevel> getVoltageLevel() const {
    return modelVoltageLevel_.lock();
  }

  /**
   * @brief getter for the boolean indicating whether the bus has a bus bar section
   * @return whether the bus has a bus bar section
   */
  inline bool hasBBS() const {
    return !busBarSectionIdentifiers_.empty();
  }

  /**
   * @brief getter for the bus index
   * @return the bus index
   */
  inline int getBusIndex() const {
    return busIndex_;
  }

  /**
   * @brief add a model of switch to the list of connectable switches
   * @param sw model of switch to add
   */
  inline void addSwitch(const std::weak_ptr<ModelSwitch>& sw) {
    connectableSwitches_.push_back(sw);
  }

  /**
   * @brief reset the bit mask corresponding to the status of U calculation for the current time step
   */
  void resetCurrentUStatus();

  /**
   * @brief get the number of internal variable of the model
   *
   * @return the number of internal variable of the model
   */
  inline unsigned getNbInternalVariables() const override {
    return 5;
  }

  /**
   * @brief append the internal variables values to a stringstream
   *
   * @param streamVariables : stream with binary formated internalVariables
   */
  void dumpInternalVariables(boost::archive::binary_oarchive& streamVariables) const override;

  /**
   * @brief import the internal variables values of the component from stringstream
   *
   * @param streamVariables : stream with binary formated internalVariables
   */
  void loadInternalVariables(boost::archive::binary_iarchive& streamVariables) override;

 private:
  /**
   * @brief define elements of the bus model using id as prefix (to deal with alias)
   * @param id id to use as prefix
   * @param elements vector of elements to fill with new elements defined
   * @param mapElement map of elements to fill with new elements
   */
  void defineElementsById(const std::string& id, std::vector<Element> &elements, std::map<std::string, int>& mapElement);

  /**
   * @brief calculate the value of U² in pu
   * @return the value of U² in pu
   */
  double calculateU2Pu() const;

  /**
   * @brief calculate the value of U in S.I.
   * @return the value of U in S.I.
   */
  inline double calculateU() const {
    return UPu_ * unom_;
  }

 private:
  std::weak_ptr<ModelVoltageLevel> modelVoltageLevel_;  ///< voltage level that contains the bus
  std::weak_ptr<BusInterface> bus_;  ///< reference to the bus interface object

  double uMin_;  ///< minimum allowed voltage
  double uMax_;  ///< maximum allowed voltage
  bool stateUmax_;  ///< whether U > UMax
  bool stateUmin_;  ///< whether U < UMin

  double U2Pu_;  ///< current value of U² (= 0 if not yet calculated)
  double UPu_;  ///< current value of U (=0 if not yet calculated)
  double U_;  ///< current value of U in S.I. unit (=0 if not yet calculated)
  BitMask currentUStatus_;  ///< Bit mask value indicating which value of U have already been calculated for the current time step

  // equivalent to z_[switchOffNum_] but with discrete variable, to be able to switch off a node thanks to an outside event
  State connectionState_;  ///< "internal" bus connection status, evaluated at the end of evalZ to detect if the state was modified by another component
  bool topologyModified_;  ///< true if the bus connection state was modified
  double irConnection_;  ///< real current injected
  double iiConnection_;  ///< imaginary current injected
  int refIslands_;  ///< island reference (used to compute switch loops)
  boost::shared_ptr<BusDerivatives> derivatives_;  ///< derivatives
  boost::shared_ptr<BusDerivatives> derivativesPrim_;  ///< derivatives for JPrim
  double ur0_{};  ///< initial real voltage
  double ui0_{};  ///< initial imaginary voltage
  double ir0_;  ///< initial real current
  double ii0_;  ///< initial imaginary current

  // index inside the whole Jacobian
  int urYNum_;  ///< index ur
  int uiYNum_;  ///< ui
  int iiYNum_;  ///< ii
  int irYNum_;  ///< ir

  int busIndex_;  ///< index of bus in its voltage level
  bool hasConnection_;  ///< whether the bus has connection
  bool hasShortCircuitCapabilities_;  ///< whether a short circuit could be applied to the bus
  bool hasDifferentialVoltages_;  ///< whether the bus model has differential voltages

  double unom_;  ///< nominal voltage
  double u0_{};  ///< initial voltage
  double angle0_;  ///< initial angle
  std::vector<std::string> busBarSectionIdentifiers_;  ///< identifiers of bus bar sections on the same electrical node
  std::vector<std::weak_ptr<ModelSwitch> > connectableSwitches_;  ///< switch connected or connectable on the node

  const std::string modelType_;  ///< model Type
  const bool isNodeBreaker_;  ///< true if the bus is modeled as node-breaker (called also calculated bus)
  std::string constraintId_;  ///< id to use in constraints
  startingPointMode_t startingPointMode_;  ///< type of starting point for the model (FLAT,WARM)
};

/**
 * class SubNetwork
 */
class SubNetwork {  ///< sub-network gathering buses connected by AC components
 public:
  /**
   * @brief default constructor
   */
  SubNetwork()
  :num_(0) { }

  /**
   * @brief constructor
   * @param num num
   */
  explicit SubNetwork(const int num)
  :num_(num) { }

  /**
   * @brief set num
   * @param num num
   */
  inline void setNum(const int num) {
    num_ = num;
  }

  /**
   * @brief get num
   * @return num
   */
  inline int getNum() const {
    return num_;
  }

  /**
   * @brief  add a bus to the sub-network
   * @param bus bus
   */
  inline void addBus(const std::shared_ptr<ModelBus>& bus) {
    assert(bus && "Undefined bus");
    bus_.push_back(bus);
  }   // add a bus to the sub-network

  /**
   * @brief  get the number of buses within the sub-network
   * @return number of buses
   */
  inline unsigned int nbBus() const {
    return static_cast<unsigned int>(bus_.size());
  }   // get the number of buses within the sub-network

  /**
   * @brief get bus
   * @param num num
   * @return bus
   */
  inline std::shared_ptr<ModelBus> bus(const int num) const {
    assert(num >= 0 && static_cast<size_t>(num) < bus_.size() && "Bus index unknown");
    return bus_[num];
  }
  /**
   * @brief  switch off all buses within the sub-network
   *
   */
  void shutDownNodes();   // switch off all buses within the sub-network
  /**
   * @brief turn on all buses within the sub-network
   *
   */
  void turnOnNodes();  // turn on all buses within the sub-network

 private:
  int num_;  ///< number of bus
  std::vector<std::shared_ptr<ModelBus> > bus_;  ///< vector of ModelBus located within the sub-network
};

/**
 * class ModelBusContainer
 */
class ModelBusContainer {
 public:
  /**
   * @brief default constructor
   */
  ModelBusContainer();

  /**
   * @brief add bus
   * @param model model
   */
  void add(const std::shared_ptr<ModelBus>& model);

  /**
   * @brief remove all buses from the sub-network
   *
   */
  void resetSubNetwork();   // remove all buses from the sub-network

  /**
   * @brief  reset node injection
   *
   */
  void resetNodeInjections();

  /**
   * @brief create a new-subnetwork, and scan the network to find all buses located within
   * @param t : time to use  (only used for log purpose)
   */
  void exploreNeighbors(double t);  // create a new-subnetwork, and scan the network to find all buses located within

  /**
   * @brief init reference islands
   *
   */
  void initRefIslands();

  /**
   * @brief init derivatives
   *
   */
  void initDerivatives();

  /**
   * @brief evaluate the residual functions for each bus
   * @param[in] type type of the residues to compute (algebraic, differential or both)
   */
  void evalF(propertyF_t type);

  /**
   * @brief get sub networks
   * @return sub networks
   */
  std::vector<boost::shared_ptr<SubNetwork> > getSubNetworks() const {
    return subNetworks_;
  }   // get the list of sub-networks

  /**
   * @brief evaluate Jacobian \f$( J = @F/@x + cj * @F/@x')\f$
   * @param cj Jacobian prime coefficient
   * @param rowOffset row offset to use to find the first row to fill
   * @param jt sparse matrix to fill
   */
  void evalJt(double cj, int rowOffset, SparseMatrix& jt);

  /**
   * @brief  evaluate Jacobian \f$( J =  @F/@x')\f$
   * @param rowOffset row offset to use to find the first row to fill
   * @param jtPrim sparse matrix to fill
   */
  void evalJtPrim(int rowOffset, SparseMatrix& jtPrim);

  /**
   * @brief reset the bit mask of every bus corresponding to the status of U calculation for the current time step
   */
  void resetCurrentUStatus();

 private:
  std::vector<std::shared_ptr<ModelBus> > models_;  ///< model bus
  std::vector<boost::shared_ptr<SubNetwork> > subNetworks_;  ///< sub network
};
}  // namespace DYN
#endif  // MODELS_CPP_MODELNETWORK_DYNMODELBUS_H_
