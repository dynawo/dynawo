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
 * @file components/ReactiveInformations.h
 * @brief MinMaxReactiveLimits and ReactiveCapabilityCurve interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_REACTIVEINFORMATIONS_H
#define LIBIIDM_COMPONENTS_GUARD_REACTIVEINFORMATIONS_H

#include <vector>

#include <IIDM/Export.h>

namespace IIDM {

class IIDM_EXPORT MinMaxReactiveLimits {
public:
  MinMaxReactiveLimits(double min, double max): m_min(min), m_max(max) {}

  double min() const { return m_min; }
  double max() const { return m_max; }

private:
  double m_min, m_max;
};

class IIDM_EXPORT ReactiveCapabilityCurve {
public:
  struct point {
    double p, qmin, qmax;
    point(double p, double qmin, double qmax): p(p), qmin(qmin), qmax(qmax) {}
  };

private:
  typedef std::vector<point> points_type;
  points_type m_points;

public:
  typedef points_type::const_iterator const_iterator;

  ReactiveCapabilityCurve(){}
  ReactiveCapabilityCurve(point const& p) {add(p);}
  ReactiveCapabilityCurve(double p, double qmin, double qmax) { add(p, qmin, qmax); }

  ReactiveCapabilityCurve& add(point const&);
  ReactiveCapabilityCurve& add(double p, double qmin, double qmax);

  ReactiveCapabilityCurve& operator() (point const& p) { return add(p); }
  ReactiveCapabilityCurve& operator() (double p, double qmin, double qmax) { return add(point(p, qmin, qmax)); }

  points_type::size_type size() const { return m_points.size(); }

  point const& operator[](points_type::size_type n) const { return m_points[n]; }

  const_iterator begin() const { return m_points.begin(); }
  const_iterator end  () const { return m_points.end  (); }
};

} // end of namespace IIDM::

#endif
