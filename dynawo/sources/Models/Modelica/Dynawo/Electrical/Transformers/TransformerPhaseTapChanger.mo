within Dynawo.Electrical.Transformers;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

model TransformerPhaseTapChanger "Two winding transformer with a fixed ratio and variable phase"


/* Equivalent circuit and conventions:

               I1  r,theta         I2
    U1,P1,Q1 -->---oo----R+jX-------<-- U2,P2,Q2
  (terminal1)                   |      (terminal2)
                               G+jB
                                |
                               ---
*/
  extends Dynawo.AdditionalIcons.Transformer;
  extends Dynawo.Electrical.Transformers.BaseClasses.BaseTransformer;

  // phase variation discrete scale
  parameter Integer NbTap "Number of taps";
  parameter Types.Angle ThetaTfoMin "Minimum phase shift in rad";
  parameter Types.Angle ThetaTfoMax "Maximum phase shift in rad";

  // transformation ratio
  parameter Types.PerUnit RatioTfoPu "Transformation ratio in pu: U2/U1 in no load conditions";

  // transformation phase shift
  Types.Angle thetaTfo(start = ThetaTfo0) "Transformation phase shift in rad";

  // Input connector
  Dynawo.Connectors.ZPin tap(value(start = Tap0)) "Current transformer tap (between 0 and NbTap - 1)";

  // output connectors
  Dynawo.Connectors.ImPin P1Pu "Active power on side 1 in pu (base SnRef) (receptor convention)";
  Dynawo.Connectors.ImPin Q1Pu "Reactive power on side 1 in pu (base SnRef) (receptor convention)";
  Dynawo.Connectors.ImPin P2Pu "Active power on side 2 in pu (base SnRef) (receptor convention";
  Dynawo.Connectors.ImPin Q2Pu "Reactive power on side 2 in pu (base SnRef) (receptor convention)";

  // initial parameters
  parameter Integer Tap0 "Start value of transformer tap";
  redeclare parameter Types.PerUnit RatioTfo0Pu = RatioTfoPu "Start value of transformation ratio in pu: U2/U1 in no load conditions";
  redeclare parameter Types.Angle ThetaTfo0 = ThetaTfoMin + (ThetaTfoMax - ThetaTfoMin) * (Tap0 / (NbTap - 1)) "Start value of transformation phase shift in rad";

equation
  when (tap.value <> pre(tap.value)) then
    // Transformation phase shift calculation
    if (NbTap == 1) then
      thetaTfo = ThetaTfoMin;
    else
      thetaTfo = ThetaTfoMin + (ThetaTfoMax - ThetaTfoMin) * (tap.value / (NbTap - 1));
    end if;
  end when;

  rTfoPu = ComplexMath.fromPolar(RatioTfoPu, thetaTfo);

  // Variables for display or connection to another model (tap-changer for example)
  P1Pu.value = ComplexMath.real(terminal1.V * ComplexMath.conj(terminal1.i));
  Q1Pu.value = ComplexMath.imag(terminal1.V * ComplexMath.conj(terminal1.i));
  P2Pu.value = ComplexMath.real(terminal2.V * ComplexMath.conj(terminal2.i));
  Q2Pu.value = ComplexMath.imag(terminal2.V * ComplexMath.conj(terminal2.i));

  annotation(preferredView = "text",
      Documentation(info = "<html><head></head><body>The transformer has the following equivalent circuit and conventions:<div><br></div><div>
<p style=\"margin: 0px;\"><br></p>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">               I1  r,theta                I2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">    U1,P1,Q1 --&gt;---oo----R+jX-------&lt;-- U2,P2,Q2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">  (terminal1)                   |      (terminal2)</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                               G+jB</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                                |</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                               ---</span><!--EndFragment--></pre></div><div><br></div></body></html>"));
end TransformerPhaseTapChanger;
