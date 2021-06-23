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
#include <boost/shared_ptr.hpp>

#ifdef LANG_CXX11
#include <mutex>
#endif

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
   * @brief destroy an instance of a submodel
   *
   */
  virtual void destroy(SubModel*) const = 0;

  /**
   * @brief Create a submodel loading given lib
   *
   * @param lib : Name of the submodel library to load
   * @return Pointer to the created submodel
   */
  static boost::shared_ptr<SubModel> createSubModelFromLib(const std::string& lib);

  void* handle_;  ///< handle return by dlopen when the library is loaded

 private:
  static SubModelFactories factories_;  ///< Factories already available
};

/**
* @brief function pointer type to destroy a model.
*/
typedef void destroy_model_t(SubModelFactory*);

/**
 * @brief SubModelFactories class
 *
 * Manage submodel factories to avoid loading the same library multiple
 * time.
 */
class SubModelFactories : private boost::noncopyable {
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
  * @brief iterator type on SubModelFactory map.
  */
  typedef std::map<std::string, SubModelFactory*>::iterator SubmodelFactoryIterator;

  /**
   * @brief Get available factory for a given library name
   *
   * @param lib : Name of the submodel library to load
   * @return A map iterator whose key is the library name and whose value
   * is a pointer to the SubModelFactory.
   */
  SubmodelFactoryIterator find(const std::string & lib);

  /**
   * @brief Test if a map iterator is the end operator of factories map
   *
   * @param iter : Iterator to test, typically obtained via
   * @p SubModelFactories::find() function
   * @return @b true if the iterator is the end operator of the factories,
   * @b false otherwise.
   */
  bool end(SubmodelFactoryIterator& iter);

  /**
   * @brief Add a factory associated to a given given library name
   *
   * @param lib : Name of the submodel library to add - key in the map
   * @param factory : Pointer to the SubModel to add - value in the
   * map
   */
  void add(const std::string& lib, SubModelFactory* factory);

  /**
   * @brief Add a factory associated to its destruction method
   *
   * @param lib : Name of the submodel library to add - key in the map
   * @param deleteFactory : function pointer to a desctruction method
   * map
   */
  void add(const std::string& lib, destroy_model_t* deleteFactory);

 private:
  std::map<std::string, SubModelFactory* > factoryMap_;  ///< associate a library factory with the name of the library
  std::map<std::string, destroy_model_t*> factoryMapDestroy_;  ///< associate a library factory with its destruction method
#ifdef LANG_CXX11
  mutable std::mutex factoriesMutex_;  ///< Mutex to handle multithreading access to factories
#endif
};

/**
 * @brief SubModelDelete class
 *
 * Manage the destruction of a submodel.
 */
class SubModelDelete {
 public:
  /**
   * @brief Constructor
   *
   * @param factory: model factory to delete
   */
  explicit SubModelDelete(SubModelFactory* factory);

  /**
   * @brief destructor
   */
  ~SubModelDelete() { }

  /**
   * @brief Function to use this class as a Functor
   *
   * @param subModel: pointer to the subModel to delete
   * map
   */
  void operator()(SubModel* subModel);

 private:
  SubModelFactory* factory_;  ///< factory associated to the model to destroy
};
}  // namespace DYN
#endif  // MODELER_COMMON_DYNSUBMODELFACTORY_H_
