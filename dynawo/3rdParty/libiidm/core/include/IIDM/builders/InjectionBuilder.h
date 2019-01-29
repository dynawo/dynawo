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
 * @file InjectionBuilder.h
 * @brief InjectionBuilder interface file
 */

#ifndef LIBIIDM_BUILDERS_GUARD_INJECTIONBUILDER_H
#define LIBIIDM_BUILDERS_GUARD_INJECTIONBUILDER_H

#include <IIDM/builders/IdentifiableBuilder.h>

namespace IIDM {
namespace builders {

/**
 * @brief an helper base class for builders for objects inheriting from IIDM::Injection
 * @tparam T the Injection class this builder is expected to build. T shall inherit from IIDM::Injection<T>
 * @tparam CRTP_BUILDER the actual builder class. CRTP_BUILDER shall inherit from this class.
 * 
 * CRTP_BUILDER is expected to be a class inheriting from this class (static_cast<CRTP&>(*this) shall always be correct)
 * an InjectionBuilder builder does NOT hold the unique identifier, it shall be given at actual building time
 * Inheriting builders shall provide the following functions:
 *    builded_type build(Id const&) const
 * @see IdentifiableBuilder
 */
template <typename T, typename CRTP_BUILDER>
class IIDM_EXPORT InjectionBuilder: public IdentifiableBuilder<T, CRTP_BUILDER> {
protected:
  typedef IdentifiableBuilder<T, CRTP_BUILDER> identifiable_builder_type;

public:
  typedef typename identifiable_builder_type::builded_type builded_type;
  typedef typename identifiable_builder_type::builder_type builder_type;

protected:
  ~InjectionBuilder(){}

public:
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(builder_type, double, p)
  MACRO_IIDM_BUILDER_OPTIONAL_PROPERTY(builder_type, double, q)

protected:
  builded_type& configure_injection(builded_type& builded) const {
    builded.m_p = m_p;
    builded.m_q = m_q;
    return builded;
  }
};

} // end of namespace IIDM::builders::
} // end of namespace IIDM::

#endif

