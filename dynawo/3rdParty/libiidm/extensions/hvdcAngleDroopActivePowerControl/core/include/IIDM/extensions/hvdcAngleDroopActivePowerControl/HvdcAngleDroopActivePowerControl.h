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
 * @file IIDM/extensions/hvdcAngleDroopActivePowerControl/HvdcAngleDroopActivePowerControl.h
 * @brief Provides Extension interface
 */

#ifndef LIBIIDM_EXTENSIONS_HVDCANGLEDROOPACTIVEPOWERCONTROL_GUARD_HVDCANGLEDROOPACTIVEPOWERCONTROL_H
#define LIBIIDM_EXTENSIONS_HVDCANGLEDROOPACTIVEPOWERCONTROL_GUARD_HVDCANGLEDROOPACTIVEPOWERCONTROL_H

#include <IIDM/Extension.h>
#include <IIDM/cpp11.h>

#include <IIDM/components/HvdcLine.h>

namespace IIDM {
namespace extensions {
namespace hvdcangledroopactivepowercontrol {

class HvdcAngleDroopActivePowerControl : public IIDM::Extension {
// ****** Extension content ****** //
public:
    BOOST_TYPE_INDEX_REGISTER_CLASS

    IIDM_UNIQUE_PTR<HvdcAngleDroopActivePowerControl> clone() const { return IIDM_UNIQUE_PTR<HvdcAngleDroopActivePowerControl>(do_clone()); }

protected:
    virtual HvdcAngleDroopActivePowerControl* do_clone() const IIDM_OVERRIDE;

public:
    HvdcAngleDroopActivePowerControl(double p0, double droop, bool enabled);

    double p0() const {
        return m_p0;
    }

    HvdcAngleDroopActivePowerControl& p0(double p0) {
        m_p0 = checkP0(p0);
        return *this;
    }

    double droop() const {
        return m_droop;
    }

    HvdcAngleDroopActivePowerControl& droop(double droop) {
        m_droop = checkDroop(droop);
        return *this;
    }

    bool enabled() const {
        return m_enabled;
    }

    HvdcAngleDroopActivePowerControl& enabled(bool enabled) {
        m_enabled = enabled;
        return *this;
    }

    HvdcAngleDroopActivePowerControl& enable() {
        m_enabled = true;
        return *this;
    }

    HvdcAngleDroopActivePowerControl& disable() {
        m_enabled = false;
        return *this;
    }

private:
    double checkP0(double p0) const;
    double checkDroop(double droop) const;

private:
    double m_p0;
    double m_droop;
    bool m_enabled;

};

} // end of namespace IIDM::extensions::hvdcangledroopactivepowercontrol::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
