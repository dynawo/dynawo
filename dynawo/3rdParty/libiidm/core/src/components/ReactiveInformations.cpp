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
 * @file components/ReactiveInformations.cpp
 * @brief ReactiveInformations implementation file
 */

#include <IIDM/components/ReactiveInformations.h>

namespace IIDM {

ReactiveCapabilityCurve& ReactiveCapabilityCurve::add(point const& p) {
#if __cplusplus < 201103L
  m_points.push_back(p);
#else
  m_points.emplace_back(p);
#endif
  return *this;
}


ReactiveCapabilityCurve& ReactiveCapabilityCurve::add(double p, double qmin, double qmax) {
#if __cplusplus < 201103L
  m_points.push_back(point(p, qmin, qmax));
#else
  m_points.emplace_back(p, qmin, qmax);
#endif
  return *this;
}

} // end of namespace IIDM::
