within Dynawo.Electrical.Controls.IEC.IEC63406;

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

model PlantCommunication "Communication interface to plant power controller (IEC63406)"

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //Parameters
  parameter Integer ComFlag "0 if the communication delay is relatively long and affects the control, 1 if accurate modeling of the communication delay is provided, 2 for linear communication and 3 for 1st order lag communication" annotation(
      Dialog(tab = "PlantCommunication"));
  parameter Types.Time Tcom "Time constant for communication delay between the plant-level controller and the generating unit-level controller" annotation(
      Dialog(tab = "PlantCommunication"));
  parameter Types.Time Tlag "Time constant for communication lag between the plant-level controller and the generating unit-level controller" annotation(
      Dialog(tab = "PlantCommunication"));
  parameter Types.Time Tlead "Time constant for communication lead between the plant-level controller and the generating unit-level controller" annotation(
      Dialog(tab = "PlantCommunication"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput pCmdPu(start = -P0Pu*SystemBase.SnRef / SNom) "Active power command from the plant controller in pu (base SNom) (generator convention)" annotation(
      Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qCmdPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Reactive power command from the plant controller in pu (base SNom) (generator convention)" annotation(
      Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uCmdPu(start = U0Pu) "Voltage command from the plant controller in pu (base UNom)" annotation(
      Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput pRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Active power reference provided by the plant controller in pu (base SNom) (generator convention)" annotation(
      Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput qRefPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Reactive power reference provided by the plant controller in pu (base SNom) (generator convention)" annotation(
      Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uRefPu(start = U0Pu) "Voltage reference provided by the plant controller in pu (base UNom)" annotation(
      Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.IEC.IEC63406.AuxiliaryBlocks.StrongDelay strongDelay(T = Tcom)  annotation(
      Placement(visible = true, transformation(origin = {-13, 80}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay(delayTime = Tcom)  annotation(
      Placement(visible = true, transformation(origin = {14, 66}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = Tcom, y_start = -P0Pu*SystemBase.SnRef / SNom)  annotation(
      Placement(visible = true, transformation(origin = {13, 40}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerExpression IntegerExpression(y = ComFlag)  annotation(
      Placement(visible = true, transformation(origin = {70, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Dynawo.Electrical.Controls.IEC.IEC63406.AuxiliaryBlocks.StrongDelay strongDelay1(T = Tcom) annotation(
    Placement(visible = true, transformation(origin = {-13, 20}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay1(delayTime = Tcom) annotation(
    Placement(visible = true, transformation(origin = {14, 6}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = Tcom, y_start = -Q0Pu*SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {13, -20}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC63406.AuxiliaryBlocks.StrongDelay strongDelay2(T = Tcom) annotation(
    Placement(visible = true, transformation(origin = {-13, -40}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = Tcom, y_start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {13, -80}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay2(delayTime = Tcom) annotation(
    Placement(visible = true, transformation(origin = {14, -54}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {70, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch1(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch2(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(group = "Operating point"));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction(a = {Tlag, 1}, b = {Tlead, 1}, y_start = -P0Pu * SystemBase.SnRef / SNom)  annotation(
    Placement(visible = true, transformation(origin = {-13, 53}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction1(a = {Tlag, 1}, b = {Tlead, 1}, y_start = -Q0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {-13, -6}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction2(a = {Tlag, 1}, b = {Tlead, 1}, y_start = -U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-13, -66}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));

equation
  connect(pCmdPu, strongDelay.u) annotation(
    Line(points = {{-120, 60}, {-40, 60}, {-40, 80}, {-21, 80}}, color = {0, 0, 127}));
  connect(pCmdPu, fixedDelay.u) annotation(
    Line(points = {{-120, 60}, {-40, 60}, {-40, 66}, {6, 66}}, color = {0, 0, 127}));
  connect(pCmdPu, firstOrder.u) annotation(
    Line(points = {{-120, 60}, {-40, 60}, {-40, 40}, {5, 40}}, color = {0, 0, 127}));
  connect(qCmdPu, strongDelay1.u) annotation(
    Line(points = {{-120, 0}, {-40, 0}, {-40, 20}, {-21, 20}}, color = {0, 0, 127}));
  connect(qCmdPu, fixedDelay1.u) annotation(
    Line(points = {{-120, 0}, {-40, 0}, {-40, 6}, {6, 6}}, color = {0, 0, 127}));
  connect(qCmdPu, firstOrder1.u) annotation(
    Line(points = {{-120, 0}, {-40, 0}, {-40, -20}, {5, -20}}, color = {0, 0, 127}));
  connect(uCmdPu, strongDelay2.u) annotation(
    Line(points = {{-120, -60}, {-40, -60}, {-40, -40}, {-21, -40}}, color = {0, 0, 127}));
  connect(uCmdPu, fixedDelay2.u) annotation(
    Line(points = {{-120, -60}, {-40, -60}, {-40, -54}, {6, -54}}, color = {0, 0, 127}));
  connect(uCmdPu, firstOrder2.u) annotation(
    Line(points = {{-120, -60}, {-40, -60}, {-40, -80}, {5, -80}}, color = {0, 0, 127}));
  connect(strongDelay.y, multiSwitch.u[1]) annotation(
    Line(points = {{-6, 80}, {40, 80}, {40, 60}, {60, 60}}, color = {0, 0, 127}));
  connect(fixedDelay.y, multiSwitch.u[2]) annotation(
    Line(points = {{22, 66}, {40, 66}, {40, 60}, {60, 60}}, color = {0, 0, 127}));
  connect(firstOrder.y, multiSwitch.u[3]) annotation(
    Line(points = {{20, 40}, {40, 40}, {40, 60}, {60, 60}}, color = {0, 0, 127}));
  connect(multiSwitch.y, pRefPu) annotation(
    Line(points = {{82, 60}, {110, 60}}, color = {0, 0, 127}));
  connect(IntegerExpression.y, multiSwitch.f) annotation(
    Line(points = {{70, 100}, {70, 72}}, color = {255, 127, 0}));
  connect(strongDelay1.y, multiSwitch1.u[1]) annotation(
    Line(points = {{-6, 20}, {40, 20}, {40, 0}, {60, 0}}, color = {0, 0, 127}));
  connect(fixedDelay1.y, multiSwitch1.u[2]) annotation(
    Line(points = {{22, 6}, {40, 6}, {40, 0}, {60, 0}}, color = {0, 0, 127}));
  connect(firstOrder1.y, multiSwitch1.u[3]) annotation(
    Line(points = {{20, -20}, {40, -20}, {40, 0}, {60, 0}}, color = {0, 0, 127}));
  connect(strongDelay2.y, multiSwitch2.u[1]) annotation(
    Line(points = {{-6, -40}, {40, -40}, {40, -60}, {60, -60}}, color = {0, 0, 127}));
  connect(fixedDelay2.y, multiSwitch2.u[2]) annotation(
    Line(points = {{22, -54}, {40, -54}, {40, -60}, {60, -60}}, color = {0, 0, 127}));
  connect(firstOrder2.y, multiSwitch2.u[3]) annotation(
    Line(points = {{20, -80}, {40, -80}, {40, -60}, {60, -60}}, color = {0, 0, 127}));
  connect(multiSwitch1.y, qRefPu) annotation(
    Line(points = {{82, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(multiSwitch2.y, uRefPu) annotation(
    Line(points = {{82, -60}, {110, -60}}, color = {0, 0, 127}));
  connect(IntegerExpression.y, multiSwitch1.f) annotation(
    Line(points = {{70, 100}, {70, 12}}, color = {255, 127, 0}));
  connect(IntegerExpression.y, multiSwitch2.f) annotation(
    Line(points = {{70, 100}, {70, -48}}, color = {255, 127, 0}));
  connect(pCmdPu, transferFunction.u) annotation(
    Line(points = {{-120, 60}, {-40, 60}, {-40, 54}, {-22, 54}}, color = {0, 0, 127}));
  connect(transferFunction.y, multiSwitch.u[4]) annotation(
    Line(points = {{-6, 54}, {40, 54}, {40, 60}, {60, 60}}, color = {0, 0, 127}));
  connect(qCmdPu, transferFunction1.u) annotation(
    Line(points = {{-120, 0}, {-40, 0}, {-40, -6}, {-22, -6}}, color = {0, 0, 127}));
  connect(transferFunction1.y, multiSwitch1.u[4]) annotation(
    Line(points = {{-6, -6}, {40, -6}, {40, 0}, {60, 0}}, color = {0, 0, 127}));
  connect(uCmdPu, transferFunction2.u) annotation(
    Line(points = {{-120, -60}, {-40, -60}, {-40, -66}, {-22, -66}}, color = {0, 0, 127}));
  connect(transferFunction2.y, multiSwitch2.u[4]) annotation(
    Line(points = {{-6, -66}, {40, -66}, {40, -60}, {60, -60}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(extent = {{-100, 100}, {100, -100}}, textString = "Plant
Com")}));
end PlantCommunication;
