within Dynawo.Electrical.Machines.Motors;

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

model SimplifiedMotor_INIT "Initialization model for simplified induction motor"
  extends BaseClasses_INIT.BaseMotor_INIT;
  extends AdditionalIcons.Init;

  parameter Types.PerUnit RsPu "Stator resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit RrPu "Rotor resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XsPu "Stator leakage reactance in pu (base UNom, SNom)";
  parameter Types.PerUnit XrPu "Rotor leakage reactance in pu (base UNom, SNom)";
  parameter Types.PerUnit XmPu "Magnetizing reactance in pu (base UNom, SNom)";

protected
  final parameter Types.ComplexImpedancePu ZsPu = Complex(RsPu, XsPu) "Stator impedance in pu (base UNom, SNom)";
  final parameter Types.ComplexImpedancePu ZrPu = Complex(RrPu, XrPu) "Rotor impedance in pu (base UNom, SNom)";
  final parameter Types.ComplexImpedancePu ZmPu = Complex(0, XmPu) "Magnetising impedance in pu (base UNom, SNom)";

public
  Types.ComplexCurrentPu is0Pu "Start value of the stator current in pu (base SNom, UNom)";
  Types.ComplexCurrentPu im0Pu "Start value of the magnetising current in pu (base SNom, UNom)";
  Types.ComplexCurrentPu ir0Pu "Start value of the rotor current in pu (base SNom, UNom)";
  Types.PerUnit Ce0Pu "Start value of the electrical torque in pu (base SNom, omegaNom)";
  Real Slip0 "Start value of the slip of the motor";
  Types.AngularVelocityPu omegaR0Pu "Start value of the angular velocity of the motor in pu (base omegaNom)";

equation
  u0Pu = ZmPu * im0Pu + ZsPu * is0Pu;  // Kirchhoff’s voltage law in the first loop
  is0Pu = u0Pu / (ZsPu + 1 / (1 / ZmPu + Slip0 / Complex(RrPu, XrPu * Slip0)));  // Avoid numerical issues when slip = 0
  is0Pu = im0Pu + ir0Pu;
  s0Pu = u0Pu * ComplexMath.conj(is0Pu) * (SNom / SystemBase.SnRef);

  Slip0 = (SystemBase.omegaRef0Pu - omegaR0Pu) / SystemBase.omegaRef0Pu;
  Ce0Pu = RrPu * ComplexMath.'abs'(ir0Pu ^ 2) / (SystemBase.omegaRef0Pu * Slip0);

  annotation(preferredView = "text");
end SimplifiedMotor_INIT;
