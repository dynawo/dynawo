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

model GeneratorPV "Model for generator PV based on SignalN for the frequency handling"

  extends BaseClasses.BaseGeneratorSignalN;

  equation

    if qStatus == QStatus.GenerationMax then
      QGenPu = QMaxPu;
    elseif qStatus == QStatus.AbsorptionMax then
      QGenPu = QMinPu;
    else
      UPu = URefPu.value;
    end if;

annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This generator provides an active power PGenPu that depends on its setpoint PGen0Pu and its participation (alpha) in an emulated frequency regulation (DYNModelSignalN model, that calculates the signal N (that is common to all the generators in a connected component and which increases or decreases the generation of each generator) and the total generators participation alphaSum).<div>It regulates the voltage UPu unless its reactive power generation hits its limits QMinPu or QMaxPu (in this case, the generator provides QMinPu or QMaxPu and the voltage is no longer regulated).<div>This model is used with the frequency handling model DYNModelSignalN and cannot be used with DYNModelOmegaRef as the frequency is not explicitly expressed.</div></body></html>"));
end GeneratorPV;
