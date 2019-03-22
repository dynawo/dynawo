//
// Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Libiidm, a library to model IIDM networks and allows
// importing and exporting them to files.
//

/**
 * @file xml/export/attributes_helper.h
 * @brief xml export support functions related to xml attributes
 */

#ifndef LIBIIDM_XML_EXPORT_GUARD_ATTRIBUTES_HELPER_H
#define LIBIIDM_XML_EXPORT_GUARD_ATTRIBUTES_HELPER_H

#include <iosfwd>
#include <IIDM/Extension.h>
#include <IIDM/BasicTypes.h>

#include <IIDM/components/Connection.h>
#include <IIDM/components/Connectable.h>
#include <IIDM/components/Identifiable.h>

#include <xml/sax/formatter/AttributeList.h>


namespace IIDM {

class Network;
class Identifiable;
class ConnectableBase;

template <typename T, side_id Sides>
class Connectable;

class Connection;

namespace xml {

namespace detail {
class attributes_adder {
private:
  ::xml::sax::formatter::AttributeList & ref;

protected:
  virtual attributes_adder const& do_add(std::string const& name, std::string const& value) const {
    ref.add(name, value);
    return *this;
  }

public:
  operator ::xml::sax::formatter::AttributeList & () const { return ref; }

  virtual ~attributes_adder() {}

  attributes_adder(::xml::sax::formatter::AttributeList & ref): ref(ref) {}

  attributes_adder const& add(std::string const& name, std::string const& value) const {
    return do_add(name, value);
  }

  template <typename V>
  attributes_adder const& add(std::string const& name, V const& value) const {
    return do_add( name, boost::lexical_cast<std::string>(value) );
  }

  attributes_adder const& add(std::string const& name, bool value) const {
    return do_add( name, (value ? "true" : "false") );
  }

  template <typename V>
  attributes_adder const& add(std::string const& name, boost::optional<V> const& value) const {
    return value ? add(name, *value) : *this;
  }


  template <typename V>
  attributes_adder const& operator() (std::string const& name, V const& value) const {
    return add(name, value);
  }
};

inline attributes_adder add(::xml::sax::formatter::AttributeList & attrs) { return attributes_adder(attrs); }

class suffixer: public attributes_adder {
public:
  suffixer(attributes_adder const& a, std::string const& suffix): attributes_adder(a), suffix(suffix) {}

  virtual attributes_adder const& do_add(std::string const& name, std::string const& value) const {
    return attributes_adder::do_add(name+suffix, value);
  }

private:
  std::string suffix;
};

inline suffixer operator+(attributes_adder const& adder, std::string const& suffix) {
  return suffixer(adder, suffix);
}

}//end of namespace IIDM::xml::detail::

//forces the conversion of reference (to use as attributes << identifiable(object); )
inline IIDM::Identifiable const& identifiable(IIDM::Identifiable const& identifiable) { return identifiable; }

//adds Identifiable attributes
::xml::sax::formatter::AttributeList& operator << (::xml::sax::formatter::AttributeList& attrs, IIDM::Identifiable const& identifiable);





//forces the conversion of reference (to use as attributes << connectable(object); )
template <typename T, IIDM::side_id side>
IIDM::Connectable<T, side> const& connectable(IIDM::Connectable<T, side> const& connectable) { return connectable; }

//allows to mark a connectable or connection to be exported with its voltagelevel
template<typename T>
struct WithVoltageLevel {
  T const& ref;

  explicit WithVoltageLevel(T const& that): ref(that) {}
  operator T const& () const { return ref; }

