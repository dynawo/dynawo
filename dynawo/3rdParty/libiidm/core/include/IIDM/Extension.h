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
 * @file Extension.h
 * @brief extension interface file
 */

#ifndef LIBIIDM_GUARD_EXTENSION_H
#define LIBIIDM_GUARD_EXTENSION_H

#include <IIDM/Export.h>
#include <IIDM/pointers.h>
#include <boost/type_index.hpp>

namespace IIDM {

/**
 * @brief Tagging base class for extensions.
 */
class IIDM_EXPORT Extension {
public:
  BOOST_TYPE_INDEX_REGISTER_CLASS

public:
  virtual ~Extension();

protected:
  Extension(){}
  Extension(Extension const&){}

public:
  IIDM_UNIQUE_PTR<Extension> clone() const { return IIDM_UNIQUE_PTR<Extension>(do_clone()); }
  
protected:
  virtual Extension* do_clone() const = 0;
};

} // end of namespace IIDM::

#endif
