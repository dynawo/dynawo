within Dynawo.Electrical.Controls.IEC.IEC63406.PrimaryEnergy;

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

model EnergyConversion "Primary energy source driven electric conversion module (IEC 63406)"

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //Parameters
  parameter Types.PerUnit PMaxPu "Maximum active power at converter terminal in pu (base SNom)" annotation(
    Dialog(tab = "General"));
  parameter Boolean SOCFlag "0 for battery energy storage systems, 1 for supercapacitor energy storage systems and flywheel energy storage systems" annotation(
    Dialog(tab = "Storage"));
  parameter Real SOCInit (unit="%") "Initial SOC amount" annotation(
    Dialog(tab = "Storage"));
  parameter Real SOCMax (unit="%") "Maximum SOC amount for charging" annotation(
    Dialog(tab = "Storage"));
  parameter Real SOCMin (unit="%") "Minimum SOC amount for charging" annotation(
    Dialog(tab = "Storage"));
  parameter Boolean StorageFlag "1 if it is a storage unit, 0 if not" annotation(
    Dialog(tab = "General"));
  parameter Types.Time Tconv "Equivalent time for primary energy conversion" annotation(
    Dialog(tab = "Storage"));
  parameter Types.Time Tess "Equivalent time constant (in s) for the battery, supercapacitor or flywheel energy storage systems (if you have Tess = 10, a system with 100% SOC and P = Pmax, the system will discharge completely in 10s)" annotation(
    Dialog(tab = "Storage"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput pMeasPu(start = -P0Pu * SystemBase.SnRef / SNom) "Measured (and filtered) active power component in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-122, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -34}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pPrimPu(start = -P0Pu * SystemBase.SnRef / SNom) "Power from the primary energy in pu (base SNom), which should be specified by model users and can be time-varying to represent the variations of primary energy" annotation(
    Placement(visible = true, transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 34}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput pAvailInPu(start = PAvailIn0Pu) "Minimum output electrical power available to the active power control module in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput pAvailOutPu(start = PMaxPu) "Maximum output electrical power available to the active power control module in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.IEC.IEC63406.PrimaryEnergy.Auxiliary.StorageSys storageSys(P0Pu = P0Pu, PAvailIn0Pu = PAvailIn0Pu, PMaxPu = PMaxPu, SNom = SNom, SOCFlag = SOCFlag, SOCInit = SOCInit, SOCMax = SOCMax, SOCMin = SOCMin, Tess = Tess)  annotation(
    Placement(visible = true, transformation(origin = {-20, -40}, extent = {{-20, 20}, {20, -20}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch11 annotation(
    Placement(visible = true, transformation(origin = {70, 40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression real annotation(
    Placement(visible = true, transformation(origin = {-10, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = StorageFlag)  annotation(
    Placement(visible = true, transformation(origin = {40, 90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedFirstOrder limitedFirstOrder(Y0 = -P0Pu * SystemBase.SnRef / SNom, YMax = PMaxPu, YMin = 0, tFilter = Tconv) annotation(
    Placement(visible = true, transformation(origin = {-20, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Initial parameters
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit PAvailIn0Pu "Initial minimum output electrical power available to the active power control module in pu (base SNom)" annotation(
    Dialog(tab = "Operating point"));

equation
  connect(switch11.y, pAvailOutPu) annotation(
    Line(points = {{81, 40}, {110, 40}}, color = {0, 0, 127}));
  connect(switch1.y, pAvailInPu) annotation(
    Line(points = {{81, -40}, {110, -40}}, color = {0, 0, 127}));
  connect(pPrimPu, limitedFirstOrder.u) annotation(
    Line(points = {{-120, 40}, {-44, 40}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch11.u2) annotation(
    Line(points = {{40, 79}, {40, 40}, {58, 40}}, color = {255, 0, 255}));
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{40, 79}, {40, -40}, {58, -40}}, color = {255, 0, 255}));
  connect(storageSys.pAvailInPu, switch1.u1) annotation(
    Line(points = {{2, -48}, {30, -48}, {30, -32}, {58, -32}}, color = {0, 0, 127}));
  connect(real.y, switch1.u3) annotation(
    Line(points = {{2, -80}, {50, -80}, {50, -48}, {58, -48}}, color = {0, 0, 127}));
  connect(limitedFirstOrder.y, switch11.u3) annotation(
    Line(points = {{2, 40}, {20, 40}, {20, 48}, {58, 48}}, color = {0, 0, 127}));
  connect(storageSys.pAvailOutPu, switch11.u1) annotation(
    Line(points = {{2, -36}, {20, -36}, {20, 32}, {58, 32}}, color = {0, 0, 127}));
  connect(pMeasPu, storageSys.pMeasPu) annotation(
    Line(points = {{-122, -40}, {-44, -40}}, color = {0, 0, 127}));

  annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(extent = {{-100, 100}, {100, -100}}, textString = "Energy
Conversion")}));
end EnergyConversion;
