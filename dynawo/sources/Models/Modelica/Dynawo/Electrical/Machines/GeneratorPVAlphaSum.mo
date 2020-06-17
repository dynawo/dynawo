within Dynawo.Electrical.Machines;

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

model GeneratorPVAlphaSum "Model for generator PV with AlphaSum. This generator provides an active power PGenPu that depends on an emulated frequency regulation (signal N and total generators participation AlphaSum) and regulates the voltage UPu unless its reactive power generation hits its limits QMinPu or QMaxPu (in this case, the generator provides QMinPu or QMaxPu and the voltage is no longer regulated). This model is used with DYNModelAlphaSum and cannot be used with DYNModelOmegaRef as the frequency is not explicitly expressed."

  extends BaseClasses.BaseGeneratorSimplified;
  extends AdditionalIcons.Machine;

  public

    parameter Types.PerUnit KGover = 1 "Mechanical power sensitivity to frequency";
    parameter Types.PerUnit Lambda = 0 "Parameter Lambda of the voltage regulation";
    parameter Types.ActivePowerPu PMinPu "Minimum active power in p.u (base SnRef)";
    parameter Types.ActivePowerPu PMaxPu "Maximum active power in p.u (base SnRef)";
    parameter Types.ReactivePowerPu QMinPu  "Minimum reactive power in p.u (base SnRef)";
    parameter Types.ReactivePowerPu QMaxPu  "Maximum reactive power in p.u (base SnRef)";
    parameter Types.ActivePowerPu PAuxHVPu = 0 "Active power consumption of the high voltage auxiliary used to recalculate the P and Q limits when the auxiliaries are not explicitly modeled (base SnRef)";
    parameter Types.ActivePowerPu QAuxHVPu = 0 "Reactive power consumption of the high voltage auxiliary used to recalculate the P and Q limits when the auxiliaries are not explicitly modeled (base SnRef)";
    parameter Types.ActivePowerPu PAuxLVPu = 0 "Active power consumption of the low voltage auxiliary used to recalculate the P and Q limits when the auxiliaries are not explicitly modeled  (base SnRef)";
    parameter Types.ActivePowerPu QAuxLVPu = 0 "Reactive power consumption of the low voltage auxiliary used to recalculate the P and Q limits when the auxiliaries are not explicitly modeled  (base SnRef)";
    final parameter Types.ActivePowerPu PMinAuxPu = PMinPu - PAuxHVPu - PAuxLVPu "Minimum active power in p.u when taking into account the auxiliaries (base SnRef)";
    final parameter Types.ActivePowerPu PMaxAuxPu = PMaxPu - PAuxHVPu - PAuxLVPu "Maximum active power in p.u when taking into account the auxiliaries (base SnRef)";
    final parameter Types.ReactivePowerPu QMinAuxPu = QMinPu - QAuxHVPu - QAuxLVPu "Minimum reactive power in p.u when taking into account the auxiliaries (base SnRef)";
    final parameter Types.ReactivePowerPu QMaxAuxPu = QMaxPu - QAuxHVPu - QAuxLVPu "Maximum reactive power in p.u when taking into account the auxiliaries (base SnRef)";

    parameter Real AlphaRaw "Reference value of the participation of the considered generator in the frequency regulation";

    Connectors.ImPin N "Signal to change the active power reference setpoint of all the generators in the system in p.u (base SnRef)";
    Connectors.ZPin Alpha "Participation of the considered generator in the frequency regulation";
    Connectors.ZPin AlphaSum "Sum of all the participations of all generators in the frequency regulation";
    Connectors.ZPin URefPu (value(start = U0Pu)) "Voltage regulation set point in p.u (base UNom)";

  protected

    Types.ActivePowerPu PGenRawPu (start = PGen0Pu) "Active power generation without taking limits into account in p.u (base SnRef) (generator convention)";

  equation

    if running.value then
      PGenRawPu = PGen0Pu + (AlphaRaw * KGover / AlphaSum.value) * N.value;
      PGenPu = if PGenRawPu >= PMaxAuxPu then PMaxAuxPu elseif PGenRawPu <= PMinAuxPu then PMinAuxPu else PGenRawPu;

      if QGenPu >= QMaxAuxPu and (pre(QGenPu)<> QMaxAuxPu or UPu < URefPu.value) then
          QGenPu = QMaxAuxPu;
      elseif QGenPu <= QMinAuxPu and (pre(QGenPu)<> QMinAuxPu or UPu > URefPu.value) then
          QGenPu = QMinAuxPu;
      else
        UPu = URefPu.value + Lambda * (QGenPu - QGen0Pu);
      end if;

      Alpha.value = if (N.value > 0 and PGenRawPu >= PMaxAuxPu) then 0 else if (N.value < 0 and PGenRawPu <= PMinAuxPu) then 0 else KGover * AlphaRaw;

    else
      PGenRawPu = - PAuxHVPu - PAuxLVPu;
      PGenPu = - PAuxHVPu - PAuxLVPu;
      QGenPu = - QAuxHVPu - QAuxLVPu;
      Alpha.value = 0;
    end if;

annotation(preferredView = "text");
end GeneratorPVAlphaSum;
