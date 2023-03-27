within Dynawo.Electrical.Controls.IEC.WPP;

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

model WPPControl "Control model for IEC N°61400-27-1 standard WPP"
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  //Nominal parameters
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.Time tS "Integration time step in s";

  //Linear communication parameters
  parameter Types.Time tLag "Communication lag time constant in s" annotation(
    Dialog(tab = "LinearCommunication"));
  parameter Types.Time tLead "Communication lead time constant in s" annotation(
    Dialog(tab = "LinearCommunication"));

  //PControl parameters
  parameter Types.PerUnit DPRefMaxPu "Maximum positive ramp rate for PD power reference in pu/s (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit DPRefMinPu "Minimum negative ramp rate for PD power reference in pu/s (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit DPwpRefMaxPu "Maximum positive ramp rate for WP power reference in pu/s (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit DPwpRefMinPu "Minimum negative ramp rate for WP power reference in pu/s (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit Kiwpp "Power PI controller integration gain in pu/s (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit Kpwpp "Power PI controller proportional gain in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit KwppRef "Power reference gain in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PErrMaxPu "Maximum control error for power PI controller in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PErrMinPu "Minimum negative control error for power PI controller in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PKiwppMaxPu "Maximum active power reference from integration in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PKiwppMinPu "Minimum active power reference from integration in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PRefMaxPu "Maximum PD power reference in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PRefMinPu "Minimum PD power reference in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));

  //QControl parameters
  parameter Types.PerUnit DXRefMaxPu "Maximum positive ramp rate for WT reactive power or voltage reference in pu/s (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit DXRefMinPu "Minimum negative ramp rate for WT reactive power or voltage reference in pu/s (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit Kiwpx "Reactive power or voltage PI controller integral gain in pu/s (base SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit Kpwpx "Reactive power or voltage PI controller proportional gain in pu (base SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit KwpqRef "Reactive power reference gain in pu (base SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit Kwpqu "Voltage controller cross coupling gain in pu (base SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Integer MwpqMode "Control mode (0 : reactive power reference, 1 : power factor reference, 2 : UQ static, 3 : voltage control)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit RwpDropPu "Resistive component of voltage drop impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.Time tUqFilt "Time constant for the UQ static mode in s" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.VoltageModulePu UwpqDipPu "Voltage threshold for UVRT detection in pu (base UNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.VoltageModulePu UwpqRisePu "Voltage threshold for OVRT detection in pu (base UNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XErrMaxPu "Maximum reactive power or voltage error input to PI controller in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XErrMinPu "Minimum reactive power or voltage error input to PI controller in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XKiwpxMaxPu "Maximum WT reactive power or voltage reference from integretion in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XKiwpxMinPu "Minimum WT reactive power or voltage reference from integretion in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XRefMaxPu "Maximum WT reactive power or voltage reference in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XRefMinPu "Minimum WT reactive power or voltage reference in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XwpDropPu "Inductive component of voltage drop impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControlWP"));

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

  //Input variables
  Modelica.ComplexBlocks.Interfaces.ComplexInput iPu(re(start = -i0Pu.re * SystemBase.SnRef / SNom), im(start = -i0Pu.im * SystemBase.SnRef / SNom)) "Complex current at grid terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-200, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Grid angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-200, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PWPRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Reference active power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-200, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex voltage at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-200, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput xWPRefPu(start = X0Pu) "Reference reactive power or voltage in pu (base SNom or UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-200, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput PPDRefComPu(start = -P0Pu * SystemBase.SnRef / SNom) "Reference active power communicated to PD in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {190, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput xPDRefComPu(start = XWT0Pu) "Reference reactive power or voltage communicated to WT in pu (base SNom or UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.IEC.BaseControls.Auxiliaries.Measurements measurements(DfMaxPu = DfMaxPu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, i0Pu = i0Pu, tIFilt = tIFilt, tPFilt = tPFilt, tQFilt = tQFilt, tS = tS, tUFilt = tUFilt, tfFilt = tfFilt, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.BaseControls.WPP.PControl pControl(DPRefMaxPu = DPRefMaxPu, DPRefMinPu = DPRefMinPu, DPwpRefMaxPu = DPwpRefMaxPu, DPwpRefMinPu = DPwpRefMinPu, Kiwpp = Kiwpp, Kpwpp = Kpwpp, KwppRef = KwppRef, P0Pu = P0Pu, PErrMaxPu = PErrMaxPu, PErrMinPu = PErrMinPu, PKiwppMaxPu = PKiwppMaxPu, PKiwppMinPu = PKiwppMinPu, PRefMaxPu = PRefMaxPu, PRefMinPu = PRefMinPu, SNom = SNom, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {40, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.BaseControls.WPP.QControl qControl(DXRefMaxPu = DXRefMaxPu, DXRefMinPu = DXRefMinPu, Kiwpx = Kiwpx, Kpwpx = Kpwpx, KwpqRef = KwpqRef, Kwpqu = Kwpqu, MwpqMode = MwpqMode, P0Pu = P0Pu, Q0Pu = Q0Pu, RwpDropPu = RwpDropPu, SNom = SNom, U0Pu = U0Pu, UwpqDipPu = UwpqDipPu, UwpqRisePu = UwpqRisePu, X0Pu = X0Pu, XErrMaxPu = XErrMaxPu, XErrMinPu = XErrMinPu, XKiwpxMaxPu = XKiwpxMaxPu, XKiwpxMinPu = XKiwpxMinPu, XRefMaxPu = XRefMaxPu, XRefMinPu = XRefMinPu, XWT0Pu = XWT0Pu, XwpDropPu = XwpDropPu, tS = tS, tUqFilt = tUqFilt) annotation(
    Placement(visible = true, transformation(origin = {40, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-10, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.BaseControls.WPP.LinearCommunication linearCommunicationWPRef(X0Pu = {-P0Pu * (SystemBase.SnRef / SNom), X0Pu}, nu = 2, tLag = tLag, tLead = tLead)  annotation(
    Placement(visible = true, transformation(origin = {-80, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.BaseControls.WPP.LinearCommunication linearCommunicationWPM(X0Pu = {-P0Pu * SystemBase.SnRef / SNom, -Q0Pu * SystemBase.SnRef / SNom, U0Pu, SystemBase.omegaRef0Pu}, nu = 4, tLag = tLag, tLead = tLead)  annotation(
    Placement(visible = true, transformation(origin = {-40, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.BaseControls.WPP.LinearCommunication linearCommunicationPD(X0Pu = {-P0Pu * (SystemBase.SnRef / SNom), XWT0Pu}, nu = 2, tLag = tLag, tLead = tLead)  annotation(
    Placement(visible = true, transformation(origin = {120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y(start = -P0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = false, transformation(origin = {-8, -56}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));

  //Initial parameters
  parameter Types.ComplexCurrentPu i0Pu "Initial complex current at grid terminal in pu (base UNom, SnRef) (receptor convention)" annotation(
    Dialog(group="Initialization"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ComplexVoltagePu u0Pu "Initial complex voltage at grid terminal in pu (base UNom)" annotation(
    Dialog(group="Initialization"));
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit X0Pu "Initial reactive power or voltage reference at grid terminal in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit XWT0Pu "Initial reactive power or voltage reference at grid terminal in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));

equation
  connect(uPu, measurements.uPu) annotation(
    Line(points = {{-200, 0}, {-160, 0}, {-160, -48}, {-142, -48}}, color = {85, 170, 255}));
  connect(iPu, measurements.iPu) annotation(
    Line(points = {{-200, -60}, {-142, -60}}, color = {85, 170, 255}));
  connect(omegaRefPu, measurements.omegaRefPu) annotation(
    Line(points = {{-200, -100}, {-160, -100}, {-160, -72}, {-142, -72}}, color = {0, 0, 127}));
  connect(qControl.fWPFrt, pControl.fWPFrt) annotation(
    Line(points = {{40, -38}, {40, 38}}, color = {255, 0, 255}));
  connect(const.y, pControl.PWPHookPu) annotation(
    Line(points = {{2, 100}, {40, 100}, {40, 82}}, color = {0, 0, 127}));
  connect(pControl.PPDRefPu, linearCommunicationPD.u[1]) annotation(
    Line(points = {{62, 60}, {80, 60}, {80, 8}, {100, 8}}, color = {0, 0, 127}));
  connect(qControl.xPDRefPu, linearCommunicationPD.u[2]) annotation(
    Line(points = {{62, -60}, {80, -60}, {80, -8}, {100, -8}}, color = {0, 0, 127}));
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
  connect(PWPRefPu, linearCommunicationWPRef.u[1]) annotation(
    Line(points = {{-200, 80}, {-160, 80}, {-160, 68}, {-100, 68}}, color = {0, 0, 127}));
  connect(xWPRefPu, linearCommunicationWPRef.u[2]) annotation(
    Line(points = {{-200, 40}, {-160, 40}, {-160, 52}, {-100, 52}}, color = {0, 0, 127}));
  connect(linearCommunicationWPRef.y[1], pControl.PWPRefComPu) annotation(
    Line(points = {{-60, 68}, {0, 68}, {0, 72}, {18, 72}}, color = {0, 0, 127}));
  connect(linearCommunicationWPRef.y[2], qControl.xWPRefComPu) annotation(
    Line(points = {{-60, 52}, {2, 52}, {2, -48}, {18, -48}}, color = {0, 0, 127}));
  connect(linearCommunicationWPM.y[1], y) annotation(
    Line(points = {{-20, -56}, {-8, -56}}, color = {0, 0, 127}));
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

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-65, 110}, extent = {{-35, 26}, {167, -132}}, textString = "WP control and"), Text(origin = {-68, 58}, extent = {{-36, 28}, {172, -140}}, textString = "communication"), Text(origin = {-23, -64}, extent = {{-41, 26}, {87, -6}}, textString = "module")}),
  Diagram(coordinateSystem(extent = {{-180, -120}, {180, 120}})));
end WPPControl;
