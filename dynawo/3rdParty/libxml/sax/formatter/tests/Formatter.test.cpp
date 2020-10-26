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

#include <xml/sax/formatter/Formatter.h>

#include <gtest/gtest.h>

#include <xml/cpp11.h>

#include <sstream>
#include <string>

#include <boost/algorithm/string.hpp>

namespace f = xml::sax::formatter;

using namespace boost::algorithm;

class TestFormatter: public testing::Test {
protected:
  static const std::string indent;

  static const std::string root;
  static const std::string node;
  static const std::string inner;
  static const std::string content;
  static const std::string encoding;

  static const std::string default_uri;
  static const std::string ns1_uri;
  static const std::string ns2_uri;

  static const std::string ns1;
  static const std::string ns2;

  std::stringstream stream;

  f::FormatterPtr make_formatter(bool indented = true) {
    return f::Formatter::createFormatter(stream, "", indented ? indent : "");
  }

  f::FormatterPtr make_formatter_namespace(bool indented = true) {
    return f::Formatter::createFormatter(stream, default_uri, indented ? indent : "");
  }

  f::FormatterPtr make_formatter_encoding(bool useEncoding = true) {
    return f::Formatter::createFormatter(stream, default_uri, "", useEncoding ? encoding : "");
  }

  //line is reduced to is "attribute" part: prefix and suffix are removed.
  //ASSERT are only valid in void functions
  static void check_element_open(std::string& line, std::string const& prefix, std::string const& suffix) {

    EXPECT_TRUE( starts_with(line, prefix) ) << "element shall start with \"" << prefix << "\", but found \""<<prefix<<'"';
    ASSERT_TRUE( ends_with(line, suffix) ) << "element shall end with \"" << suffix << "\", but found \""<<line<<'"';

    ASSERT_GE(line.find(">"), line.size() - suffix.size());

    line = line.substr(prefix.size(), line.size() - prefix.size() - suffix.size());
  }
};

const std::string TestFormatter::indent = "  ";

const std::string TestFormatter::root = "root";
const std::string TestFormatter::node = "node";
const std::string TestFormatter::inner = "inner";

const std::string TestFormatter::content = "content";

const std::string TestFormatter::default_uri = "URI_DEF";
const std::string TestFormatter::ns1_uri = "URI1";
const std::string TestFormatter::ns2_uri = "URI2";
const std::string TestFormatter::ns1 = "ns1";
const std::string TestFormatter::ns2 = "ns2";
const std::string TestFormatter::encoding = "ENCODING_TEST";



TEST_F(TestFormatter, EmptyCreation) {
  //this scope permits to test stream after the destruction of the Formatter
  {
    f::FormatterPtr ptr;
    ASSERT_EQ(ptr.get(), static_cast<void*>(XML_NULLPTR));

    ptr = make_formatter();
    ASSERT_EQ(stream.str(), "");
  }

  ASSERT_EQ(stream.str(), "");
}

TEST_F(TestFormatter, XMLHeader) {
  using std::string;

  f::FormatterPtr ptr = make_formatter();

  // The library shall allow "empty pseudo-xml document"
  ptr->startDocument();
  ptr->endDocument();

  // The xml declaration ("<?xml ... ?>") shall be present, and in only one line.
  string header;
  std::getline(stream, header);//gets the first line of the document.

  ASSERT_TRUE( starts_with(header, "<?xml") );
  string::size_type end_limiter = header.find("?>");
  ASSERT_TRUE( end_limiter != string::npos );

  //limit header to its "<?xml ... ?>" part
  header.erase(end_limiter+2);

  ASSERT_TRUE( contains(header, "version=\"1.0\"") || contains(header, "version=\"1.1\"") );
  ASSERT_TRUE( contains(header, "encoding=") );
}


TEST_F(TestFormatter, XMLBasic) {
  using std::string;

  f::FormatterPtr ptr = make_formatter();

  ptr->startDocument();

  ptr->startElement(root);
  ptr->endElement();

  ptr->endDocument();

  string line;

  //ignore the first line (the <?xml ?>)
  std::getline(stream, line);

  std::getline(stream, line);//the first line should be "<root/>"
  ASSERT_EQ(line, "<"+root+"/>");
}


