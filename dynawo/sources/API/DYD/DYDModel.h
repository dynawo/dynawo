//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file DYDModel.h
 * @brief Model description : interface file
 *
 */

#ifndef API_DYD_DYDMODEL_H_
#define API_DYD_DYDMODEL_H_

#include "DYDConnector.h"
#include "DYDIdentifiable.h"
#include "DYDMacroStaticRef.h"
#include "DYDStaticRef.h"

#include <map>
#include <memory>
#include <string>

namespace dynamicdata {

/**
 * @class Model
 * @brief Model interface class
 *
 * Model is a base class for all model types
 */
class Model {
 public:
  /**
   * @brief Available model types enum
   */
  enum ModelType {
    BLACK_BOX_MODEL,           ///< For BlackBoxModel typed model
    MODELICA_MODEL,            ///< For CompositeModel typed model
    MODEL_TEMPLATE_EXPANSION,  ///< For modelTemplateExpansion typed model
    MODEL_TEMPLATE             ///< For Model Template typed model
  };

  /**
   * @brief Destructor
   */
  virtual ~Model();

  /**
   * @brief Model id getter
   *
   * @returns Model id
   */
  const std::string& getId() const;

  /**
   * @brief Model type getter
   *
   * @returns Model type
   */
  ModelType getType() const;

  /**
   * @brief Static Ref adder
   * no id is set (the id is assumed to be the parent model dynamic id in this case)
   * @param var variable
   * @param staticVar static variable
   * @throws Error::API exception if staticRef already exists
   * @return Reference to the current Model instance
   */
  Model& addStaticRef(const std::string& var, const std::string& staticVar);

  /**
   * @brief macroStaticRef adder
   * @param macroStaticRef macroStaticRef to add to the model
   * @throws Error::API exception if macroStaticRef already exists
   */
  void addMacroStaticRef(const std::shared_ptr<MacroStaticRef>& macroStaticRef);

  /**
   * @brief find a staticRef thanks to its key (var_staticVar)
   * @param key key of the staticRef to be found
   * @throws Error::API exception if staticRef doesn't exist
   * @return the staticRef associated to the key
   */
  const std::unique_ptr<StaticRef>& findStaticRef(const std::string& key);

  /**
   * @brief find a macroStaticRef thanks to its id
   * @param id id of the macroStaticRef to be found
   * @throws Error::API exception if macroStaticRef doesn't exist
   * @return the macroStaticRef associated to the id
   */
  const std::shared_ptr<MacroStaticRef>& findMacroStaticRef(const std::string& id);

  /**
  * @brief get the static refs
  *
  * @return static refs
  */
  const std::map<std::string, std::unique_ptr<StaticRef>>& getStaticRefs() const {
    return staticRefs_;
  }

  /**
  * @brief get the macro static refs
  *
  * @return macro static refs
  */
  const std::map<std::string, std::shared_ptr<MacroStaticRef>>& getMacroStaticRefs() const {
    return macroStaticRefs_;
  }

 protected:
  /**
   * @brief Constructor
   *
   * @param[in] id Model's ID
   * @param[in] type Model's type
   */
  Model(const std::string& id, ModelType type);

 protected:
  std::unique_ptr<Identifiable> id_;                                           ///< Model's ID
  ModelType type_;                                                             ///< Model's type
  std::map<std::string, std::unique_ptr<StaticRef> > staticRefs_;              ///< map of static ref
  std::map<std::string, std::shared_ptr<MacroStaticRef> > macroStaticRefs_;    ///< map of the macroStaticRef
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMODEL_H_
