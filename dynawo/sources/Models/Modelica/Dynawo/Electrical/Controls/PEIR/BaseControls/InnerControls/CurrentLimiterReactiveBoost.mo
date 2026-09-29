within Dynawo.Electrical.Controls.PEIR.BaseControls.InnerControls;

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

model CurrentLimiterReactiveBoost "Limit sqrt(id^2 + iq^2) to IMaxPu with P/Q priority and bidirectional Iq boost (undervoltage + overvoltage)"

  // Parameters
  parameter Types.CurrentModulePu IMaxPu "Maximum current magnitude in pu (base UNom, SNom)";
  parameter Types.PerUnit IqBoostMaxPu = IMaxPu "Maximum additional reactive current boost in pu (base SNom, UNom)";
  parameter Types.PerUnit IqBoostMinPu = -IMaxPu "Minimum additional reactive current boost in pu (base SNom, UNom)";
  parameter Types.PerUnit Kqv "Reactive current boost gain in pu/pu (current base UNom, SNom / voltage base UNom), 0 to disable";
  parameter Boolean PQFlag "Current priority: true = P priority, false = Q priority (as in WECC)";
  parameter Types.Time tBoost "Time constant of first-order filter on reactive current boost in s. Set 0 to disable";
  parameter Types.VoltageModulePu UBoostLowPu "Undervoltage threshold: below it, reactive current is injected, in pu (base UNom)";
  parameter Types.VoltageModulePu UBoostHighPu "Overvoltage threshold: above it, reactive current is absorbed, in pu (base UNom)";

  // Inputs
  Modelica.Blocks.Interfaces.RealInput idRawPu "d-axis current reference before limitation in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(
      transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput iqRawPu "q-axis current reference before limitation in pu (base UNom, SNom), positive = reactive power injection" annotation(
    Placement(
      transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput ULVPu "Voltage magnitude at LV bus in pu (base UNom)" annotation(
    Placement(
      transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput idLimPu "d-axis current reference after limitation in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(
      transformation(origin = {120, 40}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput iqLimPu "q-axis current reference after limitation in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(
      transformation(origin = {120, -40}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}})));

  // Internal variables
  Types.PerUnit iqBoostPu(start = IqBoost0Pu) "Reactive current boost after limitation and filter in pu (base UNom, SNom), positive = injection";
  Types.PerUnit iqBoostRawPu(start = IqBoostRaw0Pu) "Reactive current boost before limitation in pu (base UNom, SNom), positive = injection";
  Types.PerUnit iqBoostUnfilteredPu(start = IqBoost0Pu) "Reactive current boost after limitation, before filter in pu (base UNom, SNom), positive = injection";
  Types.PerUnit iqEffPu "Reactive current reference including boost in pu (base UNom, SNom), positive = injection";

  // Initial parameter
  parameter Types.VoltageModulePu U0Pu "Start value of voltage magnitude at LV bus in pu (base UNom), used to initialize iqBoostPu";
  final parameter Types.PerUnit IqBoostRaw0Pu = if U0Pu < UBoostLowPu then Kqv*(UBoostLowPu - U0Pu)
                                               elseif U0Pu > UBoostHighPu then Kqv*(UBoostHighPu - U0Pu)
                                               else 0 "Start value of reactive current boost before limitation in pu (base UNom, SNom), positive = injection";
  final parameter Types.PerUnit IqBoost0Pu = max(min(IqBoostRaw0Pu, IqBoostMaxPu), IqBoostMinPu) "Start value of reactive current boost in pu (base UNom, SNom), positive = injection";

equation
  // Step 1: compute raw boost (undervoltage + overvoltage)
  if noEvent(ULVPu < UBoostLowPu) then
    iqBoostRawPu = Kqv * (UBoostLowPu- ULVPu);
  elseif noEvent(ULVPu > UBoostHighPu) then
    iqBoostRawPu = Kqv * (UBoostHighPu - ULVPu);
  else
    iqBoostRawPu = 0;
  end if;

  // Step 2a: limit the boost
  iqBoostUnfilteredPu = max(min(iqBoostRawPu, IqBoostMaxPu), IqBoostMinPu);

  // Step 2b: first-order filter on boost
  if noEvent(tBoost > 0) then
    tBoost * der(iqBoostPu) = iqBoostUnfilteredPu - iqBoostPu;
  else
    iqBoostPu = iqBoostUnfilteredPu;
  end if;

  // Step 3: effective iq reference
  iqEffPu = iqRawPu + iqBoostPu;

  // Step 4: current limiting with P/Q priority
  if PQFlag then
    // P priority (d-axis)
    if noEvent(abs(idRawPu) >= IMaxPu) then
      idLimPu = if (idRawPu)>0 then  IMaxPu else -  IMaxPu;
      iqLimPu = 0;
    else
      idLimPu = idRawPu;
      iqLimPu = -max(
                 min(iqEffPu,  sqrt(max(IMaxPu^2 - idRawPu^2, 0))),
                -sqrt(max(IMaxPu^2 - idRawPu^2, 0)));
    end if;
  else
    // Q priority (q-axis including boost)
    if noEvent(abs(iqEffPu) >= IMaxPu) then
      iqLimPu =  if iqEffPu>0 then  -IMaxPu else IMaxPu;
      idLimPu = 0;
    else
      iqLimPu = -iqEffPu;
      idLimPu = max(
                 min(idRawPu,  sqrt(max(IMaxPu^2 - iqEffPu^2, 0))),
                -sqrt(max(IMaxPu^2 - iqEffPu^2, 0)));
    end if;
  end if;

  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(
      coordinateSystem(extent = {{-100, -100}, {100, 100}}),
      graphics = {
        Rectangle(extent = {{-100, 100}, {100, -100}}),
        Text(origin = {0, 60}, extent = {{-80, 20}, {80, -20}},
             textString = "Current"),
        Text(origin = {0, 20}, extent = {{-80, 20}, {80, -20}},
             textString = "Limiter"),
        Text(origin = {0, -20}, extent = {{-80, 20}, {80, -20}},
             textString = "IqBoost ±"),
        Text(origin = {0, -60}, extent = {{-80, 20}, {80, -20}},
             textString = "tBoost filter")}),
    Diagram,
  Documentation(info = "<html>
<h4>Current limiter with reactive current boost &ndash; GFL outer loop</h4>

<p>This block enforces the current magnitude constraint <code>sqrt(id^2 + iq^2) &lt;= IMaxPu</code> and applies a
voltage-dependent reactive current boost to support the grid voltage during under- and overvoltage events.</p>

<h4>Reactive boost logic</h4>
<ul>
  <li><code>ULVPu &lt; UBoostLowPu</code>: undervoltage, reactive current is injected (<code>iqBoostPu &gt; 0</code>);</li>
  <li><code>ULVPu &gt; UBoostHighPu</code>: overvoltage, reactive current is absorbed (<code>iqBoostPu &lt; 0</code>);</li>
  <li><code>UBoostLowPu &lt;= ULVPu &lt;= UBoostHighPu</code>: deadband, no boost.</li>
</ul>
<pre>
  iqBoostRawPu = Kqv*(UBoostLowPu  - ULVPu)   if ULVPu &lt; UBoostLowPu
               = Kqv*(UBoostHighPu - ULVPu)   if ULVPu &gt; UBoostHighPu
               = 0                            otherwise
  iqBoostUnfilteredPu = limit(iqBoostRawPu, IqBoostMinPu, IqBoostMaxPu)
  tBoost*der(iqBoostPu) = iqBoostUnfilteredPu - iqBoostPu
  iqEffPu = iqRawPu + iqBoostPu
</pre>
<p>The boost is proportional to the voltage deviation from the threshold (gain <code>Kqv</code>), limited between
<code>IqBoostMinPu</code> and <code>IqBoostMaxPu</code>, and filtered by a first-order low-pass with time constant
<code>tBoost</code> to avoid jumps in the current reference. With <code>tBoost = 0</code> the filter is bypassed.</p>

<h4>Current limiting</h4>
<p>The priority is selected with <code>PQFlag</code> (as in WECC):</p>
<ul>
  <li><code>PQFlag = true</code>, P priority: <code>idRawPu</code> is kept first (limited to <code>IMaxPu</code>),
      and the reactive current is limited to <code>sqrt(IMaxPu^2 - idRawPu^2)</code>;</li>
  <li><code>PQFlag = false</code>, Q priority: <code>iqEffPu</code> (boost included) is kept first (limited to <code>IMaxPu</code>),
      and the d-axis current is limited to <code>sqrt(IMaxPu^2 - iqEffPu^2)</code>.</li>
</ul>
<p>In both cases the total current never exceeds <code>IMaxPu</code>, and the outputs are continuous at the limits.</p>

<h4>Sign convention</h4>
<ul>
  <li><code>idRawPu</code>, <code>idLimPu</code>: d-axis current, generator convention (injection positive).</li>
  <li><code>iqRawPu</code>, <code>iqEffPu</code> and the boost: the q-axis current, positive = reactive power injection
      (with the PLL aligned on the voltage, <code>Q = -ud*iq</code>).</li>
  <li><code>iqLimPu</code> is output with a sign flip (<code>-iqEffPu</code>, limited), so that it is the q-axis current in
      generator convention, as used by the inner current loop.</li>
</ul>

<h4>Units and base</h4>
<ul>
  <li>Currents in pu (base UNom, SNom); voltages in pu (base UNom).</li>
</ul>

</html>"));
end CurrentLimiterReactiveBoost;
