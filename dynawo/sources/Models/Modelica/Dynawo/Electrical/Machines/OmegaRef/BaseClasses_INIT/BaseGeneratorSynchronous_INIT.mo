within Dynawo.Electrical.Machines.OmegaRef.BaseClasses_INIT;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

partial model BaseGeneratorSynchronous_INIT "Base initialization model for synchronous machine"
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  extends BaseClasses.GeneratorSynchronousParameters;

  parameter Types.ComplexCurrentPu iStart0Pu = Complex(0, 0) "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";

  //Internal parameters (final value used in the equations) in pu (base UNom, SNom)
  /*For an initialization from internal parameters:
      - Apply the transformation due to the presence of the generator transformer to the internal parameters given by the user
    For an initialization from external parameters:
      - Calculate the internal parameter from the external parameters
      - Apply the transformation due to the presence of a generator transformer in the model to the internal parameters calculated from the external ones*/

  Types.PerUnit RaPPu "Armature resistance in pu";
  Types.PerUnit LdPPu "Direct axis stator leakage in pu";
  Types.PerUnit MdPPu "Direct axis mutual inductance in pu";
  Types.PerUnit LDPPu "Direct axis damper leakage in pu";
  Types.PerUnit RDPPu "Direct axis damper resistance in pu";
  Types.PerUnit MrcPPu "Canay's mutual inductance in pu";
  Types.PerUnit LfPPu "Excitation winding leakage in pu";
  Types.PerUnit RfPPu "Excitation winding resistance in pu";
  Types.PerUnit LqPPu "Quadrature axis stator leakage in pu";
  Types.PerUnit MqPPu "Quadrature axis mutual inductance in pu";
  Types.PerUnit LQ1PPu "Quadrature axis 1st damper leakage in pu";
  Types.PerUnit RQ1PPu "Quadrature axis 1st damper resistance in pu";
  Types.PerUnit LQ2PPu "Quadrature axis 2nd damper leakage in pu";
  Types.PerUnit RQ2PPu "Quadrature axis 2nd damper resistance in pu";

  // Start values calculated by the initialization model
  Types.PerUnit MdPPuEfd "Direct axis mutual inductance used to determine the excitation voltage in pu";
  Types.PerUnit MdPPuEfdNom "Direct axis mutual inductance used to determine the excitation voltage in nominal conditions in pu";
  Types.PerUnit Kuf "Scaling factor for excitation pu voltage";

  Types.ComplexApparentPowerPu sStator0Pu "Start value of complex apparent power at stator side in pu (base SnRef)";
  Types.ComplexVoltagePu uStator0Pu "Start value of complex voltage at stator side in pu (base UNom)";
  Types.ComplexCurrentPu iStator0Pu "Start value of complex current at stator side in pu (base UNom, SnRef)";

  Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power at terminal side in pu (base SnRef)";
  Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal side (base UNom)";
  Types.ComplexCurrentPu i0Pu(re(start=iStart0Pu.re)) "Start value of complex current at terminal side (base UNom, SnRef)";
  Types.ApparentPowerModulePu S0Pu "Start value of apparent power at terminal side in pu (base SNom)";
  Types.CurrentModulePu I0Pu "Start value of current module at terminal side in pu (base UNom, SNom)";

  Types.ActivePowerPu PGen0Pu "Start value of active power at terminal in pu (base SnRef) (generator convention)";
  Types.ReactivePowerPu QGen0Pu "Start value of reactive power at terminal in pu (base SnRef) (generator convention)";

  Types.Angle Theta0 "Start value of rotor angle: angle between machine rotor frame and port phasor frame";

  Types.PerUnit Ud0Pu "Start value of voltage of direct axis in pu";
  Types.PerUnit Uq0Pu "Start value of voltage of quadrature axis in pu";
  Types.PerUnit Id0Pu "Start value of current of direct axis in pu";
  Types.PerUnit Iq0Pu "Start value of current of quadrature axis in pu";

  Types.PerUnit If0Pu "Start value of current of excitation winding in pu";
  Types.PerUnit Uf0Pu "Start value of exciter voltage in pu (Kundur base)";
  Types.PerUnit Efd0Pu "Start value of input exciter voltage in pu (user-selected base)";

  Types.PerUnit Lambdad0Pu "Start value of flux of direct axis in pu";
  Types.PerUnit Lambdaq0Pu "Start value of flux of quadrature axis in pu";
  Types.PerUnit LambdaD0Pu "Start value of flux of direct axis damper";
  Types.PerUnit Lambdaf0Pu "Start value of flux of excitation winding";
  Types.PerUnit LambdaQ10Pu "Start value of flux of quadrature axis 1st damper";
  Types.PerUnit LambdaQ20Pu "Start value of flux of quadrature axis 2nd damper";

  Types.PerUnit Ce0Pu "Start value of electrical torque in pu (base SNom/omegaNom)";
  Types.PerUnit Cm0Pu "Start value of mechanical torque in pu (base PNomTurb/omegaNom)";
  Types.PerUnit Pm0Pu "Start value of mechanical power in pu (base PNomTurb/omegaNom)";

  Types.VoltageModulePu UStator0Pu "Start value of stator voltage amplitude in pu (base UNom)";
  Types.CurrentModulePu IStator0Pu "Start value of stator current amplitude in pu (base SnRef)";
  Types.ReactivePowerPu QStator0Pu "Start value of stator reactive power generated in pu (base SnRef)";
  Types.ReactivePowerPu QStator0PuQNom "Start value of stator reactive power generated in pu (base QNomAlt)";
  Types.CurrentModulePu IRotor0Pu "Start value of rotor current in pu (base SNom, user-selected base voltage)";
  Types.Angle ThetaInternal0 "Start value of internal angle in rad";

  Types.PerUnit MsalPu "Constant difference between direct and quadrature axis saturated mutual inductances in pu";
  Types.PerUnit MdSat0PPu "Start value of direct axis saturated mutual inductance in pu";
  Types.PerUnit MqSat0PPu "Start value of quadrature axis saturated mutual inductance in pu";
  Types.PerUnit LambdaAirGap0Pu "Start value of total air gap flux in pu";
  Types.PerUnit LambdaAD0Pu "Start value of common flux of direct axis in pu";
  Types.PerUnit LambdaAQ0Pu "Start value of common flux of quadrature axis in pu";
  Types.PerUnit Mds0Pu "Start value of direct axis saturated mutual inductance in the case when the total air gap flux is aligned on the direct axis in pu";
  Types.PerUnit Mqs0Pu "Start value of quadrature axis saturated mutual inductance in the case when the total air gap flux is aligned on the quadrature axis in pu";
  Types.PerUnit Cos2Eta0 "Start value of the common flux of direct axis contribution to the total air gap flux in pu";
  Types.PerUnit Sin2Eta0 "Start value of the common flux of quadrature axis contribution to the total air gap flux in pu";
  Types.PerUnit Mi0Pu "Start value of intermediate axis saturated mutual inductance in pu";

equation
  // Apparent power, voltage and current at stator side in pu (base SnRef, UNom)
  uStator0Pu = 1 / rTfoPu * (u0Pu - i0Pu * Complex(RTfoPu, XTfoPu) * SystemBase.SnRef / SNom);
  iStator0Pu = rTfoPu * i0Pu ;
  sStator0Pu = uStator0Pu * ComplexMath.conj(iStator0Pu);

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
  IStator0Pu = rTfoPu * I0Pu * SNom/SystemBase.SnRef;
  QStator0Pu = - ComplexMath.imag(sStator0Pu);
  QStator0PuQNom = QStator0Pu * SystemBase.SnRef / QNomAlt;
  IRotor0Pu = RfPPu / (Kuf * rTfoPu) * If0Pu;
  ThetaInternal0 = ComplexMath.arg(Complex(Uq0Pu, Ud0Pu));
  S0Pu = ComplexMath.'abs'(s0Pu)*SystemBase.SnRef/SNom;
  I0Pu = ComplexMath.'abs'(i0Pu)*SystemBase.SnRef/SNom;

  annotation(preferredView = "text");
end BaseGeneratorSynchronous_INIT;
