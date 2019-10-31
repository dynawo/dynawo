within Dynawo.Electrical.Machines;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

package BaseClasses_INIT

partial model BaseGeneratorSimplified_INIT "Base initialization model for simplified generator models"

  public
    parameter Types.ActivePowerPu P0Pu  "Start value of active power at terminal in p.u (base SnRef) (receptor convention)";
    parameter Types.ReactivePowerPu Q0Pu  "Start value of reactive power at terminal in p.u (base SnRef) (receptor convention)";
    parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal in p.u (base UNom)";
    parameter Types.Angle UPhase0  "Start value of voltage angle at terminal in rad";

  protected
    Types.ActivePowerPu PGen0Pu "Start value of active power at terminal in p.u (base SnRef) (generator convention)";
    Types.ReactivePowerPu QGen0Pu "Start value of reactive power at terminal in p.u (base SnRef) (generator convention)";

    Types.ComplexVoltagePu u0Pu  "Start value of complex voltage at terminal in p.u (base UNom)";
    Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power at terminal in p.u (base SnRef) (receptor convention)";
    Types.ComplexCurrentPu i0Pu  "Start value of complex current at terminal in p.u (base UNom, SnRef) (receptor convention)";

equation

  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  s0Pu = Complex(P0Pu, Q0Pu);
  s0Pu = u0Pu * ComplexMath.conj(i0Pu);

  // Convention change
  PGen0Pu = -P0Pu;
  QGen0Pu = -Q0Pu;

end BaseGeneratorSimplified_INIT;

