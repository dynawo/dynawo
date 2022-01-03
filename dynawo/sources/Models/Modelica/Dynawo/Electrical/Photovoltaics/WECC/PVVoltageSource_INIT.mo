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

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in p.u (base SnRef)";
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in p.u (base SnRef)";

  parameter Types.PerUnit P0Pu "Start value of active power at regulated bus in p.u (receptor convention) (base SnRef)";
  parameter Types.PerUnit Q0Pu "Start value of reactive power at regulated bus in p.u (receptor convention) (base SnRef)";
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at regulated bus in p.u.";
  parameter Types.Angle UPhase0 "Start value of voltage phase angle at regulated bus in rad";

  parameter Types.PerUnit RSourcePu "Source resistance in per unit (typically set to zero, typical: 0..0.01)";
  parameter Types.PerUnit XSourcePu "Source reactance in per unit (typical: 0.05..0.2)";

//protected
  Types.ComplexPerUnit u0Pu "Start value of complex voltage at terminal in p.u (base UNom)";
  Types.ComplexPerUnit s0Pu "Start value of complex apparent power at terminal in p.u (base SnRef) (receptor convention)";
  Types.ComplexPerUnit i0Pu "Start value of complex current at terminal in p.u (base UNom, SnRef) (receptor convention)";
  Types.ComplexPerUnit iSource0Pu "Start value of complex current at injector in p.u (base UNom, SNom) (generator convention)";
  Types.ComplexPerUnit uSource0Pu "Start value of complex voltage at injector in p.u (base UNom)";
  Types.ComplexPerUnit sSource0Pu "Start value of complex apparent power at injector in p.u (base SNom) (generator convention)";
  Types.PerUnit PSource0Pu "Start value of active power at injector in p.u (base SNom) (generator convention)";
  Types.PerUnit QSource0Pu "Start value of reactive power at injector in p.u (base SNom) (generator convention)";
  Types.PerUnit USource0Pu "Start value of voltage module at injector in p.u (base UNom)";
  Types.Angle UPhaseSource0 "Start value of voltage angle at injector in p.u (base UNom)";

  Types.PerUnit PF0 "Start value of power factor";
  Types.ComplexPerUnit iLine0Pu "Start value of complex current at voltage source connected bus before equivalent branch connection to the grid in p.u (base UNom, SNom) (generator convention)";
  Types.ComplexPerUnit uLine0Pu "Start value of complex voltage at voltage source connected bus before equivalent branch connection to the grid in p.u (base UNom)";
  Types.ComplexPerUnit sLine0Pu "Start value of complex apparent power at injector in p.u (base SNom) (generator convention)";
  Types.PerUnit PLine0Pu "Start value of active power at voltage source connected bus before equivalent branch connection to the grid in p.u (base SNom) (generator convention)";
  Types.PerUnit QLine0Pu "Start value of reactive power at voltage source connected bus before equivalent branch connection to the grid in p.u (base SNom) (generator convention)";
  Types.PerUnit ULine0Pu "Start value of voltage module at voltage source connected bus before equivalent branch connection to the grid in p.u (base UNom)";

  Types.PerUnit Id0Pu "Start value of d-axis current at injector in p.u (base UNom, SNom) (generator convention)";
  Types.PerUnit Iq0Pu "Start value of q-axis current at injector in p.u (base UNom, SNom) (generator convention)";
  Types.PerUnit USourced0Pu "Start value of d-axis voltage at injector in p.u (base UNom)";
  Types.PerUnit USourceq0Pu "Start value of q-axis voltage at injector in p.u (base UNom)";

equation
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  s0Pu = Complex(P0Pu, Q0Pu);
  i0Pu = ComplexMath.conj(s0Pu / u0Pu);
  iSource0Pu = - i0Pu * SystemBase.SnRef / SNom;
  uSource0Pu = u0Pu -  Complex(RPu + RSourcePu, XPu + XSourcePu) * i0Pu;
  sSource0Pu = uSource0Pu * ComplexMath.conj(iSource0Pu);
  PSource0Pu = ComplexMath.real(sSource0Pu);
  QSource0Pu = ComplexMath.imag(sSource0Pu);
  USource0Pu = ComplexMath.'abs'(uSource0Pu);
  UPhaseSource0 = ComplexMath.arg(uSource0Pu);

  iLine0Pu = iSource0Pu;
  uLine0Pu = u0Pu -  Complex(RPu, XPu) * i0Pu;
  sLine0Pu = uLine0Pu * ComplexMath.conj(iLine0Pu);
  PLine0Pu = ComplexMath.real(sLine0Pu);
  QLine0Pu = ComplexMath.imag(sLine0Pu);
  ULine0Pu = ComplexMath.'abs'(uLine0Pu);
  PF0 = PLine0Pu / max(ComplexMath.'abs'(sLine0Pu), 0.0001);

  Id0Pu = Modelica.Math.cos(UPhaseSource0) * iSource0Pu.re + Modelica.Math.sin(UPhaseSource0) * iSource0Pu.im;
  Iq0Pu = Modelica.Math.sin(UPhaseSource0) * iSource0Pu.re - Modelica.Math.cos(UPhaseSource0) * iSource0Pu.im;
  USourced0Pu = U0Pu + Id0Pu * RSourcePu - Iq0Pu * XSourcePu;
  USourceq0Pu = 0 + Iq0Pu * RSourcePu + Id0Pu * XSourcePu;

  annotation(Documentation(preferredView = "text"));

end PVVoltageSource_INIT;
