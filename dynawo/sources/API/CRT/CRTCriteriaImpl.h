//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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

#ifndef API_CRT_CRTCRITERIAIMPL_H_
#define API_CRT_CRTCRITERIAIMPL_H_

#include <string>
#include <vector>

#include "CRTCriteria.h"
#include "CRTCriteriaParams.h"

namespace criteria {

/**
 * @class Criteria::Impl
 * @brief Criteria implementation class
 *
 * Interface class for criteria object.
 */
class Criteria::Impl : public Criteria {
 public:
  /**
   * @brief Destructor
   */
  ~Impl() { }

  /**
   * @copydoc Criteria::setParams(const boost::shared_ptr<CriteriaParams>& params)
   */
  void setParams(const boost::shared_ptr<CriteriaParams>& params);

  /**
   * @copydoc Criteria::getParams() const
   */
  const boost::shared_ptr<CriteriaParams>& getParams() const;

  /**
   * @copydoc Criteria::addComponentId(const std::string& id, const std::string& voltageLevelId = "")
   */
  void addComponentId(const std::string& id, const std::string& voltageLevelId = "");

  /**
   * @copydoc Criteria::begin() const
   */
  component_id_const_iterator begin() const;

  /**
   * @copydoc Criteria::end() const
   */
  component_id_const_iterator end() const;
  friend class Criteria::BaseCompIdConstIteratorImpl;

 protected:
  boost::shared_ptr<CriteriaParams> params_;              ///< parameters of this criteria
  std::vector<boost::shared_ptr<ComponentId> > compIds_;  ///< ids of the components
};

/**
 * @class Criteria::BaseCompIdConstIteratorImpl
 * @brief Implementation class for iterators' functions
 */
class Criteria::BaseCompIdConstIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Can create a constant iterator to the
   * beginning of the component ids container or to the end.
   *
   * @param iterated Pointer to the component ids iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the container.
   */
  BaseCompIdConstIteratorImpl(const Criteria::Impl* iterated, bool begin);

  /**
   * @brief Destructor
   */
  ~BaseCompIdConstIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this const_iterator
   */
  BaseCompIdConstIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this const_iterator
   */
  BaseCompIdConstIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this const_iterator
   */
  BaseCompIdConstIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this const_iterator
   */
  BaseCompIdConstIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const BaseCompIdConstIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const BaseCompIdConstIteratorImpl& other)const;

  /**
   * @brief Indirection operator
   *
   * @returns id pointed to by this
   */
  const ComponentId& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the id pointed to by this
   */
  const ComponentId* operator->() const;

 private:
  std::vector<boost::shared_ptr<ComponentId> >::const_iterator current_;  ///< current vector const iterator
};
}  // namespace criteria

#endif  // API_CRT_CRTCRITERIAIMPL_H_
