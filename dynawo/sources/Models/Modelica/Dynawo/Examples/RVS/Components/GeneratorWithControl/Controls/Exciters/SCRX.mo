within Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SCRX
  import Modelica;
  import Dynawo;
  
  parameter Boolean CSwitch = false "Power source switch, true = terminal voltage";
  parameter Types.PerUnit K "AVR gain";
  parameter Types.PerUnit rc_rfd = 0 "Ratio of field discharge resistance to field winding resistance";
  parameter Types.Time Ta "Transient gain reduction lead time constant. Ratio Ta/Tb should typically be 0.1";
  parameter Types.Time Tb "Transient gain reduction lag time constant";
  parameter Types.Time Te "AVR time constant";
  parameter Types.VoltageModulePu EMinPu "Minimum AVR output in pu";
  parameter Types.VoltageModulePu EMaxPu "Maximum AVR output in pu";
  
  parameter Types.CurrentModulePu IRotor0Pu "Initial value of generator field current in pu (non-reciprocal)";
  parameter Types.VoltageModulePu UStator0Pu "Initial value of generator stator voltage in pu (base UNom)";
  parameter Types.VoltageModulePu URef0Pu "Initial value of voltage reference in pu (base UNom)";
  parameter Types.VoltageModulePu Uoel0Pu=0 "Initial value of OEL voltage correction in pu (base UNom)";
  parameter Types.VoltageModulePu Uuel0Pu=0 "Initial value of UEL voltage correction in pu (base UNom)";
  parameter Types.VoltageModulePu Efd0Pu "Initial value of excitation voltage in pu";
  parameter Types.VoltageModulePu Ut0Pu "Initial value of generator terminal voltage in pu (base UNom)";
  
  Modelica.Blocks.Interfaces.RealInput UtPu(start = Ut0Pu) "Generator terminal voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {40, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {80, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UStatorPu(start = UStator0Pu) "Generator stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-200, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPssPu(start = 0) "PSS voltage correction in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-200, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput IRotorPu(start = IRotor0Pu) "Generator field current in pu (non-reciprocal)" annotation(
    Placement(visible = true, transformation(origin = {0, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {120, -78}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput UoelPu(start = 0) "OEL voltage correction in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-100, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-20, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UuelPu(start = 0) "UEL voltage correction in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-140, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-78, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-200, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{-140, 40}, {-100, 80}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Excitation voltage in pu" annotation(
    Placement(visible = true, transformation(origin = {190, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add3 add3(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add31 annotation(
    Placement(visible = true, transformation(origin = {-70, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction(a = {Tb ,  1}, b = {Ta ,  1}, initType = Modelica.Blocks.Types.Init.InitialState, x_start = {Efd0Pu / Ut0Pu / K}, y_start = Efd0Pu / Ut0Pu / K)  annotation(
    Placement(visible = true, transformation(origin = {-30, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = EMaxPu, uMin = EMinPu)  annotation(
    Placement(visible = true, transformation(origin = {40, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {110, 8}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {74, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = CSwitch)  annotation(
    Placement(visible = true, transformation(origin = {70, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters.Util.NegCurrentLogic negCurrentLogic(rc_rfd = rc_rfd)  annotation(
    Placement(visible = true, transformation(origin = {150, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters.Util.FirstOrderLimState firstOrderLimState(T = Te, initType = Modelica.Blocks.Types.Init.InitialOutput, k = K, yMax = EMaxPu, yMin = EMinPu, y_start = Efd0Pu / Ut0Pu)  annotation(
    Placement(visible = true, transformation(origin = {4, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(UStatorPu, add3.u2) annotation(
    Line(points = {{-200, 0}, {-142, 0}}, color = {0, 0, 127}));
  connect(UPssPu, add3.u3) annotation(
    Line(points = {{-200, -60}, {-160, -60}, {-160, -8}, {-142, -8}}, color = {0, 0, 127}));
  connect(add3.y, add31.u3) annotation(
    Line(points = {{-119, 0}, {-82, 0}}, color = {0, 0, 127}));
  connect(add31.y, transferFunction.u) annotation(
    Line(points = {{-59, 8}, {-43, 8}}, color = {0, 0, 127}));
  connect(limiter.y, product.u2) annotation(
    Line(points = {{51, 8}, {53, 8}, {53, 18}, {61, 18}}, color = {0, 0, 127}));
  connect(UtPu, product.u1) annotation(
    Line(points = {{40, 120}, {40, 30}, {62, 30}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{81, -42}, {87, -42}, {87, 8}, {97, 8}}, color = {255, 0, 255}));
  connect(negCurrentLogic.EPu, switch1.y) annotation(
    Line(points = {{138, 12}, {130, 12}, {130, 8}, {121, 8}}, color = {0, 0, 127}));
  connect(IRotorPu, negCurrentLogic.IRotorPu) annotation(
    Line(points = {{0, -120}, {0, -80}, {130, -80}, {130, 4}, {138, 4}}, color = {0, 0, 127}));
  connect(negCurrentLogic.EfdPu, EfdPu) annotation(
    Line(points = {{161, 8}, {189, 8}}, color = {0, 0, 127}));
  connect(UoelPu, add31.u1) annotation(
    Line(points = {{-100, 120}, {-100, 16}, {-82, 16}}, color = {0, 0, 127}));
  connect(UuelPu, add31.u2) annotation(
    Line(points = {{-140, 120}, {-140, 30}, {-110, 30}, {-110, 8}, {-82, 8}}, color = {0, 0, 127}));
  connect(product.y, switch1.u3) annotation(
    Line(points = {{85, 24}, {87, 24}, {87, 16}, {97, 16}}, color = {0, 0, 127}));
  connect(limiter.y, switch1.u1) annotation(
    Line(points = {{51, 8}, {53, 8}, {53, 0}, {97, 0}}, color = {0, 0, 127}));
  connect(firstOrderLimState.y, limiter.u) annotation(
    Line(points = {{15, 8}, {27, 8}}, color = {0, 0, 127}));
  connect(transferFunction.y, firstOrderLimState.u) annotation(
    Line(points = {{-19, 8}, {-9, 8}}, color = {0, 0, 127}));
  connect(URefPu, add3.u1) annotation(
    Line(points = {{-200, 60}, {-160, 60}, {-160, 8}, {-142, 8}}, color = {0, 0, 127}));

  annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {1, 1}, extent = {{-81, 79}, {81, -79}}, textString = "SCRX")}),
    Diagram(coordinateSystem(extent = {{-180, -100}, {180, 100}})));
end SCRX;
