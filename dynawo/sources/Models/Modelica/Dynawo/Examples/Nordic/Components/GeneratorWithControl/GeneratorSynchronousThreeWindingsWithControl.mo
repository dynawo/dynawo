within Dynawo.Examples.Nordic.Components.GeneratorWithControl;

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

model GeneratorSynchronousThreeWindingsWithControl "Model of synchronous generator with three windings, a governor and a voltage regulator, for the Nordic 32 test system"
  extends Dynawo.AdditionalIcons.Machine;

  parameter GeneratorWithControl.GeneratorParameters.genFramePreset gen "Generator preset for choosing parameters and values";

  //Terminal
  Dynawo.Connectors.ACPower terminal "Connector used to connect the generator to the grid" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  replaceable Dynawo.Examples.BaseClasses.InitializedGeneratorSynchronousThreeWindings generatorSynchronous(DPu = 0, ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NoLoad, H = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.H], P0Pu = P0Pu, PNomAlt = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.PNom], PNomTurb = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.PNom], Q0Pu = Q0Pu, RTfPu = 0, RaPu = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.RaPu], SNom = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.SNom], SnTfo = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.SNom], Tpd0 = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.Tpd0], Tppd0 = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.Tppd0], Tppq0 = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.Tppq0], Tpq0 = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.Tpq0], U0Pu = U0Pu, UBaseHV = 15, UBaseLV = 15, UNom = 15, UNomHV = 15, UNomLV = 15, UPhase0 = UPhase0, XTfPu = 0, XdPu = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.XdPu], XlPu = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.XlPu], XpdPu = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.XpdPu], XppdPu = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.XppdPu], XppqPu = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.XppqPu], XpqPu = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.XpqPu], XqPu = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.XqPu], md = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.md], mq = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.mq], nd = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.nd], nq = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.nq], MdPuEfd = 0, UseApproximation = true) annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-40, -40}, {40, 40}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified.VRNordic vrNordic(Efd0Pu(fixed = false), Ir0Pu(fixed = false), Us0Pu(fixed = false), KTgr = GeneratorParameters.vrParamValues[gen, GeneratorParameters.vrParams.KTgr], IrLimPu = GeneratorParameters.vrParamValues[gen, GeneratorParameters.vrParams.IrLimPu], KPss = GeneratorParameters.vrParamValues[gen, GeneratorParameters.vrParams.KPss], tOelMin = GeneratorParameters.vrParamValues[gen, GeneratorParameters.vrParams.tOelMin], EfdMaxPu = GeneratorParameters.vrParamValues[gen, GeneratorParameters.vrParams.EfdMaxPu], tLeadPss = GeneratorParameters.vrParamValues[gen, GeneratorParameters.vrParams.tLeadPss], tLagPss = GeneratorParameters.vrParamValues[gen, GeneratorParameters.vrParams.tLagPss], tLeadTgr = GeneratorParameters.vrParamValues[gen, GeneratorParameters.vrParams.tLeadTgr], tLagTgr = GeneratorParameters.vrParamValues[gen, GeneratorParameters.vrParams.tLagTgr], tDerOmega = GeneratorParameters.vrParamValues[gen, GeneratorParameters.vrParams.tDerOmega], OelMode = GeneratorParameters.vrParamValues[gen, GeneratorParameters.vrParams.OelMode]) annotation(
    Placement(visible = true, transformation(origin = {-20, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.Governors.Simplified.GoverNordic goverNordic(PGen0Pu(fixed = false), Pm0Pu(fixed = false), KSigma = GeneratorParameters.govParamValues[gen,GeneratorParameters.govParams.KSigma], Ki = GeneratorParameters.govParamValues[gen,GeneratorParameters.govParams.Ki], Kp = GeneratorParameters.govParamValues[gen,GeneratorParameters.govParams.Kp], PNom = GeneratorParameters.govParamValues[gen,GeneratorParameters.govParams.PNom]) annotation(
    Placement(visible = true, transformation(origin = {-20, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle in rad";

initial algorithm
  vrNordic.Efd0Pu := generatorSynchronous.Efd0Pu;
  vrNordic.Ir0Pu := generatorSynchronous.IRotor0Pu;
  vrNordic.Us0Pu := generatorSynchronous.UStator0Pu;
  goverNordic.PGen0Pu := -generatorSynchronous.P0Pu;
  goverNordic.Pm0Pu := generatorSynchronous.Pm0Pu;

equation
  generatorSynchronous.switchOffSignal1.value = false;
  generatorSynchronous.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal3.value = false;
  generatorSynchronous.efdPu = vrNordic.efdPu;
  generatorSynchronous.IRotorPu = vrNordic.IrPu;
  generatorSynchronous.omegaPu = vrNordic.omegaPu;
  generatorSynchronous.UStatorPu = vrNordic.UsPu;
  generatorSynchronous.omegaPu = goverNordic.omegaPu;
  generatorSynchronous.PGenPu = goverNordic.PGenPu;
  generatorSynchronous.PmPu = goverNordic.PmPu;

  connect(generatorSynchronous.terminal, terminal);

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>The controlled generator frame functions as the regulated synchronous generator of the Nordic 32 test system.<div>It consists of a 3 windings initialized synchronous generator, which models hydro-power plants. The regulating elements comprise automatic voltage regulation (AVR), exciter (EXC), overexcitation limitation (OEL), power system stabilizer (PSS) and speed control by a governor (GOV).</div><div>Parameters are automatically chosen according to a preset defined in the GeneratorParameters. Then, only initial values need to be supplied.</div><div>To add another configuration, append a new line to \"genFrameParamValues\", \"govParamValues\" and \"vrParamValues\"&nbsp;in GeneratorParameters and append a fitting name in the \"genFramePreset\" enumeration.</div>
</body></html>"),
    Icon(graphics = {Rectangle(lineThickness = 0.75, extent = {{-100, 100}, {100, -100}})}));
end GeneratorSynchronousThreeWindingsWithControl;
