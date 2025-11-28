within Dynawo.Electrical.Loads;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

model LoadAlphaBetaRestorativeNetwork "Generic model of a restorative Alpha-Beta load, same model as in the Network."
  extends BaseClasses.BaseLoad;
  extends AdditionalIcons.Load;

  parameter Types.Time Tp "Time constant for integration of active power setpoint change, in s";
  parameter Types.Time Tq "Time constant for integration of reactive power setpoint change, in s";
  parameter Types.ActivePowerPu zPMax "Max speed of active power variation in pu/s (base SnRef)";
  parameter Types.ReactivePowerPu zQMax "Max speed of reactive power variation in pu/s (base SnRef)";
  parameter Real alpha "Active load sensitivity to voltage";
  parameter Real beta "Reactive load sensitivity to voltage";
  parameter Real alphaLong "Active load exponential sensitivity to voltage (long term behaviour)";
  parameter Real betaLong "Reactive load exponential sensitivity to voltage (long term behaviour)";

protected
  Types.ActivePower zPRaw(start = 1.0) "Dimensionless coefficient to have a first order restorative active power";
  Types.ReactivePower zQRaw(start = 1.0) "Dimensionless coefficient to have a first order restorative reactive power";
  Types.ActivePower zP(start = 1.0) "Bounded zPRaw";
  Types.ReactivePower zQ(start = 1.0) "Bounded zQRaw";

equation
  if (running.value) then
    if ((terminal.V.re == 0) and (terminal.V.im == 0)) then
      Tp * der(zPRaw) = 0.;
      Tq * der(zQRaw) = 0.;
      PPu = 0.;
      QPu = 0.;
    else
      Tp * der(zPRaw) = (ComplexMath.'abs'(terminal.V) / ComplexMath.'abs'(u0Pu)) ^ alphaLong - zPRaw * (ComplexMath.'abs'(terminal.V) / ComplexMath.'abs'(u0Pu)) ^ alpha;
      Tq * der(zQRaw) = (ComplexMath.'abs'(terminal.V) / ComplexMath.'abs'(u0Pu)) ^ betaLong - zQRaw * (ComplexMath.'abs'(terminal.V) / ComplexMath.'abs'(u0Pu)) ^ beta;
      PPu = zP * PRefPu * (1. + deltaP) * ((ComplexMath.'abs'(terminal.V) / ComplexMath.'abs'(u0Pu)) ^ alpha);
      QPu = zQ * QRefPu * (1. + deltaQ) * ((ComplexMath.'abs'(terminal.V) / ComplexMath.'abs'(u0Pu)) ^ beta);
    end if;
    zP = if zPRaw >= zPMax then zPMax elseif zPRaw <= 0. then 0. else zPRaw;
    zQ = if zQRaw >= zQMax then zQMax elseif zQRaw <= 0. then 0. else zQRaw;
  else
    Tp * der(zPRaw) = 0.;
    Tq * der(zQRaw) = 0.;
    zP = 0.;
    zQ = 0.;
    terminal.i = Complex(0);
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>  After an event, the load goes back to its initial PPu/QPu unless the voltage at its terminal is lower than UMinPu or higher than UMaxPu. In this case, the load behaves as a classical Alpha-Beta load.<div>This load restoration emulates the behaviour of a tap changer transformer that connects the load to the system and regulates the voltage at its terminal.</div></body></html>"));
end LoadAlphaBetaRestorativeNetwork;
