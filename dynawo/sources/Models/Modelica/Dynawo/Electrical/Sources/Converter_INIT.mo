within Dynawo.Electrical.Sources;

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

model Converter_INIT

  import Modelica.Math;
  import Modelica.ComplexMath;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit Rfilter "Filter resistance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Lfilter "Filter inductance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Cfilter "Filter capacitance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Rtransformer "Transformer resistance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Ltransformer "Transformer inductance in p.u (base UNom, SNom)";
  parameter Types.PerUnit CDC "DC capacitance in p.u (base UNom, SNom)";
  parameter Types.PerUnit GDC "DC conductance in p.u (base UNom, SNom)";
  parameter Types.ApparentPowerModule SNom "Apparent power module reference for the converter";

  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal in p.u (base UNom)";
  parameter Types.Angle UPhase0  "Start value of voltage angle at terminal in rad";
  parameter Types.PerUnit vdcref0 "Start value of the DC voltage reference in p.u (base Unom)";

  Types.ComplexPerUnit i0Pu "Start value of the complex current at terminal in p.u (base UNom, SnRef) (receptor convention)";
  Types.ComplexPerUnit u0Pu "Start value of the complex voltage at terminal in p.u (base UNom)";
  Types.Angle deph0 "Start value of the phase shift between the converter's rotating frame and the grid rotating frame";
  Types.PerUnit vcd0 "Start value of the d-axis modulated voltage created by the converter in p.u (base UNom)";
  Types.PerUnit vcdref0 "Start value of the d-axis modulated voltage reference created by the converter in p.u (base UNom)";
  Types.PerUnit vod0 "Start value of the d-axis voltage at the capacitor in p.u (base UNom)";
  Types.PerUnit vgd0 "Start value of the d-axis voltage at the PCC in p.u (base UNom)";
  Types.PerUnit icd0 "Start value of the d-axis current created by the converter in p.u (base UNom, SNom) (generator convention)";
  Types.PerUnit iod0 "Start value of the d-axis current at the PCC in p.u (base UNom, SNom) (generator convention)";
  Types.PerUnit vcq0 "Start value of the q-axis modulated voltage created by the converter in p.u (base UNom)";
  Types.PerUnit vcqref0 "Start value of the q-axis modulated voltage reference created by the converter in p.u (base UNom)";
  Types.PerUnit voq0 "Start value of the q-axis voltage at the capacitor in p.u (base UNom)";
  Types.PerUnit vgq0 "Start value of the q-axis voltage at the PCC in p.u (base UNom)";
  Types.PerUnit icq0 "Start value of the q-axis current created by the converter in p.u (base UNom, SNom) (generator convention)";
  Types.PerUnit ioq0 "Start value of the q-axis current at the PCC in p.u (base UNom, SNom) (generator convention)";
  Types.PerUnit idc0 "Start value of the DC source current in p.u (base SnRecConverter)";
  Types.PerUnit ix0 "Start value of the DC current in p.u (base SnRecConverter)";
  Types.PerUnit vdc0 "Start value of the DC voltage in p.u (base Unom)";
  Types.PerUnit omega0Pu "Start value of the converter frequency in p.u";

  equation

  [vgd0; vgq0] = [cos(deph0), sin(deph0); -sin(deph0), cos(deph0)] * [u0Pu.re; u0Pu.im];
  [iod0; ioq0] = - [cos(deph0), sin(deph0); -sin(deph0), cos(deph0)] * [i0Pu.re; i0Pu.im] * SystemBase.SnRef / SNom;
  0 = vod0 - Rtransformer * iod0 + omega0Pu * Ltransformer * ioq0 - vgd0;
  0 = voq0 - Rtransformer * ioq0 - omega0Pu * Ltransformer * iod0 - vgq0;
  0 = vcd0 - Rfilter * icd0 + omega0Pu * Lfilter * icq0 - vod0;
  0 = vcq0 - Rfilter * icq0 - omega0Pu * Lfilter * icd0 - voq0;
  0 = icd0 + omega0Pu * Cfilter * voq0 - iod0;
  0 = icq0 - omega0Pu * Cfilter * vod0 - ioq0;
  0 = - GDC * vdc0 + idc0 - ix0;
  vcd0 * icd0 + vcq0 * icq0 = vdcref0 * ix0;
  vcd0=vcdref0;
  vcq0=vcqref0;
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);

end Converter_INIT;

