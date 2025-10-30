within Dynawo.Electrical.Photovoltaics.WECC;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model PVCurrentSource_INIT "Initialization model for WECC PV model with a current source as interface with the grid"
  extends AdditionalIcons.Init;
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsPCS;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  parameter Types.PerUnit PPcc0Pu "Initial active power at the external bus controlled by the PPC (used when PPCLocal = False) (receptor convention, base UNom, SnRef) (only if the PCS is defined outside of the model)" annotation(
    Dialog(enable = not PPCLocal));
  parameter Types.PerUnit QPcc0Pu "Initial reactive power at the external bus controlled by the PPC (used when PPCLocal = False) (receptor convention, base UNom, SnRef) (only if the PCS is defined outside of the model)" annotation(
    Dialog(enable = not PPCLocal));
  parameter Types.PerUnit UPcc0Pu "Start value of voltage magnitude at PPC regulated bus in pu (bae UNom)" annotation(
    Dialog(enable = not PPCLocal));
  parameter Types.Angle UPhasePcc0 = 1 "Start value of voltage phase angle at PPC regulated bus in rad" annotation(
    Dialog(enable = not PPCLocal));

  parameter Types.PerUnit P0Pu "Start value of active power at converter terminal in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit Q0Pu "Start value of reactive power at converter terminal in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at converter terminal in pu (bae UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage phase angle at converter terminal in rad";

  Types.ComplexPerUnit i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  Types.PerUnit Id0Pu "Start value of d-axis current at injector in pu (base UNom, SNom) (generator convention)";
  Types.ComplexPerUnit iConv0Pu "Start value of complex current at converter terminal in pu (base UNom, SNom) (generator convention)";
  Types.ComplexPerUnit iInj0Pu "Start value of complex current at injector in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit Iq0Pu "Start value of q-axis current at injector in pu (base UNom, SNom) (generator convention)";
  Types.ComplexPerUnit iPcc0Pu "Start value of complex current at external PCC in pu (used when PPCLocal = False, meaning the PCS is defined outside of the model) (receptor convention) (base UNom, SnRef)" annotation(
    Dialog(enable = not PPCLocal));
  Types.PerUnit PInj0Pu "Start value of active power at injector in pu (base SNom) (generator convention)";
  Types.ActivePowerPu PConv0Pu "Start value of active power at converter terminal in pu (base SNom) (generator convention)";
  Types.PerUnit PF0 "Start value of power factor";
  Types.PerUnit QInj0Pu "Start value of reactive power at injector in pu (base SNom) (generator convention)";
  Types.ReactivePowerPu QConv0Pu "Start value of reactive power at converter terminal in pu (base SNom) (generator convention)";
  Types.ComplexPerUnit s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
  Types.ComplexPerUnit sConv0Pu "Start value of complex apparent power at converter in pu (base SNom) (generator convention)";
  Types.ComplexPerUnit sInj0Pu "Start value of complex apparent power at injector in pu (base SNom) (generator convention)";
  Types.ComplexPerUnit sPcc0Pu "Start value of complex apparent power at external PCC in pu (used when PPCLocal = False, meaning the PCS is defined outside of the model) (receptor convention) (base UNom, SnRef)" annotation(
    Dialog(enable = not PPCLocal));
  Types.ComplexPerUnit u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  Types.ComplexPerUnit uConv0Pu "Start value of complex voltage at converter terminal in pu (base UNom)";
  Types.VoltageModulePu UInj0Pu "Start value of voltage module at injector in pu (base UNom)";
  Types.ComplexPerUnit uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  Types.Angle UPhaseConv0 "Value of voltage phase angle at converter terminal in rad";
  Types.ComplexPerUnit uPcc0Pu "Initial voltage module at the external bus controlled by the PPC (used when PPCLocal = False, meaning the PCS is defined outside of the model) (base UNom)" annotation(
    Dialog(enable = not PPCLocal));

equation
  //Regulated bus electrical quantities
  iPcc0Pu = ComplexMath.conj(sPcc0Pu / uPcc0Pu);
  uPcc0Pu = ComplexMath.fromPolar(UPcc0Pu, UPhasePcc0);
  sPcc0Pu = Complex(PPcc0Pu, QPcc0Pu);

  //Converter terminal electrical quantities
  i0Pu = ComplexMath.conj(s0Pu / u0Pu);
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  s0Pu = Complex(P0Pu, Q0Pu);

  //Converter terminal electrical quantities
  iConv0Pu =  (- i0Pu * SystemBase.SnRef / SNom) / rTfoPu + Complex(GPcsPu, BPcsPu) * uConv0Pu;
  uConv0Pu = rTfoPu * u0Pu - Complex(RPcsPu, XPcsPu) * (i0Pu * SystemBase.SnRef / SNom) / rTfoPu;
  sConv0Pu = uConv0Pu * ComplexMath.conj(iConv0Pu);
  PConv0Pu = ComplexMath.real(sConv0Pu);
  QConv0Pu = ComplexMath.imag(sConv0Pu);
  UPhaseConv0 = ComplexMath.arg(uConv0Pu);

  //Injector terminal electrical quantities
  iInj0Pu = iConv0Pu;
  uInj0Pu = uConv0Pu + Complex(RPu, XPu) * iConv0Pu;
  sInj0Pu = uInj0Pu * ComplexMath.conj(iInj0Pu);
  PInj0Pu = ComplexMath.real(sInj0Pu);
  QInj0Pu = ComplexMath.imag(sInj0Pu);
  UInj0Pu = ComplexMath.'abs'(uInj0Pu);

  PF0 = if (not(ComplexMath.'abs'(s0Pu) == 0)) then -P0Pu / ComplexMath.'abs'(s0Pu) else 0;
  Id0Pu = Modelica.Math.cos(UPhaseConv0) * iInj0Pu.re + Modelica.Math.sin(UPhaseConv0) * iInj0Pu.im;
  Iq0Pu = Modelica.Math.sin(UPhaseConv0) * iInj0Pu.re - Modelica.Math.cos(UPhaseConv0) * iInj0Pu.im;

  annotation(
    preferredView = "text");
end PVCurrentSource_INIT;
