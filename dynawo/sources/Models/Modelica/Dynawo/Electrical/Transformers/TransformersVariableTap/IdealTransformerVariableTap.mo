within Dynawo.Electrical.Transformers.TransformersVariableTap;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model IdealTransformerVariableTap "Ideal transformer (lossless) with a variable tap"

/* Equivalent circuit and conventions:

               I1   r   I2
    U1,P1,Q1 -->---oo---<-- U2,P2,Q2
  (terminal1)              (terminal2)
*/
  extends BaseClasses.BaseTransformerVariableTap;
  extends AdditionalIcons.Transformer;

equation
  if (running.value) then
    // Transformer equations
    terminal1.i = - rTfoPu * terminal2.i;
    rTfoPu * terminal1.V = terminal2.V;
  else
    terminal1.i = terminal2.i;
    terminal2.V = Complex(0);
  end if;

  annotation(preferredView = "text",
      Documentation(info = "<html><head></head><body><div>This model is an ideal transformer model with variable tap (that can be adjusted by an external other model such as the tap changer logic defined <a href=\"modelica://Dynawo.Electrical.Controls.Transformers.TapChanger\"> here</a>). It means that the transformer is lossless and the current and voltages on both sides are linked by the following equations:</div><div><br></div><div>rTfoPu = U2/U1 and rTfoPu = - I1/I2&nbsp;</div><div><br></div>The ideal transformer equivalent circuit is:<div><br></div><div>
<p style=\"margin: 0px;\"><br></p>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">               I1   r  I2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">    U1,P1,Q1 --&gt;---oo---&lt;-- U2,P2,Q2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">  (terminal1)              (terminal2)</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                               </span></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><!--EndFragment--></pre></div><div><br></div></body></html>"));
end IdealTransformerVariableTap;
