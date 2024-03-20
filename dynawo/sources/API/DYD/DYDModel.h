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
 * @file DYDModel.h
 * @brief Model description : interface file
 *
 */

#ifndef API_DYD_DYDMODEL_H_
#define API_DYD_DYDMODEL_H_

#include "DYDConnector.h"
#include "DYDIdentifiable.h"
#include "DYDIterators.h"
#include "DYDMacroStaticRef.h"
#include "DYDStaticRef.h"

#include <boost/shared_ptr.hpp>
#include <map>
#include <string>
#include <vector>

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
  virtual ~Model() = default;

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
  void addMacroStaticRef(const boost::shared_ptr<MacroStaticRef>& macroStaticRef);

  /**
   * @brief staticRef iterator : beginning of staticRefs
   * @return beginning of staticRefs
   */
  staticRef_const_iterator cbeginStaticRef() const;

  /**
   * @brief staticRef iterator : end of staticRefs
   * @return end of staticRefs
   */
  staticRef_const_iterator cendStaticRef() const;

  /**
   * @brief macroStaticRef iterator : beginning of macroStaticRefs
   * @return beginning of macroStaticRefs
   */
  macroStaticRef_const_iterator cbeginMacroStaticRef() const;

  /**
   * @brief macroStaticRef iterator : end of macroStaticRefs
   * @return end of macroStaticRefs
   */
  macroStaticRef_const_iterator cendMacroStaticRef() const;

  /**
   * @brief staticRef iterator : beginning of staticRefs
   * @return beginning of staticRefs
   */
  staticRef_iterator beginStaticRef();

  /**
   * @brief staticRef iterator : end of staticRefs
   * @return end of staticRefs
   */
  staticRef_iterator endStaticRef();

  /**
   * @brief macroStaticRef iterator : beginning of macroStaticRefs
   * @return beginning of macroStaticRefs
   */
  macroStaticRef_iterator beginMacroStaticRef();

  /**
   * @brief macroStaticRef iterator : end of macroStaticRefs
   * @return end of macroStaticRefs
   */
  macroStaticRef_iterator endMacroStaticRef();

  /**
   * @brief find a staticRef thanks to its key (var_staticVar)
   * @param key key of the staticRef to be found
   * @throws Error::API exception if staticRef doesn't exist
   * @return the staticRef associated to the key
   */
  const boost::shared_ptr<StaticRef>& findStaticRef(const std::string& key);

  /**
   * @brief find a macroStaticRef thanks to its id
   * @param id id of the macroStaticRef to be found
   * @throws Error::API exception if macroStaticRef doesn't exist
   * @return the macroStaticRef associated to the id
   */
  const boost::shared_ptr<MacroStaticRef>& findMacroStaticRef(const std::string& id);

  friend class staticRef_iterator;
  friend class staticRef_const_iterator;
  friend class macroStaticRef_iterator;
  friend class macroStaticRef_const_iterator;

 protected:
  /**
   * @brief Constructor
   *
   * @param[in] id Model's ID
   * @param[in] type Model's type
   */
  Model(const std::string& id, ModelType type);

 protected:
  boost::shared_ptr<Identifiable> id_;                                         ///< Model's ID
  ModelType type_;                                                             ///< Model's type
  std::map<std::string, boost::shared_ptr<StaticRef> > staticRefs_;            ///< map of static ref
  std::map<std::string, boost::shared_ptr<MacroStaticRef> > macroStaticRefs_;  ///< map of the macroStaticRef
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMODEL_H_
