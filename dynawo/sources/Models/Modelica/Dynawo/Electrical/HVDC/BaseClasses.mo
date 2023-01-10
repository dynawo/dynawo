within Dynawo.Electrical.HVDC;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

package BaseClasses
  extends Icons.BasesPackage;

  partial model BaseHvdcP "Base dynamic model for HVDC links with a regulation of the active power"
    import Dynawo.Connectors;
    import Dynawo.Electrical.Controls.Basics.SwitchOff;

    extends SwitchOff.SwitchOffDCLine;

  /*
    Equivalent circuit and conventions:

                 I1                  I2
     (terminal1) -->-------HVDC-------<-- (terminal2)

  */

    Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Connectors.ACPower terminal2(V(re(start = u20Pu.re), im(start = u20Pu.im)), i(re(start = i20Pu.re), im(start = i20Pu.im))) annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

    parameter Real KLosses "Losses coefficient between 0 and 1 : 1 if no loss in the HVDC link, < 1 otherwise";
    parameter Types.ActivePowerPu PMaxPu "Maximum active power in pu (base SnRef) flowing through the HVDC link";

    input Types.ActivePowerPu P1RefPu(start = P1Ref0Pu) "Active power regulation set point in pu (base SnRef) at terminal 1 (receptor convention)";

    parameter Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base UNom)";
    parameter Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base UNom, SnRef) (receptor convention)";
    parameter Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in pu (base SnRef) (receptor convention)";
    parameter Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2 in pu (base UNom)";
    parameter Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 in pu (base UNom, SnRef) (receptor convention)";
    parameter Types.ComplexApparentPowerPu s20Pu "Start value of complex apparent power at terminal 2 in pu (base SnRef) (receptor convention)";
    parameter Types.ActivePowerPu P1Ref0Pu "Start value of active power reference at terminal 1 in pu (base SnRef) (receptor convention)";

    Types.ActivePowerPu P1Pu(start = s10Pu.re) "Active power at terminal 1 in pu (base SnRef) (receptor convention)";
    Types.ActivePowerPu P2Pu(start = s20Pu.re) "Active power at terminal 2 in pu (base SnRef) (receptor convention)";
    Types.ActivePowerPu PInj1Pu(start = - s10Pu.re) "Active power at terminal 1 in pu (base SnRef) (generator convention)";
    Types.ActivePowerPu PInj2Pu(start = - s20Pu.re) "Active power at terminal 2 in pu (base SnRef) (generator convention)";
    Types.VoltageModulePu U1Pu(start = ComplexMath.'abs'(u10Pu)) "Voltage amplitude at terminal 1 in pu (base UNom)";
    Types.VoltageModulePu U2Pu(start = ComplexMath.'abs'(u20Pu)) "Voltage amplitude at terminal 2 in pu (base UNom)";
    Types.ComplexApparentPowerPu s1Pu(re(start = s10Pu.re), im(start = s10Pu.im)) "Complex apparent power at terminal 1 in pu (base SnRef) (receptor convention)";
    Types.ComplexApparentPowerPu s2Pu(re(start = s20Pu.re), im(start = s20Pu.im)) "Complex apparent power at terminal 2 in pu (base SnRef) (receptor convention)";
    Types.ReactivePowerPu Q1Pu(start = s10Pu.im) "Reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
    Types.ReactivePowerPu Q2Pu(start = s20Pu.im) "Reactive power at terminal 2 in pu (base SnRef) (receptor convention)";
    Types.ReactivePowerPu QInj1Pu(start = - s10Pu.im) "Reactive power at terminal 1 in pu (base SnRef) (generator convention)";
    Types.ReactivePowerPu QInj2Pu(start = - s20Pu.im) "Reactive power at terminal 2 in pu (base SnRef) (generator convention)";

  equation
    U1Pu = ComplexMath.'abs'(terminal1.V);
    U2Pu = ComplexMath.'abs'(terminal2.V);
    s1Pu = Complex(P1Pu, Q1Pu);
    s1Pu = terminal1.V * ComplexMath.conj(terminal1.i);
    s2Pu = Complex(P2Pu, Q2Pu);
    s2Pu = terminal2.V * ComplexMath.conj(terminal2.i);

    if running.value then
      P1Pu = max(min(PMaxPu, P1RefPu), - PMaxPu);
      P2Pu = if P1Pu > 0 then - KLosses * P1Pu else - P1Pu / KLosses;
    else
      P1Pu = 0;
      P2Pu = 0;
    end if;

    //Sign convention change
    PInj1Pu = - P1Pu;
    PInj2Pu = - P2Pu;
    QInj1Pu = - Q1Pu;
    QInj2Pu = - Q2Pu;

    annotation(preferredView = "text",
      Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation.</div></body></html>"));
  end BaseHvdcP;

  partial model BaseHvdcPDangling "Base dynamic model for HVDC links with a regulation of the active power and with terminal2 connected to a switched-off bus"
    import Dynawo.Connectors;
    import Dynawo.Electrical.Controls.Basics.SwitchOff;

    extends SwitchOff.SwitchOffDCLine;

  /*
    Equivalent circuit and conventions:

                 I1                  I2 = 0
     (terminal1) -->-------HVDC-------<-- (switched-off terminal2)

  */

    Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) annotation(
        Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Connectors.ACPower terminal2 annotation(
        Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

    parameter Real KLosses "Coefficient between 0 and 1 (no loss) modelling the losses in the HVDC";
    parameter Types.ActivePowerPu PMaxPu "Maximum active power in pu (base SnRef) flowing through the HVDC link";

    input Types.ActivePowerPu P1RefPu(start = P1Ref0Pu) "Active power regulation set point in pu (base SnRef) at terminal 1 (receptor convention)";

    parameter Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base UNom)";
    parameter Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base UNom, SnRef) (receptor convention)";
    parameter Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in pu (base SnRef) (receptor convention)";
    parameter Types.ActivePowerPu P1Ref0Pu "Start value of active power reference at terminal 1 in pu (base SnRef) (receptor convention)";

    Types.ActivePowerPu P1Pu(start = s10Pu.re) "Active power at terminal 1 in pu (base SnRef) (receptor convention)";
    Types.ActivePowerPu P2Pu(start = 0) "Active power at terminal 2 in pu (base SnRef) (receptor convention)";
    Types.ActivePowerPu PInj1Pu(start = - s10Pu.re) "Active power at terminal 1 in pu (base SnRef) (generator convention)";
    Types.ActivePowerPu PInj2Pu(start = 0) "Active power at terminal 2 in pu (base SnRef) (generator convention)";
    Types.VoltageModulePu U1Pu(start = ComplexMath.'abs'(u10Pu)) "Voltage amplitude at terminal 1 in pu (base UNom)";
    Types.ComplexApparentPowerPu s1Pu(re(start = s10Pu.re), im(start = s10Pu.im)) "Complex apparent power at terminal 1 in pu (base SnRef) (receptor convention)";
    Types.ReactivePowerPu Q1Pu(start = s10Pu.im) "Reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
    Types.ReactivePowerPu Q2Pu(start = 0) "Reactive power at terminal 2 in pu (base SnRef) (receptor convention)";
    Types.ReactivePowerPu QInj1Pu(start = - s10Pu.im) "Reactive power at terminal 1 in pu (base SnRef) (generator convention)";
    Types.ReactivePowerPu QInj2Pu(start = 0) "Reactive power at terminal 2 in pu (base SnRef) (generator convention)";

  equation
    //Connected side
    if runningSide1.value then
      P1Pu = max(min(PMaxPu, P1RefPu), - PMaxPu);
      U1Pu = ComplexMath.'abs'(terminal1.V);
    else
      P1Pu = 0;
      U1Pu = 0;
    end if;

    //Disconnected side
    P2Pu = 0;
    Q2Pu = 0;
    terminal2.i.re = 0;
    terminal2.i.im = 0;

    //Sign convention change
    PInj1Pu = - P1Pu;
    PInj2Pu = - P2Pu;
    QInj1Pu = - Q1Pu;
    QInj2Pu = - Q2Pu;

    annotation(preferredView = "text",
      Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation. The terminal2 is connected to a switched-off bus.</div></body></html>"));
  end BaseHvdcPDangling;

  partial model BaseHvdcPDanglingDiagramPQ "Base dynamic model for HVDC links with a regulation of the active power and with terminal2 connected to a switched-off bus. The reactive power limits are given by a PQ diagram."
    import Modelica;

    extends BaseHvdcPDangling;

    parameter Types.ReactivePowerPu QInj1Min0Pu "Start value of the minimum reactive power in pu (base SnRef) (generator convention) at terminal 1";
    parameter Types.ReactivePowerPu QInj1Max0Pu "Start value of the maximum reactive power in pu (base SnRef) (generator convention) at terminal 1";
    parameter String QInj1MinTableName "Name of the table in the text file to get QInj1MinPu from PInj1Pu (generator convention)";
    parameter String QInj1MaxTableName "Name of the table in the text file to get QInj1MaxPu from PInj1Pu (generator convention)";
    parameter String QInj1MinTableFile "Text file that contains the table to get QInj1MinPu from PInj1Pu (generator convention)";
    parameter String QInj1MaxTableFile "Text file that contains the table to get QInj1MaxPu from PInj1Pu (generator convention)";

    Modelica.Blocks.Tables.CombiTable1D tableQInj1Min(tableOnFile = true, tableName = QInj1MinTableName, fileName = QInj1MinTableFile) "Table to get QInj1MinPu from PInj1Pu (generator convention)";
    Modelica.Blocks.Tables.CombiTable1D tableQInj1Max(tableOnFile = true, tableName = QInj1MaxTableName, fileName = QInj1MaxTableFile) "Table to get QInj1MaxPu from PInj1Pu (generator convention)";

    Types.ReactivePowerPu QInj1MinPu(start = QInj1Min0Pu) "Minimum reactive power in pu at terminal 1 (base SnRef) (generator convention)";
    Types.ReactivePowerPu QInj1MaxPu(start = QInj1Max0Pu) "Maximum reactive power in pu at terminal 1 (base SnRef) (generator convention)";

  equation
    PInj1Pu = tableQInj1Min.u[1];
    QInj1MinPu = tableQInj1Min.y[1];
    PInj1Pu = tableQInj1Max.u[1];
    QInj1MaxPu = tableQInj1Max.y[1];

    annotation(preferredView = "text",
      Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation. The terminal2 is connected to a switched-off bus. This partial model also implements the PQ diagram at terminal1.</div></body></html>"));
  end BaseHvdcPDanglingDiagramPQ;

  partial model BaseHvdcPDiagramPQ "Base dynamic model for HVDC links with a regulation of the active power and with a PQ Diagram at each terminal"
    import Modelica;

    extends BaseHvdcP;

    parameter Types.ReactivePowerPu QInj1Min0Pu "Start value of the minimum reactive power in pu (base SnRef) (generator convention) at terminal 1";
    parameter Types.ReactivePowerPu QInj1Max0Pu "Start value of the maximum reactive power in pu (base SnRef) (generator convention) at terminal 1";
    parameter Types.ReactivePowerPu QInj2Min0Pu "Start value of the minimum reactive power in pu (base SnRef) (generator convention) at terminal 2";
    parameter Types.ReactivePowerPu QInj2Max0Pu "Start value of the maximum reactive power in pu (base SnRef) (generator convention) at terminal 2";
    parameter String QInj1MinTableName "Name of the table in the text file to get QInj1MinPu from PInj1Pu (generator convention)";
    parameter String QInj1MaxTableName "Name of the table in the text file to get QInj1MaxPu from PInj1Pu (generator convention)";
    parameter String QInj1MinTableFile "Text file that contains the table to get QInj1MinPu from PInj1Pu (generator convention)";
    parameter String QInj1MaxTableFile "Text file that contains the table to get QInj1MaxPu from PInj1Pu (generator convention)";
    parameter String QInj2MinTableName "Name of the table in the text file to get QInj2MinPu from PInj2Pu (generator convention)";
    parameter String QInj2MaxTableName "Name of the table in the text file to get QInj2MaxPu from PInj2Pu (generator convention)";
    parameter String QInj2MinTableFile "Text file that contains the table to get QInj2MinPu from PInj2Pu (generator convention)";
    parameter String QInj2MaxTableFile "Text file that contains the table to get QInj2MaxPu from PInj2Pu (generator convention)";

    Modelica.Blocks.Tables.CombiTable1D tableQInj1Min(tableOnFile = true, tableName = QInj1MinTableName, fileName = QInj1MinTableFile) "Table to get QInj1MinPu from PInj1Pu (generator convention)";
    Modelica.Blocks.Tables.CombiTable1D tableQInj1Max(tableOnFile = true, tableName = QInj1MaxTableName, fileName = QInj1MaxTableFile) "Table to get QInj1MaxPu from PInj1Pu (generator convention)";
    Modelica.Blocks.Tables.CombiTable1D tableQInj2Min(tableOnFile = true, tableName = QInj2MinTableName, fileName = QInj2MinTableFile) "Table to get QInj2MinPu from PInj2Pu (generator convention)";
    Modelica.Blocks.Tables.CombiTable1D tableQInj2Max(tableOnFile = true, tableName = QInj2MaxTableName, fileName = QInj2MaxTableFile) "Table to get QInj2MaxPu from PInj2Pu (generator convention)";

    Types.ReactivePowerPu QInj1MinPu(start = QInj1Min0Pu) "Minimum reactive power in pu at terminal 1 (base SnRef) (generator convention)";
    Types.ReactivePowerPu QInj1MaxPu(start = QInj1Max0Pu) "Maximum reactive power in pu at terminal 1 (base SnRef) (generator convention)";
    Types.ReactivePowerPu QInj2MinPu(start = QInj2Min0Pu) "Minimum reactive power in pu at terminal 2 (base SnRef) (generator convention)";
    Types.ReactivePowerPu QInj2MaxPu(start = QInj2Max0Pu) "Maximum reactive power in pu at terminal 2 (base SnRef) (generator convention)";

  equation
    PInj1Pu = tableQInj1Min.u[1];
    QInj1MinPu = tableQInj1Min.y[1];
    PInj1Pu = tableQInj1Max.u[1];
    QInj1MaxPu = tableQInj1Max.y[1];

    PInj2Pu = tableQInj2Min.u[1];
    QInj2MinPu = tableQInj2Min.y[1];
    PInj2Pu = tableQInj2Max.u[1];
    QInj2MaxPu = tableQInj2Max.y[1];

    annotation(preferredView = "text",
      Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation. This partial model also implements PQ diagrams at each terminal of the HVDC link.</div></body></html>"));
  end BaseHvdcPDiagramPQ;

  annotation(preferredView = "text");
end BaseClasses;
