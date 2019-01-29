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
 * @file xml/import/TapChangerHandler.cpp
 * @brief Provides PhaseTapChangerHandler and RatioTapChangerHandler definitions
 */

#include <IIDM/xml/import/TapChangerHandler.h>

#include <IIDM/xml/import/iidm_namespace.h>

#include "internals/import/TerminalReferenceHandler.h"

#include "internals/import/Handler_utils.h"

namespace xml {
namespace sax {
namespace parser {

template<>
Attributes::SearchedAttribute::operator IIDM::PhaseTapChanger::e_mode () const {
  if (!value) throw std::runtime_error("no value for attribute "+name);
  if (*value=="CURRENT_LIMITER") return IIDM::PhaseTapChanger::mode_current_limiter;
  if (*value=="ACTIVE_POWER_CONTROL") return IIDM::PhaseTapChanger::mode_active_power_control;
  return IIDM::PhaseTapChanger::mode_fixed_tap;
}

} // end of namespace xml::sax::parser::
} // end of namespace xml::sax::
} // end of namespace xml::


namespace IIDM {
namespace xml {

void PhaseTapChangerHandler::do_startElement(elementName_type const& name, attributes_type const& attributes) {
  if (name == root_name) {
    tapchanger = 
      IIDM::PhaseTapChanger(
        attributes["lowTapPosition"],
        attributes["tapPosition"],
        attributes["regulationMode"]
      );
    tapchanger->regulating( attributes["regulating"].as< boost::optional<bool> >() );
    tapchanger->regulationValue( attributes["regulationValue"].as< boost::optional<double> >() );
    
  } else if (name == iidm_ns("terminalRef")) {
    tapchanger->terminalReference( make_terminalReference(attributes) );

  } else if (name == iidm_ns("step")) {
    tapchanger->add(attributes["r"], attributes["x"], attributes["g"], attributes["b"], attributes["rho"], attributes["alpha"]);
  }
}


void RatioTapChangerHandler::do_startElement(elementName_type const& name, attributes_type const& attributes) {
  if (name == root_name) {
    tapchanger = 
      IIDM::RatioTapChanger(
        attributes["lowTapPosition"],
        attributes["tapPosition"],
        attributes["loadTapChangingCapabilities"]
      );
    tapchanger->regulating( attributes["regulating"].as< boost::optional<bool> >() );
    tapchanger->targetV( attributes["targetV"].as< boost::optional<double> >() );
    
  } else if (name == iidm_ns("terminalRef")) {
    tapchanger->terminalReference( make_terminalReference(attributes) );

  } else if (name == iidm_ns("step")) {
    tapchanger->add(attributes["r"], attributes["x"], attributes["g"], attributes["b"], attributes["rho"]);
  }
}


} // end of namespace IIDM::xml::
} // end of namespace IIDM::
