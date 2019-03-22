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
 * @file  sampleFormatterWithException.cpp
 *
 * @brief test class for xmlFormatter with an exception
 *
 */

#include <fstream>
#include <iostream>

#include <xml/sax/formatter/AttributeList.h>
#include <xml/sax/formatter/Formatter.h>
#include <xml/sax/formatter/FormatterException.h>
#include <xml/sax/formatter/Document.h>

namespace format = xml::sax::formatter;

using format::AttributeList;
using format::Formatter;
using format::FormatterPtr;
using format::FormatterException;
using format::Document;
using format::Element;

int main(int argc, char** argv) {

  std::ofstream file;
  std::ostream & stream = (argc<2) ? std::cout : (file.open(argv[1]),file);

  // use of xercesc personal.xml as example
  try {
    FormatterPtr formatter = Formatter::createFormatter(stream);
    formatter->addNamespace("ns1", "http://www.namespaces/namespace1");
    formatter->addNamespace("ns2", "http://www.namespaces/namespace2");
    Document doc(*formatter);

    Element personnel = doc.element("ns3", "personnel"); //should raise an exception

    personnel.element("person", AttributeList("id", "Big.Boss"));
  }
  catch (FormatterException const& exp) {
    std::cerr<<exp.what()<<std::endl;
    return -1;
  }
  return 0;
}
