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

model GeneratorPVTfoDiagramPQ "Model for generator PV based on SignalN for the frequency handling, with a simplified transformer, a voltage regulation at stator and with an N points PQ diagram."
  extends BaseClasses.BaseGeneratorSignalNDiagramPQ;
  extends BaseClasses.BaseTfo;
  extends BaseClasses.BaseQStator(QStatorPu(start = QStator0Pu));

  // blocks
  Modelica.Blocks.Sources.BooleanExpression blocking(y = (qStatus == QStatus.AbsorptionMax or qStatus == QStatus.GenerationMax or running.value == false)) "Expression determining if reactive power limits have been reached or if the generator is disconnected" annotation(
    Placement(transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.BooleanOutput blocker "If true, reactive power limits have been reached or the generator is disconnected" annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {106, 0}, extent = {{-10, -10}, {10, 10}})));

equation
  when QGenPu + QDeadBandPu <= QMinPu and UStatorPu - UDeadBandPu > UStatorRefPu then
    qStatus = QStatus.AbsorptionMax;
    limUQDown = true;
    limUQUp = false;
  elsewhen QGenPu - QDeadBandPu >= QMaxPu and UStatorPu + UDeadBandPu < UStatorRefPu then
    qStatus = QStatus.GenerationMax;
    limUQDown = false;
    limUQUp = true;
  // If the two following branches are not here we fail to adjust QGenPu if QMaxPu was modified but we were in Standard Mode.
  elsewhen QGenPu + QDeadBandPu <= QMinPu and UStatorPu == UStatorRefPu then
    qStatus = QStatus.AbsorptionMax;
    limUQDown = true;
    limUQUp = false;
  elsewhen QGenPu - QDeadBandPu >= QMaxPu and UStatorPu == UStatorRefPu then
    qStatus = QStatus.GenerationMax;
    limUQDown = false;
    limUQUp = true;
  elsewhen (QGenPu - QDeadBandPu> QMinPu or UStatorPu + UDeadBandPu < UStatorRefPu) and (QGenPu + QDeadBandPu < QMaxPu or UStatorPu - UDeadBandPu > UStatorRefPu) then
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
      UStatorPu = UStatorRefPu;
    end if;
    if ((uStatorPu.re == 0) and (uStatorPu.im == 0)) then
      UStatorPu = 0.;
    else
      UStatorPu = ComplexMath.'abs'(uStatorPu);
    end if;
  else
    terminal.i.im = 0;
    UStatorPu = 0;
  end if;

  uStatorPu = terminal.V + iStatorPu * Complex(0, XTfoPu);
  iStatorPu = - terminal.i * SystemBase.SnRef / SNom;
  sStatorPu = uStatorPu * ComplexMath.conj(iStatorPu);
  QStatorPu = sStatorPu.im * SNom / QNomAlt;

  connect(blocking.y, blocker) annotation(
    Line(points = {{82, 0}, {110, 0}}, color = {255, 0, 255}));

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This generator regulates the voltage UStatorPu unless its reactive power generation hits its limits QMinPu or QMaxPu at terminal (in this case, the generator provides QMinPu or QMaxPu at terminal and the voltage is no longer regulated at stator).</div></body></html>"));
end GeneratorPVTfoDiagramPQ;
