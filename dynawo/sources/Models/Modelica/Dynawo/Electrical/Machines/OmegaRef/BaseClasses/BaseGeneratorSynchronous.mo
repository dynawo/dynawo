within Dynawo.Electrical.Machines.OmegaRef.BaseClasses;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

partial model BaseGeneratorSynchronous "Synchronous machine - Base dynamic model"
  extends GeneratorSynchronousParameters;
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffGenerator;

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the synchronous generator to the grid" annotation(
    Placement(visible = true, transformation(origin = {0, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Input variables
  input Dynawo.Connectors.AngularVelocityPuConnector omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference frequency in pu";
  input Dynawo.Connectors.ActivePowerPuConnector PmPu(start = Pm0Pu) "Mechanical power in pu (base PNomTurb)";
  input Dynawo.Connectors.VoltageModulePuConnector efdPu(start = Efd0Pu) "Input voltage of exciter winding in pu (user-selected base voltage)";

  // Output variables
  output Dynawo.Connectors.AngularVelocityPuConnector omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu";

  // Internal parameters of the synchronous machine in pu (base UNom, SNom)
  // These parameters are calculated at the initialization stage from the inputs parameters (internal or external)
  // These are the parameters used in the dynamic equations of the synchronous machine
  // Notation: Ra (resistance) + P ("'" or "Prim") + Pu (Per unit)
  parameter Types.PerUnit RaPPu "Armature resistance in pu";
  parameter Types.PerUnit LdPPu "Direct axis stator leakage in pu";
  parameter Types.PerUnit MdPPu "Direct axis mutual inductance in pu";
  parameter Types.PerUnit LDPPu "Direct axis damper leakage in pu";
  parameter Types.PerUnit RDPPu "Direct axis damper resistance in pu";
  parameter Types.PerUnit MrcPPu "Canay's mutual inductance in pu";
  parameter Types.PerUnit LfPPu "Excitation winding leakage in pu";
  parameter Types.PerUnit RfPPu "Excitation winding resistance in pu";
  parameter Types.PerUnit LqPPu "Quadrature axis stator leakage in pu";
  parameter Types.PerUnit MqPPu "Quadrature axis mutual inductance in pu";
  parameter Types.PerUnit LQ1PPu "Quadrature axis 1st damper leakage in pu";
  parameter Types.PerUnit RQ1PPu "Quadrature axis 1st damper resistance in pu";
  parameter Types.PerUnit LQ2PPu "Quadrature axis 2nd damper leakage in pu";
  parameter Types.PerUnit RQ2PPu "Quadrature axis 2nd damper resistance in pu";
  parameter Types.PerUnit MsalPu "Constant difference between direct and quadrature axis saturated mutual inductances in pu";
  // pu factor for excitation voltage
  parameter Types.PerUnit MdPPuEfd "Direct axis mutual inductance used to determine the excitation voltage in pu";
  parameter Types.PerUnit MdPPuEfdNom "Direct axis mutual inductance used to determine the excitation voltage in nominal conditions in pu";
  final parameter Types.PerUnit Kuf = if ExcitationPu == ExcitationPuType.Kundur then 1 elseif ExcitationPu == ExcitationPuType.UserBase then RfPPu / MdPPuEfd elseif ExcitationPu == ExcitationPuType.NoLoad then RfPPu / MdPPu elseif ExcitationPu == ExcitationPuType.NoLoadSaturated then RfPPu * (1 + md) / MdPPu else RfPPu / MdPPuEfdNom "Scaling factor for excitation pu voltage";

  // Start values given as inputs of the initialization process
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude in pu (base UNom)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.Angle UPhase0 "Start value of voltage angle in rad";

  // Start values used by the regulations
  parameter Types.PerUnit Efd0Pu "Start value of input exciter voltage in pu (user-selected base)";
  parameter Types.PerUnit Pm0Pu "Start value of mechanical power in pu (base PNomTurb/OmegaNom)";

  // Start values calculated by the initialization model
  parameter Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power at terminal in pu (base SnRef)";
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef)";
  parameter Types.Angle Theta0 "Start value of rotor angle: angle between machine rotor frame and port phasor frame";

  // Start values calculated by the initialization model
  parameter Types.PerUnit Ud0Pu "Start value of voltage of direct axis in pu";
  parameter Types.PerUnit Uq0Pu "Start value of voltage of quadrature axis in pu";
  parameter Types.PerUnit Id0Pu "Start value of current of direct axis in pu";
  parameter Types.PerUnit Iq0Pu "Start value of current of quadrature axis in pu";
  parameter Types.PerUnit If0Pu "Start value of current of excitation winding in pu";
  parameter Types.PerUnit Uf0Pu "Start value of exciter voltage in pu (Kundur base)";
  parameter Types.PerUnit Lambdad0Pu "Start value of flux of direct axis in pu";
  parameter Types.PerUnit Lambdaq0Pu "Start value of flux of quadrature axis in pu";
  parameter Types.PerUnit LambdaD0Pu "Start value of flux of direct axis damper";
  parameter Types.PerUnit Lambdaf0Pu "Start value of flux of excitation winding";
  parameter Types.PerUnit LambdaQ10Pu "Start value of flux of quadrature axis 1st damper";
  parameter Types.PerUnit LambdaQ20Pu "Start value of flux of quadrature axis 2nd damper";
  parameter Types.PerUnit Ce0Pu "Start value of electrical torque in pu (base SNom/OmegaNom)";
  parameter Types.PerUnit Cm0Pu "Start value of mechanical torque in pu (base PNomTurb/OmegaNom)";
  parameter Types.PerUnit MdSat0PPu "Start value of direct axis saturated mutual inductance in pu";
  parameter Types.PerUnit MqSat0PPu "Start value of quadrature axis saturated mutual inductance in pu";
  parameter Types.PerUnit LambdaAirGap0Pu "Start value of total air gap flux in pu";
  parameter Types.PerUnit LambdaAD0Pu "Start value of common flux of direct axis in pu";
  parameter Types.PerUnit LambdaAQ0Pu "Start value of common flux of quadrature axis in pu";
  parameter Types.PerUnit Mds0Pu "Start value of direct axis saturated mutual inductance in the case when the total air gap flux is aligned on the direct axis in pu";
  parameter Types.PerUnit Mqs0Pu "Start value of quadrature axis saturated mutual inductance in the case when the total air gap flux is aligned on the quadrature axis in pu";
  parameter Types.PerUnit Cos2Eta0 "Start value of the common flux of direct axis contribution to the total air gap flux in pu";
  parameter Types.PerUnit Sin2Eta0 "Start value of the common flux of quadrature axis contribution to the total air gap flux in pu";
  parameter Types.PerUnit Mi0Pu "Start value of intermediate axis saturated mutual inductance in pu";

  // d-q axis pu variables (base UNom, SNom)
  Types.PerUnit udPu(start = Ud0Pu) "Voltage of direct axis in pu";
  Types.PerUnit uqPu(start = Uq0Pu) "Voltage of quadrature axis in pu";
  Dynawo.Connectors.PerUnitConnector idPu(start = Id0Pu) "Current of direct axis in pu";
  Types.PerUnit iqPu(start = Iq0Pu) "Current of quadrature axis in pu";
  Types.PerUnit iDPu(start = 0) "Current of direct axis damper in pu";
  Types.PerUnit iQ1Pu(start = 0) "Current of quadrature axis 1st damper in pu";
  Types.PerUnit iQ2Pu(start = 0) "Current of quadrature axis 2nd damper in pu";
  Types.PerUnit ifPu(start = If0Pu) "Current of excitation winding in pu";
  Types.PerUnit ufPu(start = Uf0Pu) "Voltage of exciter winding in pu (base voltage as per Kundur)";
  Types.PerUnit lambdadPu(start = Lambdad0Pu) "Flux of direct axis in pu";
  Types.PerUnit lambdaqPu(start = Lambdaq0Pu) "Flux of quadrature axis in pu";
  Types.PerUnit lambdaDPu(start = LambdaD0Pu) "Flux of direct axis damper in pu";
  Types.PerUnit lambdafPu(start = Lambdaf0Pu) "Flux of excitation winding in pu";
  Types.PerUnit lambdaQ1Pu(start = LambdaQ10Pu) "Flux of quadrature axis 1st damper in pu";
  Types.PerUnit lambdaQ2Pu(start = LambdaQ20Pu) "Flux of quadrature axis 2nd damper in pu";

  // Other variables
  Dynawo.Connectors.AngleConnector theta(start = Theta0) "Rotor angle: angle between machine rotor frame and port phasor frame";
  Types.PerUnit cmPu(start = Cm0Pu) "Mechanical torque in pu (base PNomTurb/OmegaNom)";
  Types.PerUnit cePu(start = Ce0Pu) "Electrical torque in pu (base SNom/OmegaNom)";
  Types.PerUnit PePu(start = Ce0Pu * SystemBase.omega0Pu) "Electrical active power in pu (base SNom)";

  // Saturated mutual inductances and related variables
  Types.PerUnit MdSatPPu(start = MdSat0PPu) "Direct axis saturated mutual inductance in pu";
  Types.PerUnit MqSatPPu(start = MqSat0PPu) "Quadrature axis saturated mutual inductance in pu";
  Types.PerUnit lambdaAirGapPu(start = LambdaAirGap0Pu) "Total air gap flux in pu";
  Types.PerUnit lambdaADPu(start = LambdaAD0Pu) "Common flux of direct axis in pu";
  Types.PerUnit lambdaAQPu(start = LambdaAQ0Pu) "Common flux of quadrature axis in pu";
  Types.PerUnit mdsPu(start = Mds0Pu) "Direct axis saturated mutual inductance in the case when the total air gap flux is aligned on the direct axis in pu";
  Types.PerUnit mqsPu(start = Mqs0Pu) "Quadrature axis saturated mutual inductance in the case when the total air gap flux is aligned on the quadrature axis in pu";
  Types.PerUnit cos2Eta(start = Cos2Eta0) "Common flux of direct axis contribution to the total air gap flux in pu";
  Types.PerUnit sin2Eta(start = Sin2Eta0) "Common flux of quadrature axis contribution to the total air gap flux in pu";
  Types.PerUnit miPu(start = Mi0Pu) "Intermediate axis saturated mutual inductance in pu";

equation
  assert(SNom <> PNomAlt, "The alternator nominal active power should be different from the nominal apparent power");

  if running.value then
    // Park's transformations
    terminal.V.re = sin(theta) * udPu + cos(theta) * uqPu;
    terminal.V.im = (-cos(theta) * udPu) + sin(theta) * uqPu;
    terminal.i.re * SystemBase.SnRef / SNom = sin(theta) * idPu + cos(theta) * iqPu;
    terminal.i.im * SystemBase.SnRef / SNom = (-cos(theta) * idPu) + sin(theta) * iqPu;
    // Flux linkages
    lambdadPu = (MdSatPPu + LdPPu + XTfoPu) * idPu + MdSatPPu * ifPu + MdSatPPu * iDPu;
    lambdafPu = MdSatPPu * idPu + (MdSatPPu + LfPPu + MrcPPu) * ifPu + (MdSatPPu + MrcPPu) * iDPu;
    lambdaDPu = MdSatPPu * idPu + (MdSatPPu + MrcPPu) * ifPu + (MdSatPPu + LDPPu + MrcPPu) * iDPu;
    lambdaqPu = (MqSatPPu + LqPPu + XTfoPu) * iqPu + MqSatPPu * iQ1Pu + MqSatPPu * iQ2Pu;
    lambdaQ1Pu = MqSatPPu * iqPu + (MqSatPPu + LQ1PPu) * iQ1Pu + MqSatPPu * iQ2Pu;
    lambdaQ2Pu = MqSatPPu * iqPu + MqSatPPu * iQ1Pu + (MqSatPPu + LQ2PPu) * iQ2Pu;
    // Equivalent circuit equations in Park's coordinates
    udPu = (RaPPu + RTfoPu) * idPu - omegaPu * lambdaqPu;
    uqPu = (RaPPu + RTfoPu) * iqPu + omegaPu * lambdadPu;
    ufPu = RfPPu * ifPu + der(lambdafPu) / SystemBase.omegaNom;
    0 = RDPPu * iDPu + der(lambdaDPu) / SystemBase.omegaNom;
    0 = RQ1PPu * iQ1Pu + der(lambdaQ1Pu) / SystemBase.omegaNom;
    0 = RQ2PPu * iQ2Pu + der(lambdaQ2Pu) / SystemBase.omegaNom;
    // Mechanical equations
    der(theta) = (omegaPu - omegaRefPu) * SystemBase.omegaNom;
    2 * H * der(omegaPu) = cmPu * PNomTurb / SNom - cePu - DPu * (omegaPu - omegaRefPu);
    cePu = lambdaqPu * idPu - lambdadPu * iqPu;
    PePu = cePu * omegaPu;
    PmPu = cmPu * omegaPu;
    // Excitation voltage pu conversion
    ufPu = efdPu * (Kuf * rTfoPu);
    // Mutual inductances saturation
    lambdaADPu = MdSatPPu * (idPu + ifPu + iDPu);
    lambdaAQPu = MqSatPPu * (iqPu + iQ1Pu + iQ2Pu);
    lambdaAirGapPu = sqrt(lambdaADPu ^ 2 + lambdaAQPu ^ 2);
    mdsPu = MdPPu / (1 + md * lambdaAirGapPu ^ nd);
    mqsPu = MqPPu / (1 + mq * lambdaAirGapPu ^ nq);
    cos2Eta = lambdaADPu ^ 2 / lambdaAirGapPu ^ 2;
    sin2Eta = lambdaAQPu ^ 2 / lambdaAirGapPu ^ 2;
    miPu = mdsPu * cos2Eta + mqsPu * sin2Eta;
    MdSatPPu = miPu + MsalPu * sin2Eta;
    MqSatPPu = miPu - MsalPu * cos2Eta;
  else
    udPu = 0;
    uqPu = 0;
    terminal.i = Complex(0,0);
    idPu = 0;
    iqPu = 0;
    ifPu = 0;
    iDPu = 0;
    iQ1Pu = 0;
    iQ2Pu = 0;
    lambdadPu = 0;
    lambdaqPu = 0;
    der(lambdafPu) = 0;
    der(lambdaDPu) = 0;
    der(lambdaQ1Pu) = 0;
    der(lambdaQ2Pu) = 0;
    der(theta) = 0;
    der(omegaPu) = 0;
    cePu = 0;
    PePu = 0;
    cmPu = 0;
    ufPu = 0;
    lambdaADPu = 0;
    lambdaAQPu = 0;
    lambdaAirGapPu = 0;
    mdsPu = 0;
    mqsPu = 0;
    cos2Eta = 0;
    sin2Eta = 0;
    miPu = 0;
    MdSatPPu = MdPPu;
    MqSatPPu = MqPPu;
  end if;

  annotation(preferredView = "text");
end BaseGeneratorSynchronous;
