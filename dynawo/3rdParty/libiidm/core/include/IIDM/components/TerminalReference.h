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
 * @file components/TerminalReference.h
 * @brief TerminalReference interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_TERMINALREFERENCE_H
#define LIBIIDM_COMPONENTS_GUARD_TERMINALREFERENCE_H


#include <IIDM/BasicTypes.h>

namespace IIDM {
/**
 * @brief represents a reference to a Terminal.
 */
struct TerminalReference {
  ///id of the referenced terminal.
  id_type id;
  ///specific side (might be side_end)
  side_id side;


  ///constructs a TerminalReference with no specific side.
  TerminalReference(id_type const&);

  ///constructs a TerminalReference with a specific side.
  TerminalReference(id_type const&, side_id);
};

} // end of namespace IIDM::

#endif
