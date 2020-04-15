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
  extends Icons.BasesPackage;

function RotorPositionEstimation
    extends Icons.Function;

  input Real u0PuRe;
  input Real u0PuIm;
  input Real i0PuRe;
  input Real i0PuIm;
  input Types.PerUnit rTfo0Pu;
  input Types.PerUnit XdPu;
  input Types.PerUnit XqPu;
  input Types.PerUnit XlPu;
  input Types.PerUnit RaPu;
  input Types.PerUnit RTfoPu;
  input Types.PerUnit XTfoPu;
  input Types.ApparentPowerModule SNom;
  input Real md;
  input Real mq;
  input Real nd;
  input Real nq;

  output Real MsalPu;
  output Real Theta0;
  output Real Ud0Pu;
  output Real Uq0Pu;
  output Real Id0Pu;
  output Real Iq0Pu;
  output Real LambdaAD0Pu;
  output Real LambdaAQ0Pu;
  output Real LambdaAirGap0Pu;
  output Real Mds0Pu;
  output Real Mqs0Pu;
  output Real Cos2Eta0;
  output Real Sin2Eta0;
  output Real Mi0Pu;
  output Real MdSat0PPu;
  output Real MqSat0PPu;

protected
  Real MdPPu;
  Real MqPPu;
  Real LdPPu;
  Real LqPPu;
  Real RaPPu;
  Boolean iterate;
  Integer nbIterations;
  Real MdSave;
  Real MqSave;
  Real deltaMd;
  Real deltaMq;
  Real XqPPu;
  Real cosTheta0;
  Real sinTheta0;

algorithm
  MdPPu := (XdPu - XlPu) * rTfo0Pu * rTfo0Pu;
  MqPPu := (XqPu - XlPu) * rTfo0Pu * rTfo0Pu;
  LdPPu := XlPu * rTfo0Pu * rTfo0Pu;
  LqPPu := XlPu * rTfo0Pu * rTfo0Pu;
  RaPPu := RaPu * rTfo0Pu * rTfo0Pu;
  MsalPu := MdPPu - MqPPu;
  MdSat0PPu := MdPPu;
  MqSat0PPu := MqPPu;
  MdSave := MdSat0PPu;
  MqSave := MqSat0PPu;
  iterate := true;
  nbIterations := 0;

  while iterate loop

    // Theta calculation
    XqPPu := MqSat0PPu + (LqPPu + XTfoPu);
    sinTheta0 := u0PuIm -    XqPPu         *i0PuRe*SystemBase.SnRef/SNom - (RaPPu + RTfoPu)*i0PuIm*SystemBase.SnRef/SNom;
    cosTheta0 := u0PuRe - (RaPPu + RTfoPu) *i0PuRe*SystemBase.SnRef/SNom +       XqPPu     *i0PuIm*SystemBase.SnRef/SNom;
    Theta0 := atan(sinTheta0/cosTheta0);

    // Park's transformations
    Ud0Pu := sin(Theta0) * u0PuRe - cos(Theta0) * u0PuIm;
    Uq0Pu := cos(Theta0) * u0PuRe + sin(Theta0) * u0PuIm;
    Id0Pu := sin(Theta0) * i0PuRe*SystemBase.SnRef/SNom - cos(Theta0) * i0PuIm*SystemBase.SnRef/SNom;
    Iq0Pu := cos(Theta0) * i0PuRe*SystemBase.SnRef/SNom + sin(Theta0) * i0PuIm*SystemBase.SnRef/SNom;

    // Common flux calculations - Not very sure of sign conventions
    LambdaAD0Pu := (Uq0Pu - (RaPPu + RTfoPu) * Iq0Pu - (LdPPu  + XTfoPu) * Id0Pu);
    LambdaAQ0Pu := - Ud0Pu + (RaPPu + RTfoPu) * Id0Pu - (LqPPu + XTfoPu) * Iq0Pu;
    LambdaAirGap0Pu := sqrt(LambdaAD0Pu^2 + LambdaAQ0Pu^2);

    // Saturation part
    Mds0Pu := MdPPu / (1 + md*LambdaAirGap0Pu^nd);
    Mqs0Pu := MqPPu / (1 + mq*LambdaAirGap0Pu^nq);
    Cos2Eta0 := LambdaAD0Pu^2 / LambdaAirGap0Pu^2;
    Sin2Eta0 := LambdaAQ0Pu^2 / LambdaAirGap0Pu^2;
    Mi0Pu := Mds0Pu*Cos2Eta0 + Mqs0Pu*Sin2Eta0;
    MdSat0PPu := Mi0Pu + MsalPu*Sin2Eta0;
    MqSat0PPu := Mi0Pu - MsalPu*Cos2Eta0;

    // Algorithm stopping conditions
    deltaMd := abs(MdSat0PPu - MdSave);
    deltaMq := abs(MqSat0PPu - MqSave);
    nbIterations := nbIterations + 1;
    MdSave := MdSat0PPu;
    MqSave := MqSat0PPu;
    iterate := (deltaMd > 0.000001 or deltaMq > 0.000001) and nbIterations < 10;
  end while;

