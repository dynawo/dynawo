within Dynawo.Electrical.Controls.IEC.IEC61400.WPP;

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

model WPPControl2020 "Control model for IEC N°61400-27-1:2020 standard WPP"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses.BaseWPPControl;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.QControlParameters2020;

  //PControl parameters
  parameter Types.ActivePowerPu PErrMaxPu "Maximum control error for power PI controller in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PErrMinPu "Minimum negative control error for power PI controller in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));

  //QControl parameters
  parameter Types.PerUnit RwpDropPu "Resistive component of voltage drop impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.VoltageModulePu UwpqRisePu "Voltage threshold for OVRT detection in pu (base UNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XErrMaxPu "Maximum reactive power or voltage error input to PI controller in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XErrMinPu "Minimum reactive power or voltage error input to PI controller in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XwpDropPu "Inductive component of voltage drop impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControlWP"));

  //Linear communication parameters
  parameter Types.Time tLag "Communication lag time constant in s" annotation(
    Dialog(tab = "LinearCommunication"));
  parameter Types.Time tLead "Communication lead time constant in s" annotation(
    Dialog(tab = "LinearCommunication"));

  //Measurement parameters
  parameter Types.AngularVelocityPu DfMaxPu "Maximum frequency ramp rate in pu/s (base omegaNom)" annotation(
    Dialog(tab = "Measurement"));
  parameter Types.Time tfFilt "Filter time constant for frequency measurement in s" annotation(
    Dialog(tab = "Measurement"));
  parameter Types.Time tIFilt "Filter time constant for current measurement in s" annotation(
    Dialog(tab = "Measurement"));
  parameter Types.Time tPFilt "Filter time constant for active power measurement in s" annotation(
    Dialog(tab = "Measurement"));
  parameter Types.Time tQFilt "Filter time constant for reactive power measurement in s" annotation(
    Dialog(tab = "Measurement"));
  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "Measurement"));

  //Input variable
  Modelica.Blocks.Interfaces.RealInput xWPRefPu(start = X0Pu) "Reference reactive power or voltage in pu (base SNom or UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-200, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput PPDRefComPu(start = -P0Pu * SystemBase.SnRef / SNom) "Reference active power communicated to PD in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput xPDRefComPu(start = XWT0Pu) "Reference reactive power or voltage communicated to WT in pu (base SNom or UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WPP.WPPPControl2020 pControl(DPRefMaxPu = DPRefMaxPu, DPRefMinPu = DPRefMinPu, DPwpRefMaxPu = DPwpRefMaxPu, DPwpRefMinPu = DPwpRefMinPu, Kiwpp = Kiwpp, Kpwpp = Kpwpp, KwppRef = KwppRef, P0Pu = P0Pu, PErrMaxPu = PErrMaxPu, PErrMinPu = PErrMinPu, PKiwppMaxPu = PKiwppMaxPu, PKiwppMinPu = PKiwppMinPu, PRefMaxPu = PRefMaxPu, PRefMinPu = PRefMinPu, SNom = SNom, TablePwpBiasfwpFiltCom = TablePwpBiasfwpFiltCom, TablePwpBiasfwpFiltCom11 = TablePwpBiasfwpFiltCom11, TablePwpBiasfwpFiltCom12 = TablePwpBiasfwpFiltCom12, TablePwpBiasfwpFiltCom21 = TablePwpBiasfwpFiltCom21, TablePwpBiasfwpFiltCom22 = TablePwpBiasfwpFiltCom22, TablePwpBiasfwpFiltCom31 = TablePwpBiasfwpFiltCom31, TablePwpBiasfwpFiltCom32 = TablePwpBiasfwpFiltCom32, TablePwpBiasfwpFiltCom41 = TablePwpBiasfwpFiltCom41, TablePwpBiasfwpFiltCom42 = TablePwpBiasfwpFiltCom42, TablePwpBiasfwpFiltCom51 = TablePwpBiasfwpFiltCom51, TablePwpBiasfwpFiltCom52 = TablePwpBiasfwpFiltCom52, TablePwpBiasfwpFiltCom61 = TablePwpBiasfwpFiltCom61, TablePwpBiasfwpFiltCom62 = TablePwpBiasfwpFiltCom62, TablePwpBiasfwpFiltCom71 = TablePwpBiasfwpFiltCom71, TablePwpBiasfwpFiltCom72 = TablePwpBiasfwpFiltCom72, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {40, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WPP.WPPQControl2020 qControl(DXRefMaxPu = DXRefMaxPu, DXRefMinPu = DXRefMinPu, Kiwpx = Kiwpx, Kpwpx = Kpwpx, KwpqRef = KwpqRef, Kwpqu = Kwpqu, MwpqMode = MwpqMode, P0Pu = P0Pu, Q0Pu = Q0Pu, RwpDropPu = RwpDropPu, SNom = SNom, TableQwpMaxPwpFiltCom = TableQwpMaxPwpFiltCom, TableQwpMaxPwpFiltCom11 = TableQwpMaxPwpFiltCom11, TableQwpMaxPwpFiltCom12 = TableQwpMaxPwpFiltCom12, TableQwpMaxPwpFiltCom21 = TableQwpMaxPwpFiltCom21, TableQwpMaxPwpFiltCom22 = TableQwpMaxPwpFiltCom22, TableQwpMaxPwpFiltCom31 = TableQwpMaxPwpFiltCom31, TableQwpMaxPwpFiltCom32 = TableQwpMaxPwpFiltCom32, TableQwpMinPwpFiltCom = TableQwpMinPwpFiltCom, TableQwpMinPwpFiltCom11 = TableQwpMinPwpFiltCom11, TableQwpMinPwpFiltCom12 = TableQwpMinPwpFiltCom12, TableQwpMinPwpFiltCom21 = TableQwpMinPwpFiltCom21, TableQwpMinPwpFiltCom22 = TableQwpMinPwpFiltCom22, TableQwpMinPwpFiltCom31 = TableQwpMinPwpFiltCom31, TableQwpMinPwpFiltCom32 = TableQwpMinPwpFiltCom32, TableQwpUErr = TableQwpUErr, TableQwpUErr11 = TableQwpUErr11, TableQwpUErr12 = TableQwpUErr12, TableQwpUErr21 = TableQwpUErr21, TableQwpUErr22 = TableQwpUErr22, TableQwpUErr31 = TableQwpUErr31, TableQwpUErr32 = TableQwpUErr32, U0Pu = U0Pu, UwpqDipPu = UwpqDipPu, UwpqRisePu = UwpqRisePu, X0Pu = X0Pu, XErrMaxPu = XErrMaxPu, XErrMinPu = XErrMinPu, XKiwpxMaxPu = XKiwpxMaxPu, XKiwpxMinPu = XKiwpxMinPu, XRefMaxPu = XRefMaxPu, XRefMinPu = XRefMinPu, XWT0Pu = XWT0Pu, XwpDropPu = XwpDropPu, tS = tS, tUqFilt = tUqFilt) annotation(
    Placement(visible = true, transformation(origin = {40, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries.Measurements measurements(DfMaxPu = DfMaxPu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, i0Pu = i0Pu, tIFilt = tIFilt, tPFilt = tPFilt, tQFilt = tQFilt, tS = tS, tUFilt = tUFilt, tfFilt = tfFilt, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WPP.LinearCommunication linearCommunicationWPRef(X0Pu = {-P0Pu * (SystemBase.SnRef / SNom), X0Pu}, nu = 2, tLag = tLag, tLead = tLead) annotation(
    Placement(visible = true, transformation(origin = {-80, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WPP.LinearCommunication linearCommunicationWPM(X0Pu = {-P0Pu * SystemBase.SnRef / SNom, -Q0Pu * SystemBase.SnRef / SNom, U0Pu, SystemBase.omegaRef0Pu}, nu = 4, tLag = tLag, tLead = tLead) annotation(
    Placement(visible = true, transformation(origin = {-40, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WPP.LinearCommunication linearCommunicationPD(X0Pu = {-P0Pu * (SystemBase.SnRef / SNom), XWT0Pu}, nu = 2, tLag = tLag, tLead = tLead) annotation(
    Placement(visible = true, transformation(origin = {120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-10, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(uPu, measurements.uPu) annotation(
    Line(points = {{-200, 0}, {-160, 0}, {-160, -48}, {-142, -48}}, color = {85, 170, 255}));
  connect(iPu, measurements.iPu) annotation(
    Line(points = {{-200, -60}, {-142, -60}}, color = {85, 170, 255}));
  connect(omegaRefPu, measurements.omegaRefPu) annotation(
    Line(points = {{-200, -100}, {-160, -100}, {-160, -72}, {-142, -72}}, color = {0, 0, 127}));
  connect(linearCommunicationPD.y[1], PPDRefComPu) annotation(
    Line(points = {{140, 8}, {160, 8}, {160, 20}, {190, 20}}, color = {0, 0, 127}));
  connect(linearCommunicationPD.y[2], xPDRefComPu) annotation(
    Line(points = {{140, -8}, {160, -8}, {160, -20}, {190, -20}}, color = {0, 0, 127}));
  connect(measurements.PFiltPu, linearCommunicationWPM.u[1]) annotation(
    Line(points = {{-98, -44}, {-78, -44}, {-78, -52}, {-60, -52}}, color = {0, 0, 127}));
  connect(measurements.QFiltPu, linearCommunicationWPM.u[2]) annotation(
    Line(points = {{-98, -48}, {-80, -48}, {-80, -56}, {-60, -56}}, color = {0, 0, 127}));
  connect(measurements.UFiltPu, linearCommunicationWPM.u[3]) annotation(
    Line(points = {{-98, -64}, {-80, -64}, {-80, -64}, {-60, -64}}, color = {0, 0, 127}));
  connect(measurements.omegaFiltPu, linearCommunicationWPM.u[4]) annotation(
    Line(points = {{-98, -76}, {-80, -76}, {-80, -68}, {-60, -68}}, color = {0, 0, 127}));
  connect(xWPRefPu, linearCommunicationWPRef.u[2]) annotation(
    Line(points = {{-200, 40}, {-160, 40}, {-160, 52}, {-100, 52}}, color = {0, 0, 127}));
  connect(linearCommunicationWPM.y[1], y) annotation(
    Line(points = {{-20, -56}, {-8, -56}}, color = {0, 0, 127}));
  connect(PWPRefPu, linearCommunicationWPRef.u[1]) annotation(
    Line(points = {{-200, 86}, {-160, 86}, {-160, 60}, {-100, 60}}, color = {0, 0, 127}));
  connect(qControl.fWPFrt, pControl.fWPFrt) annotation(
    Line(points = {{40, -38}, {40, 38}}, color = {255, 0, 255}));
  connect(const.y, pControl.PWPHookPu) annotation(
    Line(points = {{2, 100}, {40, 100}, {40, 82}}, color = {0, 0, 127}));
  connect(pControl.PPDRefPu, linearCommunicationPD.u[1]) annotation(
    Line(points = {{62, 60}, {80, 60}, {80, 8}, {100, 8}}, color = {0, 0, 127}));
  connect(qControl.xPDRefPu, linearCommunicationPD.u[2]) annotation(
    Line(points = {{62, -60}, {80, -60}, {80, -8}, {100, -8}}, color = {0, 0, 127}));
  connect(linearCommunicationWPRef.y[1], pControl.PWPRefComPu) annotation(
    Line(points = {{-60, 68}, {0, 68}, {0, 72}, {18, 72}}, color = {0, 0, 127}));
  connect(linearCommunicationWPRef.y[2], qControl.xWPRefComPu) annotation(
    Line(points = {{-60, 52}, {2, 52}, {2, -48}, {18, -48}}, color = {0, 0, 127}));
  connect(y, qControl.PWPFiltComPu) annotation(
    Line(points = {{-8, -56}, {18, -56}}, color = {0, 0, 127}));
  connect(y, pControl.PWPFiltComPu) annotation(
    Line(points = {{-8, -56}, {0, -56}, {0, 48}, {18, 48}}, color = {0, 0, 127}));
  connect(linearCommunicationWPM.y[2], qControl.QWPFiltComPu) annotation(
    Line(points = {{-20, -64}, {18, -64}}, color = {0, 0, 127}));
  connect(linearCommunicationWPM.y[3], qControl.UWPFiltComPu) annotation(
    Line(points = {{-20, -68}, {0, -68}, {0, -72}, {18, -72}}, color = {0, 0, 127}));
  connect(linearCommunicationWPM.y[4], pControl.omegaWPFiltComPu) annotation(
    Line(points = {{-20, -52}, {-2, -52}, {-2, 60}, {18, 60}}, color = {0, 0, 127}));

end WPPControl2020;
