within Dynawo.Electrical.Controls.Machines.Governors.Standard.Generic;

model GovCT2 "IEEE Governor type TGOV1"
  /*
  * Copyright (c) 2021, RTE (http://www.rte-france.com) and UPC/Citcea (https://www.citcea.upc.edu/)
  * See AUTHORS.txt
  * All rights reserved.
  * This Source Code Form is subject to the terms of the Mozilla Public
  * License, v. 2.0. If a copy of the MPL was not distributed with this
  * file, you can obtain one at http://mozilla.org/MPL/2.0/.
  * SPDX-License-Identifier: MPL-2.0
  *
  * This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
  */
  parameter Types.PerUnit R "Controller droop";
  parameter Types.Time Tg1 "Governor time constant in s";
  parameter Types.Time Tg2 "Turbine derivative time constant in s";
  parameter Types.Time Tg3 "Turbine delay time constant in s";
  parameter Types.PerUnit Dt "Frictional losses factor";
  parameter Types.PerUnit VMin "Minimum gate limit";
  parameter Types.PerUnit VMax "Maximum gate limit";
  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-114, -50}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-114, -60}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PmRefPu(start = Pm0Pu) "Reference mechanical power in pu (base PNom)" annotation(
    Placement(visible = true, transformation(origin = {-114, 0}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-114, 0}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  //Output variables
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) "Mechanical power in pu (base PNom)" annotation(
    Placement(visible = true, transformation(origin = {111, -1}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain droop(k = 1/R) annotation(
    Placement(visible = true, transformation(origin = {-40, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = SystemBase.omegaRef0Pu) "Angular reference frequency" annotation(
    Placement(visible = true, transformation(origin = {-90, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedFirstOrder limitedFirstOrder(tFilter = Tg1, YMax = VMax, YMin = VMin, Y0 = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction leadLag(a = {Tg3, 1}, b = {Tg2, 1}, x_scaled(start = {Pm0Pu}), x_start = {Pm0Pu}, y_start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain friction(k = Dt) annotation(
    Placement(visible = true, transformation(origin = {30, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {-60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter Types.ActivePowerPu Pm0Pu "Initial mechanical power in pu (base PNom)";
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(limitedFirstOrder.y, leadLag.u) annotation(
    Line(points = {{1, 0}, {18, 0}}, color = {0, 0, 127}));
  connect(omegaPu, feedback2.u1) annotation(
    Line(points = {{-114, -50}, {-68, -50}}, color = {0, 0, 127}));
  connect(feedback2.y, friction.u) annotation(
    Line(points = {{-51, -50}, {18, -50}}, color = {0, 0, 127}));
  connect(droop.y, feedback.u2) annotation(
    Line(points = {{-40, -19}, {-40, -8}}, color = {0, 0, 127}));
  connect(feedback2.y, droop.u) annotation(
    Line(points = {{-51, -50}, {-40, -50}, {-40, -42}}, color = {0, 0, 127}));
  connect(feedback.y, limitedFirstOrder.u) annotation(
    Line(points = {{-31, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(PmRefPu, feedback.u1) annotation(
    Line(points = {{-114, 0}, {-48, 0}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, feedback2.u2) annotation(
    Line(points = {{-79, -80}, {-60, -80}, {-60, -58}}, color = {0, 0, 127}));
  connect(PmPu, feedback1.y) annotation(
    Line(points = {{111, -1}, {100, -1}, {100, 0}, {69, 0}}, color = {0, 0, 127}));
  connect(friction.y, feedback1.u2) annotation(
    Line(points = {{41, -50}, {60, -50}, {60, -8}}, color = {0, 0, 127}));
  connect(leadLag.y, feedback1.u1) annotation(
    Line(points = {{41, 0}, {52, 0}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    uses(Modelica(version = "3.2.3")),
    Documentation(info = "<html><head></head><body><!--StartFragment--><div style=\"background-color: rgb(255, 255, 255); font-family: Consolas, 'Courier New', monospace; font-size: 14px; line-height: 19px; white-space: pre;\"><div>CIM/CGMES standard model.</div><div><br></div><div>General model for any prime mover with a PID governor. The following information has been gathered from https://www.neplan.ch/wp-content/uploads/2015/08/Nep_TURBINES_GOV.pdf.</div><br><div>Used primarily for:</div><br><div><span style=\"color: #0451a5;\">-</span> combustion turbines </div><div><span style=\"color: #0451a5;\">-</span> combined cycle units</div><br><div>Can be used to represent a variety of prime movers controlled by PID governors, such as: </div><br><div><span style=\"color: #0451a5;\">-</span> Gas turbine and single shaft combined cycle turbines </div><div><span style=\"color: #0451a5;\">-</span> Diesel engines with modern electronic or digital governors </div><div><span style=\"color: #0451a5;\">-</span> Steam turbines where steam is supplied from a large boiler drum or a large header whose pressure is substantially constant over the period under study </div><div><span style=\"color: #0451a5;\">-</span> Simple hydro turbines in dam configurations where the water column length is short and water inertia effects are minimal.</div><br><div>The above points are also true for the CIM/CGMES GovCT1 model. This GovCT2 is a modification of the GovCT1 in order to represent the frequency-dependent fuel flow limit of a specific gas turbine manufacturer.</div><br></div><!--EndFragment--></body></html>"));
end GovCT2;
