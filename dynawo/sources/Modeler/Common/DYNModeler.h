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
 * @file  DYNModeler.h
 *
 * @brief Modeler header : creates all submodels and connectors between them
 *
 */

#ifndef MODELER_COMMON_DYNMODELER_H_
#define MODELER_COMMON_DYNMODELER_H_

#include <map>

#include <boost/shared_ptr.hpp>

namespace DYN {

class ModelMulti;
class DynamicData;
class DataInterface;
class SubModel;
class ModelDescription;

/**
 * @class Modeler
 * @brief class Modeler
 *
 * A modeler instantiate and connect all submodels thanks to data contained
 * in data interface (static data) and dynamic data
 */
class Modeler {
 public:
  /**
   * @brief default constructor
   */
  Modeler() { }

  /**
   * @brief destructor
   */
  ~Modeler() { }

  /**
   * @brief set the data interface to use do define the model multi
   * @param data : data interface to use
   */
  void setDataInterface(const boost::shared_ptr<DataInterface>& data) {
    data_ = data;
  }

  /**
   * @brief set the dynamic data to use do define the model multi
   * @param dyd : dynamic data to use
   */
  void setDynamicData(const boost::shared_ptr<DynamicData>& dyd) {
    dyd_ = dyd;
  }

  /**
   * @brief build the model thanks to the data interface and the dynamic data
   */
  void initSystem();

  /**
   * @brief get the model created thanks to data
   * @return model created thanks to data
   */
  boost::shared_ptr<ModelMulti> getModel() const {
    return model_;
  }

 private:
  /**
   * @brief network initialization
   */
  void initNetwork();

  /**
   * @brief Initialization of all dynamic models
   */
  void initModelDescription();

  /**
   * @brief creates all connects between models
   */
  void initConnects();

  /**
   * @brief Add reference between static model and subModel
   *
   * @param model submodel
   * @param modelDescription dynamic model
   */
  void initStaticRefs(const boost::shared_ptr<SubModel>& model, const boost::shared_ptr<ModelDescription>& modelDescription);

  /**
   * @brief find a node connector name
   *
   * @param id : id of the node connector
   * if the id contains \@static_id\@\@NODE\@, find the connection point of static id,
   * and replace \@NODE\@ by the name of the connection point
   * @return the id of the connector where \@static_id\@\@NODE\@ is replaced by the name of the connection point
   */
  std::string findNodeConnectorName(const std::string& id);

 private:
  boost::shared_ptr<DataInterface> data_;  ///< data used to build the model multi
  boost::shared_ptr<DynamicData> dyd_;  ///< dynamic data used to build the model multi
  boost::shared_ptr<ModelMulti> model_;  ///< model created thanks to previous data

  std::map<std::string, boost::shared_ptr<SubModel> > subModels_;  ///< association between name and subModel : usefull when the connectors should be created
};

}  // namespace DYN


#endif  // MODELER_COMMON_DYNMODELER_H_
