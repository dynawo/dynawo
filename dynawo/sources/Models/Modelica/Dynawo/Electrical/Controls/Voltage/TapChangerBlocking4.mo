within Dynawo.Electrical.Controls.Voltage;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools
* for power systems.
*/

model TapChangerBlocking4 "Tap Changer Blocking 4 (TCB4)"
  /* Tap Changer Blocking, special protection scheme, monitoring the voltage on four buses going below their predefined threshold
     in order to avoid a voltage collapse */
  extends BaseClasses.BaseTapChangerBlocking;

  import Modelica.Constants;

  parameter Types.VoltageModule UMin1 "Minimum voltage 1 threshold before tap-changer blocking";
  parameter Types.VoltageModule UMin2 "Minimum voltage 2 threshold before tap-changer blocking";
  parameter Types.VoltageModule UMin3 "Minimum voltage 3 threshold before tap-changer blocking";
  parameter Types.VoltageModule UMin4 "Minimum voltage 4 threshold before tap-changer blocking";

  Dynawo.Connectors.ImPin UMonitored1 "Monitored voltage 1";
  Dynawo.Connectors.ImPin UMonitored2 "Monitored voltage 2";
  Dynawo.Connectors.ImPin UMonitored3 "Monitored voltage 3";
  Dynawo.Connectors.ImPin UMonitored4 "Monitored voltage 4";

equation
  // Check when the monitored voltage goes below UMin
  when UMonitored1.value < UMin1 or UMonitored2.value < UMin2 or UMonitored3.value < UMin3 or UMonitored4.value < UMin4 then
    UUnderMin = true;
    tUnderUmin = time;
  elsewhen UMonitored1.value >= UMin1 and UMonitored2.value >= UMin2 and UMonitored3.value >= UMin3 and UMonitored4.value >= UMin4 and pre(UUnderMin) then
    UUnderMin = false;
    tUnderUmin = Constants.inf;
  end when;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>this model will send a block order to transformers with tap-changers to block the tap to its current step if the voltage becomes lower than a threshold on one of four controlled nodes. Such a mechanism enables to avoid voltage collapse on situations where the tap actions become negative for the system stability.<div><br></div>The detailed tap-changer-blocking behavior is explained in the following state diagram:

<figure>
    <img width=\"450\" src=\"modelica://Dynawo/Electrical/Controls/Voltage/Images/TapChangerBlock.png\">
</figure>
</body></html>"));
end TapChangerBlocking4;
