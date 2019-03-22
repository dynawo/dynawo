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
 * @file FormatterImpl.h
 * @brief XML formatter implementation description : header file
 *
 */

#ifndef XML_SAX_FORMATTER_FORMATTERIMPL_H_
#define XML_SAX_FORMATTER_FORMATTERIMPL_H_

#include <map>
#include <stack>

#include <xml/sax/formatter/Formatter.h>

namespace xml {
namespace sax {
namespace formatter {

/**
 * @class FormatterImpl
 * @brief SAX XML Formatter implemented class
 *
 * Formatter objects allow to create XML streams throw event-driven
 * serialization.
 */
class FormatterImpl : public Formatter {
public:
  /**
   * @brief FormatterImpl constructor
   *
   * Creates a Formatter which will write on given output stream an XML stream
   * pretty formatted or not. A default namespace for the document can be chosen.
   *
   * @param out Stream to write XML stream on
   * @param indentation If set to "", no spacing is added to make its format user friendly
   * @param defaultNamespace Default namespace URI of the XML file (put in the xmlns
   * attribute of the first element)
   */
  FormatterImpl(std::ostream& out, std::string const& defaultNamespace, std::string const& indentation);

  /**
   * @brief Destructor
   */
  virtual ~FormatterImpl();

  /**
   * @copydoc Formatter::addNamespace()
   */
  virtual void addNamespace(std::string const& prefix, std::string const& uri);

  /**
   * @copydoc Formatter::startDocument()
   */
  virtual void startDocument();

  /**
   * @copydoc Formatter::endDocument()
   */
  virtual void endDocument();

  using Formatter::startElement;

  /**
   * @copydoc Formatter::startElement()
   */
  virtual void startElement(std::string const& namespacePrefix, std::string const& name, AttributeList const& attrs);

  /**
   * @copydoc Formatter::endElement()
   */
  virtual void endElement();

  /**
   * @copydoc Formatter::characters()
   */
  virtual void characters(std::string const& chars);

private:
  /**
   * @brief Adds indentation
   *
   * Used with pretty format outputs
   */
  void add_indentation();

  /**
   * @brief Adds a line break
   *
   * Used with pretty format outputs
   */
  void add_newline();


  /**
   * @brief Replace XML reserved characters in given string
   *
   * @param[in] str String to treat by removing reserved characters
   * @param[out] str2 String treated
   * @returns true if some characters have been replaced, false otherwise
   */
  static bool replaceReservedCharacters(std::string const& str, std::string& str2);

private: //non copyable:
  FormatterImpl(FormatterImpl const&);
  FormatterImpl& operator=(FormatterImpl const&);

private:
  typedef std::string namespace_prefix_type;
  typedef std::string fullname_type;

  typedef std::map<namespace_prefix_type, std::string> namespaces_type;

  typedef std::stack<fullname_type> tag_stack_type;

  static fullname_type make_fullname(namespace_prefix_type const& prefix, std::string const& name);

  std::ostream& out_;         ///< Output XML stream

  namespaces_type namespaces_;///< Namespaces map organized by prefix

  tag_stack_type tag_stack;   ///< Namespace stack for correct elements prefixing
  bool tagClosed_;            ///< Latest tag closed ?
  bool hasCharacters_;        ///< Element with characters

  bool prettyFormat_;         ///< Is pretty format used
  std::string indentation_;   ///< Indent depth, in spaces
};

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

#endif
