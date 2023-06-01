within Dynawo.Electrical.Machines.SignalN;

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

  partial model BaseTfo "Base dynamic model for generator transformer"

    parameter Types.ApparentPowerModule SNom "Nominal apparent power of the generator in MVA";
    parameter Types.PerUnit XTfoPu "Reactance of the generator transformer in pu (base UNom, SNom)";

    input Types.VoltageModulePu UStatorRefPu(start = UStatorRef0Pu) "Voltage regulation set point at stator in pu (base UNom)";

    Types.ComplexCurrentPu iStatorPu(re(start = iStator0Pu.re), im(start = iStator0Pu.im)) "Complex current at stator in pu (base UNom, SNom) (generator convention)";
    Types.ComplexApparentPowerPu sStatorPu(re(start = sStator0Pu.re), im(start = sStator0Pu.im)) "Complex apparent power at stator in pu (base UNom, SNom) (generator convention)";
    Types.ComplexVoltagePu uStatorPu(re(start = uStator0Pu.re), im(start = uStator0Pu.im)) "Complex voltage at stator in pu (base UNom)";
    Types.VoltageModulePu UStatorPu(start = UStator0Pu) "Voltage module at stator in pu (base UNom)";

    parameter Types.ComplexCurrentPu iStator0Pu "Start value of complex current at stator in pu (base UNom, SNom) (generator convention)";
    parameter Types.ReactivePowerPu QStator0Pu "Start value of stator reactive power in pu (base QNomAlt) (generator convention)";
    parameter Types.ComplexApparentPowerPu sStator0Pu "Start value of complex apparent power at stator in pu (base UNom, SNom) (generator convention)";
    parameter Types.ComplexVoltagePu uStator0Pu "Start value of complex voltage at stator in pu (base UNom)";
    parameter Types.VoltageModulePu UStator0Pu "Start value of voltage module at stator in pu (base UNom)";
    parameter Types.VoltageModulePu UStatorRef0Pu "Start value of voltage regulation set point at stator in pu (base UNom)";

    annotation(preferredView = "text");
  end BaseTfo;

  partial model BaseQStator "Base dynamic model for the calculation of QStatorPu in pu (base QNomAlt)"

    parameter Types.ReactivePower QNomAlt "Nominal reactive power of the generator on alternator side in Mvar";

    Types.ReactivePowerPu QStatorPu "Stator reactive power in pu (base QNomAlt) (generator convention)";

    annotation(preferredView = "text");
  end BaseQStator;

  partial model BaseDiagramPQ "Base dynamic model for a PQ diagram"
    import Modelica;

    parameter String QMaxTableFile "Text file that contains the table to get QMaxPu from PGenPu";
    parameter String QMaxTableName "Name of the table in the text file to get QMaxPu from PGenPu";
    parameter String QMinTableFile "Text file that contains the table to get QMinPu from PGenPu";
    parameter String QMinTableName "Name of the table in the text file to get QMinPu from PGenPu";

    Types.ReactivePowerPu QMaxPu(start = QMax0Pu) "Maximum reactive power in pu (base SnRef)";
    Types.ReactivePowerPu QMinPu(start = QMin0Pu) "Minimum reactive power in pu (base SnRef)";

    Modelica.Blocks.Tables.CombiTable1D tableQMax(tableOnFile = true, tableName = QMaxTableName, fileName = QMaxTableFile) "Table to get QMaxPu from PGenPu";
    Modelica.Blocks.Tables.CombiTable1D tableQMin(tableOnFile = true, tableName = QMinTableName, fileName = QMinTableFile) "Table to get QMinPu from PGenPu";

    parameter Types.ReactivePowerPu QMax0Pu "Start value of the maximum reactive power in pu (base SnRef)";
    parameter Types.ReactivePowerPu QMin0Pu "Start value of the minimum reactive power in pu (base SnRef)";

  equation
    QMaxPu = tableQMax.y[1];
    QMinPu = tableQMin.y[1];

    annotation(preferredView = "text");
  end BaseDiagramPQ;

  partial model BaseFixedReactiveLimits "Base dynamic model for fixed reactive limits"

    parameter Types.ReactivePowerPu QMaxPu "Maximum reactive power in pu (base SnRef)";
    parameter Types.ReactivePowerPu QMinPu "Minimum reactive power in pu (base SnRef)";

    annotation(preferredView = "text");
  end BaseFixedReactiveLimits;

  partial model BasePQProp "Base dynamic model for a proportional reactive power regulation"

    parameter Real QPercent "Percentage of the coordinated reactive control that comes from this machine";

    input Types.PerUnit NQ "Signal to change the reactive power generation of the generator depending on the centralized distant voltage regulation (generator convention)";

    parameter Types.ReactivePowerPu QRef0Pu "Start value of the reactive power set point in pu (base SnRef) (receptor convention)";

  protected
    Types.ReactivePowerPu QGenRawPu "Reactive power generation without taking limits into account in pu (base SnRef) (generator convention)";

  equation
    QGenRawPu = - QRef0Pu + QPercent * NQ;

    annotation(preferredView = "text");
  end BasePQProp;

  partial model BasePV "Base dynamic model for a voltage regulation"

    input Types.VoltageModulePu URefPu(start = URef0Pu) "Voltage regulation set point in pu (base UNom)";

    parameter Types.VoltageModulePu URef0Pu "Start value of the voltage regulation set point in pu (base UNom)";

    annotation(preferredView = "text");
  end BasePV;

  partial model BasePVProp "Base dynamic model for a proportional voltage regulation"
    extends BaseClasses.BasePV;

    parameter Types.PerUnit KVoltage "Parameter of the proportional voltage regulation";

    parameter Types.ReactivePowerPu QRef0Pu "Start value of the reactive power set point in pu (base SnRef) (receptor convention)";

    annotation(preferredView = "text");
  end BasePVProp;

  partial model BasePVRemote "Base dynamic model for a remote voltage regulation"

    input Types.VoltageModule URef(start = URef0) "Voltage regulation set point in kV";
    input Types.VoltageModule URegulated(start = URegulated0) "Regulated voltage in kV";

    parameter Types.VoltageModule URef0 "Start value of the voltage regulation set point in kV";
    parameter Types.VoltageModule URegulated0 "Start value of the regulated voltage in kV";

    annotation(preferredView = "text");
  end BasePVRemote;

  partial model BaseGenerator "Base dynamic model for generators based on SignalN for the frequency handling"
    import Dynawo.Electrical.Machines;
    import Dynawo.NonElectrical.Logs.Timeline;
    import Dynawo.NonElectrical.Logs.TimelineKeys;

    extends AdditionalIcons.Machine;
    extends Machines.BaseClasses.BaseGeneratorSimplified;

    parameter Types.PerUnit KGover "Mechanical power sensitivity to frequency";
    parameter Types.ActivePowerPu PMaxPu "Maximum active power in pu (base SnRef)";
    parameter Types.ActivePowerPu PMinPu "Minimum active power in pu (base SnRef)";
    parameter Types.ActivePower PNom "Nominal power in MW";

    final parameter Real Alpha = PNom * KGover "Participation of the considered generator in the primary frequency regulation";

    type PStatus = enumeration(Standard, LimitPMin, LimitPMax);
    type QStatus = enumeration(Standard, AbsorptionMax, GenerationMax);

    input Types.PerUnit N "Signal to change the active power reference setpoint of the generators participating in the primary frequency regulation in pu (base SnRef)";
    input Types.ActivePowerPu PRefPu(start = PRef0Pu) "Active power set point in pu (base Snref) (receptor convention)";

    Boolean limUQDown(start = limUQDown0) "Whether the minimum reactive power limits are reached or not (from generator voltage regulator)";
    Boolean limUQUp(start = limUQUp0) "Whether the maximum reactive power limits are reached or not (from generator voltage regulator)";

    parameter Boolean limUQDown0 "Whether the minimum reactive power limits are reached or not (from generator voltage regulator), start value";
    parameter Boolean limUQUp0 "Whether the maximum reactive power limits are reached or not (from generator voltage regulator), start value";
    parameter Types.ActivePowerPu PRef0Pu "Start value of the active power set point in pu (base SnRef) (receptor convention)";
    parameter QStatus qStatus0 "Start voltage regulation status: Standard, AbsorptionMax, GenerationMax";

  protected
    Types.ActivePowerPu PGenRawPu(start = PGen0Pu) "Active power generation without taking limits into account in pu (base SnRef) (generator convention)";
    PStatus pStatus(start = PStatus.Standard) "Active power / frequency regulation status: Standard, LimitPMin, LimitPMax";
    QStatus qStatus(start = qStatus0) "Voltage regulation status: Standard, AbsorptionMax, GenerationMax";

  equation
    when PGenRawPu >= PMaxPu and pre(pStatus) <> PStatus.LimitPMax then
      pStatus = PStatus.LimitPMax;
      Timeline.logEvent1(TimelineKeys.ActivatePMAX);
    elsewhen PGenRawPu <= PMinPu and pre(pStatus) <> PStatus.LimitPMin then
      pStatus = PStatus.LimitPMin;
      Timeline.logEvent1(TimelineKeys.ActivatePMIN);
    elsewhen PGenRawPu > PMinPu and pre(pStatus) == PStatus.LimitPMin then
      pStatus = PStatus.Standard;
      Timeline.logEvent1(TimelineKeys.DeactivatePMIN);
    elsewhen PGenRawPu < PMaxPu and pre(pStatus) == PStatus.LimitPMax then
      pStatus = PStatus.Standard;
      Timeline.logEvent1(TimelineKeys.DeactivatePMAX);
    end when;

    when qStatus == QStatus.AbsorptionMax and pre(qStatus) <> QStatus.AbsorptionMax then
      Timeline.logEvent1(TimelineKeys.GeneratorMinQ);
    elsewhen qStatus == QStatus.GenerationMax and pre(qStatus) <> QStatus.GenerationMax then
      Timeline.logEvent1(TimelineKeys.GeneratorMaxQ);
    elsewhen qStatus == QStatus.Standard and pre(qStatus) <> QStatus.Standard then
      Timeline.logEvent1(TimelineKeys.GeneratorBackRegulation);
    end when;

    if running.value then
      PGenPu = if PGenRawPu >= PMaxPu then PMaxPu elseif PGenRawPu <= PMinPu then PMinPu else PGenRawPu;
    else
      terminal.i.re = 0;
    end if;

    annotation(preferredView = "text");
  end BaseGenerator;

  partial model BaseGeneratorSignalN "Base dynamic model for generators based on SignalN for the frequency handling and that do not participate in the Secondary Frequency Regulation (SFR)"
    extends BaseClasses.BaseGenerator;

  equation
    if running.value then
      PGenRawPu = - PRefPu + Alpha * N;
    else
      PGenRawPu = 0;
    end if;

    annotation(preferredView = "text");
  end BaseGeneratorSignalN;

  partial model BaseGeneratorSignalNSFR "Base dynamic model for generators based on SignalN for the frequency handling and that participate in the Secondary Frequency Regulation (SFR)"
    extends BaseClasses.BaseGenerator;

    parameter Types.PerUnit KSFR "Coefficient of participation in the secondary frequency regulation";

    final parameter Real AlphaSFR = PNom * KSFR "Participation of the considered generator in the secondary frequency regulation";

    input Types.PerUnit NSFR "Signal to change the active power reference setpoint of the generators participating in the secondary frequency regulation in pu (base SnRef)";

  equation
    if running.value then
      PGenRawPu = - PRefPu + Alpha * N + AlphaSFR * NSFR;
    else
      PGenRawPu = 0;
    end if;

    annotation(preferredView = "text");
  end BaseGeneratorSignalNSFR;

  partial model BaseGeneratorSignalNDiagramPQ "Base dynamic model for generators based on SignalN for the frequency handling with a PQ diagram and that do not participate in the Secondary Frequency Regulation (SFR)"
    extends BaseClasses.BaseGeneratorSignalN;
    extends BaseClasses.BaseDiagramPQ;

  equation
    PGenPu = tableQMin.u[1];
    PGenPu = tableQMax.u[1];

    annotation(preferredView = "text");
  end BaseGeneratorSignalNDiagramPQ;

  partial model BaseGeneratorSignalNSFRDiagramPQ "Base dynamic model for generators based on SignalN for the frequency handling with a PQ diagram and that participate in the Secondary Frequency Regulation (SFR)"
    extends BaseClasses.BaseGeneratorSignalNSFR;
    extends BaseClasses.BaseDiagramPQ;

  equation
    PGenPu = tableQMin.u[1];
    PGenPu = tableQMax.u[1];

    annotation(preferredView = "text");
  end BaseGeneratorSignalNSFRDiagramPQ;

  partial model BaseGeneratorSignalNFixedReactiveLimits "Base dynamic model for generators based on SignalN for the frequency handling with fixed reactive limits and that do not participate in the Secondary Frequency Regulation (SFR)"
    extends BaseClasses.BaseGeneratorSignalN;
    extends BaseClasses.BaseFixedReactiveLimits;

    annotation(preferredView = "text");
  end BaseGeneratorSignalNFixedReactiveLimits;

  partial model BaseGeneratorSignalNSFRFixedReactiveLimits "Base dynamic model for generators based on SignalN for the frequency handling with fixed reactive limits and that participate in the Secondary Frequency Regulation (SFR)"
    extends BaseClasses.BaseGeneratorSignalNSFR;
    extends BaseClasses.BaseFixedReactiveLimits;

    annotation(preferredView = "text");
  end BaseGeneratorSignalNSFRFixedReactiveLimits;


  annotation(preferredView = "text");
end BaseClasses;
