// Copyright (c) 2026, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.

/** @file  DYNModelBus.h */

#ifndef MODELS_CPP_MODELNETWORK_DYNMODELBUS_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELBUS_H_

#include "DYNNetworkComponent.h"

namespace DYN {
class SubNetwork;
class BusInterface;
class BusDerivatives;
class ModelVoltageLevel;
class ModelSwitch;

/** interface abstracting all buses, whether they support node injection or are bridged to a dynamic bus model */
class ModelBus : public NetworkComponent {
 public :
  /** @brief type of interdependent voltage value requested */
  typedef enum {
    U2PuType_ = 0,
    UPuType_ = 1,
    UType_ = 2
  } UType_t;

  /** @brief fixed local indexes in Z vector */
  typedef enum {
    numSubNetworkNum_ = 0,
    switchOffNum_ = 1,
    connectionStateNum_ = 2
  } IndexDiscreteVariable_t;

 public :
  void initSize() override;
  void getY0() override;
  void collectSilentZ(BitMask* silentZTable) override;
  void instantiateVariables(std::vector<boost::shared_ptr<Variable> >& variables) override;
  void defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) override;

  /**
   * @brief add a bus to the list of this bus' neighbors (i.e. AC-connected)
   * @param bus the bus to add to this bus' list of neighbors
   */
  void addNeighbor(const std::shared_ptr<ModelBus>& bus);

  /** @brief reset the list of this bus' neighbors */
  void clearNeighbors();

  /**
   * @brief recursevely add all connex buses to a single subnetwork
   * @param numSubNetwork the ID of the subnetwork being built
   * @param subNetwork the subnetwork being built
   */
  void exploreNeighbors(int numSubNetwork, const boost::shared_ptr<SubNetwork>& subNetwork);

  /** @brief activates the bus */
  void switchOn();

  /** @brief deactivates the bus (and force the voltage to be set to 0) */
  virtual void switchOff();

  /**
   * @brief checks whether the bus is active or not
   * @returns @b true if the bus is active, @b false if inactive
   */
  bool getSwitchOff() const;

  /**
   * @brief trivial setter for the ID of the subnetwork the bus is in
   * @param num the new value to set
   */
  inline void setNumSubNetwork(int num)   {z_[numSubNetworkNum_] = num;}

  /** @brief resets the ID of the subnetwork the bus is in */
  inline void clearNumSubNetwork()        {setNumSubNetwork(-1.);}

  /**
   * @brief trivial getter for the ID of the subnetwork the bus is in
   * @returns the current value of the ID
   */
  inline int  getNumSubNetwork() const    {return z_[numSubNetworkNum_];}

  /**
   * @brief checks whether a valid ID for a subnetwork is currently set
   * @returns true if a subnetwork ID has actually been set, false if the bus is currently attached to no subnetwork
   */
  inline bool isNumSubNetworkSet() const  {return doubleNotEquals(getNumSubNetwork(), -1.);}

  /**
   * @brief trivial setter for the voltage level that contains the bus
   * @param voltageLevel the new value to set
   */
  inline void setVoltageLevel(const std::weak_ptr<ModelVoltageLevel>& voltageLevel) {modelVoltageLevel_ = voltageLevel;}

  /**
   * @brief trivial getter for the voltage level that contains the bus
   * @returns pointer to the voltage level object currently set
   */
  inline std::shared_ptr<ModelVoltageLevel> getVoltageLevel() const {return modelVoltageLevel_.lock();}

  /**
   * @brief trivial getter for the current connection state (ie. open, closed or partially closed) of the bus
   * @returns the current connection state
   */
  inline State getConnectionState() const {return connectionState_;}

  /**
   * @brief trivial getter for the index of the bus in its voltage level
   * @returns the index
   */
  inline int getBusIndex() const {return busIndex_;}

  /**
   * @brief checks whether the bus has at least one valid bus bar section identifier
   * @returns @b true if it does, @b false otherwise
   */
  inline bool hasBBS() const {return !busBarSectionIdentifiers_.empty();}

  /**
   * @brief add a model of switch to the list of connectable switches
   * @param sw model of switch to add
   */
  inline void addSwitch(const std::weak_ptr<ModelSwitch>& sw) {connectableSwitches_.push_back(sw);}

  /**
   * @brief set if the bus voltage variables are differential
   * @param hasDifferentialVoltages @b true if the bus voltages are differential
  **/
  inline void setHasDifferentialVoltages(const bool hasDifferentialVoltages) {hasDifferentialVoltages_ = hasDifferentialVoltages;}

  /**
   * @brief get the current requested value of U
   * @param currentURequested type of U requested
   * @return the current requested value of U
   */
  virtual double getCurrentU(UType_t currentURequested) = 0;

