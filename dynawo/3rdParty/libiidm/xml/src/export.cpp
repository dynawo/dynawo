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
 * @file xml/export.cpp
 * @brief XML export implementation
 */

#include <IIDM/xml/export.h>
#include <xml/sax/formatter/Formatter.h>
#include <xml/sax/formatter/FormatterException.h>
#include <xml/sax/formatter/AttributeList.h>
#include <xml/sax/formatter/Document.h>

#include <IIDM/xml/exception.h>
#include <IIDM/xml/export/export_functions.h>

#include <fstream>
#include <iostream>
#include <iomanip>

#include <algorithm>
#include <iterator>

#include <boost/optional.hpp>
#include <boost/optional/bad_optional_access.hpp>

#include <IIDM/Network.h>

namespace IIDM {
namespace xml {

void xml_formatter::register_extension(extension_exporter const& e, extension_uri const& uri, xml_prefix const& prefix) {
  if (exporters.insert( exporters_type::value_type(uri, exporter(prefix, e)) ).second == false) {
    throw extension_error("an extension is already defined for "+uri);
  }
}


//exports with all defined extensions
void xml_formatter::to_xml(Network const& network, std::string const& target) {
  std::ofstream stream(target.c_str());
  return to_xml(network, stream);
}

//exports with all defined extensions
void xml_formatter::to_xml(Network const& network, const char * target) {
  std::ofstream stream(target);
  return to_xml(network, stream);
}

//exports with only specified extensions
void xml_formatter::to_xml(Network const& network, std::string const& target, extensions_filter_type const& extensions) {
  std::ofstream stream(target.c_str());
  return to_xml(network, stream, extensions);
}

//exports with only specified extensions
void xml_formatter::to_xml(Network const& network, const char * target, extensions_filter_type const& extensions) {
  std::ofstream stream(target);
  return to_xml(network, stream, extensions);
}


using ::xml::sax::formatter::Document;
using ::xml::sax::formatter::Element;
using ::xml::sax::formatter::FormatterPtr;

inline FormatterPtr make_formatter(std::ostream& stream) {
  stream << std::boolalpha;

  return ::xml::sax::formatter::Formatter::createFormatter(
    stream, "http://www.itesla_project.eu/schema/iidm/1_0", "  "
  );
}



//exports with all defined extensions
void xml_formatter::to_xml(Network const& network, std::ostream& stream) {
  FormatterPtr formatter = make_formatter(stream);
  Document document(*formatter);

  extensions_type extensions;
  extensions.reserve(exporters.size());
  for (exporters_type::const_iterator it = exporters.begin(); it != exporters.end(); ++it) {
    extensions.push_back(it->second);

    formatter->addNamespace(it->second.prefix, it->first);
  }
  try {
    Element network_element = IIDM::xml::to_xml(document, network);

    if (!exporters.empty()) {
      for (Network::identifiable_const_iterator it = network.identifiable_begin(); it!=network.identifiable_end(); ++it) {
        export_extensions(extensions, network_element, *it );
      }
    }
  }
  catch (::xml::sax::formatter::FormatterException const& e) {
    throw export_error(e.what());
  }
  catch (boost::bad_optional_access const& e) {
    throw export_error(e.what());
  }
}


//exports with only specified extensions
void xml_formatter::to_xml(Network const& network, std::ostream& stream, extensions_filter_type const& extensions_filter) {
  FormatterPtr formatter = make_formatter(stream);
  Document document(*formatter);


  extensions_type extensions;
  extensions.reserve(extensions_filter.size());

  if (!exporters.empty()) {
    for (extensions_filter_type::const_iterator it = extensions_filter.begin(); it != extensions_filter.end(); ++it) {
      exporters_type::const_iterator where = exporters.find(*it);

      if (where!=exporters.end()) {
        extensions.push_back(where->second);
        formatter->addNamespace(where->second.prefix, where->first);
      }
    }
  }

  try {
    Element network_element = IIDM::xml::to_xml(document, network);

    if (!extensions.empty()) {
      for (Network::identifiable_const_iterator it = network.identifiable_begin(); it!=network.identifiable_end(); ++it) {
        export_extensions(extensions, network_element, *it );
      }
    }
  }
  catch (::xml::sax::formatter::FormatterException const& e) {
    throw export_error(e.what());
  }
  catch (boost::bad_optional_access const& e) {
    throw export_error(e.what());
  }
}


// support function
void xml_formatter::export_extensions(extensions_type const& extensions, Element& root, IIDM::Identifiable const& c) {
  if (!c.has_extensions()) return;

  Element extension = root.element( "extension", ::xml::sax::formatter::AttributeList("id", c.id()) );

  for (extensions_type::const_iterator it = extensions.begin(); it!= extensions.end(); ++it) {
    (*it)(c, extension);
  }
}



} // end of namespace IIDM::xml::
} // end of namespace IIDM::