partial model BaseGeneratorSynchronous_INIT "Base initialization model for synchronous machine"
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  extends BaseClasses.GeneratorSynchronousParameters;

  protected

    //Internal parameters (final value used in the equations) in p.u (base UNom, SNom)
    /*For an initialization from internal parameters:
        - Apply the transformation due to the presence of the generator transformer to the internal parameters given by the user
      For an initialization from external parameters:
        - Calculate the internal parameter from the external parameters
        - Apply the transformation due to the presence of a generator transformer in the model to the internal parameters calculated from the external ones*/
    Types.PerUnit RaPPu "Armature resistance in p.u.";
    Types.PerUnit LdPPu "Direct axis stator leakage in p.u.";
    Types.PerUnit MdPPu "Direct axis mutual inductance in p.u.";
    Types.PerUnit LDPPu "Direct axis damper leakage in p.u.";
    Types.PerUnit RDPPu "Direct axis damper resistance in p.u.";
    Types.PerUnit MrcPPu "Canay's mutual inductance in p.u.";
    Types.PerUnit LfPPu "Excitation winding leakage in p.u.";
    Types.PerUnit RfPPu "Excitation winding resistance in p.u.";
    Types.PerUnit LqPPu "Quadrature axis stator leakage in p.u.";
    Types.PerUnit MqPPu "Quadrature axis mutual inductance in p.u.";
    Types.PerUnit LQ1PPu "Quadrature axis 1st damper leakage in p.u.";
    Types.PerUnit RQ1PPu "Quadrature axis 1st damper resistance in p.u.";
    Types.PerUnit LQ2PPu "Quadrature axis 2nd damper leakage in p.u.";
    Types.PerUnit RQ2PPu "Quadrature axis 2nd damper resistance in p.u.";

    // Used for initialization of theta
    Types.PerUnit XqPPu "Quadrature axis reactance in p.u.";

    // Start values calculated by the initialization model
    Types.PerUnit MdPPuEfd "Direct axis mutual inductance used to determine the excitation voltage in p.u.";
    Types.PerUnit Kuf "Scaling factor for excitation p.u voltage";

    Types.ComplexApparentPowerPu sStator0Pu "Start value of complex apparent power at stator side in p.u (base SnRef)";
    Types.ComplexVoltagePu uStator0Pu "Start value of complex voltage at stator side in p.u (base UNom)";
    Types.ComplexCurrentPu iStator0Pu "Start value of complex current at stator side in p.u (base UNom, SnRef)";

    Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power at terminal side in p.u (base SnRef)";
    Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal side (base UNom)";
    Types.ComplexCurrentPu i0Pu "Start value of complex current at terminal side (base UNom, SnRef)";

    Types.ApparentPowerModulePu S0Pu "Start value of apparent power at terminal side in p.u (base SNom)";
    Types.CurrentModulePu I0Pu "Start value of current module at terminal side in p.u (base UNom, SNom)";
    Types.Angle phi0 "Start value of power factor";

    Types.ActivePowerPu PGen0Pu "Start value of active power at terminal in p.u (base SnRef) (generator convention)";
    Types.ReactivePowerPu QGen0Pu "Start value of reactive power at terminal in p.u (base SnRef) (generator convention)";

    Types.Angle Theta0 "Start value of rotor angle: angle between machine rotor frame and port phasor frame";
    Types.PerUnit sinTheta0 "Start value of sin(theta)";
    Types.PerUnit cosTheta0 "Start value of cos(theta)";
    Types.PerUnit tanTheta0 "Start value of tan(theta)";

    Types.PerUnit Ud0Pu "Start value of voltage of direct axis in p.u";
    Types.PerUnit Uq0Pu "Start value of voltage of quadrature axis in p.u";
    Types.PerUnit Id0Pu "Start value of current of direct axis in p.u";
    Types.PerUnit Iq0Pu "Start value of current of quadrature axis in p.u";

    Types.PerUnit If0Pu "Start value of flux of excitation winding in p.u";
    Types.PerUnit Uf0Pu "Start value of exciter voltage in p.u (Kundur base)";
    Types.PerUnit Efd0Pu "Start value of input exciter voltage in p.u (user-selcted base)";

    Types.PerUnit Lambdad0Pu "Start value of flux of direct axis in p.u";
    Types.PerUnit Lambdaq0Pu "Start value of flux of quadrature axis in p.u";
    Types.PerUnit LambdaD0Pu "Start value of flux of direct axis damper";
    Types.PerUnit Lambdaf0Pu "Start value of flux of excitation winding";
    Types.PerUnit LambdaQ10Pu "Start value of flux of quadrature axis 1st damper";
    Types.PerUnit LambdaQ20Pu "Start value of flux of quadrature axis 2nd damper";

    Types.PerUnit Ce0Pu "Start value of electrical torque in p.u (base SNom/omegaNom)";
    Types.PerUnit Cm0Pu "Start value of mechanical torque in p.u (base PNom/omegaNom)";
    Types.PerUnit Pm0Pu "Start value of mechanical power in p.u (base PNom/omegaNom)";

    Types.VoltageModulePu UStator0Pu "Start value of stator voltage amplitude in p.u (base UNom)";
    Types.CurrentModulePu IStator0Pu "Start value of stator current amplitude in p.u (base SnRef)";
    Types.ReactivePowerPu QStator0Pu "Start value of stator reactive power generated in p.u (base SnRef)";
    Types.CurrentModulePu IRotor0Pu "Start value of rotor current in p.u (base SNom)";
    Types.Angle ThetaInternal0 "Start value of internal angle";

equation
  MdPPuEfd = MdPuEfd  * rTfoPu * rTfoPu;
  if ExcitationPu == ExcitationPuType.Kundur then
    Kuf = 1;
  elseif ExcitationPu == ExcitationPuType.UserBase then
    assert(MdPuEfd <> 0, "Direct axis mutual inductance should be different from 0");
    Kuf = RfPPu / MdPPuEfd;
  else
    Kuf = RfPPu / MdPPu;
  end if;

  // Used for initialization of theta
  XqPPu = MqPPu + (LqPPu + XTfoPu);

  // Internal parameters after transformation due to the presence of a generator transformer in the model
  RaPPu  = RaPu  * rTfoPu * rTfoPu;
  LdPPu  = LdPu  * rTfoPu * rTfoPu;
  MdPPu  = MdPu  * rTfoPu * rTfoPu;
  LDPPu  = LDPu  * rTfoPu * rTfoPu;
  RDPPu  = RDPu  * rTfoPu * rTfoPu;
  MrcPPu = MrcPu * rTfoPu * rTfoPu;
  LfPPu  = LfPu  * rTfoPu * rTfoPu;
  RfPPu  = RfPu  * rTfoPu * rTfoPu;
  LqPPu  = LqPu  * rTfoPu * rTfoPu;
  MqPPu  = MqPu  * rTfoPu * rTfoPu;
  LQ1PPu = LQ1Pu * rTfoPu * rTfoPu;
  RQ1PPu = RQ1Pu * rTfoPu * rTfoPu;
  LQ2PPu = LQ2Pu * rTfoPu * rTfoPu;
  RQ2PPu = RQ2Pu * rTfoPu * rTfoPu;

