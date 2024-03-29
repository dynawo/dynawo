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
#include <boost/dll.hpp>
#include <boost/function.hpp>

#include <mutex>

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
  SubModelFactory() { }

  /**
   * @brief Destructor
   */
  virtual ~SubModelFactory() = default;

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

  boost::shared_ptr<boost::dll::shared_library> lib_;  ///< Library of the submodel
};

/**
* @brief function pointer type to destroy a model.
*/
typedef void deleteSubModelFactory_t(SubModelFactory*);

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
  SubModelFactories() = default;

  /**
   * @brief destructor
   */
  ~SubModelFactories();

  /**
   * @brief Get unique instance
   * @return  The unique instance
   */
  static SubModelFactories& getInstance();

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
  void add(const std::string& lib, const boost::function<deleteSubModelFactory_t>& deleteFactory);

 private:
  std::map<std::string, SubModelFactory*> factoryMap_;  ///< associate a library factory with the name of the library
  std::map<std::string, boost::function<deleteSubModelFactory_t> > factoryMapDelete_;  ///< associate a library factory with its destruction method
  mutable std::mutex factoriesMutex_;  ///< Mutex to handle multithreading access to factories
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
   * @param factory model factory to delete
   */
  explicit SubModelDelete(SubModelFactory* factory);

  /**
   * @brief Function to use this class as a Functor
   *
   * @param subModel pointer to the subModel to delete
   * map
   */
  void operator()(SubModel* subModel);

 private:
  SubModelFactory* factory_;  ///< factory associated to the model to destroy
};
}  // namespace DYN

/**
 * @brief SubModelFactory getter
 * @return A pointer to a new instance of SubModelFactory
 */
extern "C" DYN::SubModelFactory* getFactory();

/**
 * @brief SubModelFactory destroy method
 * @param factory the SubModelFactory to destroy
 */
extern "C" void deleteFactory(DYN::SubModelFactory* factory);

#endif  // MODELER_COMMON_DYNSUBMODELFACTORY_H_
