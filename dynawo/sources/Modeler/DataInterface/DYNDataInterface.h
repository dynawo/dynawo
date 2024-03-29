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
 * @file  DYNDataInterface.h
 *
 * @brief Data interface : interface file
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNDATAINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNDATAINTERFACE_H_

#include <string>
#include <vector>
#include <boost/shared_ptr.hpp>

#include "CRTCriteriaCollection.h"
#include "LEQLostEquipmentsCollection.h"
#include "DYNServiceManagerInterface.h"
#include "TLTimeline.h"

namespace DYN {
class NetworkInterface;
class SubModel;

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @brief Data interface
 */
class DataInterface {
 public:
  /**
   * @brief Destructor
   */
  virtual ~DataInterface() = default;

  /**
   * @brief Determines if variant management is supported
   * @returns @b true if network variant is supported, @b false if not
   */
  virtual bool canUseVariant() const = 0;

  /**
   * @brief Choose which network variant to use
   * @param variantName the name of the variant to use
   */
  virtual void selectVariant(const std::string& variantName) = 0;

  /**
   * @brief Getter for the network interface instance
   * @return the network interface instance
   */
  virtual boost::shared_ptr<NetworkInterface> getNetwork() const = 0;

  /**
   * @brief Indicate that component has a dynamic model
   * @param id Component's id associated to the dynamic model
   */
  virtual void hasDynamicModel(const std::string& id) = 0;

  /**
   * @brief Associate a dynamic model to a component
   * @param componentId Component's id associated to the dynamic model
   * @param model Dynamic model associated to the component
   */
  virtual void setDynamicModel(const std::string& componentId, const boost::shared_ptr<SubModel>& model) = 0;

  /**
   * @brief Associate the model of network to data
   * @param model instance of network's model
   */
  virtual void setModelNetwork(const boost::shared_ptr<SubModel>& model) = 0;

  /**
   * @brief Associate a component variable to a model variable
   * @param componentVar component's var
   * @param staticId static id of the model
   * @param modelId model's id
   * @param modelVar model's var associated to the component's var
   */
  virtual void setReference(const std::string& componentVar, const std::string& staticId, const std::string& modelId, const std::string& modelVar) = 0;

  /**
   * @brief for each components, if there is a dynamic model, indicate for
   * nodes where component is connected that there is an outside connection
   */
  virtual void mapConnections() = 0;

  /**
   * @brief update from model state variables
   * @param filterForCriteriaCheck true if we only want to update the parameters used in criteria check
   */
  virtual void updateFromModel(bool filterForCriteriaCheck) = 0;

  /**
   * @brief get state variable reference in dynamic model
   */
  virtual void getStateVariableReference() = 0;

  /**
   * @brief export state variables
   */
  virtual void exportStateVariables() = 0;

  /**
   * @brief find connected components
   * @return vector of connected components found
   */
  virtual const boost::shared_ptr<std::vector<boost::shared_ptr<ComponentInterface> > > findConnectedComponents() = 0;

  /**
   * @brief find lost equipments (equipments which have lost connection)
   * @param connectedComponents vector of components previously connected
   * @return vector of lost equipments found
   */
  virtual const boost::shared_ptr<lostEquipments::LostEquipmentsCollection>
    findLostEquipments(const boost::shared_ptr<std::vector<boost::shared_ptr<ComponentInterface> > >& connectedComponents) = 0;

  /**
   * @brief import static parameters
   */
  virtual void importStaticParameters() = 0;

  /**
   * @brief set the criteria for this model
   * @param criteria criteria to be used
   */
  virtual void configureCriteria(const boost::shared_ptr<criteria::CriteriaCollection>& criteria) = 0;

  /**
   * @brief check if criteria for static model is respected
   * @param t current time of the simulation
   * @param finalStep @b true check criteria at each iteration, @b false check only at the end of simulation
   * @return false if criteria is not respected
   */
  virtual bool checkCriteria(double t, bool finalStep) = 0;

  /**
   * @brief fill a vector with the ids of the failing criteria
   * @param failingCriteria vector to fill
   */
  virtual void getFailingCriteria(std::vector<std::pair<double, std::string> >& failingCriteria) const = 0;

  /**
   * @brief get static parameter value
   * @param staticID id of static model
   * @param refOrigName parameter of static model
   * @return value
   */
  virtual double getStaticParameterDoubleValue(const std::string& staticID, const std::string& refOrigName) = 0;

  /**
   * @brief get static parameter value
   * @param staticID id of static model
   * @param refOrigName parameter of static model
   * @return value
   */
  virtual int getStaticParameterIntValue(const std::string& staticID, const std::string& refOrigName) = 0;

  /**
   * @brief get static parameter value
   * @param staticID id of static model
   * @param refOrigName parameter of static model
   * @return value
   */
  virtual bool getStaticParameterBoolValue(const std::string& staticID, const std::string& refOrigName) = 0;

  /**
   * @brief get the name of the bus where a component is connected
   * @param staticID id of the component
   * @param labelNode \@NODE\@ or \@NODE1\@ or \@NODE2\@ or \@NODE3\@
   * @return name of the bus where the component is connected
   */
  virtual std::string getBusName(const std::string& staticID, const std::string& labelNode) = 0;

  /**
   * @brief dump the network to a file with the proper format
   * @param filepath file to create
   */
  virtual void dumpToFile(const std::string& filepath) const = 0;

  /**
   * @brief Retrieve service manager associated with this data interface
   *
   * @returns the service manager
   */
  virtual boost::shared_ptr<ServiceManagerInterface> getServiceManager() const = 0;

  /**
   * @brief Clone the current data interface
   *
   * @returns cloned data interface
   */
  virtual boost::shared_ptr<DataInterface> clone() const = 0;

  /**
  * @brief test if some network components does not have a dynamic model
  *
  * A network model will be instantiated if at least one of the static components does not have a dynamic model
  *
  * @return do we need to instantiate the network
  */
  virtual bool instantiateNetwork() const = 0;

  /**
   * @brief Setter for timeline
   * @param timeline timeline output
   */
  virtual void setTimeline(const boost::shared_ptr<timeline::Timeline>& timeline) = 0;
};  ///< Class for data interface

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNDATAINTERFACE_H_
