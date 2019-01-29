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
 * @file ComposableBase.cpp
 * @brief XML Handler description : implementation file
 *
 */

#include <xml/sax/parser/ComposableBase.h>

#include <xml/sax/parser/ElementHandler.h>
#include <xml/sax/parser/Path.h>

namespace xml {
namespace sax {
namespace parser {


namespace {

struct startElement_wrapper {
public:  
  startElement_wrapper(ElementHandler& wrapped): wrapped(wrapped) {}
  
  bool operator()(ElementName const& name, Attributes const& attributes) {
    wrapped.startElement(name, attributes);
    return true;
  }

private:
  ElementHandler& wrapped;
};

struct endElement_wrapper {
public:  
  endElement_wrapper(ElementHandler& wrapped): wrapped(wrapped) {}
  
  bool operator()(ElementName const& name) {
    wrapped.endElement(name);
    return true;
  }

private:
  ElementHandler& wrapped;
};

struct characters_wrapper {
public:  
  characters_wrapper(ElementHandler& wrapped): wrapped(wrapped) {}
  
  bool operator()(std::string const& chars) {
    wrapped.readCharacters(chars);
    return true;
  }

private:
  ElementHandler& wrapped;
};

} //end of namespace XML::SAX::<anonymous>::

ComposableBase::ComposableBase(ComposableBase const& other):
  m_startElement_observers(other.m_startElement_observers),
  m_endElement_observers(other.m_endElement_observers),
  m_characters_observers(other.m_characters_observers),
  m_current_path()
{}

ComposableBase& ComposableBase::operator=(ComposableBase const& other) {
  m_startElement_observers = other.m_startElement_observers;
  m_endElement_observers = other.m_endElement_observers;
  m_characters_observers = other.m_characters_observers;
  m_current_path = other.m_current_path;
  return *this;
}





ComposableBase& ComposableBase::onStartElement(path_type const& p, startElement_observer const& o, bool recursive) {
  m_startElement_observers.insert(p, make_observer(o, recursive) );
  return *this;
}

ComposableBase& ComposableBase::onEndElement(path_type const& p, endElement_observer const& o, bool recursive) {
  m_endElement_observers.insert(p, make_observer(o, recursive));
  return *this;
}

ComposableBase& ComposableBase::onReadCharacters(path_type const& p, characters_observer const& o, bool recursive) {
  m_characters_observers.insert(p, make_observer(o, recursive));
  return *this;
}


ComposableBase& ComposableBase::onElement(path_type const& p, ElementHandler & other) {
  m_startElement_observers.insert(p, make_observer<startElement_observer>( startElement_wrapper(other), true) );
  m_endElement_observers.insert(p, make_observer<endElement_observer>( endElement_wrapper(other), true) );
  m_characters_observers.insert(p, make_observer<characters_observer>( characters_wrapper(other), true) );
  
  return *this;
}



void ComposableBase::reset() {
  m_current_path.clear();
}



void ComposableBase::startElement(ElementName const& name, Attributes const& attributes) {
  m_current_path += name;
  
  path_type p;
  for (path_type::const_iterator it = m_current_path.begin(); it!=m_current_path.end(); ++it) {
    p+=*it;

    startElement_observers_type::const_value_range 
    // boost::optional< Observer<startElement_observer> const&> 
    that = m_startElement_observers.find(p);
    
    for (startElement_observers_type::const_value_range::iterator it = that.begin(); it!=that.end(); ++it) {
      if (it->is_recursive || p == m_current_path ) {
        (it->observer)(name, attributes);
      }
    }
  }
}

void ComposableBase::endElement(ElementName const& name) {
  for (path_type p = m_current_path; !p.empty(); p.remove_end()) {
    endElement_observers_type::const_value_range 
    that = m_endElement_observers.find(p);
    
    for (endElement_observers_type::const_value_range::iterator it = that.begin(); it!=that.end(); ++it) {
      if (it->is_recursive || p == m_current_path ) {
        (it->observer)(name);
      }
    }
  }

  m_current_path.remove_end();
}

void ComposableBase::readCharacters(std::string const& characters) {
  path_type p;
  for (path_type::const_iterator it = m_current_path.begin(); it!=m_current_path.end(); ++it) {
    p+=*it;

    characters_observers_type::const_value_range that = m_characters_observers.find(p);
    for (characters_observers_type::const_value_range::iterator it = that.begin(); it!=that.end(); ++it) {
      if (it->is_recursive || p == m_current_path ) {
        (it->observer)(characters);
      }
    }
  }
}

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::
