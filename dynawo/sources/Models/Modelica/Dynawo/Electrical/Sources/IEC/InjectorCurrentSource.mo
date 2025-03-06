within Dynawo.Electrical.Sources.IEC;

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

model InjectorCurrentSource "Converter model and grid interface (IEC63406)"
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffInjector;

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //Circuit parameters
  parameter Types.PerUnit BesPu "Shunt susceptance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit GesPu "Shunt conductance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit ResPu "Serial resistance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit XesPu "Serial reactance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.Time Tg "Time constant to represent the control delay effect of the inner current control loop. Alternatively set it to zero to bypass this delay." annotation(
    Dialog(tab = "CurrentSource"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput ipRefPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current reference order in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqRefPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current reference order in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput thetaPLL(start = UPhase0) "Phase angle outputted by phase-locked loop" annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));

  //Output variables
  Modelica.ComplexBlocks.Interfaces.ComplexOutput iPu(re(start = -i0Pu.re * SystemBase.SnRef / SNom), im(start = -i0Pu.im * SystemBase.SnRef / SNom)) "generator convention" annotation(
    Placement(visible = true, transformation(origin = {108, -66}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexOutput uPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex voltage at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {108, -88}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Interfaces
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Grid terminal, complex voltage and current in pu (base UNom, SnRef) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {121, -3.55271e-15}, extent = {{-21, -21}, {21, 21}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.ComplexBlocks.ComplexMath.RealToComplex realToComplex annotation(
    Placement(visible = true, transformation(origin = {72, -66}, extent = {{-8, 8}, {8, -8}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.RealToComplex realToComplex1 annotation(
    Placement(visible = true, transformation(origin = {72, -88}, extent = {{-8, 8}, {8, -8}}, rotation = 0)));
  Dynawo.Electrical.Sources.IEC.BaseConverters.CurrentSourceIEC63406 currentSourceIEC63406(IGsIm0Pu = IsIm0Pu, IGsRe0Pu = IsRe0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, Tg = Tg, U0Pu = U0Pu, UGsIm0Pu = UsIm0Pu, UGsRe0Pu = UsRe0Pu, UPhase0 = UPhase0) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Sources.IEC.BaseConverters.ElecSystem elecSystem(BesPu = BesPu, GesPu = GesPu, IGsIm0Pu = IsIm0Pu, IGsRe0Pu = IsRe0Pu, ResPu = ResPu, SNom = SNom, UGsIm0Pu = UsIm0Pu, UGsRe0Pu = UsRe0Pu, XesPu = XesPu, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {40, 1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Initial parameters
  parameter Types.ComplexCurrentPu i0Pu "Initial complex current at grid terminal in pu (base UNom, SnRef) (receptor convention)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.PerUnit IsIm0Pu "Initial imaginary component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.PerUnit IsRe0Pu "Initial real component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.ComplexVoltagePu u0Pu "Initial complex voltage at grid terminal in pu (base UNom)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.PerUnit UsIm0Pu "Initial imaginary component of the voltage at converter terminal in pu (base UNom)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.PerUnit UsRe0Pu "Initial real component of the voltage at converter terminal in pu (base UNom)" annotation(
    Dialog(group = "Operating point"));
  parameter Types.Angle UPhase0 "Initial Phase angle outputted by phase-locked loop" annotation(
    Dialog(group = "Operating point"));

equation
  currentSourceIEC63406.running = running.value;

  connect(realToComplex1.y, uPu) annotation(
    Line(points = {{80.8, -88}, {107.8, -88}}, color = {85, 170, 255}));
  connect(realToComplex.y, iPu) annotation(
    Line(points = {{80.8, -66}, {107.8, -66}}, color = {85, 170, 255}));
  connect(thetaPLL, currentSourceIEC63406.thetaPLL) annotation(
    Line(points = {{-120, 60}, {-40, 60}, {-40, 22}}, color = {0, 0, 127}));
  connect(ipRefPu, currentSourceIEC63406.ipRefPu) annotation(
    Line(points = {{-120, 20}, {-80, 20}, {-80, 8}, {-62, 8}}, color = {0, 0, 127}));
  connect(iqRefPu, currentSourceIEC63406.iqRefPu) annotation(
    Line(points = {{-120, -20}, {-80, -20}, {-80, -8}, {-62, -8}}, color = {0, 0, 127}));
  connect(currentSourceIEC63406.terminal, elecSystem.terminal1) annotation(
    Line(points = {{-18, 0}, {18, 0}}, color = {0, 0, 255}));
  connect(elecSystem.terminal2, terminal) annotation(
    Line(points = {{62, 0}, {122, 0}}, color = {0, 0, 255}));
  connect(elecSystem.uWtRePu, realToComplex1.re) annotation(
    Line(points = {{22, -22}, {22, -92}, {62, -92}}, color = {0, 0, 127}));
  connect(elecSystem.uWtImPu, realToComplex1.im) annotation(
    Line(points = {{26, -22}, {26, -84}, {62, -84}}, color = {0, 0, 127}));
  connect(elecSystem.iWtRePu, realToComplex.re) annotation(
    Line(points = {{32, -22}, {32, -70}, {62, -70}}, color = {0, 0, 127}));
  connect(elecSystem.iWtImPu, realToComplex.im) annotation(
    Line(points = {{36, -22}, {36, -62}, {62, -62}}, color = {0, 0, 127}));

  annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(extent = {{-100, 100}, {100, -100}}, textString = "Injector")}));
end InjectorCurrentSource;
