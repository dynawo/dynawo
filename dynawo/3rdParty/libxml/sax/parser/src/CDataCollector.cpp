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
 * @file CDataCollector.cpp
 * @brief CDataCollector : implementation file
 *
 */

#include <xml/sax/parser/CDataCollector.h>
#include <iostream>

namespace xml {
namespace sax {
namespace parser {


CDataCollector::CDataCollector(): SimpleElementHandler(), tag_(), data_(), attributes_() {}

void CDataCollector::do_startElement(ElementName const& tag, attributes_type const& attributes) {
  tag_ = tag;
  attributes_ = attributes;
}

void CDataCollector::readCharacters(std::string const& characters) {
  data_ = characters;
}


} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::
