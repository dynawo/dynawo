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
 * @file  FormatterPtr.h
 *
 * @brief Define auto_ptr/unique_ptr to formatter object: Different implementation between C++98 and C++11
 *
 */

#ifndef XML_SAX_FORMATTER_FORMATTERPTR_H
#define XML_SAX_FORMATTER_FORMATTERPTR_H

#include <xml/pointers.h>

namespace xml {
namespace sax {
namespace formatter {

class Formatter;

typedef XML_OWNER_PTR<Formatter> FormatterPtr; /**< AutoPtr to Formatter object. Different implementation between C++98 and C++11 **/

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::

#endif
