within Dynawo.Electrical.Transformers.TransformersFixedTap;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model GeneratorTransformer_INIT
  extends BaseClasses_INIT.BaseGeneratorTransformer_INIT;
  extends AdditionalIcons.Init;

  // Transformer internal parameters
  parameter Types.PerUnit rTfoPu "Transformation ratio in pu: U2/U1 in no load conditions";
  parameter Types.PerUnit RPu "Resistance of the generator transformer in pu (base U2Nom, SnRef)";
  parameter Types.PerUnit BPu "Susceptance of the generator transformer in pu (base U2Nom, SnRef)";
  parameter Types.PerUnit XPu "Reactance of the generator transformer in pu (base U2Nom, SnRef)";
  parameter Types.PerUnit GPu "Conductance of the generator transformer in pu (base U2Nom, SnRef)";

  // Transformer parameters
  parameter Types.ComplexImpedancePu ZPu = Complex(RPu, XPu) "Impedance in pu (base U2Nom, SnRef)";
  parameter Types.ComplexAdmittancePu YPu = Complex(GPu, BPu) "Admittance in pu (base U2Nom, SnRef)";

equation
  // Transformer equations
  i10Pu = rTfoPu * (YPu * u20Pu - i20Pu);
  rTfoPu * rTfoPu * u10Pu = rTfoPu * u20Pu + ZPu * i10Pu;
  // Equations could also be written with the following
  // i10Pu = rTfoPu * rTfoPu * u10Pu / ZPu - rTfoPu * u20Pu / ZPu;
  // i20Pu = - rTfoPu * u10Pu / ZPu + (1 / ZPu + YPu) * u20Pu;

  annotation(preferredView = "text");
end GeneratorTransformer_INIT;
