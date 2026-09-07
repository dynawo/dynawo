within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

record ParamsDcLine "Parameters of DC line"
  parameter Types.PerUnit CDcPu "DC line capacitance in pu (base UDcNom, SnRef)";
  parameter Types.PerUnit RDcPu "Resistance of one cable of DC line in pu (base UDcNom, SnRef)";

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>
<pre><span>Equivalent circuit and conventions:</span></pre>
<pre><br></pre>
<pre><span>             IDc1Pu                   IDc2Pu</span></pre>
<pre>     UDc1Pu ----&lt;----------2*RDcPu-------&gt;----UDc2Pu</span></pre>
<pre>     P1Pu               |           |         P2Pu</span></pre>
<pre>                      CDcPu       CDcPu</span></pre>
<pre>                        |           |</span></pre>
<pre><span>                       ---         ---</span></pre></body></html>"));
end ParamsDcLine;
