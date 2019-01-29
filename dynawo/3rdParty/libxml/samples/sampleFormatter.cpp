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


namespace format = xml::sax::formatter;

using format::AttributeList;
using format::Formatter;
using format::FormatterPtr;

int main(int argc, char** argv) {
  // use of xercesc personal.xml as example
  
  std::ofstream file;
  std::ostream & stream = (argc<2) ? std::cout : (file.open(argv[1]),file);
  
  FormatterPtr formatter = Formatter::createFormatter(stream);
  formatter->startDocument();
  
  AttributeList attrs;
  formatter->startElement("personnel", attrs);

  attrs.clear();
  attrs.add("id","Big.Boss");
  formatter->startElement("person",attrs);
  
  attrs.clear();
  formatter->startElement("name",attrs);
  
  formatter->startElement("family",attrs);
  formatter->characters("Boss");
  formatter->endElement();// family

  formatter->startElement("given",attrs);
  formatter->characters("Big");
  formatter->endElement();// given
  
  formatter->endElement();// name

  formatter->startElement("email",attrs);
  formatter->characters("chief@foo.com");
  formatter->endElement();// email

  attrs.clear();
  attrs.add("subordinate1","one.worker");
  attrs.add("subordinate2","two.worker");
  attrs.add("subordinate3","three.worker");
  formatter->startElement("link",attrs);
  formatter->characters("Test characters with attributes");
  formatter->endElement();// link

  formatter->endElement();// person
  
  formatter->endElement();// personnel
}
