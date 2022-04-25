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
  import Modelica.ComplexMath;
  import Modelica.Math;
  import Dynawo.Connectors;
  import Dynawo.Types;

  extends AdditionalIcons.Init;

  //Line parameters
  parameter Types.PerUnit RPu "Line resistance in pu (base SnRef)";
  parameter Types.PerUnit XPu "Line reactance in pu (base SnRef)";

  //Machine parameters
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude of the machine in pu (base UNom)";
  parameter Types.ActivePowerPu P0Pu "Initial active power at terminal of the machine in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at terminal of the machine in pu (base SnRef) (receptor convention)";
  parameter Types.Angle UPhase0 "Initial voltage angle of the machine in rad";

  //Bus variables
  Types.VoltageModulePu UBus0Pu "Infinite bus constant voltage module in pu (base UNom)";
  Types.Angle UPhaseBus0 "Infinite bus constant voltage angle in rad";
  Types.ComplexVoltagePu uBus0Pu "Initial voltage at terminal of the bus in pu (base UNom)";

  //Machine variables
  Types.ComplexCurrentPu iMachine0Pu "Initial current at terminal of the machine in pu (base UNom, SnRef)";
  Types.ComplexApparentPowerPu SMachine0Pu "Initial apparent power at terminal of the machine in pu (base SnRef)";
  Types.ComplexVoltagePu uMachine0Pu "Initial voltage at terminal of the machine in pu (base UNom)";

  final parameter Types.ComplexImpedancePu ZPu = Complex(RPu, XPu) "Equivalent impedance between the bus and the machine";

equation
  uMachine0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  SMachine0Pu = Complex(P0Pu, Q0Pu);
  SMachine0Pu = uMachine0Pu * ComplexMath.conj(iMachine0Pu);
  uMachine0Pu - uBus0Pu = ZPu * iMachine0Pu;
  UBus0Pu = (uBus0Pu.re ^ 2 + uBus0Pu.im ^ 2) ^ 0.5;
  UPhaseBus0 = Math.atan2(uBus0Pu.im, uBus0Pu.re);

  annotation(
    preferredView = "text");
end InfiniteBusWithImpedance_INIT;
