within Dynawo.Electrical.StaticVarCompensators.BaseControls;

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

package Parameters "Parameters of the static var compensator"
  extends Icons.RecordsPackage;

  record Params_Regulation
    import Dynawo.Types;

    parameter Types.PerUnit Kp "Proportional gain of the PI controller";
    parameter Types.PerUnit Lambda "Statism of the regulation law URefPu = UPu + Lambda * QPu in pu (base UNom, SNom)";
    parameter Types.ApparentPowerModule SNom "Static var compensator nominal apparent power in MVA";
    parameter Types.Time Ti "Integral time constant of the PI controller in s";

    annotation(preferredView = "text");
  end Params_Regulation;

  record Params_Limitations
      import Dynawo.Types;

      parameter Types.PerUnit BMaxPu "Maximum value for the variable susceptance in pu (base UNom, SNom)";
      parameter Types.PerUnit BMinPu "Minimum value for the variable susceptance in pu (base UNom, SNom)";
      parameter Types.CurrentModulePu IMaxPu "Maximum value for the current in pu (base UNom, SNom)";
      parameter Types.CurrentModulePu IMinPu "Minimum value for the current in pu (base UNom, SNom)";
      parameter Types.PerUnit KCurrentLimiter "Integral gain of current limiter";

    annotation(preferredView = "text");
  end Params_Limitations;

  record Params_CalculationBG
    import Dynawo.Types;

    parameter Types.PerUnit BShuntPu "Fixed susceptance of the static var compensator in pu (for standby mode) (base SNom)";

    annotation(preferredView = "text");
  end Params_CalculationBG;

  record Params_ModeHandling
     import Dynawo.Types;

     parameter Types.Time tThresholdDown "Time duration associated with the condition U < UThresholdDown for the change from standby to running mode, in s";
     parameter Types.Time tThresholdUp "Time duration associated with the condition U > UThresholdUp for the change from standby to running mode, in s";
     parameter Types.VoltageModule URefDown "Voltage reference taken into account when the static var compensator switches from standby mode to running mode by falling under UThresholdDown for more than tThresholdDown seconds, in kV";
     parameter Types.VoltageModule URefUp "Voltage reference taken into account when the static var compensator switches from standby mode to running mode by exceeding UThresholdUp for more than tThresholdUp seconds, in kV";
     parameter Types.VoltageModule UThresholdDown "Voltage value under which the static var compensator automatically switches from standby mode to running mode, in kV";
     parameter Types.VoltageModule UThresholdUp "Voltage value above which the static var compensator automatically switches from standby mode to running mode, in kV";

    annotation(preferredView = "text");
  end Params_ModeHandling;

  record Params_BlockingFunction
     import Dynawo.Types;

     parameter Types.VoltageModule UBlock "Voltage value under which the static var compensator is blocked, in kV";
     parameter Types.VoltageModule UUnblockDown "Lower voltage value defining the voltage interval in which the static var compensator is unblocked, in kV";
     parameter Types.VoltageModule UUnblockUp "Upper voltage value defining the voltage interval in which the static var compensator is unblocked, in kV";

    annotation(preferredView = "text");
  end Params_BlockingFunction;

  annotation(preferredView = "text");
end Parameters;
