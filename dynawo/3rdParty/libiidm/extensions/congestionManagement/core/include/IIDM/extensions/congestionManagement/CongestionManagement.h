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
 * @file IIDM/extensions/congestionManagement/CongestionManagement.h
 * @brief Provides CongestionManagement interface
 */

#ifndef LIBIIDM_EXTENSIONS_CONGESTIONMANAGEMENT_GUARD_CONGESTIONMANAGEMENT_H
#define LIBIIDM_EXTENSIONS_CONGESTIONMANAGEMENT_GUARD_CONGESTIONMANAGEMENT_H

#include <IIDM/Extension.h>
#include <IIDM/cpp11.h>

namespace IIDM {
namespace extensions {
namespace congestion_management {

class CongestionManagementBuilder;

class CongestionManagement : public IIDM::Extension {
public:
  BOOST_TYPE_INDEX_REGISTER_CLASS

  /// clones this CongestionManagement
  IIDM_UNIQUE_PTR<CongestionManagement> clone() const { return IIDM_UNIQUE_PTR<CongestionManagement>(do_clone()); }

protected:
  virtual CongestionManagement* do_clone() const IIDM_OVERRIDE;

private:
  CongestionManagement() {}
  friend class CongestionManagementBuilder;

public:
  bool enabled() const { return m_enabled; }

  CongestionManagement& enabled(bool enabled) { m_enabled = enabled; return *this; }

private:
  bool m_enabled;
};

} // end of namespace IIDM::extensions::congestion_management::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
