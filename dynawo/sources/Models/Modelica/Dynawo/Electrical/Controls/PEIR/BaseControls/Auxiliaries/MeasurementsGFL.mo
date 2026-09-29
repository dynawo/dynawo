within Dynawo.Electrical.Controls.PEIR.BaseControls.Auxiliaries;

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

model MeasurementsGFL "Measurement block for the GFL converter: dq transformation in the PLL frame, P, Q and voltage measurements with low-pass filters"

  // Filter parameters
  parameter Types.PerUnit KFilter "Measurement low-pass filter gain";
  parameter Types.Time tFilter "Measurement low-pass filter time constant in s";

  // Input variables
  Modelica.ComplexBlocks.Interfaces.ComplexInput iConvPu(re(start = IreConv0Pu), im(start = IimConv0Pu)) "Complex current from converter into filter in the network RI frame in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {-110, -44}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.ComplexBlocks.Interfaces.ComplexInput iPccPu(re(start = IrePcc0Pu), im(start = IimPcc0Pu)) "Complex current at PCC in the network RI frame in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-110, 36}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput thetaPLL(start = Theta0) "PLL angle relative to the network RI frame, used for the RI to dq transformation, in rad" annotation(
    Placement(transformation(origin = {-110, 52}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uFiltPu(re(start = UreFilter0Pu), im(start = UimFilter0Pu)) "Complex filter capacitor voltage in the network RI frame in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, -84}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-120, -100}, extent = {{-20, -20}, {20, 20}})));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uLVPu(re(start = UreLV0Pu), im(start = UimLV0Pu)) "Complex voltage at LV bus in the network RI frame in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, -4}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}})));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPccPu(re(start = UrePcc0Pu), im(start = UimPcc0Pu)) "Complex voltage at PCC in the network RI frame in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, 76}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}})));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput idConvPu(start = IdConv0Pu) "d-axis current in the converter in the PLL frame in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {110, -54}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput iqConvPu(start = IqConv0Pu) "q-axis current in the converter in the PLL frame in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {110, -68}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput PLVFilteredPu(start = PLV0Pu) "Filtered active power at LV bus in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {110, -34}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput PPccFilteredPu(start = PPcc0Pu) "Filtered active power at PCC in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {109, 79}, extent = {{-9, -9}, {9, 9}}), iconTransformation(origin = {-10, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput QLVFilteredPu(start = QLV0Pu) "Filtered reactive power at LV bus in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {110, -84}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput QPccFilteredPu(start = QPcc0Pu) "Filtered reactive power at PCC in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {16, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput udLVPu(start = UdLV0Pu) "d-axis voltage at LV bus in the PLL frame in pu (base UNom)" annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput uqLVPu(start = UqLV0Pu) "q-axis voltage at LV bus in the PLL frame in pu (base UNom)" annotation(
    Placement(transformation(origin = {110, -14}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput uqFilterPu(start = UqFilter0Pu) "q-axis filter voltage in the PLL frame in pu (base UNom), PLL error signal, 0 at lock" annotation(
    Placement(transformation(origin = {110, -112}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {82, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput ULVPu(start = sqrt(UreLV0Pu^2 + UimLV0Pu^2)) "Voltage magnitude at LV bus in pu (base UNom)" annotation(
    Placement(transformation(origin = {108, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput UPccFilteredPu(start = UPcc0Pu) "Filtered voltage magnitude at PCC in pu (base UNom)" annotation(
    Placement(transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {44, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  // Internal variables
  Types.ActivePowerPu PLVPu "Active power at LV bus in pu (base SNom) (generator convention)";
  Types.ReactivePowerPu QLVPu "Reactive power at LV bus in pu (base SNom) (generator convention)";
  Types.ActivePowerPu PPccPu "Active power at PCC in pu (base SNom) (generator convention)";
  Types.ReactivePowerPu QPccPu "Reactive power at PCC in pu (base SNom) (generator convention)";
  Types.VoltageModulePu UPccPu "Voltage magnitude at PCC in pu (base UNom)";

  Modelica.Blocks.Sources.RealExpression UPccPuexpr(y = UPccPu) annotation(
    Placement(transformation(origin = {30, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression PPccPuexpr(y = PPccPu) annotation(
    Placement(transformation(origin = {30, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression QPccPuexpr(y = QPccPu) annotation(
    Placement(transformation(origin = {30, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression PLVPuexpr(y = PLVPu) annotation(
    Placement(transformation(origin = {30, -34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression QLVPuexpr(y = QLVPu) annotation(
    Placement(transformation(origin = {30, -84}, extent = {{-10, -10}, {10, 10}})));

  // RI to dq transformations (PLL frame)
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQUPcc annotation(
    Placement(transformation(origin = {-30, 70}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQIPcc annotation(
    Placement(transformation(origin = {-30, 30}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQULV annotation(
    Placement(transformation(origin = {-30, -10}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQIConv annotation(
    Placement(transformation(origin = {-30, -50}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQUFilt annotation(
    Placement(transformation(origin = {-30, -90}, extent = {{-10, -10}, {10, 10}})));

  // First-order low-pass filters
  Modelica.Blocks.Continuous.FirstOrder firstOrderUPcc(k = KFilter, T = tFilter, y_start = UPcc0Pu) "Low-pass filter on the PCC voltage magnitude" annotation(
    Placement(transformation(origin = {70, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrderPPcc(k = KFilter, T = tFilter, y_start = PPcc0Pu) "Low-pass filter on the active power at PCC" annotation(
    Placement(transformation(origin = {70, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrderQPcc(k = KFilter, T = tFilter, y_start = QPcc0Pu) "Low-pass filter on the reactive power at PCC" annotation(
    Placement(transformation(origin = {70, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrderPLV(k = KFilter, T = tFilter, y_start = PLV0Pu) "Low-pass filter on the active power at LV bus" annotation(
    Placement(transformation(origin = {70, -34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrderQLV(k = KFilter, T = tFilter, y_start = QLV0Pu) "Low-pass filter on the reactive power at LV bus" annotation(
    Placement(transformation(origin = {70, -84}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IreConv0Pu "Start value of real-axis current from converter into filter in pu (base UNom, SNom)";
  parameter Types.PerUnit IimConv0Pu "Start value of imag-axis current from converter into filter in pu (base UNom, SNom)";
  parameter Types.PerUnit IrePcc0Pu "Start value of real-axis current at PCC in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IimPcc0Pu "Start value of imag-axis current at PCC in pu (base UNom, SNom) (generator convention)";
  parameter Types.ActivePowerPu PLV0Pu "Start value of active power at LV bus in pu (base SNom) (generator convention)";
  parameter Types.ActivePowerPu PPcc0Pu "Start value of active power at PCC in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QLV0Pu "Start value of reactive power at LV bus in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QPcc0Pu "Start value of reactive power at PCC in pu (base SNom) (generator convention)";
  parameter Types.Angle Theta0 "Start value of the PLL angle relative to the network RI frame in rad";
  parameter Types.PerUnit UdLV0Pu "Start value of d-axis voltage at LV bus in the PLL frame in pu (base UNom)";
  parameter Types.VoltageModulePu UPcc0Pu "Start value of voltage magnitude at PCC in pu (base UNom)";
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis filter voltage in the PLL frame in pu (base UNom), 0 at lock";
  parameter Types.PerUnit UqLV0Pu "Start value of q-axis voltage at LV bus in the PLL frame in pu (base UNom)";
  parameter Types.PerUnit UrePcc0Pu "Start value of real-axis voltage at PCC in pu (base UNom)";
  parameter Types.PerUnit UimPcc0Pu "Start value of imag-axis voltage at PCC in pu (base UNom)";
  parameter Types.PerUnit UreLV0Pu "Start value of real-axis voltage at LV bus in pu (base UNom)";
  parameter Types.PerUnit UimLV0Pu "Start value of imag-axis voltage at LV bus in pu (base UNom)";
  parameter Types.PerUnit UreFilter0Pu "Start value of real-axis filter capacitor voltage in pu (base UNom)";
  parameter Types.PerUnit UimFilter0Pu "Start value of imag-axis filter capacitor voltage in pu (base UNom)";

equation
  // Powers in the PLL frame (generator convention); the LV bus carries the PCC current
  PLVPu = transformRItoDQULV.ud*transformRItoDQIPcc.ud + transformRItoDQULV.uq*transformRItoDQIPcc.uq;
  QLVPu = transformRItoDQULV.uq*transformRItoDQIPcc.ud - transformRItoDQULV.ud*transformRItoDQIPcc.uq;
  PPccPu = transformRItoDQUPcc.ud*transformRItoDQIPcc.ud + transformRItoDQUPcc.uq*transformRItoDQIPcc.uq;
  QPccPu = transformRItoDQUPcc.uq*transformRItoDQIPcc.ud - transformRItoDQUPcc.ud*transformRItoDQIPcc.uq;
  // Voltage magnitudes
  ULVPu = Modelica.ComplexMath.'abs'(uLVPu);
  UPccPu = Modelica.ComplexMath.'abs'(uPccPu);

  connect(transformRItoDQUPcc.phi, thetaPLL) annotation(
    Line(points = {{-41, 64}, {-88.5, 64}, {-88.5, 52}, {-110, 52}}, color = {0, 0, 127}));
  connect(transformRItoDQIPcc.phi, thetaPLL) annotation(
    Line(points = {{-41, 24}, {-88, 24}, {-88, 52}, {-110, 52}}, color = {0, 0, 127}));
  connect(transformRItoDQULV.phi, thetaPLL) annotation(
    Line(points = {{-41, -16}, {-88, -16}, {-88, 52}, {-110, 52}}, color = {0, 0, 127}));
  connect(transformRItoDQIConv.phi, thetaPLL) annotation(
    Line(points = {{-41, -56}, {-88, -56}, {-88, 52}, {-110, 52}}, color = {0, 0, 127}));
  connect(UPccPuexpr.y, firstOrderUPcc.u) annotation(
    Line(points = {{41, 20}, {58, 20}}, color = {0, 0, 127}));
  connect(firstOrderUPcc.y, UPccFilteredPu) annotation(
    Line(points = {{81, 20}, {110, 20}}, color = {0, 0, 127}));
  connect(PPccPuexpr.y, firstOrderPPcc.u) annotation(
    Line(points = {{41, 80}, {58, 80}}, color = {0, 0, 127}));
  connect(PPccFilteredPu, firstOrderPPcc.y) annotation(
    Line(points = {{109, 79}, {100.5, 79}, {100.5, 80}, {81, 80}}, color = {0, 0, 127}));
  connect(firstOrderQPcc.u, QPccPuexpr.y) annotation(
    Line(points = {{58, 50}, {41, 50}}, color = {0, 0, 127}));
  connect(QPccFilteredPu, firstOrderQPcc.y) annotation(
    Line(points = {{110, 50}, {81, 50}}, color = {0, 0, 127}));
  connect(PLVPuexpr.y, firstOrderPLV.u) annotation(
    Line(points = {{41, -34}, {58, -34}}, color = {0, 0, 127}));
  connect(PLVFilteredPu, firstOrderPLV.y) annotation(
    Line(points = {{110, -34}, {81, -34}}, color = {0, 0, 127}));
  connect(QLVPuexpr.y, firstOrderQLV.u) annotation(
    Line(points = {{41, -84}, {58, -84}}, color = {0, 0, 127}));
  connect(firstOrderQLV.y, QLVFilteredPu) annotation(
    Line(points = {{81, -84}, {110, -84}}, color = {0, 0, 127}));
  connect(transformRItoDQUFilt.uq, uqFilterPu) annotation(
    Line(points = {{-19, -96}, {48.5, -96}, {48.5, -112}, {110, -112}}, color = {0, 0, 127}));
  connect(transformRItoDQIConv.uq, iqConvPu) annotation(
    Line(points = {{-19, -56}, {45.5, -56}, {45.5, -68}, {110, -68}}, color = {0, 0, 127}));
  connect(transformRItoDQIConv.ud, idConvPu) annotation(
    Line(points = {{-19, -44}, {45.5, -44}, {45.5, -54}, {110, -54}}, color = {0, 0, 127}));
  connect(transformRItoDQULV.uq, uqLVPu) annotation(
    Line(points = {{-19, -16}, {52, -16}, {52, -14}, {110, -14}}, color = {0, 0, 127}));
  connect(transformRItoDQULV.ud, udLVPu) annotation(
    Line(points = {{-19, -4}, {52, -4}, {52, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(uPccPu, transformRItoDQUPcc.u) annotation(
    Line(points = {{-110, 76}, {-41, 76}}, color = {85, 170, 255}));
  connect(iPccPu, transformRItoDQIPcc.u) annotation(
    Line(points = {{-110, 36}, {-40, 36}}, color = {85, 170, 255}));
  connect(uLVPu, transformRItoDQULV.u) annotation(
    Line(points = {{-110, -4}, {-41, -4}}, color = {85, 170, 255}));
  connect(iConvPu, transformRItoDQIConv.u) annotation(
    Line(points = {{-110, -44}, {-41, -44}}, color = {85, 170, 255}));
  connect(uFiltPu, transformRItoDQUFilt.u) annotation(
    Line(points = {{-110, -84}, {-41, -84}}, color = {85, 170, 255}));
  connect(thetaPLL, transformRItoDQUFilt.phi) annotation(
    Line(points = {{-110, 52}, {-88, 52}, {-88, -96}, {-40, -96}}, color = {0, 0, 127}));

  annotation(
    Icon(graphics = {Rectangle(origin = {0, -10}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 110}, {100, -110}}), Text(extent = {{-90, 20}, {90, -20}}, textString = "measurement filters")}, coordinateSystem(extent = {{-100, -120}, {100, 100}})),
    uses(Modelica(version = "3.2.3"), Dynawo(version = "2.0.0")),
    Diagram(coordinateSystem(extent = {{-100, -120}, {100, 100}})),
    Documentation(info = "<html><head></head><body><h4>Measurement block – GFL plant</h4>

<p>Computes the electrical measurements used by the GFL converter control and the plant controller, from the voltages and
currents at the PCC, the LV bus, the filter capacitor and the converter, given in the network RI frame.</p>

<h4>RI to dq transformation</h4>
<p>All quantities are rotated into the PLL frame with the same angle <code>thetaPLL</code> (five <code>TransformRItoDQ</code> blocks):</p>
<pre>  xd =  xr*cos(thetaPLL) + xi*sin(thetaPLL)
  xq = -xr*sin(thetaPLL) + xi*cos(thetaPLL)
</pre>

<h4>Powers and voltage magnitudes</h4>
<pre>  PPccPu = udPcc*idPcc + uqPcc*iqPcc        QPccPu = uqPcc*idPcc - udPcc*iqPcc
  PLVPu  = udLV*idPcc  + uqLV*iqPcc         QLVPu  = uqLV*idPcc  - udLV*iqPcc
  UPccPu = |uPccPu|                         ULVPu  = |uLVPu|
</pre>
<p>The LV-bus powers use the PCC current: the LV bus and the PCC are connected by the HV transformer stage only, so they
carry the same current.</p>

<h4>Filtering</h4>
<p>The following signals are filtered by a first-order low-pass <code>KFilter/(1 + s*tFilter)</code>:</p>
<ul>
  <li><code>UPccFilteredPu</code>, <code>PPccFilteredPu</code>, <code>QPccFilteredPu</code>: to the plant controller;</li>
  <li><code>PLVFilteredPu</code>, <code>QLVFilteredPu</code>: to the outer loop.</li>
</ul>
<p>The following signals are not filtered:</p>
<ul>
  <li><code>idConvPu</code>, <code>iqConvPu</code>: to the inner current loop;</li>
  <li><code>udLVPu</code>, <code>uqLVPu</code>: current loop feedforward;</li>
  <li><code>ULVPu</code>: to the outer loop (direct mode, current limiter);</li>
  <li><code>uqFilterPu</code>: PLL error signal, not filtered to keep the PLL bandwidth.</li>
</ul>

<h4>Sign conventions</h4>
<ul>
  <li>Currents and powers use the generator convention.</li>
</ul>

<h4>Units and base</h4>
<ul>
  <li>Voltages in pu (base UNom), currents in pu (base UNom, SNom), powers in pu (base SNom), angles in rad.</li>
</ul>

<h4>Initialization</h4>
<p>The filters start at the initial values <code>UPcc0Pu</code>, <code>PPcc0Pu</code>, <code>QPcc0Pu</code>,
<code>PLV0Pu</code>, <code>QLV0Pu</code>, so the outputs have no transient at t = 0 if these values are consistent with the
inputs. The unfiltered outputs follow directly from the inputs and <code>thetaPLL</code>.</p>
</body></html>"));
end MeasurementsGFL;
