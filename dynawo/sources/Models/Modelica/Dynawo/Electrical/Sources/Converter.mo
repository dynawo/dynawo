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
  parameter Types.ApparentPowerModule SNom "Apparent power module reference for the converter";

  Types.PerUnit vConvd(start=VConvdref0) "d-axis modulated voltage created by the converter in p.u (base UNom)";
  Types.PerUnit vFilterd(start=VFilterd0) "d-axis voltage at the converter's capacitor in p.u (base UNom)";
  Types.PerUnit vPCCd(start=VPCCd0) "d-axis voltage at the PCC in p.u (base UNom)";
  Types.PerUnit iConvd(start=IConvd0) "d-axis current created by the converter in p.u (base UNom, SNom) (generator convention)";
  Types.PerUnit iPCCd(start=IPCCd0) "d-axis current at the PCC in p.u (base UNom, SNom) (generator convention)";
  Types.PerUnit vConvq(start=VConvqref0) "q-axis modulated voltage created by the converter in p.u (base UNom)";
  Types.PerUnit vFilterq(start=VFilterq0) "q-axis voltage at the converter's capacitor in p.u (base UNom)";
  Types.PerUnit vPCCq(start=VPCCq0) "q-axis voltage at the PCC in p.u (base UNom)";
  Types.PerUnit iConvq(start=IConvq0) "q-axis current created by the converter in p.u (base UNom, SNom) (generator convention)";
  Types.PerUnit iPCCq(start=IPCCq0) "q-axis current at the PCC in p.u (base UNom, SNom) (generator convention)";
  Types.PerUnit vdc(start = Vdc0) "DC Voltage in p.u (base UNom)";
  Types.PerUnit ix(start = Idc0) "DC Current in p.u (base UNom)";
  Types.PerUnit iConvmodule(start = sqrt(IConvd0 * IConvd0 + IConvq0 * IConvq0)) "current created by the converter in p.u (base UNom, SNom) (generator convention)";

  Connectors.ImPin idc(value(start = Idc0)) "Phase shift between the voltage at the converter's capacitor and the voltage at terminal (in rad)";
  Connectors.ImPin vConvdref(value(start = VConvdref0)) "d-axis modulated voltage reference in p.u (base UNom)";
  Connectors.ImPin vConvqref(value(start = VConvdref0)) "q-axis modulated voltage reference in p.u (base UNom)";
  Connectors.ImPin vdcref(value(start = Vdc0)) "DC voltage reference in p.u (base UNom)";
  Connectors.ImPin theta(value(start = Theta0)) "Phase shift between the converter's rotating frame and the grid rotating frame";
  Connectors.ImPin omegaPu(value(start = SystemBase.omegaRef0Pu)) "Converter angular frequency in p.u (base OmegaNom)";
  Connectors.ACPower terminal (V (re (start = u0Pu.re), im (start = u0Pu.im)), i (re (start = i0Pu.re), im (start = i0Pu.im))) "Connector used to connect the converter to the grid";

protected

  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at terminal in p.u (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at terminal in p.u (base UNom)";
  parameter Types.Angle Theta0 "Start value of the phase shift between the converter's rotating frame and the grid rotating frame";
  parameter Types.PerUnit VConvdref0 "Start value of the d-axis modulated voltage reference created by the converter in p.u (base UNom)";
  parameter Types.PerUnit VFilterd0 "Start value of the d-axis voltage at the capacitor in p.u (base UNom)";
  parameter Types.PerUnit VPCCd0 "Start value of the d-axis voltage at the PCC in p.u (base UNom)";
  parameter Types.PerUnit IConvd0 "Start value of the d-axis current created by the converter in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IPCCd0 "Start value of the d-axis current at the PCC in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit VConvqref0 "Start value of the q-axis modulated voltage reference created by the converter in p.u (base UNom)";
  parameter Types.PerUnit VFilterq0 "Start value of the q-axis voltage at the capacitor in p.u (base UNom)";
  parameter Types.PerUnit VPCCq0 "Start value of the q-axis voltage at the PCC in p.u (base UNom)";
  parameter Types.PerUnit IConvq0 "Start value of the q-axis current created by the converter in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IPCCq0 "Start value of the q-axis current at the PCC in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit Idc0 "Start value of the DC source current in p.u (base SnRefConverter)";
  parameter Types.PerUnit Vdc0 "Start value of the DC voltage in p.u (base Unom)";

  equation

  /* DQ reference frame change from network reference to converter reference and p.u base change */
  [vPCCd; vPCCq] = [cos(theta.value), sin(theta.value); -sin(theta.value), cos(theta.value)] * [terminal.V.re; terminal.V.im];
  [iPCCd; iPCCq] = - [cos(theta.value), sin(theta.value); -sin(theta.value), cos(theta.value)] * [terminal.i.re; terminal.i.im] * SystemBase.SnRef / SNom;

  /* RL Transformer */
  Ltransformer / SystemBase.omegaNom * der(iPCCd) = vFilterd - Rtransformer * iPCCd + omegaPu.value * Ltransformer * iPCCq - vPCCd;
  Ltransformer / SystemBase.omegaNom * der(iPCCq) = vFilterq - Rtransformer * iPCCq - omegaPu.value * Ltransformer * iPCCd - vPCCq;

  /* RLC Filter */
  Lfilter / SystemBase.omegaNom * der(iConvd) = vConvd - Rfilter * iConvd + omegaPu.value * Lfilter * iConvq - vFilterd;
  Lfilter / SystemBase.omegaNom * der(iConvq) = vConvq - Rfilter * iConvq - omegaPu.value * Lfilter * iConvd - vFilterq;
  Cfilter / SystemBase.omegaNom * der(vFilterd) = iConvd + omegaPu.value * Cfilter * vFilterq - iPCCd;
  Cfilter / SystemBase.omegaNom * der(vFilterq) = iConvq - omegaPu.value * Cfilter * vFilterd - iPCCq;
  iConvmodule = sqrt (iConvd * iConvd + iConvq * iConvq);

  /* DC Side */
  CDC * der(vdc) = idc.value - ix;

  /* Power Conservation */
  vConvd * iConvd + vConvq * iConvq = vdc * ix;

  /* AC Voltage Source */
  vConvd=vConvdref.value*vdc/vdcref.value;
  vConvq=vConvqref.value*vdc/vdcref.value;

annotation(preferredView = "text");

end Converter;

