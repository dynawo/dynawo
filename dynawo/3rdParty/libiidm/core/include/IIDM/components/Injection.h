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
 * @file components/Injection.h
 * @brief Injection interface file
 Injection adds p and q (optional) values to each side of a connectable
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_INJECTION_H
#define LIBIIDM_COMPONENTS_GUARD_INJECTION_H

#include <boost/optional.hpp>

#include <IIDM/Export.h>
#include <IIDM/cpp11.h>
#include <IIDM/cpp11_type_traits.h>

#include <IIDM/BasicTypes.h>
#include <IIDM/components/Connectable.h>

namespace IIDM {

namespace builders {
template <typename T, typename CRTP_BUILDER>
class InjectionBuilder;
} // end of namespace IIDM::builders::

/**
 * @brief adds active and reactive power to a one sided connectable.
 * @tparam CRTP_INJECTION the actual type of the inheriter
 */
template <typename CRTP_INJECTION>
class IIDM_EXPORT Injection: public Connectable<CRTP_INJECTION, side_1> {
public:
  typedef CRTP_INJECTION injection_type;
protected:
  ~Injection(){}

private:
  template <typename T, typename CRTP_BUILDER>
  friend class IIDM::builders::InjectionBuilder;
  
  boost::optional<double> m_p;
  boost::optional<double> m_q;

public:
  /** @brief tells if the active power is set. */
  bool has_p() const { return static_cast<bool>(m_p); }

  /** @brief gets the active power.
   * @throws boost::bad_optional_access if not set
   */
  double p() const { return m_p.value(); }

  /** @brief gets the optional active power. */
  boost::optional<double> const& optional_p() const { return m_p; }

  /** @brief sets the active power. */
  injection_type& p(double p) { m_p = p; return static_cast<injection_type&>(*this); }

  /** @brief sets the active power (or unsets if used with boost::none or an empty optional). */
  injection_type& p(boost::optional<double> const& p) { m_p = p; return static_cast<injection_type&>(*this); }


  /** @brief tells if the reactive power is set. */
  bool has_q() const { return static_cast<bool>(m_q); }

  /** @brief gets the reactive power.
   * @throws boost::bad_optional_access if not set
   */
  double q() const { return m_q.value(); }

  /** @brief gets the optional reactive power. */
  boost::optional<double> const& optional_q() const { return m_q; }

  /** @brief sets the reactive power. */
  injection_type& q(side_id side, double q) { m_q = q; return static_cast<injection_type&>(*this); }

  /** @brief sets the reactive power (or unsets if used with boost::none or an empty optional). */
  injection_type& q(boost::optional<double> const& q) { m_q = q; return static_cast<injection_type&>(*this); }
};

/**
 * @brief adds active and reactive power to sides of a Connectable with multiple sides.
 * @tparam CRTP_BRANCH the actual type of the inheriter
 * @tparam Sides the number of side of this Branch
 * @nosubgrouping
 * Branch provides two interfaces to check side validity: at compile time through templates,
 * and at runtime via a side argument
 */
template <typename CRTP_BRANCH, side_id Sides>
class IIDM_EXPORT Branch: public Connectable<CRTP_BRANCH, Sides> {
public:
  typedef CRTP_BRANCH branch_type;

private:
  boost::optional<double> m_p[Sides];
  boost::optional<double> m_q[Sides];

/**
 * @name compile time check interface
 * @{
 */
public:
  /**
   * @brief Tells if the active power is set at the given side.
   * @tparam S the side to inspect.
   *
   * Only available for values of S allowed by Sides.
   * @returns true if the given side as an active power, false otherwise.
   */
  template <side_id S>
#ifndef DOXYGEN_RUNNING
  typename IIDM_ENABLE_IF< S<=Sides, bool>::type
#else
  bool
#endif
  has_p() const { return static_cast<bool>(m_p[S]); }

  /**
   * @brief Gets the active power at the given side.
   * @tparam S the side to inspect.
   *
   * Only available for values of S allowed by Sides.
   * @throws boost::bad_optional_access if no active power is set for the given side.
   * @returns the active power at given side.
   */
  template <side_id S>
#ifndef DOXYGEN_RUNNING
  typename IIDM_ENABLE_IF< S<=Sides, double >::type
#else
  double
#endif
  p() const { return m_p[S].value(); }

  /**
   * @brief Gts the optional active power at the given side.
   * @tparam S the side to inspect.
   *
   * Only available for values of S allowed by Sides.
   * @returns the active power at the given side if set, boost::none otherwise.
   */
  template <side_id S>
#ifndef DOXYGEN_RUNNING
  typename IIDM_ENABLE_IF< S<=Sides, boost::optional<double> const& >::type
#else
  boost::optional<double>
#endif
  optional_p() const { return m_p[S]; }

  /**
   * @brief Sets the active power at the given side.
   * @tparam S the side to alter.
   * @param p value to use.
   *
   * Only available for values of S allowed by Sides.
   * @returns *this
   */
  template <side_id S>
#ifndef DOXYGEN_RUNNING
  typename IIDM_ENABLE_IF< S<=Sides, branch_type&>::type
#else
  branch_type&
#endif
  p(double p) { m_p[S] = p; return static_cast<branch_type&>(*this); }

