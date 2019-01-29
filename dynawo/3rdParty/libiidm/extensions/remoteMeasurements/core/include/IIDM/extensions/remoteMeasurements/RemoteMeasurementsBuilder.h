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

/*
 * @file IIDM/extensions/remotemeasurements/TelemeasuresBuilder.h
 * @brief Provides remotemeasurements interface
 */

#ifndef LIBIIDM_EXTENSIONS_REMOTEMEASUREMENTS_GUARD_REMOTEMEASUREMENTS_BUILDER_H
#define LIBIIDM_EXTENSIONS_REMOTEMEASUREMENTS_GUARD_REMOTEMEASUREMENTS_BUILDER_H

#include <IIDM/builders/builders_utils.h>
#include <IIDM/extensions/remoteMeasurements/RemoteMeasurements.h>
#include <IIDM/cpp11.h>

namespace IIDM {
namespace extensions {
namespace remotemeasurements {

class RemoteMeasurementsBuilder {
public:
  typedef RemoteMeasurements builded_type;
  typedef RemoteMeasurementsBuilder builder_type;

  MACRO_IIDM_BUILDER_PROPERTY(builder_type, boost::optional<RemoteMeasurements::RemoteMeasurement>, p)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, boost::optional<RemoteMeasurements::RemoteMeasurement>, q)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, boost::optional<RemoteMeasurements::RemoteMeasurement>, p1)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, boost::optional<RemoteMeasurements::RemoteMeasurement>, q1)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, boost::optional<RemoteMeasurements::RemoteMeasurement>, p2)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, boost::optional<RemoteMeasurements::RemoteMeasurement>, q2)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, boost::optional<RemoteMeasurements::RemoteMeasurement>, v)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, boost::optional<RemoteMeasurements::TapPosition>, tapPosition)

  RemoteMeasurements build() const;
};

}
}
}

#endif /* EXTENSIONS_REMOTEMEASUREMENTS_CORE_INCLUDE_IIDM_EXTENSIONS_REMOTEMEASUREMENTS_REMOTEMEASUREMENTSBUILDER_H_ */
