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

#include <xml/sax/formatter/Document.h>
#include <xml/sax/formatter/Formatter.h>

#include <gtest/gtest.h>

#include "type_trait_test.hpp"


namespace f = xml::sax::formatter;


class TestDocument: public testing::Test {
protected:
  static const std::string indent;

  static const std::string root;
  static const std::string node;
  static const std::string inner;
  static const std::string content;

  static const std::string default_uri;

  TestDocument(bool ns = false, bool indented = true):
    raw( make_formatter(stream_raw, ns, indented) ),
    doc( make_formatter(stream_doc, ns, indented) )
  {}

  ~TestDocument() {}

  virtual void TearDown() {
    ASSERT_EQ(stream_raw.str(), stream_doc.str());
  }

private:
  std::ostringstream stream_raw;
  std::ostringstream stream_doc;
protected:
  f::FormatterPtr raw;
  f::FormatterPtr doc;

private:
  static f::FormatterPtr make_formatter(std::ostringstream & stream, bool ns, bool indented) {
    return f::Formatter::createFormatter(stream, ns?default_uri:"", indented ? indent : "");
  }
};

const std::string TestDocument::indent = "  ";

const std::string TestDocument::root = "root";
const std::string TestDocument::node = "node";
const std::string TestDocument::inner = "inner";

const std::string TestDocument::content = "content";

const std::string TestDocument::default_uri = "URI_DEF";

class TestDocumentUnpretty : public TestDocument {
protected:
  TestDocumentUnpretty(): TestDocument(false, false) {}
};


class TestDocumentNS : public TestDocument {
protected:
  static const std::string ns1_uri;
  static const std::string ns2_uri;

  static const std::string ns1;
  static const std::string ns2;

  TestDocumentNS(): TestDocument(true) {
    raw->addNamespace(ns1, ns1_uri);
    doc->addNamespace(ns1, ns1_uri);

    raw->addNamespace(ns2, ns2_uri);
    doc->addNamespace(ns2, ns2_uri);
  }
};

const std::string TestDocumentNS::ns1_uri = "URI1";
const std::string TestDocumentNS::ns2_uri = "URI2";
const std::string TestDocumentNS::ns1 = "ns1";
const std::string TestDocumentNS::ns2 = "ns2";

using f::Document;


TEST_F(TestDocument, XMLBasic) {
  raw->startDocument();
    raw->startElement(root);
    raw->endElement();
  raw->endDocument();

  Document(*doc)
    .element(root);
}


TEST_F(TestDocument, XMLTwoNodes) {
  raw->startDocument();
    raw->startElement(root);

      raw->startElement(node);
      raw->characters(content);
      raw->endElement();

      raw->startElement(inner);
      raw->characters(content);
      raw->endElement();

    raw->endElement();
  raw->endDocument();

  Document(*doc)
    .element(root)
      .simple_element(node, content)
      .simple_element(inner, content)
  ;
}


TEST_F(TestDocument, XMLAttributes) {
  f::AttributeList att1; att1("a", "A")("b", "B");
  f::AttributeList att2; att2("c", "C")("d", "D");
  f::AttributeList att3; att3("e", "E")("f", "F")("g", "G");

  raw->startDocument();
    raw->startElement(root);
      raw->startElement(node, att1);
      raw->endElement();

      raw->startElement(node, att2);
      raw->characters(content);
      raw->endElement();

      raw->startElement(node, att3);;
        raw->startElement(inner);
        raw->endElement();
      raw->endElement();

    raw->endElement();
  raw->endDocument();

  Document(*doc)
    .element(root)
      .empty_element(node, att1)
      .simple_element(node, att2, content)
      .element(node, att3)
        .empty_element(inner)
  ;
}

TEST_F(TestDocumentNS, XMLnamespace) {
  raw->startDocument();
    raw->startElement(root);//root no prefix
      raw->startElement(ns1, node);
      raw->endElement();

      //attribute on complex element
      raw->startElement(ns1, node);
        raw->startElement(ns2, inner);
        raw->endElement();
      raw->endElement();

    raw->endElement();
  raw->endDocument();


  Document(*doc)
    .element(root)
      .empty_element(ns1, node)
      .element(ns1, node)
        .empty_element(ns2, inner)
  ;
}

TEST_F(TestDocumentUnpretty, XMLunpretty) {
  raw->startDocument();
    raw->startElement(root);
      raw->startElement(node, f::AttributeList("a", "A"));
        raw->startElement(inner);
          raw->characters(content);
        raw->endElement();
      raw->endElement();
    raw->endElement();
  raw->endDocument();


  Document(*doc)
    .element(root)
      .element(node, f::AttributeList("a", "A"))
        .simple_element(inner, content)
  ;
}

TEST_F(TestDocument, Integer) {
  Document(*raw)
    .element(root)
      .simple_element(node, 2);
  Document(*doc)
    .element(root)
      .simple_element(node, "2");
}

TEST_F(TestDocument, Value1) {
  Document(*raw)
    .element(root)
      .simple_element(node, content);
  Document(*doc)
    .element(root)
      .element(node).value(content);
}

TEST_F(TestDocument, Value2) {
  const int value = 2;
  Document(*raw)
    .element(root)
      .simple_element(node, value);
  Document(*doc)
    .element(root)
      .element(node).value(value);
}

TEST_F(TestDocument, Characters) {
  Document(*raw)
    .element(root)
      .simple_element(node, content);
  Document(*doc)
    .element(root)
      .element(node).characters(content);
}
