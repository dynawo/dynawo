within Dynawo.Examples.IEEE57.BaseClasses;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model IEEE57BaseHvdcPs "Base class for IEEE 57-bus system benchmark formed with 57 buses, 7 generators, 3 shunts, 16 transformers, 1 phase shifter, 63 lines, 1 HVDC line  and 42 loads"

  extends Dynawo.Examples.IEEE57.BaseClasses.IEEE57Base(redeclare Dynawo.Electrical.Transformers.TransformerPhaseTapChanger TfoB7B29(BPu = 0.0 * ZBASE13_8, GPu = 0.0 * ZBASE13_8, RPu = 0.0 / ZBASE13_8, XPu = 0.12340521 / ZBASE13_8, NbTap = 13, RatioTfo0Pu = 1, Tap0 = 6, AlphaTfoMax = -0.05, AlphaTfoMin = 0.05, i10Pu = Complex(0.614995, -0.11085), i20Pu = Complex(-0.614995, 0.11085), u10Pu = Complex(0.982429, 0.0376055), u20Pu = Complex(0.975246, -0.00224616), U20Pu = 0.975249));
  import Dynawo.Electrical.Machines.OmegaRef.GeneratorPV.QStatus;

  // HVDC with AC emulation
  Dynawo.Electrical.HVDC.HvdcPV.HvdcPV HvdcLineB29B52(KLosses = 1, Lambda1Pu = 0, Lambda2Pu = 0, NbSwitchOffSignalsSide1 = 2, PMaxPu = 10000, Q1MaxPu = 100, Q1MinPu = -100, Q1Nom = 200, Q1Ref0Pu = 0.026, Q2MaxPu = 100, Q2MinPu = -100, Q2Nom = 200, Q2Ref0Pu = 0.022, U1Ref0Pu = 1, U2Ref0Pu = 1, UPhase10 = -0.00230319, UPhase20 = -0.00274936, limUQDown10 = false, limUQDown20 = false, limUQUp10 = false, limUQUp20 = false, modeU10 = true, modeU20 = true, q1Status0 = Dynawo.Electrical.HVDC.HvdcPV.HvdcPV.QStatus.Standard, q2Status0 = Dynawo.Electrical.HVDC.HvdcPV.HvdcPV.QStatus.Standard, s10Pu = Complex(0.1894, 0.026), s20Pu = Complex(-0.1894, 0.022), u10Pu = Complex(0.975246, -0.00224619), u20Pu = Complex(0.968767, -0.0026635), P1Ref0Pu = 0.17, i10Pu = Complex(0.185421, -0.027087), i20Pu = Complex(-0.186785, -0.0221957));
  Dynawo.Electrical.HVDC.BaseControls.ACEmulation AcEmulation(KACEmulation = 2, tFilter = 25, PRef0Pu = 0.17, Theta10 = -0.0031, Theta20 = -0.0305, PRefSet0Pu = 0.18);

  // Phase Shifter Controller
  Dynawo.Electrical.Controls.Transformers.PhaseShifterP PhaseShifterB7B29(P0 = 59, PDeadBand = 0.5, PTarget = 60, state0 = Dynawo.Electrical.Controls.Transformers.BaseClasses.TapChangerPhaseShifterParams.State.Standard, t1st = 25, tNext = 10, tap0 = 6, tapMax = 12, tapMin = 0);

  equation
// HVDC control
  HvdcLineB29B52.Theta1 = AcEmulation.Theta1;
  HvdcLineB29B52.Theta2 = AcEmulation.Theta2;

// Network connections
  connect(HvdcLineB29B52.terminal1, Bus29.terminal);
  connect(HvdcLineB29B52.terminal2, Bus52.terminal);

  annotation(
    preferredView = "text");
end IEEE57BaseHvdcPs;
