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
 * @file components/ExternalComponent.h
 * @brief ExternalComponent interface file
 */

#ifndef LIBIIDM_COMPONENTS_GUARD_EXTERNALCOMPONENT_H
#define LIBIIDM_COMPONENTS_GUARD_EXTERNALCOMPONENT_H

#include <IIDM/Export.h>

#include <IIDM/components/Identifiable.h>
#include <IIDM/components/ContainedIn.h>

namespace IIDM {

class Network;


class IIDM_EXPORT ExternalComponent: public Identifiable, public ContainedIn<Network> {
  /* ********* data interface ********* */
public:
  //aliases of parent()
  ///tells if a parent network is specified
  bool has_network() const { return has_parent(); }

  ///gets a constant reference to the parent network
  Network const& network() const { return parent(); }
  ///gets a reference to the parent network
  Network      & network()       { return parent(); }

/* ****** connection interface ****** */
public:
  ExternalComponent(id_type const&);
};

} // end of namespace IIDM::

#endif
