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

model Grid

  import Modelica.ComplexMath;

  import Dynawo.Connectors;
  import Dynawo.Types;

  parameter Types.VoltageModulePu URef "Reference phase-to-phase voltage at connection terminal";     // pu 380kV
  parameter Types.Angle UPhaseRef = 0 "Voltage phase angle at connection terminal";
  parameter Types.ApparentPowerModulePu SSC "Short-circuit capacity";                                    // PU SNOM snref ?!!
  parameter Types.PerUnit c = 1.1 "c-factor for calculation of short-circuit capacity";
  parameter Types.PerUnit R_X = 1/10 "Ratio of resistance to reactance of the grid";

  // Connectors.ACPower terminal(V(re (start = eStart.re), im (start = eStart.im)));
  // Connectors.ACPower terminal(V(re (start = ComplexMath.fromPolar(URef,UPhaseRef).re), im (start = ComplexMath.fromPolar(URef,UPhaseRef).im)));
  Connectors.ACPower terminal(V(re (start = 1), im (start = 0)));

  protected

  Types.ComplexApparentPowerPu Ssc "Short circuit active power";
  Types.ComplexImpedancePu ZGrid "Grid impedance";
  Types.Voltage eStart "Tentative value of voltage source";

equation

Ssc = ComplexMath.fromPolar(SSC/c, atan(1/R_X));
// ZGrid = 1/ComplexMath.conj(Ssc/URef ^ 2);
ZGrid = 1/ComplexMath.conj(Ssc/1 ^ 2);
eStart = ComplexMath.fromPolar(URef,UPhaseRef);

terminal.V = eStart + ZGrid*terminal.i;

end Grid;


model Grid_INIT
end Grid_INIT;
