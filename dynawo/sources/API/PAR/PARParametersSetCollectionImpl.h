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
 * @file PARParametersSetCollectionImpl.h
 * @brief Dynawo parameters set collection : header file
 *
 */

#ifndef API_PAR_PARPARAMETERSSETCOLLECTIONIMPL_H_
#define API_PAR_PARPARAMETERSSETCOLLECTIONIMPL_H_

#include <map>

#include <boost/shared_ptr.hpp>

#include "PARParametersSetCollection.h"
#include "PARParametersSetImpl.h"

namespace parameters {

/**
 * @class ParametersSetCollection::Impl
 * @brief Parameters set collection interface class
 *
 * ParametersSetCollection objects describe collection parameters' set.
 */
class ParametersSetCollection::Impl : public ParametersSetCollection {
 public:
  /**
   * @brief Default constructor
   */
  Impl();

  /**
   * @brief Default destructor
   */
  virtual ~Impl();

  /**
   * @copydoc ParametersSetCollection::addParametersSet()
   */
  void addParametersSet(boost::shared_ptr<ParametersSet> paramSet, bool force = false);

  /**
   * @copydoc ParametersSetCollection::getParametersSet()
   */
  boost::shared_ptr<ParametersSet> getParametersSet(const std::string& id);

  /**
   * @copydoc ParametersSetCollection::hasParametersSet(const std::string& id)
   */
  bool hasParametersSet(const std::string& id);

  /**
   * @copydoc ParametersSetCollection::cbeginParametersSet()
   */
  parametersSet_const_iterator cbeginParametersSet() const;

  /**
   * @copydoc ParametersSetCollection::cendParametersSet()
   */
  parametersSet_const_iterator cendParametersSet() const;

  /**
   * @copydoc ParametersSetCollection::propagateOriginData()
   */
  void propagateOriginData(const std::string& filepath);

  friend class ParametersSetCollection::BaseIteratorImpl;

 private:
  std::map<std::string, boost::shared_ptr<ParametersSet> > parametersSets_; /**< Map of the parameters set */
};

/**
 * @class ParametersSetCollection::BaseIteratorImpl
 * @brief Implementation class for iterators' functions
 */
class ParametersSetCollection::BaseIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on parameters' set collection. Can create an implementation
   * for an iterator to the beginning of the parameters' set container or to the end.
   *
   * @param iterated Pointer to the parameters' set collection iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the parameters' set container.
   * @returns Created implementation object
   */
  BaseIteratorImpl(const ParametersSetCollection::Impl* iterated, bool begin);

  /**
   * @brief Destructor
   */
  ~BaseIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this parametersSet_const_iterator
   */
  BaseIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this parametersSet_const_iterator
   */
  BaseIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this parametersSet_const_iterator
   */
  BaseIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this parametersSet_const_iterator
   */
  BaseIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const BaseIteratorImpl& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const BaseIteratorImpl& other) const;

  /**
   * @brief Indirection operator
   *
   * @returns Parameter pointed to by this
   */
  const boost::shared_ptr<ParametersSet>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the Parameter pointed to by this
   */
  const boost::shared_ptr<ParametersSet>* operator->() const;

 private:
  std::map<std::string, boost::shared_ptr<ParametersSet> >::const_iterator current_; /**< Hidden map iterator */
};

}  // namespace parameters

#endif  // API_PAR_PARPARAMETERSSETCOLLECTIONIMPL_H_
