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
 * @file  DYDIteratorsImpl.h
 *
 * @brief
 *
 */
#ifndef API_DYD_DYDITERATORSIMPL_H_
#define API_DYD_DYDITERATORSIMPL_H_

#include "DYDDynamicModelsCollectionImpl.h"
#include "DYDModelImpl.h"
#include "DYDMacroStaticReferenceImpl.h"

namespace dynamicdata {

class Connector;
class Model;

/**
 * @class ModelIteratorImpl
 * @brief Implementation class for iterators' functions
 */
class ModelIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on dynamicModelsCollection. Can create an implementation for
   * an iterator to the beginning of the models' container or to the end.
   *
   * @param iterated Pointer to the models' vector iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the models' container.
   * @returns Created implementation object
   */
  ModelIteratorImpl(DynamicModelsCollection::Impl* iterated, bool begin);

  /**
   * @brief Destructor
   */
  ~ModelIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  ModelIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  ModelIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this iterator
   */
  ModelIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  ModelIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const ModelIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const ModelIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns Model pointed to by this
   */
  boost::shared_ptr<Model>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the Model pointed to by this
   */
  boost::shared_ptr<Model>* operator->() const;

  /**
   * @brief Get the current iterator
   *
   * @returns Current iterator
   */
  std::map<std::string, boost::shared_ptr<Model> >::iterator current() const;

 private:
  std::map<std::string, boost::shared_ptr<Model> >::iterator current_;  ///< current map iterator
};

/**
 * @class ModelConstIteratorImpl
 * @brief Implementation class for const iterators' functions
 */
class ModelConstIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on dynamicModelsCollection. Can create an implementation for
   * a const iterator to the beginning of the models' container or to the end.
   *
   * @param iterated Pointer to the models' vector iterated
   * @param begin Flag indicating if the const iterator point to the beginning (true)
   * or the end of the models' container.
   * @returns Created implementation object
   */
  ModelConstIteratorImpl(const DynamicModelsCollection::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * @param iterator current iterator on the vector
   * @returns Created constant iterator
   */
  explicit ModelConstIteratorImpl(const ModelIteratorImpl& iterator);

  /**
   * @brief Destructor
   */
  ~ModelConstIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  ModelConstIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  ModelConstIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this iterator
   */
  ModelConstIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  ModelConstIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const ModelConstIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const ModelConstIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns Model pointed to by this
   */
  const boost::shared_ptr<Model>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the Model pointed to by this
   */
  const boost::shared_ptr<Model>* operator->() const;

 private:
  std::map<std::string, boost::shared_ptr<Model> >::const_iterator current_;  ///< current vector const iterator
};

/**
 * @class ConnectorIteratorImpl
 * @brief Implementation class for iterators' functions
 */
class ConnectorIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on dynamicModelsCollection. Can create an implementation for
   * an iterator to the beginning of the connectors' container or to the end.
   *
   * @param iterated Pointer to the connectors' vector iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the connectors' container.
   * @returns Created implementation object
   */
  ConnectorIteratorImpl(DynamicModelsCollection::Impl* iterated, bool begin);

  /**
   * @brief Destructor
   */
  ~ConnectorIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  ConnectorIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  ConnectorIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this iterator
   */
  ConnectorIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  ConnectorIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const ConnectorIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const ConnectorIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns Connector pointed to by this
   */
  boost::shared_ptr<Connector>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the Connector pointed to by this
   */
  boost::shared_ptr<Connector>* operator->() const;

  /**
   * @brief Get the current iterator
   *
   * @returns Current iterator
   */
  std::vector<boost::shared_ptr<Connector> >::iterator current() const;

 private:
  std::vector<boost::shared_ptr<Connector> >::iterator current_;  ///< current vector iterator
};

/**
 * @class ConnectorConstIteratorImpl
 * @brief Implementation class for constant iterators' functions
 */
class ConnectorConstIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on dynamicModelsCollection. Can create an implementation for
   * a const iterator to the beginning of the connectors' container or to the end.
   *
   * @param iterated Pointer to the connectors' vector iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the connectors' container.
   * @returns Created implementation object
   */
  ConnectorConstIteratorImpl(const DynamicModelsCollection::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * @param iterator current iterator on the vector
   * @returns Created constant iterator
   */
  explicit ConnectorConstIteratorImpl(const ConnectorIteratorImpl& iterator);

  /**
   * @brief Destructor
   */
  ~ConnectorConstIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  ConnectorConstIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  ConnectorConstIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this iterator
   */
  ConnectorConstIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  ConnectorConstIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const ConnectorConstIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const ConnectorConstIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns Connector pointed to by this
   */
  const boost::shared_ptr<Connector>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the Connector pointed to by this
   */
  const boost::shared_ptr<Connector>* operator->() const;

 private:
  std::vector<boost::shared_ptr<Connector> >::const_iterator current_;  ///< current vector const iterator
};

/**
 * @class MacroConnectorIteratorImpl
 * @brief Implementation class for iterators' functions
 */
class MacroConnectorIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on dynamicModelsCollection. Can create an implementation for
   * an iterator to the beginning of the macroConnectors' container or to the end.
   *
   * @param iterated Pointer to the macroConnectors' vector iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the macroConnectors' container.
   * @returns Created implementation object
   */
  MacroConnectorIteratorImpl(DynamicModelsCollection::Impl* iterated, bool begin);

  /**
   * @brief Destructor
   */
  ~MacroConnectorIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  MacroConnectorIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  MacroConnectorIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this iterator
   */
  MacroConnectorIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  MacroConnectorIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const MacroConnectorIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const MacroConnectorIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns MacroConnector pointed to by this
   */
  boost::shared_ptr<MacroConnector>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the Connector pointed to by this
   */
  boost::shared_ptr<MacroConnector>* operator->() const;

  /**
   * @brief Get the current iterator
   *
   * @returns Current iterator
   */
  std::map<std::string, boost::shared_ptr<MacroConnector> >::iterator current() const;

 private:
  std::map<std::string, boost::shared_ptr<MacroConnector> >::iterator current_;  ///< current map iterator
};

/**
 * @class MacroConnectorConstIteratorImpl
 * @brief Implementation class for constant iterators' functions
 */
class MacroConnectorConstIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on dynamicModelsCollection. Can create an implementation for
   * a const iterator to the beginning of the macroConnectors' container or to the end.
   *
   * @param iterated Pointer to the macroConnectors' vector iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the macroConnectors' container.
   * @returns Created implementation object
   */
  MacroConnectorConstIteratorImpl(const DynamicModelsCollection::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * @param iterator current iterator on the map
   * @returns Created constant iterator
   */
  explicit MacroConnectorConstIteratorImpl(const MacroConnectorIteratorImpl& iterator);

  /**
   * @brief Destructor
   */
  ~MacroConnectorConstIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  MacroConnectorConstIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  MacroConnectorConstIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this iterator
   */
  MacroConnectorConstIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  MacroConnectorConstIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const MacroConnectorConstIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const MacroConnectorConstIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns MacroConnector pointed to by this
   */
  const boost::shared_ptr<MacroConnector>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the MacroConnector pointed to by this
   */
  const boost::shared_ptr<MacroConnector>* operator->() const;

 private:
  std::map<std::string, boost::shared_ptr<MacroConnector> >::const_iterator current_;  ///< current map const iterator
};

/**
 * @class MacroConnectIteratorImpl
 * @brief Implementation class for iterators' functions
 */
class MacroConnectIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on dynamicModelsCollection. Can create an implementation for
   * an iterator to the beginning of the macroConnects' container or to the end.
   *
   * @param iterated Pointer to the macroConnects' vector iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the macroConnects' container.
   * @returns Created implementation object
   */
  MacroConnectIteratorImpl(DynamicModelsCollection::Impl* iterated, bool begin);

  /**
   * @brief Destructor
   */
  ~MacroConnectIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  MacroConnectIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  MacroConnectIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this iterator
   */
  MacroConnectIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  MacroConnectIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const MacroConnectIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const MacroConnectIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns MacroConnect pointed to by this
   */
  boost::shared_ptr<MacroConnect>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the Connect pointed to by this
   */
  boost::shared_ptr<MacroConnect>* operator->() const;

  /**
   * @brief Get the current iterator
   *
   * @returns Current iterator
   */
  std::vector<boost::shared_ptr<MacroConnect> >::iterator current() const;

 private:
  std::vector<boost::shared_ptr<MacroConnect> >::iterator current_;  ///< current vector iterator
};

/**
 * @class MacroConnectConstIteratorImpl
 * @brief Implementation class for constant iterators' functions
 */
class MacroConnectConstIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on dynamicModelsCollection. Can create an implementation for
   * a const iterator to the beginning of the macroConnects' container or to the end.
   *
   * @param iterated Pointer to the macroConnects' vector iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the macroConnects' container.
   * @returns Created implementation object
   */
  MacroConnectConstIteratorImpl(const DynamicModelsCollection::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * @param iterator current iterator on the map
   * @returns Created constant iterator
   */
  explicit MacroConnectConstIteratorImpl(const MacroConnectIteratorImpl& iterator);

  /**
   * @brief Destructor
   */
  ~MacroConnectConstIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  MacroConnectConstIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  MacroConnectConstIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference of this iterator
   */
  MacroConnectConstIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  MacroConnectConstIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const MacroConnectConstIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const MacroConnectConstIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns MacroConnect pointed to by this
   */
  const boost::shared_ptr<MacroConnect>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the MacroConnect pointed to by this
   */
  const boost::shared_ptr<MacroConnect>* operator->() const;

 private:
  std::vector<boost::shared_ptr<MacroConnect> >::const_iterator current_;  ///< current vector const iterator
};

/**
 * @class StaticRefIteratorImpl
 * @brief Implementation class for iterators' functions
 */
class StaticRefIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on Model. Can create an implementation for
   * an iterator to the beginning of the staticRefs container or to the end.
   *
   * @param iterated Pointer to the model iterated
   * @param begin Flag indicating if the iterator points to the beginning (true)
   * or the end of the staticRefs container.
   * @returns Created implementation object
   */
  StaticRefIteratorImpl(Model::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * Constructor based on MacroStaticReference. Can create an implementation for
   * an iterator to the beginning of the staticRefs container or to the end.
   *
   * @param iterated Pointer to the macroStaticReference iterated
   * @param begin Flag indicating if the iterator points to the beginning (true)
   * or the end of the staticRefs container.
   * @returns Created implementation object
   */
  StaticRefIteratorImpl(MacroStaticReference::Impl* iterated, bool begin);

  /**
   * @brief Destructor
   */
  ~StaticRefIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  StaticRefIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  StaticRefIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this iterator
   */
  StaticRefIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  StaticRefIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if iterators are equals, else false
   */
  bool operator==(const StaticRefIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if iterators are different, else false
   */
  bool operator!=(const StaticRefIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns StaticRef pointed to by this
   */
  boost::shared_ptr<StaticRef>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the StaticRef pointed to by this
   */
  boost::shared_ptr<StaticRef>* operator->() const;

  /**
   * @brief Get the current iterator
   *
   * @returns Current iterator
   */
  std::map<std::string, boost::shared_ptr<StaticRef> >::iterator current() const;

 private:
  std::map<std::string, boost::shared_ptr<StaticRef> >::iterator current_;  ///< current map iterator
};

/**
 * @class StaticRefConstIteratorImpl
 * @brief Implementation class for constant iterators' functions
 */
class StaticRefConstIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on Model. Can create an implementation for
   * a const iterator to the beginning of the staticRefs container or to the end.
   *
   * @param iterated Pointer to the model iterated
   * @param begin Flag indicating if the iterator points to the beginning (true)
   * or the end of the staticRefs container.
   * @returns Created implementation object
   */
  StaticRefConstIteratorImpl(const Model::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * Constructor based on MacroStaticReference. Can create an implementation for
   * a const iterator to the beginning of the staticRefs container or to the end.
   *
   * @param iterated Pointer to the macroStaticReference iterated
   * @param begin Flag indicating if the iterator points to the beginning (true)
   * or the end of the staticRefs container.
   * @returns Created implementation object
   */
  StaticRefConstIteratorImpl(const MacroStaticReference::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * @param iterator current iterator on the container
   * @returns Created constant iterator
   */
  explicit StaticRefConstIteratorImpl(const StaticRefIteratorImpl& iterator);

  /**
   * @brief Destructor
   */
  ~StaticRefConstIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  StaticRefConstIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  StaticRefConstIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference of this iterator
   */
  StaticRefConstIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  StaticRefConstIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if iterators are equals, else false
   */
  bool operator==(const StaticRefConstIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if iterators are different, else false
   */
  bool operator!=(const StaticRefConstIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns StaticRef pointed to by this
   */
  const boost::shared_ptr<StaticRef>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the StaticRef pointed to by this
   */
  const boost::shared_ptr<StaticRef>* operator->() const;

 private:
  std::map<std::string, boost::shared_ptr<StaticRef> >::const_iterator current_;  ///< current map const iterator
};

/**
 * @class MacroStaticRefIteratorImpl
 * @brief Implementation class for iterators' functions
 */
class MacroStaticRefIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on Model. Can create an implementation for
   * an iterator to the beginning of the MacroStaticRefs container or to the end.
   *
   * @param iterated Pointer to the model iterated
   * @param begin Flag indicating if the iterator points to the beginning (true)
   * or the end of the MacroStaticRefs container.
   * @returns Created implementation object
   */
  MacroStaticRefIteratorImpl(Model::Impl* iterated, bool begin);

  /**
   * @brief Destructor
   */
  ~MacroStaticRefIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  MacroStaticRefIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  MacroStaticRefIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this iterator
   */
  MacroStaticRefIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  MacroStaticRefIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if iterators are equals, else false
   */
  bool operator==(const MacroStaticRefIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if iterators are different, else false
   */
  bool operator!=(const MacroStaticRefIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns MacroStaticRef pointed to by this
   */
  boost::shared_ptr<MacroStaticRef>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the MacroStaticRef pointed to by this
   */
  boost::shared_ptr<MacroStaticRef>* operator->() const;

  /**
   * @brief Get the current iterator
   *
   * @returns Current iterator
   */
  std::map<std::string, boost::shared_ptr<MacroStaticRef> >::iterator current() const;

 private:
  std::map<std::string, boost::shared_ptr<MacroStaticRef> >::iterator current_;  ///< current map iterator
};

/**
 * @class MacroStaticRefConstIteratorImpl
 * @brief Implementation class for constant iterators' functions
 */
class MacroStaticRefConstIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on Model. Can create an implementation for
   * a const iterator to the beginning of the MacroStaticRefs container or to the end.
   *
   * @param iterated Pointer to the model iterated
   * @param begin Flag indicating if the iterator points to the beginning (true)
   * or the end of the MacroStaticRefs container.
   * @returns Created implementation object
   */
  MacroStaticRefConstIteratorImpl(const Model::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * @param iterator current iterator on the container
   * @returns Created constant iterator
   */
  explicit MacroStaticRefConstIteratorImpl(const MacroStaticRefIteratorImpl& iterator);

  /**
   * @brief Destructor
   */
  ~MacroStaticRefConstIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  MacroStaticRefConstIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  MacroStaticRefConstIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference of this iterator
   */
  MacroStaticRefConstIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  MacroStaticRefConstIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if iterators are equals, else false
   */
  bool operator==(const MacroStaticRefConstIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if iterators are different, else false
   */
  bool operator!=(const MacroStaticRefConstIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns MacroStaticRef pointed to by this
   */
  const boost::shared_ptr<MacroStaticRef>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the MacroStaticRef pointed to by this
   */
  const boost::shared_ptr<MacroStaticRef>* operator->() const;

 private:
  std::map<std::string, boost::shared_ptr<MacroStaticRef> >::const_iterator current_;  ///< current map const iterator
};

/**
 * @class MacroStaticReferenceIteratorImpl
 * @brief Implementation class for iterators' functions
 */
class MacroStaticReferenceIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on dynamicModelsCollection. Can create an implementation for
   * an iterator to the beginning of the macroStaticReferences container or to the end.
   *
   * @param iterated Pointer to the dynamicModelsCollection iterated
   * @param begin Flag indicating if the iterator points to the beginning (true)
   * or the end of the macroStaticReferences container.
   * @returns Created implementation object
   */
  MacroStaticReferenceIteratorImpl(DynamicModelsCollection::Impl* iterated, bool begin);

  /**
   * @brief Destructor
   */
  ~MacroStaticReferenceIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  MacroStaticReferenceIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  MacroStaticReferenceIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this iterator
   */
  MacroStaticReferenceIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  MacroStaticReferenceIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if iterators are equals, else false
   */
  bool operator==(const MacroStaticReferenceIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if iterators are different, else false
   */
  bool operator!=(const MacroStaticReferenceIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns MacroStaticReference pointed to by this
   */
  boost::shared_ptr<MacroStaticReference>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the MacroStaticReference pointed to by this
   */
  boost::shared_ptr<MacroStaticReference>* operator->() const;

  /**
   * @brief Get the current iterator
   *
   * @returns Current iterator
   */
  std::map<std::string, boost::shared_ptr<MacroStaticReference> >::iterator current() const;

 private:
  std::map<std::string, boost::shared_ptr<MacroStaticReference> >::iterator current_;  ///< current map iterator
};

/**
 * @class MacroStaticReferenceConstIteratorImpl
 * @brief Implementation class for constant iterators' functions
 */
class MacroStaticReferenceConstIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on dynamicModelsCollection. Can create an implementation for
   * a const iterator to the beginning of the macroStaticReferences container or to the end.
   *
   * @param iterated Pointer to the dynamicModelsCollection iterated
   * @param begin Flag indicating if the iterator points to the beginning (true)
   * or the end of the macroStaticReferences container.
   * @returns Created implementation object
   */
  MacroStaticReferenceConstIteratorImpl(const DynamicModelsCollection::Impl* iterated, bool begin);

  /**
   * @brief Constructor
   *
   * @param iterator current iterator on the map
   * @returns Created constant iterator
   */
  explicit MacroStaticReferenceConstIteratorImpl(const MacroStaticReferenceIteratorImpl& iterator);

  /**
   * @brief Destructor
   */
  ~MacroStaticReferenceConstIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this iterator
   */
  MacroStaticReferenceConstIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this iterator
   */
  MacroStaticReferenceConstIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference of this iterator
   */
  MacroStaticReferenceConstIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this iterator
   */
  MacroStaticReferenceConstIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if iterators are equals, else false
   */
  bool operator==(const MacroStaticReferenceConstIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with
   * @returns true if iterators are different, else false
   */
  bool operator!=(const MacroStaticReferenceConstIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns MacroStaticReference pointed to by this
   */
  const boost::shared_ptr<MacroStaticReference>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the MacroStaticReference pointed to by this
   */
  const boost::shared_ptr<MacroStaticReference>* operator->() const;

 private:
  std::map<std::string, boost::shared_ptr<MacroStaticReference> >::const_iterator current_;  ///< current map iterator
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDITERATORSIMPL_H_
