within Dynawo.Electrical.InverterBasedGeneration.BaseClasses_INIT;

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

model IBG_INIT "Initialization model for IBGs"
  extends AdditionalIcons.Init;

  // Rating
  parameter Types.ApparentPowerModule SNom "Nominal apparent power of the injector (in MVA)";
  parameter Types.CurrentModulePu IMaxPu "Maximum current of the injector in pu (base UNom, SNom)";

  parameter Types.PerUnit P0Pu "Start value of active power at regulated bus in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit Q0Pu "Start value of reactive power at regulated bus in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at regulated bus in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage phase angle at regulated bus in rad";

  // Voltage support
  parameter Types.VoltageModulePu US1 "Lower voltage limit of deadband in pu (base UNom)";
  parameter Types.VoltageModulePu US2 "Higher voltage limit of deadband in pu (base UNom)";
  parameter Real kRCI "Slope of reactive current increase for low voltages in pu (base UNom, SNom)";
  parameter Real kRCA "Slope of reactive current decrease for high voltages in pu (base UNom, SNom)";
  parameter Real m "Current injection just outside of lower deadband in pu (base IMaxPu)";
  parameter Real n "Current injection just outside of lower deadband in pu (base IMaxPu)";

protected
  Types.ComplexPerUnit i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  Types.ComplexPerUnit s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
  Types.ComplexPerUnit u0Pu "Start value of complex voltage at terminal in pu (base UNom)";

  Types.PerUnit Id0Pu "Start value of d-axis current at injector in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit Iq0Pu "Start value of q-axis current at injector in pu (base UNom, SNom) (generator convention)";

  Types.PerUnit IqRef0Pu "Start value of the reference q-axis current at injector in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit IqSup0Pu "Start value of the reactive current support (base Unom, SNom) (generator convention)";

equation
  s0Pu = Complex(P0Pu, Q0Pu);
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  s0Pu = u0Pu * ComplexMath.conj(i0Pu);

  Id0Pu = -1 * (Modelica.Math.cos(UPhase0) * i0Pu.re + Modelica.Math.sin(UPhase0) * i0Pu.im) * SystemBase.SnRef / SNom;
  Iq0Pu = -1 * (Modelica.Math.sin(UPhase0) * i0Pu.re - Modelica.Math.cos(UPhase0) * i0Pu.im) * SystemBase.SnRef / SNom;

  if U0Pu < US1 then
    IqSup0Pu = m * IMaxPu + kRCI * (US1 - U0Pu);
  elseif U0Pu < US2 then
    IqSup0Pu = 0;
  else
    IqSup0Pu = -n * IMaxPu + kRCA * (U0Pu - US2);
  end if;

  Iq0Pu = IqRef0Pu + IqSup0Pu;

  annotation(preferredView = "text");
end IBG_INIT;
