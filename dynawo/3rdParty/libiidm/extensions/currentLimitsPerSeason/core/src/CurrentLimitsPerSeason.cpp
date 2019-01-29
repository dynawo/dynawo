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


#include <IIDM/extensions/currentLimitsPerSeason/CurrentLimitsPerSeason.h>


namespace IIDM {
namespace extensions {
namespace currentlimitsperseason {

// **************** class CurrentLimitsPerSeason **************** //

CurrentLimitsPerSeason* CurrentLimitsPerSeason::do_clone() const {
  return new CurrentLimitsPerSeason(*this);
}


CurrentLimitsPerSeason& CurrentLimitsPerSeason::set(season const& s) {
  if (m_seasons.insert( seasons_type::value_type(s.name(), s) ).second == false) {
    throw std::runtime_error("season already defined: "+s.name());
  }
  return *this;
}


// ************ class CurrentLimitsPerSeason::season ************ //

CurrentLimitsPerSeason::season::season(season_name name, bool single_sided):
  m_name(name), m_single_sided(single_sided)
{}

CurrentLimitsPerSeason::season::season(season_name name, IIDM::CurrentLimits const& limits):
  m_name(name), m_single_sided(true)
{
  m_limits.insert(limits_type::value_type(IIDM::side_1, limits));
}


CurrentLimitsPerSeason::season&
CurrentLimitsPerSeason::season::set(IIDM::side_id side, IIDM::CurrentLimits const& limits) {
  if (m_single_sided && side != IIDM::side_1) {
    throw std::range_error("only side 1 is available on this season");
  }
  
  std::pair<limits_type::iterator, bool> insertion = m_limits.insert(limits_type::value_type(side, limits));
  if (!insertion.second) {
    insertion.first->second = limits;
  }
  
  return *this;
}



} // end of namespace IIDM::extensions::currentlimitsperseason::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::
