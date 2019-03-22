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
 * @file xml/import.h
 * @brief xml import methods
 */

#ifndef LIBIIDM_XML_GUARD_IMPORT_H
#define LIBIIDM_XML_GUARD_IMPORT_H

#include <iosfwd>
#include <map>
#include <vector>
#include <string>

#include <IIDM/xml/import/ExtensionHandler.h>

#include <xml/sax/parser/ParserFactory.h>

namespace IIDM {

class Network;

namespace xml {

class xml_parser {
public:
  typedef std::string extension_uri;

  ///type of extension request for partial selection.
  typedef std::vector<extension_uri> extension_uris_type;

private:
  template <typename Handler>
  struct SimpleExtensionHandlerFactory {
    ExtensionHandler* operator() () const { return new Handler(); }
  };

  struct extension_handler_factory {
    ExtensionHandlerFactory factory;
    std::string xsd_path;
  };

  typedef std::map<extension_uri, extension_handler_factory> extension_factories_type;

public:
  explicit xml_parser() {}

  /**
   * @brief sets the handler factory related to a given xml target namespace.
   * @param uri target namespace as defined in the xsd.
   * @param factory a factory used to create the actual ExtensionHandler at parse time.
   * @throws IIDM::xml::extension_error if an extension is already set for the given uri.
   */
  void register_extension(extension_uri const& uri, ExtensionHandlerFactory const& factory, std::string const& xsd_path);

  /**
   * @brief helper to easily set an extension. requires some static members
   * @tparam Ext a type having static string functions uri() and xsd_path(), and a static type Factory. (see register_extension(...) for meanings)
   * @throws IIDM::xml::extension_error if an extension is already set for the given uri.
   * @see void register_extension(extension_uri const&, ExtensionHandler::Factory const&, std::string const&);
   */
  template <typename Ext>
  void register_extension() {
    register_extension(Ext::uri(), SimpleExtensionHandlerFactory<Ext>(), Ext::xsd_path());
  }



  ///imports with all defined extensions
  // @throws IIDM::xml::extension_error if an extension's xsd can't be parsed.
  // @throws IIDM::xml::import_error if an error occurs while parsing
  Network from_xml(std::string const& source, bool validating = false);

  ///imports with all defined extensions
  // @throws IIDM::xml::extension_error if an extension's xsd can't be parsed.
  // @throws IIDM::xml::import_error if an error occurs while parsing
  Network from_xml(const char * source, bool validating = false);

  ///imports with all defined extensions
  // @throws IIDM::xml::extension_error if an extension's xsd can't be parsed.
  // @throws IIDM::xml::import_error if an error occurs while parsing
  Network from_xml(std::istream& source, bool validating = false);



  ///imports with only specified extensions
  // @throws IIDM::xml::extension_error if an extension's xsd can't be parsed.
  // @throws IIDM::xml::import_error if an error occurs while parsing
  Network from_xml(std::string const& source, extension_uris_type const& extensions, bool validating = false);

  ///imports with only specified extensions
  // @throws IIDM::xml::extension_error if an extension's xsd can't be parsed.
  // @throws IIDM::xml::import_error if an error occurs while parsing
  Network from_xml(const char * source, extension_uris_type const& extensions, bool validating = false);

  ///imports with only specified extensions
  // @throws IIDM::xml::extension_error if an extension's xsd can't be parsed.
  // @throws IIDM::xml::import_error if an error occurs while parsing
  Network from_xml(std::istream& source, extension_uris_type const& extensions, bool validating = false);


private:
  ::xml::sax::parser::ParserPtr make_parser(bool validating);

  ::xml::sax::parser::ParserFactory parser_factory;
  extension_factories_type extension_factories;
};

} // end of namespace IIDM::io::

} // end of namespace IIDM::

#endif
