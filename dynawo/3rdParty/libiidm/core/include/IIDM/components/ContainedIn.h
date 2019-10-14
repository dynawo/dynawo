//
// Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Libiidm, a library to model IIDM networks and allows
// importing and exporting them to files.
//

/**
 * @file components/ContainedIn.h
 * @brief ContainedIn interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_CONTAINEDIN_H
#define LIBIIDM_COMPONENTS_GUARD_CONTAINEDIN_H


#include <IIDM/cpp11.h>

namespace IIDM {

template <typename T>
class Contains;

/**
 * @brief Base class for object having a parent container.
 * @tparam CRTP_Parent the class of the expected container. CRTP_Parent shall inherit from ContainedIn<CRTP_Parent>
 */
template <typename CRTP_Parent>
class ContainedIn {
public:
  ///alias to the type of the parent
  typedef CRTP_Parent parent_type;

  ///tells if a parent is specified
  bool has_parent() const { return m_parent!=IIDM_NULLPTR; }

  ///gets a reference to the parent
  parent_type const& parent() const { return *m_parent; }

  ///gets a reference to the parent
  parent_type & parent() { return *m_parent; }

private:
  parent_type * m_parent;

private:
  template<typename T>
  friend class IIDM::Contains;

  /**
   * @brief sets the parent of this object
   *
   * shall only be used by parent_type (especially by its add method)
   */
  void setParent(parent_type& p) {m_parent = &p;}

  /**
   * @brief unsets the parent of this object
   *
   * shall only be used by parent_type (especially by its add method)
   */
  void detachFromParent() {m_parent = IIDM_NULLPTR;}

protected:
  ///destructs a ContainedIn. The parent is not deleted.
  ~ContainedIn(){}

  ///constructs a ContainedIn with no parent
  explicit ContainedIn(): m_parent(IIDM_NULLPTR) {}

  ///constructs a copie of a ContainedIn
  explicit ContainedIn(ContainedIn const& other): m_parent(other.m_parent) {}

  ///copies a ContainedIn
  ContainedIn& operator=(ContainedIn const& other) {
    m_parent = other.m_parent;
    return *this;
  }
};

} // end of namespace IIDM::

#endif
