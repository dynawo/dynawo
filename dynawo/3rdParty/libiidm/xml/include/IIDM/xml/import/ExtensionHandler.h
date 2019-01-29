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
 * @file xml/import/ExtensionHandler.h
 * @brief Provides ExtensionHandler interface
 */

#ifndef LIBIIDM_XML_IMPORT_GUARD_EXTENSION_H
#define LIBIIDM_XML_IMPORT_GUARD_EXTENSION_H

#include <IIDM/Extension.h>

#include <xml/sax/parser/ElementHandler.h>

#include <IIDM/pointers.h>

namespace IIDM {
namespace xml {

class ExtensionHandler: public virtual ::xml::sax::parser::ElementHandler {
public:
  typedef IIDM_UNIQUE_PTR<IIDM::Extension> extension_ptr;

  virtual ~ExtensionHandler();
  
  extension_ptr make() { return extension_ptr(do_make()); }
  
private:
  virtual IIDM::Extension* do_make() = 0;
  
public:
  ///name of the xml element serving as base element
  virtual elementName_type const& root_element() const = 0;
};

//the expected function object shall not own the returned pointer. It will be deleted by xml_parser.
typedef boost::function< ExtensionHandler*() > ExtensionHandlerFactory;

} // end of namespace IIDM::xml::
} // end of namespace IIDM::

#endif
