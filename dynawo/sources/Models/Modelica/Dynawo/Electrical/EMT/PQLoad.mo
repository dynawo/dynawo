within Dynawo.Electrical.EMT;

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
*
* Three-phase constant-PQ load, ported from the EMTSim "PQLoad" component
* recovered by decomposing the GFf_Load_InfBus flat model
* (documentation/SinusoidalPredictorMethod/recovered_cases/decomposition.md).
* It is a parallel R // L (or R // C) shunt to ground sized from the rated
* operating point (P, Q at rated RMS line-to-line voltage V).
*/

model PQLoad "Three-phase constant-PQ load (parallel R, L, C) in EMT, receptor convention"
  Dynawo.Electrical.EMT.PwPin p "Load terminal pin";

  parameter Modelica.SIunits.ActivePower P "Active power absorbed at rated voltage";
  parameter Modelica.SIunits.ReactivePower Q "Reactive power absorbed at rated voltage (Q > 0 inductive, Q < 0 capacitive)";
  parameter Modelica.SIunits.Voltage V "Rated RMS line-to-line voltage";

protected
  final parameter Real omegaNom = 2 * Modelica.Constants.pi * Dynawo.Electrical.SystemBase.fNom "Nominal angular frequency";
  final parameter Modelica.SIunits.Resistance R_PQLoad = if P > 0 then V * V / P else 1e60 "Equivalent shunt resistance (open if P = 0)";
  final parameter Modelica.SIunits.Inductance L_PQLoad = if Q > 0 then V * V / (omegaNom * Q) else 1e60 "Equivalent shunt inductance (open if Q <= 0)";
  final parameter Modelica.SIunits.Capacitance C_PQLoad = if Q < 0 then -Q / (omegaNom * V * V) else 0 "Equivalent shunt capacitance (absent if Q >= 0)";
  Modelica.SIunits.Current i_R[3] "Resistor branch current";
  Modelica.SIunits.Current i_LC[3] "Inductor branch current";

equation
  i_R = p.v / R_PQLoad;
  p.v = L_PQLoad * der(i_LC);
  // receptor convention: current entering the device splits over the R, L and C branches
  p.i = i_R + i_LC + C_PQLoad * der(p.v);

  annotation(preferredView = "text");
end PQLoad;
