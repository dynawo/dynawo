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

partial model BaseBESSd "Partial base model for the WECC BESS models including the electrical model type D"
  extends Dynawo.Electrical.BESS.WECC.BaseClasses.BaseBESS(repc.QInjRef0Pu = if not PfFlag and not UFlag and QFlag then UInj0Pu else QInj0Pu);
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.REECdParameters;

  Dynawo.Electrical.Controls.WECC.REEC.REECd reec(DPMaxPu = DPMaxPu, DPMinPu = DPMinPu, Dbd1Pu = Dbd1Pu, Dbd2Pu = Dbd2Pu, IMaxPu = IMaxPu, Ip0Pu = Ip0Pu, Iq0Pu = Iq0Pu, IqFrzPu = IqFrzPu, Iqh1Pu = Iqh1Pu, Iql1Pu = Iql1Pu, Kc = Kc, Ke = Ke, Kqi = Kqi, Kqp = Kqp, Kqv = Kqv, Kvi = Kvi, Kvp = Kvp, PF0 = PF0, PFlag = false, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, PQFlag = PQFlag, PfFlag = PfFlag, QFlag = QFlag, QInj0Pu = QInj0Pu, QUMaxPu = QUMaxPu, QUMinPu = QUMinPu, RcPu = RcPu, UBlkHPu = UBlkHPu, UBlkLPu = UBlkLPu, UCmpFlag = UCmpFlag, UDipPu = UDipPu, UFlag = UFlag, UInj0Pu = UInj0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, UUpPu = UUpPu, VDLIp101 = VDLIp101, VDLIp102 = VDLIp102, VDLIp11 = VDLIp11, VDLIp12 = VDLIp12, VDLIp21 = VDLIp21, VDLIp22 = VDLIp22, VDLIp31 = VDLIp31, VDLIp32 = VDLIp32, VDLIp41 = VDLIp41, VDLIp42 = VDLIp42, VDLIp51 = VDLIp51, VDLIp52 = VDLIp52, VDLIp61 = VDLIp61, VDLIp62 = VDLIp62, VDLIp71 = VDLIp71, VDLIp72 = VDLIp72, VDLIp81 = VDLIp81, VDLIp82 = VDLIp82, VDLIp91 = VDLIp91, VDLIp92 = VDLIp92, VDLIq101 = VDLIq101, VDLIq102 = VDLIq102, VDLIq11 = VDLIq11, VDLIq12 = VDLIq12, VDLIq21 = VDLIq21, VDLIq22 = VDLIq22, VDLIq31 = VDLIq31, VDLIq32 = VDLIq32, VDLIq41 = VDLIq41, VDLIq42 = VDLIq42, VDLIq51 = VDLIq51, VDLIq52 = VDLIq52, VDLIq61 = VDLIq61, VDLIq62 = VDLIq62, VDLIq71 = VDLIq71, VDLIq72 = VDLIq72, VDLIq81 = VDLIq81, VDLIq82 = VDLIq82, VDLIq91 = VDLIq91, VDLIq92 = VDLIq92, VRef0Pu = VRef0Pu, VRef1Pu = VRef1Pu, XcPu = XcPu, iInj0Pu = -i0Pu * SystemBase.SnRef / SNom, tBlkDelay = tBlkDelay, tHld = tHld, tHld2 = tHld2, tIq = tIq, tP = tP, tPOrd = tPOrd, tR1 = tR1, tRv = tRv, uInj0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(repc.PInjRefPu, reec.PInjRefPu) annotation(
    Line(points = {{-109, 6}, {-91, 6}}, color = {0, 0, 127}));
  connect(repc.QInjRefPu, reec.QInjRefPu) annotation(
    Line(points = {{-109, -6}, {-91, -6}}, color = {0, 0, 127}));
  connect(PFaRef, reec.PFaRef) annotation(
    Line(points = {{-80, 70}, {-80, 11}}, color = {0, 0, 127}));
  connect(PAuxPu, reec.PAuxPu) annotation(
    Line(points = {{-100, 70}, {-100, 55}, {-86, 55}, {-86, 11}}, color = {0, 0, 127}));
  connect(OmegaRef.y, reec.omegaGPu) annotation(
    Line(points = {{-179, 34}, {-175, 34}, {-175, -60}, {-84, -60}, {-84, -11}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram");
end BaseBESSd;