  /**
   * @brief Sets or unsets the active power at the given side.
   * @tparam S the side to alter.
   * @param p optional value to use. If empty (or boost::none), unsets the active power at given side.
   * Only available for values of S allowed by Sides.
   * @returns *this
   */
  template <side_id S>
#ifndef DOXYGEN_RUNNING
  typename IIDM_ENABLE_IF< S<=Sides, branch_type&>::type
#else
  branch_type&
#endif
  p(boost::optional<double> const& p) { m_p[S] = p; return static_cast<branch_type&>(*this); }




  /**
   * @brief Tells if the arective power is set at the given side.
   * @tparam S the side to inspect.
   *
   * Only available for values of S allowed by Sides.
   * @returns true if the given side as an reactive power, false otherwise.
   */
  template <side_id S>
#ifndef DOXYGEN_RUNNING
  typename IIDM_ENABLE_IF< S<=Sides, bool>::type
#else
  bool
#endif
  has_q() const { return static_cast<bool>(m_q[S]); }

  /**
   * @brief Gets the reactive power at the given side.
   * @tparam S the side to inspect.
   *
   * Only available for values of S allowed by Sides.
   * @throws boost::bad_optional_access if no reactive power is set for the given side.
   * @returns the reactive power at given side.
   */
  template <side_id S>
#ifndef DOXYGEN_RUNNING
  typename IIDM_ENABLE_IF< S<=Sides, double>::type
#else
  double
#endif
  q() const { return m_q[S].value(); }

  /**
   * @brief Gets the optional reactive power at the given side.
   * @tparam S the side to inspect.
   *
   * Only available for values of S allowed by Sides.
   * @returns the reactive power at the given side if set, boost::none otherwise.
   */
  template <side_id S>
#ifndef DOXYGEN_RUNNING
  typename IIDM_ENABLE_IF< S<=Sides, boost::optional<double> const&>::type
#else
  boost::optional<double>
#endif
  optional_q() const { return m_q[S]; }

  /**
   * @brief Sets the reactive power at the given side.
   * @tparam S the side to alter.
   * @param q value to use.
   *
   * Only available for values of S allowed by Sides.
   * @returns *this
   */
  template <side_id S>
#ifndef DOXYGEN_RUNNING
  typename IIDM_ENABLE_IF< S<=Sides, branch_type&>::type
#else
  branch_type&
#endif
  q(double q) { m_q[S] = q; return static_cast<branch_type&>(*this); }

  /**
   * @brief Sets or unsets the reactive power at the given side.
   * @tparam S the side to alter.
   * @param q optional value to use. If empty (or boost::none), unsets the reactive power at given side.
   * Only available for values of S allowed by Sides.
   * @returns *this
   */
  template <side_id S>
#ifndef DOXYGEN_RUNNING
  typename IIDM_ENABLE_IF< S<=Sides, branch_type&>::type
#else
  branch_type&
#endif
  q(boost::optional<double> const& q) { m_q[S] = q; return static_cast<branch_type&>(*this); }

/** @} */

/**
 * @name run time check interface
 * @{
 */
private:
  void check(side_id s) const { if (s>Sides) throw std::range_error("no such a side"); }

public:
  /** @brief Tells if the active power is set at the given side. */
  bool has_p(side_id side) const {
    check(side);
    return static_cast<bool>(m_p[side]);
  }

  /** @brief Gets the active power at the given side.
   * @throws boost::bad_optional_access if not set at the given side.
   */
  double p(side_id side) const {
    check(side);
    return m_p[side].value();
  }

  /** @brief Gets the optional active power at the given side. */
  boost::optional<double> const& optional_p(side_id side) const { return m_p[side]; }

  /** @brief Sets the active power at the given side. */
  branch_type& p(side_id side, double p) {
    check(side);
    m_p[side] = p;
    return static_cast<branch_type&>(*this);
  }

  /**
   * @brief Sets or unsets the active power at the given side.
   * @param side side to alter
   * @param p optional value to use. If empty (or boost::none), unsets the active power at given side.
   * @returns *this
   */
  branch_type& p(side_id side, boost::optional<double> const& p) {
    check(side);
    m_p[side] = p;
    return static_cast<branch_type&>(*this);
  }


  /** @brief Tells if the reactive power is set at the given side. */
  bool has_q(side_id side) const {
    check(side);
    return static_cast<bool>(m_q[side]);
  }

  /** @brief Gets the reactive power at the given side.
   * @throws boost::bad_optional_access if not set at the given side.
   */
  double q(side_id side) const {
    check(side);
    return m_q[side].value();
  }

  /** @brief Gets the optional reactive power at the given side. */
  boost::optional<double> const& optional_q(side_id side) const { return m_q[side]; }

  /** @brief Sets the reactive power at the given side. */
  branch_type& q(side_id side, double q) {
    check(side);
    m_q[side] = q;
    return static_cast<branch_type&>(*this);
  }

  /**
   * @brief Sets or unsets the reactive power at the given side.
   * @param side side to alter
   * @param q optional value to use. If empty (or boost::none), unsets the reactive power at given side.
   * @returns *this
   */
  branch_type& q(side_id side, boost::optional<double> const& q) {
    check(side);
    m_q[side] = q;
    return static_cast<branch_type&>(*this);
  }
/** @} */
};

} // end of namespace IIDM

#endif

