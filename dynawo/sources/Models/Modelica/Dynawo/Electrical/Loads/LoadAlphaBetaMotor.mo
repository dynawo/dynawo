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

model LoadAlphaBetaMotor "AlphaBeta load in parallel with an induction motor. The load torque is supposed constant (does not change with rotor speed)."
/*
                  isPu          umPu  irPu
    terminal --.--->----Rs+jXs---.----->--Rr+jXr------.
               |                 |                    |
            PQ load             jXm                Rr(1-s)/s
               |                 |                    |
               ----------------------------------------

imPu goes downwards through jXm
*/

  extends BaseClasses.BaseLoad;
  extends AdditionalIcons.Load;

  Connectors.ImPin omegaRefPu(value(start = SystemBase.omegaRef0Pu)) "Network angular reference frequency in pu (base omegaNom)";

  parameter Real ActiveMotorShare "Share of active power consumed by motors (between 0 and 1)";
  parameter Types.ApparentPowerModule SNom = ActiveMotorShare * s0Pu.re * SystemBase.SnRef "Nominal apparent power of a single motor in MVA";
  parameter Types.PerUnit RsPu "Stator resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit RrPu "Rotor resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XsPu "Stator leakage reactance in pu (base UNom, SNom)";
  parameter Types.PerUnit XrPu "Rotor leakage reactance in pu (base UNom, SNom)";
  parameter Types.PerUnit XmPu "Magnetizing reactance in pu (base UNom, SNom)";
  parameter Real H "Inertia constant (s, base UNom, SNom)";

  parameter Real Alpha "Active load sensitivity to voltage";
  parameter Real Beta "Reactive load sensitivity to voltage";

  Types.ComplexCurrentPu isPu(re(start = is0Pu.re), im(start = is0Pu.im)) "Stator current in pu (base UNom, SNom) (receptor convention)";
  Types.ComplexCurrentPu imPu(re(start = im0Pu.re), im(start = im0Pu.im)) "Magnetising current in pu (base UNom, SNom) (receptor convention)";
  Types.ComplexCurrentPu irPu(re(start = ir0Pu.re), im(start = ir0Pu.im)) "Rotor current in pu (base UNom, SNom) (receptor convention)";

  Types.PerUnit cePu(start = ce0Pu) "Electrical torque in pu (base SNom, omegaNom)";
  Types.PerUnit clPu(start = ce0Pu) "Load torque in pu (base SNom, omegaNom)";
  Real s(start = s0) "Slip of the motor";
  Types.AngularVelocity omegaRPu(start = omegaR0Pu) "Angular velocity of the motor in pu (base omegaNom)";

  Types.ActivePowerPu PLoadPu(start = PLoad0Pu) "Active power consumed by the load in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu QLoadPu(start = QLoad0Pu) "Reactive power consumed by the load in pu (base SnRef) (receptor convention)";
  Complex iLoadPu(re(start = iLoad0Pu.re), im(start = iLoad0Pu.im)) "Complex current consumed by the load in pu (base SnRef) (receptor convention)";

protected
  final parameter Types.ComplexImpedancePu ZsPu = Complex(RsPu,XsPu) "Stator impedance in pu (base UNom, SNom)";
  final parameter Types.ComplexImpedancePu ZrPu = Complex(RrPu,XrPu) "Rotor impedance in pu (base UNom, SNom)";
  final parameter Types.ComplexImpedancePu ZmPu = Complex(0,XmPu) "Magnetising impedance in pu (base UNom, SNom)";

public
  // Motor initial values
  parameter Types.ComplexCurrentPu is0Pu "Start value of the stator current in pu (base SNom, UNom)";
  parameter Types.ComplexCurrentPu im0Pu "Start value of the magnetising current in pu (base SNom, UNom)";
  parameter Types.ComplexCurrentPu ir0Pu "Start value of the rotor current in pu (base SNom, UNom)";

  parameter Types.PerUnit ce0Pu "Start value of the electrical torque in pu (SNom base)";
  parameter Types.PerUnit cl0Pu "Start value of the load torque in pu (SNom base)";
  parameter Real s0 "Start value of the slip of the motor";
  parameter Types.AngularVelocity omegaR0Pu "Start value of the angular velocity of the motor in pu (base omegaNom)";

  parameter Types.ReactivePowerPu QMotor0Pu "Start value of the reactive power consumed by the motor in pu (base SNom)";

  // Load initial values
  parameter Types.ActivePowerPu PLoad0Pu "Start value of the active power consumed by the load in pu (SnRef base)";
  parameter Types.ReactivePowerPu QLoad0Pu "Start value of the reactive power consumed by the load in pu (SnRef base)";
  parameter Types.ComplexCurrentPu iLoad0Pu "Start value of the complex current consumed by the load in pu (SnRef base)";

equation
  assert(0 < ActiveMotorShare and ActiveMotorShare < 1, "ActiveMotorShare should be between 0 and 1");

  if (running.value) then
    // PQ load
    PLoadPu = (1-ActiveMotorShare) * PRefPu * (1 + deltaP) * ((ComplexMath.'abs' (terminal.V) / ComplexMath.'abs' (u0Pu)) ^ Alpha);
    QLoadPu = (QRefPu * (1 + deltaQ) - QMotor0Pu * (SNom/SystemBase.SnRef) * (PRefPu/s0Pu.re) * (1 + deltaP)) * ((ComplexMath.'abs' (terminal.V) / ComplexMath.'abs' (u0Pu)) ^ Beta); // s0Pu.re = PRef0Pu (if PRefPu increases but QRefPu stays constant, the reactive power consumed by the motor increases, so the reactive power of the load is reduced to keep the total constant).
    Complex(PLoadPu,QLoadPu) = terminal.V*ComplexMath.conj(iLoadPu);

    // Asynchronous motor
    terminal.V = ZmPu*imPu + ZsPu*isPu; // Kirchhoff’s voltage law in the first loop
    isPu = terminal.V/(ZsPu + 1/(1/ZmPu + s/Complex(RrPu,XrPu*s))); // Avoid numerical issues when s = 0
    isPu = imPu + irPu;

    s = (omegaRefPu.value - omegaRPu)/omegaRefPu.value;
    cePu = RrPu*ComplexMath.'abs'(irPu^2)/(omegaRefPu.value*s);
    clPu = ce0Pu; // Constant load torque
    2*H*der(omegaRPu) = cePu - clPu;

    // Total load
    terminal.i = iLoadPu + (SNom/SystemBase.SnRef)*isPu * (PRefPu/s0Pu.re) * (1 + deltaP);
  else
    omegaRPu = 0;
    PLoadPu = 0;
    QLoadPu = 0;
    iLoadPu = Complex(0);
    isPu = Complex(0);
    imPu = Complex(0);
    irPu = Complex(0);
    cePu = 0;
    clPu = 0;
    s = 0;
    terminal.i = Complex(0);
  end if;

  annotation(preferredView = "text");
end LoadAlphaBetaMotor;
