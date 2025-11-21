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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model GeneratorPQPropDiagramPQSFR "Model for generator PQ with a PQ diagram, based on SignalN for the frequency handling, with a proportional reactive power regulation and that participates in the Secondary Frequency Regulation (SFR)"
  extends BaseClasses.BaseGeneratorSignalNSFRDiagramPQ;
  extends BaseClasses.BasePQProp(QGenRawPu(start = QGen0Pu));

equation
  when QGenRawPu + QDeadBandPu <= QMinPu then
    qStatus = QStatus.AbsorptionMax;
    limUQDown = true;
    limUQUp = false;
  elsewhen QGenRawPu - QDeadBandPu >= QMaxPu then
    qStatus = QStatus.GenerationMax;
    limUQDown = false;
    limUQUp = true;
  elsewhen QGenRawPu - QDeadBandPu > QMinPu and QGenRawPu + QDeadBandPu < QMaxPu then
    qStatus = QStatus.Standard;
    limUQDown = false;
    limUQUp = false;
  end when;

  if running.value then
    if qStatus == QStatus.GenerationMax then
      QGenPu = QMaxPu;
    elseif qStatus == QStatus.AbsorptionMax then
      QGenPu = QMinPu;
    else
      QGenPu = min(max(QGenRawPu, QMinPu), QMaxPu);
    end if;
  else
    terminal.i.im = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This PQ generator adapts it Q to regulate the voltage of a distant bus along with other generators depending on a participation factor QPercent. To do so, it receives a set point NQ to adapt its Q. This NQ is common to all the generators participating in this regulation. The reactive power limitations follow a PQ diagram. </div></body></html>"));
end GeneratorPQPropDiagramPQSFR;
