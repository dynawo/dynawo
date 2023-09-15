within Dynawo.Electrical.Lines;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model Line "AC power line - PI model"

/*
  Equivalent circuit and conventions:

               I1                  I2
   (terminal1) -->-------R+jX-------<-- (terminal2)
                    |           |
                  G+jB         G+jB
                    |           |
                   ---         ---
*/

  Dynawo.Connectors.ACPower terminal1;
  Dynawo.Connectors.ACPower terminal2;

  parameter SIunits.Resistance RPu "Resistance in pu (base SnRef)";
  parameter SIunits.Reactance XPu "Reactance in pu (base SnRef)";
  parameter SIunits.Conductance GPu "Half-conductance in pu (base SnRef)";
  parameter SIunits.Susceptance BPu "Half-susceptance in pu (base SnRef)";

protected
  parameter Types.AC.Impedance ZPu (re = RPu, im = XPu) "Line impedance";
  parameter Types.AC.Admittance YPu (re = GPu, im = BPu) "Line half-admittance";

equation

  ZPu * (terminal2.i - YPu * terminal2.V) = terminal2.V - terminal1.V;
  ZPu * (terminal1.i - YPu * terminal1.V) = terminal1.V - terminal2.V;

end Line;
