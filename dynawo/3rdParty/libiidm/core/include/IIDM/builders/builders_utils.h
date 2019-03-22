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
 * @file builders/builders_utils.h
 * @brief basic template support for builders.
 */

/*
an exemple of builder:

namespace IIDM {
namespace builders {

class IIDM_EXPORT Builder {
public:
  typedef B builded_type;

  MACRO_IIDM_BUILDER_PROPERTY(Builder, double, p0)
  MACRO_IIDM_BUILDER_PROPERTY(Builder, double, q0)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(Builder, boost::optional<double>, p )
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(Builder, boost::optional<double>, q )

public:
  builded_type build(id_type const&) const;
};

} // end of namespace IIDM::builders::
} // end of namespace IIDM::

*/

#ifndef LIBIIDM_BUILDERS_GUARD_BUILDERS_H
#define LIBIIDM_BUILDERS_GUARD_BUILDERS_H

#include <IIDM/cpp11_type_traits.h>
#include <stdexcept>

namespace IIDM {
namespace builders {

struct builder_exception: std::runtime_error {
  explicit builder_exception(std::string const& msg) : std::runtime_error(msg) {}
};

} // end of namespace IIDM::builders::
} // end of namespace IIDM::


/*
 * this macro creates a private member, and related functions.
 * it is expected to be used when creating a builder.
 * it is required that the class using this macro inherits from Self. At least, *this shall be convertable to Self&
 */
#define MACRO_IIDM_BUILDER_PROPERTY(Self, Type, Name) \
private:\
  Type m_##Name;\
public:\
  Type const& Name() const { return m_##Name; }\
  Self& Name(Type const& Name) { m_##Name = Name; return static_cast<Self&>(*this); }

/*
 * this macro creates a private member, and related functions.
 * it is expected to be used when creating a builder.
 * it is required that the class using this macro inherits from Self. At least, *this shall be convertable to Self&
 * Type will be wrapped into a boost::optional<Type>
 * in the specific case of boost::optional<string>, there is an extra overload, Name(char const*)
 */
#define MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(Self, Type, Name) \
private:\
  boost::optional< Type > m_##Name;\
public:\
  boost::optional< Type > const& Name() const { return m_##Name; }\
  Self& Name(boost::optional< Type > const& Name) { m_##Name = Name; return static_cast<Self&>(*this); }\
  template <typename X> \
  typename IIDM_ENABLE_IF< \
    IIDM::tt::is_same< std::basic_string< X >, Type>::value, \
    Self& \
  >::type \
  Name(X const* Name) { m_##Name = std::string(Name); return static_cast<Self&>(*this); }

#endif
