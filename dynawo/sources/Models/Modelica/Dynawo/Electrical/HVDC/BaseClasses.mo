within Dynawo.Electrical.HVDC;

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

package BaseClasses
  extends Icons.BasesPackage;

  partial model BaseDiagramPQTerminal1 "Base dynamic model for a PQ diagram at terminal 1"
    import Modelica;

    parameter String QInj1MaxTableFile "Text file that contains the table to get QInj1MaxPu from PInj1Pu (generator convention)";
    parameter String QInj1MaxTableName "Name of the table in the text file to get QInj1MaxPu from PInj1Pu (generator convention)";
    parameter String QInj1MinTableFile "Text file that contains the table to get QInj1MinPu from PInj1Pu (generator convention)";
    parameter String QInj1MinTableName "Name of the table in the text file to get QInj1MinPu from PInj1Pu (generator convention)";

    Modelica.Blocks.Tables.CombiTable1D tableQInj1Max(tableOnFile = true, tableName = QInj1MaxTableName, fileName = QInj1MaxTableFile) "Table to get QInj1MaxPu from PInj1Pu (generator convention)";
    Modelica.Blocks.Tables.CombiTable1D tableQInj1Min(tableOnFile = true, tableName = QInj1MinTableName, fileName = QInj1MinTableFile) "Table to get QInj1MinPu from PInj1Pu (generator convention)";

    Types.ReactivePowerPu QInj1MaxPu(start = QInj1Max0Pu) "Maximum reactive power at terminal 1 in pu (base SnRef) (generator convention)";
    Types.ReactivePowerPu QInj1MinPu(start = QInj1Min0Pu) "Minimum reactive power at terminal 1 in pu (base SnRef) (generator convention)";

    parameter Types.ReactivePowerPu QInj1Max0Pu "Start value of the maximum reactive power in pu (base SnRef) (generator convention) at terminal 1";
    parameter Types.ReactivePowerPu QInj1Min0Pu "Start value of the minimum reactive power in pu (base SnRef) (generator convention) at terminal 1";

  equation
    QInj1MaxPu = tableQInj1Max.y[1];
    QInj1MinPu = tableQInj1Min.y[1];

    annotation(preferredView = "text");
  end BaseDiagramPQTerminal1;

  partial model BaseDiagramPQTerminal2 "Base dynamic model for a PQ diagram at terminal 2"
    import Modelica;

    parameter String QInj2MaxTableFile "Text file that contains the table to get QInj2MaxPu from PInj2Pu (generator convention)";
    parameter String QInj2MaxTableName "Name of the table in the text file to get QInj2MaxPu from PInj2Pu (generator convention)";
    parameter String QInj2MinTableFile "Text file that contains the table to get QInj2MinPu from PInj2Pu (generator convention)";
    parameter String QInj2MinTableName "Name of the table in the text file to get QInj2MinPu from PInj2Pu (generator convention)";

    Modelica.Blocks.Tables.CombiTable1D tableQInj2Max(tableOnFile = true, tableName = QInj2MaxTableName, fileName = QInj2MaxTableFile) "Table to get QInj2MaxPu from PInj2Pu (generator convention)";
    Modelica.Blocks.Tables.CombiTable1D tableQInj2Min(tableOnFile = true, tableName = QInj2MinTableName, fileName = QInj2MinTableFile) "Table to get QInj2MinPu from PInj2Pu (generator convention)";

    Types.ReactivePowerPu QInj2MaxPu(start = QInj2Max0Pu) "Maximum reactive power at terminal 2 in pu (base SnRef) (generator convention)";
    Types.ReactivePowerPu QInj2MinPu(start = QInj2Min0Pu) "Minimum reactive power at terminal 2 in pu (base SnRef) (generator convention)";

    parameter Types.ReactivePowerPu QInj2Max0Pu "Start value of the maximum reactive power in pu (base SnRef) (generator convention) at terminal 2";
    parameter Types.ReactivePowerPu QInj2Min0Pu "Start value of the minimum reactive power in pu (base SnRef) (generator convention) at terminal 2";

  equation
    QInj2MaxPu = tableQInj2Max.y[1];
    QInj2MinPu = tableQInj2Min.y[1];

    annotation(preferredView = "text");
  end BaseDiagramPQTerminal2;

  partial model BaseFixedReactiveLimitsDangling "Base dynamic model for fixed reactive limits at terminal 1"

    parameter Types.ReactivePowerPu Q1MaxPu "Maximum reactive power in pu (base SnRef) at terminal 1 (generator convention)";
    parameter Types.ReactivePowerPu Q1MinPu "Minimum reactive power in pu (base SnRef) at terminal 1 (generator convention)";

    annotation(preferredView = "text");
  end BaseFixedReactiveLimitsDangling;

  partial model BaseFixedReactiveLimits "Base dynamic model for fixed reactive limits"
    extends BaseClasses.BaseFixedReactiveLimitsDangling;

    parameter Types.ReactivePowerPu Q2MaxPu "Maximum reactive power in pu (base SnRef) at terminal 2 (generator convention)";
    parameter Types.ReactivePowerPu Q2MinPu "Minimum reactive power in pu (base SnRef) at terminal 2 (generator convention)";

    annotation(preferredView = "text");
  end BaseFixedReactiveLimits;

  partial model BasePQPropDangling "Base dynamic model for proportional reactive power control at terminal 1"

    parameter Real QPercent1 "Percentage of the coordinated reactive control that comes from converter 1";

    input Types.PerUnit NQ1 "Signal to change the reactive power of converter 1 depending on the centralized voltage regulation (generator convention)";

    Types.ReactivePowerPu QInj1RawModeUPu "Reactive power generation of converter 1 without taking limits into account in pu and for mode U activated (base SnRef) (generator convention)";
    Types.ReactivePowerPu QInj1RawPu "Reactive power generation of converter 1 without taking limits into account in pu (base SnRef) (generator convention)";

    annotation(preferredView = "text");
  end BasePQPropDangling;

  partial model BasePQProp "Base dynamic model for proportional reactive power control"
    extends BaseClasses.BasePQPropDangling;

    parameter Real QPercent2 "Percentage of the coordinated reactive control that comes from converter 2";

    input Types.PerUnit NQ2 "Signal to change the reactive power of converter 2 depending on the centralized voltage regulation (generator convention)";

    Types.ReactivePowerPu QInj2RawModeUPu "Reactive power generation of converter 2 without taking limits into account in pu and for mode U activated (base SnRef) (generator convention)";
    Types.ReactivePowerPu QInj2RawPu "Reactive power generation of converter 2 without taking limits into account in pu (base SnRef) (generator convention)";

    annotation(preferredView = "text");
  end BasePQProp;

  partial model BasePTanPhiDangling "Base dynamic model for P/tan(Phi) control at terminal 1"

    input Real tanPhi1Ref(start = TanPhi1Ref0) "tan(Phi) regulation set point at terminal 1";

    parameter Real TanPhi1Ref0 "Start value of tan(Phi) regulation set point at terminal 1";

  protected
    Types.ReactivePowerPu QInj1RawPu "Raw reactive power at terminal 1 in pu (base SnRef) (generator convention)";

    annotation(preferredView = "text");
  end BasePTanPhiDangling;

  partial model BasePTanPhi "Base dynamic model for P/tan(Phi) control"
    extends BaseClasses.BasePTanPhiDangling;

    input Real tanPhi2Ref(start = TanPhi2Ref0) "tan(Phi) regulation set point at terminal 2";

    parameter Real TanPhi2Ref0 "Start value of tan(Phi) regulation set point at terminal 2";

  protected
    Types.ReactivePowerPu QInj2RawPu "Raw reactive power at terminal 2 in pu (base SnRef) (generator convention)";

    annotation(preferredView = "text");
  end BasePTanPhi;

  partial model BasePVDangling "Base dynamic model for PV control at terminal 1"

    parameter Types.PerUnit Lambda1Pu "Parameter Lambda of the voltage regulation law U1RefPu = U1Pu + Lambda1Pu * QInj1Pu, in pu (base UNom, SnRef) at terminal 1";
    parameter Types.ReactivePower Q1Nom "Nominal reactive power in Mvar at terminal 1";
    final parameter Boolean UseLambda1 = not(Lambda1Pu == 0) "If true, the voltage regulation follows the law U1RefPu = U1Pu + Lambda1Pu * QInj1Pu at terminal 1";

    input Types.VoltageModulePu U1RefPu(start = U1Ref0Pu) "Voltage regulation set point in pu (base UNom) at terminal 1";

    Types.ReactivePowerPu QInj1PuQNom "Reactive power at terminal 1 in pu (base Q1Nom) (generator convention)";

    parameter Types.VoltageModulePu U1Ref0Pu "Start value of the voltage regulation set point in pu (base UNom) at terminal 1";

    annotation(preferredView = "text");
  end BasePVDangling;

  partial model BasePV "Base dynamic model for PV control"
    extends BaseClasses.BasePVDangling;

    parameter Types.PerUnit Lambda2Pu "Parameter Lambda of the voltage regulation law U2RefPu = U2Pu + Lambda2Pu * QInj2Pu, in pu (base UNom, SnRef) at terminal 2";
    parameter Types.ReactivePower Q2Nom "Nominal reactive power in Mvar at terminal 2";
    final parameter Boolean UseLambda2 = not(Lambda2Pu == 0) "If true, the voltage regulation follows the law U2RefPu = U2Pu + Lambda2Pu * QInj2Pu at terminal 2";

    input Types.VoltageModulePu U2RefPu(start = U2Ref0Pu) "Voltage regulation set point in pu (base UNom) at terminal 2";

    Types.ReactivePowerPu QInj2PuQNom "Reactive power at terminal 2 in pu (base Q2Nom) (generator convention)";

    parameter Types.VoltageModulePu U2Ref0Pu "Start value of the voltage regulation set point in pu (base UNom) at terminal 2";

    annotation(preferredView = "text");
  end BasePV;

  partial model BaseQStatusDangling "Base dynamic model QStatus at terminal 1"
    import Dynawo.NonElectrical.Logs.Timeline;
    import Dynawo.NonElectrical.Logs.TimelineKeys;

    type QStatus = enumeration (Standard "Reactive power is fixed to its initial value",
                                AbsorptionMax "Reactive power is fixed to its absorption limit",
                                GenerationMax "Reactive power is fixed to its generation limit");

    Boolean limUQDown1(start = limUQDown10) "Whether the minimum reactive power limits are reached or not at terminal 1";
    Boolean limUQUp1(start = limUQUp10) "Whether the maximum reactive power limits are reached or not at terminal 1";
    QStatus q1Status(start = q1Status0) "Voltage regulation status of terminal 1: Standard, AbsorptionMax or GenerationMax";

    parameter Boolean limUQDown10 "Whether the minimum reactive power limits are reached or not at terminal 1, start value";
    parameter Boolean limUQUp10 "Whether the maximum reactive power limits are reached or not at terminal 1, start value";
    parameter QStatus q1Status0 "Start voltage regulation status of terminal 1: Standard, AbsorptionMax, GenerationMax";

  equation
    when q1Status == QStatus.AbsorptionMax and pre(q1Status) <> QStatus.AbsorptionMax then
      Timeline.logEvent1(TimelineKeys.HVDC1MinQ);
    elsewhen q1Status == QStatus.GenerationMax and pre(q1Status) <> QStatus.GenerationMax then
      Timeline.logEvent1(TimelineKeys.HVDC1MaxQ);
    elsewhen q1Status == QStatus.Standard and pre(q1Status) <> QStatus.Standard then
      Timeline.logEvent1(TimelineKeys.HVDC1BackRegulation);
    end when;

    annotation(preferredView = "text");
  end BaseQStatusDangling;

  partial model BaseQStatus "Base dynamic model QStatus"
    import Dynawo.NonElectrical.Logs.Timeline;
    import Dynawo.NonElectrical.Logs.TimelineKeys;

    extends BaseClasses.BaseQStatusDangling;

    Boolean limUQDown2(start = limUQDown20) "Whether the minimum reactive power limits are reached or not at terminal 2";
    Boolean limUQUp2(start = limUQUp20) "Whether the maximum reactive power limits are reached or not at terminal 2";
    QStatus q2Status(start = q2Status0) "Voltage regulation status of terminal 2: Standard, AbsorptionMax or GenerationMax";

    parameter Boolean limUQDown20 "Whether the minimum reactive power limits are reached or not at terminal 2, start value";
    parameter Boolean limUQUp20 "Whether the maximum reactive power limits are reached or not at terminal 2, start value";
    parameter QStatus q2Status0 "Start voltage regulation status of terminal 2: Standard, AbsorptionMax, GenerationMax";

  equation
    when q2Status == QStatus.AbsorptionMax and pre(q2Status) <> QStatus.AbsorptionMax then
      Timeline.logEvent1(TimelineKeys.HVDC2MinQ);
    elsewhen q2Status == QStatus.GenerationMax and pre(q2Status) <> QStatus.GenerationMax then
      Timeline.logEvent1(TimelineKeys.HVDC2MaxQ);
    elsewhen q2Status == QStatus.Standard and pre(q2Status) <> QStatus.Standard then
      Timeline.logEvent1(TimelineKeys.HVDC2BackRegulation);
    end when;

    annotation(preferredView = "text");
  end BaseQStatus;

  partial model BaseVoltageRegulationDangling "Base dynamic model for Hvdc voltage regulation at terminal 1"

    input Boolean modeU1(start = modeU10) "Boolean assessing the mode of the control of converter 1: true if U mode (here a proportional Q regulation), false if Q mode (fixed Q)";
    input Types.ReactivePowerPu Q1RefPu(start = Q1Ref0Pu) "Reactive power regulation set point in pu (base SnRef) (receptor convention) at terminal 1";

    parameter Boolean modeU10 "Start value of the boolean assessing the mode of the control of converter 1";
    parameter Types.ReactivePowerPu Q1Ref0Pu "Start value of reactive power regulation set point in pu (base SnRef) (receptor convention) at terminal 1";

    annotation(preferredView = "text");
  end BaseVoltageRegulationDangling;

  partial model BaseVoltageRegulation "Base dynamic model for Hvdc voltage regulation"
    extends BaseClasses.BaseVoltageRegulationDangling;

    input Boolean modeU2(start = modeU20) "Boolean assessing the mode of the control of converter 2: true if U mode (here a proportional Q regulation), false if Q mode (fixed Q)";
    input Types.ReactivePowerPu Q2RefPu(start = Q2Ref0Pu) "Reactive power regulation set point in pu (base SnRef) (receptor convention) at terminal 2";

    parameter Boolean modeU20 "Start value of the boolean assessing the mode of the control of converter 2";
    parameter Types.ReactivePowerPu Q2Ref0Pu "Start value of reactive power regulation set point in pu (base SnRef) (receptor convention) at terminal 2";

    annotation(preferredView = "text");
  end BaseVoltageRegulation;

  partial model BaseHvdc "Base dynamic model for HVDC links"
    import Dynawo.Connectors;
    import Dynawo.Electrical.Controls.Basics.SwitchOff;
    import Dynawo.NonElectrical.Logs.Timeline;
    import Dynawo.NonElectrical.Logs.TimelineKeys;

    extends SwitchOff.SwitchOffDCLine;
    extends AdditionalIcons.Hvdc;

  /*
    Equivalent circuit and conventions:

                 I1                  I2
     (terminal1) -->-------HVDC-------<-- (terminal2)

  */

    parameter Real KLosses "Losses coefficient between 0 and 1 : 1 if no loss in the HVDC link, < 1 otherwise";
    parameter Types.ActivePowerPu PMaxPu "Maximum active power in pu (base SnRef) flowing through the HVDC link";

    type PStatus = enumeration(Standard, LimitPMax);

    input Types.ActivePowerPu P1RefPu(start = P1Ref0Pu) "Active power regulation set point in pu (base SnRef) at terminal 1 (receptor convention)";
    Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) annotation(
      Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Connectors.ACPower terminal2 annotation(
        Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

    Types.ActivePowerPu P1Pu(start = s10Pu.re) "Active power at terminal 1 in pu (base SnRef) (receptor convention)";
    Types.ActivePowerPu P2Pu(start = 0) "Active power at terminal 2 in pu (base SnRef) (receptor convention)";
    Types.ActivePowerPu PInj1Pu(start = - s10Pu.re) "Active power at terminal 1 in pu (base SnRef) (generator convention)";
    Types.ActivePowerPu PInj2Pu(start = 0) "Active power at terminal 2 in pu (base SnRef) (generator convention)";
    PStatus pStatus(start = PStatus.Standard) "Status of the active power function";
    Types.ReactivePowerPu Q1Pu(start = s10Pu.im) "Reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
    Types.ReactivePowerPu Q2Pu(start = 0) "Reactive power at terminal 2 in pu (base SnRef) (receptor convention)";
    Types.ReactivePowerPu QInj1Pu(start = - s10Pu.im) "Reactive power at terminal 1 in pu (base SnRef) (generator convention)";
    Types.ReactivePowerPu QInj2Pu(start = 0) "Reactive power at terminal 2 in pu (base SnRef) (generator convention)";
    Types.ComplexApparentPowerPu s1Pu(re(start = s10Pu.re), im(start = s10Pu.im)) "Complex apparent power at terminal 1 in pu (base SnRef) (receptor convention)";
    Types.VoltageModulePu U1Pu(start = ComplexMath.'abs'(u10Pu)) "Voltage amplitude at terminal 1 in pu (base UNom)";

    parameter Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base UNom, SnRef) (receptor convention)";
    parameter Types.ActivePowerPu P1Ref0Pu "Start value of active power reference at terminal 1 in pu (base SnRef) (receptor convention)";
    parameter Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in pu (base SnRef) (receptor convention)";
    parameter Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base UNom)";

  equation
    when (P1RefPu >= PMaxPu or P1RefPu <= -PMaxPu) and pre(pStatus) <> PStatus.LimitPMax then
      pStatus = PStatus.LimitPMax;
      Timeline.logEvent1(TimelineKeys.HVDCMaxP);
    elsewhen (P1RefPu < PMaxPu and P1RefPu > -PMaxPu) and pre(pStatus) == PStatus.LimitPMax then
      pStatus = PStatus.Standard;
      Timeline.logEvent1(TimelineKeys.HVDCDeactivateMaxP);
    end when;

    s1Pu = Complex(P1Pu, Q1Pu);
    s1Pu = terminal1.V * ComplexMath.conj(terminal1.i);

    //Sign convention change
    PInj1Pu = - P1Pu;
    PInj2Pu = - P2Pu;
    QInj1Pu = - Q1Pu;
    QInj2Pu = - Q2Pu;

    annotation(preferredView = "text");
  end BaseHvdc;

  partial model BaseHvdcP "Base dynamic model for HVDC links with a regulation of the active power"
    import Modelica;

    extends BaseHvdc(P2Pu(start = s20Pu.re), PInj2Pu(start = - s20Pu.re), Q2Pu(start = s20Pu.im), QInj2Pu(start = - s20Pu.im), terminal2(V(re(start = u20Pu.re), im(start = u20Pu.im)), i(re(start = i20Pu.re), im(start = i20Pu.im))));

  /*
    Equivalent circuit and conventions:

                 I1                  I2
     (terminal1) -->-------HVDC-------<-- (terminal2)

  */

    Types.ComplexApparentPowerPu s2Pu(re(start = s20Pu.re), im(start = s20Pu.im)) "Complex apparent power at terminal 2 in pu (base SnRef) (receptor convention)";
    Types.Angle Theta1(start = UPhase10) "Angle of the voltage at terminal 1 in rad";
    Types.Angle Theta2(start = UPhase20) "Angle of the voltage at terminal 2 in rad";
    Types.VoltageModulePu U2Pu(start = ComplexMath.'abs'(u20Pu)) "Voltage amplitude at terminal 2 in pu (base UNom)";

    parameter Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 in pu (base UNom, SnRef) (receptor convention)";
    parameter Types.ComplexApparentPowerPu s20Pu "Start value of complex apparent power at terminal 2 in pu (base SnRef) (receptor convention)";
    parameter Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2 in pu (base UNom)";
    parameter Types.Angle UPhase10 "Start value of voltage angle and filtered voltage angle at terminal 1 in rad";
    parameter Types.Angle UPhase20 "Start value of voltage angle and filtered voltage angle at terminal 2 in rad";

  equation
    U1Pu = ComplexMath.'abs'(terminal1.V);
    U2Pu = ComplexMath.'abs'(terminal2.V);
    s2Pu = Complex(P2Pu, Q2Pu);
    s2Pu = terminal2.V * ComplexMath.conj(terminal2.i);
    Theta1 = Modelica.Math.atan2(terminal1.V.im, terminal1.V.re);
    Theta2 = Modelica.Math.atan2(terminal2.V.im, terminal2.V.re);

    if running.value then
      P1Pu = max(min(PMaxPu, P1RefPu), - PMaxPu);
      P2Pu = if P1Pu > 0 then - KLosses * P1Pu else - P1Pu / KLosses;
    else
      P1Pu = 0;
      P2Pu = 0;
    end if;

    annotation(preferredView = "text",
      Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation.</div></body></html>"));
  end BaseHvdcP;

  partial model BaseHvdcPDiagramPQ "Base dynamic model for HVDC links with a regulation of the active power and with a PQ Diagram at each terminal"
    extends BaseHvdcP;
    extends BaseDiagramPQTerminal1;
    extends BaseDiagramPQTerminal2;

  equation
    PInj1Pu = tableQInj1Min.u[1];
    PInj1Pu = tableQInj1Max.u[1];
    PInj2Pu = tableQInj2Min.u[1];
    PInj2Pu = tableQInj2Max.u[1];

    annotation(preferredView = "text",
      Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation. This partial model also implements PQ diagrams at each terminal of the HVDC link.</div></body></html>"));
  end BaseHvdcPDiagramPQ;

  partial model BaseHvdcPFixedReactiveLimits "Base dynamic model for HVDC links with a regulation of the active power and with fixed reactive power limits"
    extends BaseHvdcP;
    extends BaseFixedReactiveLimits;

    annotation(preferredView = "text",
      Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation.</div></body></html>"));
  end BaseHvdcPFixedReactiveLimits;

  partial model BaseHvdcPDangling "Base dynamic model for HVDC links with a regulation of the active power and with terminal2 connected to a switched-off bus"
    extends BaseHvdc;

  /*
    Equivalent circuit and conventions:

                 I1                  I2 = 0
     (terminal1) -->-------HVDC-------<-- (switched-off terminal2)

  */

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

    annotation(preferredView = "text",
      Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation. The terminal2 is connected to a switched-off bus.</div></body></html>"));
  end BaseHvdcPDangling;

  partial model BaseHvdcPDanglingDiagramPQ "Base dynamic model for HVDC links with a regulation of the active power and with terminal2 connected to a switched-off bus. The reactive power limits are given by a PQ diagram."
    extends BaseHvdcPDangling;
    extends BaseDiagramPQTerminal1;

  equation
    PInj1Pu = tableQInj1Min.u[1];
    PInj1Pu = tableQInj1Max.u[1];

    annotation(preferredView = "text",
      Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation. The terminal2 is connected to a switched-off bus. This partial model also implements the PQ diagram at terminal1.</div></body></html>"));
  end BaseHvdcPDanglingDiagramPQ;

  partial model BaseHvdcPDanglingFixedReactiveLimits "Base dynamic model for HVDC links with a regulation of the active power and with fixed reactive power limits"
    extends BaseHvdcPDangling;
    extends BaseFixedReactiveLimitsDangling;

    annotation(preferredView = "text",
      Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation. The terminal2 is connected to a switched-off bus.</div></body></html>"));
  end BaseHvdcPDanglingFixedReactiveLimits;

  annotation(preferredView = "text");
end BaseClasses;
