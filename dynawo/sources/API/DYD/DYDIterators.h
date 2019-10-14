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
 * @file  DYDIterators.h
 *
 * @brief
 *
 */
#ifndef API_DYD_DYDITERATORS_H_
#define API_DYD_DYDITERATORS_H_

#include "DYDDynamicModelsCollectionImpl.h"
#include "DYDModelImpl.h"
#include "DYDMacroStaticReferenceImpl.h"

namespace dynamicdata {

class ConnectorConstIteratorImpl;
class ConnectorIteratorImpl;
class ModelConstIteratorImpl;
class ModelIteratorImpl;
class MacroConnectorConstIteratorImpl;
class MacroConnectorIteratorImpl;
class MacroConnectConstIteratorImpl;
class MacroConnectIteratorImpl;
class StaticRefConstIteratorImpl;
class StaticRefIteratorImpl;
class MacroStaticRefConstIteratorImpl;
class MacroStaticRefIteratorImpl;
class MacroStaticReferenceConstIteratorImpl;
class MacroStaticReferenceIteratorImpl;

/**
 * @class dynamicModel_iterator
 * @brief iterator over models
 *
 * iterator over models stored in dynamic models collection
 */
class dynamicModel_iterator {
 public:
  /**
   * @brief this
   */
  typedef dynamicModel_iterator THIS;
  /**
   * @brief Constructor
   *
   * Constructor based on models. Can create an iterator to the
   * beginning of the models' container or to the end. Models
   * can be modified.
   *
   * @param iterated Pointer to the dynamic models collection iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the models' container.
   * @returns Created model_iterator.
   */
  dynamicModel_iterator(DynamicModelsCollection::Impl* iterated, bool begin);

  /**
   * @brief Copy constructor
   * @param original : the model iterator to copy
   */
  dynamicModel_iterator(const dynamicModel_iterator& original);

  /**
   * @brief Destructor
   */
  ~dynamicModel_iterator();

  /**
   * @brief assignment
   * @param other : model_iterator to assign
   *
   * @returns Reference to this model_iterator
   */
  THIS& operator=(const THIS& other);

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this model_iterator
   */
  THIS& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this model_iterator
   */
  THIS operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this model_iterator
   */
  THIS& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this model_iterator
   */
  THIS operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if model_iterators are equals, else false
   */
  bool operator==(const THIS& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if model_iterators are different, else false
   */
  bool operator!=(const THIS& other) const;

  /**
   * @brief Indirection operator
   *
   * @returns Model pointed to by this
   */
  boost::shared_ptr<Model>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Model pointed to by this
   */
  boost::shared_ptr<Model>* operator->() const;

  /**
   * @brief Get the implementation ot the iterator
   * @return the implementation ot the iterator
   */
  ModelIteratorImpl* impl() const;

 private:
  ModelIteratorImpl* impl_;  ///< Pointer to the implementation of the model iterator;
};

/**
 * @class dynamicModel_const_iterator
 * @brief const iterator over models
 *
 * const iterator over models stored in dynamic models collection
 */
class dynamicModel_const_iterator {
 public:
  /**
   * @brief this
   */
  typedef dynamicModel_const_iterator THIS;
  /**
   * @brief Constructor
   *
   * Constructor based on models. Can create a const iterator to the
   * beginning of the models' container or to the end. Models
   * cannot be modified.
   *
   * @param iterated Pointer to the final states collection iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the models' container.
   * @returns Created model_const_iterator.
   */
  dynamicModel_const_iterator(const DynamicModelsCollection::Impl* iterated, bool begin);

  /**
   * @brief Copy constructor
   * @param original : the model const iterator to copy
   */
  dynamicModel_const_iterator(const dynamicModel_const_iterator& original);

  /**
   * @brief Constructor
   *
   * @param original current iterator
   * @returns Created model_const_iterator
   */
  explicit dynamicModel_const_iterator(const dynamicModel_iterator& original);

