within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model VRProportionalReactiveFeedback
  import Modelica;
  import Dynawo;
  import Dynawo.NonElectrical.Logs.Constraint;
  import Dynawo.NonElectrical.Logs.ConstraintKeys;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Types.VoltageModulePu EfdMaxPu "Maximum allowed exciter field voltage in pu (user-selected base voltage)";
  parameter Types.VoltageModulePu EfdMinPu "Minimum allowed exciter field voltage in pu (user-selected base voltage)";
  parameter Types.PerUnit Gain "Control gain";
  parameter Types.ReactivePowerPu QsMaxPu "Maximum stator reactive power in pu (base QNom)";
  parameter Types.ReactivePowerPu QsMinPu "Minimum stator reactive power in pu (base QNom)";
  parameter Types.Time tIntegral "Integration time constant in s";
  parameter Types.PerUnit UcTDerMaxPu "Maximum time derivative of the voltage request in pu/s (base UNom)";
  parameter Types.VoltageModulePu UsMaxPu "Maximum stator voltage in pu (base UNom)";
  parameter Types.VoltageModulePu UsMinPu "Minimum stator voltage in pu (base UNom)";

  constant Types.PerUnit Cq0 = 15.0 "Inverse gain applied to stator reactive power";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput deltaUsRefPu(start = 0) "Additional reference stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QsPu(start = Qs0Pu) "Stator reactive power in pu (base QNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) "Reference stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-220, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Exciter field voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {210, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Blocks
  Modelica.Blocks.Math.Gain gainU(k = Gain) annotation(
    Placement(visible = true, transformation(origin = {130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 error(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiterEfd(uMax = EfdMaxPu, uMin = EfdMinPu) annotation(
    Placement(visible = true, transformation(origin = {170, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiterQ(uMax = QsMaxPu, uMin = QsMinPu) annotation(
    Placement(visible = true, transformation(origin = {-90, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-40, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainQ(k = 1 / (tIntegral * Cq0)) annotation(
    Placement(visible = true, transformation(origin = {10, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add UsRefTotal annotation(
    Placement(visible = true, transformation(origin = {-150, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MaxThresholdSwitch ComputationUcDerTLimitMax(UMax = UsMaxPu, yNotSatMax = 0, ySatMax = UcTDerMaxPu) annotation(
    Placement(visible = true, transformation(origin = {10, 80}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
  Dynawo.NonElectrical.Blocks.NonLinear.MinThresholdSwitch ComputationUcDerTLimitMin(UMin = UsMinPu, yNotSatMin = -UcTDerMaxPu, ySatMin = 0) annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Here, UsMin and UsMax do not play a symmetric role, to be checked

  parameter Types.VoltageModulePu Efd0Pu "Initial exciter field voltage in pu (user-selected voltage)";
  parameter Types.ReactivePowerPu Qs0Pu "Initial stator reactive power in pu (base QNom)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";
  parameter Types.VoltageModulePu UsRef0Pu "Initial reference stator voltage in pu (base UNom)";

protected
  Boolean constraintUsMax(start = false) "Maximum limit for stator voltage is reached";
  Boolean constraintUsMin(start = false) "Minimum limit for stator voltage is reached";
  Boolean limitationEfd(start = false) "If true, Efd limitation is reached";

equation
  //TimeLine
  when UsPu >= UsMaxPu then
    Constraint.logConstraintBegin(ConstraintKeys.UsMax);
    constraintUsMax = true;
  //UcTDerUpMaxPu = UcTDerMaxPu;
  elsewhen (UsPu < UsMaxPu) and pre(constraintUsMax) then
    Constraint.logConstraintEnd(ConstraintKeys.UsMax);
    constraintUsMax = false;
  //UcTDerUpMaxPu = 0.;
  end when;

  when UsPu <= UsMinPu then
    Constraint.logConstraintBegin(ConstraintKeys.UsMin);
    constraintUsMin = true;
  //UcTDerDownMaxPu = 0;
  elsewhen (UsPu > UsMinPu) and pre(constraintUsMin) then
    Constraint.logConstraintEnd(ConstraintKeys.UsMin);
    constraintUsMin = false;
  //UcTDerDownMaxPu = - UcTDerMaxPu;
  end when;

  when (limiterEfd.u <= EfdMinPu) then
    Timeline.logEvent1(TimelineKeys.VRLimitationEfdMin);
    limitationEfd = true;
  elsewhen(limiterEfd.u >= EfdMaxPu) then
    Timeline.logEvent1(TimelineKeys.VRLimitationEfdMax);
    limitationEfd = true;
  elsewhen (limiterEfd.u > EfdMinPu and limiterEfd.u < EfdMaxPu) and pre(limitationEfd) then
    Timeline.logEvent1(TimelineKeys.VRBackToRegulation);
    limitationEfd = false;
  end when;

  connect(ComputationUcDerTLimitMin.y, variableLimiter.limit2) annotation(
    Line(points = {{21, 0}, {21, 0}, {40, 0}, {40, 32}, {58, 32}}, color = {0, 0, 127}));
  connect(UsPu, ComputationUcDerTLimitMin.u) annotation(
    Line(points = {{-220, 0}, {-2, 0}}, color = {0, 0, 127}));
  connect(ComputationUcDerTLimitMax.y, variableLimiter.limit1) annotation(
    Line(points = {{21, 80}, {40, 80}, {40, 48}, {58, 48}}, color = {0, 0, 127}));
  connect(gainQ.y, variableLimiter.u) annotation(
    Line(points = {{21, 40}, {58, 40}}, color = {0, 0, 127}));
  connect(variableLimiter.y, integrator.u) annotation(
    Line(points = {{81, 40}, {98, 40}}, color = {0, 0, 127}));
  connect(integrator.y, error.u1) annotation(
    Line(points = {{121, 40}, {140, 40}, {140, 0}, {60, 0}, {60, -32}, {78, -32}}, color = {0, 0, 127}));
  connect(gainQ.u, feedback.y) annotation(
    Line(points = {{-2, 40}, {-31, 40}}, color = {0, 0, 127}));
  connect(QsPu, feedback.u2) annotation(
    Line(points = {{-160, 40}, {-120, 40}, {-120, 20}, {-40, 20}, {-40, 32}}, color = {0, 0, 127}));
  connect(feedback.u1, limiterQ.y) annotation(
    Line(points = {{-48, 40}, {-79, 40}}, color = {0, 0, 127}));
  connect(QsPu, limiterQ.u) annotation(
    Line(points = {{-160, 40}, {-102, 40}}, color = {0, 0, 127}));
  connect(limiterEfd.u, gainU.y) annotation(
    Line(points = {{158, -40}, {141, -40}}, color = {0, 0, 127}));
  connect(limiterEfd.y, EfdPu) annotation(
    Line(points = {{181, -40}, {210, -40}}, color = {0, 0, 127}));
  connect(gainU.u, error.y) annotation(
    Line(points = {{118, -40}, {101, -40}}, color = {0, 0, 127}));
  connect(deltaUsRefPu, UsRefTotal.u1) annotation(
    Line(points = {{-220, -40}, {-180, -40}, {-180, -54}, {-162, -54}}, color = {0, 0, 127}));
  connect(UsRefPu, UsRefTotal.u2) annotation(
    Line(points = {{-220, -80}, {-180, -80}, {-180, -66}, {-162, -66}}, color = {0, 0, 127}));
  connect(UsPu, error.u2) annotation(
    Line(points = {{-220, 0}, {-20, 0}, {-20, -40}, {78, -40}}, color = {0, 0, 127}));
  connect(UsRefTotal.y, error.u3) annotation(
    Line(points = {{-139, -60}, {60, -60}, {60, -48}, {78, -48}}, color = {0, 0, 127}));
  connect(UsPu, ComputationUcDerTLimitMax.u) annotation(
    Line(points = {{-220, 0}, {-180, 0}, {-180, 80}, {-2, 80}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Documentation(info = "<html><head></head><body>This a block version of model VRProportionalReactiveFeedback. It is a temporary model that needs to be checked since VRProportionalReactiveFeedback equations are not fully understood (see comments in the code).<div><br></div><div>The initialization model is still to be written.</div></body></html>"),
  Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})));
end VRProportionalReactiveFeedback;