// Apparent power, voltage and current at terminal in p.u (base SnRef, UNom)
  s0Pu = Complex(P0Pu, Q0Pu);
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  s0Pu = u0Pu * ComplexMath.conj(i0Pu);

  PGen0Pu = -P0Pu;
  QGen0Pu = -Q0Pu;

// Apparent power, voltage and current at stator side in p.u (base SnRef, UNom)
  uStator0Pu = 1 / rTfoPu * (u0Pu - i0Pu * Complex(RTfoPu, XTfoPu));
  iStator0Pu = rTfoPu * i0Pu ;
  sStator0Pu = uStator0Pu * ComplexMath.conj(iStator0Pu);

// Rotation between machine rotor frame and port phasor frame
  S0Pu = sqrt(P0Pu^2+Q0Pu^2)*SystemBase.SnRef/SNom;
  I0Pu = S0Pu/U0Pu;
  phi0 = acos(abs(P0Pu/sqrt(P0Pu^2+Q0Pu^2)));
  sinTheta0 = u0Pu.im -    XqPPu         *i0Pu.re*SystemBase.SnRef/SNom - (RaPPu + RTfoPu)*i0Pu.im*SystemBase.SnRef/SNom;
  cosTheta0 = u0Pu.re - (RaPPu + RTfoPu) *i0Pu.re*SystemBase.SnRef/SNom +       XqPPu     *i0Pu.im*SystemBase.SnRef/SNom;
  tanTheta0 = sinTheta0/cosTheta0;
  Theta0 = atan(tanTheta0);

// Park's transformations
  u0Pu.re =  sin(Theta0)*Ud0Pu + cos(Theta0)*Uq0Pu;
  u0Pu.im = -cos(Theta0)*Ud0Pu + sin(Theta0)*Uq0Pu;
  i0Pu.re*SystemBase.SnRef/SNom =  sin(Theta0)*Id0Pu + cos(Theta0)*Iq0Pu;
  i0Pu.im*SystemBase.SnRef/SNom = -cos(Theta0)*Id0Pu + sin(Theta0)*Iq0Pu;

// Flux linkages
  Lambdad0Pu  = (MdPPu + (LdPPu + XTfoPu)) * Id0Pu +          MdPPu          * If0Pu;
  Lambdaf0Pu  =           MdPPu            * Id0Pu + (MdPPu + LfPPu + MrcPPu)* If0Pu;
  LambdaD0Pu  =           MdPPu            * Id0Pu +     (MdPPu + MrcPPu)    * If0Pu;
  LambdaQ10Pu =           MqPPu            * Iq0Pu;
  LambdaQ20Pu =           MqPPu            * Iq0Pu;

// Equivalent circuit equations in Park's coordinates
  Ud0Pu = (RaPPu + RTfoPu) * Id0Pu - SystemBase.omega0Pu * Lambdaq0Pu;
  Uq0Pu = (RaPPu + RTfoPu) * Iq0Pu + SystemBase.omega0Pu * Lambdad0Pu;
  Uf0Pu = RfPPu * If0Pu;
  Efd0Pu = Uf0Pu/(Kuf*rTfoPu);

// Mechanical equations
  Ce0Pu = Lambdaq0Pu*Id0Pu - Lambdad0Pu*Iq0Pu;
  Cm0Pu = Ce0Pu/PNom*SNom;
  Pm0Pu = Cm0Pu*SystemBase.omega0Pu;

// Output variables for external controlers
  UStator0Pu = ComplexMath.'abs' (uStator0Pu);
  IStator0Pu = rTfoPu * I0Pu *SNom/SystemBase.SnRef;
  QStator0Pu = - ComplexMath.imag(sStator0Pu);
  IRotor0Pu = MdPPu / rTfoPu * If0Pu;
  ThetaInternal0 = Theta0;

