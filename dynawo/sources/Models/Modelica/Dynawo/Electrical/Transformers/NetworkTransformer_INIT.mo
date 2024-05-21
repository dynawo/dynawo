within Dynawo.Electrical.Transformers;

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

model NetworkTransformer_INIT
  extends AdditionalIcons.Init;

  parameter Types.VoltageModule RatedU1 "Rated voltage at terminal 1 in kV";
  parameter Types.VoltageModule RatedU2 "Rated voltage at terminal 2 in kV";
  parameter Types.VoltageModule U1Nom "Nominal voltage at terminal 1 in kV";
  parameter Types.VoltageModule U2Nom "Nominal voltage at terminal 2 in kV";

  final parameter Types.PerUnit rTfoPu = RatedU2 / RatedU1 * U1Nom / U2Nom "Transformation ratio in pu: U2/U1 in no load conditions";

  parameter Modelica.SIunits.Resistance R "Resistance of the transformer in Ohm";
  parameter Modelica.SIunits.Reactance X "Reactance of the transformer in Ohm";
  parameter Modelica.SIunits.Conductance G "Conductance of the transformer in S";
  parameter Modelica.SIunits.Susceptance B "Susceptance of the transformer in S";

  final parameter Modelica.SIunits.ComplexImpedance Z = Complex(R, X) "Impedance of the transformer";
  final parameter Modelica.SIunits.ComplexAdmittance Y = Complex(G, B) "Admittance of the transformer";

  final parameter Types.ComplexImpedancePu ZPu = Complex(R / (U2Nom * U2Nom / SystemBase.SnRef), X / (U2Nom * U2Nom / SystemBase.SnRef)) "Impedance in pu (base U2Nom, SnRef)";
  final parameter Types.ComplexAdmittancePu YPu = Complex(G * (U2Nom * U2Nom / SystemBase.SnRef), B * (U2Nom * U2Nom / SystemBase.SnRef)) "Admittance in pu (base U2Nom, SnRef)";

  parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base UNom)";
  parameter Types.Angle U1Phase0 "Start value of voltage angle at terminal 1 in rad";

  Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base U1Nom)";
  Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in pu (base SnRef) (receptor convention)";
  flow Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base U1Nom, SnRef) (receptor convention)";

  Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 1 in pu (base U2Nom)";
  flow Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 1 in pu (base U2Nom, SnRef) (receptor convention)";

equation
  // Transformer equations
  u20Pu = rTfoPu * u10Pu + ZPu * i20Pu;
  i10Pu = rTfoPu * rTfoPu * YPu * u10Pu - rTfoPu * i20Pu;
  // Equations can also be rewritten with the following
  // i10Pu = rTfoPu * rTfoPu * ( 1 / ZPu + YPu) * u10Pu - rTfoPu * u20Pu / ZPu;
  // i20Pu = - rTfoPu * u10Pu / ZPu + u20Pu / ZPu;

  u10Pu = ComplexMath.fromPolar(U10Pu, U1Phase0);
  s10Pu = Complex(P10Pu, Q10Pu);
  s10Pu = u10Pu * ComplexMath.conj(i10Pu);

  annotation(preferredView = "text");

end NetworkTransformer_INIT;
