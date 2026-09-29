within Dynawo.Electrical.Controls.PEIR.BaseControls.OuterLoops;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
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

model OuterLoopQControl "Outer loop with control on active power and reactive power"
  // Parameters
  parameter Types.PerUnit DidMax "Maximum rate of change of idConvRefPu in pu/s (base UNom, SNom)";
  parameter Types.PerUnit DidMin "Minimum rate of change of idConvRefPu in pu/s (base UNom, SNom)";
  parameter Types.PerUnit IqBoostMaxPu "Maximum reactive current boost in pu (base UNom, SNom)";
  parameter Types.PerUnit IqBoostMinPu "Minimum reactive current boost in pu (base UNom, SNom)";
  parameter Types.CurrentModulePu IMaxPu "Maximum converter current magnitude in pu (base UNom, SNom)";
  parameter Types.PerUnit Kpd "Active power PI proportional gain in pu/pu (current base UNom, SNom / power base SNom)";
  parameter Types.PerUnit Kid "Active power PI integral gain in pu/(pu.s) (current base UNom, SNom / power base SNom)";
  parameter Types.PerUnit Kpq "Reactive power PI proportional gain in pu/pu (current base UNom, SNom / power base SNom)";
  parameter Types.PerUnit Kiq "Reactive power PI integral gain in pu/(pu.s) (current base UNom, SNom / power base SNom)";
  parameter Types.PerUnit Kqv "Reactive current boost gain in pu/pu, 0 to disable";
  parameter Boolean PQFlag "Current priority: true = P priority, false = Q priority";
  parameter Boolean PControlFlag "true: direct control idConvRefPu = PRefFiltPu/ULVPu | false: PI regulator (default)";
  parameter Boolean QControlFlag "true: direct control iqConvRefPu = QRefFiltPu/ULVPu | false: PI regulator (default)";
  parameter Types.VoltageModulePu UBoostHighPu "High voltage threshold for reactive current boost in pu (base UNom)";
  parameter Types.VoltageModulePu UBoostLowPu "Low voltage threshold for reactive current boost in pu (base UNom)";
  parameter Types.Time tBoost "Time constant of the first-order filter on the reactive current boost in s, 0 to disable";
  parameter Types.Time tPlant "Time constant of the plant-to-outer-loop delay in s";
  parameter Types.Time tSid "Sample time of the idConvRefPu ramp limiter in s";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PInj0Pu) "Active power reference at LV bus in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-240, 80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-220, 60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput PLVFilteredPu(start = PInj0Pu) "Filtered active power measured at LV bus in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-240, 40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-220, 160}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QInj0Pu) "Reactive power reference at LV bus in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-240, -40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-220, -60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput QLVFilteredPu(start = QInj0Pu) "Filtered reactive power measured at LV bus in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-240, -80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-220, -160}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput ULVPu(start = ULV0Pu) "Voltage magnitude at LV bus in pu (base UNom)" annotation(
    Placement(transformation(origin = {-240, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-93, 219}, extent = {{-13, -13}, {13, 13}}, rotation = -90)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput idConvRefPu(start = Id0Pu) "d-axis converter current reference in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {230, 16}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {220, 80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput iqConvRefPu(start = -Iq0Pu) "q-axis converter current reference in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {230, -16}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {220, -80}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Math.Feedback sum_node_p annotation(
    Placement(transformation(origin = {-98, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback sum_node_q annotation(
    Placement(transformation(origin = {-100, -40}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindup pIAntiWindupVariableLimitsd(Ki = Kid, Kp = Kpd, Y0 = Id0Pu, YMax = IMaxPu, YMin = -IMaxPu) annotation(
    Placement(transformation(origin = {-50, 80}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindup pIAntiWindupVariableLimitsq(Y0 = -Iq0Pu, Ki = Kiq, Kp = Kpq, YMax = IMaxPu, YMin = -IMaxPu) annotation(
    Placement(transformation(origin = {-48, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Division division annotation(
    Placement(transformation(origin = {-70, -100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(transformation(origin = {30, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(transformation(origin = {30, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = PControlFlag) annotation(
    Placement(transformation(origin = {-10, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1(k = QControlFlag) annotation(
    Placement(transformation(origin = {-10, -60}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.InnerControls.CurrentLimiterReactiveBoost current_limiter_outer_loop(IMaxPu = IMaxPu, PQFlag = PQFlag, UBoostHighPu = UBoostHighPu, UBoostLowPu = UBoostLowPu, Kqv = Kqv, IqBoostMaxPu = IqBoostMaxPu, IqBoostMinPu = IqBoostMinPu, U0Pu = ULV0Pu, tBoost = tBoost) annotation(
    Placement(transformation(origin = {120, 0}, extent = {{-40, -40}, {40, 40}})));
  Dynawo.NonElectrical.Blocks.NonLinear.RampLimiter rampLimiter(DuMax = DidMax, DuMin = DidMin, tS = tSid, Y0 = Id0Pu, y(start = Id0Pu)) annotation(
    Placement(transformation(origin = {190, 16}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tPlant, y_start = PInj0Pu) annotation(
    Placement(transformation(origin = {-170, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tPlant, y_start = QInj0Pu) annotation(
    Placement(transformation(origin = {-170, -40}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  parameter Types.PerUnit Id0Pu "Start value of d-axis converter current in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit Iq0Pu "Start value of q-axis converter current in pu (base UNom, SNom) (generator convention)";
  parameter Types.ActivePowerPu PInj0Pu "Start value of active power at LV bus in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QInj0Pu "Start value of reactive power at LV bus in pu (base SNom) (generator convention)";
  parameter Types.VoltageModulePu ULV0Pu "Start value of voltage magnitude at LV bus in pu (base UNom)";

equation
  connect(PLVFilteredPu, sum_node_p.u2) annotation(
    Line(points = {{-240, 40}, {-98, 40}, {-98, 72}}, color = {46, 194, 126}, thickness = 0.75));
  connect(QLVFilteredPu, sum_node_q.u2) annotation(
    Line(points = {{-240, -80}, {-100, -80}, {-100, -48}}, color = {46, 194, 126}, thickness = 0.75));
  connect(division1.u2, ULVPu) annotation(
    Line(points = {{-82, 34}, {-120, 34}, {-120, 0}, {-240, 0}}, color = {230, 97, 0}, thickness = 0.75));
  connect(division.u2, ULVPu) annotation(
    Line(points = {{-82, -106}, {-120, -106}, {-120, 0}, {-240, 0}}, color = {230, 97, 0}, thickness = 0.75));
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{1, 60}, {18, 60}}, color = {255, 0, 255}));
  connect(division1.y, switch1.u1) annotation(
    Line(points = {{-59, 40}, {8.5, 40}, {8.5, 68}, {18, 68}}, color = {230, 97, 0}, thickness = 0.75));
  connect(booleanConstant1.y, switch2.u2) annotation(
    Line(points = {{1, -60}, {18, -60}}, color = {255, 0, 255}));
  connect(division.y, switch2.u1) annotation(
    Line(points = {{-59, -100}, {11, -100}, {11, -52}, {17, -52}}, color = {230, 97, 0}, thickness = 0.75));
  connect(switch1.y, current_limiter_outer_loop.idRawPu) annotation(
    Line(points = {{41, 60}, {60.5, 60}, {60.5, 16}, {76, 16}}, color = {0, 0, 127}));
  connect(current_limiter_outer_loop.idLimPu, rampLimiter.u) annotation(
    Line(points = {{164, 16}, {178, 16}}, color = {0, 0, 127}));
  connect(rampLimiter.y, idConvRefPu) annotation(
    Line(points = {{201, 16}, {230, 16}}, color = {0, 0, 127}));
  connect(iqConvRefPu, current_limiter_outer_loop.iqLimPu) annotation(
    Line(points = {{230, -16}, {164, -16}}, color = {0, 0, 127}));
  connect(PRefPu, firstOrder.u) annotation(
    Line(points = {{-240, 80}, {-182, 80}}, color = {0, 0, 127}));
  connect(firstOrder.y, sum_node_p.u1) annotation(
    Line(points = {{-158, 80}, {-106, 80}}, color = {46, 194, 126}, thickness = 0.75));
  connect(division1.u1, firstOrder.y) annotation(
    Line(points = {{-82, 46}, {-140, 46}, {-140, 80}, {-158, 80}}, color = {230, 97, 0}, thickness = 0.75));
  connect(QRefPu, firstOrder1.u) annotation(
    Line(points = {{-240, -40}, {-182, -40}}, color = {0, 0, 127}));
  connect(firstOrder1.y, sum_node_q.u1) annotation(
    Line(points = {{-159, -40}, {-108, -40}}, color = {46, 194, 126}, thickness = 0.75));
  connect(division.u1, firstOrder1.y) annotation(
    Line(points = {{-82, -94}, {-82, -93}, {-145, -93}, {-145, -39.5}, {-159, -39.5}, {-159, -40}}, color = {230, 97, 0}, thickness = 0.75));
  connect(sum_node_q.y, pIAntiWindupVariableLimitsq.u) annotation(
    Line(points = {{-91, -40}, {-60, -40}}, color = {46, 194, 126}, thickness = 0.75));
  connect(pIAntiWindupVariableLimitsq.y, switch2.u3) annotation(
    Line(points = {{-37, -40}, {8, -40}, {8, -68}, {17, -68}}, color = {46, 194, 126}, thickness = 0.75));
  connect(sum_node_p.y, pIAntiWindupVariableLimitsd.u) annotation(
    Line(points = {{-89, 80}, {-62, 80}}, color = {46, 194, 126}, thickness = 0.75));
  connect(pIAntiWindupVariableLimitsd.y, switch1.u3) annotation(
    Line(points = {{-38, 80}, {12, 80}, {12, 52}, {18, 52}}, color = {46, 194, 126}, thickness = 0.75));
  connect(switch2.y, current_limiter_outer_loop.iqRawPu) annotation(
    Line(points = {{42, -60}, {60, -60}, {60, -16}, {76, -16}}, color = {0, 0, 127}));
  connect(ULVPu, current_limiter_outer_loop.ULVPu) annotation(
    Line(points = {{-240, 0}, {76, 0}}, color = {0, 0, 127}));

  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(coordinateSystem(extent = {{-220, -200}, {220, 200}}), graphics = {Rectangle(extent = {{-200, 200}, {200, -200}}), Text(origin = {0, 70}, extent = {{-80, 20}, {80, -20}}, textString = "Outer Loop"), Text(origin = {0, 10}, extent = {{-80, 15}, {80, -15}}, textString = "P/Q/V control"), Text(origin = {0, -50}, extent = {{-80, 15}, {80, -15}}, textString = "PI / Direct switchable")}),
    Diagram(coordinateSystem(extent = {{-220, -200}, {220, 200}})),
        Documentation(info = "<html><head></head><body><h4>Outer loop: P/Q control – GFL control</h4>

<p>Outer control loop of the grid-following converter. It turns the active and reactive power references at the LV bus
into dq current references for the inner current loop. Each axis can use either a PI regulator or a direct calculation,
and both axes then go through a current limiter with reactive current boost.</p>

<h4>Equations</h4>
<p>Plant communication delay:</p>
<pre>  PRefFiltPu = PRefPu / (1 + s*tPlant)
  QRefFiltPu = QRefPu / (1 + s*tPlant)
</pre>
<p><b><i><u>PI mode</u></i></b> (<code>PControlFlag = false</code>, <code>QControlFlag = false</code>), anti-windup PI limited to [-IMaxPu, IMaxPu]:</p>
<pre>  idRawPu = (Kpd + Kid/s) * (PRefFiltPu - PLVFilteredPu)
  iqRawPu = (Kpq + Kiq/s) * (QRefFiltPu - QLVFilteredPu)
</pre>
<p><b><i><u>Direct mode</u></i></b> (<code>PControlFlag = true</code>, <code>QControlFlag = true</code>):</p>
<pre>  idRawPu = PRefFiltPu / ULVPu
  iqRawPu = QRefFiltPu / ULVPu
</pre>
<p>Limitation:</p>
<ul>
  <li>the current limiter limits the current magnitude to <code>IMaxPu</code>, with P or Q priority (<code>PQFlag</code>), and adds a
      reactive current boost outside <code>[UBoostLowPu, UBoostHighPu]</code> (gain <code>Kqv</code>), limited to
      <code>[IqBoostMinPu, IqBoostMaxPu]</code> and filtered by <code>tBoost</code>;</li>
  <li>the d-axis reference is then rate-limited to <code>[DidMin, DidMax]</code> (sample time <code>tSid</code>).</li>
</ul>

<h4>Inputs</h4>
<ul>
  <li><code>PRefPu</code>, <code>QRefPu</code>: power references at LV bus from the plant controller, in pu (base SNom), generator convention;</li>
  <li><code>PLVFilteredPu</code>, <code>QLVFilteredPu</code>: filtered powers measured at LV bus, in pu (base SNom), generator convention;</li>
  <li><code>ULVPu</code>: voltage magnitude at LV bus in pu (base UNom).</li>
</ul>

<h4>Outputs</h4>
<ul>
  <li><code>idConvRefPu</code>: d-axis converter current reference in pu (base UNom, SNom), generator convention;</li>
  <li><code>iqConvRefPu</code>: q-axis converter current reference in pu (base UNom, SNom), generator convention.</li></ul><ul>
</ul>

<h4>Initialization</h4>
<ul>
  <li>The filters start at <code>PInj0Pu</code>, <code>QInj0Pu</code>, so the power errors are zero at t = 0;</li>
  <li>the PIs start at <code>Id0Pu</code> and <code>-Iq0Pu</code>, so <code>iqConvRefPu</code> starts at <code>+Iq0Pu</code>;
      the ramp limiter starts at <code>Id0Pu</code>;</li>
  <li>in direct mode the initial point is approximate: <code>PInj0Pu/ULV0Pu</code> is not exactly <code>Id0Pu</code>,
      because the converter current includes the filter capacitor current.</li>
</ul>

<h4>Notes</h4><ul>
  <li>The direct mode is useful when the PI parameters are unknown or cause low-frequency oscillations. The interaction
      between the outer-loop PI bandwidth and the PLL is a known cause of low-frequency oscillations (Cheng et al. 2023).</li>
</ul>
</body></html>"));
end OuterLoopQControl;
