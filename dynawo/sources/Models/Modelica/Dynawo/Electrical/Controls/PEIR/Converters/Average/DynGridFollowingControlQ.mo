within Dynawo.Electrical.Controls.PEIR.Converters.Average;

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

model DynGridFollowingControlQ "Grid-following converter control: PLL, P/Q outer loop with current limitation, inner current loop and dq/RI transformation"

  // PLL parameters
  parameter Types.PerUnit KiPLL "PLL integral gain in pu/(pu.s)";
  parameter Types.PerUnit KpPLL "PLL proportional gain in pu/pu (frequency pu per voltage pu)";
  parameter Types.AngularVelocityPu OmegaMaxPu "Upper frequency limit in pu (base omegaNom)";
  parameter Types.AngularVelocityPu OmegaMinPu "Lower frequency limit in pu (base omegaNom)";

  // Outer loop parameters
  parameter Types.PerUnit DidMax "Maximum rate of change of idConvRefPu in pu/s (base UNom, SNom)";
  parameter Types.PerUnit DidMin "Minimum rate of change of idConvRefPu in pu/s (base UNom, SNom)";
  parameter Types.PerUnit IqBoostMaxPu "Maximum reactive current boost in pu (base UNom, SNom)";
  parameter Types.PerUnit IqBoostMinPu "Minimum reactive current boost in pu (base UNom, SNom)";
  parameter Types.CurrentModulePu IMaxPu "Maximum converter current magnitude in pu (base UNom, SNom)";
  parameter Types.PerUnit KidOuter "Active power PI integral gain in pu/(pu.s) (current base UNom, SNom / power base SNom)";
  parameter Types.PerUnit KpdOuter "Active power PI proportional gain in pu/pu (current base UNom, SNom / power base SNom)";
  parameter Types.PerUnit KiqOuter "Reactive power PI integral gain in pu/(pu.s) (current base UNom, SNom / power base SNom)";
  parameter Types.PerUnit KpqOuter "Reactive power PI proportional gain in pu/pu (current base UNom, SNom / power base SNom)";
  parameter Types.PerUnit Kqv "Reactive current boost gain in pu/pu, 0 to disable";
  parameter Boolean PQFlag "Current priority: true = P priority, false = Q priority";
  parameter Boolean PControlFlag "true: direct control idConvRefPu = PRefFiltPu/ULVPu | false: PI regulator (default)";
  parameter Boolean QControlFlag "true: direct control iqConvRefPu = QRefFiltPu/ULVPu | false: PI regulator (default)";
  parameter Types.VoltageModulePu UBoostHighPu "High voltage threshold for reactive current boost in pu (base UNom)";
  parameter Types.VoltageModulePu UBoostLowPu "Low voltage threshold for reactive current boost in pu (base UNom)";
  parameter Types.Time tBoost "Time constant of the first-order filter on the reactive current boost in s, 0 to disable";
  parameter Types.Time tPlant "Time constant of the plant-to-outer-loop delay in s";
  parameter Types.Time tSid "Sample time of the idConvRefPu ramp limiter in s";

  // Current loop parameters
  parameter Types.PerUnit Kfd "Feedforward gain on the d-axis";
  parameter Types.PerUnit Kfq "Feedforward gain on the q-axis";
  parameter Types.PerUnit Kic "Integral gain of the current loop";
  parameter Types.PerUnit Kpc "Proportional gain of the current loop";
  parameter Types.PerUnit LgPu "Inductance used for dq decoupling in the current loop (filter + LV transformer) in pu (base UNom, SNom)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {40, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {18, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {60, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-8, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = Omega0Pu) "Reference frequency of the system in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-190, 108}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {72, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PLVFilteredPu(start = PInj0Pu) "Filtered active power measured at LV bus in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-190, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-84, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PInj0Pu) "Active power reference at LV bus in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QLVFilteredPu(start = QInj0Pu) "Filtered reactive power measured at LV bus in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-48, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QInj0Pu) "Reactive power reference at LV bus in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-190, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput udLVPu(start = UdLV0Pu) "d-axis voltage at LV bus in the PLL frame in pu (base UNom), current loop feedforward" annotation(
    Placement(transformation(origin = {-20, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {46, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uqLVPu(start = UqLV0Pu) "q-axis voltage at LV bus in the PLL frame in pu (base UNom), current loop feedforward" annotation(
    Placement(transformation(origin = {0, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {72, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "q-axis filter voltage in the PLL frame in pu (base UNom), PLL error signal" annotation(
    Placement(transformation(origin = {-190, 92}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput ULVPu(start = ULV0Pu) "Voltage magnitude at LV bus in pu (base UNom)" annotation(
    Placement(transformation(origin = {-190, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}})));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput omegaPLLPu(start = Omega0Pu) "Estimated grid frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {190, 108}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput thetaPLL(start = Theta0) "PLL angle relative to the network RI frame in rad" annotation(
    Placement(transformation(origin = {190, 92}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput uiConvRefPu(start = uConvRef0Pu.im) "Imaginary-axis converter voltage reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {190, 8}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput urConvRefPu(start = uConvRef0Pu.re) "Real-axis converter voltage reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {190, 32}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Electrical.Controls.PEIR.BaseControls.CurrentLoops.DynCurrentLoop currentLoop(Kfd = Kfd, Kfq = Kfq, Kpc = Kpc, Kic = Kic, LFilterPu = LgPu, UdFilter0Pu = UdLV0Pu, UqFilter0Pu = UqLV0Pu, IdConv0Pu = IdConv0Pu, IqConv0Pu = IqConv0Pu, UdConv0Pu = UdConv0Pu, UqConv0Pu = UqConv0Pu, IdConvRef0Pu = IdRef0Pu, IqConvRef0Pu = IqRef0Pu, Omega0Pu = Omega0Pu) annotation(
    Placement(transformation(origin = {20, 20}, extent = {{-20, -20}, {20, 20}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.OuterLoops.OuterLoopQControl OuterLoop_GFL(PControlFlag = PControlFlag, QControlFlag = QControlFlag, Kpd = KpdOuter, Kid = KidOuter, Kpq = KpqOuter, Kiq = KiqOuter, IMaxPu = IMaxPu, PQFlag = PQFlag, UBoostHighPu = UBoostHighPu, UBoostLowPu = UBoostLowPu, Kqv = Kqv, IqBoostMaxPu = IqBoostMaxPu, IqBoostMinPu = IqBoostMinPu, PInj0Pu = PInj0Pu, QInj0Pu = QInj0Pu, ULV0Pu = ULV0Pu, Id0Pu = IdRef0Pu, Iq0Pu = IqRef0Pu, DidMax = DidMax, DidMin = DidMin, tSid = tSid, tPlant = tPlant, tBoost = tBoost) annotation(
    Placement(transformation(origin = {-80, 20}, extent = {{-20, -20}, {20, 20}})));
  Dynawo.Electrical.Controls.PLL.PLL2 PLL(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, Theta0 = Theta0, Omega0Pu = Omega0Pu, UqFilter0Pu = UqFilter0Pu) annotation(
    Placement(transformation(origin = {-140, 100}, extent = {{-20, -20}, {20, 20}})));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformDQtoRI transformDQtoRI annotation(
    Placement(transformation(origin = {120, 20}, extent = {{-20, -20}, {20, 20}})));

  // Initial parameters
  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IdRef0Pu "Start value of d-axis reference current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqRef0Pu "Start value of q-axis reference current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.AngularVelocityPu Omega0Pu "Start value of grid frequency in pu (base omegaNom)";
  parameter Types.ActivePowerPu PInj0Pu "Start value of active power at LV bus in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QInj0Pu "Start value of reactive power at LV bus in pu (base SNom) (generator convention)";
  parameter Types.Angle Theta0 "Start value of the PLL angle relative to the network RI frame in rad";
  parameter Types.ComplexVoltagePu uConvRef0Pu "Start value of complex converter voltage reference in pu (base UNom)";
  parameter Types.PerUnit UdConv0Pu "Start value of d-axis modulation voltage in pu (base UNom)";
  parameter Types.PerUnit UqConv0Pu "Start value of q-axis modulation voltage in pu (base UNom)";
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis filter voltage in the PLL frame in pu (base UNom), 0 at lock";
  parameter Types.PerUnit UdLV0Pu "Start value of d-axis voltage at LV bus in the PLL frame in pu (base UNom)";
  parameter Types.PerUnit UqLV0Pu "Start value of q-axis voltage at LV bus in the PLL frame in pu (base UNom)";
  parameter Types.VoltageModulePu ULV0Pu "Start value of voltage magnitude at LV bus in pu (base UNom)";

equation
  connect(transformDQtoRI.ur, urConvRefPu) annotation(
    Line(points = {{142, 32}, {190, 32}}, color = {245, 121, 0}, thickness = 0.5));
  connect(transformDQtoRI.ui, uiConvRefPu) annotation(
    Line(points = {{142, 8}, {190, 8}}, color = {245, 121, 0}, thickness = 0.5));
  connect(PLL.theta, thetaPLL) annotation(
    Line(points = {{-118, 92}, {190, 92}}, color = {0, 0, 127}));
  connect(PLL.omegaPLLPu, omegaPLLPu) annotation(
    Line(points = {{-118, 108}, {190, 108}}, color = {0, 0, 127}));
  connect(omegaRefPu, PLL.omegaRefPu) annotation(
    Line(points = {{-190, 108}, {-162, 108}}, color = {0, 0, 127}));
  connect(uqFilterPu, PLL.uqFilterPu) annotation(
    Line(points = {{-190, 92}, {-162, 92}}, color = {192, 28, 40}, thickness = 0.5));
  connect(currentLoop.udConvRefPu, transformDQtoRI.ud) annotation(
    Line(points = {{42, 28}, {60, 28}, {60, 34}, {98, 34}}, color = {245, 121, 0}, thickness = 0.5));
  connect(currentLoop.uqConvRefPu, transformDQtoRI.uq) annotation(
    Line(points = {{42, 12}, {80, 12}, {80, 26}, {98, 26}}, color = {245, 121, 0}, thickness = 0.5));
  connect(currentLoop.omegaPu, PLL.omegaPLLPu) annotation(
    Line(points = {{20, 42}, {20, 108}, {-118, 108}}, color = {0, 0, 127}));
  connect(PLL.theta, transformDQtoRI.phi) annotation(
    Line(points = {{-118, 92}, {68, 92}, {68, 8}, {98, 8}}, color = {0, 0, 127}));
  connect(iqConvPu, currentLoop.iqConvPu) annotation(
    Line(points = {{60, -130}, {60, -40}, {40, -40}, {40, -2}}, color = {245, 121, 0}, thickness = 0.5));
  connect(idConvPu, currentLoop.idConvPu) annotation(
    Line(points = {{40, -130}, {40, -60}, {30, -60}, {30, -2}}, color = {245, 121, 0}, thickness = 0.5));
  connect(uqLVPu, currentLoop.uqFilterPu) annotation(
    Line(points = {{0, -130}, {0, -60}, {10, -60}, {10, -2}}, color = {85, 170, 0}, thickness = 0.5));
  connect(udLVPu, currentLoop.udFilterPu) annotation(
    Line(points = {{-20, -130}, {-20, -40}, {0, -40}, {0, -2}}, color = {85, 170, 0}, thickness = 0.5));
  connect(PLVFilteredPu, OuterLoop_GFL.PLVFilteredPu) annotation(
    Line(points = {{-190, 40}, {-120, 40}, {-120, 36}, {-102, 36}}, color = {85, 170, 0}, thickness = 0.5));
  connect(PRefPu, OuterLoop_GFL.PRefPu) annotation(
    Line(points = {{-190, 20}, {-120, 20}, {-120, 26}, {-102, 26}}, color = {85, 170, 0}, thickness = 0.5));
  connect(QRefPu, OuterLoop_GFL.QRefPu) annotation(
    Line(points = {{-190, 0}, {-120, 0}, {-120, 14}, {-102, 14}}, color = {85, 170, 0}, thickness = 0.5));
  connect(QLVFilteredPu, OuterLoop_GFL.QLVFilteredPu) annotation(
    Line(points = {{-190, -20}, {-112, -20}, {-112, 4}, {-102, 4}}, color = {85, 170, 0}, thickness = 0.5));
  connect(OuterLoop_GFL.idConvRefPu, currentLoop.idConvRefPu) annotation(
    Line(points = {{-58, 28}, {-2, 28}}, color = {245, 121, 0}, thickness = 0.5));
  connect(OuterLoop_GFL.iqConvRefPu, currentLoop.iqConvRefPu) annotation(
    Line(points = {{-58, 12}, {-2, 12}}, color = {245, 121, 0}, thickness = 0.5));
  connect(ULVPu, OuterLoop_GFL.ULVPu) annotation(
    Line(points = {{-190, 60}, {-88, 60}, {-88, 42}}, color = {85, 170, 0}, thickness = 0.5));

  annotation(
    uses(Dynawo(version = "2.0.0"), Modelica(version = "3.2.3")),
    Documentation(info = "<html><head></head><body><h4>Grid-following converter control – GFL plant</h4>

<p>Control of the grid-following converter. It turns the active and reactive power references at the LV bus into the
converter voltage reference in the network RI frame. It assembles four blocks:</p>
<ol>
  <li><code>PLL</code> (<code>PLL2</code>): estimates the angle <code>thetaPLL</code> and frequency <code>omegaPLLPu</code>
      by driving the q-axis filter voltage <code>uqFilterPu</code> to zero;</li>
  <li><code>OuterLoop_GFL</code> (<code>OuterLoopQControl</code>): P and Q control at the LV bus (PI or direct mode),
      with current limitation, P/Q priority and reactive current boost; outputs the dq current references;</li>
  <li><code>currentLoop</code> (<code>DynCurrentLoop</code>): dq current PI with decoupling terms
      <code>omegaPLLPu*LgPu</code> and voltage feedforward (<code>Kfd</code>, <code>Kfq</code>); outputs the dq converter
      voltage reference;</li>
  <li><code>transformDQtoRI</code> (<code>TransformDQtoRI</code>): rotates the dq voltage reference by <code>thetaPLL</code>
      into the network RI frame.</li>
</ol>



<h4>dq/RI transformation</h4>
<pre>  urConvRefPu = udConvRefPu*cos(thetaPLL) - uqConvRefPu*sin(thetaPLL)
  uiConvRefPu = udConvRefPu*sin(thetaPLL) + uqConvRefPu*cos(thetaPLL)
</pre>
<p>It is the inverse of the transformation used for the measurements: <code>xd = xr*cos(theta) + xi*sin(theta)</code>,
<code>xq = -xr*sin(theta) + xi*cos(theta)</code>.</p>

<h4>Modelling choices</h4>
<ul>
  <li>The PLL is synchronized on the filter capacitor voltage; the outer loop controls the powers at the LV bus.</li>
  <li>The current loop uses the LV-bus voltage as feedforward and <code>LgPu = Lf + LLV</code> as decoupling inductance:
      filter and LV transformer are seen as one inductance, and the filter capacitor is neglected in the control.</li>
</ul>

<h4>Sign conventions</h4>
<ul>
  <li>Powers and currents use the generator convention.</li>
  <li><code>idConvRefPu</code>, <code>iqConvRefPu</code> are the dq converter current references in generator convention.&nbsp;</li>
</ul>

<h4>Units and base</h4>
<ul>
  <li>Currents in pu (base UNom, SNom), powers in pu (base SNom), voltages in pu (base UNom).</li>
  <li>Frequencies in pu (base omegaNom), angles in rad.</li>
</ul>

<h4>Initialization</h4>
<p>All start values are computed by the upper-level model (<code>DynGFLPlant</code>) and passed down to the sub-models.
The PLL starts locked (<code>UqFilter0Pu = 0</code>), and the power and current errors are zero at t = 0.</p>
</body></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {6, 0}, extent = {{-90, 15}, {90, -15}}, textString = "GFL Control Q")}, coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Diagram(coordinateSystem(extent = {{-180, -120}, {180, 120}}), graphics = {Text(extent = {{-40, 60}, {-40, 60}}, textString = "text"), Text(origin = {-31, 36}, textColor = {245, 121, 0}, extent = {{-21, 2}, {21, -2}}, textString = "idConvRefPu", textStyle = {TextStyle.Bold}), Text(origin = {-31, 18}, textColor = {245, 121, 0}, extent = {{-21, 2}, {21, -2}}, textString = "iqConvRefPu", textStyle = {TextStyle.Bold})}));
end DynGridFollowingControlQ;
