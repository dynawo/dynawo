within Dynawo.Examples.RVS.Components.GeneratorWithControl;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SteamIEEET1Frame
  import Modelica;
  import Dynawo;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  import ieeeg1par = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1;
  import pss2bpar = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B;
  import ieeet1par = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEET1;
  import oelpar = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL;
  import genpar = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators;
  
  parameter ieeeg1par.genFramePreset ieeeg1Preset = ieeeg1par.genFramePreset.g10118;
  parameter pss2bpar.genFramePreset pss2bPreset = pss2bpar.genFramePreset.g10118;
  parameter ieeet1par.genFramePreset ieeet1Preset = ieeet1par.genFramePreset.g10118;
  parameter oelpar.oelFramePreset oelPreset = oelpar.oelFramePreset.all;
  parameter genpar.genFramePreset gen = genpar.genFramePreset.g10118;
  
  parameter Types.ActivePowerPu P0Pu;
  parameter Types.ReactivePowerPu Q0Pu;
  parameter Types.VoltageModulePu U0Pu;
  parameter Types.Angle UPhase0;
  parameter Types.VoltageModule UNom = 18;
  parameter Boolean AvrInService = true;
  parameter Boolean GovInService = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.hasGov] > 0;
  
  Dynawo.Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.GeneratorSynchronousThreeWindingsInterface generatorSynchronous(
      
    DPu = genpar.genParamValues[gen, genpar.genParamNames.DPu],
    ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NoLoad,  
    H = genpar.genParamValues[gen, genpar.genParamNames.H],P0Pu = P0Pu, 
    PNomAlt = genpar.genParamValues[gen, genpar.genParamNames.PNom], 
    PNomTurb = genpar.genParamValues[gen, genpar.genParamNames.PNom],
    Q0Pu = Q0Pu,
    RTfPu = 0, 
    RaPu = genpar.genParamValues[gen, genpar.genParamNames.RaPu], 
    SNom = genpar.genParamValues[gen, genpar.genParamNames.SNom], 
    SnTfo = genpar.genParamValues[gen, genpar.genParamNames.SNom], 
    Tpd0 = genpar.genParamValues[gen, genpar.genParamNames.Tpd0], 
    Tppd0 = genpar.genParamValues[gen, genpar.genParamNames.Tppd0], 
    Tppq0 = genpar.genParamValues[gen, genpar.genParamNames.Tppq0], 
    Tpq0 = genpar.genParamValues[gen, genpar.genParamNames.Tpq0], 
    U0Pu = U0Pu, 
    UBaseHV = UNom, 
    UBaseLV = UNom, 
    UNom = UNom, 
    UNomHV = UNom, 
    UNomLV = UNom,
    UPhase0 = UPhase0, 
    XTfPu = 0, 
    XdPu = genpar.genParamValues[gen, genpar.genParamNames.XdPu], 
    XlPu = genpar.genParamValues[gen, genpar.genParamNames.XlPu], 
    XpdPu = genpar.genParamValues[gen, genpar.genParamNames.XpdPu], 
    XppdPu = genpar.genParamValues[gen, genpar.genParamNames.XppdPu], 
    XppqPu = genpar.genParamValues[gen, genpar.genParamNames.XppqPu], 
    XpqPu = genpar.genParamValues[gen, genpar.genParamNames.XpqPu], 
    XqPu = genpar.genParamValues[gen, genpar.genParamNames.XqPu], 
    md = genpar.genParamValues[gen, genpar.genParamNames.md], 
    mq = genpar.genParamValues[gen, genpar.genParamNames.mq], 
    nd = genpar.genParamValues[gen, genpar.genParamNames.nd], 
    nq = genpar.genParamValues[gen, genpar.genParamNames.nq]
  ) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Governors.GovSteam1 ieeeg1(
    
    Db1 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.Db1],
    Db2 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.Db2],
    Eps = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.Eps],
    K = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.K],
    K1 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.K1],
    K2 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.K2],
    K3 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.K3],
    K4 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.K4],
    K5 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.K5],
    K6 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.K6],
    K7 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.K7],
    K8 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.K8],
    PMaxPu = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.PMax],
    PMinPu = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.PMin], 
    PNomTurb = genpar.genParamValues[gen, genpar.genParamNames.PNom], PgvTableName = "dummyTable",
    Pm0Pu = generatorSynchronous.Pm0Pu,
    PmRef0Pu(fixed=false), SNom = genpar.genParamValues[gen, genpar.genParamNames.SNom],
    Sdb1 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.Sdb1] > 0,
    Sdb2 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.Sdb2] > 0, TablesFile = "C:\\Users\\slohr\\Desktop\\workspace\\Dynawo-save230409\\dummyTable.txt", 
    Uc = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.Uc],
    Uo = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.Uo],
    ValveOn = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.ValveOn] > 0,
    t1 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.T1],
    t2 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.T2],
    t3 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.T3],
    t4 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.T4],
    t5 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.T5],
    t6 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.T6],
    t7 = ieeeg1par.exciterParams[ieeeg1Preset, ieeeg1par.exciterParamNames.T7]  
  ) annotation(
    Placement(visible = true, transformation(origin = {64.4, 0.666667}, extent = {{24.4, -20.3333}, {-24.4, 20.3333}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters.IEEET1 exc(
    Efd0Pu = generatorSynchronous.Efd0Pu,
    UStator0Pu = generatorSynchronous.UStator0Pu,
    URegMaxPu = ieeet1par.exciterParams[ieeet1Preset, ieeet1par.exciterParamNames.URegMaxPu],
    URegMinPu = ieeet1par.exciterParams[ieeet1Preset, ieeet1par.exciterParamNames.URegMinPu],
    Ta = ieeet1par.exciterParams[ieeet1Preset, ieeet1par.exciterParamNames.Ta],
    Te = ieeet1par.exciterParams[ieeet1Preset, ieeet1par.exciterParamNames.Te],
    Tf = ieeet1par.exciterParams[ieeet1Preset, ieeet1par.exciterParamNames.Tf],
    Tr = ieeet1par.exciterParams[ieeet1Preset, ieeet1par.exciterParamNames.Tr],
    Ka = ieeet1par.exciterParams[ieeet1Preset, ieeet1par.exciterParamNames.Ka],
    Ke = ieeet1par.exciterParams[ieeet1Preset, ieeet1par.exciterParamNames.Ke],
    Kf = ieeet1par.exciterParams[ieeet1Preset, ieeet1par.exciterParamNames.Kf],
    e1 = ieeet1par.exciterParams[ieeet1Preset, ieeet1par.exciterParamNames.e1],
    e2 = ieeet1par.exciterParams[ieeet1Preset, ieeet1par.exciterParamNames.e2],
    s1 = ieeet1par.exciterParams[ieeet1Preset, ieeet1par.exciterParamNames.s1],
    s2 = ieeet1par.exciterParams[ieeet1Preset, ieeet1par.exciterParamNames.s2]
  ) annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Controls.OEL.MAXEX2 maxex2(
    Xfd0Pu = generatorSynchronous.IRotor0Pu, 
    XfdRatedPu = genpar.genParamValues[gen, genpar.genParamNames.ifdRatedPu],
    Kmx = oelpar.oelParamValues[oelPreset, oelpar.oelParamNames.Kmx],
    ULowPu = oelpar.oelParamValues[oelPreset, oelpar.oelParamNames.ULowPu],
    T1 = oelpar.oelParamValues[oelPreset, oelpar.oelParamNames.T1],
    T2 = oelpar.oelParamValues[oelPreset, oelpar.oelParamNames.T2],
    T3 = oelpar.oelParamValues[oelPreset, oelpar.oelParamNames.T3],
    E1 = oelpar.oelParamValues[oelPreset, oelpar.oelParamNames.E1],
    E2 = oelpar.oelParamValues[oelPreset, oelpar.oelParamNames.E2],
    E3 = oelpar.oelParamValues[oelPreset, oelpar.oelParamNames.E3]
  )  annotation(
    Placement(visible = true, transformation(origin = {-130, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.PssIEEE2B pss(
    Ks1 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.Ks1], 
    Ks2 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.Ks2], 
    Ks3 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.Ks3], 
    PGen0Pu = -P0Pu, 
    SNom = generatorSynchronous.SNom, 
    Vsi1MaxPu = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.VSI1Max], 
    Vsi1MinPu = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.VSI1Min], 
    Vsi2MaxPu = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.VSI2Max], 
    Vsi2MinPu = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.VSI2Min], 
    VstMaxPu = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.VSTMax], 
    VstMinPu = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.VSTMin], 
    t1 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.T1], 
    t10 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.T10], 
    t11 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.T11], 
    t2 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.T2], 
    t3 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.T3], 
    t4 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.T4], 
    t6 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.T6], 
    t7 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.T7], 
    t8 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.T8], 
    t9 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.T9], 
    tw1 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.Tw1], 
    tw2 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.Tw2], 
    tw3 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.Tw3], 
    tw4 = pss2bpar.exciterParams[pss2bPreset, pss2bpar.exciterParamNames.Tw4]
  ) annotation(
    Placement(visible = true, transformation(origin = {-60, -60}, extent = {{20, 20}, {-20, -20}}, rotation = 0)));

  Modelica.Blocks.Sources.Constant UuelConst(k = 0)  annotation(
    Placement(visible = true, transformation(origin = {-130, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant URefPuConst(k = exc.URef0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-130, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PmRefPuConst(k = ieeeg1.PmRef0Pu)  annotation(
    Placement(visible = true, transformation(origin = {114, 40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {29, 25}, extent = {{5, 5}, {-5, -5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PmPuConst(k = generatorSynchronous.Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {45, 65}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = generatorSynchronous.Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-29, 23}, extent = {{-5, 5}, {5, -5}}, rotation = 0)));
  Modelica.Blocks.Math.Add UelPu(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-16, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

equation
  switch.u2 = AvrInService;
  switch1.u2 = GovInService;
  connect(generatorSynchronous.terminal, terminal) annotation(
    Line(points = {{0, 0}, {0, 100}}, color = {0, 0, 255}));
  connect(PmRefPuConst.y, ieeeg1.PmRefPu) annotation(
    Line(points = {{103, 40}, {64, 40}, {64, 20}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaPu_out, ieeeg1.omegaPu) annotation(
    Line(points = {{0, -18}, {0, -72}, {132, -72}, {132, 0}, {88, 0}}, color = {0, 0, 127}));
  connect(URefPuConst.y, exc.URefPu) annotation(
    Line(points = {{-118, 12}, {-82, 12}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UStatorPu_out, exc.UStatorPu) annotation(
    Line(points = {{-6, 18}, {-6, 60}, {-40, 60}, {-40, 120}, {-162, 120}, {-162, -20}, {-102, -20}, {-102, 0}, {-82, 0}}, color = {0, 0, 127}));
  connect(UuelConst.y, exc.UuelPu) annotation(
    Line(points = {{-118, 50}, {-66, 50}, {-66, 24}}, color = {0, 0, 127}));
  connect(generatorSynchronous.IRotorPu_out, maxex2.XfdPu) annotation(
    Line(points = {{-18, -10}, {-30, -10}, {-30, -30}, {-152, -30}, {-152, 90}, {-140, 90}}, color = {0, 0, 127}));
  connect(PmPuConst.y, switch1.u3) annotation(
    Line(points = {{40, 66}, {36, 66}, {36, 30}}, color = {0, 0, 127}));
  connect(constant1.y, switch.u3) annotation(
    Line(points = {{-38, 40}, {-35, 40}, {-35, 27}}, color = {0, 0, 127}));
  connect(exc.EfdPu, switch.u1) annotation(
    Line(points = {{-38, 0}, {-35, 0}, {-35, 19}}, color = {0, 0, 127}));
  connect(switch.y, generatorSynchronous.efdPu_in) annotation(
    Line(points = {{-23.5, 23}, {-16, 23}, {-16, 0}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaRefPu_out, UelPu.u1) annotation(
    Line(points = {{10, -18}, {10, -64}, {-4, -64}}, color = {0, 0, 127}));
  connect(generatorSynchronous.omegaPu_out, UelPu.u2) annotation(
    Line(points = {{0, -18}, {0, -76}, {-4, -76}}, color = {0, 0, 127}));
  connect(UelPu.y, pss.omegaPu) annotation(
    Line(points = {{-26, -70}, {-36, -70}, {-36, -72}}, color = {0, 0, 127}));
  connect(pss.UPssPu, exc.UPssPu) annotation(
    Line(points = {{-82, -60}, {-92, -60}, {-92, -14}, {-82, -14}, {-82, -12}}, color = {0, 0, 127}));
  connect(generatorSynchronous.PGenPu_out, pss.PGenPu) annotation(
    Line(points = {{-10, -18}, {-10, -48}, {-36, -48}}, color = {0, 0, 127}));
  connect(switch1.y, generatorSynchronous.PmPu_in) annotation(
    Line(points = {{24, 26}, {22, 26}, {22, 0}, {16, 0}}, color = {0, 0, 127}));
  connect(ieeeg1.Pm1Pu, switch1.u1) annotation(
    Line(points = {{40, 8}, {36, 8}, {36, 22}}, color = {0, 0, 127}));
  connect(maxex2.UoelPu, exc.UoelPu) annotation(
    Line(points = {{-120, 90}, {-74, 90}, {-74, 24}}, color = {0, 0, 127}));

  annotation(
    Icon(graphics = {Line(points = {{-35.9986, -20}, {-34.0014, -5.4116}, {-30.0014, 9.5884}, {-23.0014, 22.0884}, {-16.0014, 26.5884}, {-6.00142, 21.5884}, {-1, 8.4116}, {0, 0}, {1, -8.4116}, {6.00142, -21.5884}, {16.0014, -26.5884}, {23.0014, -22.0884}, {30.0014, -9.5884}, {34.0014, 5.4116}, {35.9986, 20}}), Line(origin = {-110, 55}, points = {{42, -15}}), Ellipse(origin = {0, -1}, extent = {{-60, 61}, {60, -59}}), Text(origin = {0, 80}, lineColor = {0, 0, 255}, extent = {{-80, 10}, {80, -10}}, textString = "%name"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end SteamIEEET1Frame;
