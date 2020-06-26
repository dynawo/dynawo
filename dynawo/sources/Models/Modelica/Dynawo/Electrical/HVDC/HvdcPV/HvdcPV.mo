within Dynawo.Electrical.HVDC.HvdcPV;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model HvdcPV "Model of PV HVDC link"
  extends AdditionalIcons.Line;

/*
  Equivalent circuit and conventions:

               I1                  I2
   (terminal1) -->-------HVDC-------<-- (terminal2)

*/

  import Modelica;
  import Dynawo.Electrical.HVDC;
  extends HVDC.BaseClasses.BaseHvdcP;

  Connectors.ZPin U1RefPu (value (start = ComplexMath.'abs'(u10Pu))) "Voltage regulation set point in p.u (base UNom) at terminal 1";
  Connectors.ZPin U2RefPu (value (start = ComplexMath.'abs'(u20Pu))) "Voltage regulation set point in p.u (base UNom) at terminal 2";

  output Types.Angle Theta1(start = UPhase10) "Angle of the voltage at terminal 1 in rad";
  output Types.Angle Theta2(start = UPhase20) "Angle of the voltage at terminal 2 in rad";

protected

  parameter Types.Angle UPhase10 "Start value of voltage angle and filtered voltage angle at terminal 1 in rad";
  parameter Types.Angle UPhase20 "Start value of voltage angle and filtered voltage angle at terminal 2 in rad";

equation

  Theta1 = Modelica.Math.atan2(terminal1.V.im,terminal1.V.re);
  Theta2 = Modelica.Math.atan2(terminal2.V.im,terminal2.V.re);

if (running.value) then

  if Q1Pu >= Q1MaxPu then
   Q1Pu = Q1MaxPu;
  elseif Q1Pu <= Q1MinPu then
   Q1Pu = Q1MinPu;
  else
   U1Pu = U1RefPu.value;
  end if;

  if Q2Pu >= Q2MaxPu then
   Q2Pu = Q2MaxPu;
  elseif Q2Pu <= Q2MinPu then
   Q2Pu = Q2MinPu;
  else
   U2Pu = U2RefPu.value;
  end if;

else

  Q1Pu = 0;
  Q2Pu = 0;

end if;

annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. It also regulates the voltage at each of its terminals. The active power setpoint is given as an input and can be modified during the simulation, as well as the voltage references.</div></body></html>"));
end HvdcPV;