  /** @brief reset the bit mask corresponding to the status of U calculation for the current time step */
  virtual void resetCurrentUStatus() = 0;

  /** @brief reset node injection */
  virtual void resetNodeInjection() = 0;

  /** @brief reset derivatives */
  virtual void resetDerivatives() = 0;

  /**
   * @brief get nominal voltage
   * @return norminal voltage
   */
  virtual double getVNom() const = 0;

  /**
   * @brief retrieve the real part of the voltage
   * @return the real part of the voltage
   */
  virtual double ur() const = 0;

  /**
   * @brief retrieve the imaginary part of the voltage
   * @return the imaginary part of the voltage
   */
  virtual double ui() const = 0;

  /**
   * @brief retrieve the derivative of the real part of the voltage
   * @return the derivative of the real part of the voltage
   */
  virtual double urp() const = 0;

    /**
   * @brief retrieve the imaginary part of the voltage
   * @return the imaginary part of the voltage
   */
  virtual double uip() const = 0;

  /**
   * @brief get index of ur in global Y vector
   * @return the index
   */
  virtual int urYNum() const = 0;

  /**
   * @brief get index of ui in global Y vector
   * @return the index
   */
  virtual int uiYNum() const = 0;

  /**
   * @brief add a new real current to the sum of real currents
   * @param ir the current to add
   */
  virtual void irAdd(double ir) = 0;

  /**
   * @brief add a new imaginary current to the sum of imaginary currents
   * @param ii the current to add
   */
  virtual void iiAdd(double ii) = 0;

  /**
   * @brief get the bus derivatives (resulting of node injections)
   * @return the derivatives sparse matrix
   */
  virtual boost::shared_ptr<BusDerivatives>& derivatives() = 0;

  /**
   * @brief get the differiential bus derivatives (resulting of node injections)
   * @return the differential derivatives sparse matrix
   */
  virtual boost::shared_ptr<BusDerivatives>& derivativesPrim() = 0;

  /**
   * @brief define variables
   * @param variables variables
   */
  static void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables);

 public :
  int refIslands = 0;  ///< island reference (used to compute switch loops)

 protected :
  /**
   * @brief constructor from static data, for inheriting classes
   * @param bus the bus description from static data
   * @param isNodeBreaker whether the bus description uses node/breaker topology or not
   */
  explicit ModelBus(const std::shared_ptr<BusInterface> & bus, bool isNodeBreaker);

  /**
   * @brief define elements of the bus model using id as prefix (to deal with alias)
   * @param id id to use as prefix
   * @param elements vector of elements to fill with new elements defined
   * @param mapElement map of elements to fill with new elements
   */
  virtual void defineElementsById(const std::string& id, std::vector<Element> &elements, std::map<std::string, int>& mapElement);

  static const bool DO_LOG_TIMELINE = true;       ///< require change event to be logged inside refreshConnectionStateFromZ()
  static const bool DO_NOT_LOG_TIMELINE = false;  ///< require change event not to be logged inside refreshConnectionStateFromZ()

  /**
   * @brief read connection state flag inside z vector and update connectionState member if necessary
   * @param logTimeline @b true if logging change event in the timeline is requested
   */
  void refreshConnectionStateFromZ(bool logTimeline);

 protected :
  int busIndex_;  ///< index of bus in its voltage level
  bool topologyModified_ = false;  ///< true if the bus connection state was modified
  State connectionState_ = CLOSED;  ///< "internal" bus connection status
  bool hasDifferentialVoltages_ = false;  ///< whether the bus model has differential voltages
  std::weak_ptr<ModelVoltageLevel> modelVoltageLevel_;  ///< voltage level that contains the bus
  std::vector<std::weak_ptr<ModelBus> > neighbors_;  ///< list of buses within the same AC-connected component
  std::vector<std::string> busBarSectionIdentifiers_;  ///< identifiers of bus bar sections on the same electrical node
  std::vector<std::weak_ptr<ModelSwitch> > connectableSwitches_;  ///< switch connected or connectable on the node
  const std::string modelType_;  ///< model Type
  const bool isNodeBreaker_;  ///< true if the bus is modeled as node-breaker (called also calculated bus)

  double angle0_;  ///< initial angle
  double ur0_;  ///< initial real voltage
  double ui0_;  ///< initial imaginary voltage

// unused virtual methods from NetworkComponent
 public :
  void evalYMat() override {}
  void evalDerivativesPrim() override {}
  void evalNodeInjection() override {}
  void evalStaticFType() override {}
  void addBusNeighbors() override {};
};

}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNMODELBUS_H_
