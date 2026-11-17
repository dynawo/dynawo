within Dynawo.Examples.BaseClasses;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
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

model InitializedGeneratorSynchronous "Synchronous generator with built-in initialization"
  extends Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronous(
    Ce0Pu(fixed = false),
    Cm0Pu(fixed = false),
    Cos2Eta0(fixed = false),
    Efd0Pu(fixed = false),
    IRotor0Pu(fixed = false),
    IStator0Pu(fixed = false),
    Id0Pu(fixed = false),
    If0Pu(fixed = false),
    Iq0Pu(fixed = false),
    LambdaAD0Pu(fixed = false),
    LambdaAQ0Pu(fixed = false),
    LambdaAirGap0Pu(fixed = false),
    LambdaD0Pu(fixed = false),
    LambdaQ10Pu(fixed = false),
    LambdaQ20Pu(fixed = false),
    Lambdad0Pu(fixed = false),
    Lambdaf0Pu(fixed = false),
    Lambdaq0Pu(fixed = false),
    MdPPuEfdNom(fixed = false),
    MdSat0PPu(fixed = false),
    Mds0Pu(fixed = false),
    Mi0Pu(fixed = false),
    MqSat0PPu(fixed = false),
    Mqs0Pu(fixed = false),
    PGen0Pu(fixed = false),
    Pm0Pu(fixed = false),
    QGen0Pu(fixed = false),
    QStator0Pu(fixed = false),
    QStator0PuQNom(fixed = false),
    Sin2Eta0(fixed = false),
    Theta0(fixed = false),
    ThetaInternal0(fixed = false),
    UStator0Pu(fixed = false),
    Ud0Pu(fixed = false),
    Uf0Pu(fixed = false),
    Uq0Pu(fixed = false),
    i0Pu(re(fixed = false), im(fixed = false)),
    iStator0Pu(re(fixed = false), im(fixed = false)),
    s0Pu(re(fixed = false), im(fixed = false)),
    sStator0Pu(re(fixed = false), im(fixed = false)),
    u0Pu(re(fixed = false), im(fixed = false)),
    uStator0Pu(re(fixed = false), im(fixed = false)));

  // Initialization
  Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronousInt_INIT generatorSynchronousInt_INIT(
    DPu = DPu,
    ExcitationPu = ExcitationPu,
    H = H,
    LDPu = LDPPu,
    LQ1Pu = LQ1PPu,
    LQ2Pu = LQ2PPu,
    LdPu = LdPPu,
    LfPu = LfPPu,
    LqPu = LqPPu,
    MdPu = MdPPu,
    MdPuEfd = MdPPuEfd,
    MqPu = MqPPu,
    MrcPu = MrcPPu,
    P0Pu = P0Pu,
    PNomAlt = PNomAlt,
    PNomTurb = PNomTurb,
    Q0Pu = Q0Pu,
    RDPu = RDPPu,
    RQ1Pu = RQ1PPu,
    RQ2Pu = RQ2PPu,
    RTfPu = RTfPu,
    RaPu = RaPPu,
    RfPu = RfPPu,
    SNom = SNom,
    SnTfo = SnTfo,
    U0Pu = U0Pu,
    UBaseHV = UBaseHV,
    UBaseLV = UBaseLV,
    UNom = UNom,
    UNomHV = UNomHV,
    UNomLV = UNomLV,
    UPhase0 = UPhase0,
    XTfPu = XTfPu,
    md = md,
    mq = mq,
    nd = nd,
    nq = nq);

