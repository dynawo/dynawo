within Dynawo.Electrical.InverterBasedGeneration.BaseClasses.der_a;

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

model FRT "Frequency ride-through model for the der_a"
  import Modelica;
  import Modelica.Constants;
  import Dynawo.Connectors;

  parameter Types.VoltageModulePu FlPu "Frequency threshold under which all inverters are disconnected in pu (base omegaNom)";
  parameter Types.Time tfl "Time-lag for under-frequency trips in s";
  parameter Types.VoltageModulePu FhPu "Frequency threshold above which all inverters are disconnected in pu (base omegaNom)";
  parameter Types.Time tfh "Time-lag for over-frequency trips in s";

  Modelica.Blocks.Interfaces.RealInput fMonitoredPu "Monitored frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Real connectedShare(start = 1);

  Types.Time tflReached(start = Constants.inf) "Time when fMonitoredPu dropped below FlPu in s";
  Types.Time tfhReached(start = Constants.inf) "Time when fMonitoredPu rised above FhPu in s";

equation
  // Low frequency
  when fMonitoredPu <= FlPu and pre(connectedShare) > 0 then
    tflReached = time;
  elsewhen fMonitoredPu > FlPu and pre(tflReached) <> Constants.inf and pre(connectedShare) > 0 then
    tflReached = Constants.inf;
  end when;

  // High frequency
  when fMonitoredPu >= FhPu and pre(connectedShare) > 0 then
    tfhReached = time;
  elsewhen fMonitoredPu < FhPu and pre(tfhReached) <> Constants.inf and pre(connectedShare) > 0 then
    tfhReached = Constants.inf;
  end when;

  when time - tflReached >= tfl or time - tfhReached >= tfh then
    connectedShare = 0;
  end when;

  annotation(Documentation(preferredView = "text"));
end FRT;
