within Dynawo.Electrical.Controls.Converters;

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

model IECWT4AControlVs_INIT "IEC Wind Turbine type 4A Control"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  extends AdditionalIcons.Init;

  /*Constructive parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  /*Electrical Parameters*/
  parameter Types.PerUnit Res "Electrical System resistance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Xes "Electrical System inductance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Ges "Electrical System shunt conductance in pu (Ubase, Sbase)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Bes "Electrical System shunt susceptance in pu (Ubase, Sbase)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Rfilter "Converter filter resistance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Lfilter "Converter filter inductance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Cfilter "Converter filter capacitance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));

  /*Parameters for initialization from load flow*/
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at plant terminal (PCC) in pu (base UNom)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.Angle UPhase0  "Start value of voltage angle at plan terminal (PCC) in rad" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in pu (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));

  Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in pu (base UNom)";
  Types.ComplexPerUnit i0Pu "Start value of the complex current at plant terminal (PCC) in pu (base UNom, SnRef)";

  Types.PerUnit UGsRe0Pu "Starting value of the real component of the voltage at the converter's terminals (generator system) in pu (base UNom)";
  Types.PerUnit UGsIm0Pu "Real component of the voltage at the converter's terminals (generator system) in pu (base UNom)";

  Types.PerUnit IGsRe0Pu "Initial value of the real component of the current at the generator system module (converter) terminal in pu (Ubase, SNom) in generator convention";
  Types.PerUnit IGsIm0Pu "Initial value of the imaginary component of the current at the generator system module (converter) terminal in pu (Ubase, SNom) in generator convention";

  Types.PerUnit UGsp0Pu "Start value of the d-axis voltage at the converter terminal (filter) in pu (base UNom)";
  Types.PerUnit UGsq0Pu "Start value of the q-axis voltage at the converter terminal (filter) in pu (base UNom)";

  Types.PerUnit IGsp0Pu "Start value of the d-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit IGsq0Pu "Start value of the q-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)";

  Types.PerUnit IpConv0Pu "Start value of the d-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit IqConv0Pu "Start value of the q-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)";

  Types.PerUnit UpCmd0Pu "Start value of the d-axis voltage at the converter terminal (filter) in pu (base UNom)";
  Types.PerUnit UqCmd0Pu "Start value of the q-axis voltage at the converter terminal (filter) in pu (base UNom)";

equation

  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0) "Start value of the complex voltage at plant terminal (PCC) in pu (base UNom)";
  i0Pu = ComplexMath.conj(Complex(P0Pu, Q0Pu) / u0Pu) "Start value of the complex current at plant terminal (PCC) in pu (base UNom, SnRef)";

  UGsRe0Pu = u0Pu.re - Res * (i0Pu.re* SystemBase.SnRef / SNom) + Xes * (i0Pu.im* SystemBase.SnRef / SNom) "Starting value of the real component of the voltage at the converter's terminals (generator system) in pu (base UNom)";
  UGsIm0Pu = u0Pu.im - Res * (i0Pu.im* SystemBase.SnRef / SNom) - Xes * (i0Pu.re* SystemBase.SnRef / SNom) "Real component of the voltage at the converter's terminals (generator system) in pu (base UNom)";

  IGsRe0Pu = (-i0Pu.re * SystemBase.SnRef / SNom) + (u0Pu.re * Ges - u0Pu.im*Bes) "Initial value of the real component of the current at the generator system module (converter) terminal in pu (Ubase, SNom) in generator convention";
  IGsIm0Pu = (-i0Pu.im * SystemBase.SnRef / SNom )+ (u0Pu.re * Bes + u0Pu.im * Ges) "Initial value of the imaginary component of the current at the generator system module (converter) terminal in pu (Ubase, SNom) in generator convention";

  UGsp0Pu = UGsRe0Pu * cos(UPhase0) + UGsIm0Pu * sin(UPhase0) "Start value of the d-axis voltage at the converter terminal (filter) in pu (base UNom)";
  UGsq0Pu = -UGsRe0Pu * sin(UPhase0) + UGsIm0Pu * cos(UPhase0) "Start value of the q-axis voltage at the converter terminal (filter) in pu (base UNom)";

  IGsp0Pu = IGsRe0Pu * cos(UPhase0) + IGsIm0Pu * sin(UPhase0) "Start value of the d-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)";
  IGsq0Pu = -IGsRe0Pu * sin(UPhase0) + IGsIm0Pu * cos(UPhase0) "Start value of the q-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)";

  IpConv0Pu = IGsp0Pu - SystemBase.omegaRef0Pu * Cfilter * UGsq0Pu "Start value of the d-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)";
  IqConv0Pu = IGsq0Pu + SystemBase.omegaRef0Pu * Cfilter * UGsp0Pu "Start value of the q-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)";

  UpCmd0Pu = UGsp0Pu + Rfilter * IpConv0Pu - SystemBase.omegaRef0Pu * Lfilter *IqConv0Pu "Start value of the d-axis voltage at the converter terminal (filter) in pu (base UNom)";
  UqCmd0Pu = UGsq0Pu + Rfilter * IqConv0Pu + SystemBase.omegaRef0Pu * Lfilter * IpConv0Pu "Start value of the q-axis voltage at the converter terminal (filter) in pu (base UNom)";

end IECWT4AControlVs_INIT;
