within Dynawo.Electrical.Controls.PEIR.BaseControls.PlantController;

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

model PlantController "Simplified plant controller: U + lambda*Q control, P control with frequency droop, deadbands, no internal filters"

  // Parameters
  parameter Types.VoltageModulePu DbdPu "Voltage error deadband half-width in pu (base UNom)";
  parameter Types.AngularVelocityPu FDbd1Pu "Overfrequency deadband on (1 - omegaPLLPu) in pu (base omegaNom) (positive value)";
  parameter Types.AngularVelocityPu FDbd2Pu "Underfrequency deadband on (1 - omegaPLLPu) in pu (base omegaNom) (positive value)";
  parameter Types.AngularVelocityPu FEMaxPu "Maximum frequency droop contribution to the active power reference in pu (base SNom)";
  parameter Types.AngularVelocityPu FEMinPu "Minimum frequency droop contribution to the active power reference in pu (base SNom)";
  parameter Types.PerUnit KDroop "Frequency droop gain in pu/pu (power base SNom / frequency base omegaNom)";
  parameter Types.PerUnit LambdaPu "Reactive power droop gain of the U + lambda*Q characteristic in pu/pu (voltage base UNom / power base SNom)";
  parameter Types.PerUnit Kiq "Voltage/Q PI integral gain in pu/(pu.s) (power base SNom / voltage base UNom)";
  parameter Types.PerUnit Kpp "Active power PI proportional gain in pu/pu";
  parameter Types.PerUnit Kip "Active power PI integral gain in pu/(pu.s)";
  parameter Types.PerUnit Kpq "Voltage/Q PI proportional gain in pu/pu (power base SNom / voltage base UNom)";
  parameter Types.ActivePowerPu PMaxPu "Maximum active power reference in pu (base SNom)";
  parameter Types.ActivePowerPu PMinPu "Minimum active power reference in pu (base SNom)";
  parameter Types.ReactivePowerPu QMaxPu "Maximum reactive power reference in pu (base SNom)";
  parameter Types.ReactivePowerPu QMinPu "Minimum reactive power reference in pu (base SNom)";

  // Inputs
  Modelica.Blocks.Interfaces.RealInput omegaPLLPu(start = Omega0Pu) "Frequency measured by the PLL in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-170, -81}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -79}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput PRegFilteredPu(start = P0Pu) "Filtered active power at PCC in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-170, -100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) "Active power reference at PCC in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-170, -10}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QRegFilteredPu(start = Q0Pu) "Filtered reactive power at PCC in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-170, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {8, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput URegFilteredPu(start = U0Pu) "Filtered voltage magnitude at PCC in pu (base UNom)" annotation(
    Placement(transformation(origin = {-170, 59}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {56, -111}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage reference of the U + lambda*Q characteristic in pu (base UNom)" annotation(
    Placement(transformation(origin = {-170, 80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}})));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput PInjRefPu(start = PInj0Pu) "Active power reference at LV bus for the outer loop in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {170, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput QInjRefPu(start = QInj0Pu) "Reactive power reference at LV bus for the outer loop in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {160, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Math.Gain lambdaGain(k = LambdaPu) annotation(
    Placement(transformation(origin = {-70, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add uLambdaQ annotation(
    Placement(transformation(origin = {-30, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add voltageErr(k2 = -1) annotation(
    Placement(transformation(origin = {30, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.DeadZone voltDeadband(uMax = DbdPu, uMin = -DbdPu) annotation(
    Placement(transformation(origin = {71, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add freqErr(k1 = +1, k2 = -1) annotation(
    Placement(transformation(origin = {-131, -60}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Nonlinear.DeadZone freqDeadband(uMax = FDbd2Pu, uMin = -FDbd1Pu) annotation(
    Placement(transformation(origin = {-90, -60}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Math.Gain droopGain(k = KDroop) annotation(
    Placement(transformation(origin = {-50, -59}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter freqErrLim(uMax = FEMaxPu, uMin = FEMinPu) annotation(
    Placement(transformation(origin = {-10, -59}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add PRefEff annotation(
    Placement(transformation(origin = {30, -21}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add activePowerErr(k2 = -1) annotation(
    Placement(transformation(origin = {70, -41}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 1) annotation(
    Placement(transformation(origin = {-170, -40}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindup piQ(Ki = Kiq, Kp = Kpq, Y0 = QInj0Pu, YMax = QMaxPu, YMin = QMinPu) annotation(
    Placement(transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindup piP(Ki = Kip, Kp = Kpp, Y0 = PInj0Pu, YMax = PMaxPu, YMin = PMinPu) annotation(
    Placement(transformation(origin = {110, -41}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  parameter Types.AngularVelocityPu Omega0Pu "Start value of frequency in pu (base omegaNom)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in pu (base SNom) (generator convention)";
  parameter Types.ActivePowerPu PInj0Pu "Start value of active power at LV bus in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at PCC in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QInj0Pu "Start value of reactive power at LV bus in pu (base SNom) (generator convention)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage magnitude at PCC in pu (base UNom)";

  final parameter Types.ActivePowerPu PRef0Pu = P0Pu "Start value of active power reference at PCC in pu (base SNom) (generator convention), zero frequency error assumed at t = 0";
  final parameter Types.VoltageModulePu URef0Pu = U0Pu + LambdaPu*Q0Pu "Start value of voltage reference in pu (base UNom)";

equation
  connect(QRegFilteredPu, lambdaGain.u) annotation(
    Line(points = {{-170, 20}, {-82, 20}}, color = {0, 0, 127}));
  connect(URegFilteredPu, uLambdaQ.u1) annotation(
    Line(points = {{-170, 59}, {-60, 59}, {-60, 46}, {-42, 46}}, color = {0, 0, 127}));
  connect(lambdaGain.y, uLambdaQ.u2) annotation(
    Line(points = {{-59, 20}, {-50.5, 20}, {-50.5, 34}, {-42, 34}}, color = {0, 0, 127}));
  connect(URefPu, voltageErr.u1) annotation(
    Line(points = {{-170, 80}, {0, 80}, {0, 66}, {18, 66}}, color = {0, 0, 127}));
  connect(uLambdaQ.y, voltageErr.u2) annotation(
    Line(points = {{-19, 40}, {0, 40}, {0, 54}, {18, 54}}, color = {0, 0, 127}));
  connect(voltageErr.y, voltDeadband.u) annotation(
    Line(points = {{41, 60}, {59, 60}}, color = {0, 0, 127}));
  connect(freqErr.y, freqDeadband.u) annotation(
    Line(points = {{-119, -60}, {-103, -60}}, color = {0, 0, 127}));
  connect(PRegFilteredPu, activePowerErr.u2) annotation(
    Line(points = {{-170, -100}, {40, -100}, {40, -47}, {58, -47}}, color = {0, 0, 127}));
  connect(piP.y, PInjRefPu) annotation(
    Line(points = {{121, -41}, {141, -41}, {141, -40}, {170, -40}}, color = {0, 0, 127}));
  connect(freqErrLim.y, PRefEff.u2) annotation(
    Line(points = {{1, -59}, {8, -59}, {8, -26}, {18, -26}}, color = {0, 0, 127}));
  connect(droopGain.y, freqErrLim.u) annotation(
    Line(points = {{-39, -59}, {-22, -59}}, color = {0, 0, 127}));
  connect(freqDeadband.y, droopGain.u) annotation(
    Line(points = {{-78, -60}, {-70, -60}, {-70, -59}, {-62, -59}}, color = {0, 0, 127}));
  connect(const.y, freqErr.u1) annotation(
    Line(points = {{-159, -40}, {-146, -40}, {-146, -53}, {-144, -53}}, color = {0, 0, 127}));
  connect(omegaPLLPu, freqErr.u2) annotation(
    Line(points = {{-170, -81}, {-148, -81}, {-148, -67}, {-144, -67}}, color = {0, 0, 127}));
  connect(PRefPu, PRefEff.u1) annotation(
    Line(points = {{-170, -10}, {0, -10}, {0, -14}, {18, -14}}, color = {0, 0, 127}));
  connect(voltDeadband.y, piQ.u) annotation(
    Line(points = {{82, 60}, {98, 60}}, color = {0, 0, 127}));
  connect(activePowerErr.y, piP.u) annotation(
    Line(points = {{82, -40}, {98, -40}}, color = {0, 0, 127}));
  connect(PRefEff.y, activePowerErr.u1) annotation(
    Line(points = {{42, -20}, {48, -20}, {48, -34}, {58, -34}}, color = {0, 0, 127}));
  connect(piQ.y, QInjRefPu) annotation(
    Line(points = {{122, 60}, {160, 60}}, color = {0, 0, 127}));

  annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 40}, extent = {{-80, 20}, {80, -20}}, textString = "Plant Controller"), Text(origin = {0, 10}, extent = {{-80, 15}, {80, -15}}, textString = "u + lambda·Q"), Text(origin = {0, -15}, extent = {{-80, 15}, {80, -15}}, textString = "P + freq droop"), Text(origin = {0, -40}, extent = {{-80, 15}, {80, -15}}, textString = "deadbands")}, coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Diagram(coordinateSystem(extent = {{-160, -120}, {160, 120}})),
    Documentation(info = "<html><head></head><body><h4>Plant controller – GFL plant</h4>

<p>Simplified plant-level controller. From the filtered measurements at the PCC and the PLL frequency, it computes the
active and reactive power references at the LV bus for the converter outer loop. Signal filtering is done externally
(measurement block); this block only applies deadbands, droop and PI control with saturation.</p>

<h4>Reactive power / voltage control (U + lambda*Q)</h4>
<pre>  QInjRefPu = limit[QMinPu, QMaxPu]( (Kpq + Kiq/s) * dbd( URefPu - (URegFilteredPu + LambdaPu*QRegFilteredPu), DbdPu ) )
</pre>
<ul>
  <li>The composite signal <code>U + LambdaPu*Q</code> is compared with <code>URefPu</code>: a voltage below its reference
      increases the reactive power reference, and <code>LambdaPu</code> sets the reactive power droop.</li>
  <li>A symmetric deadband <code>[-DbdPu, DbdPu]</code> is applied on the voltage error.</li>
</ul>
<p>The PI is an anti-windup PI (<code>PIAntiWindup</code>) with output limited to <code>[QMinPu, QMaxPu]</code>.</p>
<h4>Active power control with frequency droop</h4>
<pre>  dPDroopPu = limit[FEMinPu, FEMaxPu]( KDroop * dbd(1 - omegaPLLPu, -FDbd1Pu, FDbd2Pu) )
  PInjRefPu = limit[PMinPu, PMaxPu]( (Kpp + Kip/s) * (PRefPu + dPDroopPu - PRegFilteredPu) )
</pre>
<ul>
  <li>The frequency error is computed against the nominal frequency (1 pu). An underfrequency increases the active power
      reference, an overfrequency decreases it.</li>
  <li>The deadband is asymmetric: no droop for <code>1 - FDbd2Pu &lt; omegaPLLPu &lt; 1 + FDbd1Pu</code>.</li>
  <li>The droop contribution <code>KDroop*delta_omega</code> is limited to <code>[FEMinPu, FEMaxPu]</code> (power in pu, base SNom).</li>
</ul>
<p>The PI is an anti-windup PI (<code>PIAntiWindup</code>) with output limited to <code>[PMinPu, PMaxPu]</code>.</p>
<h4>Inputs</h4>
<ul>
  <li><code>PRefPu</code>, <code>URefPu</code>: active power and voltage references at plant level;</li>
  <li><code>PRegFilteredPu</code>, <code>QRegFilteredPu</code>, <code>URegFilteredPu</code>: filtered P, Q and voltage magnitude at PCC;</li>
  <li><code>omegaPLLPu</code>: frequency measured by the PLL in pu (base omegaNom).</li>
</ul>

<h4>Outputs</h4>
<ul>
  <li><code>PInjRefPu</code>, <code>QInjRefPu</code>: active and reactive power references at the LV bus for the outer loop.</li>
</ul>

<h4>Sign conventions</h4>
<ul>
  <li>Powers use the generator convention.</li>
</ul>

<h4>Units and base</h4>
<ul>
  <li>Powers in pu (base SNom), voltages in pu (base UNom), frequencies in pu (base omegaNom).</li>
</ul>

<h4>Initialization</h4>
<ul>
  <li><code>URef0Pu = U0Pu + LambdaPu*Q0Pu</code>, so the voltage error is zero at t = 0;</li>
  <li><code>PRef0Pu = P0Pu</code>, assuming zero frequency error at t = 0 (<code>Omega0Pu = 1</code>);</li>
    <li>the PIs start at <code>PInj0Pu</code> and <code>QInj0Pu</code> (LV-bus values), set directly by their initial output <code>Y0</code>.</li>
</ul>
</body></html>"));
end PlantController;
