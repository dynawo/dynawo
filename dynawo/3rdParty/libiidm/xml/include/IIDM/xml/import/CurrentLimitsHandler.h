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
 * @file xml/import/CurrentLimitsHandler.h
 * @brief CurrentLimitsHandler interface file
 */

#ifndef LIBIIDM_XML_IMPORT_GUARD_CURRENTLIMITSHANDLER_H
#define LIBIIDM_XML_IMPORT_GUARD_CURRENTLIMITSHANDLER_H

#include <xml/sax/parser/SimpleElementHandler.h>

#include <boost/optional.hpp>

#include <IIDM/BasicTypes.h>
#include <IIDM/components/CurrentLimit.h>

#include <IIDM/cpp11.h>

namespace IIDM {
namespace xml {

class CurrentLimitsHandler : public ::xml::sax::parser::SimpleElementHandler {
public:
  boost::optional<IIDM::CurrentLimits> limits;

  explicit CurrentLimitsHandler(elementName_type const& root_name): root_name(root_name) {}

  void clear() { limits = boost::none;}

private:
  const elementName_type root_name;

protected:
  virtual void do_startElement(elementName_type const& name, attributes_type const& attributes) IIDM_OVERRIDE;
};



} // end of namespace IIDM::xml::
} // end of namespace IIDM::

#endif
