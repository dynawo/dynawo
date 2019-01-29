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
 * @file IIDM/extensions/remotemeasurements/RemoteMeasurements.h
 * @brief Provides RemoteMeasurements interface
 */

#ifndef LIBIIDM_EXTENSIONS_REMOTEMEASUREMENTS_GUARD_REMOTEMEASUREMENTS_H
#define LIBIIDM_EXTENSIONS_REMOTEMEASUREMENTS_GUARD_REMOTEMEASUREMENTS_H

#include <boost/optional.hpp>

#include <IIDM/Extension.h>
#include <IIDM/cpp11.h>
#include <vector>

namespace IIDM {
namespace extensions {
namespace remotemeasurements {

class RemoteMeasurementsBuilder;

class RemoteMeasurements : public IIDM::Extension {
public:
  BOOST_TYPE_INDEX_REGISTER_CLASS

  /// clones this RemoteMeasurements
  IIDM_UNIQUE_PTR<RemoteMeasurements> clone() const { return IIDM_UNIQUE_PTR<RemoteMeasurements>(do_clone()); }

protected:
  virtual RemoteMeasurements* do_clone() const IIDM_OVERRIDE;

private :
  RemoteMeasurements(){}
  friend class RemoteMeasurementsBuilder;

public:
  class RemoteMeasurement
  {
    public :
      RemoteMeasurement( float value, float standardDeviation, bool valid, bool masked, bool critical)
    : m_value(value),
      m_standardDeviation(standardDeviation),
      m_valid(valid),
      m_masked(masked),
      m_critical(critical)
      {}

      float value() const { return m_value; }
      float standardDeviation() const { return m_standardDeviation; }
      bool valid() const { return m_valid; }
      bool masked() const { return m_masked; }
      bool critical() const { return m_critical; }

      RemoteMeasurement& value(float value) { m_value = value; return *this; }
      RemoteMeasurement& standardDeviation(float standardDeviation) { m_standardDeviation = standardDeviation; return *this; }
      RemoteMeasurement& valid(bool valid) { m_valid = valid; return *this; }
      RemoteMeasurement& masked(bool masked) { m_masked = masked; return *this; }
      RemoteMeasurement& critical(bool critical) { m_critical = critical; return *this; }

    private :
      float m_value;                //remote measurement value
      float m_standardDeviation;    //remote measurement standard deviation
      bool m_valid;                 //remote measurement validity
      bool m_masked;                //remote measurement visibility
      bool m_critical;              //remote measurement criticity
  };


  class TapPosition {
    public:
      TapPosition(int position): m_position(position) {}

      int position() const { return m_position;}
      TapPosition& position(int position) { m_position = position; return *this; }

    private:
      int m_position;
  };

  // ouvrage possedant 2 telemesures
  boost::optional<RemoteMeasurement> const& p() const { return m_p; }
  RemoteMeasurements& p(boost::optional<RemoteMeasurement> const& rm) { m_p = rm; return *this; }

  boost::optional<RemoteMeasurement> const& q() const { return m_q; }
  RemoteMeasurements& q(boost::optional<RemoteMeasurement> const& rm) { m_q = rm; return *this; }

  // ouvrage ayant 4 telemesures
  boost::optional<RemoteMeasurement> const& p1() const { return m_p1; }
  RemoteMeasurements& p1(boost::optional<RemoteMeasurement> const& rm) { m_p1 = rm; return *this; }

  boost::optional<RemoteMeasurement> const& q1() const { return m_q1; }
  RemoteMeasurements& q1(boost::optional<RemoteMeasurement> const& rm) { m_q1 = rm; return *this; }

  boost::optional<RemoteMeasurement> const& p2() const { return m_p2; }
  RemoteMeasurements& p2(boost::optional<RemoteMeasurement> const& rm) { m_p2 = rm; return *this; }

  boost::optional<RemoteMeasurement> const& q2() const { return m_q2; }
  RemoteMeasurements& q2(boost::optional<RemoteMeasurement> const& rm) { m_q2 = rm; return *this; }

  // for busbarsection
  boost::optional<RemoteMeasurement> const& v() const { return m_v; }
  RemoteMeasurements& v(boost::optional<RemoteMeasurement> const& rm) { m_v = rm; return *this; }

  // tapPosition
  boost::optional<TapPosition> const & tapPosition() const {return m_tapPosition;}
  RemoteMeasurements& tapPosition (boost::optional<TapPosition> const & tp){m_tapPosition = tp; return *this; }

private:
  boost::optional<RemoteMeasurement> m_p;
  boost::optional<RemoteMeasurement> m_q;
  boost::optional<RemoteMeasurement> m_p1;
  boost::optional<RemoteMeasurement> m_q1;
  boost::optional<RemoteMeasurement> m_p2;
  boost::optional<RemoteMeasurement> m_q2;
  boost::optional<RemoteMeasurement> m_v;
  boost::optional<TapPosition> m_tapPosition;
};

} // end of namespace IIDM::extensions::remotemeasurements::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
