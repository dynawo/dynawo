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
#include "DYNCriteria.h"
#include "DYNServiceManagerInterface.h"

namespace DYN {
class NetworkInterface;
class SubModel;

class DataInterface {
 public:
  /**
   * @brief Destructor
   */
  virtual ~DataInterface() { }

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
   * @param componentVar: component's var
   * @param staticId: static id of the model
   * @param modelId : model's id
   * @param modelVar: model's var associated to the component's var
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
   * @brief import static parameters
   */
  virtual void importStaticParameters() = 0;

  /**
   * @brief set the criteria for this model
   * @param criteria criteria to be used
   * @param criterias the criteria array to update
   */
  virtual void configureCriteria(const boost::shared_ptr<criteria::CriteriaCollection>& criteria, std::vector<boost::shared_ptr<Criteria> >& criterias) = 0;

  /**
   * @brief check if criteria for static model is respected
   * @param t current time of the simulation
   * @param finalStep @b true check criteria at each iteration, @b false check only at the end of simulation
   * @param criterias criterias array to update
   * @return false if criteria is not respected
   */
  virtual bool checkCriteria(double t, bool finalStep, const std::vector<boost::shared_ptr<Criteria> >& criterias) = 0;

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
};  ///< Class for data interface
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNDATAINTERFACE_H_
