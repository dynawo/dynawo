within Dynawo.Electrical.HVDC.HvdcPTanPhi;

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

model HvdcPTanPhi "Model for P/tan(Phi) HVDC link"
  import Dynawo.Electrical.HVDC;

  extends HVDC.BaseClasses.BaseHvdcP;
  extends AdditionalIcons.Hvdc;

/*
  Equivalent circuit and conventions:

               I1                  I2
   (terminal1) -->-------HVDC-------<-- (terminal2)

*/

  parameter Types.ReactivePowerPu Q1MinPu "Minimum reactive power in pu (base SnRef) at terminal 1 (receptor convention)";
  parameter Types.ReactivePowerPu Q1MaxPu "Maximum reactive power in pu (base SnRef) at terminal 1 (receptor convention)";
  parameter Types.ReactivePowerPu Q2MinPu "Minimum reactive power in pu (base SnRef) at terminal 2 (receptor convention)";
  parameter Types.ReactivePowerPu Q2MaxPu "Maximum reactive power in pu (base SnRef) at terminal 2 (receptor convention)";

  input Real tanPhi1Ref(start = TanPhi1Ref0) "tan(Phi) regulation set point at terminal 1";
  input Real tanPhi2Ref(start = TanPhi2Ref0) "tan(Phi) regulation set point at terminal 2";

  parameter Real TanPhi1Ref0 "Start value of tan(Phi) regulation set point at terminal 1";
  parameter Real TanPhi2Ref0 "Start value of tan(Phi) regulation set point at terminal 2";

protected
  Types.ReactivePowerPu Q1RawPu(start = s10Pu.im) "Raw reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q2RawPu(start = s20Pu.im) "Raw reactive power at terminal 2 in pu (base SnRef) (receptor convention)";

equation
  Q1RawPu = tanPhi1Ref * P1Pu;
  Q2RawPu = tanPhi2Ref * P2Pu;

  if running.value then
    if Q1RawPu >= Q1MaxPu then
     Q1Pu = Q1MaxPu;
    elseif Q1RawPu <= Q1MinPu then
     Q1Pu = Q1MinPu;
    else
     Q1Pu = Q1RawPu;
    end if;
    if Q2RawPu >= Q2MaxPu then
     Q2Pu = Q2MaxPu;
    elseif Q2RawPu <= Q2MinPu then
     Q2Pu = Q2MinPu;
    else
     Q2Pu = Q2RawPu;
    end if;
  else
    Q1Pu = 0;
    Q2Pu = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself and the reactive power at each of its terminal. The power factor setpoint is given as an input and can be modified during the simulation, as well as the active power setpoint.</div></body></html>"));
end HvdcPTanPhi;
