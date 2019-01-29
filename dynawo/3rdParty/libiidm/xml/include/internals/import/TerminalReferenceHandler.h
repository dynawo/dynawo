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
 * @file xml/import/Handler_utils.h
 * @brief utilities for handler definitions
 */

#ifndef LIBIIDM_XML_INTERNALS_IMPORT_GUARD_TERMINALREFERENCEHANDLER_H
#define LIBIIDM_XML_INTERNALS_IMPORT_GUARD_TERMINALREFERENCEHANDLER_H

#include <xml/sax/parser/Attributes.h>

#include <IIDM/BasicTypes.h>
#include <IIDM/components/TerminalReference.h>

#include <stdexcept>


namespace xml {
namespace sax {
namespace parser {

template<>
inline Attributes::SearchedAttribute::operator IIDM::side_id () const {
  if (!value) throw std::runtime_error("no value for attribute "+name);

  if (*value == "ONE"  ) return IIDM::side_1;
  if (*value == "TWO"  ) return IIDM::side_2;
  if (*value == "THREE") return IIDM::side_3;

  return IIDM::side_end;
}

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::


namespace IIDM {
namespace xml {

inline TerminalReference make_terminalReference(::xml::sax::parser::Attributes const& attributes) {
  return TerminalReference(attributes["id"], attributes["side"] | IIDM::side_end);
}

} // end of namespace IIDM::xml::
} // end of namespace IIDM::

#endif
