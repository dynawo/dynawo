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
 * @file FormatterImpl.cpp
 * @brief XML formatter implementation description : implementation file
 *
 */
#include "internals/FormatterImpl.h"

#include <iostream>

#include <xml/cpp11.h>
#include <xml/sax/formatter/AttributeList.h>
#include <xml/sax/formatter/FormatterException.h>

namespace xml {
namespace sax {
namespace formatter {

FormatterImpl::FormatterImpl(std::ostream& out, std::string const& defaultNamespace, std::string const& indentation, const std::string& encoding):
  out_(out),
  tagClosed_(true),
  hasCharacters_(false),
  prettyFormat_(!indentation.empty()),
  indentation_(indentation),
  encoding_(encoding)
{
  namespaces_[""] = defaultNamespace; // set default namespace
}



FormatterImpl::~FormatterImpl() {}

void FormatterImpl::addNamespace(std::string const& prefix, std::string const& uri) {
  if (namespaces_.find(prefix) != namespaces_.end()) {
    std::ostringstream msg;
    msg << "Namespace with prefix '" << prefix << "' already set in current formatter";
    throw FormatterException(msg.str());
  }
  namespaces_[prefix] = uri;
}



void FormatterImpl::startDocument() {
  out_ << "<?xml version=\"1.0\" encoding=\"" << encoding_ << "\" standalone=\"no\"?>";
  add_newline();
}



void FormatterImpl::endDocument() {
  out_.flush();
}



void
FormatterImpl::startElement(std::string const& namespacePrefix, std::string const& name, AttributeList const& attrs) {
  if (!tagClosed_) {
    out_ << ">";
    add_newline();
    tagClosed_ = true;
  }

  tagClosed_ = false;
  hasCharacters_ = false;

  add_indentation();


  if (namespaces_.find(namespacePrefix) == namespaces_.end()) { // invalid namespace
    std::ostringstream msg;
    msg << "Invalid namespace '" << namespacePrefix << "'";
    throw FormatterException(msg.str());
  }

  fullname_type fullname = make_fullname(namespacePrefix, name);

  out_ << "<" << fullname;

  // adding namespace definition to root element
  if (tag_stack.empty()) {
    for (namespaces_type::const_iterator it = namespaces_.begin(); it != namespaces_.end(); it ++) {
      namespace_prefix_type const& prefix = it->first;
      std::string const& uri = it->second;

      if (prefix == "" && uri != "") { // non-empty default namespace
        out_ << " xmlns=\"" << uri << "\"";
        continue;
      }
      if (prefix != "") {  // other namespace
        out_ << " xmlns:" << prefix << "=\"" << uri << "\"";
        continue;
      }
    }
  }

  tag_stack.push(fullname);

  for (AttributeList::const_iterator it = attrs.begin(); it!=attrs.end(); ++it) {
    std::string newValue;
    bool hasReservedChar = replaceReservedCharacters(it->value, newValue);
    out_ <<" "<< it->name << "=\"" << (hasReservedChar ? newValue : it->value) << "\"";
  }
}


void FormatterImpl::endElement() {
  if (tag_stack.empty()) throw FormatterException("trying to close an unopened tag");

  if (!tagClosed_) {
    out_ << "/>";
    add_newline();

    tagClosed_ = true;
    tag_stack.pop();
  }
  else {
    fullname_type fullname = tag_stack.top();
    tag_stack.pop();

    if (!hasCharacters_) add_indentation();
    out_ << "</" << fullname << ">";

    add_newline();
  }

  // element closed
  hasCharacters_ = false;
}



void FormatterImpl::characters(std::string const& chars) {
  if (!tagClosed_) {
    out_ << ">";
    tagClosed_ = true;
  }

  std::string newChars;
  bool hasReservedChar = replaceReservedCharacters(chars, newChars);
  out_ << (hasReservedChar ? newChars : chars);
  hasCharacters_ = true;
}


void FormatterImpl::add_newline() {
  if (prettyFormat_) out_ << '\n';
}


void FormatterImpl::add_indentation() {
  if (!prettyFormat_) return;
  for (tag_stack_type::size_type i = 0; i < tag_stack.size(); ++i) out_ << indentation_;
}


FormatterImpl::fullname_type
FormatterImpl::make_fullname(namespace_prefix_type const& prefix, std::string const& name) {
  return prefix.empty() ? name : prefix+':'+name;
}


const char* escape_char(char c) {
  switch(c) {
    case '<' : return "&lt;";
    case '>' : return "&gt;";
    case '&' : return "&amp;";
    case '"' : return "&quot;";
    case '\'': return "&apos;";
    default: return XML_NULLPTR;
  }
}

bool FormatterImpl::replaceReservedCharacters(std::string const& str, std::string& newStr) {
  bool hasReservedChar = false;

  // construit une chaine # de msg s'il y a au moins un caractere special
  // sinon pas la peine
  for (std::string::const_iterator it = str.begin(); it != str.end(); it++) {
    const char* escape_seq = escape_char(*it);
    if (escape_seq!=XML_NULLPTR) {
      if (hasReservedChar) // chaine de substitution deja en cours
        newStr += escape_seq;
      else {
        hasReservedChar = true;
        newStr.reserve(2 * str.size());
        newStr.assign(str.begin(), it);
        newStr += escape_seq;
      }
    } else {
      if (hasReservedChar) newStr += *it;
    }
  }

  return hasReservedChar;
}

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::
