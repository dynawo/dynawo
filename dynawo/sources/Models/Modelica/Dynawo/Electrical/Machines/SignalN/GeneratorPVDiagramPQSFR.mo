within Dynawo.Electrical.Machines.SignalN;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model GeneratorPVDiagramPQSFR "Model for generator PV based on SignalN for the frequency handling, with an N points PQ diagram and that participates in the Secondary Frequency Regulation (SFR)"
  extends BaseClasses.BaseGeneratorSignalNSFRDiagramPQ;
  extends BaseClasses.BasePV;

equation
  when QGenPu + QDeadBandPu <= QMinPu and UPu - UDeadBandPu > URefPu then
    qStatus = QStatus.AbsorptionMax;
    limUQDown = true;
    limUQUp = false;
  elsewhen QGenPu - QDeadBandPu >= QMaxPu and UPu + UDeadBandPu < URefPu then
    qStatus = QStatus.GenerationMax;
    limUQDown = false;
    limUQUp = true;
  // If the two following branches are not here we fail to adjust QGenPu if QMaxPu was modified but we were in Standard Mode.
  elsewhen QGenPu + QDeadBandPu <= QMinPu and UPu - UDeadBandPu == URefPu then
    qStatus = QStatus.AbsorptionMax;
    limUQDown = true;
    limUQUp = false;
  elsewhen QGenPu - QDeadBandPu >= QMaxPu and UPu + UDeadBandPu == URefPu then
    qStatus = QStatus.GenerationMax;
    limUQDown = false;
    limUQUp = true;
  elsewhen (QGenPu - QDeadBandPu > QMinPu or UPu + UDeadBandPu < URefPu) and (QGenPu + QDeadBandPu < QMaxPu or UPu - UDeadBandPu > URefPu) then
    qStatus = QStatus.Standard;
    limUQDown = false;
    limUQUp = false;
  end when;

  if running.value then
    if QGenPu - QDeadBandPu >= QMaxPu and UPu + UDeadBandPu < URefPu then
      QGenPu = QMaxPu;
    elseif QGenPu + QDeadBandPu <= QMinPu and UPu - UDeadBandPu > URefPu then
      QGenPu = QMinPu;
    else
      UPu = URefPu;
    end if;
  else
    terminal.i.im = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>  This generator regulates the voltage UPu unless its reactive power generation hits its limits QMinPu or QMaxPu. These limits are calculated in the model depending on PGenPu.</div></body></html>"));
end GeneratorPVDiagramPQSFR;
