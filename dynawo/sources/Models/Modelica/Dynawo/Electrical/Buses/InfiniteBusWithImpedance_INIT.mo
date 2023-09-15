within Dynawo.Electrical.Buses;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model InfiniteBusWithImpedance_INIT "Initial model for infinite bus connected to an impedance"
  extends AdditionalIcons.Init;

  //Impedance parameters
  parameter Types.PerUnit RPu "Resistance in pu (base UNom, SnRef)";
  parameter Types.PerUnit XPu "Reactance in pu (base UNom, SnRef)";

  //Terminal initial parameters
  parameter Types.ActivePowerPu P0Pu "Initial active power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Initial voltage angle at terminal in rad";

  //Infinite bus initial values
  Types.ComplexVoltagePu uBus0Pu "Infinite bus complex voltage in pu (base UNom)";
  Types.VoltageModulePu UBus0Pu "Infinite bus constant voltage module in pu (base UNom)";
  Types.Angle UPhaseBus0 "Infinite bus constant voltage angle in rad";

  //Terminal initial values
  Types.ComplexCurrentPu iTerminal0Pu "Initial complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  Types.ComplexApparentPowerPu sTerminal0Pu "Initial complex apparent power at terminal in pu (base SnRef) (receptor convention)";
  Types.ComplexVoltagePu uTerminal0Pu "Initial complex voltage at terminal in pu (base UNom)";

  final parameter Types.ComplexImpedancePu ZPu = Complex(RPu, XPu) "Equivalent impedance between terminal and infinite bus";

equation
  uTerminal0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  sTerminal0Pu = Complex(P0Pu, Q0Pu);
  sTerminal0Pu = uTerminal0Pu * ComplexMath.conj(iTerminal0Pu);
  uTerminal0Pu - uBus0Pu = ZPu * iTerminal0Pu;
  UBus0Pu = ComplexMath.'abs'(uBus0Pu);
  UPhaseBus0 = ComplexMath.arg(uBus0Pu);

  annotation(
    preferredView = "text");
end InfiniteBusWithImpedance_INIT;