end RotorPositionEstimation;

partial model BaseGeneratorSimplified_INIT "Base initialization model for simplified generator models"
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

annotation(preferredView = "text");
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

    Types.ActivePowerPu PGen0Pu "Start value of active power at terminal in p.u (base SnRef) (generator convention)";
    Types.ReactivePowerPu QGen0Pu "Start value of reactive power at terminal in p.u (base SnRef) (generator convention)";

    Types.Angle Theta0 "Start value of rotor angle: angle between machine rotor frame and port phasor frame";

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

    Types.PerUnit MsalPu "";

    Types.PerUnit MdSat0PPu "Start value of direct axis saturated mutual inductance in p.u.";
    Types.PerUnit MqSat0PPu "Start value of quadrature axis saturated mutual inductance in p.u.";
    Types.PerUnit LambdaAirGap0Pu "Start value of total air gap flux in p.u.";
    Types.PerUnit LambdaAD0Pu "Start value of      in p.u.";
    Types.PerUnit LambdaAQ0Pu "Start value of      in p.u.";
    Types.PerUnit Mds0Pu "Start value of      in p.u.";
    Types.PerUnit Mqs0Pu "Start value of      in p.u.";
    Types.PerUnit Cos2Eta0 "Start value of      in p.u.";
    Types.PerUnit Sin2Eta0 "Start value of      in p.u.";
    Types.PerUnit Mi0Pu "Start value of      in p.u.";

//    Types.PerUnit MdSat0PPu(start = 1.529) "Start value of direct axis saturated mutual inductance in p.u.";
//    Types.PerUnit MqSat0PPu(start = 1.579) "Start value of quadrature axis saturated mutual inductance in p.u.";
//    Types.PerUnit LambdaAirGap0Pu(start = 1.076) "Start value of total air gap flux in p.u.";
//    Types.PerUnit LambdaAD0Pu(start = 0.8934) "Start value of      in p.u.";
//    Types.PerUnit LambdaAQ0Pu(start = -0.6004) "Start value of      in p.u.";
//    Types.PerUnit Mds0Pu(start = 1.578) "Start value of      in p.u.";
//    Types.PerUnit Mqs0Pu(start = 1.5305) "Start value of      in p.u.";
//    Types.PerUnit Cos2Eta0(start = 0.688) "Start value of      in p.u.";
//    Types.PerUnit Sin2Eta0(start = 0.312) "Start value of      in p.u.";
//    Types.PerUnit Mi0Pu(start = 1.566) "Start value of      in p.u.";



    Types.PerUnit Ce0Pu "Start value of electrical torque in p.u (base SNom/omegaNom)";
    Types.PerUnit Cm0Pu "Start value of mechanical torque in p.u (base PNomTurb/omegaNom)";
    Types.PerUnit Pm0Pu "Start value of mechanical power in p.u (base PNomTurb/omegaNom)";

    Types.VoltageModulePu UStator0Pu "Start value of stator voltage amplitude in p.u (base UNom)";
    Types.CurrentModulePu IStator0Pu "Start value of stator current amplitude in p.u (base SnRef)";
    Types.ReactivePowerPu QStator0Pu "Start value of stator reactive power generated in p.u (base SnRef)";
    Types.ReactivePowerPu QStator0PuQNom "Start value of stator reactive power generated in p.u (base QNomAlt)";
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
  uStator0Pu = 1 / rTfoPu * (u0Pu - i0Pu * Complex(RTfoPu, XTfoPu) * SystemBase.SnRef / SNom);
  iStator0Pu = rTfoPu * i0Pu ;
  sStator0Pu = uStator0Pu * ComplexMath.conj(iStator0Pu);
  S0Pu = sqrt(P0Pu^2+Q0Pu^2)*SystemBase.SnRef/SNom;
  I0Pu = S0Pu/U0Pu;

  // Saturation part
  (MsalPu, Theta0, Ud0Pu, Uq0Pu, Id0Pu, Iq0Pu, LambdaAD0Pu, LambdaAQ0Pu, LambdaAirGap0Pu, Mds0Pu, Mqs0Pu, Cos2Eta0, Sin2Eta0, Mi0Pu, MdSat0PPu, MqSat0PPu) = RotorPositionEstimation(u0Pu.re, u0Pu.im, i0Pu.re, i0Pu.im, rTfoPu, XdPu, XqPu, XlPu, RaPu, RTfoPu, XTfoPu, SNom, md, mq, nd, nq);

