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

model Scrx "Bus-fed or solid-fed exciter model, with no excitation resistance"

  //Regulation parameters
  parameter Boolean CSwitch = false "If true, exciter is solid-fed, if false, exciter is bus-fed";
  parameter Boolean IrThresholdOn = false "If true, rotor current threshold applies";
  parameter Types.PerUnit K "Voltage regulator gain";
  parameter Types.PerUnit RcToRfd = 0 "Ratio of field discharge resistance to field winding resistance";
  parameter Types.Time tA "Transient gain reduction lead time constant in s";
  parameter Types.Time tB "Transient gain reduction lag time constant in s";
  parameter Types.Time tE "Voltage regulator time constant in s";
  parameter Types.VoltageModulePu VrMaxPu "Maximum output voltage of voltage regulator in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VrMinPu "Minimum output voltage of voltage regulator in pu (user-selected base voltage)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput IrPu(start = Ir0Pu) "Rotor current in pu (base SNom, user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {-180, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, -80}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UOelPu(start = 0) "Overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPssPu(start = 0) "Power system stabilizer output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) "Reference stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UUelPu(start = 0) "Underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Excitation voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {190, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Sum sum1(k = {1, 1, 1, 1, -1}, nin = 5) annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction(a = {tB , 1}, b = {tA , 1}, x_start = {Vr0Pu / K}, x_scaled(start = {Vr0Pu / K}), y(start = Vr0Pu / K)) annotation(
    Placement(visible = true, transformation(origin = {-70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedFirstOrder limitedFirstOrder(K = K, Y0 = Vr0Pu, YMax = VrMaxPu, YMin = VrMinPu, tFilter = tE) annotation(
    Placement(visible = true, transformation(origin = {-30, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {30, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = CSwitch) annotation(
    Placement(visible = true, transformation(origin = {30, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {150, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessThreshold lessThreshold annotation(
    Placement(visible = true, transformation(origin = {30, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -RcToRfd) annotation(
    Placement(visible = true, transformation(origin = {90, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.And and1 annotation(
    Placement(visible = true, transformation(origin = {90, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1(k = IrThresholdOn) annotation(
    Placement(visible = true, transformation(origin = {30, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Generator initial parameters
  parameter Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  parameter Types.CurrentModulePu Ir0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";

  final parameter Types.VoltageModulePu UsRef0Pu = Us0Pu + Vr0Pu / K "Initial reference stator voltage in pu (base UNom)";
  final parameter Types.VoltageModulePu Vr0Pu = if CSwitch then Efd0Pu else Efd0Pu / Us0Pu "Initial output voltage of voltage regulator in pu (user-selected base voltage)";

equation
  connect(UOelPu, sum1.u[1]) annotation(
    Line(points = {{-180, 40}, {-140, 40}, {-140, -40}, {-122, -40}}, color = {0, 0, 127}));
  connect(UUelPu, sum1.u[2]) annotation(
    Line(points = {{-180, 0}, {-140, 0}, {-140, -40}, {-122, -40}}, color = {0, 0, 127}));
  connect(UPssPu, sum1.u[3]) annotation(
    Line(points = {{-180, -40}, {-122, -40}}, color = {0, 0, 127}));
  connect(UsRefPu, sum1.u[4]) annotation(
    Line(points = {{-180, -80}, {-140, -80}, {-140, -40}, {-122, -40}}, color = {0, 0, 127}));
  connect(UsPu, sum1.u[5]) annotation(
    Line(points = {{-180, -120}, {-140, -120}, {-140, -40}, {-122, -40}}, color = {0, 0, 127}));
  connect(sum1.y, transferFunction.u) annotation(
    Line(points = {{-99, -40}, {-83, -40}}, color = {0, 0, 127}));
  connect(transferFunction.y, limitedFirstOrder.u) annotation(
    Line(points = {{-59, -40}, {-43, -40}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{41, -40}, {78, -40}}, color = {255, 0, 255}));
  connect(limitedFirstOrder.y, product.u1) annotation(
    Line(points = {{-19, -40}, {0, -40}, {0, -74}, {18, -74}}, color = {0, 0, 127}));
  connect(limitedFirstOrder.y, switch1.u1) annotation(
    Line(points = {{-19, -40}, {0, -40}, {0, 0}, {60, 0}, {60, -32}, {78, -32}}, color = {0, 0, 127}));
  connect(product.y, switch1.u3) annotation(
    Line(points = {{41, -80}, {60, -80}, {60, -48}, {78, -48}}, color = {0, 0, 127}));
  connect(IrPu, lessThreshold.u) annotation(
    Line(points = {{-180, 120}, {0, 120}, {0, 60}, {18, 60}}, color = {0, 0, 127}));
  connect(switch1.y, switch.u3) annotation(
    Line(points = {{101, -40}, {120, -40}, {120, 52}, {137, 52}}, color = {0, 0, 127}));
  connect(switch.y, EfdPu) annotation(
    Line(points = {{161, 60}, {189, 60}}, color = {0, 0, 127}));
  connect(gain.y, switch.u1) annotation(
    Line(points = {{102, 120}, {120, 120}, {120, 68}, {138, 68}}, color = {0, 0, 127}));
  connect(IrPu, gain.u) annotation(
    Line(points = {{-180, 120}, {78, 120}}, color = {0, 0, 127}));
  connect(UsPu, product.u2) annotation(
    Line(points = {{-180, -120}, {0, -120}, {0, -86}, {18, -86}}, color = {0, 0, 127}));
  connect(lessThreshold.y, and1.u1) annotation(
    Line(points = {{42, 60}, {78, 60}}, color = {255, 0, 255}));
  connect(booleanConstant1.y, and1.u2) annotation(
    Line(points = {{42, 20}, {60, 20}, {60, 52}, {78, 52}}, color = {255, 0, 255}));
  connect(and1.y, switch.u2) annotation(
    Line(points = {{102, 60}, {138, 60}}, color = {255, 0, 255}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-160, -140}, {180, 140}})));
end Scrx;
