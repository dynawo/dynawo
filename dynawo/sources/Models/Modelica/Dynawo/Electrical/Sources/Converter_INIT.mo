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

  extends AdditionalIcons.Init;

  parameter Types.PerUnit Rfilter "Filter resistance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Lfilter "Filter inductance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Cfilter "Filter capacitance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Rtransformer "Transformer resistance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Ltransformer "Transformer inductance in p.u (base UNom, SNom)";
  parameter Types.PerUnit CDC "DC capacitance in p.u (base UNom, SNom)";
  parameter Types.ApparentPowerModule SNom "Apparent power module reference for the converter";

  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal in p.u (base UNom)";
  parameter Types.Angle UPhase0  "Start value of voltage angle at terminal in rad";
  parameter Types.ActivePowerPu P0Pu  "Start value of active power in p.u (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu  "Start value of reactive power in p.u (base SnRef) (receptor convention)";

  Types.ComplexPerUnit i0Pu "Start value of the complex current at terminal in p.u (base UNom, SnRef) (receptor convention)";
  Types.ComplexPerUnit u0Pu "Start value of the complex voltage at terminal in p.u (base UNom)";
  Types.Angle Theta0 "Start value of the phase shift between the converter's rotating frame and the grid rotating frame";
  Types.PerUnit VConvdref0 "Start value of the d-axis modulated voltage reference created by the converter in p.u (base UNom)";
  Types.PerUnit VFilterd0 "Start value of the d-axis voltage at the capacitor in p.u (base UNom)";
  Types.PerUnit VPCCd0 "Start value of the d-axis voltage at the PCC in p.u (base UNom)";
  Types.PerUnit IConvd0 "Start value of the d-axis current created by the converter in p.u (base UNom, SNom) (generator convention)";
  Types.PerUnit IPCCd0 "Start value of the d-axis current at the PCC in p.u (base UNom, SNom) (generator convention)";
  Types.PerUnit VConvqref0 "Start value of the q-axis modulated voltage reference created by the converter in p.u (base UNom)";
  Types.PerUnit VFilterq0 "Start value of the q-axis voltage at the capacitor in p.u (base UNom)";
  Types.PerUnit VPCCq0 "Start value of the q-axis voltage at the PCC in p.u (base UNom)";
  Types.PerUnit IConvq0 "Start value of the q-axis current created by the converter in p.u (base UNom, SNom) (generator convention)";
  Types.PerUnit IPCCq0 "Start value of the q-axis current at the PCC in p.u (base UNom, SNom) (generator convention)";
  Types.PerUnit Idc0 "Start value of the DC source current in p.u (base SnRefConverter)";
  Types.PerUnit Vdc0 "Start value of the DC voltage in p.u (base Unom)";

  equation

  [VPCCd0; VPCCq0] = [cos(Theta0), sin(Theta0); -sin(Theta0), cos(Theta0)] * [u0Pu.re; u0Pu.im];
  [IPCCd0; IPCCq0] = - [cos(Theta0), sin(Theta0); -sin(Theta0), cos(Theta0)] * [i0Pu.re; i0Pu.im] * SystemBase.SnRef / SNom;
  0 = VFilterd0 - Rtransformer * IPCCd0 + SystemBase.omegaRef0Pu * Ltransformer * IPCCq0 - VPCCd0;
  0 = VFilterq0 - Rtransformer * IPCCq0 - SystemBase.omegaRef0Pu * Ltransformer * IPCCd0 - VPCCq0;
  0 = VConvdref0 - Rfilter * IConvd0 + SystemBase.omegaRef0Pu * Lfilter * IConvq0 - VFilterd0;
  0 = VConvqref0 - Rfilter * IConvq0 - SystemBase.omegaRef0Pu * Lfilter * IConvd0 - VFilterq0;
  0 = IConvd0 + SystemBase.omegaRef0Pu * Cfilter * VFilterq0 - IPCCd0;
  0 = IConvq0 - SystemBase.omegaRef0Pu * Cfilter * VFilterd0 - IPCCq0;
  VConvdref0 * IConvd0 + VConvqref0 * IConvq0 = Vdc0 * Idc0;
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  Complex(P0Pu, Q0Pu) = u0Pu * ComplexMath.conj(i0Pu);

annotation(preferredView = "text");

end Converter_INIT;

