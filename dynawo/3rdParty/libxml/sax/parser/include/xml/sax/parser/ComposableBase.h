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
 * @file ComposableBase.h
 * @brief XML event handler abstract implementation : interface file
 *
 */

#ifndef XML_SAX_PARSER_COMPOSABLE_BASE_H
#define XML_SAX_PARSER_COMPOSABLE_BASE_H

#include <vector>
#include <boost/function.hpp>

#include <xml/sax/parser/Attributes_fwd.h>
#include <xml/sax/parser/ElementName.h>

#include <xml/sax/parser/Path.h>
#include <xml/sax/parser/PathTree.h>

namespace xml {
namespace sax {
namespace parser {

class ElementHandler;

/**
 * @brief handler built by attaching handlers or functors to an xml path.
 *
 * A full handler can be attached to a path, or just one of the event handling functors
 */
class ComposableBase {
public:
  typedef boost::function<void (ElementName const& name, Attributes const&)> startElement_observer;
  typedef boost::function<bool (ElementName const& name)> endElement_observer;
  typedef boost::function<void (std::string const& name)> characters_observer;

  typedef path<ElementName> path_type;

public:
  /**
   * @brief Default constructor.
   */
  explicit ComposableBase() {}
  explicit ComposableBase(ComposableBase const&);

  ComposableBase& operator=(ComposableBase const&);

protected:
  /** @brief Destructor */
  ~ComposableBase() {}

public:
  //adds a possibility to beginElement
  ComposableBase& onStartElement(path_type const&, startElement_observer const&, bool recursive = false);

  //adds a possibility to endElement
  ComposableBase& onEndElement(path_type const&, endElement_observer const&, bool recursive = false);

  //adds a possibility to readCharacters
  ComposableBase& onReadCharacters(path_type const&, characters_observer const&, bool recursive = false);

  //no const handler overload, because a temporary reference is not sufficient
  ComposableBase& onElement(path_type const&, ElementHandler & other);

public:
  /**
   * @brief Called when an XML element opening tag is read.
   *
   * @param name the name and namespace of the element
   * @param attributes the attributes of the read element
   */
  void startElement(ElementName const& name, Attributes const& attributes);

  /**
   * @brief Called when an XML element closing tag is read.
   *
   * @param name Name of the element
   */
  void endElement(ElementName const& name);

  /**
   * @brief Characters inside XML element event handler
   *
   * @param chars Characters to write in the element
   */
  void readCharacters(std::string const& characters);

protected:
  void reset();
  path_type const& current_path() const { return m_current_path; }

  bool at_root() const { return m_current_path.empty(); }

private:
  //allows to attach a bool to a functor
  template <typename O>
  struct Observer {
    O observer;
    bool is_recursive;
    Observer(O const& o, bool recursive): observer(o), is_recursive(recursive) {}
  };

  template <typename O>
  static Observer<O> make_observer(O const& o, bool recursive) { return Observer<O>(o, recursive); }

  typedef path_multitree<ElementName, Observer<startElement_observer> > startElement_observers_type;
  typedef path_multitree<ElementName, Observer<endElement_observer> > endElement_observers_type;
  typedef path_multitree<ElementName, Observer<characters_observer> > characters_observers_type;


  startElement_observers_type m_startElement_observers;
  endElement_observers_type m_endElement_observers;
  characters_observers_type m_characters_observers;

  path_type m_current_path;
};

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

#endif
