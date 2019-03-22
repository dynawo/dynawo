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
 * @file xml/import/ConnectableHandler.h
 * @brief ConnectableHandler interface file
 */

#ifndef LIBIIDM_XML_IMPORT_GUARD_CONNECTABLEHANDLER_H
#define LIBIIDM_XML_IMPORT_GUARD_CONNECTABLEHANDLER_H

#include <IIDM/xml/import/IdentifiableHandler.h>

#include <xml/sax/parser/ComposableElementHandler.h>

#include <boost/optional.hpp>

#include <IIDM/BasicTypes.h>
#include <IIDM/components/Connection.h>

#include <xml/sax/parser/Attributes.h>

#include <IIDM/cpp11_type_traits.h>
#include <IIDM/cpp11.h>



namespace IIDM {
namespace xml {

boost::optional<IIDM::Connection> connection(::xml::sax::parser::Attributes const& s, IIDM::side_id side, bool withVoltageLevel);


template <typename Builder, bool WithVoltageLevel, IIDM::side_id Sides>
class ConnectableHandler: public IdentifiableHandler<Builder> {
public:
  typedef typename IdentifiableHandler<Builder>::attributes_type attributes_type;
  typedef typename IdentifiableHandler<Builder>::elementName_type elementName_type;

private:
  typedef ConnectableHandler<Builder, WithVoltageLevel, Sides> self_type;

  boost::optional<IIDM::Connection> connections[1+Sides];

public:
  ConnectableHandler(elementName_type const& root_element): IdentifiableHandler<Builder>(root_element) {}

  bool allow_connection_at(IIDM::side_id i) const { return i<=Sides; }

  boost::optional<IIDM::Connection> at(IIDM::side_id i) const {
    return allow_connection_at(i) ? connections[i] : boost::none;
  }

  ConnectableHandler& connect(IIDM::side_id i, boost::optional<IIDM::Connection> const& c) {
    if (allow_connection_at(i)) connections[i] = c;
    return *this;
  }

  ConnectableHandler& disconnect(IIDM::side_id i) {
    if (allow_connection_at(i)) connections[i] = boost::none;
    return *this;
  }

protected:
  //called when opening the block's root element
  //inheriter override shall call its parent's one.
  virtual void configure(attributes_type const& attributes) IIDM_OVERRIDE {
    IdentifiableHandler<Builder>::configure(attributes);

    if (Sides == IIDM::side_1) {
      connect( IIDM::side_1, connection(attributes, IIDM::side_end, WithVoltageLevel));
    } else {
      connect( IIDM::side_1, connection(attributes, IIDM::side_1, WithVoltageLevel));
      connect( IIDM::side_2, connection(attributes, IIDM::side_2, WithVoltageLevel));
      connect( IIDM::side_3, connection(attributes, IIDM::side_3, WithVoltageLevel));
    }
  }
};

} // end of namespace IIDM::xml::
} // end of namespace IIDM::

#endif
