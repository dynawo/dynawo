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
 * @file xml/import/iidm_namespace.h
 * @brief Provides iidm_ns
 */

#ifndef LIBIIDM_XML_IMPORT_GUARD_IIDM_NAMESPACE_H
#define LIBIIDM_XML_IMPORT_GUARD_IIDM_NAMESPACE_H

#include <xml/sax/parser/ElementName.h>

namespace IIDM {
namespace xml {

/** the xml namespace target used by iidm root.
*/
extern ::xml::sax::parser::namespace_uri iidm_ns;

} // end of namespace IIDM::xml::
} // end of namespace IIDM::

#endif
