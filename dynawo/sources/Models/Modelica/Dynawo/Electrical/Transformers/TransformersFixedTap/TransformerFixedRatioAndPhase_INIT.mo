within Dynawo.Electrical.Transformers.TransformersFixedTap;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

model TransformerFixedRatioAndPhase_INIT "Initialization model for TransformerFixedRatioAndPhase"
  extends AdditionalIcons.Init;
  extends BaseClasses.TransformerParameters;

  parameter Types.Angle AlphaTfo0 "Start value of transformation phase shift in rad";
  parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.PerUnit RatioTfo0Pu "Start value of transformation ratio in pu: U2/U1 in no load conditions";
  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base U1Nom)";
  parameter Types.Angle U1Phase0 "Start value of voltage angle at terminal 1 in rad";

  Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base U1Nom, SnRef) (receptor convention)";
  Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 in pu (base U2Nom, SnRef) (receptor convention)";
  Types.ComplexPerUnit rTfo0Pu "Transformation complex ratio in complex pu";
  Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base U1Nom)";
  Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2 in pu (base U2Nom)";
  Types.VoltageModulePu U20Pu "Start value of voltage amplitude at terminal 2 in pu (base U2Nom)";

equation
  rTfo0Pu =  ComplexMath.fromPolar(RatioTfo0Pu, AlphaTfo0);
  rTfo0Pu * ComplexMath.conj(rTfo0Pu) * u10Pu = ComplexMath.conj(rTfo0Pu) * u20Pu + ZPu * i10Pu;
  i10Pu = ComplexMath.conj(rTfo0Pu) * (YPu * u20Pu - i20Pu);
  P10Pu = ComplexMath.real(u10Pu * ComplexMath.conj(i10Pu));
  Q10Pu = ComplexMath.imag(u10Pu * ComplexMath.conj(i10Pu));
  u10Pu = ComplexMath.fromPolar(U10Pu, U1Phase0);
  U20Pu = ComplexMath.'abs'(u20Pu);

  annotation(preferredView = "text");
end TransformerFixedRatioAndPhase_INIT;
