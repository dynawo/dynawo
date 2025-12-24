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

partial model BaseWT4 "Base model for Wind Turbine Type 4 from IEC 61400-27-1 standard"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.CurrentLimitParameters;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.GridProtectionParameters;
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.QLimitParameters;

  //Nominal parameters
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.Time tS "Integration time step in s";

  //Circuit parameters
  parameter Boolean ConverterLVControl = true "Boolean parameter to choose whether the converter is controlling at its output (LV side of its transformer) : True ; or after its transformer (MV side): False" annotation(
  Dialog(tab="Converter control"));
  parameter Types.PerUnit BesPu = 0 "Shunt susceptance between converter output and converter point of control in pu (base UNom, SNom)" annotation(
  Dialog(tab="Converter control", enable = not ConverterLVControl));
  parameter Types.PerUnit GesPu = 0 "Shunt conductance between converter output and converter point of control in pu (base UNom, SNom)" annotation(
  Dialog(tab="Converter control", enable = not ConverterLVControl));
  parameter Types.PerUnit ResPu = 0 "Serial resistance between converter output and converter point of control in pu (base UNom, SNom)" annotation(
  Dialog(tab="Converter control", enable = not ConverterLVControl));
  parameter Types.PerUnit XesPu = 0 "Serial reactance between converter output and converter point of control in pu (base UNom, SNom)" annotation(
  Dialog(tab="Converter control", enable = not ConverterLVControl));

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

  //PControl parameters
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

  //QControl parameters
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

  //Interface
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Grid terminal, complex voltage and current in pu (base UNom, SnRef) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference frame for grid angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {0, 130}, extent = {{10, -10}, {-10, 10}}, rotation = 90), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PWTRefPu(start = ip0Pu * U0Pu) "Active power reference at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput tanPhi(start = Q0Pu / P0Pu) "Tangent phi (can be figured as QPu / PPu)" annotation(
    Placement(visible = true, transformation(origin = {-130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput xWTRefPu(start = XWT0Pu) "Reactive power loop reference : reactive power or voltage reference depending on the Q control mode (MqG), in pu (base SNom or UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-130, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -19.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Sources.IEC.WT4Injector wT4Injector(BesPu = BesPu, DipMaxPu = DipMaxPu, DiqMaxPu = DiqMaxPu, DiqMinPu = DiqMinPu, GesPu = GesPu, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, Kipaw = Kipaw, Kiqaw = Kiqaw, P0Pu = P0Pu, Q0Pu = Q0Pu, ResPu = ResPu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, XesPu = XesPu, iWt0Pu = i0Pu, tG = tG, uWt0Pu = u0Pu, iq0Pu = iq0Pu, ip0Pu = ip0Pu) annotation(
    Placement(visible = true, transformation(origin = {20, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.Auxiliaries.PLL pll(U0Pu = U0Pu, UPhase0 = UPhase0, UPll1Pu = UPll1Pu, UPll2Pu = UPll2Pu, tPll = tPll, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {-20, 76}, extent = {{20, -20}, {-20, 20}}, rotation = 90)));

  //Initial parameters
  final parameter Types.ComplexCurrentPu i0Pu = Modelica.ComplexMath.conj(Complex(P0Pu,Q0Pu)/u0Pu) "Initial complex current at grid terminal in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.ComplexCurrentPu iGs0Pu = Complex(GesPu, BesPu)*(u0Pu - Complex(ResPu, XesPu)*i0Pu*SystemBase.SnRef/SNom) - i0Pu*SystemBase.SnRef/SNom "Complex current at converter output (base SNom) (generator convention)";
  final parameter Types.CurrentModulePu ip0Pu = cos(UPhase0)*iGs0Pu.re + sin(UPhase0)*iGs0Pu.im "Initial active current component at converter terminal in pu (base UNom, SNom) (generator convention)";
  final parameter Types.PerUnit IpMax0Pu = Modelica.Math.Vectors.interpolate(TableIpMaxUwt[:,1], TableIpMaxUwt[:,2], U0Pu) "Initial maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)";
  final parameter Types.CurrentModulePu iq0Pu = cos(UPhase0)*iGs0Pu.im - sin(UPhase0)*iGs0Pu.re "Initial reactive current component at converter terminal in pu (base UNom, SNom) (generator convention)";
  final parameter Types.PerUnit IqMax0Pu = min(Modelica.Math.Vectors.interpolate(TableIqMaxUwt[:,1], TableIqMaxUwt[:,2], U0Pu), max(0, IMaxPu^2 - min(IpMax0Pu, -P0Pu*SystemBase.SnRef/(SNom*U0Pu))^2)^0.5) "Initial maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)";
  final parameter Types.PerUnit IqMin0Pu = max(-IqMax0Pu, Kpqu * (U0Pu - UpquMaxPu)) "Initial minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" ;
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  final parameter Types.ReactivePowerPu QMax0Pu = if QlConst then QMaxPu else min(Modelica.Math.Vectors.interpolate(TableQMaxUwtcFilt[:,1], TableQMaxUwtcFilt[:,2], U0Pu), Modelica.Math.Vectors.interpolate(TableQMaxPwtcFilt[:,1], TableQMaxPwtcFilt[:,2], -P0Pu*SystemBase.SnRef/SNom)) "Initial maximum reactive power at grid terminal in pu (base SNom) (generator convention)";
  final parameter Types.ReactivePowerPu QMin0Pu = if QlConst then QMinPu else max(Modelica.Math.Vectors.interpolate(TableQMinUwtcFilt[:,1], TableQMinUwtcFilt[:,2], U0Pu), Modelica.Math.Vectors.interpolate(TableQMinPwtcFilt[:,1], TableQMinPwtcFilt[:,2], -P0Pu*SystemBase.SnRef/SNom)) "Initial minimum reactive power at grid terminal in pu (base SNom) (generator convention)";
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  final parameter Types.ComplexVoltagePu u0Pu = Modelica.ComplexMath.fromPolar(U0Pu, UPhase0) "Initial complex voltage at grid terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad" annotation(
    Dialog(tab = "Operating point"));
  final parameter Types.VoltageModulePu UWt0DroppedPu = ((U0Pu + RDropPu * P0Pu * SystemBase.SnRef / (SNom * U0Pu) + XDropPu * Q0Pu * SystemBase.SnRef / (SNom * U0Pu))^2 + (-XDropPu * P0Pu * SystemBase.SnRef / (SNom * U0Pu) + RDropPu * Q0Pu * SystemBase.SnRef / (SNom * U0Pu))^2)^0.5 "Initial voltage magnitude controlled by the WT (base UNom)";
  final parameter Types.PerUnit XWT0Pu = if MqG == 0 then UWt0DroppedPu - URef0Pu else -iq0Pu * U0Pu "Initial reactive power or voltage reference at grid WT terminal in pu (base SNom or UNom) (generator convention)";

equation
  connect(wT4Injector.terminal, terminal) annotation(
    Line(points = {{42, -40}, {130, -40}}, color = {0, 0, 255}));
  connect(pll.thetaPll, wT4Injector.theta) annotation(
    Line(points = {{-20, 54}, {-20, 0}, {8, 0}, {8, -18}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-1.5, -1}, extent = {{-66.5, 32}, {66.5, -32}}, textString = "IEC WT4")}),
    Diagram(coordinateSystem(extent = {{-120, -120}, {120, 120}})));
end BaseWT4;
