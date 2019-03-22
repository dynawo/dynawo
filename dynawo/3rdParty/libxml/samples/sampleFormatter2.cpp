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
 * @file  sampleFormatter.cpp
 *
 * @brief test class for xmlFormatter
 *
 */

#include <fstream>
#include <iostream>

#include <xml/sax/formatter/AttributeList.h>
#include <xml/sax/formatter/Formatter.h>
#include <xml/sax/formatter/Document.h>

namespace format = xml::sax::formatter;

using format::AttributeList;
using format::Formatter;
using format::FormatterPtr;
using format::Document;
using format::Element;

int main(int argc, char** argv) {
  // use of xercesc personal.xml as example

  std::ofstream file;
  std::ostream & stream = (argc<2) ? std::cout : (file.open(argv[1]),file);

  FormatterPtr formatter = Formatter::createFormatter(stream);
  format::Document doc(*formatter);

  format::Element personnel = doc.element("personnel");

  format::Element boss = personnel.element("person", AttributeList("id", "Big.Boss"));

  boss.element("name")
    .simple_element("family", "Boss")
    .simple_element("given", "Big");

  boss.simple_element("email", "chief@foo.com");

  boss.simple_element("link",
    AttributeList
      ("subordinate1","one.worker")
      ("subordinate2","two.worker")
      ("subordinate3","three.worker"),
    "Test characters with attributes"
  );
}
