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
  import Modelica;
  import Dynawo;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Types;

  extends Dynawo.AdditionalIcons.Machine;

  parameter Dynawo.Examples.Nordic.Data.GeneratorParameters.genFramePreset gen "Generator preset for choosing parameters and values";

  //Terminal
  Dynawo.Connectors.ACPower terminal "Connector used to connect the generator to the grid" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  replaceable Dynawo.Examples.Nordic.Components.GeneratorWithControl.BaseClasses.InitializedGeneratorSynchronousThreeWindings generatorSynchronous(DPu = 0, ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NominalStatorVoltageNoLoad, H = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.H], P0Pu = P0Pu, PNomAlt = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.PNom], PNomTurb = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.PNom], Q0Pu = Q0Pu, RTfPu = 0, RaPu = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.RaPu], SNom = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.SNom], SnTfo = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.SNom], Tpd0 = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.Tpd0], Tppd0 = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.Tppd0], Tppq0 = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.Tppq0], Tpq0 = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.Tpq0], U0Pu = U0Pu, UBaseHV = 15, UBaseLV = 15, UNom = 15, UNomHV = 15, UNomLV = 15, UPhase0 = UPhase0, XTfPu = 0, XdPu = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.XdPu], XlPu = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.XlPu], XpdPu = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.XpdPu], XppdPu = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.XppdPu], XppqPu = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.XppqPu], XpqPu = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.XpqPu], XqPu = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.XqPu], md = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.md], mq = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.mq], nd = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.nd], nq = GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.nq]) annotation(
    Placement(visible = true, transformation(origin = {60, 0}, extent = {{-40, -40}, {40, 40}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified.VRNordic vrNordic(KTgr = GeneratorParameters.vrParamValues[gen, GeneratorParameters.vrParams.KTgr], IfLimPu = GeneratorParameters.vrParamValues[gen, GeneratorParameters.vrParams.IfLimPu], KPss = GeneratorParameters.vrParamValues[gen, GeneratorParameters.vrParams.KPss], tOelMin = GeneratorParameters.vrParamValues[gen, GeneratorParameters.vrParams.tOelMin], EfdMaxPu = GeneratorParameters.vrParamValues[gen, GeneratorParameters.vrParams.EfdMaxPu], tLeadPss = GeneratorParameters.vrParamValues[gen, GeneratorParameters.vrParams.tLeadPss], tLagPss = GeneratorParameters.vrParamValues[gen, GeneratorParameters.vrParams.tLagPss], tLeadTgr = GeneratorParameters.vrParamValues[gen, GeneratorParameters.vrParams.tLeadTgr], tLagTgr = GeneratorParameters.vrParamValues[gen, GeneratorParameters.vrParams.tLagTgr], tDerOmega = GeneratorParameters.vrParamValues[gen, GeneratorParameters.vrParams.tDerOmega], OelMode = GeneratorParameters.vrParamValues[gen, GeneratorParameters.vrParams.OelMode]) annotation(
    Placement(visible = true, transformation(origin = {-20, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.Governors.Simplified.GoverNordic goverNordic(KSigma = GeneratorParameters.govParamValues[gen,GeneratorParameters.govParams.KSigma], Ki = GeneratorParameters.govParamValues[gen,GeneratorParameters.govParams.Ki], Kp = GeneratorParameters.govParamValues[gen,GeneratorParameters.govParams.Kp]) annotation(
    Placement(visible = true, transformation(origin = {-20, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  // Different bases for PGenPu, ifPu and efdPu
  Modelica.Blocks.Math.Gain BaseChangeSnRef2PNom(k = SystemBase.SnRef / PNom_BaseChange) annotation(
    Placement(visible = true, transformation(origin = {-70, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain Reciprocal2NonReciprocalPUSystem(k = generatorSynchronous.MdPPu) annotation(
    Placement(visible = true, transformation(origin = {-70, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  parameter Types.ActivePower PNom_BaseChange = if not GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.PNom] == 0 then GeneratorParameters.genParamValues[gen, GeneratorParameters.genParams.PNom] else 1;
  parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle in rad";

initial algorithm
  goverNordic.Pm0Pu := generatorSynchronous.Pm0Pu;
  vrNordic.Efd0Pu := generatorSynchronous.Efd0Pu;
  vrNordic.UStator0Pu := generatorSynchronous.UStator0Pu;
  vrNordic.If0Pu := generatorSynchronous.If0Pu;

equation
  generatorSynchronous.switchOffSignal1.value = false;
  generatorSynchronous.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal3.value = false;
  generatorSynchronous.ifPu = Reciprocal2NonReciprocalPUSystem.u;
  generatorSynchronous.UStatorPu.value = vrNordic.UStatorPu;
  generatorSynchronous.omegaPu.value = vrNordic.omegaPu;
  generatorSynchronous.efdPu.value = vrNordic.efdPu;
  generatorSynchronous.omegaPu.value = goverNordic.omegaPu;
  generatorSynchronous.PGenPu = BaseChangeSnRef2PNom.u;

  connect(generatorSynchronous.terminal, terminal);
  connect(generatorSynchronous.PmPu, goverNordic.PmPuPin);
  connect(BaseChangeSnRef2PNom.y, goverNordic.PGenPuPNom) annotation(
    Line(points = {{-59, -52}, {-44, -52}}, color = {0, 0, 127}));
  connect(Reciprocal2NonReciprocalPUSystem.y, vrNordic.ifPu) annotation(
    Line(points = {{-58, 72}, {-44, 72}}, color = {0, 0, 127}));

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The controlled generator frame functions as the regulated synchronous generator of the Nordic 32 test system.<div>It consists of a 3 windings initialized synchronous generator, which models hydro-power plants. The regulating elements comprise automatic voltage regulation (AVR), exciter (EXC), overexcitation limitation (OEL), power system stabilizer (PSS) and speed control by a governor (GOV).</div><div>Parameters are automatically chosen according to a preset defined in the GeneratorParameters. Then, only initial values need to be supplied.</div><div>To add another configuration, append a new line to \"genFrameParamValues\", \"govParamValues\" and \"vrParamValues\"&nbsp;in GeneratorParameters and append a fitting name in the \"genFramePreset\" enumeration.</div>
</body></html>"),
    Icon(graphics = {Rectangle(lineThickness = 0.75, extent = {{-100, 100}, {100, -100}})}));
end GeneratorSynchronousThreeWindingsWithControl;