  /**
   * @brief Destructor
   */
  ~dynamicModel_const_iterator();

  /**
   * @brief assignment
   * @param other : model_const_iterator to assign
   *
   * @returns Reference to this model_const_iterator
   */
  THIS& operator=(const THIS& other);

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this model_const_iterator
   */
  THIS& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this model_const_iterator
   */
  THIS operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this model_const_iterator
   */
  THIS& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this model_const_iterator
   */
  THIS operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if model_const_iterators are equals, else false
   */
  bool operator==(const THIS& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if model_const_iterators are different, else false
   */
  bool operator!=(const THIS& other) const;

  /**
   * @brief Indirection operator
   *
   * @returns Model pointed to by this
   */
  const boost::shared_ptr<Model>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Model pointed to by this
   */
  const boost::shared_ptr<Model>* operator->() const;

 private:
  ModelConstIteratorImpl* impl_;  ///< Pointer to the implementation of the model const iterator;
};

/**
 * @class connector_iterator
 * @brief iterator over connectors
 *
 * iterator over connectors stored in dynamic models collection
 */
class connector_iterator {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on connectors. Can create an iterator to the
   * beginning of the connectors' container or to the end. Connectors
   * can be modified.
   *
   * @param iterated Pointer to the dynamic models collection iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the connectors' container.
   * @returns Created connector_iterator.
   */
  connector_iterator(DynamicModelsCollection::Impl* iterated, bool begin);

  /**
   * @brief Copy constructor
   * @param original : the connector iterator to copy
   */
  connector_iterator(const connector_iterator& original);

  /**
   * @brief Destructor
   */
  ~connector_iterator();

  /**
   * @brief assignment
   * @param other : connector_iterator to assign
   *
   * @returns Reference to this connector_iterator
   */
  connector_iterator& operator=(const connector_iterator& other);

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this connector_iterator
   */
  connector_iterator& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this connector_iterator
   */
  connector_iterator operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this connector_iterator
   */
  connector_iterator& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this connector_iterator
   */
  connector_iterator operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if connector_iterators are equals, else false
   */
  bool operator==(const connector_iterator& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if connector_iterators are different, else false
   */
  bool operator!=(const connector_iterator& other) const;

  /**
   * @brief Indirection operator
   *
   * @returns Connector pointed to by this
   */
  boost::shared_ptr<Connector>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Connector pointed to by this
   */
  boost::shared_ptr<Connector>* operator->() const;

  /**
   * @brief Get the implementation ot the iterator
   * @return the implementation ot the iterator
   */
  ConnectorIteratorImpl* impl() const;

 private:
  ConnectorIteratorImpl* impl_;  ///< Pointer to the implementation of the connector iterator;
};

/**
 * @class connector_const_iterator
 * @brief const iterator over connectors
 *
 * const iterator over connectors stored in dynamic models collection
 */
class connector_const_iterator {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on connectors. Can create a const iterator to the
   * beginning of the connectors' container or to the end. Connectors
   * cannot be modified.
   *
   * @param iterated Pointer to the dynamic models collection iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the connectors' container.
   * @returns Created connector_const_iterator.
   */
  connector_const_iterator(const DynamicModelsCollection::Impl* iterated, bool begin);

  /**
   * @brief Copy constructor
   * @param original : the connector const iterator to copy
   */
  connector_const_iterator(const connector_const_iterator& original);

  /**
   * @brief Constructor
   *
   * @param original current iterator
   * @returns Created connector_const_iterator
   */
  explicit connector_const_iterator(const connector_iterator& original);

  /**
   * @brief Destructor
   */
  ~connector_const_iterator();

