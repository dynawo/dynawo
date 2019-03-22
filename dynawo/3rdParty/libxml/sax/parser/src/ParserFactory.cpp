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
 * @file Parser.cpp
 * @brief XML parser description : implementation file
 *
 */

#include <xml/sax/parser/ParserFactory.h>

#include "internals/XercescParser.h"

#include <xercesc/util/PlatformUtils.hpp>

#include <iostream>

namespace xml {
namespace sax {
namespace parser {

ParserFactory::ParserFactory() {
  xercesc::XMLPlatformUtils::Initialize();
}

ParserFactory::~ParserFactory() {
  xercesc::XMLPlatformUtils::Terminate();
}

Parser* ParserFactory::newParser() const {
  return new XercescParser();
}

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::
