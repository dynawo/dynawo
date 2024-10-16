within Dynawo.Electrical.Wind.WECC;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model WT4CurrentSource_INIT "Initialization model for WECC Wind model with a current source as interface with the grid"
  extends AdditionalIcons.Init;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  // Line parameters
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in pu (base SnRef, UNom)";
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in pu (base SnRef, UNom)";

  parameter Types.PerUnit P0Pu "Start value of active power at regulated bus in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit Q0Pu "Start value of reactive power at regulated bus in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at regulated bus in pu (bae UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage phase angle at regulated bus in rad";

  Types.ComplexPerUnit i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  Types.PerUnit Id0Pu "Start value of d-axis current at injector in pu (base UNom, SNom) (generator convention)";
  Types.ComplexPerUnit iInj0Pu "Start value of complex current at injector in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit Iq0Pu "Start value of q-axis current at injector in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit PInj0Pu "Start value of active power at injector in pu (base SNom) (generator convention)";
  Types.PerUnit PF0 "Start value of power factor";
  Types.PerUnit QInj0Pu "Start value of reactive power at injector in pu (base SNom) (generator convention)";
  Types.ComplexPerUnit s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
  Types.ComplexPerUnit sInj0Pu "Start value of complex apparent power at injector in pu (base SNom) (generator convention)";
  Types.ComplexPerUnit u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  Types.PerUnit UInj0Pu "Start value of voltage module at injector in pu (base UNom)";
  Types.ComplexPerUnit uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  Types.Angle UPhaseInj0 "Start value of voltage angle at injector in rad";

equation
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  s0Pu = Complex(P0Pu, Q0Pu);
  i0Pu = ComplexMath.conj(s0Pu / u0Pu);
  iInj0Pu = - i0Pu * SystemBase.SnRef / SNom;
  uInj0Pu = u0Pu - Complex(RPu, XPu) * i0Pu;
  sInj0Pu = uInj0Pu * ComplexMath.conj(iInj0Pu);
  PInj0Pu = ComplexMath.real(sInj0Pu);
  QInj0Pu = ComplexMath.imag(sInj0Pu);
  UInj0Pu = ComplexMath.'abs'(uInj0Pu);
  UPhaseInj0 = ComplexMath.arg(uInj0Pu);
  PF0 = if (not(ComplexMath.'abs'(sInj0Pu) == 0)) then PInj0Pu / ComplexMath.'abs'(sInj0Pu) else 0;
  Id0Pu = Modelica.Math.cos(UPhaseInj0) * iInj0Pu.re + Modelica.Math.sin(UPhaseInj0) * iInj0Pu.im;
  Iq0Pu = Modelica.Math.sin(UPhaseInj0) * iInj0Pu.re - Modelica.Math.cos(UPhaseInj0) * iInj0Pu.im;

  annotation(
    preferredView = "text");
end WT4CurrentSource_INIT;