  /**
   * @brief assignment
   * @param other : connector_const_iterator to assign
   *
   * @returns Reference to this connector_const_iterator
   */
  connector_const_iterator& operator=(const connector_const_iterator& other);

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this connector_const_iterator
   */
  connector_const_iterator& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this connector_const_iterator
   */
  connector_const_iterator operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this connector_const_iterator
   */
  connector_const_iterator& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this connector_const_iterator
   */
  connector_const_iterator operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if connector_const_iterators are equals, else false
   */
  bool operator==(const connector_const_iterator& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if connector_const_iterators are different, else false
   */
  bool operator!=(const connector_const_iterator& other) const;

  /**
   * @brief Indirection operator
   *
   * @returns Connector pointed to by this
   */
  const boost::shared_ptr<Connector>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Connector pointed to by this
   */
  const boost::shared_ptr<Connector>* operator->() const;

 private:
  ConnectorConstIteratorImpl* impl_;  ///< Pointer to the implementation of the connector const iterator;
};

/**
 * @class macroConnector_iterator
 * @brief iterator over macroConnectors
 *
 * iterator over macroConnectors stored in dynamic models collection
 */
class macroConnector_iterator {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on macroConnectors. Can create an iterator to the
   * beginning of the macroConnectors' container or to the end. MacroConnectors
   * can be modified.
   *
   * @param iterated Pointer to the dynamic models collection iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the macroConnectors' container.
   * @returns Created macroConnector_iterator.
   */
  macroConnector_iterator(DynamicModelsCollection::Impl* iterated, bool begin);

  /**
   * @brief Copy constructor
   * @param original : the macroConnector iterator to copy
   */
  macroConnector_iterator(const macroConnector_iterator& original);

  /**
   * @brief Destructor
   */
  ~macroConnector_iterator();

  /**
   * @brief assignment
   * @param other : macroConnector_iterator to assign
   *
   * @returns Reference to this macroConnector_iterator
   */
  macroConnector_iterator& operator=(const macroConnector_iterator& other);

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this macroConnector_iterator
   */
  macroConnector_iterator& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this macroConnector_iterator
   */
  macroConnector_iterator operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this macroConnector_iterator
   */
  macroConnector_iterator& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this macroConnector_iterator
   */
  macroConnector_iterator operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if macroConnector_iterators are equals, else false
   */
  bool operator==(const macroConnector_iterator& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if macroConnector_iterators are different, else false
   */
  bool operator!=(const macroConnector_iterator& other) const;

  /**
   * @brief Indirection operator
   *
   * @returns MacroConnector pointed to by this
   */
  boost::shared_ptr<MacroConnector>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns MacroConnector pointed to by this
   */
  boost::shared_ptr<MacroConnector>* operator->() const;

  /**
   * @brief Get the implementation ot the iterator
   * @return the implementation ot the iterator
   */
  MacroConnectorIteratorImpl* impl() const;

 private:
  MacroConnectorIteratorImpl* impl_;  ///< Pointer to the implementation of the macroConnector iterator;
};

/**
 * @class macroConnector_const_iterator
 * @brief const iterator over macroConnectors
 *
 * const iterator over macroConnectors stored in dynamic models collection
 */
class macroConnector_const_iterator {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on macroConnectors. Can create a const iterator to the
   * beginning of the macroConnectors' container or to the end. MacroConnectors
   * cannot be modified.
   *
   * @param iterated Pointer to the dynamic models collection iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the macroConnectors' container.
   * @returns Created macroConnector_const_iterator.
   */
  macroConnector_const_iterator(const DynamicModelsCollection::Impl* iterated, bool begin);

  /**
   * @brief Copy constructor
   * @param original : the macroConnector const iterator to copy
   */
  macroConnector_const_iterator(const macroConnector_const_iterator& original);

  /**
   * @brief Constructor
   *
   * @param original current iterator
   * @returns Created macroConnector_const_iterator
   */
  explicit macroConnector_const_iterator(const macroConnector_iterator& original);

  /**
   * @brief Destructor
   */
  ~macroConnector_const_iterator();

