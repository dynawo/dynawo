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

#include <string>
#include <vector>
#include <map>

#include <boost/shared_ptr.hpp>

namespace dynamicdata {
class staticRef_const_iterator;
class staticRef_iterator;
class macroStaticRef_const_iterator;
class macroStaticRef_iterator;
class Connector;
class StaticRef;
class MacroStaticRef;

/**
 * @class Model
 * @brief Model interface class
 *
 * Model is a virtual base class for all model types
 */
class Model {
 public:
  /**
   * @brief Available model types enum
   */
  enum ModelType {
    BLACK_BOX_MODEL,  ///< For BlackBoxModel typed model
    MODELICA_MODEL,  ///< For CompositeModel typed model
    MODEL_TEMPLATE_EXPANSION,  ///< For modelTemplateExpansion typed model
    MODEL_TEMPLATE  ///< For Model Template typed model
  };

  /**
   * @brief Destructor
   */
  virtual ~Model() {}

  /**
   * @brief Model id getter
   *
   * @returns Model id
   */
  virtual std::string getId() const = 0;


  /**
   * @brief Model type getter
   *
   * @returns Model type
   */
  virtual ModelType getType() const = 0;

  /**
   * @brief Static Ref adder
   * no id is set (the id is assumed to be the parent model dynamic id in this case)
   * @param var variable
   * @param staticVar static variable
   * @throws Error::API exception if staticRef already exists
   * @return Reference to the current Model instance
   */
  virtual Model& addStaticRef(const std::string& var, const std::string& staticVar) = 0;

  /**
   * @brief macroStaticRef adder
   * @param macroStaticRef: macroStaticRef to add to the model
   * @throws Error::API exception if macroStaticRef already exists
   */
  virtual void addMacroStaticRef(const boost::shared_ptr<MacroStaticRef>& macroStaticRef) = 0;

  /**
   * @brief staticRef iterator : beginning of staticRefs
   * @return beginning of staticRefs
   */
  virtual staticRef_const_iterator cbeginStaticRef() const = 0;

  /**
   * @brief staticRef iterator : end of staticRefs
   * @return end of staticRefs
   */
  virtual staticRef_const_iterator cendStaticRef() const = 0;

  /**
   * @brief macroStaticRef iterator : beginning of macroStaticRefs
   * @return beginning of macroStaticRefs
   */
  virtual macroStaticRef_const_iterator cbeginMacroStaticRef() const = 0;

  /**
   * @brief macroStaticRef iterator : end of macroStaticRefs
   * @return end of macroStaticRefs
   */
  virtual macroStaticRef_const_iterator cendMacroStaticRef() const = 0;

  /**
   * @brief staticRef iterator : beginning of staticRefs
   * @return beginning of staticRefs
   */
  virtual staticRef_iterator beginStaticRef() = 0;

  /**
   * @brief staticRef iterator : end of staticRefs
   * @return end of staticRefs
   */
  virtual staticRef_iterator endStaticRef() = 0;

  /**
   * @brief macroStaticRef iterator : beginning of macroStaticRefs
   * @return beginning of macroStaticRefs
   */
  virtual macroStaticRef_iterator beginMacroStaticRef() = 0;

  /**
   * @brief macroStaticRef iterator : end of macroStaticRefs
   * @return end of macroStaticRefs
   */
  virtual macroStaticRef_iterator endMacroStaticRef() = 0;

  /**
   * @brief find a staticRef thanks to its key (var_staticVar)
   * @param key: key of the staticRef to be found
   * @throws Error::API exception if staticRef doesn't exist
   * @return the staticRef associated to the key
   */
  virtual const boost::shared_ptr<StaticRef>& findStaticRef(const std::string& key) = 0;

  /**
   * @brief find a macroStaticRef thanks to its id
   * @param id: id of the macroStaticRef to be found
   * @throws Error::API exception if macroStaticRef doesn't exist
   * @return the macroStaticRef associated to the id
   */
  virtual const boost::shared_ptr<MacroStaticRef>& findMacroStaticRef(const std::string& id) = 0;

  class Impl;  ///< Implemented class
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMODEL_H_
