within Dynawo.Electrical.Wind.WECC;

model WTG4CurrentSource_INIT "Initialization model for WECC Wind model with a current source as interface with the grid"
  /*
    * Copyright (c) 2026, RTE (http://www.rte-france.com)
    * See AUTHORS.txt
    * All rights reserved.
    * This Source Code Form is subject to the terms of the Mozilla Public
    * License, v. 2.0. If a copy of the MPL was not distributed with this
    * file, you can obtain one at http://mozilla.org/MPL/2.0/.
    * SPDX-License-Identifier: MPL-2.0
    *
    * This file is part of Dynawo, a hybrid C++/Modelica open source suite
    * of simulation tools for power systems.
    */
  extends AdditionalIcons.Init;
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsPCS;
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  parameter Types.ActivePowerPu PPcc0Pu "Initial active power at the external bus controlled by the PPC (used when PPCLocal = False) (receptor convention, base UNom, SnRef) (only if the PCS is defined outside of the model)" annotation(
    Dialog(enable = not PPCLocal));
  parameter Types.ReactivePowerPu QPcc0Pu "Initial reactive power at the external bus controlled by the PPC (used when PPCLocal = False) (receptor convention, base UNom, SnRef) (only if the PCS is defined outside of the model)" annotation(
    Dialog(enable = not PPCLocal));
  parameter Types.VoltageModulePu UPcc0Pu "Start value of voltage magnitude at PPC regulated bus in pu (bae UNom)" annotation(
    Dialog(enable = not PPCLocal));
  parameter Types.Angle UPhasePcc0 = 1 "Start value of voltage phase angle at PPC regulated bus in rad" annotation(
    Dialog(enable = not PPCLocal));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at converter terminal in pu (receptor convention) (base SnRef)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at converter terminal in pu (receptor convention) (base SnRef)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage magnitude at converter terminal in pu (bae UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage phase angle at converter terminal in rad";

  // Torque control parameters
  parameter Types.PerUnit P1 = 0 "1st power point for extrapolation table" annotation(
    Dialog(tab = "Torque control"));
  parameter Types.PerUnit Spd1 = 1 "1st speed point for extrapolation table" annotation(
    Dialog(tab = "Torque control"));
  parameter Types.PerUnit P2 = 1 "2nd power point for extrapolation table" annotation(
    Dialog(tab = "Torque control"));
  parameter Types.PerUnit Spd2 = 1 "2nd speed point for extrapolation table" annotation(
    Dialog(tab = "Torque control"));
  parameter Types.PerUnit P3 = 2 "3rd power point for extrapolation table" annotation(
    Dialog(tab = "Torque control"));
  parameter Types.PerUnit Spd3 = 1 "3rd speed point for extrapolation table" annotation(
    Dialog(tab = "Torque control"));
  parameter Types.PerUnit P4 = 3 "4th power point for extrapolation table" annotation(
    Dialog(tab = "Torque control"));
  parameter Types.PerUnit Spd4 = 1 "4th speed point for extrapolation table" annotation(
    Dialog(tab = "Torque control"));

  Types.ComplexCurrentPu i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  Types.PerUnit Id0Pu "Start value of d-axis current at injector in pu (base UNom, SNom) (generator convention)";
  Types.ComplexPerUnit iConv0Pu "Start value of complex current at converter terminal in pu (base UNom, SNom) (generator convention)";
  Types.ComplexPerUnit iInj0Pu "Start value of complex current at injector in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit Iq0Pu "Start value of q-axis current at injector in pu (base UNom, SNom) (generator convention)";
  Types.ComplexPerUnit iPcc0Pu "Start value of complex current at external PCC in pu (used when PPCLocal = False, meaning the PCS is defined outside of the model) (receptor convention) (base UNom, SnRef)" annotation(
    Dialog(enable = not PPCLocal));
  Types.PerUnit PInj0Pu "Start value of active power at injector in pu (base SNom) (generator convention)";
  Types.ActivePowerPu PConv0Pu "Start value of active power at converter terminal in pu (base SNom) (generator convention)";
  Types.PerUnit PF0 "Start value of power factor";
  Types.PerUnit QInj0Pu "Start value of reactive power at injector in pu (base SNom) (generator convention)";
  Types.ReactivePowerPu QConv0Pu "Start value of reactive power at converter terminal in pu (base SNom) (generator convention)";
  Types.ComplexPerUnit s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
  Types.ComplexPerUnit sConv0Pu "Start value of complex apparent power at converter in pu (base SNom) (generator convention)";
  Types.ComplexPerUnit sInj0Pu "Start value of complex apparent power at injector in pu (base SNom) (generator convention)";
  Types.ComplexPerUnit sPcc0Pu "Start value of complex apparent power at external PCC in pu (used when PPCLocal = False, meaning the PCS is defined outside of the model) (receptor convention) (base UNom, SnRef)" annotation(
    Dialog(enable = not PPCLocal));
  Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  Types.VoltageModulePu UConv0Pu "Start value of voltage module at converter terminal in pu (base UNom)";
  Types.ComplexPerUnit uConv0Pu "Start value of complex voltage at converter terminal in pu (base UNom)";
  Types.VoltageModulePu UInj0Pu "Start value of voltage module at injector in pu (base UNom)";
  Types.ComplexPerUnit uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  Types.Angle UPhaseConv0 "Value of voltage phase angle at converter terminal in rad";
  Types.ComplexVoltagePu uPcc0Pu "Initial voltage module at the external bus controlled by the PPC (used when PPCLocal = False, meaning the PCS is defined outside of the model) (base UNom)" annotation(
    Dialog(enable = not PPCLocal));
  Types.AngularVelocityPu omegaRefWTGQPu0 "Start value of reference angular frequency of torque control in pu (base omegaNom)";Modelica.Blocks.Tables.CombiTable1D combiTable1D(table = [P1, Spd1; P2, Spd2; P3, Spd3; P4, Spd4]) annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y = PInj0Pu) annotation(
    Placement(transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}})));
