//
// Copyright (c) 2023, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file DYNXmlString.h
 * @brief XML String
 *
 */

#ifndef COMMON_DYNXMLSTRING_H_
#define COMMON_DYNXMLSTRING_H_

#include <functional>
#include <memory>
#include <libxml/xmlstring.h>
#include <libxml/xmlmemory.h>

namespace DYN {

class XmlString : public std::unique_ptr<xmlChar, std::function<void(void*)>> {
public:
    explicit XmlString(xmlChar* ptr) noexcept :
        unique_ptr(ptr, xmlFree) {
    }

    XmlString(XmlString&&) noexcept = default;

    virtual ~XmlString() = default;
};

}  // end of namespace DYN

#endif  // COMMON_DYNXMLSTRING_H_
