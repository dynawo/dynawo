within Dynawo.Examples.RVS.Components.RestorativeLoad;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model LoadAlphaBetaRestorativeRVS "Load with voltage dependant active and reactive power with load reset (alpha-beta model)"
  import Dynawo.Electrical.Loads.BaseClasses;

  extends BaseClasses.BaseLoad;
  extends AdditionalIcons.Load;

  parameter Real alpha "Active load sensitivity to voltage";
  parameter Real beta "Reactive load sensitivity to voltage";
  parameter Types.PerUnit Kp = 0.05 "Active power reset multiplier gain";
  parameter Types.PerUnit Kq = 0.05 "Reactive power reset multiplier gain";
  parameter Types.PerUnit PMltMaxPu = 2 "Active power reset multiplier maximum in pu. (base UNom, PRefPu)";
  parameter Types.PerUnit PMltMinPu = 0.9 "Active power reset multiplier minimum in pu. (base UNom, PRefPu)";
  parameter Types.PerUnit QMltMaxPu = 2 "Reactive power reset multiplier maximum in pu. (base UNom, QRefPu)";
  parameter Types.PerUnit QMltMinPu = 0.9 "Reactive power reset multiplier minimum in pu. (base UNom, QRefPu)";

  Types.ActivePowerPu PMltPu "Active power load reset multiplier in pu (base UNom, PRefPu)";
  Types.ReactivePowerPu QMltPu "Reactive power load reset multiplier in pu (base UNom, QRefPu)" ;

initial equation
  PMltPu = 1.0;
  QMltPu = 1.0;

equation
  if running.value then
    if PMltPu > PMltMaxPu and Kp * ((PRefPu - PPu) / PRefPu) > 0 then
      der(PMltPu) = 0;
    elseif PMltPu < PMltMinPu and Kp * ((PRefPu - PPu) / PRefPu) < 0 then
      der(PMltPu) = 0;
    else
      der(PMltPu) = Kp * ((PRefPu - PPu) / PRefPu);
    end if;
    if QMltPu > QMltMaxPu and Kq * ((QRefPu - QPu) / QRefPu) > 0 then
      der(QMltPu) = 0;
    elseif QMltPu < QMltMinPu and Kq * ((QRefPu - QPu) / QRefPu) < 0 then
      der(QMltPu) = 0;
    else
      der(QMltPu) = Kq * ((QRefPu - QPu) / QRefPu);
    end if;
    PPu = PRefPu * (1 + deltaP) * ((ComplexMath.'abs'(terminal.V) / ComplexMath.'abs'(u0Pu)) ^ alpha) * PMltPu;
    QPu = QRefPu * (1 + deltaQ) * ((ComplexMath.'abs'(terminal.V) / ComplexMath.'abs'(u0Pu)) ^ beta) * QMltPu;
  else
    der(PMltPu) = 0;
    der(QMltPu) = 0;
    terminal.i = Complex(0);
  end if;

  annotation(
    preferredView = "text");
end LoadAlphaBetaRestorativeRVS;
