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
 * @file IIDM/extensions/currentLimitsPerSeason/CurrentLimitsPerSeason.h
 * @brief Provides Extension interface
 */

#ifndef LIBIIDM_EXTENSIONS_CURRENTLIMITSPERSEASON_GUARD_CURRENTLIMITSPERSEASON_H
#define LIBIIDM_EXTENSIONS_CURRENTLIMITSPERSEASON_GUARD_CURRENTLIMITSPERSEASON_H

#include <IIDM/Extension.h>
#include <IIDM/cpp11.h>

#include <IIDM/components/CurrentLimit.h>

#include <string>
#include <IIDM/utils/maps.h>

namespace IIDM {
namespace extensions {
namespace currentlimitsperseason {

class CurrentLimitsPerSeason : public IIDM::Extension {
// ****** Extension content ****** //
public:
  BOOST_TYPE_INDEX_REGISTER_CLASS

  IIDM_UNIQUE_PTR<CurrentLimitsPerSeason> clone() const { return IIDM_UNIQUE_PTR<CurrentLimitsPerSeason>(do_clone()); }

protected:
  virtual CurrentLimitsPerSeason* do_clone() const IIDM_OVERRIDE;

// ****** concrete content ****** //
public:
  typedef std::string season_name;

  class season {
  private:
    season_name m_name;
    typedef std::map<IIDM::side_id, IIDM::CurrentLimits> limits_type;
    limits_type m_limits;
    bool m_single_sided;

  public:
    /**
     * @param name the name of this season
     * @param single_sided true if the xml shall contain currentLimits, false if there should be currentLimits<N>
     */
    explicit season(season_name name, bool single_sided = false);

    /**
     * constructs a single sided season
     * @param name the name of this season
     * @param limits the limits used on the only side available.
     */
    season(season_name name, IIDM::CurrentLimits const& limits);


    season_name const& name() const { return m_name; }

    /**
     * @brief tells if this season is relative to a single sided component, such as a DanglingLine
     * @returns true if the xml shall contain currentLimits, false if there should be currentLimits<N>
     */
    bool single_sided() const { return m_single_sided; }

    bool exists(IIDM::side_id side) const { return m_limits.count(side)!=0; }

    IIDM::CurrentLimits const& get(IIDM::side_id side) const { return map_get(m_limits, side); }

    IIDM::CurrentLimits const* find(IIDM::side_id side) const { return map_find(m_limits, side); }


    season& set(IIDM::side_id side, IIDM::CurrentLimits const& );

    IIDM::CurrentLimits & get(IIDM::side_id side) { return map_get(m_limits, side); }

    IIDM::CurrentLimits * find(IIDM::side_id side) { return map_find(m_limits, side); }

  };

private:
  typedef std::map<season_name, season> seasons_type;

  seasons_type m_seasons;

public:
  bool exists(season_name const& season) const { return m_seasons.count(season)!=0; }

  season const& get(season_name const& name) const { return map_get(m_seasons, name); }
  season & get(season_name const& name) { return map_get(m_seasons, name); }

  season const* find(season_name const& name) const { return map_find(m_seasons, name); }
  season * find(season_name const& name) { return map_find(m_seasons, name); }

  //season names must be unique, throws on error.
  CurrentLimitsPerSeason& set(season const& s);

  typedef IIDM::map_value_iterator_adapter<seasons_type::const_iterator> season_const_iterator;

  season_const_iterator begin() const { return season_const_iterator(m_seasons.begin()); }
  season_const_iterator end() const { return season_const_iterator(m_seasons.end()); }
};

} // end of namespace IIDM::extensions::currentlimitsperseason::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
