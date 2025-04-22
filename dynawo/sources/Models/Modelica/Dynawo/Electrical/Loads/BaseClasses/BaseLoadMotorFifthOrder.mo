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

partial model BaseLoadMotorFifthOrder "Base model for loads in parallel to fifth order motor model(s)"
  extends BaseLoad;

  parameter Real Alpha "Active load sensitivity to voltage";
  parameter Real Beta "Reactive load sensitivity to voltage";
  parameter Integer NbMotors "Number of motors modelled in the load";
  parameter Real ActiveMotorShare[NbMotors](each min = 0, each max = 1) "Share of active power consumed by motors (between 0 and 1)";
  parameter Types.ApparentPowerModule SNom[NbMotors] = ActiveMotorShare * s0Pu.re * SystemBase.SnRef "Nominal apparent power of a single motor in MVA";
  parameter Types.PerUnit RsPu[NbMotors] "Stator resistance in pu (base SNom, UNom)";
  parameter Types.PerUnit LsPu[NbMotors] "Synchronous reactance in pu (base SNom, UNom)";
  // Notation: L (reactance) + P ("'" or "Prim") + Pu (Per unit)
  parameter Types.PerUnit LPPu[NbMotors] "Transient reactance in pu (base SNom, UNom)";
  parameter Types.PerUnit LPPPu[NbMotors] "Subtransient reactance in pu (base SNom, UNom)";
  parameter Types.Time tP0[NbMotors] "Transient open circuit time constant in s";
  parameter Types.Time tPP0[NbMotors] "Subtransient open circuit time constant in s";
  parameter Types.Time H[NbMotors] "Inertia constant in s";
  parameter Real torqueExponent[NbMotors] "Exponent of the torque speed dependency";

  parameter Types.VoltageModulePu Utrip1Pu[NbMotors] "Voltage at which the first block of motors trip in pu (base UNom)";
  parameter Types.Time tTrip1Pu[NbMotors] "Time lag before tripping of the first block of motors in s";
  parameter Real shareTrip1Pu[NbMotors] "Share of motors in the first block of motors";
  parameter Types.VoltageModulePu Ureconnect1Pu[NbMotors] "Voltage at which the first block of motors reconnects in pu (base UNom)";
  parameter Types.Time tReconnect1Pu[NbMotors] "Time lag before reconnection of the first block of motors in s";
  parameter Types.VoltageModulePu Utrip2Pu[NbMotors] "Voltage at which the second block of motors trip in pu (base UNom)";
  parameter Types.Time tTrip2Pu[NbMotors] "Time lag before tripping of the second block of motors in s";
  parameter Real shareTrip2Pu[NbMotors] "Share of motors in the second block of motors";
  parameter Types.VoltageModulePu Ureconnect2Pu[NbMotors] "Voltage at which the second block of motors reconnects in pu (base UNom)";
  parameter Types.Time tReconnect2Pu[NbMotors] "Time lag before reconnection of the second block of motors in s";

  Connectors.ImPin omegaRefPu(value(start = SystemBase.omegaRef0Pu)) "Network angular reference frequency in pu (base omegaNom)";

  Types.ActivePowerPu PLoadPu(start = PLoad0Pu) "Active power consumed by the load in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu QLoadPu(start = QLoad0Pu) "Reactive power consumed by the load in pu (base SnRef) (receptor convention)";

  Dynawo.Electrical.Machines.Motors.MotorFifthOrder motors[NbMotors](SNom = SNom, RsPu = RsPu, LsPu = LsPu, LPPu = LPPu, LPPPu = LPPPu, tP0 = tP0, tPP0 = tPP0, H = H, torqueExponent = torqueExponent, each NbSwitchOffSignals = 2, EdP0Pu = EdP0Pu, EqP0Pu = EqP0Pu, EdPP0Pu = EdPP0Pu, EqPP0Pu = EqPP0Pu,  Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, Ce0Pu = Ce0Pu, Slip0 = Slip0, omegaR0Pu = omegaR0Pu, i0Pu = iMotor0Pu, s0Pu = sMotor0Pu, each u0Pu = u0Pu, Utrip1Pu = Utrip1Pu, tTrip1Pu = tTrip1Pu, shareTrip1Pu = shareTrip1Pu, Ureconnect1Pu = Ureconnect1Pu, tReconnect1Pu = tReconnect1Pu, Utrip2Pu = Utrip2Pu, tTrip2Pu = tTrip2Pu, shareTrip2Pu = shareTrip2Pu, Ureconnect2Pu = Ureconnect2Pu, tReconnect2Pu = tReconnect2Pu);
  Types.ActivePowerPu PLoadCmdPu(start = PLoad0Pu) "Active power reference for the load in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu QLoadCmdPu(start = QLoad0Pu) "Reactive power reference for in pu (base SnRef) (receptor convention)";

  // Initial values
  parameter Types.PerUnit Ce0Pu[NbMotors] "Start value of the electrical torque in pu (base SNom, omegaNom)";
  parameter Types.VoltageComponentPu EdP0Pu[NbMotors] "Start value of voltage behind transient reactance d component in pu (base UNom)";
  parameter Types.VoltageComponentPu EqP0Pu[NbMotors] "Start value of voltage behind transient reactance q component in pu (base UNom)";
  parameter Types.VoltageComponentPu EdPP0Pu[NbMotors] "Start value of voltage behind subtransient reactance d component in pu (base UNom)";
  parameter Types.VoltageComponentPu EqPP0Pu[NbMotors] "Start value of voltage behind subtransient reactance q component in pu (base UNom)";
  parameter Types.CurrentComponentPu Id0Pu[NbMotors] "Start value of current of direct axis in pu (base SNom, UNom)";
  parameter Types.CurrentComponentPu Iq0Pu[NbMotors] "Start value of current of quadrature axis in pu (base SNom, UNom)";
  parameter Types.ActivePowerPu PLoad0Pu "Start value of the active power consumed by the load in pu (base SnRef)";
  parameter Types.ReactivePowerPu QLoad0Pu "Start value of the reactive power consumed by the load in pu (base SnRef)";
  parameter Real Slip0[NbMotors] "Start value of the slip of the motor";
  parameter Types.AngularVelocityPu omegaR0Pu[NbMotors] "Start value of the angular velocity of the motor in pu (base omegaNom)";
  parameter Types.ComplexCurrentPu iMotor0Pu[NbMotors] "Start value of complex current at load terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexApparentPowerPu sMotor0Pu[NbMotors] "Start value of complex apparent power in pu (base SnRef) (receptor convention)";

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
end BaseLoadMotorFifthOrder;
