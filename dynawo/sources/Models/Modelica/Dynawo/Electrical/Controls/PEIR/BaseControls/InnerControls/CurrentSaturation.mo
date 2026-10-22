within Dynawo.Electrical.Controls.PEIR.BaseControls.InnerControls;

model CurrentSaturation "Current Saturation bloc with saturating condition on the Module of the reference current and the current measured at the PCC"
  /*
  * Copyright (c) 2026, RTE (http://www.rte-france.com)
  * See AUTHORS.txt
  * All rights reserved.
  * This Source Code Form is subject to the terms of the Mozilla Public
  * License, v. 2.0. If a copy of the MPL was not distributed with this
  * file, you can obtain one at http://mozilla.org/MPL/2.0/.
  * SPDX-License-Identifier: MPL-2.0
  *
  * This file is part of Dynawo, a hybrid C++/Modelica open source suite
  * of simulation tools for power systems.
  */
  parameter Types.CurrentModulePu ImaxPu "Current max threshold to limit a current's module";
  parameter Types.CurrentModulePu IminPu "Current min threshold to limit a current's module";
  parameter Types.CurrentModulePu EpsUpPu "Upper half-width of the dead band around Imax/Imin, to avoid chattering at the activation threshold";
  parameter Types.CurrentModulePu EpsDownPu "Lower half-width of the dead band around Imax/Imin, to avoid chattering at the activation threshold";
  parameter Types.Time tSat "Time constant of the first-order filter on the dq reference currents (in s)";
  // Inputs
  Modelica.Blocks.Interfaces.RealInput idConvRefPu(start = IdConvRef0Pu) "d-axis reference current to be saturated (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, 36}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput idFilteredPccPu(start = IdPcc0Pu) "d-axis filtered current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-120, -42}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-34, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Modelica.Blocks.Interfaces.RealInput iqFilteredPccPu(start = IqPcc0Pu) "d-axis filtered current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-120, -76}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {70, -108}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqConvRefPu(start = IqConvRef0Pu) "q-axis reference current to be saturated (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, -2}, extent = {{-10, -10}, {10, 10}})));
  Types.PerUnit idFilteredConvRefPu (start=IdConvRef0Pu) "Value of the Current idConvRefPu after a first order filter ";
  Types.PerUnit iqFilteredConvRefPu (start=IqConvRef0Pu)"Value of the Current iqConvRefPu after a first order filter ";
  // Outputs
  Modelica.Blocks.Interfaces.BooleanOutput BlocCurrentSaturationEnable(start = false) "Boolean, true when current is being saturated" annotation(
    Placement(transformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput idConvSatRefPu(start = IdConvSatRef0Pu) "Saturated/limited d-axis current reference in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {110, 22}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput iqConvSatRefPu(start = IqConvSatRef0Pu) "Saturated/limited q-axis current reference in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {110, 46}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}})));
  Types.PerUnit IConvRefPu(start = IPcc0Pu) "Module of the current in dq representation idConvRefPu,iqConvRefPu ";
  Types.PerUnit IConvRefAnglePu(start = CurrentAngle0) "Phase Angle of the current in dq representation idConvRefPu,iqConvRefPu ";
  Types.PerUnit IPccPu(start = IPcc0Pu) "Module of the filtered current in dq representation idFilteredPccPu,iqFilteredPccPu ";
  Boolean saturating(start = IPcc0Pu > ImaxPu) "Boolean, true when current is being satured, used in computations only";
  Types.PerUnit IConvSatRefPu "Value of the module of the saturated current given as reference to the voltage control in Pu";
  // Initial parameters
  parameter Types.CurrentModulePu IdConvRef0Pu "Start value of id to be saturated";
  parameter Types.CurrentModulePu IqConvRef0Pu "Start value of iq to be saturated";
  parameter Types.CurrentModulePu IdConvSatRef0Pu "Start value of the satured-value of id";
  parameter Types.CurrentModulePu IqConvSatRef0Pu "Start value of the satured-value of iq";
  parameter Types.CurrentModulePu IPcc0Pu "Start value of the Module of the current in dq representation idConvPu,iqConvPu";
  parameter Types.CurrentModulePu CurrentAngle0 "Start value of the Phase Angle of the current in dq representation idConvPu,iqConvPu";
  parameter Types.PerUnit IdPcc0Pu "Start value of d-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqPcc0Pu "Start value of q-axis current in the grid in pu (base UNom, SNom) (generator convention)";
