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
 * @file IIDM/extensions/activeSeason/ActiveSeason.h
 * @brief Provides ActiveSeason interface
 */

#ifndef LIBIIDM_EXTENSIONS_ACTIVESEASON_GUARD_ACTIVESEASON_H
#define LIBIIDM_EXTENSIONS_ACTIVESEASON_GUARD_ACTIVESEASON_H

#include <IIDM/Extension.h>
#include <IIDM/cpp11.h>

#include <string>

namespace IIDM {
namespace extensions {
namespace activeseason {

class ActiveSeason : public IIDM::Extension {
public:
  BOOST_TYPE_INDEX_REGISTER_CLASS

  explicit ActiveSeason(std::string const& value): m_value(value) {}

  std::string const& value() const { return m_value; }
  ActiveSeason& value(std::string const& v) { m_value = v; return *this; }

  
public:
  IIDM_UNIQUE_PTR<ActiveSeason> clone() const { return IIDM_UNIQUE_PTR<ActiveSeason>(do_clone()); }
  
protected:
  virtual ActiveSeason* do_clone() const IIDM_OVERRIDE;

private:
  std::string m_value;
};

} // end of namespace IIDM::extensions::activeseason::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