TEST_F(TestFormatter, XMLTwoNodes) {
  using std::string;

  f::FormatterPtr ptr = make_formatter();

  ptr->startDocument();

  ptr->startElement(root);

    ptr->startElement(node);
    ptr->characters(content);
    ptr->endElement();

    ptr->startElement(node);
    ptr->characters(content);
    ptr->endElement();

  ptr->endElement();

  ptr->endDocument();

  string line;

  //ignore the first line (the <?xml ?>)
  std::getline(stream, line);

  std::getline(stream, line);
  ASSERT_EQ(line, "<"+root+">");

  std::getline(stream, line);
  ASSERT_EQ(line, indent + "<"+node+">"+content+"</"+node+">");

  std::getline(stream, line);
  ASSERT_EQ(line, indent + "<"+node+">"+content+"</"+node+">");

  std::getline(stream, line);
  ASSERT_EQ(line, "</"+root+">");
}

TEST_F(TestFormatter, XMLAttributes) {
  using std::string;

  f::FormatterPtr ptr = make_formatter();

  ptr->startDocument();

  ptr->startElement(root);
    //attribute on empty element
    ptr->startElement(node, f::AttributeList("a", "A")("b", "B"));
    ptr->endElement();

    //attribute on simple element
    ptr->startElement(node, f::AttributeList("c", "C")("d", "D"));
    ptr->characters(content);
    ptr->endElement();

    //attribute on complex element
    ptr->startElement(node, f::AttributeList("e", "E")("f", "F")("g", "G"));
      ptr->startElement(inner);
      ptr->endElement();
    ptr->endElement();

  ptr->endElement();

  ptr->endDocument();

  string line;
  // string::size_type pos;

  //ignore the first line (the <?xml ?>)
  std::getline(stream, line);

  std::getline(stream, line);
  ASSERT_EQ(line, "<"+root+">");

  //attribute on empty element
  std::getline(stream, line);
  {
    SCOPED_TRACE("empty element");
    check_element_open(line, indent+"<"+node+" ", "/>");
  }
  ASSERT_TRUE(contains(line, "a=\"A\"")) << "empty element shall declare attribute a, but found \""<<line<<'"';
  ASSERT_TRUE(contains(line, "b=\"B\"")) << "empty element shall declare attribute a, but found \""<<line<<'"';

  //attribute on simple element
  std::getline(stream, line);
  {
    SCOPED_TRACE("simple element");
    check_element_open(line, indent+"<"+node+" ", ">"+content+"</"+node+">");
  }
  ASSERT_TRUE(contains(line, "c=\"C\"")) << "simple element shall declare attribute c, but found \""<<line<<'"';
  ASSERT_TRUE(contains(line, "d=\"D\"")) << "simple element shall declare attribute d, but found \""<<line<<'"';

  //attribute on complex element
  std::getline(stream, line);
  {
    SCOPED_TRACE("complex element");
    check_element_open(line, indent+"<"+node+" ", ">");
  }
  ASSERT_TRUE(contains(line, "e=\"E\""))<< "complex element shall declare attribute e, but found \""<<line<<'"';
  ASSERT_TRUE(contains(line, "f=\"F\""))<< "complex element shall declare attribute f, but found \""<<line<<'"';
  ASSERT_TRUE(contains(line, "g=\"G\""))<< "complex element shall declare attribute g, but found \""<<line<<'"';

  std::getline(stream, line);
  ASSERT_EQ(line, indent + indent + "<"+inner+"/>");

  std::getline(stream, line);
  ASSERT_EQ(line, indent+"</"+node+">");

  std::getline(stream, line);
  ASSERT_EQ(line, "</"+root+">");
}