initial algorithm
  Ce0Pu := generatorSynchronousInt_INIT.Ce0Pu;
  Cm0Pu := generatorSynchronousInt_INIT.Cm0Pu;
  Cos2Eta0 := generatorSynchronousInt_INIT.Cos2Eta0;
  Efd0Pu := generatorSynchronousInt_INIT.Efd0Pu;
  IRotor0Pu := generatorSynchronousInt_INIT.IRotor0Pu;
  IStator0Pu := generatorSynchronousInt_INIT.IStator0Pu;
  Id0Pu := generatorSynchronousInt_INIT.Id0Pu;
  If0Pu := generatorSynchronousInt_INIT.If0Pu;
  Iq0Pu := generatorSynchronousInt_INIT.Iq0Pu;
  LambdaAD0Pu := generatorSynchronousInt_INIT.LambdaAD0Pu;
  LambdaAQ0Pu := generatorSynchronousInt_INIT.LambdaAQ0Pu;
  LambdaAirGap0Pu := generatorSynchronousInt_INIT.LambdaAirGap0Pu;
  LambdaD0Pu := generatorSynchronousInt_INIT.LambdaD0Pu;
  LambdaQ10Pu := generatorSynchronousInt_INIT.LambdaQ10Pu;
  LambdaQ20Pu := generatorSynchronousInt_INIT.LambdaQ20Pu;
  Lambdad0Pu := generatorSynchronousInt_INIT.Lambdad0Pu;
  Lambdaf0Pu := generatorSynchronousInt_INIT.Lambdaf0Pu;
  Lambdaq0Pu := generatorSynchronousInt_INIT.Lambdaq0Pu;
  MdPPuEfdNom := generatorSynchronousInt_INIT.MdPPuEfdNom;
  MdSat0PPu := generatorSynchronousInt_INIT.MdSat0PPu;
  Mds0Pu := generatorSynchronousInt_INIT.Mds0Pu;
  Mi0Pu := generatorSynchronousInt_INIT.Mi0Pu;
  MqSat0PPu := generatorSynchronousInt_INIT.MqSat0PPu;
  Mqs0Pu := generatorSynchronousInt_INIT.Mqs0Pu;
  PGen0Pu := generatorSynchronousInt_INIT.PGen0Pu;
  Pm0Pu := generatorSynchronousInt_INIT.Pm0Pu;
  QGen0Pu := generatorSynchronousInt_INIT.QGen0Pu;
  QStator0Pu := generatorSynchronousInt_INIT.QStator0Pu;
  QStator0PuQNom := generatorSynchronousInt_INIT.QStator0PuQNom;
  Sin2Eta0 := generatorSynchronousInt_INIT.Sin2Eta0;
  Theta0 := generatorSynchronousInt_INIT.Theta0;
  ThetaInternal0 := generatorSynchronousInt_INIT.ThetaInternal0;
  UStator0Pu := generatorSynchronousInt_INIT.UStator0Pu;
  Ud0Pu := generatorSynchronousInt_INIT.Ud0Pu;
  Uf0Pu := generatorSynchronousInt_INIT.Uf0Pu;
  Uq0Pu := generatorSynchronousInt_INIT.Uq0Pu;
  i0Pu.re := generatorSynchronousInt_INIT.i0Pu.re;
  i0Pu.im := generatorSynchronousInt_INIT.i0Pu.im;
  iStator0Pu.re := generatorSynchronousInt_INIT.iStator0Pu.re;
  iStator0Pu.im := generatorSynchronousInt_INIT.iStator0Pu.im;
  s0Pu.re := generatorSynchronousInt_INIT.s0Pu.re;
  s0Pu.im := generatorSynchronousInt_INIT.s0Pu.im;
  sStator0Pu.re := generatorSynchronousInt_INIT.sStator0Pu.re;
  sStator0Pu.im := generatorSynchronousInt_INIT.sStator0Pu.im;
  u0Pu.re := generatorSynchronousInt_INIT.u0Pu.re;
  u0Pu.im := generatorSynchronousInt_INIT.u0Pu.im;
  uStator0Pu.re := generatorSynchronousInt_INIT.uStator0Pu.re;
  uStator0Pu.im := generatorSynchronousInt_INIT.uStator0Pu.im;

  annotation(preferredView = "text");
end InitializedGeneratorSynchronous;