  T const& operator* () const { return ref; }
  T const* operator->() const { return &ref; }
};

inline WithVoltageLevel<IIDM::Connection> withVoltageLevel(IIDM::Connection const& c) {
  return WithVoltageLevel<IIDM::Connection>(c);
}

template<typename T, IIDM::side_id side>
WithVoltageLevel< IIDM::Connectable<T, side> > withVoltageLevel(IIDM::Connectable<T, side> const& connectable) {
  return WithVoltageLevel< IIDM::Connectable<T, side> >(connectable);
}

//to use with attributes_adder or an extension
detail::attributes_adder const& operator << (detail::attributes_adder const& attrs, IIDM::Connection const& c);

//to use with attributes_adder or an extension
detail::attributes_adder const& operator << (detail::attributes_adder const& attrs, WithVoltageLevel<IIDM::Connection> const& c);


//does not emits "VoltageLevelId" attribute
template <typename T, IIDM::side_id side>
inline ::xml::sax::formatter::AttributeList& operator << (::xml::sax::formatter::AttributeList& attrs, IIDM::Connectable<T, side> const& connectable) {
  for (typename IIDM::Connectable<T, side>::const_iterator it=connectable.begin(), end=connectable.end(); it!=end; ++it) {
    attrs+boost::lexical_cast<std::string>(it->first) << it->second;
  }
  return attrs;
}

//does not emits "VoltageLevelId" attribute
//specialization for side_1
template <typename T>
inline ::xml::sax::formatter::AttributeList& operator << (::xml::sax::formatter::AttributeList& attrs, IIDM::Connectable<T, side_1> const& connectable) {
  boost::optional<Connection> const& c = connectable.connection();
  if (c) detail::add(attrs) << *c;
  return attrs;
}

//emits "VoltageLevelId" attribute
template <typename T, IIDM::side_id side>
inline ::xml::sax::formatter::AttributeList& operator << (::xml::sax::formatter::AttributeList& attrs, WithVoltageLevel< IIDM::Connectable<T, side> > connectable) {
  for (typename IIDM::Connectable<T, side>::const_iterator it=connectable->begin(), end=connectable->end(); it!=end; ++it) {
    (detail::add(attrs) + boost::lexical_cast<std::string>(1 - IIDM::side_1 + it->first)) << withVoltageLevel(it->second);
  }
  return attrs;
}

//emits "VoltageLevelId" attribute
//specialization for side_1
template <typename T>
inline ::xml::sax::formatter::AttributeList& operator << (::xml::sax::formatter::AttributeList& attrs, WithVoltageLevel< IIDM::Connectable<T, side_1> > connectable) {
  boost::optional<Connection> const& c = connectable->connection();
  if (c) detail::add(attrs) << withVoltageLevel(*c);
  return attrs;
}


//helper to write both "p" and "q" attributes using operator<< (improves caller lisibility)
template<typename T, side_id sides, bool q_only = false>
struct WritePQ {
  T const& ref;

  WritePQ(T const& that): ref(that) {}
  operator T const& () const { return ref; }

  T const& operator* () const { return ref; }
  T const* operator->() const { return &ref; }
};

template<typename T>
WritePQ<T, side_1, true> q(IIDM::Connectable<T, side_1> const& element) {
  return WritePQ<T, side_1, true>(static_cast<T const&>(element));
}

template<typename T>
WritePQ<T, side_1> pq(IIDM::Connectable<T, side_1> const& element) {
  return WritePQ<T, side_1>(static_cast<T const&>(element));
}

template<typename T>
WritePQ<T, side_2> pq(IIDM::Connectable<T, side_2> const& element) {
  return WritePQ<T, side_2>(static_cast<T const&>(element));
}

template<typename T>
WritePQ<T, side_3> pq(IIDM::Connectable<T, side_3> const& element) {
  return WritePQ<T, side_3>(static_cast<T const&>(element));
}


template <typename T>
::xml::sax::formatter::AttributeList& operator << (::xml::sax::formatter::AttributeList& attrs, WritePQ<T, side_1, true> c) {
  return attrs("q", c->optional_q());
}

template <typename T>
::xml::sax::formatter::AttributeList& operator << (::xml::sax::formatter::AttributeList& attrs, WritePQ<T, side_1> c) {
  return attrs("p", c->optional_p())("q", c->optional_q());
}

template <typename T>
::xml::sax::formatter::AttributeList& operator << (::xml::sax::formatter::AttributeList& attrs, WritePQ<T, side_2> c) {
  return attrs
    ("p1", c->optional_p1())("q1", c->optional_q1())
    ("p2", c->optional_p2())("q2", c->optional_q2())
  ;
}

template <typename T>
::xml::sax::formatter::AttributeList& operator << (::xml::sax::formatter::AttributeList& attrs, WritePQ<T, side_3> c) {
  return attrs
    ("p1", c->optional_p1())("q1", c->optional_q1())
    ("p2", c->optional_p2())("q2", c->optional_q2())
    ("p3", c->optional_p3())("q3", c->optional_q3())
  ;
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::

#endif