TEST_F(TestFormatter, XMLnamespace) {
  using std::string;

  f::FormatterPtr ptr = make_formatter_namespace();
  ptr->addNamespace(ns1, ns1_uri);
  ptr->addNamespace(ns2, ns2_uri);


  ptr->startDocument();

  ptr->startElement(root);//root no prefix
    ptr->startElement(ns1, node);
    ptr->endElement();

    //attribute on complex element
    ptr->startElement(ns1, node);
      ptr->startElement(ns2, inner);
      ptr->endElement();
    ptr->endElement();

  ptr->endElement();

  ptr->endDocument();

  string line;
  // string::size_type pos;

  //ignore the first line (the <?xml ?>)
  std::getline(stream, line);

  //root element shall declare all namespaces
  std::getline(stream, line);
  {
    SCOPED_TRACE("root");
    check_element_open(line, "<"+root+" ", ">");
  }

  ASSERT_TRUE(contains(line, ns1+"=\""+ns1_uri+"\"")) << "root element shall declare namespace "<<ns1<<", but found \""<<line<<'"';
  ASSERT_TRUE(contains(line, ns2+"=\""+ns2_uri+"\"")) << "root element shall declare attribute "<<ns2<<", but found \""<<line<<'"';

  //ns1:node empty
  std::getline(stream, line);
  ASSERT_EQ(line, indent+"<"+ns1+":"+node+"/>");

  //ns1:node containing...
  std::getline(stream, line);
  ASSERT_EQ(line, indent+"<"+ns1+":"+node+">");

  //ns2:inner empty
  std::getline(stream, line);
  ASSERT_EQ(line, indent+indent+"<"+ns2+":"+inner+"/>");

  //...end of ns1:node
  std::getline(stream, line);
  ASSERT_EQ(line, indent+"</"+ns1+":"+node+">");

  //end of root non namespace
  std::getline(stream, line);
  ASSERT_EQ(line, "</"+root+">");
}

TEST_F(TestFormatter, XMLencoding) {
  using std::string;

  f::FormatterPtr ptr = make_formatter_encoding();
  ptr->addNamespace(ns1, ns1_uri);
  ptr->addNamespace(ns2, ns2_uri);

  ptr->setEncoding(encoding);

  ptr->startDocument();

  ptr->startElement(root);//root no prefix
    ptr->startElement(ns1, node);
    ptr->endElement();

    //attribute on complex element
    ptr->startElement(ns1, node);
      ptr->startElement(ns2, inner);
      ptr->endElement();
    ptr->endElement();

  ptr->endElement();

  ptr->endDocument();

  string line;
  // string::size_type pos;

  std::getline(stream, line);
  ASSERT_TRUE(contains(line, "<?xml version=\"1.0\" encoding=" + encoding + " standalone=\"no\"?>"));

  //root element shall declare all namespaces
  std::getline(stream, line);
  {
    SCOPED_TRACE("root");
    check_element_open(line, "<"+root+" ", ">");
  }

  ASSERT_TRUE(contains(line, ns1+"=\""+ns1_uri+"\"")) << "root element shall declare namespace "<<ns1<<", but found \""<<line<<'"';
  ASSERT_TRUE(contains(line, ns2+"=\""+ns2_uri+"\"")) << "root element shall declare attribute "<<ns2<<", but found \""<<line<<'"';

  //ns1:node empty
  std::getline(stream, line);
  ASSERT_EQ(line, indent+"<"+ns1+":"+node+"/>");

  //ns1:node containing...
  std::getline(stream, line);
  ASSERT_EQ(line, indent+"<"+ns1+":"+node+">");

  //ns2:inner empty
  std::getline(stream, line);
  ASSERT_EQ(line, indent+indent+"<"+ns2+":"+inner+"/>");

  //...end of ns1:node
  std::getline(stream, line);
  ASSERT_EQ(line, indent+"</"+ns1+":"+node+">");

  //end of root non namespace
  std::getline(stream, line);
  ASSERT_EQ(line, "</"+root+">");
}

TEST_F(TestFormatter, XMLunpretty) {
  using std::string;

  f::FormatterPtr ptr = make_formatter(false);

  ptr->startDocument();
  ptr->startElement(root);
    ptr->startElement(node, f::AttributeList("a", "A"));
      ptr->startElement(inner);
        ptr->characters(content);
      ptr->endElement();
    ptr->endElement();
  ptr->endElement();
  ptr->endDocument();

  string line;

  //ignore the first line (the <?xml ?>)
  std::getline(stream, line);
  line = line.substr(line.find("?>")+2);

  ASSERT_EQ(line, "<"+root+"><"+node+" a=\"A\"><"+inner+">"+content+"</"+inner+"></"+node+"></"+root+">");
}
