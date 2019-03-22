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
 * @file IIDM/extensions/loadDetail/LoadDetailBuilder.h
 * @brief Provides LoadDetail interface
 */

#ifndef LIBIIDM_EXTENSIONS_LOADDETAIL_GUARD_LOADDETAIL_BUILDER_H
#define LIBIIDM_EXTENSIONS_LOADDETAIL_GUARD_LOADDETAIL_BUILDER_H

#include <IIDM/builders/builders_utils.h>
#include <IIDM/extensions/loadDetail/LoadDetail.h>
#include <IIDM/cpp11.h>

namespace IIDM {
namespace extensions {
namespace load_detail {

class LoadDetailBuilder {
public:
  typedef LoadDetail builded_type;
  typedef LoadDetailBuilder builder_type;

  LoadDetail build() const;

  MACRO_IIDM_BUILDER_PROPERTY(builder_type, float, fixedActivePower)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, float, fixedReactivePower)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, float, variableActivePower)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, float, variableReactivePower)
};

} // end of namespace IIDM::extensions::load_detail::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
