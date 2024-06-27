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

model TransformerFixedRatioAndPhase "Two winding transformer with fixed transformation ratio and phase"


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

  // transformation ratio
  parameter Types.PerUnit RatioTfoPu "Transformation ratio in pu: U2/U1 in no load conditions";

  // transformation phase shift
  parameter Types.Angle ThetaTfo "Transformation phase shift in rad";

  // initial parameters
  redeclare parameter Types.PerUnit RatioTfo0Pu = RatioTfoPu "Start value of transformation ratio in pu: U2/U1 in no load conditions";
  redeclare parameter Types.Angle ThetaTfo0 = ThetaTfo "Start value of transformation phase shift in rad";

equation
  rTfoPu = ComplexMath.fromPolar(RatioTfoPu, ThetaTfo);

  annotation(preferredView = "text",
      Documentation(info = "<html><head></head><body>The transformer has the following equivalent circuit and conventions:<div><br></div><div>
<p style=\"margin: 0px;\"><br></p>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">               I1  r,theta                I2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">    U1,P1,Q1 --&gt;---oo----R+jX-------&lt;-- U2,P2,Q2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">  (terminal1)                   |      (terminal2)</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                               G+jB</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                                |</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                               ---</span><!--EndFragment--></pre></div><div><br></div></body></html>"));
end TransformerFixedRatioAndPhase;
