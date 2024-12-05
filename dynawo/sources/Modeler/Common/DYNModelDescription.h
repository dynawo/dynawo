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
 * @file DYNModelDescription.h
 * @brief model desription structure header file
 */
#ifndef MODELER_COMMON_DYNMODELDESCRIPTION_H_
#define MODELER_COMMON_DYNMODELDESCRIPTION_H_

#include <string>
#include <vector>

#include <boost/shared_ptr.hpp>
#include <boost/weak_ptr.hpp>

#include "DYDModel.h"
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"


namespace DYN {
class SubModel;
class StaticRefInterface;

/**
 * @class ModelDescription
 * @brief ModelDescription
 */
class ModelDescription {
 public:
  /**
   * @brief default constructor.
   */
  ModelDescription() :
  hasCompiledModel_(false) { }

  /**
   * @brief default constructor.
   * @param model another model
   */
  explicit ModelDescription(const boost::shared_ptr<dynamicdata::Model>& model) :
  model_(model),
  hasCompiledModel_(false) { }

  /**
   * @brief add static reference interface
   * @param staticRefInterface static reference interface
   */
  inline void addStaticRefInterface(const boost::shared_ptr<StaticRefInterface>& staticRefInterface) {
    staticRefInterfaces_.push_back(staticRefInterface);
  }

  /**
   * @brief get the type of the model
   * @returns type of the model
   */
  inline dynamicdata::Model::ModelType getType() const {
    return model_->getType();
  }

  /**
   * @brief get model id
   * @returns id
   */
  inline std::string getID() const {
    return model_->getId();
  }

  /**
   * @brief get static model id
   * @returns id
   */
  inline std::string getStaticId() const {
    return staticId_;
  }

  /**
   * @brief set static id of the model description
   * @param id : static id of the model
   */
  inline void setStaticId(const std::string& id) {
    staticId_ = id;
  }

  /**
   * @brief set compiled model ID
   * @param compiledModelId compiled model ID
   */
  inline void setCompiledModelId(const std::string& compiledModelId) {
    compiledModelId_ = compiledModelId;
  }

  /**
   * @brief get compiled model ID
   * @returns compiled model ID
   */
  inline std::string getCompiledModelId() const {
    return compiledModelId_;
  }

  /**
   * @brief get all static references
   * @returns list of static references
   */
  inline const std::vector<boost::shared_ptr<StaticRefInterface> > getStaticRefInterfaces() const {
    return staticRefInterfaces_;
  }

  /**
   * @brief reset static references list
   *
   */
  inline void resetStaticRefInterfaces() {
    staticRefInterfaces_.clear();
  }

  /**
   * @brief get dynamic model
   * @returns dynamic model
   */
  inline boost::shared_ptr<dynamicdata::Model> getModel() const {
    return model_;
  }

  /**
   * @brief Associate a set of parameters to the model
   * @param params : set of parameters associated to the model
   */
  inline void setParametersSet(const std::shared_ptr<parameters::ParametersSet>& params) {
    if (params)
      parameters_ = parameters::ParametersSetFactory::copySet(params);
  }

  /**
   * @brief Get the set of parameters associated to the model
   * @return the set of parameters associated to the model
   */
  inline std::shared_ptr<parameters::ParametersSet> getParametersSet() const {
    return parameters_;
  }

  /**
   * @brief set the library to use to instantiate the model
   * @param lib : path of the library to use for this model
   */
  inline void setLib(const std::string& lib) {
    lib_ = lib;
  }

  /**
   * @brief get the path of the library to use to instantiate this model
   * @returns path of the library to use for this model
   */
  inline std::string getLib() const {
    return lib_;
  }

  /**
   * @brief set if the model description has a compiled model
   * @param hasCompiledModel :  @b true if the model has a compiled model, @b false else
   */
  inline void hasCompiledModel(bool hasCompiledModel) {
    hasCompiledModel_ = hasCompiledModel;
  }

  /**
   * @brief check if the model description has a compiled model
   * @return @b true if the model has a compiled model, @b false else
   */
  inline bool hasCompiledModel() const {
    return hasCompiledModel_;
  }

  /**
   * @brief get the sub model associated to the model description
   * @returns sub model associated to the model description
   */
  inline boost::shared_ptr<SubModel> getSubModel() const {
    return subModel_.lock();
  }

  /**
   * @brief set the SubModel associated to the model description
   * @param subModel : sub model associated to the model description
   */
  inline void setSubModel(const boost::shared_ptr<SubModel>& subModel) {
    subModel_ = subModel;
  }


 protected:
  boost::shared_ptr<dynamicdata::Model> model_;  ///< dynamic model
  boost::weak_ptr<SubModel> subModel_;  ///< submodel associated to the model description
  std::shared_ptr<parameters::ParametersSet> parameters_;  ///< set of parameters associated to the model
  std::vector<boost::shared_ptr<StaticRefInterface> > staticRefInterfaces_;  ///< Static reference
  std::string compiledModelId_;  ///< Compiled Model ID
  std::string lib_;  ///< compiled lib .so
  bool hasCompiledModel_;  ///< @b true if the model has a compiled model, @b false else
  std::string staticId_;  ///< static id of the model description
};  ///< class of model description



}  // namespace DYN

#endif  // MODELER_COMMON_DYNMODELDESCRIPTION_H_
