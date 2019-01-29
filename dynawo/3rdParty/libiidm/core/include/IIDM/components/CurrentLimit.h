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
 * @file components/CurrentLimit.h
 * @brief CurrentLimit interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_CURRENTLIMIT_H
#define LIBIIDM_COMPONENTS_GUARD_CURRENTLIMIT_H

#include <vector>
#include <string>

#include <boost/optional.hpp>

#include <IIDM/Export.h>
#include <IIDM/cpp11.h>

#include <IIDM/components/Identifiable.h>


namespace IIDM {

/**
 * @brief a temporary limit in a current limits specification.
 */
struct IIDM_EXPORT CurrentLimit {
  std::string name;

  boost::optional<double> value;///<limit value
  boost::optional<int> acceptableDuration;///<acceptable duration for this limit
  boost::optional<bool> fictitious;

  CurrentLimit(std::string const& name);

  CurrentLimit(std::string const& name, boost::optional<double> const& value, boost::optional<int> const& acceptableDuration, boost::optional<bool> const& fictitious = boost::none);
};

/**
 * @brief a current limits specification.
 */
class IIDM_EXPORT CurrentLimits {
private:
  typedef std::vector<CurrentLimit> temporary_limits_type;
public:
  ///iterator over limit. outputs CurrentLimit
  typedef temporary_limits_type::const_iterator const_iterator;

  /**
   * @brief Constructs a current limits specification.
   * @param permanent_limit optional value for a permanent limit. If empty, this specification does not provides a permanent limit
   */
  explicit CurrentLimits(boost::optional<double> const& permanent_limit);

  ///Adds a temporary limit
  CurrentLimits& add(CurrentLimit const&);
  ///Adds a temporary limit
  CurrentLimits& add(std::string const& name, double value, int acceptableDuration);
  ///Adds a temporary limit
  CurrentLimits& add(std::string const& name, boost::optional<double> const& value, boost::optional<int> const& acceptableDuration, boost::optional<bool> const& fictitious = boost::none);

  ///Gets an iterator to the first of the temporary limits
  const_iterator begin() const { return m_temporary_limits.begin(); }

  ///Gets an iterator to the end of the temporary limits
  const_iterator end() const { return m_temporary_limits.end(); }


  /**
   * @brief Tells if the permanent limit is set.
   * @returns true if permanent limit is set, false otherwise.
   */
  bool has_permanent_limit() const { return static_cast<bool>(m_permanent_limit); }

  /**
   * @brief Gets the permanent limit.
   * @throws boost::bad_optional_access if no permanent limit is set.
   * @returns the permanent limit.
   */
  double permanent_limit() const { return m_permanent_limit.value(); }

  /**
   * @brief Gets the optional permanent limit.
   * @returns the permanent limit if set, boost::none otherwise.
   */
  boost::optional<double> const& optional_permanent_limit() const { return m_permanent_limit; }

  /**
   * @brief Sets the permanent limit.
   * @param l value to use.
   *
   * @returns *this
   */
  CurrentLimits& permanent_limit(double l) { m_permanent_limit = l; return *this; }

  /**
   * @brief Sets or unsets the permanent limit at the given side.
   * @param l optional value to use. If empty (or boost::none), unsets the permanent limit at given side.
   * @returns *this
   */
  CurrentLimits& permanent_limit(boost::optional<double> const& l) { m_permanent_limit = l; return *this; }

private:
  temporary_limits_type m_temporary_limits;
  boost::optional<double> m_permanent_limit;
};

} // end of namespace IIDM::

#endif
