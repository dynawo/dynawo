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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model GeneratorPVDiagramPQ "Model for generator PV based on SignalN for the frequency handling with an N points PQ diagram."
  extends BaseClasses.BaseGeneratorSignalNDiagramPQ;
  extends BaseClasses.BasePV;
  extends BaseClasses.BaseQStator(QStatorPu(start = QGen0Pu * SystemBase.SnRef / QNomAlt));

  // blocks
  Modelica.Blocks.Sources.BooleanExpression blocking(y = (qStatus == QStatus.AbsorptionMax or qStatus == QStatus.GenerationMax or running.value == false)) "Expression determining if reactive power limits have been reached or if the generator is disconnected" annotation(
    Placement(transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.BooleanOutput blocker "If true, reactive power limits have been reached or the generator is disconnected" annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {106, 0}, extent = {{-10, -10}, {10, 10}})));

equation
  when QGenPu  <= QMinPu and UPu > URefPu then
    qStatus = QStatus.AbsorptionMax;
    limUQDown = true;
    limUQUp = false;
  elsewhen QGenPu >= QMaxPu and UPu < URefPu then
    qStatus = QStatus.GenerationMax;
    limUQDown = false;
    limUQUp = true;
  // If the two following branches are not here we fail to adjust QGenPu if QMaxPu/QMinPu was modified but we were in Standard Mode.
  elsewhen QGenPu <= QMinPu and UPu == URefPu then
    qStatus = QStatus.AbsorptionMax;
    limUQDown = true;
    limUQUp = false;
  elsewhen QGenPu >= QMaxPu and UPu == URefPu then
    qStatus = QStatus.GenerationMax;
    limUQDown = false;
    limUQUp = true;
  elsewhen (QGenPu - QDeadBandPu > QMinPu or UPu + UDeadBandPu < URefPu) and (QGenPu + QDeadBandPu < QMaxPu or UPu - UDeadBandPu > URefPu) then
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
      UPu = URefPu;
    end if;
  else
    terminal.i.im = 0;
  end if;

  QStatorPu = QGenPu * SystemBase.SnRef / QNomAlt;

  connect(blocking.y, blocker) annotation(
    Line(points = {{82, 0}, {110, 0}}, color = {255, 0, 255}));

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>  This generator provides an active power PGenPu that depends on an emulated frequency regulation and regulates the voltage UPu unless its reactive power generation hits its limits QMinPu or QMaxPu. These limits are calculated in the model depending on PGenPu.</div></body></html>"));
end GeneratorPVDiagramPQ;
