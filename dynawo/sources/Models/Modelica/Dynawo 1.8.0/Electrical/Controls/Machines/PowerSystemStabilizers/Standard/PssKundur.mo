within Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
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

model PssKundur "Power system stabilizer based on Kundur's book"

  parameter Types.PerUnit KStab "PSS gain";
  parameter Types.Time t1 "Phase compensation lead time constant in s";
  parameter Types.Time t2 "Phase compensation lag time constant in s";
  parameter Types.Time tW "Washout time constant in s";
  parameter Types.VoltageModulePu VsMinPu "Minimum output of PSS in pu (base UNom)";
  parameter Types.VoltageModulePu VsMaxPu "Maximum output of PSS in pu (base UNom)";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-140, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Grid angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-140, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput UPssPu(start = 0) "Output voltage of power system stabilizer in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Feedback dW annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainPSS(k = KStab) annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.Washout washout(tW = tW) annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction phaseCompensation(a = {t2, 1}, b = {t1, 1}) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiterPSS(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = VsMaxPu, uMin = VsMinPu) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(omegaRefPu, dW.u2) annotation(
    Line(points = {{-140, 40}, {-80, 40}, {-80, 8}}, color = {0, 0, 127}));
  connect(omegaPu, dW.u1) annotation(
    Line(points = {{-140, 0}, {-88, 0}}, color = {0, 0, 127}));
  connect(dW.y, gainPSS.u) annotation(
    Line(points = {{-70, 0}, {-42, 0}}, color = {0, 0, 127}));
  connect(gainPSS.y, washout.u) annotation(
    Line(points = {{-19, 0}, {-11, 0}, {-11, 0}, {-3, 0}, {-3, 0}, {-3, 0}, {-3, 0}, {-3, 0}}, color = {0, 0, 127}));
  connect(washout.y, phaseCompensation.u) annotation(
    Line(points = {{21, 0}, {38, 0}}, color = {0, 0, 127}));
  connect(phaseCompensation.y, limiterPSS.u) annotation(
    Line(points = {{61, 0}, {77, 0}}, color = {0, 0, 127}));
  connect(limiterPSS.y, UPssPu) annotation(
    Line(points = {{102, 0}, {130, 0}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    uses(Modelica(version = "3.2.2")),
    Documentation(info = "<html><head></head><body>This model is inherited from the Kundur \"Power System Stability and Control\" book, section 13.3.3.
  Notations are kept identical whenever possible for readability reasons.</body></html>"),
  Diagram(coordinateSystem(extent = {{-120, -100}, {120, 100}})));
end PssKundur;
