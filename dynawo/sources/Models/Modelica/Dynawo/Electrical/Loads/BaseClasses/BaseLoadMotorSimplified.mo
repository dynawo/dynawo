within Dynawo.Electrical.Loads.BaseClasses;

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

partial model BaseLoadMotorSimplified "Base model for loads in parallel to simplified motor model(s)"
  extends BaseLoad;

  parameter Real Alpha "Active load sensitivity to voltage";
  parameter Real Beta "Reactive load sensitivity to voltage";
  parameter Integer NbMotors "Number of motors modelled in the load";
  parameter Real ActiveMotorShare[NbMotors](each min = 0, each max = 1) "Share of active power consumed by motors (between 0 and 1)";
  parameter Types.ApparentPowerModule SNom[NbMotors] = ActiveMotorShare * s0Pu.re * SystemBase.SnRef "Nominal apparent power of a single motor in MVA";
  parameter Types.PerUnit RsPu[NbMotors] "Stator resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit RrPu[NbMotors] "Rotor resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XsPu[NbMotors] "Stator leakage reactance in pu (base UNom, SNom)";
  parameter Types.PerUnit XrPu[NbMotors] "Rotor leakage reactance in pu (base UNom, SNom)";
  parameter Types.PerUnit XmPu[NbMotors] "Magnetizing reactance in pu (base UNom, SNom)";
  parameter Real H[NbMotors] "Inertia constant in s";
  parameter Real torqueExponent[NbMotors] "Exponent of the torque speed dependency";

  Connectors.ImPin omegaRefPu(value(start = SystemBase.omegaRef0Pu)) "Network angular reference frequency in pu (base omegaNom)";

  Types.ActivePowerPu PLoadPu(start = PLoad0Pu) "Active power consumed by the load in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu QLoadPu(start = QLoad0Pu) "Reactive power consumed by the load in pu (base SnRef) (receptor convention)";

  Dynawo.Electrical.Machines.Motors.SimplifiedMotor motors[NbMotors](SNom = SNom, RsPu=RsPu, RrPu = RrPu, XsPu = XsPu, XrPu = XrPu, XmPu = XmPu, H = H, torqueExponent = torqueExponent, each NbSwitchOffSignals = 2, is0Pu = is0Pu, im0Pu = im0Pu, ir0Pu = ir0Pu, ce0Pu = ce0Pu, s0 = s0, omegaR0Pu = omegaR0Pu, i0Pu = motori0Pu, s0Pu = motors0Pu, each u0Pu = u0Pu);
  Types.ActivePowerPu PLoadCmdPu(start = PLoad0Pu) "Active power reference for the load in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu QLoadCmdPu(start = QLoad0Pu) "Reactive power reference for in pu (base SnRef) (receptor convention)";

  // Initial values
  parameter Types.ActivePowerPu PLoad0Pu "Start value of the active power consumed by the load in pu (base SnRef)";
  parameter Types.ReactivePowerPu QLoad0Pu "Start value of the reactive power consumed by the load in pu (base SnRef)";
  parameter Types.ComplexCurrentPu is0Pu[NbMotors] "Start value of the stator current in pu (base SNom, UNom)";
  parameter Types.ComplexCurrentPu im0Pu[NbMotors] "Start value of the magnetising current in pu (base SNom, UNom)";
  parameter Types.ComplexCurrentPu ir0Pu[NbMotors] "Start value of the rotor current in pu (base SNom, UNom)";
  parameter Types.PerUnit ce0Pu[NbMotors] "Start value of the electrical torque in pu (base SNom, omegaNom)";
  parameter Real s0[NbMotors] "Start value of the slip of the motor";
  parameter Types.AngularVelocityPu omegaR0Pu[NbMotors] "Start value of the angular velocity of the motor in pu (base omegaNom)";
  parameter Types.ComplexCurrentPu motori0Pu[NbMotors] "Start value of complex current at load terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexApparentPowerPu motors0Pu[NbMotors] "Start value of complex apparent power in pu (base SnRef) (receptor convention)";

equation
  for i in 1:NbMotors loop
    motors[i].V = terminal.V;
    connect(motors[i].omegaRefPu, omegaRefPu);
    switchOffSignal1.value = motors[i].switchOffSignal1.value;
    switchOffSignal2.value = motors[i].switchOffSignal2.value;
  end for;

  if running.value then
    PLoadCmdPu = (1 - sum(ActiveMotorShare)) * PRefPu * (1 + deltaP);
    QLoadCmdPu = QRefPu * (1 + deltaQ) - sum(motors.s0Pu.im) * (PRefPu / s0Pu.re) * (1 + deltaP); // s0Pu.re = PRef0Pu (if PRefPu increases but QRefPu stays constant, the reactive power consumed by the motor increases, so the reactive power of the load is reduced to keep the total constant).
    PPu = PLoadPu + sum(motors.PPu);
    QPu = QLoadPu + sum(motors.QPu);
    PLoadPu = PLoadCmdPu * ((ComplexMath.'abs' (terminal.V) / ComplexMath.'abs' (u0Pu)) ^ Alpha);
    QLoadPu = QLoadCmdPu * ((ComplexMath.'abs' (terminal.V) / ComplexMath.'abs' (u0Pu)) ^ Beta);
  else
    PLoadCmdPu = 0;
    QLoadCmdPu = 0;
    terminal.i = Complex(0);
    PLoadPu = 0;
    QLoadPu = 0;
  end if;

  annotation(preferredView = "text");
end BaseLoadMotorSimplified;

