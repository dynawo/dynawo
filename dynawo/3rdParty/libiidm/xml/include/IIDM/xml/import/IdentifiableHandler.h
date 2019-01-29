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
 * @file xml/import/IdentifiableHandler.h
 * @brief IdentifiableHandler interface file
 */

#ifndef LIBIIDM_XML_IMPORT_GUARD_IDENTIFIABLEHANDLER_H
#define LIBIIDM_XML_IMPORT_GUARD_IDENTIFIABLEHANDLER_H

#include <xml/sax/parser/ComposableElementHandler.h>
#include <xml/sax/parser/Attributes.h>

#include <IIDM/xml/import/iidm_namespace.h>

#include <IIDM/BasicTypes.h>
#include <IIDM/cpp11.h>

namespace IIDM {
namespace xml {

template <typename Builder>
class IdentifiableHandler: public ::xml::sax::parser::ComposableElementHandler {
private:
  typedef IdentifiableHandler<Builder> self_type;

public:
  typedef Builder builder_type;
  typedef typename Builder::builded_type builded_type;

  IdentifiableHandler(elementName_type const& root_element);

  builded_type build() const { return m_builder.build(m_id); }
  
  builder_type const& builder () const { return m_builder; }
  builder_type      & builder ()       { return m_builder; }

  builder_type const& operator * () const { return m_builder; }
  builder_type      & operator * ()       { return m_builder; }

  builder_type const* operator-> () const { return &m_builder; }
  builder_type      * operator-> ()       { return &m_builder; }

protected:
  
  //called when opening the block's root element
  //inheriter override shall call its parent's one.
  virtual void configure(attributes_type const& attributes) {
    m_id = attributes["id"].as_string();
    m_builder = builder_type().name(attributes["name"]);
  }

  IIDM::id_type const& id() const { return m_id; }
  
private:
  IdentifiableHandler(IdentifiableHandler const&);
  IdentifiableHandler& operator=(IdentifiableHandler const&);
  
  builder_type m_builder;
  IIDM::id_type m_id;

  void set_property(attributes_type const& attributes) {
    m_builder.set(attributes["name"], attributes["value"]);
  }
  
private:
  //a few functors, to not use Boost.Phoenix nor lambda in this header
  
  struct configurator {
    self_type & handler;
    configurator(self_type & ref): handler(ref) {}
    
    void operator() (elementName_type const&, attributes_type const& attributes) const {
      handler.configure(attributes);
    }
  };
  
  struct property_adder {
    self_type & handler;
    property_adder(self_type & ref): handler(ref) {}
    
    void operator() (elementName_type const&, attributes_type const& attributes) const {
      handler.set_property(attributes);
    }
  };
};

template <typename Builder>
inline IdentifiableHandler<Builder>::IdentifiableHandler(elementName_type const& root_element) {
  onStartElement( root_element, configurator(*this) );
  onStartElement( root_element+iidm_ns("property"), property_adder(*this) );
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::

#endif
