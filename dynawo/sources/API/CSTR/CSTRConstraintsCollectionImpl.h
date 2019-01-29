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
 * @file  CSTRConstraintsCollectionImpl.h
 *
 * @brief Dynawo constraints : header file
 *
 */

#ifndef API_CSTR_CSTRCONSTRAINTSCOLLECTIONIMPL_H_
#define API_CSTR_CSTRCONSTRAINTSCOLLECTIONIMPL_H_

#include <vector>
#include <map>
#include <boost/shared_ptr.hpp>

#include "CSTRConstraintsCollection.h"

namespace constraints {
class Constraint;

/**
 * @class ConstraintsCollection::Impl
 * @brief ConstraintsCollection implemented class
 *
 * Implementation of ContraintsCollection interface class
 */
class ConstraintsCollection::Impl : public ConstraintsCollection {
 public:
  /**
   * @brief constructor
   *
   * @param id ConstraintsCollection's id
   */
  explicit Impl(const std::string& id);

  /**
   * @brief Destructor
   */
  virtual ~Impl();

  /**
   * @copydoc ConstraintsCollection::addConstraint(const std::string& modelName, const std::string& description, const double& time, Type_t type)
   */
  void addConstraint(const std::string& modelName, const std::string& description, const double& time, Type_t type);

  /**
   * @copydoc ConstraintsCollection::cbegin()
   */
  virtual const_iterator cbegin() const;

  /**
   * @copydoc ConstraintsCollection::cend()
   */
  virtual const_iterator cend() const;

  /**
   */
  friend class ConstraintsCollection::BaseIteratorImpl;

 private:
  /**
   * @brief Constructor
   */
#ifdef LANG_CXX11
  Impl() = delete;
#else
  Impl();
#endif

  std::string id_;  ///< ConstraintCollection's id
  std::map<std::string, std::vector<boost::shared_ptr<Constraint> > >constraintsByModel_;  ///< constraint sorted by model
  std::map<std::string, boost::shared_ptr<Constraint > >constraintsById_;  ///< constraint sorted by id
};

/**
 * @class ConstraintsCollection::BaseIteratorImpl
 * @brief Implementation class for iterators' functions
 */
class ConstraintsCollection::BaseIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on ConstraintsCollection. Can create an implementation for
   * an iterator to the beginning of the constraints' container or to the end.
   *
   * @param iterated Pointer to the constraints' map iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the constraints' container.
   * @returns Created implementation object
   */
  BaseIteratorImpl(const ConstraintsCollection::Impl* iterated, bool begin);

  /**
   * @brief Destructor
   */
  ~BaseIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this const_iterator
   */
  BaseIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this const_iterator
   */
  BaseIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this const_iterator
   */
  BaseIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this const_iterator
   */
  BaseIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const BaseIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const BaseIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns Constraint pointed to by this
   */
  const boost::shared_ptr<Constraint>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the Constraint pointed to by this
   */
  const boost::shared_ptr<Constraint>* operator->() const;

 private:
  std::map<std::string, boost::shared_ptr<Constraint> >::const_iterator current_;  ///< current map iterator
};

}  // namespace constraints

#endif  // API_CSTR_CSTRCONSTRAINTSCOLLECTIONIMPL_H_
