within Dynawo.Electrical.PEIR.Plants.Simplified;

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

model GenericInverter "Injector model with regulation, used in the modified Nordic32 test system"
  extends Dynawo.AdditionalIcons.Machine;

  parameter Types.CurrentModulePu IMaxPu "Maximum current module in pu (base SNom, UNom)";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  //Terminal
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the generator to the grid" annotation(
    Placement(transformation(origin = {130, 10}, extent = {{-10, -10}, {10, 10}}), iconTransformation(extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference angular velocity in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {140, 56}, extent = {{20, -20}, {-20, 20}}), iconTransformation(origin = {120, 40}, extent = {{20, -20}, {-20, 20}}, rotation = -0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Reference active power in pu (base SNom)" annotation(
    Placement(transformation(origin = {-140, -80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput VRefPu(start = VReg0Pu) "Reference voltage amplitude at the PCC in pu (base UNom)" annotation(
    Placement(transformation(origin = {-140, 80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput VRegPu(start = VReg0Pu) "Voltage amplitude at the PCC in pu (base UNom)" annotation(
    Placement(transformation(origin = {-140, 40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput VtRefPu(start = U0Pu) "Reference voltage amplitude at the terminal in pu (base UNom)" annotation(
    Placement(transformation(origin = {-140, -40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}})));

  Types.VoltageModulePu VtPu(start = U0Pu) "Voltage amplitude at the terminal in pu (base UNom)";

  Electrical.Sources.InjectorIDQ injectorIDQ(SwitchOffSignal20 = false, SNom = SNom, i0Pu = i0Pu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, s0Pu = s0Pu, U0Pu = U0Pu, u0Pu = u0Pu, UPhase0 = UPhase0) annotation(
    Placement(transformation(origin = {60, 0}, extent = {{-20, -20}, {20, 20}})));
  Dynawo.Electrical.PEIR.BaseControls.Simplified.ElectricalControlNordic electricalControlNordic(t1 = 1, t2 = 1, t3 = 1, t4 = 1, t5 = 1, t6 = 1, Kp = 5, Ki = 0.1, Id0Pu = Id0Pu, IMaxPu = IMaxPu, Iq0Pu = Iq0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, VReg0Pu = VReg0Pu) annotation(
    Placement(transformation(origin = {-20, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y = VtPu) annotation(
    Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Controls.PLL.PLL pll(Ki = 1, Kp = 1, u0Pu = u0Pu, OmegaMaxPu = 60, OmegaMinPu = 40) annotation(
    Placement(transformation(origin = {60, 68}, extent = {{20, -20}, {-20, 20}})));

  parameter Types.ActivePowerPu P0Pu "Initial active power in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at the terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Initial voltage angle at the terminal in rad";
  parameter Types.VoltageModulePu VReg0Pu "Initial voltage amplitude at the PCC in pu (base UNom)";

  final parameter Types.ComplexCurrentPu i0Pu = ComplexMath.conj(s0Pu / u0Pu) "Initial complex current at the terminal in pu (base SnRef, UNom) (receptor convention)";
  final parameter Types.PerUnit Id0Pu = -(cos(UPhase0) * i0Pu.re + sin(UPhase0) * i0Pu.im) * SystemBase.SnRef / SNom "Initial active current in pu (base SNom, UNom) (generator convention)";
  final parameter Types.PerUnit Iq0Pu = (sin(UPhase0) * i0Pu.re - cos(UPhase0) * i0Pu.im) * SystemBase.SnRef / SNom "Initial reactive current in pu (base SNom, UNom) (generator convention)";
  final parameter Types.ComplexApparentPowerPu s0Pu = Complex(P0Pu, Q0Pu) "Initial complex apparent power in pu (base SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0) "Initial complex voltage at the terminal in pu (base UNom)";

equation
  VtPu = Modelica.ComplexMath.'abs'(terminal.V);

  connect(electricalControlNordic.IdRefPu, injectorIDQ.idPu) annotation(
    Line(points = {{2, 12}, {37, 12}}, color = {0, 0, 127}));
  connect(electricalControlNordic.IqRefPu, injectorIDQ.iqPu) annotation(
    Line(points = {{2, -12}, {20, -12}, {20, -8}, {38, -8}}, color = {0, 0, 127}));
  connect(omegaRefPu, pll.omegaRefPu) annotation(
    Line(points = {{140, 56}, {81, 56}}, color = {0, 0, 127}));
  connect(VtRefPu, electricalControlNordic.VtRefPu) annotation(
    Line(points = {{-140, -40}, {-80, -40}, {-80, -8}, {-44, -8}}, color = {0, 0, 127}));
  connect(realExpression.y, electricalControlNordic.VtPu) annotation(
    Line(points = {{-99, 0}, {-44, 0}}, color = {0, 0, 127}));
  connect(VRegPu, electricalControlNordic.VRegPu) annotation(
    Line(points = {{-140, 40}, {-80, 40}, {-80, 8}, {-44, 8}}, color = {0, 0, 127}));
  connect(injectorIDQ.terminal, terminal) annotation(
    Line(points = {{83, -15.8}, {129, -15.8}, {129, 10.2}}, color = {0, 0, 255}));
  connect(pll.phi, injectorIDQ.UPhase) annotation(
    Line(points = {{38, 70}, {20, 70}, {20, 40}, {60, 40}, {60, 24}}, color = {0, 0, 127}));
  connect(injectorIDQ.uPu, pll.uPu) annotation(
    Line(points = {{83, -6.6}, {100, -6.6}, {100, 79.4}, {81, 79.4}}, color = {85, 170, 255}));
  connect(PRefPu, electricalControlNordic.PRefPu) annotation(
    Line(points = {{-140, -80}, {-60, -80}, {-60, -16}, {-44, -16}}, color = {0, 0, 127}));
  connect(VRefPu, electricalControlNordic.VRefPu) annotation(
    Line(points = {{-140, 80}, {-60, 80}, {-60, 16}, {-44, 16}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-120, -100}, {120, 100}})),
    Icon(graphics = {Rectangle(lineThickness = 0.75, extent = {{-100, 100}, {100, -100}}), Rectangle(lineColor = {0, 170, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 77}, textColor = {0, 0, 255}, extent = {{-35, 15}, {35, -15}}, textString = "%name"), Line(origin = {0, 40}, points = {{-80, 0}, {80, 0}, {80, 0}}, color = {0, 170, 0}, thickness = 0.5), Line(origin = {0, -40}, points = {{-80, 0}, {80, 0}, {80, 0}}, color = {0, 170, 0}, thickness = 0.5), Line(origin = {-20, -40}, points = {{-40, 80}, {-10, 0}, {20, 80}}, color = {0, 170, 0}, thickness = 0.5), Line(origin = {40, 40}, points = {{-40, -80}, {-10, 0}, {20, -80}}, color = {0, 170, 0}, thickness = 0.5)}),
    Documentation(info = "<html><head></head><body>This controlled injector is used in the modified Nordic32 test sytem described in the paper&nbsp;<a href=\"https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=9446224\">\"Impact of Inverter-Based Generation on Voltage Stability in a Modiﬁed Nordic Test System\"</a>.</body></html>"));
end GenericInverter;
