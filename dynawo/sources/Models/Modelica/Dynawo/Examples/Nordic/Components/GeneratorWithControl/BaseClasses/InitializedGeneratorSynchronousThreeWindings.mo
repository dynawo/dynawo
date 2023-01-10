within Dynawo.Examples.Nordic.Components.GeneratorWithControl.BaseClasses;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
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

model InitializedGeneratorSynchronousThreeWindings "Model of synchronous generator with three windings and built-in initialization, for the Nordic 32 test system"
  import Dynawo.Electrical.Machines;
  import Dynawo.Types;

  extends Machines.OmegaRef.GeneratorSynchronous(RaPPu(fixed=false), LdPPu(fixed=false), MdPPu(fixed=false), LDPPu(fixed=false), RDPPu(fixed=false), MrcPPu(fixed=false), LfPPu(fixed=false), RfPPu(fixed=false), LqPPu(fixed=false), MqPPu(fixed=false), LQ1PPu(fixed=false), RQ1PPu(fixed=false), LQ2PPu(fixed=false), RQ2PPu(fixed=false), MsalPu(fixed=false), MdPPuEfd(fixed=false), PGen0Pu(fixed=false), QGen0Pu(fixed=false), Theta0(fixed=false), Ud0Pu(fixed=false), Uq0Pu(fixed=false), Id0Pu(fixed=false), Iq0Pu(fixed=false), If0Pu(fixed=false), Uf0Pu(fixed=false), Efd0Pu(fixed=false), Lambdad0Pu(fixed=false), Lambdaq0Pu(fixed=false), LambdaD0Pu(fixed=false), Lambdaf0Pu(fixed=false), LambdaQ20Pu(fixed=false), LambdaQ10Pu(fixed=false), Ce0Pu(fixed=false), Cm0Pu(fixed=false), Pm0Pu(fixed=false), MdSat0PPu(fixed=false), MqSat0PPu(fixed=false), LambdaAirGap0Pu(fixed=false), LambdaAQ0Pu(fixed=false), LambdaAD0Pu(fixed=false), Mds0Pu(fixed=false), Mqs0Pu(fixed=false), Cos2Eta0(fixed=false), Sin2Eta0(fixed=false), Mi0Pu(fixed=false), ThetaInternal0(fixed=false), IRotor0Pu(fixed=false), QStator0PuQNom(fixed=false), QStator0Pu(fixed=false), IStator0Pu(fixed=false), UStator0Pu(fixed=false), u0Pu.re(fixed=false), u0Pu.im(fixed=false), i0Pu.re(fixed=false), i0Pu.im(fixed=false), s0Pu.re(fixed=false), s0Pu.im(fixed=false), iStator0Pu.re(fixed=false), iStator0Pu.im(fixed=false), uStator0Pu.re(fixed=false), uStator0Pu.im(fixed=false), sStator0Pu.re(fixed=false), sStator0Pu.im(fixed=false));

  parameter Types.PerUnit RaPu "Armature resistance in pu (base SNom, UNom)";
  parameter Types.PerUnit XlPu "Stator leakage in pu (base SNom, UNom)";
  parameter Types.PerUnit XdPu "Direct axis reactance in pu (base SNom, UNom)";
  parameter Types.PerUnit XpdPu "Direct axis transient reactance in pu (base SNom, UNom)";
  parameter Types.PerUnit XppdPu "Direct axis sub-transient reactance in pu (base SNom, UNom)";
  parameter Types.PerUnit XqPu "Quadrature axis reactance in pu (base SNom, UNom)";
  parameter Types.PerUnit XpqPu "Quadrature axis transient reactance in pu (base SNom, UNom)";
  parameter Types.PerUnit XppqPu "Quadrature axis sub-transient reactance in pu (base SNom, UNom)";
  parameter Types.Time Tpd0 "Direct axis, open circuit transient time constant in s";
  parameter Types.Time Tppd0 "Direct axis, open circuit sub-transient time constant in s";
  parameter Types.Time Tpq0 "Open circuit quadrature axis transient time constant in s";
  parameter Types.Time Tppq0 "Open circuit quadrature axis sub-transient time constant in s";

  Machines.OmegaRef.GeneratorSynchronousExt_3E_INIT gen_init3(U0Pu = U0Pu, UPhase0 = UPhase0, P0Pu = P0Pu, Q0Pu = Q0Pu, UNom = UNom, SNom = SNom, H = H, DPu = DPu, PNomTurb = PNomTurb, PNomAlt = PNomAlt, ExcitationPu = ExcitationPu, SnTfo = SnTfo, UNomHV = UNomHV, UNomLV = UNomLV, UBaseHV = UBaseHV, UBaseLV = UBaseLV, RTfPu = RTfPu, XTfPu = XTfPu, md = md, mq = mq, nd = nd, nq = nq, RaPu = RaPu, XlPu = XlPu, XdPu = XdPu, XpdPu = XpdPu, XppdPu = XppdPu, XqPu = XqPu, XppqPu = XppqPu, Tpd0 = Tpd0, Tppd0 = Tppd0, Tppq0 = Tppq0) ;

