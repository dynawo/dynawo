within Dynawo;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

package Types "Standard types for electrical variables"

  public

  package AC "types for AC variables"
    // voltages
    // record Voltage = Complex (re (VoltageComponent), im (VoltageComponent)) "AC voltage as complex number";
    record Voltage = Complex "AC voltage as complex number";
    type VoltageComponent = SIunits.Voltage "Real or imaginary part of complex AC voltage";
    type VoltageModule = SIunits.Voltage "AC voltage module";

    // currents
    // record Current = flow Complex (re (CurrentComponent), im (CurrentComponent)) "AC current as complex number";
    record Current = Complex "AC current as complex number";
    type CurrentComponent = SIunits.ElectricCurrent "Real or imaginary part of complex AC current";
    type CurrentModule = SIunits.ElectricCurrent "AC current module";

    // apparent power
    // record ApparentPower = Complex (re (ActivePower), im (ReactivePower)) "AC apparent power";
    record ApparentPower = Complex "AC apparent power";
    type ApparentPowerModule = Real (final unit = "MVA") "AC apparent power module";
    type ActivePower = SIunits.ActivePower "AC active power";
    type ReactivePower = SIunits.ReactivePower "AC reactive power";

    // impedance
    // record Impedance = Complex (re (Resistance), im (Reactance)) "Complex impedance";
    record Impedance = Complex "Complex impedance";
    record Admittance = Complex "Complex admittance";

  end AC;

end Types;
