within Dynawo.Electrical.BESS.WECC.BaseClasses;

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

partial model BaseBESSc "Partial base model for the WECC BESS models including the electrical model type C"
  extends Dynawo.Electrical.BESS.WECC.BaseClasses.BaseBESS(repc.QInjRef0Pu = if not PfFlag and not UFlag and QFlag then UInj0Pu else QInj0Pu);
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.REECcParameters;

  Dynawo.Electrical.Controls.WECC.REEC.REECc reec(DPMaxPu = DPMaxPu, DPMinPu = DPMinPu, Dbd1Pu = Dbd1Pu, Dbd2Pu = Dbd2Pu, IMaxPu = IMaxPu, Ip0Pu = Ip0Pu, Iq0Pu = Iq0Pu, Iqh1Pu = Iqh1Pu, Iql1Pu = Iql1Pu, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PF0 = PF0, PGen0Pu = -P0Pu * SystemBase.SnRef / SNom, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, PQFlag = PQFlag, PfFlag = PfFlag, QFlag = QFlag, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, SOC0 = SOC0, SOCMaxPu = SOCMaxPu, SOCMinPu = SOCMinPu, UDipPu = UDipPu, UFlag = UFlag, UInj0Pu = UInj0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, UUpPu = UUpPu, VDLIp11 = VDLIp11, VDLIp12 = VDLIp12, VDLIp21 = VDLIp21, VDLIp22 = VDLIp22, VDLIq11 = VDLIq11, VDLIq12 = VDLIq12, VDLIq21 = VDLIq21, VDLIq22 = VDLIq22, VRef0Pu = VRef0Pu, tBattery = tBattery, tIq = tIq, tP = tP, tPOrd = tPOrd, tRv = tRv) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameter
  parameter Types.PerUnit SOC0 "Initial state of charge in pu (base SNom)" annotation(
    Dialog(group = "Initialization"));

equation
  connect(repc.PInjRefPu, reec.PInjRefPu) annotation(
    Line(points = {{-109, 6}, {-91, 6}}, color = {0, 0, 127}));
  connect(repc.QInjRefPu, reec.QInjRefPu) annotation(
    Line(points = {{-109, -6}, {-91, -6}}, color = {0, 0, 127}));
  connect(PFaRef, reec.PFaRef) annotation(
    Line(points = {{-80, 70}, {-80, 11}}, color = {0, 0, 127}));
  connect(PAuxPu, reec.PAuxPu) annotation(
    Line(points = {{-100, 70}, {-100, 55}, {-86, 55}, {-86, 11}}, color = {0, 0, 127}));
  connect(measurements.PPu, reec.PGenPu) annotation(
    Line(points = {{54, 11}, {54, 20}, {40, 20}, {40, -40}, {-84, -40}, {-84, -11}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram");
end BaseBESSc;
