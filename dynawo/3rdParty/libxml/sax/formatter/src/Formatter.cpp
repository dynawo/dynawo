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
 * @file Formatter.cpp
 * @brief XML formatter description : implementation file
 *
 */

#include <xml/sax/formatter/Formatter.h>

#include "internals/FormatterImpl.h"

namespace xml {
namespace sax {
namespace formatter {

Formatter::~Formatter() {}

Formatter*
Formatter::newFormatter(std::ostream& out, std::string const& defaultNamespace, std::string const& indentation) {
  return new FormatterImpl(out, defaultNamespace, indentation);
}

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::
