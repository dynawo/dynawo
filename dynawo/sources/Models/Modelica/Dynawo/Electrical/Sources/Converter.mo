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

model Converter

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

  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at terminal in p.u (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at terminal in p.u (base UNom)";
  parameter Types.Angle deph0 "Start value of the phase shift between the converter's rotating frame and the grid rotating frame";
  parameter Types.PerUnit vcd0 "Start value of the d-axis modulated voltage created by the converter in p.u (base UNom)";
  parameter Types.PerUnit vcdref0 "Start value of the d-axis modulated voltage reference created by the converter in p.u (base UNom)";
  parameter Types.PerUnit vod0 "Start value of the d-axis voltage at the capacitor in p.u (base UNom)";
  parameter Types.PerUnit vgd0 "Start value of the d-axis voltage at the PCC in p.u (base UNom)";
  parameter Types.PerUnit icd0 "Start value of the d-axis current created by the converter in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit iod0 "Start value of the d-axis current at the PCC in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit vcq0 "Start value of the q-axis modulated voltage created by the converter in p.u (base UNom)";
  parameter Types.PerUnit vcqref0 "Start value of the q-axis modulated voltage reference created by the converter in p.u (base UNom)";
  parameter Types.PerUnit voq0 "Start value of the q-axis voltage at the capacitor in p.u (base UNom)";
  parameter Types.PerUnit vgq0 "Start value of the q-axis voltage at the PCC in p.u (base UNom)";
  parameter Types.PerUnit icq0 "Start value of the q-axis current created by the converter in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit ioq0 "Start value of the q-axis current at the PCC in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit idc0 "Start value of the DC source current in p.u (base SnRecConverter)";
  parameter Types.PerUnit ix0 "Start value of the DC current in p.u (base SnRecConverter)";
  parameter Types.PerUnit vdc0 "Start value of the DC voltage in p.u (base Unom)";
  parameter Types.PerUnit vdcref0 "Start value of the DC voltage reference in p.u (base Unom)";
  parameter Types.PerUnit omega0Pu;

  Types.PerUnit vcd(start=vcd0) "d-axis modulated voltage created by the converter in p.u (base UNom)";
  Types.PerUnit vod(start=vod0) "d-axis voltage at the converter's capacitor in p.u (base UNom)";
  Types.PerUnit vgd(start=vgd0) "d-axis voltage at the PCC in p.u (base UNom)";
  Types.PerUnit icd(start=icd0) "d-axis current created by the converter in p.u (base UNom, SNom) (generator convention)";
  Types.PerUnit iod(start=iod0) "d-axis current at the PCC in p.u (base UNom, SNom) (generator convention)";
  Types.PerUnit vcq(start=vcq0) "q-axis modulated voltage created by the converter in p.u (base UNom)";
  Types.PerUnit voq(start=voq0) "q-axis voltage at the converter's capacitor in p.u (base UNom)";
  Types.PerUnit vgq(start=vgq0) "q-axis voltage at the PCC in p.u (base UNom)";
  Types.PerUnit icq(start=icq0) "q-axis current created by the converter in p.u (base UNom, SNom) (generator convention)";
  Types.PerUnit ioq(start=ioq0) "q-axis current at the PCC in p.u (base UNom, SNom) (generator convention)";
  Types.PerUnit vdc(start = vdc0) "DC Voltage in p.u (base UNom)";
  Types.PerUnit ix(start = ix0) "DC Current in p.u (base UNom)";
  Types.PerUnit icmodule(start = sqrt(icd0 * icd0 + icq0 * icq0)) "current created by the converter in p.u (base UNom, SNom) (generator convention)";

  Connectors.ImPin idc(value(start = idc0)) "Phase shift between the voltage at the converter's capacitor and the voltage at terminal (in rad)";
  Connectors.ImPin vcdref(value(start = vcdref0)) "d-axis modulated voltage reference in p.u (base UNom)";
  Connectors.ImPin vcqref(value(start = vcdref0)) "q-axis modulated voltage reference in p.u (base UNom)";
  Connectors.ImPin vdcref(value(start = vdcref0)) "DC voltage reference in p.u (base UNom)";
  Connectors.ImPin deph(value(start = deph0)) "Phase shift between the converter's rotating frame and the grid rotating frame";
  Connectors.ImPin omegaPu(value(start = omega0Pu)) "Converter angular frequency in p.u (base OmegaNom)";
  Connectors.ACPower terminal (V (re (start = u0Pu.re), im (start = u0Pu.im)), i (re (start = i0Pu.re), im (start = i0Pu.im))) "Connector used to connect the converter to the grid";

  equation

  /* DQ reference frame change from network reference to converter reference and p.u base change */
  [vgd; vgq] = [cos(deph.value), sin(deph.value); -sin(deph.value), cos(deph.value)] * [terminal.V.re; terminal.V.im];
  [iod; ioq] = - [cos(deph.value), sin(deph.value); -sin(deph.value), cos(deph.value)] * [terminal.i.re; terminal.i.im] * SystemBase.SnRef / SNom;

  /* RL Transformer */
  Ltransformer / SystemBase.omegaNom * der(iod) = vod - Rtransformer * iod + omegaPu.value * Ltransformer * ioq - vgd;
  Ltransformer / SystemBase.omegaNom * der(ioq) = voq - Rtransformer * ioq - omegaPu.value * Ltransformer * iod - vgq;

  /* RLC Filter */
  Lfilter / SystemBase.omegaNom * der(icd) = vcd - Rfilter * icd + omegaPu.value * Lfilter * icq - vod;
  Lfilter / SystemBase.omegaNom * der(icq) = vcq - Rfilter * icq - omegaPu.value * Lfilter * icd - voq;
  Cfilter / SystemBase.omegaNom * der(vod) = icd + omegaPu.value * Cfilter * voq - iod;
  Cfilter / SystemBase.omegaNom * der(voq) = icq - omegaPu.value * Cfilter * vod - ioq;
  icmodule = sqrt (icd * icd + icq * icq);

  /* DC Side */
  CDC * der(vdc) = - GDC * vdc + idc.value - ix;

  /* Power Conservation */
  vcd * icd + vcq * icq = vdc * ix;

  /* AC Voltage Source */
  vcd=vcdref.value*vdc/vdcref.value;
  vcq=vcqref.value*vdc/vdcref.value;

end Converter;