  /**
   * @brief assignment
   * @param other : macroConnector_const_iterator to assign
   *
   * @returns Reference to this macroConnector_const_iterator
   */
  macroConnector_const_iterator& operator=(const macroConnector_const_iterator& other);

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this macroConnector_const_iterator
   */
  macroConnector_const_iterator& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this macroConnector_const_iterator
   */
  macroConnector_const_iterator operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this macroConnector_const_iterator
   */
  macroConnector_const_iterator& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this macroConnector_const_iterator
   */
  macroConnector_const_iterator operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if macroConnector_const_iterators are equals, else false
   */
  bool operator==(const macroConnector_const_iterator& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if macroConnector_const_iterators are different, else false
   */
  bool operator!=(const macroConnector_const_iterator& other) const;

  /**
   * @brief Indirection operator
   *
   * @returns MacroConnector pointed to by this
   */
  const boost::shared_ptr<MacroConnector>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns MacroConnector pointed to by this
   */
  const boost::shared_ptr<MacroConnector>* operator->() const;

 private:
  MacroConnectorConstIteratorImpl* impl_;  ///< Pointer to the implementation of the macroconnector const iterator;
};

/**
 * @class macroConnect_iterator
 * @brief iterator over macroConnects
 *
 * iterator over macroConnects stored in dynamic models collection
 */
class macroConnect_iterator {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on macroConnects. Can create an iterator to the
   * beginning of the macroConnects' container or to the end. MacroConnects
   * can be modified.
   *
   * @param iterated Pointer to the dynamic models collection iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the macroConnects' container.
   * @returns Created macroConnect_iterator.
   */
  macroConnect_iterator(DynamicModelsCollection::Impl* iterated, bool begin);

  /**
   * @brief Copy constructor
   * @param original : the macroConnect iterator to copy
   */
  macroConnect_iterator(const macroConnect_iterator& original);

  /**
   * @brief Destructor
   */
  ~macroConnect_iterator();

  /**
   * @brief assignment
   * @param other : macroConnect_iterator to assign
   *
   * @returns Reference to this macroConnect_iterator
   */
  macroConnect_iterator& operator=(const macroConnect_iterator& other);

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this macroConnect_iterator
   */
  macroConnect_iterator& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this macroConnect_iterator
   */
  macroConnect_iterator operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this macroConnect_iterator
   */
  macroConnect_iterator& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this macroConnect_iterator
   */
  macroConnect_iterator operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if macroConnect_iterators are equals, else false
   */
  bool operator==(const macroConnect_iterator& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if macroConnect_iterators are different, else false
   */
  bool operator!=(const macroConnect_iterator& other) const;

  /**
   * @brief Indirection operator
   *
   * @returns MacroConnect pointed to by this
   */
  boost::shared_ptr<MacroConnect>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns MacroConnect pointed to by this
   */
  boost::shared_ptr<MacroConnect>* operator->() const;

  /**
   * @brief Get the implementation ot the iterator
   * @return the implementation ot the iterator
   */
  MacroConnectIteratorImpl* impl() const;

 private:
  MacroConnectIteratorImpl* impl_;  ///< Pointer to the implementation of the macroConnect iterator;
};

/**
 * @class macroConnect_const_iterator
 * @brief const iterator over macroConnects
 *
 * const iterator over macroConnects stored in dynamic models collection
 */
class macroConnect_const_iterator {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on macroConnects. Can create a const iterator to the
   * beginning of the macroConnects' container or to the end. MacroConnects
   * cannot be modified.
   *
   * @param iterated Pointer to the dynamic models collection iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the macroConnects' container.
   * @returns Created macroConnect_const_iterator.
   */
  macroConnect_const_iterator(const DynamicModelsCollection::Impl* iterated, bool begin);

  /**
   * @brief Copy constructor
   * @param original : the macroConnect const iterator to copy
   */
  macroConnect_const_iterator(const macroConnect_const_iterator& original);

  /**
   * @brief Constructor
   *
   * @param original current iterator
   * @returns Created macroConnect_const_iterator
   */
  explicit macroConnect_const_iterator(const macroConnect_iterator& original);

