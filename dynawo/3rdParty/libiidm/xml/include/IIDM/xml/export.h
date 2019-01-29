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
 * @file xml/export.h
 * @brief xml export methods
 */

#ifndef LIBIIDM_XML_GUARD_EXPORT_H
#define LIBIIDM_XML_GUARD_EXPORT_H

#include <iosfwd>
#include <vector>
#include <map>
#include <string>

#include <IIDM/Extension.h>
#include <IIDM/forward.h>

#include <IIDM/xml/exception.h>

#include <boost/function.hpp>

namespace xml {
namespace sax {
namespace formatter {
class Element;
class Document;
} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

namespace IIDM {

class Network;

namespace xml {

class xml_formatter {
public:
  typedef std::string extension_uri;
  typedef std::string xml_prefix;
  
  ///type of extension request for partial selection.
  typedef std::vector<extension_uri> extensions_filter_type;

  ///type of function that extract an extension from an identifiable, and exports it under the given parent xml element with a given prefix.
  typedef boost::function<void(IIDM::Identifiable const&, ::xml::sax::formatter::Element& parent, xml_prefix const&)> extension_exporter;

private:
  struct exporter {
    exporter(xml_prefix const& prefix, extension_exporter const& functor): prefix(prefix), functor(functor) {}

    void operator()(IIDM::Identifiable const& i, ::xml::sax::formatter::Element& parent) const {
      functor(i, parent, prefix);
    }

    xml_prefix prefix;
    extension_exporter functor;
  };
  
  typedef std::map< extension_uri, exporter > exporters_type;
  typedef std::vector< exporters_type::mapped_type > extensions_type;

  exporters_type exporters;
  
public:
  /**
   * @brief sets the formatter for a given prefix.
   * @param exporter the function actually exporting the extension object.
   * @param uri target namespace as defined in the xsd.
   * @param prefix prefix used to bind the elements to the xsd
  // @throws IIDM::xml::extension_error if an extension is already set for the given prefix.
   */
  void register_extension(extension_exporter const& exporter, extension_uri const& uri, xml_prefix const& prefix);

  ///exports with all defined extensions
  // @throws IIDM::xml::export_error if an error occurs while exporting
  void to_xml(Network const&, std::string const& target);

  ///exports with all defined extensions
  // @throws IIDM::xml::export_error if an error occurs while exporting
  void to_xml(Network const&, const char * target);

  ///exports with all defined extensions
  // @throws IIDM::xml::export_error if an error occurs while exporting
  void to_xml(Network const&, std::ostream& target);



  ///exports with only specified extensions
  // @throws IIDM::xml::export_error if an error occurs while exporting
  void to_xml(Network const&, std::string const& target, extensions_filter_type const& extensions);

  ///exports with only specified extensions
  // @throws IIDM::xml::export_error if an error occurs while exporting
  void to_xml(Network const&, const char * target, extensions_filter_type const& extensions);

  ///exports with only specified extensions
  // @throws IIDM::xml::export_error if an error occurs while exporting
  void to_xml(Network const&, std::ostream& target, extensions_filter_type const& extensions);

private:
  void export_extensions(extensions_type const&, ::xml::sax::formatter::Element& root, IIDM::Identifiable const&);
};



// exports without extensions
inline void to_xml(Network const& network, std::string const& target) {
  xml_formatter().to_xml(network, target);
}

// exports without extensions
inline void to_xml(Network const& network, const char * target) {
  xml_formatter().to_xml(network, target);
}

// exports without extensions
inline void to_xml(Network const& network, std::ostream& target) {
  xml_formatter().to_xml(network, target);
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::

#endif

