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
 * @file xml/import/ContainerHandler.h
 * @brief Provides the ContainerHandler base class
 */

#ifndef LIBIIDM_XML_IMPORT_GUARD_CONTAINERHANDLER_H
#define LIBIIDM_XML_IMPORT_GUARD_CONTAINERHANDLER_H

#include <IIDM/xml/import/IdentifiableHandler.h>
#include <IIDM/xml/import/ConnectableHandler.h>

#include <IIDM/BasicTypes.h>
#include <IIDM/components/Connection.h>
#include <IIDM/cpp11_type_traits.h>

#include <boost/optional.hpp>
#include <string>

namespace IIDM {
namespace xml {

/**
 * @brief base Handler class for container components, such as VoltageLevel and Substation.
 */
template <typename Builder>
class ContainerHandler: public IdentifiableHandler<Builder> {
public:
  typedef typename IdentifiableHandler<Builder>::builded_type builded_type;
  typedef typename IdentifiableHandler<Builder>::elementName_type elementName_type;
  typedef typename IdentifiableHandler<Builder>::attributes_type attributes_type;
  typedef typename IdentifiableHandler<Builder>::path_type path_type;
  
  explicit ContainerHandler(elementName_type const& root_element):
    IdentifiableHandler<Builder>(root_element)
  {}
  
  builded_type const& get() const {
    if (!m_builded) m_builded = this->build();
    return *m_builded;
  }

  builded_type & get() {
    if (!m_builded) m_builded = this->build();
    return *m_builded;
  }

protected:
  template <typename B, bool with_voltageLevel, IIDM::side_id Sides>
  typename IIDM_ENABLE_IF<Sides == IIDM::side_1>::type
  add_connectable(ConnectableHandler<B, with_voltageLevel, IIDM::side_1> const& handler) {
    m_builded->add( handler.build(), handler.at(IIDM::side_1) );
  }
  
  template <typename B, bool with_voltageLevel, IIDM::side_id Sides>
  typename IIDM_ENABLE_IF<Sides == IIDM::side_2>::type
  add_connectable(ConnectableHandler<B, with_voltageLevel, IIDM::side_2> const& handler) {
    m_builded->add( handler.build(), handler.at(IIDM::side_1), handler.at(IIDM::side_2) );
  }
  
  template <typename B, bool with_voltageLevel, IIDM::side_id Sides>
  typename IIDM_ENABLE_IF<Sides == IIDM::side_3>::type
  add_connectable(ConnectableHandler<B, with_voltageLevel, IIDM::side_3> const& handler) {
    m_builded->add( handler.build(), handler.at(IIDM::side_1), handler.at(IIDM::side_2), handler.at(IIDM::side_3) );
  }
  
  template <typename H>
  void add(H const& handler) {
    get().add(handler.build());
  }

  struct create_builded {
  private:
    ContainerHandler & self;
  
  public:
    create_builded(ContainerHandler & ref): self(ref) {}
    
    void operator() () { self.get(); }
  };
  
  template <typename B, bool with_voltageLevel, IIDM::side_id Sides>
  struct connectable_adder {
  private:
    ContainerHandler & self;
    ConnectableHandler<B, with_voltageLevel, Sides> const& handler;

  public:
    connectable_adder(ContainerHandler & ref, ConnectableHandler<B, with_voltageLevel, Sides>& handler_ref):
      self(ref), handler(handler_ref)
    {}
    
    void operator() () { self.add_connectable<B, with_voltageLevel, Sides>(handler); }
  };
  
  template <typename B, bool with_voltageLevel, IIDM::side_id Sides>
  void set_connectable_handler(path_type const& path, ConnectableHandler<B, with_voltageLevel, Sides>& handler) {
    this->onElement(path, handler);
    handler.onStart( create_builded(*this) );
    handler.onEnd( connectable_adder<B, with_voltageLevel, Sides>(*this, handler) );
  }


  void configure(attributes_type const& attributes) IIDM_OVERRIDE {
    IdentifiableHandler<Builder>::configure(attributes);
    m_builded = boost::none;
  }
  
private:
  mutable boost::optional<builded_type> m_builded;
};

} // end of namespace IIDM::xml::
} // end of namespace IIDM::

#endif
