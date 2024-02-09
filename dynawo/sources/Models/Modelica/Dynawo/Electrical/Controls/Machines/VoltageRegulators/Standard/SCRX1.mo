within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

model SCRX1 "Bus-fed or solid-fed exciter model"

  parameter Boolean CSwitch = false "If true, exciter is solid-fed, if false, exciter is bus-fed";
  parameter Types.PerUnit K "Voltage regulator gain";
  parameter Types.PerUnit RcToRfd = 0 "Ratio of field discharge resistance to field winding resistance";
  parameter Types.Time tA "Transient gain reduction lead time constant in s";
  parameter Types.Time tB "Transient gain reduction lag time constant in s";
  parameter Types.Time tE "Voltage regulator time constant in s";
  parameter Types.VoltageModulePu VrMaxPu "Maximum output voltage of voltage regulator in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu VrMinPu "Minimum output voltage of voltage regulator in pu (user-selected base voltage)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput IRotorPu(start = IRotor0Pu) "Rotor current in pu (base SNom, user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {-240, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, -80}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UOelPu(start = 0) "OEL output voltage correction in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-240, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPssPu(start = 0) "PSS output voltage correction in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-240, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Reference stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-240, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UStatorPu(start = UStator0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-240, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UtPu(start = Ut0Pu) "Generator terminal voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-240, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput UUelPu(start = 0) "UEL output voltage correction in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-240, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Excitation voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {250, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Sum sum1(k = {1, 1, 1, 1, -1}, nin = 5) annotation(
    Placement(visible = true, transformation(origin = {-170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction(a = {tB , 1}, b = {tA , 1}, initType = Modelica.Blocks.Types.Init.InitialState, x_start = {Vr0Pu / K}, y_start = Vr0Pu / K) annotation(
    Placement(visible = true, transformation(origin = {-130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedFirstOrder limitedFirstOrder(K = K, Y0 = Vr0Pu, YMax = VrMaxPu, YMin = VrMinPu, tFilter = tE) annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {30, 40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-30, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = CSwitch) annotation(
    Placement(visible = true, transformation(origin = {-30, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -RcToRfd) annotation(
    Placement(visible = true, transformation(origin = {30, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(visible = true, transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqualThreshold lessEqualThreshold annotation(
    Placement(visible = true, transformation(origin = {90, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));

  parameter Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  parameter Types.CurrentModulePu IRotor0Pu "Initial rotor current in pu (base SNom, user-selected base voltage)";
  parameter Types.VoltageModulePu UStator0Pu "Initial stator voltage in pu (base UNom)";
  parameter Types.VoltageModulePu Ut0Pu "Generator terminal initial voltage in pu (base UNom)";

  final parameter Types.VoltageModulePu URef0Pu = UStator0Pu + Vr0Pu / K "Initial reference stator voltage in pu (base UNom)";
  final parameter Types.VoltageModulePu Vr0Pu = if CSwitch then Efd0Pu else Efd0Pu / Ut0Pu "Initial output voltage of voltage regulator in pu (user-selected base voltage)";

equation
  connect(UOelPu, sum1.u[1]) annotation(
    Line(points = {{-240, 80}, {-200, 80}, {-200, 0}, {-182, 0}}, color = {0, 0, 127}));
  connect(UUelPu, sum1.u[2]) annotation(
    Line(points = {{-240, 40}, {-200, 40}, {-200, 0}, {-182, 0}}, color = {0, 0, 127}));
  connect(UPssPu, sum1.u[3]) annotation(
    Line(points = {{-240, 0}, {-182, 0}}, color = {0, 0, 127}));
  connect(URefPu, sum1.u[4]) annotation(
    Line(points = {{-240, -40}, {-200, -40}, {-200, 0}, {-182, 0}}, color = {0, 0, 127}));
  connect(UStatorPu, sum1.u[5]) annotation(
    Line(points = {{-240, -80}, {-200, -80}, {-200, 0}, {-182, 0}}, color = {0, 0, 127}));
  connect(sum1.y, transferFunction.u) annotation(
    Line(points = {{-159, 0}, {-143, 0}}, color = {0, 0, 127}));
  connect(transferFunction.y, limitedFirstOrder.u) annotation(
    Line(points = {{-119, 0}, {-103, 0}}, color = {0, 0, 127}));
  connect(UtPu, product.u1) annotation(
    Line(points = {{-240, 120}, {-60, 120}, {-60, 86}, {-42, 86}}, color = {0, 0, 127}));
  connect(limitedFirstOrder.y, product.u2) annotation(
    Line(points = {{-79, 0}, {-60, 0}, {-60, 74}, {-42, 74}}, color = {0, 0, 127}));
  connect(limitedFirstOrder.y, switch1.u1) annotation(
    Line(points = {{-79, 0}, {0, 0}, {0, 32}, {18, 32}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{-19, 40}, {18, 40}}, color = {255, 0, 255}));
  connect(product.y, switch1.u3) annotation(
    Line(points = {{-19, 80}, {0, 80}, {0, 48}, {18, 48}}, color = {0, 0, 127}));
  connect(switch1.y, lessEqual.u2) annotation(
    Line(points = {{41, 40}, {60, 40}, {60, 8}, {78, 8}}, color = {0, 0, 127}));
  connect(IRotorPu, gain.u) annotation(
    Line(points = {{-240, -120}, {18, -120}}, color = {0, 0, 127}));
  connect(gain.y, lessEqual.u1) annotation(
    Line(points = {{41, -120}, {60, -120}, {60, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(gain.y, lessEqualThreshold.u) annotation(
    Line(points = {{41, -120}, {60, -120}, {60, -60}, {78, -60}}, color = {0, 0, 127}));
  connect(lessEqual.y, or1.u1) annotation(
    Line(points = {{101, 0}, {137, 0}}, color = {255, 0, 255}));
  connect(lessEqualThreshold.y, or1.u2) annotation(
    Line(points = {{101, -60}, {120, -60}, {120, -8}, {138, -8}}, color = {255, 0, 255}));
  connect(switch1.y, switch.u1) annotation(
    Line(points = {{41, 40}, {180, 40}, {180, 8}, {198, 8}}, color = {0, 0, 127}));
  connect(or1.y, switch.u2) annotation(
    Line(points = {{161, 0}, {198, 0}}, color = {255, 0, 255}));
  connect(gain.y, switch.u3) annotation(
    Line(points = {{42, -120}, {180, -120}, {180, -8}, {198, -8}}, color = {0, 0, 127}));
  connect(switch.y, EfdPu) annotation(
    Line(points = {{221, 0}, {250, 0}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-220, -140}, {240, 140}})),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(extent = {{-100, 100}, {100, -100}}, textString = "SCRX")}));
end SCRX1;
