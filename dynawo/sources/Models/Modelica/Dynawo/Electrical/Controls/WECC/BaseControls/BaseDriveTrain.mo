within Dynawo.Electrical.Controls.WECC.BaseControls;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

partial model BaseDriveTrain
  extends Parameters.ParamsDriveTrain;

  Modelica.Blocks.Interfaces.RealInput PePu(start = PInj0Pu) "Electrical active power in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, -54}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {180, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference frequency used for Generator and Turbine in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-220, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput omegaGPu(start = SystemBase.omegaRef0Pu) "Generator frequency used for electrical control in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {170, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {60, 140}, extent = {{20, -20}, {-20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput omegaTPu "Turbine frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {170, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput dTorqueY "Torque derivative in pu/s (base SNom, omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {170, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 123}, extent = {{0, 0}, {0,0}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput dampingY "Damping value in pu (base SNom, omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {170, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 123}, extent = {{0, 0}, {0,0}}, rotation = 90)));

  Modelica.Blocks.Math.Add OmegaGenerator annotation(
    Placement(visible = true, transformation(origin = {74, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add OmegaTurbine annotation(
    Placement(visible = true, transformation(origin = {70, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division TorqueE annotation(
    Placement(visible = true, transformation(origin = {-150, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division TorqueM annotation(
    Placement(visible = true, transformation(origin = {-150, 60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression omegaRefPu1(y = omegaRefPu) annotation(
    Placement(visible = true, transformation(origin = {10, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression omegaRefPu2(y = omegaRefPu) annotation(
    Placement(visible = true, transformation(origin = {10, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression dTorqueY1(y = dTorqueY) annotation(
    Placement(visible = true, transformation(origin = {-130, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression dTorqueY2(y = dTorqueY) annotation(
    Placement(visible = true, transformation(origin = {-130, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression dampingY1(y = dampingY) annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression dampingY2(y = dampingY) annotation(
    Placement(visible = true, transformation(origin = {-130, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator dPhi(y_start = PInj0Pu / Kshaft) annotation(
    Placement(visible = true, transformation(origin = {90, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator dOmegaTurbine(k = 1 / (2 * Ht)) annotation(
    Placement(visible = true, transformation(origin = {-30, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator dOmegaGenerator(k = 1 / (2 * Hg)) annotation(
    Placement(visible = true, transformation(origin = {-30, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add OmegaDiff(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 dTorqueE(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-70, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 dTorqueM(k1 = -1, k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {-70, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain Damping(k = Dshaft) annotation(
    Placement(visible = true, transformation(origin = {130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain dTorque(k = Kshaft) annotation(
    Placement(visible = true, transformation(origin = {130, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit PInj0Pu "Initial value of mechanical power in pu (base SNom)";

equation
  connect(dOmegaGenerator.y, OmegaGenerator.u1) annotation(
    Line(points = {{-19, -60}, {62, -60}}, color = {0, 0, 127}));
  connect(OmegaDiff.y, dPhi.u) annotation(
    Line(points = {{42, 0}, {60, 0}, {60, 20}, {78, 20}}, color = {0, 0, 127}));
  connect(TorqueE.y, dTorqueE.u2) annotation(
    Line(points = {{-139, -60}, {-82, -60}}, color = {0, 0, 127}));
  connect(TorqueM.y, dTorqueM.u2) annotation(
    Line(points = {{-139, 60}, {-82, 60}}, color = {0, 0, 127}));
  connect(dPhi.y, dTorque.u) annotation(
    Line(points = {{101, 20}, {118, 20}}, color = {0, 0, 127}));
  connect(dTorqueM.y, dOmegaTurbine.u) annotation(
    Line(points = {{-59, 60}, {-42, 60}}, color = {0, 0, 127}));
  connect(dTorqueE.y, dOmegaGenerator.u) annotation(
    Line(points = {{-59, -60}, {-42, -60}}, color = {0, 0, 127}));
  connect(dTorque.y, dTorqueY) annotation(
    Line(points = {{141, 20}, {170, 20}}, color = {0, 0, 127}));
  connect(dampingY2.y, dTorqueM.u3) annotation(
    Line(points = {{-119, 20}, {-100, 20}, {-100, 52}, {-82, 52}}, color = {0, 0, 127}));
  connect(Damping.y, dampingY) annotation(
    Line(points = {{141, -20}, {170, -20}}, color = {0, 0, 127}));
  connect(PePu, TorqueE.u1) annotation(
    Line(points = {{-220, -54}, {-162, -54}}, color = {0, 0, 127}));
  connect(dTorqueY1.y, dTorqueM.u1) annotation(
    Line(points = {{-118, 100}, {-100, 100}, {-100, 68}, {-82, 68}}, color = {0, 0, 127}));
  connect(dampingY1.y, dTorqueE.u1) annotation(
    Line(points = {{-118, -20}, {-100, -20}, {-100, -52}, {-82, -52}}, color = {0, 0, 127}));
  connect(dTorqueY2.y, dTorqueE.u3) annotation(
    Line(points = {{-118, -100}, {-100, -100}, {-100, -68}, {-82, -68}}, color = {0, 0, 127}));
  connect(dOmegaGenerator.y, OmegaDiff.u2) annotation(
    Line(points = {{-18, -60}, {0, -60}, {0, -6}, {18, -6}}, color = {0, 0, 127}));
  connect(dOmegaTurbine.y, OmegaDiff.u1) annotation(
    Line(points = {{-18, 60}, {0, 60}, {0, 6}, {18, 6}}, color = {0, 0, 127}));
  connect(OmegaDiff.y, Damping.u) annotation(
    Line(points = {{42, 0}, {60, 0}, {60, -20}, {118, -20}}, color = {0, 0, 127}));
  connect(OmegaTurbine.y, TorqueM.u2) annotation(
    Line(points = {{81, 66}, {100, 66}, {100, 120}, {-180, 120}, {-180, 66}, {-162, 66}}, color = {0, 0, 127}));
  connect(OmegaGenerator.y, TorqueE.u2) annotation(
    Line(points = {{86, -66}, {100, -66}, {100, -120}, {-180, -120}, {-180, -66}, {-162, -66}}, color = {0, 0, 127}));
  connect(OmegaGenerator.y, omegaGPu) annotation(
    Line(points = {{86, -66}, {100, -66}, {100, -120}, {170, -120}}, color = {0, 0, 127}));
  connect(OmegaTurbine.y, omegaTPu) annotation(
    Line(points = {{81, 66}, {100, 66}, {100, 120}, {170, 120}}, color = {0, 0, 127}));
  connect(omegaRefPu1.y, OmegaGenerator.u2) annotation(
    Line(points = {{22, -100}, {40, -100}, {40, -72}, {62, -72}}, color = {0, 0, 127}));
  connect(dOmegaTurbine.y, OmegaTurbine.u2) annotation(
    Line(points = {{-18, 60}, {58, 60}}, color = {0, 0, 127}));
  connect(omegaRefPu2.y, OmegaTurbine.u1) annotation(
    Line(points = {{22, 100}, {40, 100}, {40, 72}, {58, 72}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    uses(Modelica(version = "3.2.3")),
    Diagram(coordinateSystem(extent = {{-200, -140}, {160, 140}})),
    Icon(coordinateSystem(extent = {{-200, -140}, {160, 120}}, initialScale = 0.1), graphics = {Rectangle(origin = {-20, -10}, extent = {{-180, 130}, {180, -130}}), Text(origin = {-13, -3}, extent = {{-147, 103}, {133, -99}}, textString = "WTGT"), Text(origin = {-232, 37}, extent = {{-28, 21}, {28, -21}}, textString = "omegaRefPu"), Text(origin = {194, 34}, extent = {{-14, 16}, {14, -16}}, textString = "PePu"), Text(origin = {-148, 135}, extent = {{-28, 21}, {28, -21}}, textString = "omegaTPu"), Text(origin = {16, 135}, extent = {{-28, 21}, {28, -21}}, textString = "omegaGPu")}),
    version = "");
end BaseDriveTrain;
