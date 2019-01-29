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
 * @file internals/xml/libxml_raii.h
 * @brief complement to libXML, in order to provide RAII support
 */

#ifndef LIBXML_SAX_FORMATTER_GUARD_DOCUMENT_H
#define LIBXML_SAX_FORMATTER_GUARD_DOCUMENT_H

#include <xml/sax/formatter/AttributeList.h>
#include <xml/sax/formatter/Formatter.h>

#include <boost/optional.hpp>

#include <string>


namespace xml {
namespace sax {
namespace formatter {

class Element;

class Document {
public:
  explicit Document(Formatter & formatter);

  ~Document();

  Element element(std::string const& name);

  Element element(std::string const& name, AttributeList const& attrs);

  Element element(std::string const& namespacePrefix, std::string const& name);

  Element element(std::string const& namespacePrefix, std::string const& name, AttributeList const& attrs);

private:
  Formatter & formatter;
};




class Element {
public:
  Element(Formatter & formatter, std::string const& name);

  Element(Formatter & formatter, std::string const& namespacePrefix, std::string const& name);

  Element(Formatter & formatter, std::string const& name, AttributeList const& attrs);

  Element(Formatter & formatter, std::string const& namespacePrefix, std::string const& name, AttributeList const& attrs);

  ~Element();


  ///chainage: creer un element interne, sans attribut
  Element element(std::string const& name) {
    return Element(formatter, name);
  }

  ///chainage: creer un element interne, sans attribut
  Element element(std::string const& namespacePrefix, std::string const& name) {
    return Element(formatter, namespacePrefix, name);
  }

  ///chainage: creer un element interne, avec attributs
  Element element(std::string const& name, AttributeList const& attrs) {
    return Element(formatter, name, attrs);
  }

  ///chainage: creer un element interne, avec attributs
  Element element(std::string const& namespacePrefix, std::string const& name, AttributeList const& attrs) {
    return Element(formatter, namespacePrefix, name, attrs);
  }



  ///chainage: creer un element interne vide, sans attribut
  Element& empty_element(std::string const& name);

  ///chainage: creer un element interne vide, avec attributs
  Element& empty_element(std::string const& name, AttributeList const& attrs);


  ///chainage: creer un element interne vide, sans attribut
  Element& empty_element(std::string const& namespacePrefix, std::string const& name);

  ///chainage: creer un element interne vide, avec attributs
  Element& empty_element(std::string const& namespacePrefix, std::string const& name, AttributeList const& attrs);



  ///chainage: creer un element interne avec une valeur, sans attribut, sans prefixe xml
  template <typename T>
  Element& simple_element(std::string const& name, T const& value) {
    Element(formatter, name).value(value);
    return *this;
  }

  ///chainage: creer un element interne avec une valeur, avec attributs, sans prefixe xml
  template <typename T>
  Element& simple_element(std::string const& name, AttributeList const& attrs, T const& value) {
    Element(formatter, name, attrs).value(value);
    return *this;
  }

  ///chainage: creer un element interne avec une valeur, sans attribut, avec prefixe xml
  template <typename T>
  Element& simple_element(std::string const& namespacePrefix, std::string const& name, T const& value) {
    Element(formatter, namespacePrefix, name).value(value);
    return *this;
  }

  ///chainage: creer un element interne avec une valeur, avec attributs, avec prefixe xml
  template <typename T>
  Element& simple_element(std::string const& namespacePrefix, std::string const& name, AttributeList const& attrs, T const& value) {
    Element(formatter, namespacePrefix, name, attrs).value(value);
    return *this;
  }



  Element& characters(std::string const& value) { formatter.characters(value); return *this; }

  template <typename T>
  Element& value(T const& value) { return characters(boost::lexical_cast<std::string>(value)); }

private:
  Formatter & formatter;
};

template <>
inline Element& Element::value(std::string const& value) { return characters(value); }



} // end of namespace xml::sax::formatter::
} // end of namespace xml::sax::
} // end of namespace xml::

#endif
