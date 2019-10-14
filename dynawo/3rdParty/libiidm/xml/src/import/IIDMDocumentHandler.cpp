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
 * @file xml/import_handler.cpp
 * @brief XML import details: handler part
 */

#include "internals/import/IIDMDocumentHandler.h"

#include <IIDM/xml/import/iidm_namespace.h>

#include <stdexcept>

#include <boost/phoenix/core.hpp>
#include <boost/phoenix/operator/self.hpp>
#include <boost/phoenix/bind.hpp>

namespace lambda = boost::phoenix;
namespace lambda_args = lambda::placeholders;

namespace parser = ::xml::sax::parser;

namespace IIDM {
namespace xml {



IIDMDocumentHandler::IIDMDocumentHandler():
  network_handler(parser::ElementName(iidm_ns, "network")),
  extension_handler(*this)
{
  onElement(iidm_ns("network"), network_handler );
  onElement(iidm_ns("network/extension"), extension_handler);
}



bool IIDMDocumentHandler::has_network() const {
  return network_handler.has_network();
}


IIDM::Network const& IIDMDocumentHandler::network() const {
  if (!network_handler.has_network()) throw std::runtime_error("no network available");
  return network_handler.network();
}

IIDM::Network & IIDMDocumentHandler::network() {
  if (!network_handler.has_network()) throw std::runtime_error("no network available");
  return network_handler.network();
}

void IIDMDocumentHandler::add_extension(ExtensionHandlerFactory const& factory) {
  extension_handler.add_extension(factory);
}


// this function is the one actually adding an extension in the network.
// if no identifiable is found, a pseudo component is injected, and the extension is added to it.
void IIDMDocumentHandler::ActualExtensionHandler::add_constructed_extension(ExtensionHandler& ext) {
  IIDM::Network& net = doc_handler.network();
  Identifiable * identifiable = net.searchById(id);
  if (!identifiable) {
    identifiable = & net.add_externalComponent(id);
  }
  identifiable->setExtension(ext.make());
}



IIDMDocumentHandler::ActualExtensionHandler::ActualExtensionHandler(IIDMDocumentHandler & doc_handler):
  doc_handler(doc_handler)
{
  onStartElement(
    iidm_ns("extension"),
#ifdef _MSC_VER
    [this](parser::ElementName const&, parser::Attributes const& attrs) { id = attrs["id"].as_string(); }
#else
    lambda::ref(id) = lambda::bind(&attributes_type::SearchedAttribute::as_string, lambda_args::arg2["id"])
#endif
  );
}

IIDMDocumentHandler::ActualExtensionHandler::~ActualExtensionHandler() {
  for(extension_handlers_type::const_iterator it=extension_handlers.begin(); it!=extension_handlers.end(); ++it) {
    delete *it;
  }
}

//functor used by add_extension
struct IIDMDocumentHandler::ActualExtensionHandler::onEndFunctor {
  onEndFunctor(IIDMDocumentHandler::ActualExtensionHandler & aeh, ExtensionHandler & handler):
    aeh(aeh), handler(handler)
  {}

  void operator() () {
    aeh.add_constructed_extension(handler);
  }
private:
  IIDMDocumentHandler::ActualExtensionHandler & aeh;
  ExtensionHandler & handler;
};

void IIDMDocumentHandler::ActualExtensionHandler::add_extension(ExtensionHandlerFactory const& factory) {
  ExtensionHandler* handler = factory();
  extension_handlers.push_back(handler);

  onElement(iidm_ns("extension") + handler->root_element(), *handler);
  handler->onEnd( onEndFunctor(*this, *handler) );
}


} // end of namespace IIDM::xml::
} // end of namespace IIDM::
