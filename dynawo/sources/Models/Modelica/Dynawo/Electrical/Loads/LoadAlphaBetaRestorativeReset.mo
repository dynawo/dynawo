within Dynawo.Electrical.Loads;

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

model LoadAlphaBetaRestorativeReset "Load with voltage-dependent active and reactive power with load reset (Alpha-Beta model)"
  extends Dynawo.Electrical.Loads.BaseClasses.BaseLoad;
  extends AdditionalIcons.Load;

  parameter Real Alpha "Active load sensitivity to voltage";
  parameter Real Beta "Reactive load sensitivity to voltage";
  parameter Types.PerUnit Kp = 0.05 "Active power reset multiplier gain";
  parameter Types.PerUnit KpMltMax = 2 "Active power reset multiplier maximum";
  parameter Types.PerUnit KpMltMin = 0.9 "Active power reset multiplier minimum";
  parameter Types.PerUnit Kq = 0.05 "Reactive power reset multiplier gain";
  parameter Types.PerUnit KqMltMax = 2 "Reactive power reset multiplier maximum";
  parameter Types.PerUnit KqMltMin = 0.9 "Reactive power reset multiplier minimum";

  Types.PerUnit KpMlt(start = 1) "Active power load reset variable multiplier";
  Types.PerUnit KqMlt(start = 1) "Reactive power load reset variable multiplier";

equation
  if running.value then
    if KpMlt > KpMltMax and Kp * (PRefPu - PPu) / PRefPu > 0 then
      der(KpMlt) = 0;
    elseif KpMlt < KpMltMin and Kp * (PRefPu - PPu) / PRefPu < 0 then
      der(KpMlt) = 0;
    else
      der(KpMlt) = Kp * (PRefPu - PPu) / PRefPu;
    end if;
    if KqMlt > KqMltMax and Kq * (QRefPu - QPu) / QRefPu > 0 then
      der(KqMlt) = 0;
    elseif KqMlt < KqMltMin and Kq * (QRefPu - QPu) / QRefPu < 0 then
      der(KqMlt) = 0;
    else
      der(KqMlt) = Kq * (QRefPu - QPu) / QRefPu;
    end if;
    if ((terminal.V.re == 0) and (terminal.V.im == 0)) then
      PPu = 0.;
      QPu = 0.;
    else
      PPu = PRefPu * (1 + deltaP) * ((ComplexMath.'abs'(terminal.V) / ComplexMath.'abs'(u0Pu)) ^ Alpha) * KpMlt;
      QPu = QRefPu * (1 + deltaQ) * ((ComplexMath.'abs'(terminal.V) / ComplexMath.'abs'(u0Pu)) ^ Beta) * KqMlt;
    end if;
  else
    der(KpMlt) = 0;
    der(KqMlt) = 0;
    terminal.i = Complex(0);
  end if;

  annotation(preferredView = "text");
end LoadAlphaBetaRestorativeReset;
