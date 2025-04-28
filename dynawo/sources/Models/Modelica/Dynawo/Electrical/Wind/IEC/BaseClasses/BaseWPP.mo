within Dynawo.Electrical.Wind.IEC.BaseClasses;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model BaseWPP "Base model for Wind Power Plants from IEC 61400-27-1 standard"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.CurrentLimitParameters;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.GridProtectionParameters;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.PControlParameters;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.QLimitParameters;

  //Nominal parameters
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.Time tS "Integration time step in s";

  //Electrical parameters for internal MV network + MV/HV transformer
  parameter Types.PerUnit BMvHvPu = 0 "Shunt susceptance of internal MV network + MV/HV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "MV network + MV/HV transformer", enable = PPCLocal));
  parameter Types.PerUnit GMvHvPu = 0 "Shunt conductance of internal MV network + MV/HV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "MV network + MV/HV transformer", enable = PPCLocal));
  parameter Types.PerUnit RMvHvPu = 0 "Serial resistance of internal MV network + MV/HV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "MV network + MV/HV transformer", enable = PPCLocal));
  parameter Types.PerUnit XMvHvPu = 0 "Serial reactance of internal MV network + MV/HV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "MV network + MV/HV transformer", enable = PPCLocal));

  //Parameters for LV transformer
  parameter Types.PerUnit BLvTrPu "Shunt susceptance of LV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "LV transformer"));
  parameter Types.PerUnit GLvTrPu "Shunt conductance of LV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "LV transformer"));
  parameter Types.PerUnit RLvTrPu "Serial resistance of LV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "LV transformer"));
  parameter Types.PerUnit XLvTrPu "Serial reactance of LV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "LV transformer"));

  //Configuration parameters to define how the user wants to represent the internal network
  parameter Boolean ConverterLVControl "Boolean parameter to choose whether the converter is controlling at its output (LV side of its transformer) : True ; or after its transformer (MV side): False" annotation(
    Dialog(tab = "LV transformer"));
  parameter Boolean PPCLocal "Boolean parameter to choose whether the Power Park Control is controlling at model's output terminal (True) or at a remote terminal using external measurements (False)" annotation(
    Dialog(tab = "MV network + MV/HV transformer"));

  // In every cases (RPcsPu + j*XPcsPu) and (GPcsPu + j*BPcsPu) are respectively the serial impedance and shunt admittance between WT terminal and model's output terminal
  //Depending on the 4 possible combinations of (ConverterLVControl ; PPCLocal) we are correctly defining these parameters
  final parameter Types.PerUnit BPcsPu = if PPCLocal and ConverterLVControl then BLvTrPu + BMvHvPu elseif PPCLocal and not ConverterLVControl then BMvHvPu
   elseif not PPCLocal and ConverterLVControl then BLvTrPu else 0 "Shunt susceptance between WT terminal and model's output terminal in pu (base UNom, SNom)";
  final parameter Types.PerUnit GPcsPu = if PPCLocal and ConverterLVControl then GLvTrPu + GMvHvPu elseif PPCLocal and not ConverterLVControl then GMvHvPu
   elseif not PPCLocal and ConverterLVControl then GLvTrPu else 0 "Shunt conductance between WT terminal and model's output terminal in pu (base UNom, SNom)";
  final parameter Types.PerUnit RPcsPu = if PPCLocal and ConverterLVControl then RLvTrPu + RMvHvPu elseif PPCLocal and not ConverterLVControl then RMvHvPu
   elseif not PPCLocal and ConverterLVControl then RLvTrPu else 0 "Serial resistance between WT terminal and model's output terminal in pu (base UNom, SNom)";
  final parameter Types.PerUnit XPcsPu = if PPCLocal and ConverterLVControl then XLvTrPu + XMvHvPu elseif PPCLocal and not ConverterLVControl then XMvHvPu
   elseif not PPCLocal and ConverterLVControl then XLvTrPu else 0 "Serial reactance between WT terminal and model's output terminal in pu (base UNom, SNom)";

  // In every cases (ResPu + j*XesPu) and (GesPu + j*BesPu) are respectively the serial impedance and shunt admittance between converter's output and WT terminal
  //Depending on the value of ConverterLVControl we are correctly defining these parameters
  final parameter Types.PerUnit BesPu = if ConverterLVControl then 0 else BLvTrPu "Shunt susceptance between converter output and WT terminal in pu (base UNom, SNom)";
  final parameter Types.PerUnit GesPu = if ConverterLVControl then 0 else GLvTrPu "Shunt conductance between converter output and WT terminal in pu (base UNom, SNom)";
  final parameter Types.PerUnit ResPu = if ConverterLVControl then 0 else RLvTrPu "Serial resistance between converter output and WT terminal in pu (base UNom, SNom)";
  final parameter Types.PerUnit XesPu = if ConverterLVControl then 0 else XLvTrPu "Serial reactance between converter output and WT terminal in pu (base UNom, SNom)";

  //Control parameters
  parameter Types.PerUnit DipMaxPu "Maximum active current ramp rate in pu/s (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Control"));
  parameter Types.PerUnit DiqMaxPu "Maximum reactive current ramp rate in pu/s (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Control"));
  parameter Types.PerUnit DiqMinPu "Minimum reactive current ramp rate in pu/s (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Control"));
  parameter Types.PerUnit Kipaw "Anti-windup gain for active current in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "Control"));
  parameter Types.PerUnit Kiqaw "Anti-windup gain for reactive current in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "Control"));
  parameter Types.Time tG "Current generation time constant in s" annotation(
    Dialog(tab = "Control"));

  //PLL parameters
  parameter Types.Time tPll "PLL first order filter time constant in s" annotation(
    Dialog(tab = "PLL"));
  parameter Types.VoltageModulePu UPll1Pu "Voltage below which the angle of the voltage is filtered and possibly also frozen, in pu (base UNom)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.VoltageModulePu UPll2Pu "Voltage below which the angle of the voltage is frozen, in pu (base UNom) (UPll2Pu < UPll1Pu typically)" annotation(
    Dialog(tab = "PLL"));

  //WT PControl parameters
  parameter Types.PerUnit Kpaw "Anti-windup gain for active power in pu/s (base SNom)" annotation(
    Dialog(tab = "PControl"));

  //Current limiter parameters
  parameter Types.CurrentModulePu IMaxDipPu "Maximum current during voltage dip at converter terminal in pu (base UNom, SNom)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Types.CurrentModulePu IMaxPu "Maximum continuous current at converter terminal in pu (base UNom, SNom)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Types.PerUnit Kpqu "Partial derivative of reactive current limit against voltage in pu (base UNom, SNom)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Boolean MdfsLim "Limitation of type 3 stator current (false: total current limitation, true: stator current limitation)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Boolean Mqpri "Prioritization of reactive power during FRT (false: active power priority, true: reactive power priority)" annotation(
    Dialog(tab = "CurrentLimiter"));
  parameter Types.VoltageModulePu UpquMaxPu "WT voltage in the operation point where zero reactive power can be delivered, in pu (base UNom)" annotation(
    Dialog(tab = "CurrentLimiter"));

  //WT QControl parameters
  parameter Types.PerUnit IqH1Pu "Maximum reactive current injection during dip in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit IqMaxPu "Maximum reactive current injection in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit IqMinPu "Minimum reactive current injection in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit IqPostPu "Post-fault reactive current injection in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kiq "Reactive power PI controller integration gain in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kiu "Voltage PI controller integration gain in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kpq "Reactive power PI controller proportional gain in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kpu "Voltage PI controller proportional gain in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kqv "Voltage scaling factor for FRT current in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Integer MqG "General Q control mode (0-4): Voltage control (0), Reactive power control (1), Open loop reactive power control (2), Power factor control (3), Open loop power factor control (4)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit RDropPu "Resistive component of voltage drop impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tPost "Length of time period where post-fault reactive power is injected, in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tQord "Reactive power order lag time constant in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu UMaxPu "Maximum voltage in voltage PI controller integral term in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu UMinPu "Minimum voltage in voltage PI controller integral term in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu UqDipPu "Voltage threshold for UVRT detection in Q control in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu URef0Pu "User-defined bias in voltage reference in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit XDropPu "Inductive component of voltage drop impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));

  //QLimiter parameters
  parameter Boolean QlConst "True if limits are constant" annotation(
    Dialog(tab = "QLimiter"));
  parameter Types.ReactivePowerPu QMaxPu "Constant maximum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "QLimiter"));
  parameter Types.ReactivePowerPu QMinPu "Constant minimum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "QLimiter"));

  //Grid protection parameters
  parameter Types.PerUnit fOverPu "WT over frequency protection activation threshold in pu (base fNom)" annotation(
    Dialog(tab = "GridProtection"));
  parameter Types.PerUnit fUnderPu "WT under frequency protection activation threshold in pu (base fNom)" annotation(
    Dialog(tab = "GridProtection"));
  parameter Types.VoltageModulePu UOverPu "WT over voltage protection activation threshold in pu (base UNom)" annotation(
    Dialog(tab = "GridProtection"));
  parameter Types.VoltageModulePu UUnderPu "WT under voltage protection activation threshold in pu (base UNom)" annotation(
    Dialog(tab = "GridProtection"));

  //WPP PControl parameters
  parameter Types.PerUnit DPRefMaxPu "Maximum positive ramp rate for PD power reference in pu/s (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit DPRefMinPu "Minimum negative ramp rate for PD power reference in pu/s (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit DPwpRefMaxPu "Maximum positive ramp rate for WP power reference in pu/s (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit DPwpRefMinPu "Minimum negative ramp rate for WP power reference in pu/s (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit Kiwpp "Power PI controller integration gain in pu/s (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit Kpwpp "Power PI controller proportional gain in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit KwppRef "Power reference gain in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PKiwppMaxPu "Maximum active power reference from integration in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PKiwppMinPu "Minimum active power reference from integration in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PRefMaxPu "Maximum PD power reference in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PRefMinPu "Minimum PD power reference in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));

  //WPP QControl parameters
  parameter Types.PerUnit DXRefMaxPu "Maximum positive ramp rate for WT reactive power or voltage reference in pu/s (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit DXRefMinPu "Minimum negative ramp rate for WT reactive power or voltage reference in pu/s (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit Kiwpx "Reactive power or voltage PI controller integral gain in pu/s (base SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit Kpwpx "Reactive power or voltage PI controller proportional gain in pu (base SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit KwpqRef "Reactive power reference gain in pu (base SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit Kwpqu "Voltage controller cross coupling gain in pu (base SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Integer MwpqMode "Control mode (0 : reactive power reference, 1 : power factor reference, 2 : UQ static, 3 : voltage control)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.Time tUqFilt "Time constant for the UQ static mode in s" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.VoltageModulePu UwpqDipPu "Voltage threshold for UVRT detection in pu (base UNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XKiwpxMaxPu "Maximum WT reactive power or voltage reference from integration in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XKiwpxMinPu "Minimum WT reactive power or voltage reference from integration in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XRefMaxPu "Maximum WT reactive power or voltage reference in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XRefMinPu "Minimum WT reactive power or voltage reference in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));

  //Interface
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(transformation(origin = {210, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference frame for grid angular frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-140, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput PPccPu(start = PPcc0Pu) "Active power measurement coming from the external PCC (base SnRef, receptor convention) (used only when PPCLocal = false)" annotation(
    Placement(transformation(origin = {220, 0}, extent = {{20, -20}, {-20, 20}}), iconTransformation(origin = {-60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PWPRefPu(start = PControl0Pu) "Reference active power in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-140, 80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QPccPu(start = QPcc0Pu) "Reactive power measurement coming from the external PCC (base SnRef, receptor convention) (used only when PPCLocal = false)" annotation(
    Placement(transformation(origin = {220, -30}, extent = {{20, -20}, {-20, 20}}), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput tanPhi(start = Q0Pu/P0Pu) "Tangent phi (can be figured as QPu / PPu)" annotation(
    Placement(visible = true, transformation(origin = {-20, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPccPu(re(start = Modelica.ComplexMath.real(Modelica.ComplexMath.fromPolar(UPcc0Pu, UPccPhase0))), im(start = Modelica.ComplexMath.imag(Modelica.ComplexMath.fromPolar(UPcc0Pu, UPccPhase0)))) annotation(
    Placement(transformation(origin = {220, -68}, extent = {{20, -20}, {-20, 20}}), iconTransformation(origin = {60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries.ElecMeasurements elecMeasurements(SNom = SNom) annotation(
    Placement(transformation(origin = {140, 40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = PPCLocal) annotation(
    Placement(transformation(origin = {90, -90}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Sources.IEC.BaseConverters.ElecSystem PCS(SNom = SNom, BPu = BPcsPu, GPu = GPcsPu, RPu = RPcsPu, XPu = XPcsPu, i20Pu = -i0Pu*SystemBase.SnRef/SNom, u20Pu = u0Pu) annotation(
    Placement(transformation(origin = {80, 40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(transformation(origin = {46, 4}, extent = {{6, -6}, {-6, 6}})));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(transformation(origin = {46, -14}, extent = {{6, -6}, {-6, 6}})));
  Modelica.Blocks.Logical.Switch switch3 annotation(
    Placement(transformation(origin = {46, -72}, extent = {{6, -6}, {-6, 6}})));
  Modelica.Blocks.Logical.Switch switch4 annotation(
    Placement(transformation(origin = {46, -54}, extent = {{6, -6}, {-6, 6}})));
  Modelica.ComplexBlocks.ComplexMath.RealToComplex realToComplex annotation(
    Placement(transformation(origin = {12, -4}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.ComplexBlocks.ComplexMath.RealToComplex realToComplex1 annotation(
    Placement(transformation(origin = {12, -64}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = -SystemBase.SnRef/SNom*Modelica.ComplexMath.imag(Modelica.ComplexMath.conj(Complex(PPccPu, QPccPu)/uPccPu))) annotation(
    Placement(transformation(origin = {138, -18}, extent = {{10, -10}, {-10, 10}})));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal annotation(
    Placement(transformation(origin = {148, -68}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = -SystemBase.SnRef/SNom*Modelica.ComplexMath.real(Modelica.ComplexMath.conj(Complex(PPccPu, QPccPu)/uPccPu))) annotation(
    Placement(transformation(origin = {138, 0}, extent = {{10, -10}, {-10, 10}})));

  //Initial parameters
  final parameter Types.ComplexCurrentPu i0Pu = Modelica.ComplexMath.conj(Complex(P0Pu, Q0Pu)/u0Pu) "Initial complex current at grid terminal in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.ComplexCurrentPu iControl0Pu = if PPCLocal then i0Pu else Modelica.ComplexMath.conj(Complex(PPcc0Pu, QPcc0Pu) / Modelica.ComplexMath.fromPolar(UPcc0Pu, UPccPhase0)) "Initial complex current to be controlled by the PPC coming either from the external bus or from the model's output terminal (receptor convention, base UNom, SnRef)";
  final parameter Types.ComplexCurrentPu iWt0Pu = i0Pu - Complex(GPcsPu, BPcsPu)*(u0Pu*SNom/SystemBase.SnRef - Complex(RPcsPu, XPcsPu)*i0Pu) "Initial complex current at WT terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  final parameter Types.ActivePowerPu PControl0Pu = if PPCLocal then -P0Pu * SystemBase.SnRef / SNom else -PPcc0Pu * SystemBase.SnRef / SNom "Initial active power at the point controlled by the PPC (either model's output terminal or external PCC) (base SNom, generator convetion)";
  parameter Types.CurrentComponent PPcc0Pu = 0 "Initial active power at the external bus controlled by the PPC (used when PPCLocal = False) (receptor convention, base UNom, SnRef) (only if the PCS is defined outside of the model)" annotation(
    Dialog(tab = "Operating point", enable = not PPCLocal));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  final parameter Types.ReactivePowerPu QControl0Pu = if PPCLocal then -Q0Pu * SystemBase.SnRef / SNom else -QPcc0Pu * SystemBase.SnRef / SNom "Initial reactive power at the point controlled by the PPC (either model's output terminal or external PCC) (base SNom, generator convention)";
  parameter Types.CurrentComponent QPcc0Pu = 0 "Initial reactive power at the external bus controlled by the PPC (used when PPCLocal = False) (receptor convention, base UNom, SnRef) (only if the PCS is defined outside of the model)" annotation(
    Dialog(tab = "Operating point", enable = not PPCLocal));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  final parameter Types.ComplexVoltagePu u0Pu = Modelica.ComplexMath.fromPolar(U0Pu, UPhase0) "Initial complex voltage at grid terminal in pu (base UNom)";
  parameter Types.CurrentModulePu UPcc0Pu = 1 "Initial voltage module at the external bus controlled by the PPC (used when PPCLocal = False) (base UNom) (only if the PCS is defined outside of the model)" annotation(
    Dialog(tab = "Operating point", enable = not PPCLocal));
  parameter Types.Angle UPccPhase0 = 0 "Initial voltage angle at the external bus controlled by the PPC (used when PPCLocal = False) (base UNom) (only if the PCS is defined outside of the model)" annotation(
    Dialog(tab = "Operating point", enable = not PPCLocal));
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad" annotation(
    Dialog(tab = "Operating point"));
  final parameter Types.ComplexVoltagePu uControl0Pu = if PPCLocal then u0Pu else Modelica.ComplexMath.fromPolar(UPcc0Pu, UPccPhase0) "Initial complex voltage to be controlled by the PPC coming either from the external bus or from the model's output terminal (base UNom)";
  final parameter Types.ComplexVoltagePu uWt0Pu = u0Pu - Complex(RPcsPu, XPcsPu)*i0Pu*SystemBase.SnRef/SNom "Initial complex voltage at WT terminal in pu (base UNom)";

equation
  connect(PCS.terminal2, elecMeasurements.terminal1) annotation(
    Line(points = {{102, 40}, {118, 40}}, color = {0, 0, 255}));
  connect(elecMeasurements.terminal2, terminal) annotation(
    Line(points = {{162, 40}, {210, 40}}, color = {0, 0, 255}));
  connect(PCS.i2RePu, switch1.u1) annotation(
    Line(points = {{72, 18}, {72, 9}, {53, 9}}, color = {0, 0, 127}));
  connect(PCS.i2ImPu, switch2.u1) annotation(
    Line(points = {{76, 18}, {76, -9}, {53, -9}}, color = {0, 0, 127}));
  connect(PCS.u2RePu, switch4.u1) annotation(
    Line(points = {{62, 18}, {62, -50}, {54, -50}}, color = {0, 0, 127}));
  connect(PCS.u2ImPu, switch3.u1) annotation(
    Line(points = {{66, 18}, {66, -68}, {54, -68}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch3.u2) annotation(
    Line(points = {{90, -78}, {90, -72}, {54, -72}}, color = {255, 0, 255}));
  connect(booleanConstant.y, switch4.u2) annotation(
    Line(points = {{90, -78}, {90, -54}, {54, -54}}, color = {255, 0, 255}));
  connect(booleanConstant.y, switch2.u2) annotation(
    Line(points = {{90, -78}, {90, -14}, {54, -14}}, color = {255, 0, 255}));
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{90, -78}, {90, 4}, {54, 4}}, color = {255, 0, 255}));
  connect(switch1.y, realToComplex.re) annotation(
    Line(points = {{40, 4}, {32, 4}, {32, 2}, {24, 2}}, color = {0, 0, 127}));
  connect(switch2.y, realToComplex.im) annotation(
    Line(points = {{40, -14}, {32, -14}, {32, -10}, {24, -10}}, color = {0, 0, 127}));
  connect(switch3.y, realToComplex1.im) annotation(
    Line(points = {{40, -72}, {32, -72}, {32, -70}, {24, -70}}, color = {0, 0, 127}));
  connect(switch4.y, realToComplex1.re) annotation(
    Line(points = {{40, -54}, {32, -54}, {32, -58}, {24, -58}}, color = {0, 0, 127}));
  connect(realExpression.y, switch1.u3) annotation(
    Line(points = {{127, 0}, {54, 0}}, color = {0, 0, 127}));
  connect(realExpression1.y, switch2.u3) annotation(
    Line(points = {{127, -18}, {54, -18}}, color = {0, 0, 127}));
  connect(uPccPu, complexToReal.u) annotation(
    Line(points = {{220, -68}, {160, -68}}, color = {85, 170, 255}));
  connect(complexToReal.im, switch3.u3) annotation(
    Line(points = {{136, -74}, {125, -74}, {125, -76}, {54, -76}}, color = {0, 0, 127}));
  connect(complexToReal.re, switch4.u3) annotation(
    Line(points = {{136, -62}, {126, -62}, {126, -58}, {54, -58}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-1.5, -1}, extent = {{-66.5, 32}, {66.5, -32}}, textString = "IEC WPP4")}),
    Diagram(coordinateSystem(extent = {{-120, -100}, {200, 100}})));
end BaseWPP;