end BaseGeneratorSynchronous_INIT;

partial model BaseGeneratorSynchronousExt_INIT "Base initialization model for synchronous machine from external parameters"

  extends BaseGeneratorSynchronous_INIT;

  public

    // External parameters of the synchronous machine given as parameters in p.u (base UNom, SNom)
    parameter Types.PerUnit RaPu "Armature resistance in p.u.";
    parameter Types.PerUnit XlPu "Stator leakage in p.u.";
    parameter Types.PerUnit XdPu "Direct axis reactance in p.u.";
    parameter Types.PerUnit XpdPu "Direct axis transient reactance in p.u.";
    parameter Types.PerUnit XppdPu "Direct axis sub-transient reactance p.u.";
    parameter Types.Time Tpd0 "Direct axis, open circuit transient time constant";
    parameter Types.Time Tppd0 "Direct axis, open circuit sub-transient time constant";
    parameter Types.PerUnit XqPu "Quadrature axis reactance in p.u.";
    parameter Types.PerUnit MdPuEfd "Direct axis mutual inductance used to determine the excitation voltage in p.u.";

  protected

    // Internal parameters to be calculated from the external ones in p.u (base UNom, SNom)
    Types.PerUnit LdPu "Direct axis stator leakage in p.u.";
    Types.PerUnit MdPu "Direct axis mutual inductance in p.u.";
    Types.PerUnit LDPu "Direct axis damper leakage in p.u.";
    Types.PerUnit RDPu "Direct axis damper resistance in p.u.";
    Types.PerUnit MrcPu "Canay's mutual inductance in p.u.";
    Types.PerUnit LfPu "Excitation winding leakage in p.u.";
    Types.PerUnit RfPu "Excitation winding resistance in p.u.";
    Types.PerUnit LqPu "Quadrature axis stator leakage in p.u.";
    Types.PerUnit MqPu "Quadrature axis mutual inductance in p.u.";
    Types.PerUnit LQ1Pu "Quadrature axis 1st damper leakage in p.u.";
    Types.PerUnit RQ1Pu "Quadrature axis 1st damper resistance in p.u.";
    Types.PerUnit LQ2Pu "Quadrature axis 2nd damper leakage in p.u.";
    Types.PerUnit RQ2Pu "Quadrature axis 2nd damper resistance in p.u.";

    // Auxiliary parameters: direct axis (see Kundur implementation, p143)
    Types.Time Tpd;
    Types.Time Tppd;

    Types.PerUnit T1dPu;
    Types.PerUnit T3dPu;
    Types.PerUnit T4dPu;
    Types.PerUnit T6dPu;

    // Auxiliary parameters: quadrature axis (see Kundur implementation, p143)
    // see subclasses

equation

  MrcPu = 0;

  // Direct axis
  LdPu = XlPu;
  MdPu + LdPu = XdPu;

  Tpd = Tpd0 * XpdPu / XdPu;
  Tppd = Tppd0 * XppdPu / XpdPu;

  T1dPu = Tpd0  * SystemBase.omegaNom;
  T3dPu = Tppd0 * SystemBase.omegaNom;
  T4dPu = Tpd   * SystemBase.omegaNom;
  T6dPu = Tppd  * SystemBase.omegaNom;

  LfPu * (MdPu + LdPu) * (T1dPu - T4dPu) = MdPu * ( (MdPu + LdPu) * T4dPu -  LdPu * T1dPu);
  RfPu * T1dPu = MdPu + LfPu;

  LDPu * (MdPu + LfPu) * (T3dPu - T6dPu) = MdPu * LfPu * (T6dPu - T3dPu * (MdPu + LfPu) * LdPu / (MdPu * LdPu + MdPu * LfPu + LdPu * LfPu));
  RDPu * T3dPu = LDPu + MdPu * LfPu / (MdPu + LfPu);

  // Quadrature axis
  LqPu = XlPu;
  MqPu + LqPu = XqPu;

end BaseGeneratorSynchronousExt_INIT;

end BaseClasses_INIT;
