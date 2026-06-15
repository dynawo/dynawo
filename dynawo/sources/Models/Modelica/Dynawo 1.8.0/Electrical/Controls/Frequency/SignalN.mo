within Dynawo.Electrical.Controls.Frequency;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SignalN "Model for frequency regulation"

  input Types.Angle thetaRef(start = 0) "Voltage angle reference";
  output Types.PerUnit N "Signal to change the active power reference setpoint of the generators participating in the primary frequency regulation in pu (base SnRef)";

equation
  der(thetaRef) = 0;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>All generators of the network are connected to this model through the signal N, which is common to all the generators in the same synchronous area and that changes the active power reference of the generators to balance the generation and the consumption. Moreover, the voltage angle of a chosen bus is fixed here to balance the number of equations and the number of variables. When using this model, the frequency is not explicitly modeled.</div></body></html>"));
end SignalN;
