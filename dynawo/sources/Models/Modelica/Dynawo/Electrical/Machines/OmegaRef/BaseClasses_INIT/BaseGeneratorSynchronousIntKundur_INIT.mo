within Dynawo.Electrical.Machines.OmegaRef.BaseClasses_INIT;

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

partial model BaseGeneratorSynchronousIntKundur_INIT "Base initialization model for synchronous machine from internal parameters"
  extends BaseGeneratorSynchronousKundur_INIT;

  // Internal parameters of the synchronous machine given as parameters
  parameter Types.PerUnit RaPu "Armature resistance in pu";
  parameter Types.PerUnit LdPu "Direct axis stator leakage in pu";
  parameter Types.PerUnit MdPu "Direct axis mutual inductance in pu";
  parameter Types.PerUnit LDPu "Direct axis damper leakage in pu";
  parameter Types.PerUnit RDPu "Direct axis damper resistance in pu";
  parameter Types.PerUnit MrcPu "Canay's mutual inductance in pu";
  parameter Types.PerUnit LfPu "Excitation winding leakage in pu";
  parameter Types.PerUnit RfPu "Excitation windings resistance in pu";
  parameter Types.PerUnit LqPu "Quadrature axis stator leakage in pu";
  parameter Types.PerUnit MqPu "Quadrature axis mutual inductance in pu";
  parameter Types.PerUnit LQ1Pu "Quadrature axis 1st damper leakage in pu";
  parameter Types.PerUnit RQ1Pu "Quadrature axis 1st damper resistance in pu";
  parameter Types.PerUnit LQ2Pu "Quadrature axis 2nd damper leakage in pu";
  parameter Types.PerUnit RQ2Pu "Quadrature axis 2nd damper resistance in pu";
  parameter Types.PerUnit MdPuEfd "Direct axis mutual inductance used to determine the excitation voltage in pu";

equation
  // Variables related to the magnetic saturation and rotor position
  (Theta0, Ud0Pu, Uq0Pu, Id0Pu, Iq0Pu, LambdaAD0Pu, LambdaAQ0Pu, LambdaAirGap0Pu, MdSat0PPu, MqSat0PPu) = RotorPositionEstimationKundur(u0Pu, i0Pu, MdPu, MqPu, LdPu, LqPu, RaPu, rTfoPu, RTfoPu, XTfoPu, SNom, ASat, BSat, lambdaT1);

  MdPPuEfdNom = MdPPuEfdNomCalculationKundur(PNomAlt, MdPu, MqPu, LdPu, LqPu, RaPu, rTfoPu, RTfoPu, XTfoPu, SNom, ASat, BSat, lambdaT1);

  MdPPuEfd = MdPuEfd  * rTfoPu * rTfoPu;

  if ExcitationPu == ExcitationPuType.Kundur then
    Kuf = 1;
  elseif ExcitationPu == ExcitationPuType.UserBase then
    assert(MdPuEfd <> 0, "Direct axis mutual inductance should be different from 0");
    Kuf = RfPPu / MdPPuEfd;
  elseif ExcitationPu == ExcitationPuType.NoLoad then
    Kuf = RfPPu / MdPPu;
  elseif ExcitationPu == ExcitationPuType.NoLoadSaturated then
    Kuf = RfPPu * (1 + md) / MdPPu;
  else
    Kuf = RfPPu / MdPPuEfdNom;
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

  annotation(preferredView = "text");
end BaseGeneratorSynchronousIntKundur_INIT;
