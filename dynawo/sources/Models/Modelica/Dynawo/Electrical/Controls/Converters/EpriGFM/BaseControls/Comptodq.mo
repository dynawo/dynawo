within Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls;

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

model Comptodq "Computation of dq components from grid measurements in EPRI Grid Forming model"
  extends Parameters.PLL;
  extends Parameters.OmegaFlag;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA" annotation(
  Dialog(tab = "General"));

  // Input variables
  Modelica.ComplexBlocks.Interfaces.ComplexInput iInjPu(re(start = iInj0Pu.re), im(start = iInj0Pu.im)) "Complex current in pu (base UNom, SnRef) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-270, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-120, 18}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput phi(start = Modelica.ComplexMath.arg(u0Pu)) "Voltage phase at injector terminal in rad" annotation(
    Placement(visible = true, transformation(origin = {-280, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput thetaGFM(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(visible = true, transformation(origin = {-280, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uInjPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-270, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput idConvPu(start = IdConv0Pu) "D-axis current of the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {270, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iMagPu annotation(
    Placement(visible = true, transformation(origin = {268, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {72, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput iqConvPu(start = IqConv0Pu) "Q-axis current of the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {270, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udFilterPu(start = UdFilter0Pu) "D-axis voltage at the converter's terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {270, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqFilterPu(start = UqFilter0Pu) "Q-axis voltage at the converter's terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {270, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Product idSquare annotation(
    Placement(visible = true, transformation(origin = {150, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain changeOfBaseD(k = SystemBase.SnRef / SNom)  annotation(
    Placement(visible = true, transformation(origin = {70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain changeOfBaseq(k = SystemBase.SnRef / SNom)  annotation(
    Placement(visible = true, transformation(origin = {70, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.IntegerConstant integerConstant(k = OmegaFlag) annotation(
    Placement(visible = true, transformation(origin = {-9, -65}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Math.Product iqSquare annotation(
    Placement(visible = true, transformation(origin = {150, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {-8, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sqrt sqrt1 annotation(
    Placement(visible = true, transformation(origin = {230, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add sumidiq annotation(
    Placement(visible = true, transformation(origin = {190, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ annotation(
    Placement(visible = true, transformation(origin = {30, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ1 annotation(
    Placement(visible = true, transformation(origin = {30, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.ComplexCurrentPu iInj0Pu "Start value of complex current at converter's terminal in pu (base UNom, SnRef) (generator convention)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current of the converter in pu (base UNom, SNom) (generator convention)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current of the converter in pu (base UNom, SNom) (generator convention)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
  Dialog(tab = "Initial"));
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at converter's terminal in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's terminal in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's terminal in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));

equation
  connect(transformRItoDQ.udPu, udFilterPu) annotation(
    Line(points = {{41, 96}, {100.5, 96}, {100.5, 120}, {270, 120}}, color = {0, 0, 127}));
  connect(transformRItoDQ.uqPu, uqFilterPu) annotation(
    Line(points = {{41, 84}, {99.5, 84}, {99.5, 60}, {270, 60}}, color = {0, 0, 127}));
  connect(transformRItoDQ1.uPu, iInjPu) annotation(
    Line(points = {{19, 16}, {-11, 16}, {-11, 58}, {-270, 58}}, color = {85, 170, 255}));
  connect(uInjPu, transformRItoDQ.uPu) annotation(
    Line(points = {{-270, 120}, {-0.5, 120}, {-0.5, 96}, {19, 96}}, color = {85, 170, 255}));
  connect(phi, multiSwitch.u[1]) annotation(
    Line(points = {{-280, 0}, {-141, 0}, {-141, -100}, {-18, -100}}, color = {0, 0, 127}));
  connect(thetaGFM, multiSwitch.u[2]) annotation(
    Line(points = {{-280, -100}, {-18, -100}}, color = {0, 0, 127}));
  connect(thetaGFM, multiSwitch.u[3]) annotation(
    Line(points = {{-280, -100}, {-18, -100}}, color = {0, 0, 127}));
  connect(thetaGFM, multiSwitch.u[4]) annotation(
    Line(points = {{-280, -100}, {-18, -100}}, color = {0, 0, 127}));
  connect(multiSwitch.y, transformRItoDQ1.phi) annotation(
    Line(points = {{3, -100}, {8, -100}, {8, 4}, {19, 4}}, color = {0, 0, 127}));
  connect(transformRItoDQ.phi, multiSwitch.y) annotation(
    Line(points = {{19, 84}, {8, 84}, {8, -100}, {3, -100}}, color = {0, 0, 127}));
  connect(sumidiq.y, sqrt1.u) annotation(
    Line(points = {{201, -100}, {218, -100}}, color = {0, 0, 127}));
  connect(sqrt1.y, iMagPu) annotation(
    Line(points = {{241, -100}, {268, -100}}, color = {0, 0, 127}));
  connect(integerConstant.y, multiSwitch.f) annotation(
    Line(points = {{-9, -70.5}, {-9, -69}, {-8, -69}, {-8, -88}}, color = {255, 127, 0}));
  connect(sumidiq.u1, idSquare.y) annotation(
    Line(points = {{178, -94}, {167, -94}, {167, -80}, {161, -80}}, color = {0, 0, 127}));
  connect(iqSquare.y, sumidiq.u2) annotation(
    Line(points = {{161, -130}, {168.5, -130}, {168.5, -106}, {178, -106}}, color = {0, 0, 127}));
  connect(transformRItoDQ1.udPu, changeOfBaseD.u) annotation(
    Line(points = {{41, 16}, {48.5, 16}, {48.5, 40}, {58, 40}}, color = {0, 0, 127}));
  connect(changeOfBaseD.y, idConvPu) annotation(
    Line(points = {{81, 40}, {270, 40}}, color = {0, 0, 127}));
  connect(idSquare.u1, idSquare.u2) annotation(
    Line(points = {{138, -74}, {128, -74}, {128, -86}, {138, -86}}, color = {0, 0, 127}));
  connect(transformRItoDQ1.uqPu, changeOfBaseq.u) annotation(
    Line(points = {{42, 4}, {48, 4}, {48, -20}, {58, -20}}, color = {0, 0, 127}));
  connect(changeOfBaseD.y, idSquare.u1) annotation(
    Line(points = {{82, 40}, {128, 40}, {128, -74}, {138, -74}}, color = {0, 0, 127}));
  connect(changeOfBaseq.y, iqConvPu) annotation(
    Line(points = {{82, -20}, {270, -20}}, color = {0, 0, 127}));
  connect(changeOfBaseq.y, iqSquare.u1) annotation(
    Line(points = {{82, -20}, {120, -20}, {120, -124}, {138, -124}}, color = {0, 0, 127}));
  connect(changeOfBaseq.y, iqSquare.u2) annotation(
    Line(points = {{82, -20}, {120, -20}, {120, -136}, {138, -136}}, color = {0, 0, 127}));

  annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {1, 3}, extent = {{-83, 65}, {83, -65}}, textString = "computation
to
dq")}),
    Diagram(coordinateSystem(extent = {{-260, -160}, {260, 160}})));
end Comptodq;
