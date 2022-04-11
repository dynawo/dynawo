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
// This a block version of model VRProportionalReactiveFeedback. It is a temporary model that needs to be checked since VRProportionalReactiveFeedback equations are not fully understood (see comments in the code).
// The init model is still to be written.
  import Modelica.Blocks;
  import Dynawo.NonElectrical.Logs.Constraint;
  import Dynawo.NonElectrical.Logs.ConstraintKeys;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;
  import Dynawo.NonElectrical.Blocks.NonLinear.LimiterDoubleOutput;
  import Dynawo.NonElectrical.Blocks.NonLinear.MaxThresholdSwitch;
  import Dynawo.NonElectrical.Blocks.NonLinear.MinThresholdSwitch;

  parameter Real Gain "Control gain";
  parameter Types.Time tIntegral "Integral time";
  parameter Types.ReactivePowerPu QsMinPu "Minimum stator reactive power";
  parameter Types.ReactivePowerPu QsMaxPu "Maximum stator reactive power";
  parameter Types.VoltageModulePu UsMinPu "Minimum stator voltage";
  parameter Types.VoltageModulePu UsMaxPu "Maximum stator voltage";
  parameter Types.VoltageModulePu EfdMinPu "Minimum allowed Efd";
  parameter Types.VoltageModulePu EfdMaxPu "Maximum allowed Efd";
  parameter Real UcTDerMaxPu ( unit = "kV/s") "Maximum time derivative of the voltage request";
  constant Real Cq0 = 15.0;

  // Inputs
  Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-176, -38}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-176, -38}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Interfaces.RealInput UsPu(start = Us0Pu) annotation(
    Placement(visible = true, transformation(origin = {-136, -96}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-56, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Interfaces.RealInput QsPu(start = Qs0Pu) annotation(
    Placement(visible = true, transformation(origin = {-176, 34}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-176, 34}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  // Outputs
  Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {66, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {66, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Blocks
  Blocks.Math.Gain gainU(k = Gain) annotation(
    Placement(visible = true, transformation(origin = {-42, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add3 error(k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {-98, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Nonlinear.Limiter limiterEfd(limitsAtInit = true, uMax = EfdMaxPu, uMin = EfdMinPu)  annotation(
    Placement(visible = true, transformation(origin = {10, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Nonlinear.Limiter limiterQ(limitsAtInit = true, uMax = QsMaxPu, uMin = QsMinPu)  annotation(
    Placement(visible = true, transformation(origin = {-106, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-70, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Gain gainQ(k = 1/(tIntegral*Cq0)) annotation(
    Placement(visible = true, transformation(origin = {-34, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.Integrator integrator annotation(
    Placement(visible = true, transformation(origin = {46, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Nonlinear.VariableLimiter variableLimiter(limitsAtInit = true)  annotation(
    Placement(visible = true, transformation(origin = {6, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  MaxThresholdSwitch ComputationUcDerTLimitMax(UMax = UsMaxPu, yNotSatMax = 0, ySatMax = UcTDerMaxPu)  annotation(
    Placement(visible = true, transformation(origin = {96, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  MinThresholdSwitch ComputationUcDerTLimitMin(UMin = UsMinPu, yNotSatMin = -UcTDerMaxPu, ySatMin = 0)  annotation(
    Placement(visible = true, transformation(origin = {126, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  // Here, UsMin and UsMax don't play a symetric role, to be checked

  parameter Types.ReactivePowerPu Qs0Pu "Initial stator reactive power";
  parameter Types.VoltageModulePu UsRef0Pu "Initial control voltage"; // pu = Unom
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage"; // pu = Unom
  parameter Types.VoltageModulePu Efd0Pu "Initial Efd";

protected
  Boolean constraintUsMax(start = false) "Maximum limit reached for stator voltage";
  Boolean constraintUsMin(start = false) "Minimum limit reached for stator voltage";
  Boolean limitationEfd(start = false) "Limitation reached for Efd";

equation
  connect(ComputationUcDerTLimitMin.y, variableLimiter.limit2) annotation(
    Line(points = {{126, -34}, {126, -34}, {126, 60}, {-12, 60}, {-12, 26}, {-6, 26}, {-6, 26}}, color = {0, 0, 127}));
  connect(UsPu, ComputationUcDerTLimitMin.u) annotation(
    Line(points = {{-136, -96}, {-136, -96}, {-136, -68}, {126, -68}, {126, -60}, {126, -60}, {126, -58}}, color = {0, 0, 127}));
  connect(ComputationUcDerTLimitMax.y, variableLimiter.limit1) annotation(
    Line(points = {{96, -34}, {96, -34}, {96, 58}, {-10, 58}, {-10, 42}, {-6, 42}, {-6, 42}}, color = {0, 0, 127}));
  connect(UsPu, ComputationUcDerTLimitMax.u) annotation(
    Line(points = {{-136, -96}, {-136, -96}, {-136, -68}, {96, -68}, {96, -58}, {96, -58}}, color = {0, 0, 127}));
  connect(UsPu, error.u3) annotation(
    Line(points = {{-136, -96}, {-136, -46}, {-110, -46}}, color = {0, 0, 127}));
  connect(gainQ.y, variableLimiter.u) annotation(
    Line(points = {{-22, 34}, {-6, 34}, {-6, 34}, {-6, 34}}, color = {0, 0, 127}));
  connect(variableLimiter.y, integrator.u) annotation(
    Line(points = {{18, 34}, {34, 34}, {34, 34}, {34, 34}}, color = {0, 0, 127}));
  connect(integrator.y, error.u1) annotation(
    Line(points = {{57, 34}, {77, 34}, {77, 0}, {-137, 0}, {-137, -30}, {-109, -30}, {-109, -31}, {-111, -31}, {-111, -30}}, color = {0, 0, 127}));
  connect(gainQ.u, feedback.y) annotation(
    Line(points = {{-46, 34}, {-60, 34}, {-60, 34}, {-60, 34}}, color = {0, 0, 127}));
  connect(QsPu, feedback.u2) annotation(
    Line(points = {{-176, 34}, {-157, 34}, {-157, 34}, {-138, 34}, {-138, 14}, {-70, 14}, {-70, 26}, {-70, 26}, {-70, 26}, {-70, 26}}, color = {0, 0, 127}));
  connect(feedback.u1, limiterQ.y) annotation(
    Line(points = {{-78, 34}, {-86, 34}, {-86, 34}, {-94, 34}, {-94, 34}, {-94, 34}}, color = {0, 0, 127}));
  connect(QsPu, limiterQ.u) annotation(
    Line(points = {{-176, 34}, {-147, 34}, {-147, 34}, {-118, 34}, {-118, 34}, {-118, 34}, {-118, 34}, {-118, 34}}, color = {0, 0, 127}));
  connect(limiterEfd.u, gainU.y) annotation(
    Line(points = {{-2, -38}, {-17, -38}, {-17, -38}, {-34, -38}, {-34, -38}, {-31, -38}, {-31, -38}, {-30, -38}}, color = {0, 0, 127}));
  connect(limiterEfd.y, EfdPu) annotation(
    Line(points = {{21, -38}, {59, -38}, {59, -38}, {65, -38}}, color = {0, 0, 127}));
  connect(UsRefPu, error.u2) annotation(
    Line(points = {{-176, -38}, {-110, -38}}, color = {0, 0, 127}));
  connect(gainU.u, error.y) annotation(
    Line(points = {{-54, -38}, {-88, -38}, {-88, -38}, {-86, -38}}, color = {0, 0, 127}));

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

  annotation(preferredView = "diagram");
end VRProportionalReactiveFeedback;
