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
 * @file IdentifiableBuilder.h
 * @brief Identifiable interface file
 */

#ifndef LIBIIDM_BUILDERS_GUARD_IDENTIFIABLEBUILDER_H
#define LIBIIDM_BUILDERS_GUARD_IDENTIFIABLEBUILDER_H

#include <string>
#include <boost/optional.hpp>


#include <IIDM/BasicTypes.h>
#include <IIDM/builders/builders_utils.h>

#include <IIDM/components/Identifiable.h>

namespace IIDM {
namespace builders {

/**
 * @brief an helper bas class for builders for objects inheriting from IIDM::Identifiable
 * @tparam T the Identifiable class this builder is expected to build. T shall inherit from IIDM::Identifiable
 * @tparam CRTP_BUILDER the actual builder class. CRTP_BUILDER shall inherit from this class.
 *
 * CRTP_BUILDER is expected to be a class inheriting from this class (static_cast<CRTP&>(*this) shall always be correct)
 * an identifiable builder does NOT hold the unique identifier, it shall be given at actual building time
 * Inheriting builders shall provide the following functions:
 *    builded_type build(Id const&) const
 */
template <typename T, typename CRTP_BUILDER>
class IdentifiableBuilder {
public:
  typedef T builded_type;
  typedef CRTP_BUILDER builder_type;

public:
  typedef IIDM::Identifiable::property_id_type property_id_type;
  typedef IIDM::Identifiable::property_value_type property_value_type;
  typedef IIDM::Identifiable::properties_type properties_type;

  IdentifiableBuilder() {}

  builder_type clone() const { return static_cast<builder_type const&>(*this); }

protected:
  ~IdentifiableBuilder(){}

public:
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(builder_type, std::string, name)
  MACRO_IIDM_BUILDER_PROPERTY(builder_type, properties_type, properties)

public:
  builder_type& set(property_id_type const& id, property_value_type const& value) {
    m_properties[id]=value;
    return static_cast<builder_type&>(*this);
  }

  /**
   * @brief Tells if this Identifiable is named
   * @returns true if name() returns a name, false otherwise
   */
  bool named() const { return !m_name; }

  /**
   * @brief Creates the identifier for the builded object
   * @returns an Identifier made of the given id and the selected name
   */
  Identifier make_identifier(id_type const& id) const { return Identifier(id, m_name? *m_name : ""); }
};

} // end of namespace IIDM::builders::
} // end of namespace IIDM::

#endif
