within Dynawo.Electrical.Photovoltaics.WECC;

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

model PVVoltageSource_INIT "Initialization model for WECC PV model with a voltage source as interface with the grid"

  import Modelica;
  import Modelica.ComplexMath;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  extends AdditionalIcons.Init;

  parameter Types.ApparentPowerModule SNom =100 "Nominal apparent power in MVA";
  parameter Types.PerUnit RPu = 0 "Resistance of equivalent branch connection to the grid in p.u (base SnRef)";
  parameter Types.PerUnit XPu = 0.0000020661 "Reactance of equivalent branch connection to the grid in p.u (base SnRef)";

  parameter Types.PerUnit P0Pu = -0.7"Start value of active power at regulated bus in p.u (receptor convention) (base SnRef)";
  parameter Types.PerUnit Q0Pu = -0.2 "Start value of reactive power at regulated bus in p.u (receptor convention) (base SnRef)";
  parameter Types.PerUnit U0Pu = 1 "Start value of voltage magnitude at regulated bus in p.u.";
  parameter Types.Angle UPhase0 = 0.00000144621  "Start value of voltage phase angle at regulated bus in rad";

  parameter Types.PerUnit RSourcePu =0 "Source resistance in per unit (typically set to zero, typical: 0..0.01)";
  parameter Types.PerUnit XSourcePu =0.1 "Source reactance in per unit (typical: 0.05..0.2)";

//protected
  Types.ComplexPerUnit u0Pu   "Start value of complex voltage at terminal in p.u (base UNom)";
  Types.ComplexPerUnit s0Pu "Start value of complex apparent power at terminal in p.u (base SnRef) (receptor convention)";
  Types.ComplexPerUnit i0Pu "Start value of complex current at terminal in p.u (base UNom, SnRef) (receptor convention)";
  Types.ComplexPerUnit iInj0Pu "Start value of complex current at injector in p.u (base UNom, SNom) (generator convention)";
  Types.ComplexPerUnit uInj0Pu "Start value of complex voltage at injector in p.u (base UNom)";
  Types.ComplexPerUnit sInj0Pu "Start value of complex apparent power at injector in p.u (base SNom) (generator convention)";
  Types.PerUnit PInj0Pu "Start value of active power at injector in p.u (base SNom) (generator convention)";
  Types.PerUnit QInj0Pu "Start value of reactive power at injector in p.u (base SNom) (generator convention)";
  Types.PerUnit UInj0Pu "Start value of voltage module at injector in p.u (base UNom)";
  Types.Angle UPhaseInj0 "Start value of voltage angle at injector in p.u (base UNom)";
  Types.PerUnit PF0 "Start value of power factor";
  Types.PerUnit Id0Pu "Start value of d-axis current at injector in p.u (base UNom, SNom) (generator convention)";
  Types.PerUnit Iq0Pu "Start value of q-axis current at injector in p.u (base UNom, SNom) (generator convention)";
  Types.PerUnit Ud0Pu "Start value of d-axis voltage at injector in p.u (base UNom)";
  Types.PerUnit Uq0Pu "Start value of q-axis voltage at injector in p.u (base UNom)";

equation
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  s0Pu = Complex(P0Pu, Q0Pu);
  i0Pu = ComplexMath.conj(s0Pu / u0Pu);
  iInj0Pu = - i0Pu * SystemBase.SnRef / SNom;
  uInj0Pu = u0Pu -  Complex(RPu, XPu) * i0Pu;
  sInj0Pu = uInj0Pu * ComplexMath.conj(iInj0Pu);
  PInj0Pu = ComplexMath.real(sInj0Pu);
  QInj0Pu = ComplexMath.imag(sInj0Pu);
  UInj0Pu = ComplexMath.'abs'(uInj0Pu);
  UPhaseInj0 = ComplexMath.arg(uInj0Pu);
  PF0 = PInj0Pu / max(ComplexMath.'abs'(sInj0Pu), 0.0001);
  Id0Pu = Modelica.Math.cos(UPhaseInj0) * iInj0Pu.re + Modelica.Math.sin(UPhaseInj0) * iInj0Pu.im;
  Iq0Pu = Modelica.Math.sin(UPhaseInj0) * iInj0Pu.re - Modelica.Math.cos(UPhaseInj0) * iInj0Pu.im;

  Ud0Pu = U0Pu + Id0Pu * RSourcePu - Iq0Pu * XSourcePu;
  Uq0Pu = 0 + Iq0Pu * RSourcePu + Id0Pu * XSourcePu;

  annotation(Documentation(preferredView = "text"));

end PVVoltageSource_INIT;