// Flux linkages
  Lambdad0Pu  = (MdSat0PPu + (LdPPu + XTfoPu)) * Id0Pu +          MdSat0PPu          * If0Pu;
  Lambdaf0Pu  =           MdSat0PPu            * Id0Pu + (MdSat0PPu + LfPPu + MrcPPu)* If0Pu;
  LambdaD0Pu  =           MdSat0PPu            * Id0Pu +     (MdSat0PPu + MrcPPu)    * If0Pu;
  LambdaQ10Pu =           MqSat0PPu            * Iq0Pu;
  LambdaQ20Pu =           MqSat0PPu            * Iq0Pu;

// Equivalent circuit equations in Park's coordinates
  Ud0Pu = (RaPPu + RTfoPu) * Id0Pu - SystemBase.omega0Pu * Lambdaq0Pu;
  Uq0Pu = (RaPPu + RTfoPu) * Iq0Pu + SystemBase.omega0Pu * Lambdad0Pu;
  Uf0Pu = RfPPu * If0Pu;
  Efd0Pu = Uf0Pu/(Kuf*rTfoPu);

// Mechanical equations
  Ce0Pu = Lambdaq0Pu*Id0Pu - Lambdad0Pu*Iq0Pu;
  Cm0Pu = Ce0Pu/PNomTurb*SNom;
  Pm0Pu = Cm0Pu*SystemBase.omega0Pu;

// Output variables for external controlers
  UStator0Pu = ComplexMath.'abs' (uStator0Pu);
  IStator0Pu = rTfoPu * I0Pu *SNom/SystemBase.SnRef;
  QStator0Pu = - ComplexMath.imag(sStator0Pu);
  QStator0PuQNom = QStator0Pu * SystemBase.SnRef / QNomAlt;
  IRotor0Pu = MdSat0PPu / rTfoPu * If0Pu;
  ThetaInternal0 = Theta0;

annotation(preferredView = "text");
end BaseGeneratorSynchronous_INIT;



partial model BaseGeneratorSynchronousInt_INIT "Base initialization model for synchronous machine from internal parameters"

  extends BaseGeneratorSynchronous_INIT;

    // Internal parameters of the synchronous machine given as parameters
    parameter Types.PerUnit RaPu "Armature resistance in p.u.";
    parameter Types.PerUnit LdPu "Direct axis stator leakage in p.u.";
    parameter Types.PerUnit MdPu "Direct axis mutual inductance in p.u.";
    parameter Types.PerUnit LDPu "Direct axis damper leakage in p.u.";
    parameter Types.PerUnit RDPu "Direct axis damper resistance in p.u.";
    parameter Types.PerUnit MrcPu "Canay's mutual inductance in p.u.";
    parameter Types.PerUnit LfPu "Excitation winding leakage in p.u.";
    parameter Types.PerUnit RfPu "Excitation windings resistance in p.u.";
    parameter Types.PerUnit LqPu "Quadrature axis stator leakage in p.u.";
    parameter Types.PerUnit MqPu "Quadrature axis mutual inductance in p.u.";
    parameter Types.PerUnit LQ1Pu "Quadrature axis 1st damper leakage in p.u.";
    parameter Types.PerUnit RQ1Pu "Quadrature axis 1st damper resistance in p.u.";
    parameter Types.PerUnit LQ2Pu "Quadrature axis 2nd damper leakage in p.u.";
    parameter Types.PerUnit RQ2Pu "Quadrature axis 2nd damper resistance in p.u.";
    parameter Types.PerUnit MdPuEfd "Direct axis mutual inductance used to determine the excitation voltage in p.u.";

