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
 * @file components/CurrentLimit.cpp
 * @brief CurrentLimit implementation file
 */

#include <IIDM/components/CurrentLimit.h>

namespace IIDM {


CurrentLimit::CurrentLimit(std::string const& name):
  name(name),
  value(boost::none),
  acceptableDuration(boost::none),
  fictitious(boost::none)
{}


CurrentLimit::CurrentLimit(
  std::string const& name,
  boost::optional<double> const& value,
  boost::optional<int> const& acceptableDuration,
  boost::optional<bool> const& fictitious
):
  name(name),
  value(value),
  acceptableDuration(acceptableDuration),
  fictitious(fictitious)
{}






CurrentLimits::CurrentLimits(boost::optional<double> const& permanent_limit): m_permanent_limit(permanent_limit) {}

CurrentLimits& CurrentLimits::add(CurrentLimit const& l) {
  m_temporary_limits.push_back(l);
  return *this;
}

CurrentLimits& CurrentLimits::add(std::string const& name, double value, int acceptableDuration) {
#if __cplusplus < 201103L
  CurrentLimit l(name, value, acceptableDuration);
  m_temporary_limits.push_back(l);
#else
  m_temporary_limits.emplace_back(name, value, acceptableDuration);
#endif
  return *this;
}

CurrentLimits& CurrentLimits::add(
  std::string const& name,
  boost::optional<double> const& value,
  boost::optional<int> const& acceptableDuration,
  boost::optional<bool> const& fictitious
) {
#if __cplusplus < 201103L
  m_temporary_limits.push_back( CurrentLimit(name, value, acceptableDuration, fictitious) );
#else
  m_temporary_limits.emplace_back(name, value, acceptableDuration, fictitious);
#endif
  return *this;
}

} // end of namespace IIDM::
