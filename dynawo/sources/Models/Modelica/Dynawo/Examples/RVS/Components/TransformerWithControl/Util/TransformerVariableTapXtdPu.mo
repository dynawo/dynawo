within Dynawo.Examples.RVS.Components.TransformerWithControl.Util;

model TransformerVariableTapXtdPu "Transformer with variable tap to be connected to a tap changer, used in the Nordic 32 test system"
  /*
    * Copyright (c) 2022, RTE (http://www.rte-france.com)
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
  /*
        Equivalent circuit and conventions:
                     I1  r                I2
          U1,P1,Q1 -->---oo----R+jX-------<-- U2,P2,Q2
        (terminal1)                   |      (terminal2)
                                     G+jB
                                      |
                                     ---
        The transformer ratio is variable.
      */
  import Dynawo.Electrical.Transformers.BaseClasses;
  import Dynawo.Electrical.SystemBase;
  extends BaseClasses.BaseTransformerVariableTap;
  extends AdditionalIcons.Transformer;
  // Transformer parameters
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  parameter Types.Percent R "Resistance in % (base U2Nom, SNom)";
  parameter Types.Percent X "Reactance in % (base U2Nom, SNom)";
  parameter Types.Percent G "Conductance in % (base U2Nom, SNom)";
  parameter Types.Percent B "Susceptance in % (base U2Nom, SNom)";
  Types.PerUnit XtdPu(start = 15 / 100 * rTfo0Pu ^ 2 * SystemBase.SnRef / SNom) "Ratio dependent reactance of side 1 in pu (base U2Nom, SNom)";
  Types.PerUnit RtdPu(start = 0.3 / 100 * rTfo0Pu ^ 2 * SystemBase.SnRef / SNom) "Ratio dependent reactance of side 1 in pu (base U2Nom, SNom)";
protected
  parameter Types.ComplexAdmittancePu YPu(re = G / 100 * SNom / SystemBase.SnRef, im = B / 100 * SNom / SystemBase.SnRef) "Transformer admittance in pu (base U2Nom, SnRef)";
  Types.ComplexImpedancePu ZPu "Transformer impedance in pu (base U2Nom, SnRef)";
equation
  RtdPu = 0.3 / 100 * rTfoPu ^ 2 * SystemBase.SnRef / SNom;
  XtdPu = 15 / 100 * rTfoPu ^ 2 * SystemBase.SnRef / SNom;
  ZPu.im = XtdPu;
  ZPu.re = RtdPu;
  if running.value then
// Transformer equations
    terminal1.i = rTfoPu * (YPu * terminal2.V - terminal2.i);
    ZPu * terminal1.i = rTfoPu * rTfoPu * terminal1.V - rTfoPu * terminal2.V;
  else
    terminal1.i = terminal2.i;
    terminal2.V = Complex(0);
  end if;
  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>This model is a variation of the TransformerVariableTap, where the reactance of side 2 is calculated from the reactance of side 1, therefore dependent on the transformer ratio over time.<div>This model is used in the Nordic 32 test system for voltage stability studies.</div></body></html>"));
end TransformerVariableTapXtdPu;
