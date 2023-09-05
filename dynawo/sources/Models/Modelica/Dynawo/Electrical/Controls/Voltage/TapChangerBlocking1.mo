within Dynawo.Electrical.Controls.Voltage;

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

model TapChangerBlocking1 "Tap Changer Blocking 1 (TCB1)"
  /* Tap Changer Blocking, special protection scheme, monitoring the voltage on one bus going below a predefined threshold
     in order to avoid a voltage collapse */
  extends BaseClasses.BaseTapChangerBlocking;

  import Modelica.Constants;

  parameter Types.VoltageModule UMin "Minimum voltage threshold before tap-changer blocking";

  Dynawo.Connectors.ImPin UMonitored "Monitored voltage";

equation
  // Check when the monitored voltage goes below UMin
  when UMonitored.value < UMin then
    UUnderMin = true;
    tUnderUmin = time;
  elsewhen UMonitored.value >= UMin and pre(UUnderMin) then
    UUnderMin = false;
    tUnderUmin = Constants.inf;
  end when;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>This model will send a block order to transformers with tap-changers to block the tap to its current step if the voltage becomes lower than a threshold on one controlled node. Such a mechanism enables to avoid voltage collapse on situations where the tap actions become negative for the system stability.<div><br></div>The detailed tap-changer-blocking behavior is explained in the following state diagram:

<figure>
    <img width=\"450\" src=\"modelica://Dynawo/Electrical/Controls/Voltage/Images/TapChangerBlock.png\">
</figure>
</body></html>"));
end TapChangerBlocking1;