equation
  // Filtering reference current from the Converters
  idConvRefPu= idFilteredConvRefPu + der(idFilteredConvRefPu) * tSat;
  iqConvRefPu= iqFilteredConvRefPu + der(iqFilteredConvRefPu) * tSat;
  // Computing references for saturation
  IConvRefPu = sqrt(idFilteredConvRefPu*idFilteredConvRefPu + iqFilteredConvRefPu*iqFilteredConvRefPu);
  IConvRefAnglePu = atan2(iqFilteredConvRefPu, idFilteredConvRefPu);
  IPccPu = sqrt(idFilteredPccPu^2 + iqFilteredPccPu^2);

  when IConvRefPu > ImaxPu + EpsUpPu or IPccPu > ImaxPu + EpsUpPu then
    saturating = true;
  elsewhen IConvRefPu < ImaxPu - EpsDownPu then
    saturating = false;
  end when;
  BlocCurrentSaturationEnable = saturating;
  if saturating then
    idConvSatRefPu = ImaxPu*cos(IConvRefAnglePu);
    iqConvSatRefPu = ImaxPu*sin(IConvRefAnglePu);
  elseif IPccPu < IminPu then
    idConvSatRefPu = IminPu*cos(IConvRefAnglePu);
    iqConvSatRefPu = IminPu*sin(IConvRefAnglePu);
  else
    idConvSatRefPu = idFilteredConvRefPu;
    iqConvSatRefPu = iqFilteredConvRefPu;
  end if;
  IConvSatRefPu = sqrt(idConvSatRefPu^2 + iqConvSatRefPu^2);

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>
    <p>This block limits the module of the converter current reference (<code>idConvRefPu</code>, <code>iqConvRefPu</code>)
    sent to the current loop, while preserving its phase angle (i.e. the P/Q ratio). Saturation is triggered either by the reference itself (<code>idConvRefPu</code>,&nbsp;<code>iqConvRefPu</code>) or by the current actually measured at the PCC (<code>idPccPu</code>, <code>iqPccPu</code>).</p><ul>
    </ul>

    <h4>1. Saturation logic (with hysteresis)</h4>
    <p>The Boolean <code>saturating</code>&nbsp;is driven by events:</p>
    <ul>
    <li>it becomes <b>true</b> as soon as <b>either</b> <code>IConvRefFilterModulePu</code> <b>or</b> <code>CurrentModulePcc</code>
    exceeds <code>ImaxPu + HysteresisPu</code>;</li>
    <li>it becomes <b>false</b> only when <b>both</b> modules are below <code>ImaxPu - HysteresisPu</code>.</li>
    </ul>
    <p>The dead band of width 2·<code>HysteresisPu</code> around <code>ImaxPu</code> avoids chattering at the threshold.
    At initialisation, <code>saturating</code> starts at <code>CurrentModule0 &gt; ImaxPu</code>.</p>

    <h4>2. Output law</h4>
    <ul>
    <li><b>Saturated</b> (<code>saturating = true</code>): the reference is projected onto the circle of radius <code>ImaxPu</code>,
    keeping the angle of the filtered reference:
    <pre>  idConvSatRefPu = ImaxPu * cos(IConvRefFilterAnglePu)
  iqConvSatRefPu = ImaxPu * sin(IConvRefFilterAnglePu)</pre></li>
    <li><b>Low current</b> (not saturated and <code>CurrentModulePcc &lt; IminPu</code>): the reference is set on the circle of
    radius <code>IminPu</code> with the same filtered angle. This condition is evaluated on the PCC current only, without hysteresis.</li>
    <li><b>Normal operation</b>: the reference is passed through unchanged:
    <code>idConvSatRefPu = idConvRefPu</code>, <code>iqConvSatRefPu = iqConvRefPu</code>.</li></ul>

    <p>The <code>BlocCurrentSaturationEnable</code> output can be used by upstream blocks (voltage reference, virtual impedance,
    QSEM) to freeze their states while the current is limited, which avoids integrator wind-up.</p>
    </body></html>"),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Text(origin = {-167, 42}, extent = {{-41, 25}, {41, -25}}, textString = "idConvRefPu"), Text(origin = {-168, 2}, extent = {{-42, 16}, {42, -16}}, textString = "iqConvRefPu"), Text(origin = {174, 54}, textColor = {46, 194, 126}, extent = {{-56, 50}, {56, -50}}, textString = "idConvSatRefPu"), Text(origin = {175, -9}, textColor = {46, 194, 126}, extent = {{-55, 49}, {55, -49}}, textString = "iqConvsatRefPu"), Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {2, 2}, extent = {{-98, 84}, {98, -84}}, textString = "%name"), Text(origin = {-28, -132}, extent = {{-42, 16}, {42, -16}}, textString = "idFilteredPccPu"), Text(origin = {78, -132}, extent = {{-42, 16}, {42, -16}}, textString = "iqFilteredPccPu"), Text(origin = {53, 132}, textColor = {134, 94, 60}, extent = {{-47, 14}, {47, -14}}, textString = "CurrentSaturation Enable")}));
end CurrentSaturation;
