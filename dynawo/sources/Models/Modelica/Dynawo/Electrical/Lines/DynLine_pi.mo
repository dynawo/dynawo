within Dynawo.Electrical.Lines;


/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model DynLine_pi "AC power line - Fully Dynamic Pi model (series R+jX, shunt G+jB split half/half on each side, both with dynamic states in the network rotating reference frame)"

/*
  Equivalent circuit and conventions:

               I1        Iseries        I2
   (terminal1) -->-------R+jX-------<-- (terminal2)
                    |                |
                  G/2+jB/2        G/2+jB/2
                    |                |
                   ---              ---

  All branches (series R+jX AND shunt G+jB) are modeled with dynamic
  state equations in the network reference frame rotating at omegaPu,
  consistently with each other. This differs from the standard
  quasi-static Pi-line model, where only the series branch is dynamic
  and the shunt branches are algebraic (i = Y*V).
*/
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffLine;
  extends AdditionalIcons.Line;

  Dynawo.Connectors.ACPower terminal1(V(re(start = u01Pu.re), im(start = u01Pu.im)), i(re(start = i01Pu.re), im(start = i01Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal2(V(re(start = u02Pu.re), im(start = u02Pu.im)), i(re(start = i02Pu.re), im(start = i02Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omegaRef0Pu);

  parameter Types.PerUnit RPu "Series resistance in pu (base SnRef)";
  parameter Types.PerUnit XPu "Series reactance in pu (base SnRef)";
  parameter Types.PerUnit GPu "Half shunt conductance in pu (base SnRef), split G/2 on each side";
  parameter Types.PerUnit BPu "Half shunt susceptance in pu (base SnRef), split B/2 on each side";

  Types.ComplexCurrentPu iSeriesPu(re(start = iSeries01Pu.re), im(start = iSeries01Pu.im)) "Complex current through the series R+jX branch, in pu (base UNom, SnRef)";

  Types.ActivePowerPu P1Pu "Active power on side 1 in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q1Pu "Reactive power on side 1 in pu (base SnRef) (receptor convention)";
  Types.ActivePowerPu P2Pu "Active power on side 2 in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q2Pu "Reactive power on side 2 in pu (base SnRef) (receptor convention)";

  parameter Types.VoltageModulePu U01Pu "Start value of voltage amplitude at terminal1/PCC in pu (base UNom)";
  parameter Types.Angle UPhase01 "Start value of voltage angle at terminal1/PCC in rad";
  parameter Types.ActivePowerPu P01Pu "Start value of active power at terminal1/PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q01Pu "Start value of reactive power at terminal1/PCC in pu (base SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu u01Pu = ComplexMath.fromPolar(U01Pu, UPhase01) "Start value of the complex voltage at terminal1/PCC in pu (base UNom)";
  final parameter Types.ComplexCurrentPu i01Pu = ComplexMath.conj(Complex(P01Pu, Q01Pu) / u01Pu) "Start value of the complex terminal current at terminal1/PCC in pu (base UNom, SnRef) (receptor convention)";

  parameter Types.VoltageModulePu U02Pu "Start value of voltage amplitude at terminal2/PCC in pu (base UNom)";
  parameter Types.Angle UPhase02 "Start value of voltage angle at terminal2/PCC in rad";
  parameter Types.ActivePowerPu P02Pu "Start value of active power at terminal2/PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q02Pu "Start value of reactive power at terminal2/PCC in pu (base SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu u02Pu = ComplexMath.fromPolar(U02Pu, UPhase02) "Start value of the complex voltage at terminal2/PCC in pu (base UNom)";
  final parameter Types.ComplexCurrentPu i02Pu = ComplexMath.conj(Complex(P02Pu, Q02Pu) / u02Pu) "Start value of the complex terminal current at terminal2/PCC in pu (base UNom, SnRef) (receptor convention)";

  // Half-shunt admittance (G/2 + jB/2), and derived start value of the series-branch current
  final parameter Types.ComplexAdmittancePu yShPu = Complex(GPu, BPu) "Half-shunt admittance in pu (base SnRef), applied at each side";
  final parameter Types.ComplexCurrentPu iShunt01Pu = yShPu * u01Pu "Start value of the shunt current at terminal1";
  final parameter Types.ComplexCurrentPu iShunt02Pu = yShPu * u02Pu "Start value of the shunt current at terminal2";
  final parameter Types.ComplexCurrentPu iSeries01Pu = i01Pu - iShunt01Pu "Start value of the series-branch current, computed from side 1";

  // Dynamic shunt currents (now states, since the shunt susceptance is a capacitor with i = C dV/dt)
  Types.ComplexCurrentPu iShunt1Pu(re(start = iShunt01Pu.re), im(start = iShunt01Pu.im)) "Complex current through the shunt branch at terminal1, in pu";
  Types.ComplexCurrentPu iShunt2Pu(re(start = iShunt02Pu.re), im(start = iShunt02Pu.im)) "Complex current through the shunt branch at terminal2, in pu";

initial equation
  terminal1.V.re = u01Pu.re;
  terminal1.V.im = u01Pu.im;
  terminal2.V.re = u02Pu.re;
  terminal2.V.im = u02Pu.im;

equation

  // ── Series branch: dynamic RL equation in the network reference frame rotating at omegaPu ──
  XPu / SystemBase.omegaNom * der(iSeriesPu.re) + RPu * iSeriesPu.re - omegaPu * XPu * iSeriesPu.im = terminal1.V.re - terminal2.V.re;
  XPu / SystemBase.omegaNom * der(iSeriesPu.im) + RPu * iSeriesPu.im + omegaPu * XPu * iSeriesPu.re = terminal1.V.im - terminal2.V.im;

  // ── Shunt branch at terminal1: dynamic GC equation in the same rotating reference frame ──
  BPu / SystemBase.omegaNom * der(terminal1.V.re) - omegaPu * BPu * terminal1.V.im + GPu * terminal1.V.re = iShunt1Pu.re;
  BPu / SystemBase.omegaNom * der(terminal1.V.im) + omegaPu * BPu * terminal1.V.re + GPu * terminal1.V.im = iShunt1Pu.im;

  // ── Shunt branch at terminal2: dynamic GC equation in the same rotating reference frame ──
  BPu / SystemBase.omegaNom * der(terminal2.V.re) - omegaPu * BPu * terminal2.V.im + GPu * terminal2.V.re = iShunt2Pu.re;
  BPu / SystemBase.omegaNom * der(terminal2.V.im) + omegaPu * BPu * terminal2.V.re + GPu * terminal2.V.im = iShunt2Pu.im;

  // ── Terminal currents = series current +/- local shunt current ────────
  terminal1.i.re = iSeriesPu.re + iShunt1Pu.re;
  terminal1.i.im = iSeriesPu.im + iShunt1Pu.im;
  terminal2.i.re = -iSeriesPu.re + iShunt2Pu.re;
  terminal2.i.im = -iSeriesPu.im + iShunt2Pu.im;

  P1Pu = ComplexMath.real(terminal1.V * ComplexMath.conj(terminal1.i));
  Q1Pu = ComplexMath.imag(terminal1.V * ComplexMath.conj(terminal1.i));
  P2Pu = ComplexMath.real(terminal2.V * ComplexMath.conj(terminal2.i));
  Q2Pu = ComplexMath.imag(terminal2.V * ComplexMath.conj(terminal2.i));

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>
The line model is a fully dynamic Pi-line model with the following equivalent circuit and conventions:<div><br></div><div>
<p style=\"margin: 0px;\"><br></p>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">               I1                  I2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">   (terminal1) --&gt;-------R+jX-------&lt;-- (terminal2)</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                    |           |</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                  G/2+jB/2   G/2+jB/2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                    |           |</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                   ---         ---</span></pre></div>
<p>Unlike the standard quasi-static Pi model, both the series branch (R+jX) AND the shunt branches (G+jB) are modeled as dynamic states in the network reference frame rotating at omegaPu, consistently with each other. The shunt susceptance B is treated as a capacitor (i = C dV/dt in stationary axes), which produces a der(V) term and an omegaPu*B cross-coupling term analogous to those already present in the series branch.</p>
<p><b>Important:</b> this formulation makes terminal1.V and terminal2.V differential states owned by this line model. This changes the DAE index structure of the node compared to the standard algebraic-shunt line: do not connect this model to a bus that already owns a dynamic state for the same voltage (e.g. another dynamic shunt or capacitor model at that node), or the system will be over-determined/singular. Use only when justified by the frequency range of interest (e.g. SSO studies where the standard quasi-static shunt approximation is not accurate enough).</p>
</body></html>"));
end DynLine_pi;
