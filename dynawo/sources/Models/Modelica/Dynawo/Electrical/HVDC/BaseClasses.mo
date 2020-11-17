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
    import Modelica;
    import Dynawo.Connectors;
    import Dynawo.Electrical.Controls.Basics.SwitchOff;

    extends SwitchOff.SwitchOffDCLine;

  /*
    Equivalent circuit and conventions:

                 I1                  I2
     (terminal1) -->-------HVDC-------<-- (terminal2)

  */

    Connectors.ACPower terminal1 (V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Connectors.ACPower terminal2 (V(re(start = u20Pu.re), im(start = u20Pu.im)), i(re(start = i20Pu.re), im(start = i20Pu.im))) annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

    parameter Real KLosses "Coefficient between 0 and 1 (no loss) modelling the losses in the HVDC";

    input Types.ActivePowerPu P1RefPu (start = s10Pu.re) "Active power regulation set point in p.u (base SnRef) at terminal 1";

  protected

    parameter Types.ComplexVoltagePu u10Pu  "Start value of complex voltage at terminal 1 in p.u (base UNom)";
    parameter Types.ComplexCurrentPu i10Pu  "Start value of complex current at terminal 1 in p.u (base UNom, SnRef) (receptor convention)";
    parameter Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in p.u (base SnRef) (receptor convention)";
    parameter Types.ComplexVoltagePu u20Pu  "Start value of complex voltage at terminal 2 in p.u (base UNom)";
    parameter Types.ComplexCurrentPu i20Pu  "Start value of complex current at terminal 2 in p.u (base UNom, SnRef) (receptor convention)";
    parameter Types.ComplexApparentPowerPu s20Pu "Start value of complex apparent power at terminal 2 in p.u (base SnRef) (receptor convention)";

    Types.ActivePowerPu P1Pu (start = s10Pu.re) "Active power at terminal 1 in p.u (base SnRef) (receptor convention)";
    Types.ActivePowerPu P2Pu (start = s20Pu.re) "Active power at terminal 2 in p.u (base SnRef) (receptor convention)";
    Types.ActivePowerPu PInj1Pu (start = - s10Pu.re) "Active power at terminal 1 in p.u (base SnRef) (generator convention)";
    Types.ActivePowerPu PInj2Pu (start = - s20Pu.re) "Active power at terminal 2 in p.u (base SnRef) (generator convention)";
    Types.VoltageModulePu U1Pu (start = ComplexMath.'abs'(u10Pu)) "Voltage amplitude at terminal 1 in p.u (base UNom)";
    Types.VoltageModulePu U2Pu (start = ComplexMath.'abs'(u20Pu)) "Voltage amplitude at terminal 2 in p.u (base UNom)";
    Types.ComplexApparentPowerPu s1Pu(re (start = s10Pu.re), im (start = s10Pu.im)) "Complex apparent power at terminal 1 in p.u (base SnRef) (receptor convention)";
    Types.ComplexApparentPowerPu s2Pu(re (start = s20Pu.re), im (start = s20Pu.im)) "Complex apparent power at terminal 2 in p.u (base SnRef) (receptor convention)";
    Types.ReactivePowerPu Q1Pu (start = s10Pu.im) "Reactive power at terminal 1 in p.u (base SnRef) (receptor convention)";
    Types.ReactivePowerPu Q2Pu (start = s20Pu.im) "Reactive power at terminal 2 in p.u (base SnRef) (receptor convention)";
    Types.ReactivePowerPu QInj1Pu (start = - s10Pu.im) "Reactive power at terminal 1 in p.u (base SnRef) (generator convention)";
    Types.ReactivePowerPu QInj2Pu (start = - s20Pu.im) "Reactive power at terminal 2 in p.u (base SnRef) (generator convention)";

  equation

    U1Pu = ComplexMath.'abs'(terminal1.V);
    U2Pu = ComplexMath.'abs'(terminal2.V);
    s1Pu = Complex(P1Pu, Q1Pu);
    s1Pu = terminal1.V * ComplexMath.conj(terminal1.i);
    s2Pu = Complex(P2Pu, Q2Pu);
    s2Pu = terminal2.V * ComplexMath.conj(terminal2.i);

    if (running.value) then
      P1Pu = P1RefPu;
      P2Pu = if P1Pu > 0 then - KLosses * P1Pu else - P1Pu / KLosses;
    else
      P1Pu = 0;
      P2Pu = 0;
    end if;

// Sign convention change
    PInj1Pu = - P1Pu;
    PInj2Pu = - P2Pu;
    QInj1Pu = - Q1Pu;
    QInj2Pu = - Q2Pu;

annotation(preferredView = "text",
      Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation.</div></body></html>"));
  end BaseHvdcP;

  partial model BaseHvdcPDangling "Base dynamic model for HVDC links with a regulation of the active power and with terminal2 connected to a switched-off bus"
    import Modelica;
    import Dynawo.Connectors;
    import Dynawo.Electrical.Controls.Basics.SwitchOff;

    extends SwitchOff.SwitchOffDCLine;

  /*
    Equivalent circuit and conventions:

                 I1                  I2 = 0
     (terminal1) -->-------HVDC-------<-- (switched-off terminal2)

  */

    Connectors.ACPower terminal1 (V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) annotation(
        Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Connectors.ACPower terminal2 annotation(
        Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    input Types.ActivePowerPu P1RefPu (start = s10Pu.re) "Active power regulation set point in p.u (base SnRef) at terminal 1";

    parameter Types.ReactivePowerPu Q1MinPu  "Minimum reactive power in p.u (base SnRef) at terminal 1";
    parameter Types.ReactivePowerPu Q1MaxPu  "Maximum reactive power in p.u (base SnRef) at terminal 1";
    parameter Types.ReactivePowerPu Q2MinPu  "Minimum reactive power in p.u (base SnRef) at terminal 2";
    parameter Types.ReactivePowerPu Q2MaxPu  "Maximum reactive power in p.u (base SnRef) at terminal 2";
    parameter Real KLosses "Coefficient between 0 and 1 (no loss) modelling the losses in the HVDC";

  protected

    parameter Types.ComplexVoltagePu u10Pu  "Start value of complex voltage at terminal 1 in p.u (base UNom)";
    parameter Types.ComplexCurrentPu i10Pu  "Start value of complex current at terminal 1 in p.u (base UNom, SnRef) (receptor convention)";
    parameter Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in p.u (base SnRef) (receptor convention)";

    Types.ActivePowerPu P1Pu (start = s10Pu.re) "Active power at terminal 1 in p.u (base SnRef) (receptor convention)";
    Types.ActivePowerPu P2Pu (start = 0) "Active power at terminal 2 in p.u (base SnRef) (receptor convention)";
    Types.ActivePowerPu PInj1Pu (start = - s10Pu.re) "Active power at terminal 1 in p.u (base SnRef) (generator convention)";
    Types.ActivePowerPu PInj2Pu (start = 0) "Active power at terminal 2 in p.u (base SnRef) (generator convention)";
    Types.VoltageModulePu U1Pu (start = ComplexMath.'abs'(u10Pu)) "Voltage amplitude at terminal 1 in p.u (base UNom)";
    Types.ComplexApparentPowerPu s1Pu(re (start = s10Pu.re), im (start = s10Pu.im)) "Complex apparent power at terminal 1 in p.u (base SnRef) (receptor convention)";
    Types.ReactivePowerPu Q1Pu (start = s10Pu.im) "Reactive power at terminal 1 in p.u (base SnRef) (receptor convention)";
    Types.ReactivePowerPu Q2Pu (start = 0) "Reactive power at terminal 2 in p.u (base SnRef) (receptor convention)";
    Types.ReactivePowerPu QInj1Pu (start = - s10Pu.im) "Reactive power at terminal 1 in p.u (base SnRef) (generator convention)";
    Types.ReactivePowerPu QInj2Pu (start = 0) "Reactive power at terminal 2 in p.u (base SnRef) (generator convention)";

  equation

  // Connected side
    U1Pu = ComplexMath.'abs'(terminal1.V);
    s1Pu = Complex(P1Pu, Q1Pu);
    s1Pu = terminal1.V * ComplexMath.conj(terminal1.i);
    P1Pu = P1RefPu;

  // Disconnected side
    P2Pu = 0;
    Q2Pu = 0;
    terminal2.i.re = 0;
    terminal2.i.im = 0;

  // Sign convention change
    PInj1Pu = - P1Pu;
    PInj2Pu = - P2Pu;
    QInj1Pu = - Q1Pu;
    QInj2Pu = - Q2Pu;

  annotation(preferredView = "text",
      Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation. The terminal2 is connected to a switched-off bus.</div></body></html>"));
  end BaseHvdcPDangling;

  partial model BaseHvdcPDiagramPQ "Base dynamic model for HVDC links with a regulation of the active power and with a PQ Diagram at each terminal"
  import Modelica;
  extends BaseHvdcP;

    parameter Types.ReactivePowerPu Q1Min0Pu  "Start value of the minimum reactive power in p.u (base SnRef) (receptor convention) at terminal 1";
    parameter Types.ReactivePowerPu Q1Max0Pu  "Start value of the maximum reactive power in p.u (base SnRef) (receptor convention) at terminal 1";
    parameter Types.ReactivePowerPu Q2Min0Pu  "Start value of the minimum reactive power in p.u (base SnRef) (receptor convention) at terminal 2";
    parameter Types.ReactivePowerPu Q2Max0Pu  "Start value of the maximum reactive power in p.u (base SnRef) (receptor convention) at terminal 2";
    parameter Types.Time tFilter "Filter time constant to update QMin/QMax";
    parameter String Q1MinTableName "Name of the table in the text file to get Q1MinPu from P1Pu";
    parameter String Q1MaxTableName "Name of the table in the text file to get Q1MaxPu from P1Pu";
    parameter String Q1MinTableFile "Text file that contains the table to get Q1MinPu from P1Pu";
    parameter String Q1MaxTableFile "Text file that contains the table to get Q1MaxPu from P1Pu";
    parameter String Q2MinTableName "Name of the table in the text file to get Q2MinPu from P2Pu";
    parameter String Q2MaxTableName "Name of the table in the text file to get Q2MaxPu from P2Pu";
    parameter String Q2MinTableFile "Text file that contains the table to get Q2MinPu from P2Pu";
    parameter String Q2MaxTableFile "Text file that contains the table to get Q2MaxPu from P2Pu";

    Modelica.Blocks.Tables.CombiTable1D tableQ1Min(tableOnFile = true, tableName = Q1MinTableName, fileName = Q1MinTableFile) "Table to get Q1MinPu from P1Pu";
    Modelica.Blocks.Tables.CombiTable1D tableQ1Max(tableOnFile = true, tableName = Q1MaxTableName, fileName = Q1MaxTableFile) "Table to get Q1MaxPu from P1Pu";
    Modelica.Blocks.Tables.CombiTable1D tableQ2Min(tableOnFile = true, tableName = Q2MinTableName, fileName = Q2MinTableFile) "Table to get Q2MinPu from P2Pu";
    Modelica.Blocks.Tables.CombiTable1D tableQ2Max(tableOnFile = true, tableName = Q2MaxTableName, fileName = Q2MaxTableFile) "Table to get Q2MaxPu from P2Pu";

    Types.ReactivePowerPu Q1MinPu(start = Q1Min0Pu) "Minimum reactive power in p.u at terminal 1 (base SnRef) (receptor convention)";
    Types.ReactivePowerPu Q1MaxPu(start = Q1Max0Pu) "Maximum reactive power in p.u at terminal 1 (base SnRef) (receptor convention)";
    Types.ReactivePowerPu Q2MinPu(start = Q2Min0Pu) "Minimum reactive power in p.u at terminal 2 (base SnRef) (receptor convention)";
    Types.ReactivePowerPu Q2MaxPu(start = Q2Max0Pu) "Maximum reactive power in p.u at terminal 2 (base SnRef) (receptor convention)";

  equation
    P1Pu = tableQ1Min.u[1];
    tFilter * der(Q1MinPu) + Q1MinPu = tableQ1Min.y[1];
    P1Pu = tableQ1Max.u[1];
    tFilter * der(Q1MaxPu) + Q1MaxPu = tableQ1Max.y[1];

    P2Pu = tableQ2Min.u[1];
    tFilter * der(Q2MinPu) + Q2MinPu = tableQ2Min.y[1];
    P2Pu = tableQ2Max.u[1];
    tFilter * der(Q2MaxPu) + Q2MaxPu = tableQ2Max.y[1];

  annotation(preferredView = "text",
      Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation. This partial model also implements PQ diagrams at each terminal of the HVDC link.</div></body></html>"));
  end BaseHvdcPDiagramPQ;

  annotation(preferredView = "text");
end BaseClasses;
