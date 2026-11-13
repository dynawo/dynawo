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

model OuterLoopUControl "Outer loop with control on active power and voltage"

  // Parameters
  parameter Types.PerUnit DidMax "Maximum rate of change of idConvRefPu in pu/s (base UNom, SNom)";
  parameter Types.PerUnit DidMin "Minimum rate of change of idConvRefPu in pu/s (base UNom, SNom)";
  parameter Types.PerUnit IqBoostMaxPu "Maximum reactive current boost in pu (base UNom, SNom)";
  parameter Types.PerUnit IqBoostMinPu "Minimum reactive current boost in pu (base UNom, SNom)";
  parameter Types.CurrentModulePu IMaxPu "Maximum converter current magnitude in pu (base UNom, SNom)";
  parameter Types.PerUnit Kpd "Active power PI proportional gain in pu/pu (current base UNom, SNom / power base SNom)";
  parameter Types.PerUnit Kid "Active power PI integral gain in pu/(pu.s) (current base UNom, SNom / power base SNom)";
  parameter Types.PerUnit Kpq "Voltage PI proportional gain in pu/pu (current base UNom, SNom / voltage base UNom)";
  parameter Types.PerUnit Kiq "Voltage PI integral gain in pu/(pu.s) (current base UNom, SNom / voltage base UNom)";
  parameter Types.PerUnit Kqv "Reactive current boost gain in pu/pu, 0 to disable";
  parameter Boolean PQFlag "Current priority: true = P priority, false = Q priority";
  parameter Boolean PControlFlag "true: direct control idConvRefPu = PRefPu/ULVPu | false: PI regulator (default)";
  parameter Types.VoltageModulePu UBoostHighPu "High voltage threshold for reactive current boost in pu (base UNom)";
  parameter Types.VoltageModulePu UBoostLowPu "Low voltage threshold for reactive current boost in pu (base UNom)";
  parameter Types.Time tBoost "Time constant of the first-order filter on the reactive current boost in s, 0 to disable";
  parameter Types.Time tSid "Sample time of the idConvRefPu ramp limiter in s";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PInj0Pu) "Active power reference at LV bus in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-240, 80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-214, 58}, extent = {{-14, -14}, {14, 14}})));
  Modelica.Blocks.Interfaces.RealInput PLVPu(start = PInj0Pu) "Active power measured at LV bus in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-240, 38}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-216, 158}, extent = {{-14, -14}, {14, 14}})));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = ULV0Pu) "Voltage reference at LV bus in pu (base UNom)" annotation(
    Placement(transformation(origin = {-240, -20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-215, -59}, extent = {{-15, -15}, {15, 15}})));
  Modelica.Blocks.Interfaces.RealInput ULVPu(start = ULV0Pu) "Voltage magnitude at LV bus in pu (base UNom)" annotation(
    Placement(transformation(origin = {-240, -60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-93, 219}, extent = {{-13, -13}, {13, 13}}, rotation = -90)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput idConvRefPu(start = Id0Pu) "d-axis converter current reference in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {230, 16}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {220, 80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput iqConvRefPu(start = Iq0Pu) "q-axis converter current reference in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {230, -16}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {220, -80}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Math.Feedback sum_node_p annotation(
    Placement(transformation(origin = {-100, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback sum_node_q annotation(
    Placement(transformation(origin = {-100, -20}, extent = {{-10, -10}, {10, 10}})));
  NonElectrical.Blocks.Continuous.PIAntiWindup pIAntiWindupVariableLimitsd(Ki = Kid, Kp = Kpd, Y0 = Id0Pu, YMax = IMaxPu, YMin = -IMaxPu) annotation(
    Placement(transformation(origin = {-50, 80}, extent = {{-10, -10}, {10, 10}})));
  NonElectrical.Blocks.Continuous.PIAntiWindup pIAntiWindupVariableLimitsq(Ki = Kiq, Kp = Kpq, Y0 = -Iq0Pu, YMax = IMaxPu, YMin = -IMaxPu) annotation(
    Placement(transformation(origin = {-50, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(transformation(origin = {30, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = PControlFlag) annotation(
    Placement(transformation(origin = {-10, 60}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.InnerControls.CurrentLimiterReactiveBoost current_limiter_OuterLoop(IMaxPu = IMaxPu, PQFlag = PQFlag, UBoostHighPu = UBoostHighPu, UBoostLowPu = UBoostLowPu, Kqv = Kqv, IqBoostMaxPu = IqBoostMaxPu, IqBoostMinPu = IqBoostMinPu, U0Pu = ULV0Pu, tBoost = tBoost) annotation(
    Placement(transformation(origin = {121, -1}, extent = {{-41, -41}, {41, 41}})));
  NonElectrical.Blocks.NonLinear.RampLimiter rampLimiter(DuMax = DidMax, DuMin = DidMin, tS = tSid, Y0 = Id0Pu, y(start = Id0Pu)) annotation(
    Placement(transformation(origin = {190, 14}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  parameter Types.PerUnit Id0Pu "Start value of d-axis converter current in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit Iq0Pu "Start value of q-axis converter current in pu (base UNom, SNom) (generator convention)";
  parameter Types.ActivePowerPu PInj0Pu "Start value of active power at LV bus in pu (base SNom) (generator convention)";
  parameter Types.VoltageModulePu ULV0Pu "Start value of voltage magnitude at LV bus in pu (base UNom)";

equation
  connect(PLVPu, sum_node_p.u2) annotation(
    Line(points = {{-240, 38}, {-100, 38}, {-100, 72}}, color = {46, 194, 126}, thickness = 0.75));
  connect(division1.u2, ULVPu) annotation(
    Line(points = {{-82, 34}, {-140, 34}, {-140, -60}, {-240, -60}}, color = {230, 97, 0}, thickness = 0.75));
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{1, 60}, {18, 60}}, color = {255, 0, 255}));
  connect(division1.y, switch1.u1) annotation(
    Line(points = {{-59, 40}, {11, 40}, {11, 68}, {18, 68}}, color = {230, 97, 0}, thickness = 0.75));
  connect(switch1.y, current_limiter_OuterLoop.idRawPu) annotation(
    Line(points = {{41, 60}, {59.5, 60}, {59.5, 15}, {76, 15}}, color = {0, 0, 127}));
  connect(current_limiter_OuterLoop.idLimPu, rampLimiter.u) annotation(
    Line(points = {{166, 15}, {178, 15}, {178, 14}}, color = {0, 0, 127}));
  connect(rampLimiter.y, idConvRefPu) annotation(
    Line(points = {{201, 14}, {230, 14}}, color = {0, 0, 127}));
  connect(iqConvRefPu, current_limiter_OuterLoop.iqLimPu) annotation(
    Line(points = {{230, -16}, {230, -17}, {166, -17}}, color = {0, 0, 127}));
  connect(PRefPu, sum_node_p.u1) annotation(
    Line(points = {{-240, 80}, {-108, 80}}, color = {46, 194, 126}, thickness = 0.75));
  connect(division1.u1, PRefPu) annotation(
    Line(points = {{-82, 46}, {-140, 46}, {-140, 80}, {-240, 80}}, color = {230, 97, 0}, thickness = 0.75));
  connect(URefPu, sum_node_q.u1) annotation(
    Line(points = {{-240, -20}, {-108, -20}}, color = {46, 194, 126}, thickness = 0.75));
  connect(sum_node_q.u2, ULVPu) annotation(
    Line(points = {{-100, -28}, {-100, -60}, {-240, -60}}, color = {46, 194, 126}, thickness = 0.75));
  connect(sum_node_q.y, pIAntiWindupVariableLimitsq.u) annotation(
    Line(points = {{-90, -20}, {-62, -20}}, color = {46, 194, 126}, thickness = 0.75));
  connect(sum_node_p.y, pIAntiWindupVariableLimitsd.u) annotation(
    Line(points = {{-90, 80}, {-62, 80}}, color = {46, 194, 126}, thickness = 0.75));
  connect(pIAntiWindupVariableLimitsd.y, switch1.u3) annotation(
    Line(points = {{-38, 80}, {8, 80}, {8, 52}, {18, 52}}, color = {46, 194, 126}, thickness = 0.75));
  connect(pIAntiWindupVariableLimitsq.y, current_limiter_OuterLoop.iqRawPu) annotation(
    Line(points = {{-38, -20}, {76, -20}, {76, -18}}, color = {46, 194, 126}, thickness = 0.75));
  connect(ULVPu, current_limiter_OuterLoop.ULVPu) annotation(
    Line(points = {{-240, -60}, {40, -60}, {40, 0}, {76, 0}}, color = {0, 0, 127}));

  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(coordinateSystem(extent = {{-220, -200}, {220, 200}}), graphics = {Rectangle(extent = {{-200, 200}, {200, -200}}), Text(origin = {0, 70}, extent = {{-80, 20}, {80, -20}}, textString = "Outer Loop"), Text(origin = {0, 10}, extent = {{-80, 15}, {80, -15}}, textString = "P/U control"), Text(origin = {0, -50}, extent = {{-80, 15}, {80, -15}}, textString = "PI / Direct switchable")}),
    Diagram(coordinateSystem(extent = {{-220, -200}, {220, 200}})),
    Documentation(info = "<html><head></head><body><h4>Outer loop: P/U control – GFL control</h4>

<p>Outer control loop of the grid-following converter. It turns the active power reference and the voltage reference at
the LV bus into dq current references for the inner current loop. The active power axis can use either a PI regulator or
a direct calculation; the voltage axis always uses a PI regulator. Both axes then go through a current limiter with
reactive current boost.</p>

<h4>Equations</h4>
<p><b><i><u>Active power, PI mode</u></i></b> (<code>PControlFlag = false</code>), anti-windup PI limited to [-IMaxPu, IMaxPu]:</p>
<pre>  idRawPu = (Kpd + Kid/s) * (PRefPu - PLVPu)
</pre>
<p><b><i><u>Active power, direct mode</u></i></b> (<code>PControlFlag = true</code>):</p>
<pre>  idRawPu = PRefPu / ULVPu
</pre>
<p><b><i><u>Voltage</u></i></b>, anti-windup PI limited to [-IMaxPu, IMaxPu]:</p>
<pre>  iqRawPu = (Kpq + Kiq/s) * (URefPu - ULVPu)
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
  <li><code>PRefPu</code>: active power reference at LV bus in pu (base SNom), generator convention;</li>
  <li><code>PLVPu</code>: active power measured at LV bus in pu (base SNom), generator convention;</li>
  <li><code>URefPu</code>: voltage reference at LV bus in pu (base UNom);</li>
  <li><code>ULVPu</code>: voltage magnitude at LV bus in pu (base UNom).</li>
</ul>

<h4>Outputs</h4>
<ul>
  <li><code>idConvRefPu</code>: d-axis converter current reference in pu (base UNom, SNom), generator convention;</li>
  <li><code>iqConvRefPu</code>: q-axis converter current reference in pu (base UNom, SNom), generator convention.</li></ul><ul>
</ul>

<h4>Initialization</h4>
<ul>
  <li><code>PRefPu</code> starts at <code>PInj0Pu</code> and <code>URefPu</code> at <code>ULV0Pu</code>, so the errors are zero at t = 0;</li>
  <li>in direct mode the initial point is approximate: <code>PInj0Pu/ULV0Pu</code> is not exactly <code>Id0Pu</code>,
      because the converter current includes the filter capacitor current.</li>
</ul>

<h4>Notes</h4>
<ul>
  <li>Unlike <code>OuterLoopQControl</code>, there is no plant communication delay (<code>tPlant</code>) on the references.</li>
  <li>The direct mode is useful when the PI parameters are unknown or cause low-frequency oscillations. The interaction
      between the outer-loop PI bandwidth and the PLL is a known cause of low-frequency oscillations (Cheng et al. 2023).</li>
</ul>
</body></html>"));
end OuterLoopUControl;
