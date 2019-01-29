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
 * @file IIDM/extensions/hvdcOperatorActivePowerRange/HvdcOperatorActivePowerRange.h
 * @brief Provides Extension interface
 */

#ifndef LIBIIDM_EXTENSIONS_HVDCOPERATORACTIVEPOWERRANGE_GUARD_HVDCOPERATORACTIVEPOWERRANGE_H
#define LIBIIDM_EXTENSIONS_HVDCOPERATORACTIVEPOWERRANGE_GUARD_HVDCOPERATORACTIVEPOWERRANGE_H

#include <IIDM/Extension.h>
#include <IIDM/cpp11.h>

#include <IIDM/components/HvdcLine.h>

namespace IIDM {
namespace extensions {
namespace hvdcoperatoractivepowerrange {

class HvdcOperatorActivePowerRange : public IIDM::Extension {
// ****** Extension content ****** //
public:
    BOOST_TYPE_INDEX_REGISTER_CLASS

    IIDM_UNIQUE_PTR<HvdcOperatorActivePowerRange> clone() const { return IIDM_UNIQUE_PTR<HvdcOperatorActivePowerRange>(do_clone()); }

protected:
    virtual HvdcOperatorActivePowerRange* do_clone() const IIDM_OVERRIDE;

public:
    HvdcOperatorActivePowerRange(double oprFromCS1toCS2, double oprFromCS2toCS1);

    double oprFromCS1toCS2() const {
        return m_oprFromCS1toCS2;
    }

    HvdcOperatorActivePowerRange& oprFromCS1toCS2(double oprFromCS1toCS2) {
        m_oprFromCS1toCS2 = checkOpr(oprFromCS1toCS2);
        return *this;
    }

    double oprFromCS2toCS1() const {
        return m_oprFromCS2toCS1;
    }

    HvdcOperatorActivePowerRange& oprFromCS2toCS1(double oprFromCS2toCS1) {
        m_oprFromCS2toCS1 = checkOpr(oprFromCS2toCS1);
        return *this;
    }

private:
    double checkOpr(double opr) const; // TODO: Add CS parameters for logging purpose

private:
    double m_oprFromCS1toCS2;
    double m_oprFromCS2toCS1;
};

} // end of namespace IIDM::extensions::hvdcoperatoractivepowerrange::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
