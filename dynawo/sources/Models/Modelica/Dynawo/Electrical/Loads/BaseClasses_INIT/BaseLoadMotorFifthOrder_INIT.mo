within Dynawo.Electrical.Loads.BaseClasses_INIT;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model BaseLoadMotorFifthOrder_INIT "Base initialization model for loads in parallel to fifth order motor model(s)"
  extends AdditionalIcons.Init;
  extends Load_INIT;

  parameter Integer NbMotors "Number of motors modelled in the load";
  parameter Real ActiveMotorShare[NbMotors](each min = 0, each max = 1) "Share of active power consumed by motors (between 0 and 1)";
  parameter Types.ApparentPowerModule SNom[NbMotors] = ActiveMotorShare * P0Pu * SystemBase.SnRef "Nominal apparent power of a single motor in MVA";
  parameter Types.PerUnit RsPu[NbMotors] "Stator resistance in pu (base SNom, UNom)";
  parameter Types.PerUnit LsPu[NbMotors] "Synchronous reactance in pu (base SNom, UNom)";
  // Notation: L (reactance) + P ("'" or "Prim") + Pu (Per unit)
  parameter Types.PerUnit LPPu[NbMotors] "Transient reactance in pu (base SNom, UNom)";
  parameter Types.PerUnit LPPPu[NbMotors] "Subtransient reactance in pu (base SNom, UNom)";
  parameter Types.Time tP0[NbMotors] "Transient open circuit time constant in s";
  parameter Types.Time tPP0[NbMotors] "Subtransient open circuit time constant in s";

  Types.ActivePowerPu PLoad0Pu "Start value of the active power consumed by the load in pu (base SnRef)";
  Types.ReactivePowerPu QLoad0Pu "Start value of the reactive power consumed by the load in pu (base SnRef)";
  Types.PerUnit EdP0Pu[NbMotors] "Start value of voltage behind transient reactance d component in pu (base UNom)";
  Types.PerUnit EqP0Pu[NbMotors] "Start value of voltage behind transient reactance q component in pu (base UNom)";
  Types.PerUnit EdPP0Pu[NbMotors] "Start value of voltage behind subtransient reactance d component in pu (base UNom)";
  Types.PerUnit EqPP0Pu[NbMotors] "Start value of voltage behind subtransient reactance q component in pu (base UNom)";
  Types.PerUnit id0Pu[NbMotors] "Start value of current of direct axis in pu (base SNom, UNom)";
  Types.PerUnit iq0Pu[NbMotors] "Start value of current of quadrature axis in pu (base SNom, UNom)";
  Types.PerUnit ce0Pu[NbMotors] "Start value of the electrical torque in pu (base SNom, omegaNom)";
  Real s0[NbMotors] "Start value of the slip of the motor";
  Types.AngularVelocityPu omegaR0Pu[NbMotors] "Start value of the angular velocity of the motor in pu (base omegaNom)";
  Types.ComplexCurrentPu motori0Pu[NbMotors] "Start value of complex current at load terminal in pu (base UNom, SnRef) (receptor convention)";
  Types.ComplexApparentPowerPu motors0Pu[NbMotors] "Start value of complex apparent power in pu (base SnRef) (receptor convention)";

  Dynawo.Electrical.Machines.Motors.MotorFifthOrder_INIT motors_INIT[NbMotors](SNom=SNom, RsPu=RsPu, LsPu=LsPu, LPPu=LPPu, LPPPu=LPPPu, tP0=tP0, tPP0=tPP0, P0Pu=ActiveMotorShare*P0Pu, each U0Pu=U0Pu, each UPhase0=UPhase0);

equation
  PLoad0Pu = (1-sum(ActiveMotorShare)) * P0Pu;
  QLoad0Pu = Q0Pu - sum(motors_INIT.s0Pu.im);

  EdP0Pu = motors_INIT.EdP0Pu;
  EqP0Pu = motors_INIT.EqP0Pu;
  EdPP0Pu = motors_INIT.EdPP0Pu;
  EqPP0Pu = motors_INIT.EqPP0Pu;
  id0Pu = motors_INIT.id0Pu;
  iq0Pu = motors_INIT.iq0Pu;
  ce0Pu = motors_INIT.ce0Pu;
  s0 = motors_INIT.s0;
  omegaR0Pu = motors_INIT.omegaR0Pu;
  motori0Pu = motors_INIT.i0Pu;
  motors0Pu = motors_INIT.s0Pu;

  annotation(preferredView = "text");
end BaseLoadMotorFifthOrder_INIT;

