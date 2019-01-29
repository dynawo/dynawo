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
 * @file IIDM/extensions/connectablePosition/ConnectablePosition.h
 * @brief Provides ConnectablePosition interface
 */

#ifndef LIBIIDM_EXTENSIONS_CONNECTABLEPOSITION_GUARD_CONNECTABLEPOSITION_H
#define LIBIIDM_EXTENSIONS_CONNECTABLEPOSITION_GUARD_CONNECTABLEPOSITION_H

#include <boost/optional.hpp>

#include <IIDM/Extension.h>
#include <IIDM/cpp11.h>

namespace IIDM {
namespace extensions {
namespace connectable_position {

class ConnectablePositionBuilder;

class ConnectablePosition : public IIDM::Extension {
public:
  BOOST_TYPE_INDEX_REGISTER_CLASS

  /// clones this ConnectablePosition
  IIDM_UNIQUE_PTR<ConnectablePosition> clone() const { return IIDM_UNIQUE_PTR<ConnectablePosition>(do_clone()); }
  
protected:
  virtual ConnectablePosition* do_clone() const IIDM_OVERRIDE;

private:
  ConnectablePosition() {}
  friend class ConnectablePositionBuilder;

public:
  class Feeder {
  public:
      enum Direction {
          TOP,
          BOTTOM,
          UNDEFINED
      };

      Feeder(const std::string& name, int order, Direction direction)
      : m_name(name),
        m_order(order),
        m_direction(direction) {
    }

    std::string name() const { return m_name; }

    Feeder& name(const std::string& name) { m_name = name; return *this; }

    int order() const { return m_order; }

    Feeder& order(int order) { m_order = order; return *this; }

    Direction direction() const { return m_direction; }

    Feeder& direction(Direction direction) { m_direction = direction; return *this; }

  private:
    std::string m_name;
    int m_order;
    Direction m_direction;
  };

  boost::optional<Feeder> const& feeder() const { return m_feeder; }
  ConnectablePosition& feeder(boost::optional<Feeder> const& feeder) { m_feeder = feeder; return *this; }

  boost::optional<Feeder> const& feeder1() const { return m_feeder1; }
  ConnectablePosition& feeder1(boost::optional<Feeder> const& feeder1) { m_feeder1 = feeder1; return *this; }

  boost::optional<Feeder> const& feeder2() const { return m_feeder2; }
  ConnectablePosition& feeder2(boost::optional<Feeder> const& feeder2) { m_feeder2 = feeder2; return *this; }

  boost::optional<Feeder> const& feeder3() const { return m_feeder3; }
  ConnectablePosition& feeder3(boost::optional<Feeder> const& feeder3) { m_feeder3 = feeder3; return *this; }

private:
  boost::optional<Feeder> m_feeder;
  boost::optional<Feeder> m_feeder1;
  boost::optional<Feeder> m_feeder2;
  boost::optional<Feeder> m_feeder3;
};

} // end of namespace IIDM::extensions::connectable_position::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
