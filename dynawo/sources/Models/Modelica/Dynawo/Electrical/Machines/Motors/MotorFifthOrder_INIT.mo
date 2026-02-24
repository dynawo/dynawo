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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model MotorFifthOrder_INIT "Initialization model for MotorFifthOrder"
  extends BaseClasses_INIT.BaseMotor_INIT;
  extends AdditionalIcons.Init;

  parameter Types.PerUnit RsPu "Stator resistance in pu (base SNom, UNom)";
  parameter Types.PerUnit LsPu "Synchronous reactance in pu (base SNom, UNom)";
  // Notation: L (reactance) + P ("'" or "Prim") + Pu (Per unit)
  parameter Types.PerUnit LPPu "Transient reactance in pu (base SNom, UNom)";
  parameter Types.PerUnit LPPPu "Subtransient reactance in pu (base SNom, UNom)";
  parameter Types.Time tP0 "Transient open circuit time constant in s";
  parameter Types.Time tPP0 "Subtransient open circuit time constant in s";

  Types.PerUnit EdP0Pu(start = 1) "Start value of voltage behind transient reactance d component in pu (base UNom)";
  Types.PerUnit EqP0Pu "Start value of voltage behind transient reactance q component in pu (base UNom)";
  Types.PerUnit EdPP0Pu(start = 1) "Start value of voltage behind subtransient reactance d component in pu (base UNom)";
  Types.PerUnit EqPP0Pu "Start value of voltage behind subtransient reactance q component in pu (base UNom)";
  Types.PerUnit id0Pu "Start value of current of direct axis in pu (base SNom, Unom)";
  Types.PerUnit iq0Pu "Start value of current of quadrature axis in pu (base SNom, Unom)";
  Types.AngularVelocityPu omegaR0Pu "Start value of the angular velocity of the motor in pu (base omegaNom)";
  Types.PerUnit ce0Pu "Start value of the electrical torque in pu (base SNom, omegaNom)";
  Real s0 "Start value of the slip of the motor";

equation
  0 = -EqP0Pu + id0Pu * (LsPu - LPPu) - EdP0Pu * SystemBase.omegaNom * SystemBase.omegaRef0Pu * s0 * tP0;
  0 = -EdP0Pu - iq0Pu * (LsPu - LPPu) + EqP0Pu * SystemBase.omegaNom * SystemBase.omegaRef0Pu * s0 * tP0;
  0 = 1/tPP0 * (EqP0Pu - EqPP0Pu + (LPPu - LPPPu) * id0Pu) + SystemBase.omegaNom * SystemBase.omegaRef0Pu * s0 * (EdP0Pu - EdPP0Pu);
  0 = 1/tPP0 * (EdP0Pu - EdPP0Pu - (LPPu - LPPPu) * iq0Pu) - SystemBase.omegaNom * SystemBase.omegaRef0Pu * s0 * (EqP0Pu - EqPP0Pu);

  u0Pu = Complex(EdPP0Pu, EqPP0Pu) + Complex(RsPu, LPPPu) * Complex(id0Pu, iq0Pu);
  Complex(P0Pu, Q0Pu) = u0Pu * Complex(id0Pu, -iq0Pu) * (SNom / SystemBase.SnRef);

  s0 = (SystemBase.omegaRef0Pu - omegaR0Pu) / SystemBase.omegaRef0Pu;
  ce0Pu = EdPP0Pu * id0Pu + EqPP0Pu * iq0Pu;

  annotation(preferredView = "text");
end MotorFifthOrder_INIT;
