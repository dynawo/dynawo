within Dynawo.Electrical.Transformers.BaseClasses_INIT;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

partial model BaseTransformerVariableTap_INIT "Base model for initialization of TransformerVariableTap"
  extends BaseTransformerVariableTapCommon_INIT;

/*  Equivalent circuit and conventions:

               I1  r                I2
    U1,P1,Q1 -->---oo----R+jX-------<-- U2,P2,Q2
  (terminal1)                   |      (terminal2)
                               G+jB
                                |
                               ---
*/

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  parameter Types.Percent R "Resistance in % (base U2Nom, SNom)";
  parameter Types.Percent X "Reactance in % (base U2Nom, SNom)";
  parameter Types.Percent G "Conductance in % (base U2Nom, SNom)";
  parameter Types.Percent B "Susceptance in % (base U2Nom, SNom)";

protected
  // Transformer's impedance and susceptance
  parameter Types.ComplexImpedancePu ZPu(re = R / 100 * SystemBase.SnRef / SNom, im = X / 100 * SystemBase.SnRef / SNom) "Transformer impedance in pu (base U2Nom, SnRef)";
  parameter Types.ComplexAdmittancePu YPu(re = G / 100 * SNom / SystemBase.SnRef, im = B / 100 * SNom / SystemBase.SnRef) "Transformer admittance in pu (base U2Nom, SnRef)";

  annotation(preferredView = "text");
end BaseTransformerVariableTap_INIT;
