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
 * @file src/components/CurrentLimit.cpp
 * @brief CurrentLimit implementation file
 */

#include <IIDM/components/TapChanger.h>

namespace IIDM {

RatioTapChangerStep::RatioTapChangerStep(double r, double x, double g, double b, double rho):
  r(r), x(x), g(g), b(b), rho(rho)
{}


RatioTapChanger::RatioTapChanger(int lowStepPosition, int position, bool loadTapChangingCapabilities):
  TapChanger<RatioTapChanger,RatioTapChangerStep>(lowStepPosition, position),
  m_targetV(boost::none),
  m_loadTapChangingCapabilities(loadTapChangingCapabilities)
{}




PhaseTapChangerStep::PhaseTapChangerStep(double r, double x, double g, double b, double rho, double alpha):
  r(r), x(x), g(g), b(b), rho(rho), alpha(alpha)
{}


PhaseTapChanger::PhaseTapChanger(int lowStepPosition, int position, e_mode regulationMode):
  TapChanger<PhaseTapChanger,PhaseTapChangerStep>(lowStepPosition, position),
  m_regulationMode(regulationMode),
  m_regulationValue(boost::none)
{}



} // end of namespace IIDM::
