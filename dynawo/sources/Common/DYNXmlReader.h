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
 * @file DYNXmlReader.h
 * @brief XML Reader
 *
 */

#ifndef COMMON_DYNXMLREADER_H_
#define COMMON_DYNXMLREADER_H_

#include <functional>
#include <memory>
#include <libxml/xmlreader.h>

namespace DYN {

class XmlReader : public std::unique_ptr<xmlTextReader, std::function<void(xmlTextReader*)> > {
public:
    explicit XmlReader(xmlTextReader* ptr) noexcept :
        unique_ptr(ptr, xmlFreeTextReader) {
    }
};

}  // end of namespace DYN

#endif  // COMMON_DYNXMLREADER_H_