initial algorithm
  // Generator init values
  PGen0Pu := gen_init3.PGen0Pu;
  QGen0Pu := gen_init3.QGen0Pu;
  u0Pu := gen_init3.u0Pu;
  i0Pu := gen_init3.i0Pu;
  s0Pu := gen_init3.s0Pu;
  uStator0Pu := gen_init3.uStator0Pu;
  iStator0Pu := gen_init3.uStator0Pu;
  sStator0Pu := gen_init3.sStator0Pu;
  // dq0
  Theta0 := gen_init3.Theta0;
  Ud0Pu := gen_init3.Ud0Pu;
  Uq0Pu := gen_init3.Uq0Pu;
  Id0Pu := gen_init3.Id0Pu;
  Iq0Pu := gen_init3.Iq0Pu;
  // Exciter & Flux values
  If0Pu := gen_init3.If0Pu;
  Uf0Pu := gen_init3.Uf0Pu;
  Efd0Pu := gen_init3.Efd0Pu;
  Lambdad0Pu := gen_init3.Lambdad0Pu;
  Lambdaq0Pu := gen_init3.Lambdaq0Pu;
  LambdaD0Pu := gen_init3.LambdaD0Pu;
  Lambdaf0Pu := gen_init3.Lambdaf0Pu;
  LambdaQ10Pu := gen_init3.LambdaQ10Pu;
  LambdaQ20Pu := gen_init3.LambdaQ20Pu;
  LambdaAirGap0Pu := gen_init3.LambdaAirGap0Pu;
  LambdaAD0Pu := gen_init3.LambdaAD0Pu;
  LambdaAQ0Pu := gen_init3.LambdaAQ0Pu;
  Cos2Eta0 := gen_init3.Cos2Eta0;
  Sin2Eta0 := gen_init3.Sin2Eta0;
  // saturated inductances
  MdSat0PPu := gen_init3.MdSat0PPu;
  MqSat0PPu := gen_init3.MqSat0PPu;
  Mds0Pu := gen_init3.Mds0Pu;
  Mqs0Pu := gen_init3.Mqs0Pu;
  Mi0Pu := gen_init3.Mi0Pu;
  // Torque & Power
  Ce0Pu := gen_init3.Ce0Pu;
  Cm0Pu := gen_init3.Cm0Pu;
  Pm0Pu := gen_init3.Pm0Pu;
  // Stator init values
  UStator0Pu := gen_init3.UStator0Pu;
  IStator0Pu := gen_init3.IStator0Pu;
  QStator0Pu := gen_init3.QStator0Pu;
  QStator0PuQNom := gen_init3.QStator0PuQNom;
  IRotor0Pu := gen_init3.IRotor0Pu;
  ThetaInternal0 := gen_init3.ThetaInternal0;
  // OP Params
  RaPPu := gen_init3.RaPPu;
  LdPPu := gen_init3.LdPPu;
  MdPPu := gen_init3.MdPPu;
  LDPPu := gen_init3.LDPPu;
  RDPPu := gen_init3.RDPPu;
  MrcPPu := gen_init3.MrcPPu;
  LfPPu := gen_init3.LfPPu;
  RfPPu := gen_init3.RfPPu;
  LqPPu := gen_init3.LqPPu;
  MqPPu := gen_init3.MqPPu;
  LQ1PPu := gen_init3.LQ1PPu;
  RQ1PPu := gen_init3.RQ1PPu;
  LQ2PPu := gen_init3.LQ2PPu;
  RQ2PPu := gen_init3.RQ2PPu;
  MsalPu := gen_init3.MsalPu;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>This model implements a three windings synchronous generator which is automatically initialized by an initialization model.<div>The standard parameters are passed to the initialization model, which in turn calculates the necessary operational parameters. The calculated values are then assigned to the respective generator parameters in an initial algorithm section. This way, the generator has appropriate parameters before the simulation starts. The model can not use equations due to variability conflict (parameters and variables), therefore the assignment operator must be used. This is permissible, because the initial values do not change during simulation.</div></body></html>"));
end InitializedGeneratorSynchronousThreeWindings;
