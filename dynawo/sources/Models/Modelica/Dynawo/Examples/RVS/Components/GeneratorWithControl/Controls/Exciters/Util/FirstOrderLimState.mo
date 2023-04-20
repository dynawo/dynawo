within Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters.Util;

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

block FirstOrderLimState "First order transfer function block (= 1 pole)"
  import Modelica;
  import Modelica.SIunits;
  import Modelica.Blocks;
  import Modelica.Blocks.Types.Init;

  parameter Real k(unit="1")=1 "Gain";
  parameter SIunits.Time T(start=1) "Time Constant";
  parameter Real yMin;
  parameter Real yMax;
  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.NoInit
    "Type of initialization (1: no init, 2: steady state, 3/4: initial output)" annotation(Evaluate=true,
      Dialog(group="Initialization"));
  parameter Real y_start=0 "Initial or guess value of output (= state)"
    annotation (Dialog(group="Initialization"));

  Blocks.Interfaces.RealInput u "Connector of Real input signal" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}})));
  Blocks.Interfaces.RealOutput y(start = y_start) "Connector of Real output signal" annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));


initial equation
  if initType == Init.SteadyState then
    der(y) = 0;
  elseif initType == Init.InitialState or initType == Init.InitialOutput then
    y = y_start;
  end if;

equation
  if y > yMax and (k*u - y)/T > 0 then
    der(y) = 0;
  elseif y < yMin and (k*u - y)/T < 0 then
    der(y) = 0;
  else
    der(y) = (k*u - y)/T;
  end if;

  annotation(preferredView = "text");
end FirstOrderLimState;
