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
 * @file xml/IIDMDocumentHandler.h
 * @brief import_handler interface file
 */

#ifndef LIBIIDM_INTERNALS_XML_GUARD_IIDMDOCUMENTHANDLER_H
#define LIBIIDM_INTERNALS_XML_GUARD_IIDMDOCUMENTHANDLER_H

#include <IIDM/xml/import/NetworkHandler.h>
#include <IIDM/xml/import/ExtensionHandler.h>

#include <IIDM/pointers.h>

#include <xml/sax/parser/ComposableDocumentHandler.h>
#include <xml/sax/parser/ComposableElementHandler.h>

namespace IIDM {
class Network;

namespace xml {

class IIDMDocumentHandler : public ::xml::sax::parser::ComposableDocumentHandler {
public:
  IIDMDocumentHandler();


  bool has_network() const;

  IIDM::Network const& network() const;
  IIDM::Network & network();

  void add_extension(ExtensionHandlerFactory const& factory);

private:
  class ActualExtensionHandler: public ::xml::sax::parser::ComposableElementHandler {
  public:
    explicit ActualExtensionHandler(IIDMDocumentHandler &);
    ~ActualExtensionHandler();


    void add_extension(ExtensionHandlerFactory const& factory);

  private:
    void add_constructed_extension(ExtensionHandler& ext);

    //note: std::auto_ptr are not safe to use in STL containers
    typedef std::vector<ExtensionHandler*> extension_handlers_type;

    extension_handlers_type extension_handlers;
    IIDMDocumentHandler & doc_handler;
    std::string id;

    struct onEndFunctor;
  };

private:
  NetworkHandler network_handler;
  ActualExtensionHandler extension_handler;
};

} // end of namespace IIDM::xml::
} // end of namespace IIDM::

#endif
