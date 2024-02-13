within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model Scrx1 "Bus-fed or solid-fed exciter model, with no excitation resistance"

  //Regulation parameters
  parameter Boolean CSwitch = false "If true, exciter is solid-fed, if false, exciter is bus-fed";
  parameter Types.PerUnit K "Voltage regulator gain";
  parameter Types.Time tA "Transient gain reduction lead time constant in s";
  parameter Types.Time tB "Transient gain reduction lag time constant in s";
  parameter Types.Time tE "Voltage regulator time constant in s";
  parameter Types.VoltageModulePu VrMaxPu "Maximum output voltage of voltage regulator in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VrMinPu "Minimum output voltage of voltage regulator in pu (user-selected base voltage)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput UOelPu(start = 0) "Overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPssPu(start = 0) "Power system stabilizer output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) "Reference stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UUelPu(start = 0) "Underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Excitation voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Sum sum1(k = {1, 1, 1, 1, -1}, nin = 5) annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction(a = {tB , 1}, b = {tA , 1}, x_start = {Vr0Pu / K}, x_scaled(start = {Vr0Pu / K}), y(start = Vr0Pu / K)) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedFirstOrder limitedFirstOrder(K = K, Y0 = Vr0Pu, YMax = VrMaxPu, YMin = VrMinPu, tFilter = tE) annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = CSwitch) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator initial parameters
  parameter Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";

  final parameter Types.VoltageModulePu UsRef0Pu = Us0Pu + Vr0Pu / K "Initial reference stator voltage in pu (base UNom)";
  final parameter Types.VoltageModulePu Vr0Pu = if CSwitch then Efd0Pu else Efd0Pu / Us0Pu "Initial output voltage of voltage regulator in pu (user-selected base voltage)";

equation
  connect(UOelPu, sum1.u[1]) annotation(
    Line(points = {{-160, 80}, {-120, 80}, {-120, 0}, {-102, 0}}, color = {0, 0, 127}));
  connect(UUelPu, sum1.u[2]) annotation(
    Line(points = {{-160, 40}, {-120, 40}, {-120, 0}, {-102, 0}}, color = {0, 0, 127}));
  connect(UPssPu, sum1.u[3]) annotation(
    Line(points = {{-160, 0}, {-102, 0}}, color = {0, 0, 127}));
  connect(UsRefPu, sum1.u[4]) annotation(
    Line(points = {{-160, -40}, {-120, -40}, {-120, 0}, {-102, 0}}, color = {0, 0, 127}));
  connect(UsPu, sum1.u[5]) annotation(
    Line(points = {{-160, -80}, {-120, -80}, {-120, 0}, {-102, 0}}, color = {0, 0, 127}));
  connect(sum1.y, transferFunction.u) annotation(
    Line(points = {{-79, 0}, {-63, 0}}, color = {0, 0, 127}));
  connect(transferFunction.y, limitedFirstOrder.u) annotation(
    Line(points = {{-39, 0}, {-23, 0}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{61, 0}, {98, 0}}, color = {255, 0, 255}));
  connect(UsPu, product.u2) annotation(
    Line(points = {{-160, -80}, {20, -80}, {20, -46}, {38, -46}}, color = {0, 0, 127}));
  connect(limitedFirstOrder.y, product.u1) annotation(
    Line(points = {{1, 0}, {20, 0}, {20, -34}, {38, -34}}, color = {0, 0, 127}));
  connect(limitedFirstOrder.y, switch1.u1) annotation(
    Line(points = {{1, 0}, {20, 0}, {20, 40}, {80, 40}, {80, 8}, {98, 8}}, color = {0, 0, 127}));
  connect(product.y, switch1.u3) annotation(
    Line(points = {{61, -40}, {80, -40}, {80, -8}, {98, -8}}, color = {0, 0, 127}));
  connect(switch1.y, EfdPu) annotation(
    Line(points = {{122, 0}, {150, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}})));
end Scrx1;
