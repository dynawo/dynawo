within Dynawo.Electrical.Loads;

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

model LoadAlphaBeta "Load with voltage-dependent active and reactive power (alpha-beta model)"
  extends BaseClasses.BaseLoad;
  extends AdditionalIcons.Load;

  parameter Real alpha "Active load sensitivity to voltage";
  parameter Real beta "Reactive load sensitivity to voltage";
  parameter Types.VoltageModulePu UMinPu = 0 "Voltage below which the load is the constant admittance that takes at UMinPu the power of the alpha-beta law, in pu (base UNom); 0: never";

equation
  if running and terminal.V <> Complex(0) and ComplexMath.'abs'(terminal.V) >= UMinPu then
    PPu = PRefPu * (1 + deltaP) * ((ComplexMath.'abs'(terminal.V) / ComplexMath.'abs'(u0Pu)) ^ alpha);
    QPu = QRefPu * (1 + deltaQ) * ((ComplexMath.'abs'(terminal.V) / ComplexMath.'abs'(u0Pu)) ^ beta);
  elseif running and UMinPu > 0 then
    // the current is then defined at any voltage, zero included, where the power law leaves it undetermined
    terminal.i = ComplexMath.conj(Complex(PRefPu * (1 + deltaP) * ((UMinPu / ComplexMath.'abs'(u0Pu)) ^ alpha), QRefPu * (1 + deltaQ) * ((UMinPu / ComplexMath.'abs'(u0Pu)) ^ beta))) * terminal.V / UMinPu ^ 2;
  else
    terminal.i = Complex(0);
  end if;

  annotation(preferredView = "text");
end LoadAlphaBeta;
