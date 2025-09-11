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

model SimplifiedMotor "Simplified model of an induction motor"
/*
                  isPu          umPu  irPu
    terminal ------>----Rs+jXs---.----->--Rr+jXr------.
                                 |                    |
                                jXm                Rr(1-s)/s
                                 |                    |
               ----------------------------------------

imPu goes downwards through jXm
*/
  extends BaseClasses.BaseMotor;
  extends AdditionalIcons.Machine;

  parameter Types.PerUnit RsPu "Stator resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit RrPu "Rotor resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XsPu "Stator leakage reactance in pu (base UNom, SNom)";
  parameter Types.PerUnit XrPu "Rotor leakage reactance in pu (base UNom, SNom)";
  parameter Types.PerUnit XmPu "Magnetizing reactance in pu (base UNom, SNom)";
  parameter Real H "Inertia constant in s";
  parameter Real torqueExponent "Exponent of the torsque speed dependency";

  Types.ComplexCurrentPu isPu(re(start = is0Pu.re), im(start = is0Pu.im)) "Stator current in pu (base UNom, SNom) (receptor convention)";
  Types.ComplexCurrentPu imPu(re(start = im0Pu.re), im(start = im0Pu.im)) "Magnetising current in pu (base UNom, SNom) (receptor convention)";
  Types.ComplexCurrentPu irPu(re(start = ir0Pu.re), im(start = ir0Pu.im)) "Rotor current in pu (base UNom, SNom) (receptor convention)";

  Types.PerUnit cePu(start = Ce0Pu) "Electrical torque in pu (base SNom, omegaNom)";
  Types.PerUnit clPu(start = Ce0Pu) "Load torque in pu (base SNom, omegaNom)";
  Real slip(start = Slip0) "Slip of the motor";
  Types.AngularVelocityPu omegaRPu(start = omegaR0Pu) "Angular velocity of the motor in pu (base omegaNom)";

protected
  final parameter Types.ComplexImpedancePu ZsPu = Complex(RsPu, XsPu) "Stator impedance in pu (base UNom, SNom)";
  final parameter Types.ComplexImpedancePu ZrPu = Complex(RrPu, XrPu) "Rotor impedance in pu (base UNom, SNom)";
  final parameter Types.ComplexImpedancePu ZmPu = Complex(0, XmPu) "Magnetising impedance in pu (base UNom, SNom)";

public
  parameter Types.ComplexCurrentPu is0Pu "Start value of the stator current in pu (base SNom, UNom)";
  parameter Types.ComplexCurrentPu im0Pu "Start value of the magnetising current in pu (base SNom, UNom)";
  parameter Types.ComplexCurrentPu ir0Pu "Start value of the rotor current in pu (base SNom, UNom)";
  parameter Types.PerUnit Ce0Pu "Start value of the electrical torque in pu (base SNom)";
  parameter Real Slip0 "Start value of the slip of the motor";
  parameter Types.AngularVelocityPu omegaR0Pu "Start value of the angular velocity of the motor in pu (base omegaNom)";

equation
  if (running.value) then
    V = ZmPu * imPu + ZsPu * isPu;  // Kirchhoff’s voltage law in the first loop
    isPu = V / (ZsPu + 1 / (1 / ZmPu + slip / Complex(RrPu, XrPu * slip)));  // Avoid numerical issues when s = 0
    isPu = imPu + irPu;
    SPu = V * ComplexMath.conj(isPu) * (SNom / SystemBase.SnRef);

    slip = (omegaRefPu.value - omegaRPu) / omegaRefPu.value;
    cePu = RrPu * ComplexMath.'abs'(irPu ^ 2) / (omegaRefPu.value * slip);
    clPu = Ce0Pu * (omegaRPu / omegaR0Pu) ^ torqueExponent;
    2 * H * der(omegaRPu) = cePu - clPu;
  else
    der(omegaRPu) = 0;
    isPu = Complex(0);
    imPu = Complex(0);
    irPu = Complex(0);
    cePu = 0;
    clPu = 0;
    slip = 0;
    SPu = Complex(0);
  end if;

  annotation(preferredView = "text");
end SimplifiedMotor;
