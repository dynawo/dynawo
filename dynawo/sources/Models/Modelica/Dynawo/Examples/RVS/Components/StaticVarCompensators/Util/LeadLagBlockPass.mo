within Dynawo.Examples.RVS.Components.StaticVarCompensators.Util;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

model LeadLagBlockPass "Lead-Lag block that passes input if lag time constant is 0"
  import Modelica;
  import Modelica.Blocks.Types.Init;
  import Dynawo.Types;

  extends Modelica.Blocks.Interfaces.SISO;

  parameter Types.Time Tb "Lag time constant in s";
  parameter Types.Time Tc "Lead time constant in s";

  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.NoInit
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
                                     annotation(Evaluate=true, Dialog(group=
          "Initialization"));
  parameter Real x_start=0
    "Initial or guess values of states"
    annotation (Dialog(group="Initialization"));
  parameter Real y_start=0
    "Initial value of output (derivatives of y are zero up to nx-1-th derivative)"
    annotation(Dialog(group=
          "Initialization"));
  output Real x(start=x_start)
    "State of transfer function from controller canonical form";

initial equation
  if initType == Init.SteadyState then
    der(x) = 0;
  elseif initType == Init.InitialState then
    x = x_start;
  elseif initType == Init.InitialOutput then
    y = y_start;
    der(x) = 0;
  end if;

equation
  if Tb > 0 then
    der(x) = (u - x) / Tb;
    y = x + Tc * der(x);
  else
    der(x) = 0;
    y = u;
  end if;

end LeadLagBlockPass;
