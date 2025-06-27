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

model GeneratorPVTfo "Model for generator PV based on SignalN for the frequency handling, with a simplified transformer and a voltage regulation at stator"
  extends BaseClasses.BaseGeneratorSignalNFixedReactiveLimits;
  extends BaseClasses.BaseTfo;
  extends BaseClasses.BaseQStator(QStatorPu(start = QStator0Pu));

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
  elsewhen (QGenPu + QDeadBandPu  > QMinPu or UStatorPu - UDeadBandPu < UStatorRefPu) and (QGenPu - QDeadBandPu  < QMaxPu or UStatorPu + UDeadBandPu  > UStatorRefPu) then
    qStatus = QStatus.Standard;
    limUQDown = false;
    limUQUp = false;
  end when;

  if running.value then
    if QGenPu - QDeadBandPu >= QMaxPu and UStatorPu + UDeadBandPu < UStatorRefPu then
      QGenPu = QMaxPu;
    elseif QGenPu + QDeadBandPu <= QMinPu and UStatorPu - UDeadBandPu > UStatorRefPu then
      QGenPu = QMinPu;
    else
      UStatorPu = UStatorRefPu;
    end if;
    UStatorPu = ComplexMath.'abs'(uStatorPu);
  else
    terminal.i.im = 0;
    UStatorPu = 0;
  end if;

  uStatorPu = terminal.V + iStatorPu * Complex(0, XTfoPu);
  iStatorPu = - terminal.i * SystemBase.SnRef / SNom;
  sStatorPu = uStatorPu * ComplexMath.conj(iStatorPu);
  QStatorPu = sStatorPu.im * SNom / QNomAlt;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This generator regulates the voltage UStatorPu unless its reactive power generation hits its limits QMinPu or QMaxPu at terminal (in this case, the generator provides QMinPu or QMaxPu at terminal and the voltage is no longer regulated at stator).</div></body></html>"));
end GeneratorPVTfo;
