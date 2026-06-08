within Dynawo.Electrical.Loads;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tool for power systems.
*/

model LoadAlphaBetaFrequencyDependent
  extends BaseClasses.BaseLoad;
  extends AdditionalIcons.Load;
  extends Dynawo.Electrical.Controls.PLL.ParamsPLL;

  parameter Real alpha "Active load sensitivity to voltage";
  parameter Real beta "Reactive load sensitivity to voltage";
  parameter Real Kpf "Active load sensitivity to frequency";
  parameter Real Kqf "Reactive load sensitivity to frequency";
  parameter Real omegaRef0Pu = 1.0 "Reference frequency in p.u.";

  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference frequency of the system in pu (base OmegaNom)" annotation(
    Placement(transformation(origin = {-104, -4}, extent = {{-4, -4}, {4, 4}}), iconTransformation(origin = {-105, -39}, extent = {{-5, -5}, {5, 5}})));
  Dynawo.Electrical.Controls.PLL.PLL PLL(Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = u0Pu) annotation(
    Placement(transformation(origin = {-30, 6}, extent = {{-16, -16}, {16, 16}})));

equation
  PLL.uPu.re = terminal.V.re;
  PLL.uPu.im = terminal.V.im;
  if (running) then
    PPu = PRefPu*(1 + deltaP)*((ComplexMath.'abs'(terminal.V)/ComplexMath.'abs'(u0Pu))^alpha)*(1 + Kpf*(PLL.omegaPLLPu - omegaRef0Pu));
    QPu = QRefPu*(1 + deltaQ)*((ComplexMath.'abs'(terminal.V)/ComplexMath.'abs'(u0Pu))^beta)*(1 + Kqf*(PLL.omegaPLLPu - omegaRef0Pu));
  else
    terminal.i = Complex(0);
  end if;
  connect(omegaRefPu, PLL.omegaRefPu) annotation(
    Line(points = {{-104, -4}, {-48, -4}}, color = {0, 0, 127}));

  annotation(
    preferredView = "text");
end LoadAlphaBetaFrequencyDependent;
