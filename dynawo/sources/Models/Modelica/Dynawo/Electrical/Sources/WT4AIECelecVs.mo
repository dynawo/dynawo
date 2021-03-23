within Dynawo.Electrical.Sources;

model WT4AIECelecVs "Converter Model and grid interface according to IEC 61400-27-1 standard for a wind turbine of type 4A"
  /*
          * Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
          * See AUTHORS.txt
          * All rights reserved.
          * This Source Code Form is subject to the terms of the Mozilla Public
          * License, v. 2.0. If a copy of the MPL was not distributed with this
          * file, you can obtain one at http://mozilla.org/MPL/2.0/.
          * SPDX-License-Identifier: MPL-2.0
          *
          * This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
          */
  /*
            Equivalent circuit and conventions:
            */
  import Modelica;
  import Modelica.Math;
  import Modelica.ComplexMath;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;
  extends SwitchOff.SwitchOffGenerator;

  /*Nominal Parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.PerUnit Res "Electrical system serial resistance in pu (base UNom, SNom)" annotation(
  Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Xes "Electrical system serial reactance in pu (base UNom, SNom)" annotation(
  Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Ges "Electrical system shunt conductance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Bes "Electrical system shunt susceptance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Rfilter "Converter filter resistance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Lfilter "Converter filter inductance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Cfilter "Converter filter capacitance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));

  /*Control parameters*/
  parameter Types.Time Tg "Current generation time constant in seconds" annotation(
    Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit DipMax "Maximun active current ramp rate in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit DiqMax "Maximun reactive current ramp rate in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Generator"));
  parameter Types.PerUnit DiqMin "Minimum reactive current ramp rate in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Generator"));

  /*Parameters for initialization from load flow*/
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at plant terminal (PCC) in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.Angle UPhase0 "Start value of voltage angle at plan terminal (PCC) in radians" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in pu (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));

  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in pu (Ubase)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at plant terminal (PCC) in pu (Ubase, SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UGsRe0Pu "Starting value of the real component of the voltage at the converter's terminals (generator system) in pu (base UNom)" annotation(
 Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UGsIm0Pu "Real component of the voltage at the converter's terminals (generator system) in pu (base UNom)"annotation(
 Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IGsRe0Pu "Initial value of the real component of the current at the generator system module (converter) terminal in pu (Ubase, SNom) in generator convention" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IGsIm0Pu "Initial value of the imaginary component of the current at the generator system module (converter) terminal in pu (Ubase, SNom) in generator convention" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UGsp0Pu "Start value of the d-axis voltage at the converter terminal (filter) in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UGsq0Pu "Start value of the q-axis voltage at the converter terminal (filter) in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UpCdm0Pu "Start value of the d-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention"  annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UqCmd0Pu "Start value q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention"  annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IGsp0Pu "Start value of the d-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)"  annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IGsq0Pu "Start value of the q-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)"  annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IpConv0Pu "Start value of the d-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention"  annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IqConv0Pu "Start value of the q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention"  annotation(
    Dialog(group = "group", tab = "Operating point"));

  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput theta(start = UPhase0) "Phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
        Placement(visible = true, transformation(origin = {1.33227e-15, 111}, extent = {{-11, -11}, {11, 11}}, rotation = -90), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omegaRef0Pu) "Converter angular frequency in pu (base OmegaNom)" annotation(
        Placement(visible = true, transformation(origin = {110.5, 60.5}, extent = {{-10.5, 10.5}, {10.5, -10.5}}, rotation = 180), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput uqCmdPu(start = UqCmd0Pu) "q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
        Placement(visible = true, transformation(origin = {110, -10}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput upCmdPu(start = UpCdm0Pu) annotation(
    Placement(visible = true, transformation(origin = {110, 10}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  /*Ouputs*/
  Modelica.Blocks.Interfaces.RealOutput uWtRePu(start = u0Pu.re) "Real component of the voltage at the wind turbine terminals (electrical system) in pu (base UNom)" annotation(
        Placement(visible = true, transformation(origin = {-110, -76}, extent = {{-10, 10}, {10, -10}}, rotation = 180), iconTransformation(origin = {30, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput uWtImPu(start = u0Pu.im) "Imaginary component of the voltage at the wind turbine terminals (electrical system) in pu (base UNom) " annotation(
        Placement(visible = true, transformation(origin = {-110, -92}, extent = {{-10, 10}, {10, -10}}, rotation = 180), iconTransformation(origin = {70, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput iWtImPu(start = -i0Pu.im* SystemBase.SnRef / SNom) "Imaginary component of the current at the wind turbine terminals in pu (Ubase, SNom) (generator convention)" annotation(
        Placement(visible = true, transformation(origin = {-110, -58}, extent = {{-10, 10}, {10, -10}}, rotation = 180), iconTransformation(origin = {-31, -110}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput uGsqPu(start = UGsq0Pu) "q-axis voltage at the converter terminal (filter) in pu (base UNom)" annotation(
        Placement(visible = true, transformation(origin = {109, -58}, extent = {{-9, -9}, {9, 9}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput uGspPu(start = UGsp0Pu) "d-axis voltage at the converter terminal (filter) in pu (base UNom)" annotation(
        Placement(visible = true, transformation(origin = {110, -41}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput ipConvPu(start = IpConv0Pu) "d-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
        Placement(visible = true, transformation(origin = {110, -93}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput iqConvPu(start = IqConv0Pu) "q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
        Placement(visible = true, transformation(origin = {110, -75}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput iWtRePu(start = -i0Pu.re * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {-110, -38}, extent = {{-10, 10}, {10, -10}}, rotation = 180), iconTransformation(origin = {-70, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im)))  annotation(
    Placement(visible = true, transformation(origin = {-94, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Sources.BaseConverters.IECVSCI iECVSCI(Cfilter = Cfilter, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IGsp0Pu = IGsp0Pu, IGsq0Pu = IGsq0Pu, IpConv0Pu = IpConv0Pu, IqConv0Pu = IqConv0Pu, Lfilter = Lfilter, Rfilter = Rfilter, SNom = SNom, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UGsp0Pu = UGsp0Pu, UGsq0Pu = UGsq0Pu, UPhase0 = UPhase0, UpCdm0Pu = UpCdm0Pu, UqCmd0Pu = UqCmd0Pu, i0Pu = i0Pu, u0Pu = u0Pu)  annotation(
    Placement(visible = true, transformation(origin = {64, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));

  Dynawo.Electrical.Sources.BaseConverters.IECElecSystem iECElecSystem(Bes = Bes, Ges = Ges, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, Res = Res, SNom = SNom, U0Pu = U0Pu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UPhase0 = UPhase0, Xes = Xes, i0Pu = i0Pu, u0Pu = u0Pu)    annotation(
    Placement(visible = true, transformation(origin = {-60, 3.55271e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Sources.BaseConverters.IECFrameRotation iECFrameRotation(P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0)  annotation(
    Placement(visible = true, transformation(origin = {0.9, -1.00002}, extent = {{9.9, -33.0001}, {-9.9, 33.0001}}, rotation = 0)));
equation
  running.value = iECElecSystem.running;
 connect(iECFrameRotation.iGsRePu, iECElecSystem.iGsRePu) annotation(
    Line(points = {{-12, 16}, {-25, 16}, {-25, 10}, {-38, 10}}, color = {0, 0, 127}));
 connect(iECFrameRotation.iGsImPu, iECElecSystem.iGsImPu) annotation(
    Line(points = {{-12, -18}, {-22.5, -18}, {-22.5, -10}, {-38, -10}}, color = {0, 0, 127}));
 connect(omegaPu, iECVSCI.omegaPu) annotation(
    Line(points = {{110, 60}, {74, 60}, {74, 22}, {74, 22}}, color = {0, 0, 127}));
 connect(theta, iECVSCI.theta) annotation(
    Line(points = {{0, 111}, {0, 60}, {54, 60}, {54, 22}}, color = {0, 0, 127}));
 connect(iECElecSystem.uWtImPu, uWtImPu) annotation(
    Line(points = {{-56, -22}, {-56, -22}, {-56, -92}, {-110, -92}, {-110, -92}}, color = {0, 0, 127}));
 connect(iECElecSystem.uWtRePu, uWtRePu) annotation(
    Line(points = {{-64, -22}, {-64, -22}, {-64, -76}, {-110, -76}, {-110, -76}}, color = {0, 0, 127}));
 connect(iECElecSystem.iWtImPu, iWtImPu) annotation(
    Line(points = {{-70, -22}, {-72, -22}, {-72, -58}, {-110, -58}, {-110, -58}}, color = {0, 0, 127}));
 connect(iECElecSystem.iWtRePu, iWtRePu) annotation(
    Line(points = {{-78, -22}, {-78, -22}, {-78, -38}, {-110, -38}, {-110, -38}}, color = {0, 0, 127}));
 connect(iECVSCI.ipConvPu, ipConvPu) annotation(
    Line(points = {{50, -22}, {50, -22}, {50, -92}, {110, -92}, {110, -92}}, color = {0, 0, 127}));
 connect(iECVSCI.iqConvPu, iqConvPu) annotation(
    Line(points = {{58, -22}, {58, -74}, {110, -74}, {110, -75}}, color = {0, 0, 127}));
 connect(iECVSCI.uGsqPu, uGsqPu) annotation(
    Line(points = {{70, -22}, {70, -58}, {109, -58}}, color = {0, 0, 127}));
 connect(iECVSCI.uGspPu, uGspPu) annotation(
    Line(points = {{78, -22}, {78, -40}, {110, -40}, {110, -41}}, color = {0, 0, 127}));
 connect(uqCmdPu, iECVSCI.uqCmdPu) annotation(
    Line(points = {{110, -10}, {86, -10}, {86, -10}, {86, -10}}, color = {0, 0, 127}));
 connect(upCmdPu, iECVSCI.upCmdPu) annotation(
    Line(points = {{110, 10}, {86, 10}, {86, 10}, {86, 10}}, color = {0, 0, 127}));
 connect(iECElecSystem.terminal, terminal) annotation(
    Line(points = {{-80, 0}, {-92, 0}, {-92, 0}, {-94, 0}}, color = {0, 0, 255}));
 connect(theta, iECFrameRotation.theta) annotation(
    Line(points = {{0, 111}, {0, 60}, {26, 60}, {26, -30}, {14, -30}}, color = {0, 0, 127}));
 connect(iECElecSystem.uGsRePu, iECVSCI.uGsRePu) annotation(
    Line(points = {{-42, -22}, {-42, -22}, {-42, -40}, {32, -40}, {32, -6}, {42, -6}, {42, -6}}, color = {0, 0, 127}));
 connect(iECElecSystem.uGsImPu, iECVSCI.uGsImPu) annotation(
    Line(points = {{-48, -22}, {-48, -22}, {-48, -50}, {42, -50}, {42, -14}, {42, -14}}, color = {0, 0, 127}));
 connect(iECVSCI.iGsqPu, iECFrameRotation.iqCmdPu) annotation(
    Line(points = {{42, 6}, {32, 6}, {32, 0}, {14, 0}, {14, -2}}, color = {0, 0, 127}));
 connect(iECVSCI.iGspPu, iECFrameRotation.ipCmdPu) annotation(
    Line(points = {{42, 14}, {32, 14}, {32, 28}, {14, 28}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 30}, extent = {{-90, -30}, {90, 30}}, textString = "IEC WT4A"), Text(origin = {0, -30}, extent = {{-90, -30}, {90, 30}}, textString = "Converter")}, coordinateSystem(initialScale = 0.1)));


end WT4AIECelecVs;