  /**
   * @brief Destructor
   */
  ~macroConnect_const_iterator();

  /**
   * @brief assignment
   * @param other : macroConnect_const_iterator to assign
   *
   * @returns Reference to this macroConnect_const_iterator
   */
  macroConnect_const_iterator& operator=(const macroConnect_const_iterator& other);

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this macroConnect_const_iterator
   */
  macroConnect_const_iterator& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this macroConnect_const_iterator
   */
  macroConnect_const_iterator operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this macroConnect_const_iterator
   */
  macroConnect_const_iterator& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this macroConnect_const_iterator
   */
  macroConnect_const_iterator operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if macroConnect_const_iterators are equals, else false
   */
  bool operator==(const macroConnect_const_iterator& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if macroConnect_const_iterators are different, else false
   */
  bool operator!=(const macroConnect_const_iterator& other) const;

  /**
   * @brief Indirection operator
   *
   * @returns MacroConnect pointed to by this
   */
  const boost::shared_ptr<MacroConnect>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns MacroConnect pointed to by this
   */
  const boost::shared_ptr<MacroConnect>* operator->() const;

 private:
  MacroConnectConstIteratorImpl* impl_;  ///< Pointer to the implementation of the macroconnect const iterator;
};

/**
 * @class staticRef_iterator
 * @brief iterator over staticRefs
 *
 * iterator over staticRefs stored in Model and MacroStaticReference
 */
class staticRef_iterator {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on staticRefs. Can create an iterator to the
   * beginning of the staticRef container or to the end.
   * StaticRefs can be modified.
   *
   * @param iterated Pointer to the model iterated
   * @param begin Flag indicating if the iterator points to the beginning (true)
   * or the end of the staticRefs container.
   * @returns Created staticRef_iterator.
   */
  staticRef_iterator(Model::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * Constructor based on staticRefs. Can create an iterator to the
   * beginning of the staticRef container or to the end.
   * StaticRefs can be modified.
   *
   * @param iterated Pointer to the macroStaticReference iterated
   * @param begin Flag indicating if the iterator points to the beginning (true)
   * or the end of the staticRefs container.
   * @returns Created staticRef_iterator.
   */
  staticRef_iterator(MacroStaticReference::Impl* iterated, bool begin);

  /**
   * @brief Copy constructor
   * @param original : the staticRef const iterator to copy
   */
  staticRef_iterator(const staticRef_iterator& original);

  /**
   * @brief Destructor
   */
  ~staticRef_iterator();

  /**
   * @brief assignment
   * @param other : staticRef_iterator to assign
   *
   * @returns Reference to this staticRef_iterator
   */
  staticRef_iterator& operator=(const staticRef_iterator& other);

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this staticRef_iterator
   */
  staticRef_iterator& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this staticRef_iterator
   */
  staticRef_iterator operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this staticRef_iterator
   */
  staticRef_iterator& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this staticRef_iterator
   */
  staticRef_iterator operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if staticRef_iterator are equals, else false
   */
  bool operator==(const staticRef_iterator& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if staticRef_iterator are different, else false
   */
  bool operator!=(const staticRef_iterator& other) const;

  /**
   * @brief Indirection operator
   *
   * @returns StaticRef pointed to by this
   */
  boost::shared_ptr<StaticRef>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns StaticRef pointed to by this
   */
  boost::shared_ptr<StaticRef>* operator->() const;

  /**
   * @brief Get the implementation of the iterator
   * @return the implementation of the iterator
   */
  StaticRefIteratorImpl* impl() const;

 private:
  StaticRefIteratorImpl* impl_;  ///< Pointer to the implementation of the StaticRef iterator
};

/**
 * @class staticRef_const_iterator
 * @brief const iterator over staticRefs
 *
 * const iterator over staticRefs stored in Model and MacroStaticReference
 */
class staticRef_const_iterator {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on staticRefs. Can create a const iterator to the
   * beginning of the staticRefs container or to the end.
   * StaticRefs cannot be modified.
   *
   * @param iterated Pointer to the model iterated
   * @param begin Flag indicating if the iterator points to the beginning (true)
   * or the end of the staticRefs container.
   * @returns Created staticRef_const_iterator.
   */
  staticRef_const_iterator(const Model::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * Constructor based on staticRefs. Can create a const iterator to the
   * beginning of the staticRefs container or to the end.
   * StaticRefs cannot be modified.
   *
   * @param iterated Pointer to the macroStaticReference iterated
   * @param begin Flag indicating if the iterator points to the beginning (true)
   * or the end of the staticRefs container.
   * @returns Created staticRef_const_iterator.
   */
  staticRef_const_iterator(const MacroStaticReference::Impl* iterated, bool begin);

  /**
   * @brief Copy constructor
   * @param original : the staticRef const iterator to copy
   */
  staticRef_const_iterator(const staticRef_const_iterator& original);

  /**
   * @brief Constructor
   *
   * @param original current iterator
   * @returns Created staticRef_const_iterator
   */
  explicit staticRef_const_iterator(const staticRef_iterator& original);

  /**
   * @brief Destructor
   */
  virtual ~staticRef_const_iterator();

  /**
   * @brief assignment
   * @param other : staticRef_iterator to assign
   *
   * @returns Reference to this staticRef_iterator
   */
  staticRef_const_iterator& operator=(const staticRef_const_iterator& other);

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this staticRef_const_iterator
   */
  staticRef_const_iterator& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this staticRef_const_iterator
   */
  staticRef_const_iterator operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this staticRef_const_iterator
   */
  staticRef_const_iterator& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this staticRef_const_iterator
   */
  staticRef_const_iterator operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if staticRef_const_iterator are equals, else false
   */
  bool operator==(const staticRef_const_iterator& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if staticRef_const_iterator are different, else false
   */
  bool operator!=(const staticRef_const_iterator& other) const;

  /**
   * @brief Indirection operator
   *
   * @returns StaticRef pointed to by this
   */
  const boost::shared_ptr<StaticRef>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns StaticRef pointed to by this
   */
  const boost::shared_ptr<StaticRef>* operator->() const;

 private:
  StaticRefConstIteratorImpl* impl_;  ///< Pointer to the implementation of the StaticRef const iterator;
};

/**
 * @class macroStaticRef_iterator
 * @brief iterator over macroStaticRefs
 *
 * iterator over macroStaticRefs stored in models
 */
class macroStaticRef_iterator {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on macroStaticRefs. Can create an iterator to the
   * beginning of the macroStaticRef container or to the end.
   * MacroStaticRefs can be modified.
   *
   * @param iterated Pointer to the model iterated
   * @param begin Flag indicating if the iterator points to the beginning (true)
   * or the end of the macroStaticRefs container.
   * @returns Created macroStaticRef_iterator.
   */
  macroStaticRef_iterator(Model::Impl* iterated, bool begin);

  /**
   * @brief Copy constructor
   * @param original : the macroStaticRef const iterator to copy
   */
  macroStaticRef_iterator(const macroStaticRef_iterator& original);

  /**
   * @brief Destructor
   */
  ~macroStaticRef_iterator();

  /**
   * @brief assignment
   * @param other : macroStaticRef_iterator to assign
   *
   * @returns Reference to this macroStaticRef_iterator
   */
  macroStaticRef_iterator& operator=(const macroStaticRef_iterator& other);

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this macroStaticRef_iterator
   */
  macroStaticRef_iterator& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this macroStaticRef_iterator
   */
  macroStaticRef_iterator operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this macroStaticRef_iterator
   */
  macroStaticRef_iterator& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this macroStaticRef_iterator
   */
  macroStaticRef_iterator operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if macroStaticRef_iterator are equals, else false
   */
  bool operator==(const macroStaticRef_iterator& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if macroStaticRef_iterator are different, else false
   */
  bool operator!=(const macroStaticRef_iterator& other) const;

  /**
   * @brief Indirection operator
   *
   * @returns MacroStaticRef pointed to by this
   */
  boost::shared_ptr<MacroStaticRef>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns MacroStaticRef pointed to by this
   */
  boost::shared_ptr<MacroStaticRef>* operator->() const;

  /**
   * @brief Get the implementation of the iterator
   * @return the implementation of the iterator
   */
  MacroStaticRefIteratorImpl* impl() const;

 private:
  MacroStaticRefIteratorImpl* impl_;  ///< Pointer to the implementation of the StaticRef iterator
};

/**
 * @class macroStaticRef_const_iterator
 * @brief const iterator over macroStaticRefs
 *
 * const iterator over macroStaticRefs stored in models
 */
class macroStaticRef_const_iterator {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on macroStaticRefs. Can create a const iterator to the
   * beginning of the macroStaticRefs container or to the end.
   * MacroStaticRefs cannot be modified.
   *
   * @param iterated Pointer to the model iterated
   * @param begin Flag indicating if the iterator points to the beginning (true)
   * or the end of the macroStaticRefs container.
   * @returns Created macroStaticRef_const_iterator.
   */
  macroStaticRef_const_iterator(const Model::Impl* iterated, bool begin);

  /**
   * @brief Copy constructor
   * @param original : the macroStaticRef const iterator to copy
   */
  macroStaticRef_const_iterator(const macroStaticRef_const_iterator& original);

  /**
   * @brief Constructor
   *
   * @param original current iterator
   * @returns Created macroStaticRef_const_iterator
   */
  explicit macroStaticRef_const_iterator(const macroStaticRef_iterator& original);

  /**
   * @brief Destructor
   */
  ~macroStaticRef_const_iterator();

  /**
   * @brief assignment
   * @param other : macroStaticRef_const_iterator to assign
   *
   * @returns Reference to this macroStaticRef_const_iterator
   */
  macroStaticRef_const_iterator& operator=(const macroStaticRef_const_iterator& other);

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this macroStaticRef_const_iterator
   */
  macroStaticRef_const_iterator& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this macroStaticRef_const_iterator
   */
  macroStaticRef_const_iterator operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this macroStaticRef_const_iterator
   */
  macroStaticRef_const_iterator& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this macroStaticRef_const_iterator
   */
  macroStaticRef_const_iterator operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if macroStaticRef_const_iterator are equals, else false
   */
  bool operator==(const macroStaticRef_const_iterator& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if macroStaticRef_const_iterator are different, else false
   */
  bool operator!=(const macroStaticRef_const_iterator& other) const;

  /**
   * @brief Indirection operator
   *
   * @returns MacroStaticRef pointed to by this
   */
  const boost::shared_ptr<MacroStaticRef>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns MacroStaticRef pointed to by this
   */
  const boost::shared_ptr<MacroStaticRef>* operator->() const;

 private:
  MacroStaticRefConstIteratorImpl* impl_;  ///< Pointer to the implementation of the StaticRef const iterator;
};

/**
 * @class macroStaticReference_iterator
 * @brief iterator over macroStaticReferences
 *
 * iterator over macroStaticReferences stored in dynamic models collection
 */
class macroStaticReference_iterator {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on macroStaticReferences. Can create an iterator to the
   * beginning of the macroStaticReferences container or to the end.
   * MacroStaticReferences can be modified.
   *
   * @param iterated Pointer to the dynamic models collection iterated
   * @param begin Flag indicating if the iterator points to the beginning (true)
   * or the end of the macroStaticReferences container.
   * @returns Created macroStaticReference_iterator.
   */
  macroStaticReference_iterator(DynamicModelsCollection::Impl* iterated, bool begin);

  /**
   * @brief Copy constructor
   * @param original : the macroStaticReference const iterator to copy
   */
  macroStaticReference_iterator(const macroStaticReference_iterator& original);

  /**
   * @brief Destructor
   */
  ~macroStaticReference_iterator();

  /**
   * @brief assignment
   * @param other : macroStaticReference_iterator to assign
   *
   * @returns Reference to this macroStaticReference_iterator
   */
  macroStaticReference_iterator& operator=(const macroStaticReference_iterator& other);

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this macroStaticReference_iterator
   */
  macroStaticReference_iterator& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this macroStaticReference_iterator
   */
  macroStaticReference_iterator operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this macroStaticReference_iterator
   */
  macroStaticReference_iterator& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this macroStaticReference_iterator
   */
  macroStaticReference_iterator operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if macroStaticReference_iterator are equals, else false
   */
  bool operator==(const macroStaticReference_iterator& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if macroStaticReference_iterator are different, else false
   */
  bool operator!=(const macroStaticReference_iterator& other) const;

  /**
   * @brief Indirection operator
   *
   * @returns MacroStaticReference pointed to by this
   */
  boost::shared_ptr<MacroStaticReference>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns MacroStaticReference pointed to by this
   */
  boost::shared_ptr<MacroStaticReference>* operator->() const;

  /**
   * @brief Get the implementation of the iterator
   * @return the implementation of the iterator
   */
  MacroStaticReferenceIteratorImpl* impl() const;

 private:
  MacroStaticReferenceIteratorImpl* impl_;  ///< Pointer to the implementation of the macroStaticReference iterator
};

/**
 * @class macroStaticReference_const_iterator
 * @brief const iterator over macroStaticReferences
 *
 * const iterator over macroStaticReferences stored in dynamic models collection
 */
class macroStaticReference_const_iterator {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on macroStaticReferences. Can create a const iterator to the
   * beginning of the macroStaticReferences container or to the end.
   * MacroStaticReferences cannot be modified.
   *
   * @param iterated Pointer to the dynamic models collection iterated
   * @param begin Flag indicating if the iterator points to the beginning (true)
   * or the end of the macroStaticReferences container.
   * @returns Created macroStaticReference_const_iterator.
   */
  macroStaticReference_const_iterator(const DynamicModelsCollection::Impl* iterated, bool begin);

  /**
   * @brief Copy constructor
   * @param original : the macroStaticReference const iterator to copy
   */
  macroStaticReference_const_iterator(const macroStaticReference_const_iterator& original);

  /**
   * @brief Constructor
   *
   * @param original current iterator
   * @returns Created macroStaticReference_const_iterator
   */
  explicit macroStaticReference_const_iterator(const macroStaticReference_iterator& original);

  /**
   * @brief Destructor
   */
  ~macroStaticReference_const_iterator();

  /**
   * @brief assignment
   * @param other : macroStaticReference_const_iterator to assign
   *
   * @returns Reference to this macroStaticReference_const_iterator
   */
  macroStaticReference_const_iterator& operator=(const macroStaticReference_const_iterator& other);

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this macroStaticReference_const_iterator
   */
  macroStaticReference_const_iterator& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this macroStaticReference_const_iterator
   */
  macroStaticReference_const_iterator operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this macroStaticReference_const_iterator
   */
  macroStaticReference_const_iterator& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this macroStaticReference_const_iterator
   */
  macroStaticReference_const_iterator operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if macroStaticReference_const_iterator are equals, else false
   */
  bool operator==(const macroStaticReference_const_iterator& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if macroStaticReference_const_iterator are different, else false
   */
  bool operator!=(const macroStaticReference_const_iterator& other) const;

  /**
   * @brief Indirection operator
   *
   * @returns MacroStaticReference pointed to by this
   */
  const boost::shared_ptr<MacroStaticReference>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns MacroStaticReference pointed to by this
   */
  const boost::shared_ptr<MacroStaticReference>* operator->() const;

 private:
  MacroStaticReferenceConstIteratorImpl* impl_;  ///< Pointer to the implementation of the macroStaticReference const iterator;
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDITERATORS_H_
