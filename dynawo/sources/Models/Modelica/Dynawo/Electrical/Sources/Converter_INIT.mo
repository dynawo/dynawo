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
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  extends AdditionalIcons.Init;

  parameter Types.PerUnit Rfilter = 0.005 "Filter resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit Lfilter = 0.15 "Filter inductance in pu (base UNom, SNom)";
  parameter Types.PerUnit Cfilter = 0.066 "Filter capacitance in pu (base UNom, SNom)";
  parameter Types.PerUnit Rtransformer = 0.01 "Transformer resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit Ltransformer = 0.2 "Transformer inductance in pu (base UNom, SNom)";
  parameter Types.ApparentPowerModule SNom = 2220 * conv "Apparent power module reference for the converter";
  parameter Real conv = 0.6;

  parameter Types.VoltageModulePu U0Pu = 1   "Start value of voltage amplitude at terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 = 0.49 "Start value of voltage angle at terminal in rad";
  parameter Types.ActivePowerPu P0Pu = -19.98 * conv  "Start value of active power in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu = -9.68 * conv "Start value of reactive power in pu (base SnRef) (receptor convention)";

  Types.ComplexPerUnit i0Pu "Start value of the complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  Types.ComplexPerUnit u0Pu "Start value of the complex voltage at terminal in pu (base UNom)";
  Types.Angle Theta0  "Start value of the phase shift between the converter's rotating frame and the grid rotating frame";
  Types.PerUnit UdConv0Pu  "Start value of the d-axis modulated voltage reference created by the converter in pu (base UNom)";
  Types.PerUnit UdFilter0Pu   "Start value of the d-axis voltage at the capacitor in pu (base UNom)";
  Types.PerUnit UdPcc0Pu "Start value of the d-axis voltage at the PCC in pu (base UNom)";
  Types.PerUnit IdConv0Pu  "Start value of the d-axis current created by the converter in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit IdPcc0Pu   "Start value of the d-axis current at the PCC in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit UqConv0Pu "Start value of the q-axis modulated voltage reference created by the converter in pu (base UNom)";
  Types.PerUnit UqPcc0Pu  "Start value of the q-axis voltage at the PCC in pu (base UNom)";
  Types.PerUnit IqConv0Pu  "Start value of the q-axis current created by the converter in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit IqPcc0Pu     "Start value of the q-axis current at the PCC in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit IdcSource0Pu  "Start value of the DC source current in pu (base SnRefConverter)";
  Types.PerUnit UdcSource0Pu   "Start value of the DC voltage in pu (base Unom)";
  Types.PerUnit PRef0Pu;
  Types.PerUnit QRef0Pu;
  Types.PerUnit IdcSourceRef0Pu;
  parameter Types.ComplexImpedancePu ZTransfoPu (re = 0, im = 0.00675);
  Types.ComplexPerUnit itransfo;

  equation

  ComplexMath.fromPolar(U0Pu, UPhase0) * ComplexMath.conj(itransfo) = Complex((1-conv)*19.98,(1-conv)*9.68);
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0) - ZTransfoPu *itransfo ;
  Complex(P0Pu, Q0Pu) = u0Pu * ComplexMath.conj(i0Pu);

  /* DQ reference frame change from network reference to converter reference and pu base change */
  [UdPcc0Pu; UqPcc0Pu] = [cos(Theta0), sin(Theta0); -sin(Theta0), cos(Theta0)] * [u0Pu.re; u0Pu.im];
  [IdPcc0Pu; IqPcc0Pu] = - [cos(Theta0), sin(Theta0); -sin(Theta0), cos(Theta0)] * [i0Pu.re; i0Pu.im] * SystemBase.SnRef / SNom;

  /* RL Transformer */
  0 = UdFilter0Pu - Rtransformer * IdPcc0Pu + SystemBase.omegaRef0Pu * Ltransformer * IqPcc0Pu - UdPcc0Pu;
  0 = - Rtransformer * IqPcc0Pu - SystemBase.omegaRef0Pu * Ltransformer * IdPcc0Pu - UqPcc0Pu;

  /* RLC Filter */
  0 = UdConv0Pu - Rfilter * IdConv0Pu + SystemBase.omegaRef0Pu * Lfilter * IqConv0Pu - UdFilter0Pu;
  0 = UqConv0Pu - Rfilter * IqConv0Pu - SystemBase.omegaRef0Pu * Lfilter * IdConv0Pu;
  0 = IdConv0Pu - IdPcc0Pu;
  0 = IqConv0Pu - SystemBase.omegaRef0Pu * Cfilter * UdFilter0Pu - IqPcc0Pu;

  /* Power Conservation */
  UdConv0Pu * IdConv0Pu + UqConv0Pu * IqConv0Pu = UdcSource0Pu * IdcSource0Pu;
  PRef0Pu = UdFilter0Pu * IdPcc0Pu;
  PRef0Pu = IdcSourceRef0Pu * UdcSource0Pu;
  QRef0Pu =  - UdFilter0Pu * IqPcc0Pu;
  UdcSource0Pu = UdFilter0Pu;

annotation(preferredView = "text");

end Converter_INIT;