equation
//Regulated bus electrical quantities
  iPcc0Pu = ComplexMath.conj(sPcc0Pu/uPcc0Pu);
  uPcc0Pu = ComplexMath.fromPolar(UPcc0Pu, UPhasePcc0);
  sPcc0Pu = Complex(PPcc0Pu, QPcc0Pu);
//Converter terminal electrical quantities
  i0Pu = ComplexMath.conj(s0Pu/u0Pu);
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  s0Pu = Complex(P0Pu, Q0Pu);
//Converter terminal electrical quantities
  UConv0Pu = ComplexMath.'abs'(uConv0Pu);
  iConv0Pu = (-i0Pu*SystemBase.SnRef/SNom)/rTfoPu + Complex(GPcsPu, BPcsPu)*uConv0Pu;
  uConv0Pu = rTfoPu*u0Pu - Complex(RPcsPu, XPcsPu)*(i0Pu*SystemBase.SnRef/SNom)/rTfoPu;
  sConv0Pu = uConv0Pu*ComplexMath.conj(iConv0Pu);
  PConv0Pu = ComplexMath.real(sConv0Pu);
  QConv0Pu = ComplexMath.imag(sConv0Pu);
  UPhaseConv0 = ComplexMath.arg(uConv0Pu);
//Injector terminal electrical quantities
  iInj0Pu = iConv0Pu;
  uInj0Pu = uConv0Pu + Complex(RPu, XPu)*iConv0Pu;
  sInj0Pu = uInj0Pu*ComplexMath.conj(iInj0Pu);
  PInj0Pu = ComplexMath.real(sInj0Pu);
  QInj0Pu = ComplexMath.imag(sInj0Pu);
  UInj0Pu = ComplexMath.'abs'(uInj0Pu);
  PF0 = if (not (ComplexMath.'abs'(s0Pu) == 0)) then -P0Pu/ComplexMath.'abs'(s0Pu) else 0;
  Id0Pu = Modelica.Math.cos(UPhaseConv0)*iInj0Pu.re + Modelica.Math.sin(UPhaseConv0)*iInj0Pu.im;
  Iq0Pu = Modelica.Math.sin(UPhaseConv0)*iInj0Pu.re - Modelica.Math.cos(UPhaseConv0)*iInj0Pu.im;
  omegaRefWTGQPu0 = combiTable1D.y[1];
  connect(realExpression.y, combiTable1D.u[1]) annotation(
    Line(points = {{-48, 0}, {-12, 0}}, color = {0, 0, 127}));
  annotation(
    preferredView = "text");
end WTG4CurrentSource_INIT;
