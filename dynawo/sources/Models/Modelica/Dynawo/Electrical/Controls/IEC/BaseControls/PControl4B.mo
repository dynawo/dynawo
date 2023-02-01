within Dynawo.Electrical.Controls.IEC.BaseControls;

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

model PControl4B "Active power control module for type 4B wind turbines (IEC N°61400-27-1)"
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  extends Dynawo.Electrical.Controls.IEC.BaseClasses.BasePControl4(absLimRateLimFirstOrderAntiWindup.tI = tPOrdP4B, absLimRateLimFirstOrderAntiWindup.DyMax = DPMaxP4BPu, absLimRateLimFirstOrderAntiWindup.UseLimits = true);

  //Nominal parameter
  parameter Types.Time tS "Integration time step in s";

  //PControl parameters
  parameter Types.PerUnit DPMaxP4BPu "Maximum WT power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMax4BPu "Maximum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMin4BPu "Minimum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPAero "Aerodynamic power response time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPOrdP4B "Power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));

  //Input variable
  Modelica.Blocks.Interfaces.RealInput omegaGenPu(start = SystemBase.omega0Pu) "Generator angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput PAeroPu(start = -P0Pu * SystemBase.SnRef / SNom) "Aerodynamic power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {170, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Product product2 annotation(
    Placement(visible = true, transformation(origin = {50, -100}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.StandAloneRampRateLimiter standAloneRampRateLimiter(DuMax = DPRefMax4BPu, DuMin = DPRefMin4BPu, Y0 = -P0Pu * SystemBase.SnRef / SNom, tS = tS)  annotation(
    Placement(visible = true, transformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tPAero, y_start = -P0Pu * SystemBase.SnRef / SNom)  annotation(
    Placement(visible = true, transformation(origin = {110, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(switch1.y, product2.u1) annotation(
    Line(points = {{22, -100}, {30, -100}, {30, -106}, {38, -106}}, color = {0, 0, 127}));
  connect(product2.y, absLimRateLimFirstOrderAntiWindup.u) annotation(
    Line(points = {{62, -100}, {78, -100}}, color = {0, 0, 127}));
  connect(omegaGenPu, product2.u2) annotation(
    Line(points = {{-180, 20}, {30, 20}, {30, -94}, {38, -94}}, color = {0, 0, 127}));
  connect(PWTRefPu, standAloneRampRateLimiter.u) annotation(
    Line(points = {{-180, -100}, {-122, -100}}, color = {0, 0, 127}));
  connect(standAloneRampRateLimiter.y, product.u1) annotation(
    Line(points = {{-98, -100}, {-80, -100}, {-80, -134}, {-62, -134}}, color = {0, 0, 127}));
  connect(standAloneRampRateLimiter.y, switch1.u3) annotation(
    Line(points = {{-98, -100}, {-40, -100}, {-40, -92}, {-2, -92}}, color = {0, 0, 127}));
  connect(switch1.y, firstOrder.u) annotation(
    Line(points = {{22, -100}, {30, -100}, {30, -120}, {80, -120}, {80, -140}, {98, -140}}, color = {0, 0, 127}));
  connect(firstOrder.y, PAeroPu) annotation(
    Line(points = {{122, -140}, {170, -140}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {83, 35}, extent = {{-14, 21}, {14, -20}}, textString = "B")}));
end PControl4B;
