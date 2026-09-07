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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

partial model BaseGeneratorSynchronousExt_INIT "Base initialization model for synchronous machine from external parameters"
  extends BaseGeneratorSynchronous_INIT;

  parameter Boolean UseApproximation "True if an approximate formula is used for the calculation of the internal parameters";

  // External parameters of the synchronous machine given as parameters in pu (base UNom, SNom)
  parameter Types.PerUnit RaPu "Armature resistance in pu";
  parameter Types.PerUnit XlPu "Stator leakage in pu";
  parameter Types.PerUnit XdPu "Direct axis reactance in pu";
  parameter Types.PerUnit XpdPu "Direct axis transient reactance in pu";
  parameter Types.PerUnit XppdPu "Direct axis sub-transient reactance pu";
  parameter Types.Time Tpd0 "Direct axis, open circuit transient time constant";
  parameter Types.Time Tppd0 "Direct axis, open circuit sub-transient time constant";
  parameter Types.PerUnit XqPu "Quadrature axis reactance in pu";
  parameter Types.PerUnit MdPuEfd "Direct axis mutual inductance used to determine the excitation voltage in pu";

  // Internal parameters to be calculated from the external ones in pu (base UNom, SNom)
  final parameter Types.PerUnit LdPu = XlPu "Direct axis stator leakage in pu";
  final parameter Types.PerUnit MdPu = XdPu - XlPu "Direct axis mutual inductance in pu";
  final parameter Types.PerUnit LqPu = XlPu "Quadrature axis stator leakage in pu";
  final parameter Types.PerUnit MqPu = XqPu - XlPu "Quadrature axis mutual inductance in pu";
  Types.PerUnit LDPu "Direct axis damper leakage in pu";
  Types.PerUnit RDPu "Direct axis damper resistance in pu";
  Types.PerUnit MrcPu "Canay's mutual inductance in pu";
  Types.PerUnit LfPu "Excitation winding leakage in pu";
  Types.PerUnit RfPu "Excitation winding resistance in pu";
  Types.PerUnit LQ1Pu "Quadrature axis 1st damper leakage in pu";
  Types.PerUnit RQ1Pu "Quadrature axis 1st damper resistance in pu";
  Types.PerUnit LQ2Pu "Quadrature axis 2nd damper leakage in pu";
  Types.PerUnit RQ2Pu "Quadrature axis 2nd damper resistance in pu";

  // Auxiliary parameters: direct axis (see Kundur implementation, p143)
  Types.Time Tpd;
  Types.Time Tppd;
  Types.PerUnit T1dPu;
  Types.PerUnit T3dPu;
  Types.PerUnit T4dPu;
  Types.PerUnit T6dPu;

  // Auxiliary parameters: quadrature axis (see Kundur implementation, p143)
  // see subclasses

  // Auxiliary parameters for precise calculation of internal parameters
  Real xd, B1d, B2d, C1d, C2d, Pd, Qd, Bd, RADd, V1d, V2d, U1d, U2d, Z1d, Z2d, E1d, E2d, Ed, Fd, Vd, Ud, Rf1, Rf2, RfPuApprox, RfPuPrecise, LfPuApprox, LfPuPrecise, RDPuPrecise, LDPuPrecise;

equation
  // Variables related to the magnetic saturation and rotor position
  (MsalPu, Theta0, Ud0Pu, Uq0Pu, Id0Pu, Iq0Pu, LambdaAD0Pu, LambdaAQ0Pu, LambdaAirGap0Pu, Mds0Pu, Mqs0Pu, Cos2Eta0, Sin2Eta0, Mi0Pu, MdSat0PPu, MqSat0PPu) = RotorPositionEstimation(u0Pu, i0Pu, MdPu, MqPu, LdPu, LqPu, RaPu, rTfoPu, RTfoPu, XTfoPu, SNom, md, mq, nd, nq);

  MdPPuEfdNom = MdPPuEfdNomCalculation(PNomAlt, MdPu, MqPu, LdPu, LqPu, RaPu, rTfoPu, RTfoPu, XTfoPu, SNom, md, mq, nd, nq);

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

  MrcPu = 0;

  Tpd = Tpd0 * XpdPu / XdPu;
  Tppd = Tppd0 * XppdPu / XpdPu;

  T1dPu = Tpd0  * SystemBase.omegaNom;
  T3dPu = Tppd0 * SystemBase.omegaNom;
  T4dPu = Tpd   * SystemBase.omegaNom;
  T6dPu = Tppd  * SystemBase.omegaNom;

  // Precise calculation of direct axis
  B1d = T1dPu + T3dPu;
  B2d = T4dPu + T6dPu;
  C1d = T1dPu * T3dPu;
  C2d = T4dPu * T6dPu;
  xd = MdPu * LdPu / XdPu;
  Pd = (B1d / MdPu) - (B2d / xd);
  Qd = (1 / xd) - (1 / MdPu);
  Bd = C2d - C1d * LdPu / XdPu;
  RADd = sqrt(1 - 4 * Bd * LdPu * Qd * Qd / (xd * Pd * Pd));
  V1d = - 0.5 * Pd * (1 + RADd) / Qd;
  V2d = - 0.5 * Pd * (1 - RADd) / Qd;
  U1d = Bd * LdPu / (xd * V1d);
  U2d = Bd * LdPu / (xd * V2d);
  Z1d = Bd * LdPu + MdPu * (B2d + Pd / Qd) * V1d;
  Z2d = Bd * LdPu + MdPu * (B2d + Pd / Qd) * V2d;
  E1d = (C1d - Z1d / xd) / ((U1d - V1d) * MdPu);
  E2d = (C1d - Z2d / xd) / ((U2d - V2d) * MdPu);
  Rf1 = 1 / E1d;
  Rf2 = 1 / E2d;
  LfPuApprox = (Tpd * MdPu - Tpd0 * xd) / (Tpd0 - Tpd);
  RfPuApprox = (MdPu + LfPuApprox) / T1dPu;
  RfPuPrecise = if abs(Rf1 - RfPuApprox) < abs(Rf2 - RfPuApprox) then Rf1 else Rf2;
  Ed = if abs(Rf1 - RfPuApprox) < abs(Rf2 - RfPuApprox) then E1d else E2d;
  Vd = if abs(Rf1 - RfPuApprox) < abs(Rf2 - RfPuApprox) then V1d else V2d;
  Ud = if abs(Rf1 - RfPuApprox) < abs(Rf2 - RfPuApprox) then U1d else U2d;
  Fd = (B2d + Pd / Qd) / xd - Ed;
  RDPuPrecise = 1 / Fd;
  LDPuPrecise = Ud * RDPuPrecise;
  LfPuPrecise = Vd * RfPuPrecise;

  // Calculation of direct axis
  if UseApproximation then
    RfPu * T1dPu = MdPu + LfPu;
    RDPu * T3dPu = LDPu + MdPu * LfPu / (MdPu + LfPu);
    LDPu * (MdPu + LfPu) * (T3dPu - T6dPu) = MdPu * LfPu * (T6dPu - T3dPu * (MdPu + LfPu) * LdPu / (MdPu * LdPu + MdPu * LfPu + LdPu * LfPu));
    LfPu * (MdPu + LdPu) * (T1dPu - T4dPu) = MdPu * ((MdPu + LdPu) * T4dPu - LdPu * T1dPu);
  else
    RfPu = RfPuPrecise;
    RDPu = RDPuPrecise;
    LDPu = LDPuPrecise;
    LfPu = LfPuPrecise;
  end if;

  annotation(preferredView = "text");
end BaseGeneratorSynchronousExt_INIT;
