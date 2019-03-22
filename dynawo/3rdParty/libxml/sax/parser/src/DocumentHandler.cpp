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
 * @file DocumentHandler.cpp
 * @brief DocumentHandler : implementation file
 *
 */

#include <xml/sax/parser/DocumentHandler.h>

namespace xml {
namespace sax {
namespace parser {

DocumentHandler::~DocumentHandler() {}


void DocumentHandler::startElement(ElementName const&, attributes_type const&) {}

void DocumentHandler::endElement(ElementName const&) {}

void DocumentHandler::readCharacters(std::string const&) {}

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::
