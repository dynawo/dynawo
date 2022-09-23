within Dynawo.Electrical.Loads;

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

model LoadAlphaBetaMotor_INIT
  extends Load_INIT;
  import Modelica;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power of a single motor in MVA";
  parameter Real ActiveMotorShare "Share of active power consumed by motors (between 0 and 1)";
  parameter Types.PerUnit RsPu "Stator resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit RrPu "Rotor resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XsPu "Stator leakage reactance in pu (base UNom, SNom)";
  parameter Types.PerUnit XrPu "Rotor leakage reactance in pu (base UNom, SNom)";
  parameter Types.PerUnit XmPu "Magnetizing reactance in pu (base UNom, SNom)";

  Types.ComplexCurrentPu is0Pu "Start value of the stator current in pu (base UNom, SNom) (receptor convention)";
  Types.ComplexCurrentPu im0Pu "Start value of the magnetising current in pu (base UNom, SNom) (receptor convention)";
  Types.ComplexCurrentPu ir0Pu "Start value of the rotor current in pu (base UNom, SNom) (receptor convention)";

  Types.PerUnit ce0Pu "Start value of the electrical torque in pu (base SNom, omegaNom)";
  Types.PerUnit cl0Pu "Start value of the load torque in pu (base SNom, omegaNom)";
  Real s0 "Start value of the slip of the motor";
  Types.AngularVelocity omegaR0Pu "Start value of the angular velocity of the motor (base omegaNom)";

  Types.ReactivePowerPu QMotor0Pu "Start value of the reactive power consumed by the motor in pu (base SnRef) (receptor convention)";

  Types.ActivePowerPu PLoad0Pu "Start value of the active power consumed by the load in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu QLoad0Pu "Start value of the reactive power consumed by the load in pu (base SnRef) (receptor convention)";
  Types.ComplexCurrentPu iLoad0Pu "Start value of the complex current consumed by the load in pu (base SnRef) (receptor convention)";

protected
  final parameter Types.ComplexImpedancePu ZsPu = Complex(RsPu,XsPu) "Stator impedance in pu (base UNom, SNom)";
  final parameter Types.ComplexImpedancePu ZrPu = Complex(RrPu,XrPu) "Rotor impedance in pu (base UNom, SNom)";
  final parameter Types.ComplexImpedancePu ZmPu = Complex(0,XmPu) "Magnetising impedance in pu (base UNom, SNom)";

equation

  // PQ load
  PLoad0Pu = (1-ActiveMotorShare) * s0Pu.re;
  Complex(PLoad0Pu,QLoad0Pu) = u0Pu*ComplexMath.conj(iLoad0Pu);

  // Asynchronous motor
  u0Pu = ZmPu*im0Pu + ZsPu*is0Pu; // Kirchhoff’s voltage law in the first loop
  is0Pu = u0Pu/(ZsPu + 1/(1/ZmPu + s0/Complex(RrPu,XrPu*s0))); // Avoid numerical issues when s = 0
  is0Pu = im0Pu + ir0Pu;

  s0 = (SystemBase.omega0Pu - omegaR0Pu)/SystemBase.omega0Pu;
  ce0Pu = RrPu*ComplexMath.'abs'(ir0Pu^2)/(SystemBase.omega0Pu*s0);
  cl0Pu = ce0Pu;

  QMotor0Pu = ComplexMath.imag(u0Pu*ComplexMath.conj(is0Pu));

  // Total load
  i0Pu = iLoad0Pu + (SNom/SystemBase.SnRef)*is0Pu;

annotation(preferredView = "text");
end LoadAlphaBetaMotor_INIT;
