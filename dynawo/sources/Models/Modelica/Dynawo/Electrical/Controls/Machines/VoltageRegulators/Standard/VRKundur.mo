within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;

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

model VRKundur "Proportional voltage regulator based on Kundur's book"

  parameter Types.VoltageModulePu EfdMaxPu "Maximum excitation voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu EfdMinPu "Minimum excitation voltage in pu (user-selected base voltage)";
  parameter Types.PerUnit Ka "Exciter gain";
  parameter Types.Time tR "Transducer time constant in s";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput UPssPu(start = 0) "Output voltage of power system stabilizer in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-56, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-56, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) "Reference stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-56, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput efdPu(start = Efd0Pu) "Excitation voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder transducer(k = 1, T = tR, y_start = Us0Pu) annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 error(k1 = 1, k2 = -1, k3 = 1) annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain exciter(k = Ka) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiterAVR(uMax = EfdMaxPu, uMin = EfdMinPu) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";

  final parameter Types.VoltageModulePu UsRef0Pu = Efd0Pu / Ka + Us0Pu "Initial reference stator voltage in pu (base UNom)";

equation
  connect(UsRefPu, error.u1) annotation(
    Line(points = {{-120, 40}, {-40, 40}, {-40, 8}, {-22, 8}}, color = {0, 0, 127}));
  connect(limiterAVR.y, efdPu) annotation(
    Line(points = {{81, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(exciter.y, limiterAVR.u) annotation(
    Line(points = {{41, 0}, {58, 0}}, color = {0, 0, 127}));
  connect(error.y, exciter.u) annotation(
    Line(points = {{1, 0}, {18, 0}}, color = {0, 0, 127}));
  connect(transducer.y, error.u2) annotation(
    Line(points = {{-58, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(UsPu, transducer.u) annotation(
    Line(points = {{-120, 0}, {-82, 0}}, color = {0, 0, 127}));
  connect(UPssPu, error.u3) annotation(
    Line(points = {{-120, -40}, {-40, -40}, {-40, -8}, {-22, -8}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    uses(Modelica(version = "3.2.2")),
    Documentation(info = "<html><head></head><body>This model is inherited from the Kundur \"Power System Stability and Control\" book, section 13.3.3.
  Notations are kept identical whenever possible for readability reasons.</body></html>"));
end VRKundur;
