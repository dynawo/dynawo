within Dynawo.Electrical.PEIR.Converters.General.EPRI;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model EpriGFM_INIT "Initialization model for EpriGFM"
  extends AdditionalIcons.Init;
  extends Dynawo.Electrical.Controls.Converters.EpriGFM.Parameters.OmegaFlag;

  /*                uSource0Pu                                      u0Pu,uInj0Pu
     --------         |                                                 |
    | Source |--------+---->>--------RSourcePu+jXSourcePu---------<<----+---- terminal
     --------          iSource0Pu                                 i0Pu
*/

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA" annotation(
  Dialog(tab = "General"));

  // Line parameters
  parameter Types.PerUnit RSourcePu "Resistance in pu (base SNom, UNom), example value = 0.0015" annotation(
  Dialog(tab = "Circuit"));
  parameter Types.PerUnit XSourcePu "Reactance in pu (base SNom, UNom), example value = 0.15" annotation(
  Dialog(tab = "Circuit"));

  flow Types.ComplexCurrentPu i0Pu "Start value of complex current at converter's terminal in pu (base UNom, SnRef) (receptor convention)";
  Types.PerUnit IdConv0Pu "Start value of d-axis current of the converter in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit IqConv0Pu "Start value of q-axis current of the converter in pu (base UNom, SNom) (generator convention)";
  Types.ComplexPerUnit s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
  Types.ComplexVoltagePu u0Pu "Start value of complex voltage at converter's terminal in pu (base UNom)";
  Types.PerUnit UdConv0Pu "Start value of d-axis modulation voltage in pu (base UNom)";
  Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's terminal in pu (base UNom)";
  Types.PerUnit UqConv0Pu "Start value of q-axis modulation voltage in pu (base UNom)";
  Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's terminal in pu (base UNom)";

  // Initial parameters given by the user
  parameter Types.ActivePowerPu P0Pu "Start value of the active power at the converter's terminal in pu (base SnRef) (receptor convention)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of the reactive power at the converter's terminal in pu (base SnRef) (receptor convention)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at regulated bus in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));

equation
  s0Pu = Complex(P0Pu, Q0Pu);
  u0Pu = ComplexMath.fromPolar(U0Pu, Theta0);
  i0Pu = ComplexMath.conj(s0Pu / u0Pu);
  IdConv0Pu = - (SystemBase.SnRef / SNom) * (cos(Theta0) * i0Pu.re + sin(Theta0) * i0Pu.im);
  IqConv0Pu = - (SystemBase.SnRef / SNom) * (- sin(Theta0) * i0Pu.re + cos(Theta0) * i0Pu.im);
  UdFilter0Pu = cos(Theta0) * u0Pu.re + sin(Theta0) * u0Pu.im;
  UqFilter0Pu = - sin(Theta0) * u0Pu.re + cos(Theta0) * u0Pu.im;
  UdConv0Pu = UdFilter0Pu + IdConv0Pu * RSourcePu - IqConv0Pu * XSourcePu;
  UqConv0Pu = UqFilter0Pu + IqConv0Pu * RSourcePu + IdConv0Pu * XSourcePu;

  annotation(
  preferredView = "text");
end EpriGFM_INIT;
