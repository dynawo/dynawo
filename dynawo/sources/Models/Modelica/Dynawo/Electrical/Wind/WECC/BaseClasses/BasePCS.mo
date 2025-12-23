within Dynawo.Electrical.Wind.WECC.BaseClasses;

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

model BasePCS "Base model of the Power Collection System to be extended in the WECC models of power plants"
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsPCS;

  //Interface
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {140, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(extent = {{120, -10}, {100, 10}}, rotation = 0)));
  //Input variables
  Modelica.Blocks.Interfaces.RealInput PPccPu(start = PPcc0Pu) "Active power setpoint at regulated bus in pu (receptor convention) (base SnRef) (used only when PPCLocal = false)" annotation(
    Placement(visible = true, transformation(origin = {140, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput QPccPu(start = QPcc0Pu) "Reactive power setpoint at regulated bus in pu (receptor convention) (base SnRef) (used only when PPCLocal = false)" annotation(
    Placement(visible = true, transformation(origin = {140, 38}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPccPu(im(start = uPcc0Pu.im), re(start = uPcc0Pu.re)) "Complex voltage at PPC regulated bus in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {140, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(extent = {{120, 60}, {100, 80}}, rotation = 0)));

  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {25, 70}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal annotation(
    Placement(visible = true, transformation(origin = {99, 54}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch3 annotation(
    Placement(visible = true, transformation(origin = {25, 85}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(visible = true, transformation(origin = {25, 55}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = PPCLocal) annotation(
    Placement(visible = true, transformation(origin = {40, 115}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.ComplexBlocks.ComplexMath.RealToComplex i annotation(
    Placement(visible = true, transformation(origin = {-15, 93}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.RealToComplex u annotation(
    Placement(visible = true, transformation(origin = {-15, 63}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch4 annotation(
    Placement(visible = true, transformation(origin = {25, 100}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal1 annotation(
    Placement(visible = true, transformation(origin = {99, 84}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.Measurements WTGTerminalMeasurements(SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {115, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression QRegPuSnExtern(y = -SystemBase.SnRef/SNom*QPccPu) annotation(
    Placement(transformation(origin = {59, 35.5}, extent = {{13, -7.5}, {-13, 7.5}})));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {25, 23}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch5 annotation(
    Placement(visible = true, transformation(origin = {25, 39}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression PRegPuSnExtern(y = -SystemBase.SnRef/SNom*PPccPu) annotation(
    Placement(visible = true, transformation(origin = {59, 19.5}, extent = {{13, -7.5}, {-13, 7.5}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = SNom/SystemBase.SnRef) annotation(
    Placement(visible = true, transformation(origin = {64, 104}, extent = {{4, -4}, {-4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = SNom/SystemBase.SnRef) annotation(
    Placement(visible = true, transformation(origin = {64, 88}, extent = {{4, -4}, {-4, 4}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal2 annotation(
    Placement(visible = true, transformation(origin = {99, 100}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal3 annotation(
    Placement(visible = true, transformation(origin = {99, 70}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformersFixedTap.TransformerFixedRatio TfoPCS(BPu = BPcsPu*SNom/SystemBase.SnRef, GPu = GPcsPu*SNom/SystemBase.SnRef, RPu = RPcsPu*SystemBase.SnRef/SNom, XPu = XPcsPu*SystemBase.SnRef/SNom, rTfoPu = rTfoPu) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Sources.ComplexExpression complexExpr(y = ComplexMath.conj(Complex(PPccPu, QPccPu)/uPccPu))  annotation(
    Placement(transformation(origin = {134, 84}, extent = {{10, -10}, {-10, 10}})));

  //Initial parameters
  parameter Types.ComplexPerUnit i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.ComplexCurrentPu iControl0Pu = if PPCLocal then i0Pu else iPcc0Pu "Initial complex current to be controlled by the PPC coming either from the external bus or from the model's output terminal (receptor convention, base UNom, SnRef)";
  parameter Types.ComplexPerUnit iPcc0Pu "Start value of complex current at external PCC in pu (used when PPCLocal = False, meaning the PCS is defined outside of the model) (receptor convention) (base UNom, SnRef)";
  parameter Types.PerUnit P0Pu "Start value of active power at converter terminal in pu (receptor convention) (base SnRef)";
  final parameter Types.ActivePowerPu PControl0Pu = if PPCLocal then -P0Pu*SystemBase.SnRef/SNom else -PPcc0Pu*SystemBase.SnRef/SNom "Initial active power at the point controlled by the PPC (either model's output terminal or external PCC) (base SNom, generator convetion)";
  parameter Types.PerUnit PPcc0Pu = 1 "Initial active power at the external bus controlled by the PPC (used when PPCLocal = False) (receptor convention, base UNom, SnRef) (only if the PCS is defined outside of the model)" annotation(
    Dialog(tab = "Operating point", enable = not PPCLocal));
  parameter Types.PerUnit Q0Pu "Start value of reactive power at converter terminal in pu (receptor convention) (base SnRef)";
  final parameter Types.ReactivePowerPu QControl0Pu = if PPCLocal then -Q0Pu*SystemBase.SnRef/SNom else -QPcc0Pu*SystemBase.SnRef/SNom "Initial reactive power at the point controlled by the PPC (either model's output terminal or external PCC) (base SNom, generator convention)";
  parameter Types.PerUnit QPcc0Pu = 1 "Initial reactive power at the external bus controlled by the PPC (used when PPCLocal = False) (receptor convention, base UNom, SnRef) (only if the PCS is defined outside of the model)" annotation(
    Dialog(tab = "Operating point", enable = not PPCLocal));
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at converter terminal in pu (base UNom)";
  parameter Types.ComplexPerUnit u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  final parameter Types.ComplexVoltagePu uControl0Pu = if PPCLocal then u0Pu else uPcc0Pu "Initial complex voltage to be controlled by the PPC coming either from the external bus or from the model's output terminal (base UNom)";
  parameter Types.ComplexPerUnit uPcc0Pu "Initial voltage module at the external bus controlled by the PPC (used when PPCLocal = False, meaning the PCS is defined outside of the model) (base UNom)" annotation(
    Dialog(tab = "Operating point", enable = not PPCLocal));
  parameter Types.PerUnit UPcc0Pu = 1 "Start value of voltage magnitude at regulated bus in pu (base UNom)";

equation
  TfoPCS.switchOffSignal1.value = false;
  TfoPCS.switchOffSignal2.value = false;

  connect(booleanConstant.y, switch4.u2) annotation(
    Line(points = {{40, 109.5}, {40, 100}, {31, 100}}, color = {255, 0, 255}));
  connect(booleanConstant.y, switch3.u2) annotation(
    Line(points = {{40, 109.5}, {40, 85}, {31, 85}}, color = {255, 0, 255}));
  connect(booleanConstant.y, switch2.u2) annotation(
    Line(points = {{40, 109.5}, {40, 55}, {31, 55}}, color = {255, 0, 255}));
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{40, 109.5}, {40, 70}, {31, 70}}, color = {255, 0, 255}));
  connect(QRegPuSnExtern.y, switch5.u3) annotation(
    Line(points = {{45, 35.5}, {45, 35}, {30.7, 35}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch5.u2) annotation(
    Line(points = {{40, 110}, {40, 39}, {31, 39}}, color = {255, 0, 255}));
  connect(booleanConstant.y, switch.u2) annotation(
    Line(points = {{40, 110}, {40, 23}, {31, 23}}, color = {255, 0, 255}));
  connect(switch2.y, u.im) annotation(
    Line(points = {{19.5, 55}, {-1.25, 55}, {-1.25, 60}, {-9, 60}}, color = {0, 0, 127}));
  connect(switch1.y, u.re) annotation(
    Line(points = {{19.5, 70}, {-1.25, 70}, {-1.25, 66}, {-9, 66}}, color = {0, 0, 127}));
  connect(switch4.y, i.re) annotation(
    Line(points = {{19.5, 100}, {-0.5, 100}, {-0.5, 96}, {-9, 96}}, color = {0, 0, 127}));
  connect(switch3.y, i.im) annotation(
    Line(points = {{19.5, 85}, {-0.5, 85}, {-0.5, 90}, {-9, 90}}, color = {0, 0, 127}));
  connect(uPccPu, complexToReal.u) annotation(
    Line(points = {{140, 60}, {123, 60}, {123, 54}, {105, 54}}, color = {85, 170, 255}));
  connect(PRegPuSnExtern.y, switch.u3) annotation(
    Line(points = {{45, 19.5}, {32.7, 19.5}}, color = {0, 0, 127}));
  connect(complexToReal.im, switch2.u3) annotation(
    Line(points = {{93, 51}, {31, 51}}, color = {0, 0, 127}));
  connect(complexToReal.re, switch1.u3) annotation(
    Line(points = {{93, 57}, {90, 57}, {90, 66}, {31, 66}}, color = {0, 0, 127}));
  connect(complexToReal1.im, switch3.u3) annotation(
    Line(points = {{93, 81}, {31, 81}}, color = {0, 0, 127}));
  connect(gain1.y, switch3.u1) annotation(
    Line(points = {{60, 88}, {46, 88}, {46, 90}, {32, 90}}, color = {0, 0, 127}));
  connect(complexToReal1.re, switch4.u3) annotation(
    Line(points = {{93, 87}, {90, 87}, {90, 96}, {31, 96}}, color = {0, 0, 127}));
  connect(gain.y, switch4.u1) annotation(
    Line(points = {{60, 104}, {32, 104}}, color = {0, 0, 127}));
  connect(WTGTerminalMeasurements.uPu, complexToReal3.u) annotation(
    Line(points = {{116, 6}, {116, 70}, {106, 70}}, color = {85, 170, 255}));
  connect(complexToReal3.im, switch2.u1) annotation(
    Line(points = {{94, 68}, {80, 68}, {80, 60}, {32, 60}}, color = {0, 0, 127}));
  connect(complexToReal3.re, switch1.u1) annotation(
    Line(points = {{94, 74}, {32, 74}}, color = {0, 0, 127}));
  connect(WTGTerminalMeasurements.iPu, complexToReal2.u) annotation(
    Line(points = {{118, 6}, {118, 100}, {106, 100}}, color = {85, 170, 255}));
  connect(complexToReal2.re, gain.u) annotation(
    Line(points = {{94, 104}, {68, 104}}, color = {0, 0, 127}));
  connect(complexToReal2.im, gain1.u) annotation(
    Line(points = {{94, 98}, {80, 98}, {80, 88}, {68, 88}}, color = {0, 0, 127}));
  connect(WTGTerminalMeasurements.PPu, switch.u1) annotation(
    Line(points = {{112, 6}, {112, 27}, {31, 27}}, color = {0, 0, 127}));
  connect(WTGTerminalMeasurements.QPu, switch5.u1) annotation(
    Line(points = {{114, 6}, {114, 43}, {31, 43}}, color = {0, 0, 127}));
  connect(WTGTerminalMeasurements.terminal2, terminal) annotation(
    Line(points = {{120, 0}, {140, 0}}, color = {0, 0, 255}));
  connect(TfoPCS.terminal1, WTGTerminalMeasurements.terminal1) annotation(
    Line(points = {{100, 0}, {110, 0}}, color = {0, 0, 255}));
  connect(complexExpr.y, complexToReal1.u) annotation(
    Line(points = {{123, 84}, {106, 84}}, color = {85, 170, 255}));

annotation(
    Diagram);
end BasePCS;
