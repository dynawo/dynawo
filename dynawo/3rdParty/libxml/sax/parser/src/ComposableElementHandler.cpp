//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Libxml, a library to handle XML files parsing.
//

/**
 * @file ComposableElementHandler.cpp
 * @brief ComposableElementHandler implementation file
 *
 */

#include <xml/sax/parser/ComposableElementHandler.h>
#include <xml/sax/parser/Path.h>

namespace xml {
namespace sax {
namespace parser {

void ComposableElementHandler::startElement(ElementName const& name, attributes_type const& attributes) {
  if (at_root()) start();
  ComposableBase::startElement(name, attributes);
}

void ComposableElementHandler::endElement(ElementName const& name) {
  ComposableBase::endElement(name);
  if (at_root()) end();
}

void ComposableElementHandler::readCharacters(std::string const& characters) {
  ComposableBase::readCharacters(characters);
}

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::
