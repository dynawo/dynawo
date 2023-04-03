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

  partial model BaseGeneratorSignalN "Base dynamic model for generators based on SignalN for the frequency handling"
    import Dynawo.Electrical.Machines;
    import Dynawo.NonElectrical.Logs.Timeline;
    import Dynawo.NonElectrical.Logs.TimelineKeys;

    extends Machines.BaseClasses.BaseGeneratorSimplified;

    type PStatus = enumeration(Standard, LimitPMin, LimitPMax);

    parameter Types.ActivePowerPu PRef0Pu "Start value of the active power set point in pu (base SnRef) (receptor convention)";
    parameter Types.ActivePowerPu PMinPu "Minimum active power in pu (base SnRef)";
    parameter Types.ActivePowerPu PMaxPu "Maximum active power in pu (base SnRef)";
    parameter Types.PerUnit KGover "Mechanical power sensitivity to frequency";
    parameter Types.ActivePower PNom "Nominal power in MW";
    final parameter Real Alpha = PNom * KGover "Participation of the considered generator in the primary frequency regulation";

    input Types.PerUnit N "Signal to change the active power reference setpoint of the generators participating in the primary frequency regulation in pu (base SnRef)";
    input Types.ActivePowerPu PRefPu(start = PRef0Pu) "Active power set point in pu (base Snref) (receptor convention)";

  protected
    Types.ActivePowerPu PGenRawPu(start = PGen0Pu) "Active power generation without taking limits into account in pu (base SnRef) (generator convention)";
    PStatus pStatus(start = PStatus.Standard) "Status of the power / frequency regulation function";

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

    if running.value then
      PGenRawPu = - PRefPu + Alpha * N;
      PGenPu = if PGenRawPu >= PMaxPu then PMaxPu elseif PGenRawPu <= PMinPu then PMinPu else PGenRawPu;
    else
      PGenRawPu = 0;
      terminal.i.re = 0;
    end if;

    annotation(preferredView = "text");
  end BaseGeneratorSignalN;

  partial model BaseGeneratorSignalNSFR "Base dynamic model for generators based on SignalN for the frequency handling and that participate in the Secondary Frequency Regulation (SFR)"
    import Dynawo.Electrical.Machines;
    import Dynawo.NonElectrical.Logs.Timeline;
    import Dynawo.NonElectrical.Logs.TimelineKeys;

    extends Machines.BaseClasses.BaseGeneratorSimplified;

    type PStatus = enumeration(Standard, LimitPMin, LimitPMax);

    parameter Types.ActivePowerPu PRef0Pu "Start value of the active power set point in pu (base SnRef) (receptor convention)";
    parameter Types.ActivePowerPu PMinPu "Minimum active power in pu (base SnRef)";
    parameter Types.ActivePowerPu PMaxPu "Maximum active power in pu (base SnRef)";
    parameter Types.PerUnit KGover "Mechanical power sensitivity to frequency";
    parameter Types.ActivePower PNom "Nominal power in MW";
    final parameter Real Alpha = PNom * KGover "Participation of the considered generator in the primary frequency regulation";
    parameter Types.PerUnit KSFR "Coefficient of participation in the secondary frequency regulation";
    final parameter Real AlphaSFR = PNom * KSFR "Participation of the considered generator in the secondary frequency regulation";

    input Types.PerUnit N "Signal to change the active power reference setpoint of the generators participating in the primary frequency regulation in pu (base SnRef)";
    input Types.PerUnit NSFR "Signal to change the active power reference setpoint of the generators participating in the secondary frequency regulation in pu (base SnRef)";
    input Types.ActivePowerPu PRefPu(start = PRef0Pu) "Active power set point in pu (base Snref) (receptor convention)";

  protected
    Types.ActivePowerPu PGenRawPu(start = PGen0Pu) "Active power generation without taking limits into account in pu (base SnRef) (generator convention)";
    PStatus pStatus(start = PStatus.Standard) "Status of the power / frequency regulation function";

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

    if running.value then
      PGenRawPu = - PRefPu + Alpha * N + AlphaSFR * NSFR;
      PGenPu = if PGenRawPu >= PMaxPu then PMaxPu elseif PGenRawPu <= PMinPu then PMinPu else PGenRawPu;
    else
      PGenRawPu = 0;
      terminal.i.re = 0;
    end if;

    annotation(preferredView = "text");
  end BaseGeneratorSignalNSFR;

  annotation(preferredView = "text");
end BaseClasses;
