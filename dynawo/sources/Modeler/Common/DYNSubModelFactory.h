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
 * @file  DYNSubModelFactory.h
 *
 * @brief SubModel factory header
 *
 */

#ifndef MODELER_COMMON_DYNSUBMODELFACTORY_H_
#define MODELER_COMMON_DYNSUBMODELFACTORY_H_
#include <map>
#include <string>
#include <boost/core/noncopyable.hpp>
namespace DYN {
class SubModel;
class SubModelFactories;

/**
 * @brief SubModelFactory class
 *
 * Utility interface used to define a building class for sub models.
 */
class SubModelFactory : private boost::noncopyable {
 public:
  /**
   * @brief Constructor
   */
  SubModelFactory() :
  handle_(NULL) { }

  /**
   * @brief Destructor
   */
  virtual ~SubModelFactory() { }

  /**
   * @brief create a new instance of a submodel
   *
   * @return the new instance of submodel
   */
  virtual SubModel* create() const = 0;

  /**
   * @brief Create a submodel loading given lib
   *
   * @param lib : Name of the submodel library to load
   * @return Pointer to the created submodel
   */
  static SubModel* createSubModelFromLib(const std::string & lib);

  /**
   * @brief reset all factories of submodel
   */
  static void resetFactories();


  void* handle_;  ///< handle return by dlopen when the library is loaded

 private:
  static SubModelFactories factories_;  ///< Factories already available
};

/**
 * @brief SubModelFactories class
 *
 * Manage submodel factories to avoid loading the same library multiple
 * time.
 */
class SubModelFactories {
 public:
  /**
   * @brief Constructor
   */
  SubModelFactories();

  /**
   * @brief destructor
   */
  ~SubModelFactories();

  /**
   * @brief Get available factory for a given library name
   *
   * @param lib : Name of the submodel library to load
   * @return A map iterator whose key is the library name and whose value
   * is a pointer to the SubModelFactory.
   */
  std::map<std::string, SubModelFactory*>::iterator find(const std::string & lib);

  /**
   * @brief Test if a map iterator is the end operator of factories map
   *
   * @param iter : Iterator to test, typically obtained via
   * @p SubModelFactories::find() function
   * @return @b true if the iterator is the end operator of the factories,
   * @b false otherwise.
   */
  bool end(std::map<std::string, SubModelFactory*>::iterator & iter);

  /**
   * @brief Add a factory associated to a given given library name
   *
   * @param lib : Name of the submodel library to add - key in the map
   * @param factory : Pointer to the SubModel to add - value in the
   * map
   */
  void add(const std::string & lib, SubModelFactory * factory);

  /**
   * @brief reset all factory : delete all factories
   *
   */
  void reset();

 private:
  std::map<std::string, SubModelFactory* > factoryMap_;  ///< associate a library factory with the name of the library
};
}  // namespace DYN
#endif  // MODELER_COMMON_DYNSUBMODELFACTORY_H_
