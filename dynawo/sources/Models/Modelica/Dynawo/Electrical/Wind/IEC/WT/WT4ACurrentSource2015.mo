within Dynawo.Electrical.Wind.IEC.WT;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model WT4ACurrentSource2015 "Wind Turbine Type 4A model from IEC 61400-27-1:2015 standard : measurement, PLL, protection, PControl, QControl, limiters, electrical and generator modules"
  extends Dynawo.Electrical.Wind.IEC.BaseClasses.BaseWT4;

  //Uf measurement parameters
  parameter Types.AngularVelocityPu DfMaxPu "Maximum frequency ramp rate in pu/s (base omegaNom)" annotation(
    Dialog(tab = "UfMeasurement"));
  parameter Boolean Mzc "Zero crossing measurement mode (true = 1 if the wind turbine protection system uses zero crossings to detect the frequency - otherwise false = 0)" annotation(
    Dialog(tab = "UfMeasurement"));
  parameter Types.Time tfFilt "Filter time constant for frequency measurement in s" annotation(
    Dialog(tab = "UfMeasurement"));
  parameter Types.Time tphiFilt "Filter time constant for voltage angle measurement in s" annotation(
    Dialog(tab = "UfMeasurement"));
  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "UfMeasurement"));

  //PControl parameters
  parameter Types.PerUnit DPMaxP4APu "Maximum WT power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPOrdP4A "Power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tUFiltP4A "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "PControl"));

  //Current limiter parameters
  parameter Types.Time tUFiltcl "Voltage filter time constant in s" annotation(
    Dialog(tab = "CurrentLimiter"));

  //QControl parameters
  parameter Integer MqUvrt "UVRT Q control modes (0-2) (see Table 23, section 5.6.5.7, page 51 of the IEC norm N°61400-27-1:2015)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tPFiltQ "Active power filter time constant in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tUFiltQ "Voltage filter time constant in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu Udb1Pu "Voltage dead band lower limit in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu Udb2Pu "Voltage dead band upper limit in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));

  //Qlimiter parameters
  parameter Types.Time tPFiltql "Filter time constant for active power measurement in s" annotation(
    Dialog(tab = "QLimiter"));
  parameter Types.Time tUFiltql "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "QLimiter"));

  Dynawo.Electrical.Controls.IEC.IEC61400.WT.Control4A2015 control4A(DPMaxP4APu = DPMaxP4APu, Udb1Pu = Udb1Pu, Udb2Pu = Udb2Pu, IMaxDipPu = IMaxDipPu, IMaxPu = IMaxPu, IpMax0Pu = IpMax0Pu, IqH1Pu = IqH1Pu, IqMax0Pu = IqMax0Pu, IqMaxPu = IqMaxPu, IqMin0Pu = IqMin0Pu, IqMinPu = IqMinPu, IqPostPu = IqPostPu, Kiq = Kiq, Kiu = Kiu, Kpaw = Kpaw, Kpq = Kpq, Kpqu = Kpqu, Kpu = Kpu, Kqv = Kqv, MdfsLim = MdfsLim, MqG = MqG, MqUvrt = MqUvrt, Mqpri = Mqpri, P0Pu = P0Pu, Q0Pu = Q0Pu, QMax0Pu = QMax0Pu, QMaxPu = QMaxPu, QMin0Pu = QMin0Pu, QMinPu = QMinPu, QlConst = QlConst, RDropPu = RDropPu, SNom = SNom, TableIpMaxUwt = TableIpMaxUwt, TableIqMaxUwt = TableIqMaxUwt, TableQMaxPwtcFilt = TableQMaxPwtcFilt, TableQMaxUwtcFilt = TableQMaxUwtcFilt, TableQMinPwtcFilt = TableQMinPwtcFilt, TableQMinUwtcFilt = TableQMinUwtcFilt, U0Pu = U0Pu, UMaxPu = UMaxPu, UMinPu = UMinPu, UPhase0 = UPhase0, URef0Pu = URef0Pu, UpquMaxPu = UpquMaxPu, UqDipPu = UqDipPu, XDropPu = XDropPu, XWT0Pu = XWT0Pu, tPFiltQ = tPFiltQ, tPFiltql = tPFiltql, tPOrdP4A = tPOrdP4A, tPost = tPost, tQord = tQord, tS = tS, tUFiltP4A = tUFiltP4A, tUFiltQ = tUFiltQ, tUFiltcl = tUFiltcl, tUFiltql = tUFiltql) annotation(
    Placement(visible = true, transformation(origin = {-58, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-75, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries.GridProtection2015 gridProtection(DfMaxPu = DfMaxPu, Mzc = Mzc,TabletUoverUwtfilt = TabletUoverUwtfilt, TabletUunderUwtfilt = TabletUunderUwtfilt, Tabletfoverfwtfilt = Tabletfoverfwtfilt, Tabletfunderfwtfilt = Tabletfunderfwtfilt, U0Pu = U0Pu,UOverPu = UOverPu, UPhase0 = UPhase0, UUnderPu = UUnderPu, fOverPu = fOverPu, fUnderPu = fUnderPu, tS = tS, tUFilt = tUFilt, tfFilt = tfFilt, tphiFilt = tphiFilt, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {60, 80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToPolar complexToPolar annotation(
    Placement(visible = true, transformation(origin = {10, 30}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries.MeasurementsPQ measurementsPQ(P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-10, -90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

equation
  connect(control4A.ipMaxPu, wT4Injector.ipMaxPu) annotation(
    Line(points = {{-36, -24}, {-2, -24}}, color = {0, 0, 127}));
  connect(control4A.ipCmdPu, wT4Injector.ipCmdPu) annotation(
    Line(points = {{-36, -32}, {-2, -32}}, color = {0, 0, 127}));
  connect(control4A.iqMaxPu, wT4Injector.iqMaxPu) annotation(
    Line(points = {{-36, -40}, {-2, -40}}, color = {0, 0, 127}));
  connect(control4A.iqCmdPu, wT4Injector.iqCmdPu) annotation(
    Line(points = {{-36, -48}, {-2, -48}}, color = {0, 0, 127}));
  connect(control4A.iqMinPu, wT4Injector.iqMinPu) annotation(
    Line(points = {{-36, -56}, {-2, -56}}, color = {0, 0, 127}));
  connect(xWTRefPu, control4A.xWTRefPu) annotation(
    Line(points = {{-130, -60}, {-100, -60}, {-100, -52}, {-80, -52}}, color = {0, 0, 127}));
  connect(tanPhi, control4A.tanPhi) annotation(
    Line(points = {{-130, -40}, {-80, -40}}, color = {0, 0, 127}));
  connect(PWTRefPu, control4A.PWTRefPu) annotation(
    Line(points = {{-130, -20}, {-100, -20}, {-100, -34}, {-80, -34}}, color = {0, 0, 127}));
  connect(const.y, control4A.omegaGenPu) annotation(
    Line(points = {{-70, 0}, {-58, 0}, {-58, -18}}, color = {0, 0, 127}));
  connect(wT4Injector.uWtPu, gridProtection.uWtPu) annotation(
    Line(points = {{42, -28}, {100, -28}, {100, 102}, {72, 102}}, color = {85, 170, 255}));
  connect(gridProtection.fOCB, wT4Injector.fOCB) annotation(
    Line(points = {{60, 58}, {60, -10}, {20, -10}, {20, -18}}, color = {255, 0, 255}));
  connect(omegaRefPu, gridProtection.omegaRefPu) annotation(
    Line(points = {{0, 130}, {0, 120}, {52, 120}, {52, 102}}, color = {0, 0, 127}));
  connect(wT4Injector.uWtPu, complexToPolar.u) annotation(
    Line(points = {{42, -28}, {50, -28}, {50, 30}, {22, 30}}, color = {85, 170, 255}));
  connect(complexToPolar.len, control4A.UWTPu) annotation(
    Line(points = {{-2, 36}, {-86, 36}, {-86, -28}, {-80, -28}}, color = {0, 0, 127}));
  connect(complexToPolar.len, pll.UWTPu) annotation(
    Line(points = {{-2, 36}, {-86, 36}, {-86, 102}, {-28, 102}, {-28, 98}}, color = {0, 0, 127}));
  connect(complexToPolar.phi, pll.theta) annotation(
    Line(points = {{-2, 24}, {-60, 24}, {-60, 108}, {-12, 108}, {-12, 98}}, color = {0, 0, 127}));
  connect(measurementsPQ.PPu, control4A.PWTPu) annotation(
    Line(points = {{-13, -79}, {-12.5, -79}, {-12.5, -73}, {-92, -73}, {-92, -46}, {-80, -46}}, color = {0, 0, 127}));
  connect(measurementsPQ.QPu, control4A.QWTPu) annotation(
    Line(points = {{-7, -79}, {-6.5, -79}, {-6.5, -69}, {-88, -69}, {-88, -58.5}, {-80, -58.5}, {-80, -58}}, color = {0, 0, 127}));
  connect(wT4Injector.uWtPu, measurementsPQ.uPu) annotation(
    Line(points = {{42, -28}, {50, -28}, {50, -84}, {1, -84}}, color = {85, 170, 255}));
  connect(wT4Injector.iWtPu, measurementsPQ.iPu) annotation(
    Line(points = {{42, -24}, {70, -24}, {70, -90}, {1, -90}}, color = {85, 170, 255}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Text(origin = {69.5, -1.5}, extent = {{-40, 20}, {41, -19}}, textString = "A"), Text(origin = {3, -41}, extent = {{-53, 24}, {53, -24}}, textString = "2015")}));
end WT4ACurrentSource2015;