annotation(preferredView = "text");
end BaseGeneratorSynchronousInt_INIT;



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

annotation(preferredView = "text");
end BaseGeneratorSynchronousExt_INIT;

partial model BaseGeneratorSynchronousExt4E_INIT "Base initialization model for synchronous machine from external parameters with four windings"

  extends BaseGeneratorSynchronousExt_INIT;

    parameter Types.PerUnit XpqPu "Quadrature axis transient reactance in p.u.";
    parameter Types.Time Tpq0 "Open circuit quadrature axis transient time constant";
    parameter Types.PerUnit XppqPu "Quadrature axis sub-transient reactance in p.u.";
    parameter Types.Time Tppq0 "Open circuit quadrature axis sub-transient time constant";

  protected

    // Auxiliary parameters: quadrature axis
    Types.Time Tpq;
    Types.Time Tppq;

    Types.PerUnit T1qPu;
    Types.PerUnit T4qPu;
    Types.PerUnit T3qPu;
    Types.PerUnit T6qPu;

equation

  Tpq = Tpq0 * XpqPu / XqPu;
  Tppq = Tppq0 * XppqPu / XpqPu;

  T1qPu = Tpq0  * SystemBase.omegaNom;
  T4qPu = Tpq   * SystemBase.omegaNom;
  T3qPu = Tppq0 * SystemBase.omegaNom;
  T6qPu = Tppq  * SystemBase.omegaNom;

  LQ1Pu * (MqPu + LqPu) * (T1qPu - T4qPu) = (MqPu + LqPu) * MqPu * T4qPu - MqPu * LqPu * T1qPu;
  RQ1Pu * T1qPu = MqPu + LQ1Pu;

  LQ2Pu * (MqPu + LQ1Pu) * (T3qPu - T6qPu) = MqPu * LQ1Pu * (T6qPu - T3qPu * (MqPu + LQ1Pu) * LqPu / (MqPu * LqPu + MqPu * LQ1Pu + LqPu * LQ1Pu));
  RQ2Pu * T3qPu = LQ2Pu + MqPu * LQ1Pu / (MqPu + LQ1Pu);

annotation(preferredView = "text");
end BaseGeneratorSynchronousExt4E_INIT;


partial model BaseGeneratorSynchronousExt3E_INIT "Base initialization model for synchronous machine from external parameters with three windings"

  extends BaseGeneratorSynchronousExt_INIT;

    parameter Types.PerUnit XppqPu "Quadrature axis sub-transient reactance in p.u.";
    parameter Types.Time Tppq0 "Open circuit quadrature axis sub-transient time constant";

  protected

    Types.Time Tppq;

    Types.PerUnit T3qPu;
    Types.PerUnit T6qPu;

equation

  Tppq = Tppq0 * XppqPu / XqPu;

  T3qPu = Tppq0 * SystemBase.omegaNom;
  T6qPu = Tppq  * SystemBase.omegaNom;

  LQ1Pu * (MqPu + LqPu) * (T3qPu - T6qPu) = (MqPu + LqPu) * MqPu * T6qPu - MqPu * LqPu * T3qPu;
  RQ1Pu * T3qPu = MqPu + LQ1Pu;

  RQ2Pu = 0;
  LQ2Pu = 100000;

annotation(preferredView = "text");
end BaseGeneratorSynchronousExt3E_INIT;

annotation(preferredView = "text");
end BaseClasses_INIT;
