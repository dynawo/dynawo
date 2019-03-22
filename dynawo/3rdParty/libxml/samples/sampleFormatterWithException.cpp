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


namespace format = xml::sax::formatter;

using format::AttributeList;
using format::Formatter;
using format::FormatterPtr;
using format::FormatterException;

int main(int argc, char** argv) {
  if (argc != 2) {
    std::cerr << "Usage: sampleFormatter <fileOut.xml>" << std::endl;
    exit(-1);
  }

  const std::string filename(argv[1]);

  // use of xercesc personal.xml as example
  try {
    std::fstream file(filename.c_str(), std::fstream::out);
    FormatterPtr formatter =  Formatter::createFormatter(file);
    formatter->addNamespace("ns1", "http://www.namespaces/namespace1");
    formatter->addNamespace("ns2", "http://www.namespaces/namespace2");
    formatter->startDocument();

    AttributeList attrs;
    formatter->startElement("ns3", "personnel", attrs); //should raise an exception
    attrs.clear();

    attrs.add("id","Big.Boss");
    formatter->startElement("person",attrs);
    formatter->endElement();// person
    formatter->endElement();//"personnel"
  }
  catch (FormatterException const& exp) {
    std::cerr<<exp.what()<<std::endl;
    return -1;
  }
  return 0;
}
