within Dynawo.Electrical.Photovoltaics.WECC;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PVVoltageSource_INIT "Initialization model for WECC PV model with a voltage source as interface with the grid"

/*                uSource0Pu                                uInj0Pu                    u0Pu
     --------         |                                       |                         |
    | Source |--------+---->>--------RSourcePu+jXSourcePu-----+------RPu+jXPu-----<<----+---- terminal
     --------          iSource0Pu                                               i0Pu
*/

  extends AdditionalIcons.Init;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // Lines parameters
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in pu (base SnRef, UNom)";
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in pu (base SnRef, UNom)";
  parameter Types.PerUnit RSourcePu "Source resistance in pu (base SNom, UNom) (typically set to zero, typical: 0..0.01)";
  parameter Types.PerUnit XSourcePu "Source reactance in pu (base SNom, UNom) (typical: 0.05..0.2)";

  parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage magnitude at terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage phase angle at terminal in rad";

  Types.ComplexCurrentPu i0Pu "Start value of complex current in pu (base UNom, SnRef) (receptor convention)";
  Types.CurrentComponentPu Id0Pu "Start value of d-axis current in pu (base UNom, SNom) (generator convention)";
  Types.CurrentComponentPu Iq0Pu "Start value of q-axis current in pu (base UNom, SNom) (generator convention)";
  Types.ComplexCurrentPu iSource0Pu "Start value of complex current at source in pu (base UNom, SNom) (generator convention)";
  Types.ActivePowerPu PInj0Pu "Start value of active power at injector in pu (base SNom) (generator convention)";
  Types.PerUnit PF0 "Start value of power factor";
  Types.ReactivePowerPu QInj0Pu "Start value of reactive power at injector in pu (base SNom) (generator convention)";
  Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
  Types.ComplexApparentPowerPu sInj0Pu "Start value of complex apparent power at injector in pu (base SNom) (generator convention)";
  Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  Types.VoltageComponentPu UdInj0Pu "Start value of d-axis voltage at injector in pu (base UNom)";
  Types.VoltageModulePu UInj0Pu "Start value of voltage module at injector in pu (base UNom)";
  Types.ComplexVoltagePu uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  Types.Angle UInjPhase0 "Start value of voltage phase angle at injector in rad";
  Types.VoltageComponentPu UqInj0Pu "Start value of q-axis voltage at injector in pu (base UNom)";
  Types.ComplexVoltagePu uSource0Pu "Start value of complex voltage at source in pu (base UNom)";

equation
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  s0Pu = Complex(P0Pu, Q0Pu);
  i0Pu = ComplexMath.conj(s0Pu / u0Pu);
  iSource0Pu = - i0Pu * SystemBase.SnRef / SNom;
  uSource0Pu = u0Pu - Complex(RPu + RSourcePu * SystemBase.SnRef / SNom, XPu + XSourcePu * SystemBase.SnRef / SNom) * i0Pu;
  uInj0Pu = u0Pu - Complex(RPu, XPu) * i0Pu;
  UInj0Pu = ComplexMath.'abs'(uInj0Pu);
  UInjPhase0 = ComplexMath.arg(uInj0Pu);
  sInj0Pu = uInj0Pu * ComplexMath.conj(iSource0Pu);
  PInj0Pu = ComplexMath.real(sInj0Pu);
  QInj0Pu = ComplexMath.imag(sInj0Pu);
  PF0 = if (not(ComplexMath.'abs'(sInj0Pu) == 0)) then PInj0Pu / ComplexMath.'abs'(sInj0Pu) else 0;
  UdInj0Pu = cos(UInjPhase0) * uInj0Pu.re + sin(UInjPhase0) * uInj0Pu.im;
  UqInj0Pu = - sin(UInjPhase0) * uInj0Pu.re + cos(UInjPhase0) * uInj0Pu.im;
  Id0Pu = cos(UInjPhase0) * iSource0Pu.re + sin(UInjPhase0) * iSource0Pu.im;
  Iq0Pu = sin(UInjPhase0) * iSource0Pu.re - cos(UInjPhase0) * iSource0Pu.im;

  annotation(
    preferredView = "text");
end PVVoltageSource_INIT;
