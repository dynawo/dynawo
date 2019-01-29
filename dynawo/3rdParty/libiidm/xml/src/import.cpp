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
 * @file xml/import.cpp
 * @brief xml import public part implementation file
 */

#include <IIDM/xml/import.h>

#include <xml/sax/parser/Parser.h>
#include <xml/sax/parser/ParserException.h>

#include <IIDM/xml/exception.h>
#include <IIDM/xml/import/iidm_namespace.h>

#include "internals/import/IIDMDocumentHandler.h"
#include "internals/config.h"

#include <fstream>

namespace parser = xml::sax::parser;

namespace IIDM {
namespace xml {

void xml_parser::register_extension(extension_uri const& uri, ExtensionHandlerFactory const& factory, std::string const& xsd_path) {
  extension_handler_factory added = {factory, xsd_path};
  
  if (extension_factories.insert( extension_factories_type::value_type(uri, added) ).second == false) {
    throw extension_error("an extension is already defined for "+uri);
  }
}

parser::ParserPtr xml_parser::make_parser(bool validating) {
  parser::ParserPtr parser = parser_factory.createParser();
  if (validating) parser->addXmlSchema( IIDM_XML_XSD_PATH + std::string("iidm.xsd") );
  
  return parser;
}


//imports with all defined extensions
Network xml_parser::from_xml(std::string const& source, bool validating) {
  std::ifstream stream(source.c_str());
  return from_xml(stream, validating);
}

//imports with all defined extensions
Network xml_parser::from_xml(const char * source, bool validating) {
  std::ifstream stream(source);
  return from_xml(stream, validating);
}

//imports with only specified extensions
Network xml_parser::from_xml(std::string const& source, extension_uris_type const& extensions, bool validating) {
  std::ifstream stream(source.c_str());
  return from_xml(stream, extensions, validating);
}

//imports with only specified extensions
Network xml_parser::from_xml(const char * source, extension_uris_type const& extensions, bool validating) {
  std::ifstream stream(source);
  return from_xml(stream, extensions, validating);
}


//imports with all defined extensions
//throws std::string, std::runtime_error or parser::ParserException
Network xml_parser::from_xml(std::istream& source, bool validating) {
  IIDMDocumentHandler handler;
  parser::ParserPtr parser = make_parser(validating);

  try {  
    for (extension_factories_type::const_iterator it = extension_factories.begin(); it != extension_factories.end(); ++it) {
      handler.add_extension( it->second.factory );
      if (validating) parser->addXmlSchema( it->second.xsd_path );
    }
  }
  catch (parser::ParserException const& e) {
    throw extension_error(e.what());
  }

  try {
    parser->parse(source, handler, validating);
  }
  catch (parser::ParserException const& e) {
    throw import_error(e.what());
  }
  catch (boost::bad_lexical_cast const& e) {
    throw import_error(e.what());
  }

  return handler.network();
}



//imports with only specified extensions
//throws std::string, std::runtime_error or parser::ParserException
IIDM::Network xml_parser::from_xml(std::istream& source, extension_uris_type const& extensions, bool validating) {
  IIDMDocumentHandler handler;
  parser::ParserPtr parser = make_parser(validating);

  try {  
    for (extension_uris_type::const_iterator it = extensions.begin(); it != extensions.end(); ++it) {
      extension_factories_type::const_iterator ext = extension_factories.find(*it);
      if (ext!=extension_factories.end()) {
        handler.add_extension( ext->second.factory );
        if (validating) parser->addXmlSchema( ext->second.xsd_path );
      }
    }
  } 
  catch (parser::ParserException const& e) {
    throw extension_error(e.what());
  }

  try {
    parser->parse(source, handler, validating);
  }
  catch (parser::ParserException const& e) {
    throw import_error(e.what());
  }
  catch (boost::bad_lexical_cast const& e) {
    throw import_error(e.what());
  }

  return handler.network();
}


} // end of namespace IIDM::xml::
} // end of namespace IIDM::
