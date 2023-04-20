within Dynawo.Examples.RVS.BaseSystems;

model FullStaticModel
  import Modelica.SIunits.Conversions.from_deg;
  import Dynawo;
  import Dynawo.Electrical.SystemBase.SnRef;
  
  extends NetworkWithPQLoads;
  
  parameter Types.VoltageModule UNom_lower = 138;
  parameter Types.VoltageModule UNom_upper = 230;

  parameter Types.VoltageModule URef0_bus_101;
  parameter Types.VoltageModule URef0_bus_102;
  parameter Types.VoltageModule URef0_bus_106;
  parameter Types.VoltageModule URef0_bus_107;
  parameter Types.VoltageModule URef0_bus_110;
  parameter Types.VoltageModule URef0_bus_113;
  parameter Types.VoltageModule URef0_bus_115;
  parameter Types.VoltageModule URef0_bus_116;
  parameter Types.VoltageModule URef0_bus_118;
  parameter Types.VoltageModule URef0_bus_122;
  parameter Types.VoltageModule URef0_bus_123;

  parameter Types.ReactivePowerPu Q0Pu_sVarC_10106;
  parameter Types.ReactivePowerPu Q0Pu_sVarC_10114;
  parameter Types.ActivePowerPu PRef0Pu_gen_10101;
  parameter Types.ActivePowerPu PRef0Pu_gen_10102;
  parameter Types.ActivePowerPu PRef0Pu_gen_10107;
  parameter Types.ActivePowerPu PRef0Pu_gen_10113;
  parameter Types.ActivePowerPu PRef0Pu_gen_10115;
  parameter Types.ActivePowerPu PRef0Pu_gen_10116;
  parameter Types.ActivePowerPu PRef0Pu_gen_10118;
  parameter Types.ActivePowerPu PRef0Pu_gen_10122;
  parameter Types.ActivePowerPu PRef0Pu_gen_10123;
  parameter Types.ActivePowerPu PRef0Pu_gen_20101;
  parameter Types.ActivePowerPu PRef0Pu_gen_20102;
  parameter Types.ActivePowerPu PRef0Pu_gen_20107;
  parameter Types.ActivePowerPu PRef0Pu_gen_20113;
  parameter Types.ActivePowerPu PRef0Pu_gen_20115;
  parameter Types.ActivePowerPu PRef0Pu_gen_20122;
  parameter Types.ActivePowerPu PRef0Pu_gen_20123;
  parameter Types.ActivePowerPu PRef0Pu_gen_30101;
  parameter Types.ActivePowerPu PRef0Pu_gen_30102;
  parameter Types.ActivePowerPu PRef0Pu_gen_30107;
  parameter Types.ActivePowerPu PRef0Pu_gen_30113;
  parameter Types.ActivePowerPu PRef0Pu_gen_30115;
  parameter Types.ActivePowerPu PRef0Pu_gen_30122;
  parameter Types.ActivePowerPu PRef0Pu_gen_30123;
  parameter Types.ActivePowerPu PRef0Pu_gen_40101;
  parameter Types.ActivePowerPu PRef0Pu_gen_40102;
  parameter Types.ActivePowerPu PRef0Pu_gen_40115;
  parameter Types.ActivePowerPu PRef0Pu_gen_40122;
  parameter Types.ActivePowerPu PRef0Pu_gen_50115;
  parameter Types.ActivePowerPu PRef0Pu_gen_50122;
  parameter Types.ActivePowerPu PRef0Pu_gen_60115;
  parameter Types.ActivePowerPu PRef0Pu_gen_60122;
  parameter Types.VoltageModulePu U0Pu_gen_10101;
  parameter Types.VoltageModulePu U0Pu_gen_10102;
  parameter Types.VoltageModulePu U0Pu_gen_10107;
  parameter Types.VoltageModulePu U0Pu_gen_10113;
  parameter Types.VoltageModulePu U0Pu_gen_10115;
  parameter Types.VoltageModulePu U0Pu_gen_10116;
  parameter Types.VoltageModulePu U0Pu_gen_10118;
  parameter Types.VoltageModulePu U0Pu_gen_10122;
  parameter Types.VoltageModulePu U0Pu_gen_10123;
  parameter Types.VoltageModulePu U0Pu_gen_20101;
  parameter Types.VoltageModulePu U0Pu_gen_20102;
  parameter Types.VoltageModulePu U0Pu_gen_20107;
  parameter Types.VoltageModulePu U0Pu_gen_20113;
  parameter Types.VoltageModulePu U0Pu_gen_20115;
  parameter Types.VoltageModulePu U0Pu_gen_20122;
  parameter Types.VoltageModulePu U0Pu_gen_20123;
  parameter Types.VoltageModulePu U0Pu_gen_30101;
  parameter Types.VoltageModulePu U0Pu_gen_30102;
  parameter Types.VoltageModulePu U0Pu_gen_30107;
  parameter Types.VoltageModulePu U0Pu_gen_30113;
  parameter Types.VoltageModulePu U0Pu_gen_30115;
  parameter Types.VoltageModulePu U0Pu_gen_30122;
  parameter Types.VoltageModulePu U0Pu_gen_30123;
  parameter Types.VoltageModulePu U0Pu_gen_40101;
  parameter Types.VoltageModulePu U0Pu_gen_40102;
  parameter Types.VoltageModulePu U0Pu_gen_40115;
  parameter Types.VoltageModulePu U0Pu_gen_40122;
  parameter Types.VoltageModulePu U0Pu_gen_50115;
  parameter Types.VoltageModulePu U0Pu_gen_50122;
  parameter Types.VoltageModulePu U0Pu_gen_60115;
  parameter Types.VoltageModulePu U0Pu_gen_60122;

  Dynawo.Electrical.Controls.Basics.SetPoint N(Value0 = 0);
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = from_deg(13.4), UPu = 1.04685) annotation(
    Placement(visible = true, transformation(origin = {-100, 226}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10121_121(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 471, XPu = 0.15 * 100 / 471, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-80, 186}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1118_118(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 450, Tap0 = 11, X = 0.15 * 100, rTfo0Pu = 1 + (11 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {60, 164}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10118_118(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 471, XPu = 0.15 * 100 / 471, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {20, 104}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_10118_ASTOR_G1(KGover = 0, PGen0Pu = PRef0Pu_gen_10118, PMaxPu = 999, PMinPu = 0, PNom = 400, PRef0Pu = -PRef0Pu_gen_10118, QMaxPu = 2, QMinPu = -0.5, QPercent = 1, U0Pu = U0Pu_gen_10118) annotation(
    Placement(visible = true, transformation(origin = {-20, 104}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_20115_ARTHUR_G2(KGover = 0, PGen0Pu = PRef0Pu_gen_20115, PMaxPu = 999, PMinPu = 0, PNom = 12, PRef0Pu = -PRef0Pu_gen_20115, QMaxPu = 0.06, QMinPu = 0, QPercent = 0.05410822, U0Pu = U0Pu_gen_20115) annotation(
    Placement(visible = true, transformation(origin = {-230, 156}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_30115_ARTHUR_G3(KGover = 0, PGen0Pu = PRef0Pu_gen_30115, PMaxPu = 999, PMinPu = 0, PNom = 12, PRef0Pu = -PRef0Pu_gen_30115, QMaxPu = 0.06, QMinPu = 0, QPercent = 0.05410822, U0Pu = U0Pu_gen_30115) annotation(
    Placement(visible = true, transformation(origin = {-230, 116}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_40115_ARTHUR_G4(KGover = 0, PGen0Pu = PRef0Pu_gen_40115, PMaxPu = 999, PMinPu = 0, PNom = 12, PRef0Pu = -PRef0Pu_gen_40115, QMaxPu = 0.06, QMinPu = 0, QPercent = 0.05410822, U0Pu = U0Pu_gen_40115) annotation(
    Placement(visible = true, transformation(origin = {-230, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_60115_ARTHUR_G6(KGover = 0, PGen0Pu = PRef0Pu_gen_60115, PMaxPu = 999, PMinPu = 0, PNom = 155, PRef0Pu = -PRef0Pu_gen_60115, QMaxPu = 0.8, QMinPu = -0.5, QPercent = 0.7294589, U0Pu = U0Pu_gen_60115) annotation(
    Placement(visible = true, transformation(origin = {-230, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_10115_ARTHUR_G1(KGover = 0, PGen0Pu = PRef0Pu_gen_10115, PMaxPu = 999, PMinPu = 0, PNom = 12, PRef0Pu = -PRef0Pu_gen_10115, QMaxPu = 0.06, QMinPu = 0, QPercent = 0.05410822, U0Pu = U0Pu_gen_10115) annotation(
    Placement(visible = true, transformation(origin = {-230, 196}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_50115_ARTHUR_G5(KGover = 0, PGen0Pu = PRef0Pu_gen_50115, PMaxPu = 999, PMinPu = 0, PNom = 12, PRef0Pu = -PRef0Pu_gen_50115, QMaxPu = 0.06, QMinPu = 0, QPercent = 0.05410822, U0Pu = U0Pu_gen_50115) annotation(
    Placement(visible = true, transformation(origin = {-230, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_115(Gain = 1, U0 = URef0_bus_115, URef0 = URef0_bus_115, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-170, 216}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-190, 116}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_40115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-190, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_60115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 182, XPu = 0.15 * 100 / 182, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-190, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_50115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-190, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-190, 156}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-190, 196}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1115_115(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 400, Tap0 = 6, X = 0.15 * 100, rTfo0Pu = 1 + (6 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-152, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.StaticVarCompensators.SVarCPV sVarC_10114_ARNOLD_SVC(B0Pu = Q0Pu_sVarC_10114 / 1.05 ^ 2, BMaxPu = 0.5, BMinPu = -2, BShuntPu = 0, U0Pu = 1.05, UNom = 18, URef0Pu = 1.05, i0Pu = Complex(0, Q0Pu_sVarC_10114), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {48, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10114_114(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 200, XPu = 0.15 * 100 / 200, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {8, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1114_114(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 250, Tap0 = 6, X = 0.15 * 100, rTfo0Pu = 1 + (6 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {8, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10116_116(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 182, XPu = 0.15 * 100 / 182, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-72, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1116_116(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 150, Tap0 = 8, X = 0.15 * 100, rTfo0Pu = 1 + (8 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-70, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_116(Gain = 1, U0 = URef0_bus_116, URef0 = URef0_bus_116, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-50, 86}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_10116_ASSER_G1(KGover = 0, PGen0Pu = PRef0Pu_gen_10116, PMaxPu = 999, PMinPu = 0, PNom = 155, PRef0Pu = -PRef0Pu_gen_10116, QMaxPu = 0.8, QMinPu = -0.5, QPercent = 1, U0Pu = U0Pu_gen_10116) annotation(
    Placement(visible = true, transformation(origin = {-112, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_118(Gain = 1, U0 = URef0_bus_118, URef0 = URef0_bus_118, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {40, 184}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_20101_ABEL_G2(KGover = 0, PGen0Pu = PRef0Pu_gen_20101, PMaxPu = 999, PMinPu = 0, PNom = 20, PRef0Pu = -PRef0Pu_gen_20101, QMaxPu = 0.1, QMinPu = 0, QPercent = 0.126, U0Pu = U0Pu_gen_20101) annotation(
    Placement(visible = true, transformation(origin = {-174, -362}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_40101_ABEL_G4(KGover = 0, PGen0Pu = PRef0Pu_gen_40101, PMaxPu = 999, PMinPu = 0, PNom = 76, PRef0Pu = -PRef0Pu_gen_40101, QMaxPu = 0.3, QMinPu = -0.25, QPercent = 0.374, U0Pu = U0Pu_gen_40101) annotation(
    Placement(visible = true, transformation(origin = {-94, -362}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_10101_ABEL_G1(KGover = 0, PGen0Pu = PRef0Pu_gen_10101, PMaxPu = 999, PMinPu = 0, PNom = 20, PRef0Pu = -PRef0Pu_gen_10101, QMaxPu = 0.1, QMinPu = 0, QPercent = 0.126, U0Pu = U0Pu_gen_10101) annotation(
    Placement(visible = true, transformation(origin = {-214, -362}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_30101_ABEL_G3(KGover = 0, PGen0Pu = PRef0Pu_gen_30101, PMaxPu = 999, PMinPu = 0, PNom = 76, PRef0Pu = -PRef0Pu_gen_30101, QMaxPu = 0.3, QMinPu = -0.25, QPercent = 0.374, U0Pu = U0Pu_gen_30101) annotation(
    Placement(visible = true, transformation(origin = {-134, -362}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30101_101(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 89, XPu = 0.15 * 100 / 89, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-134, -322}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_40101_101(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 89, XPu = 0.15 * 100 / 89, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-94, -322}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1101_101(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 150, Tap0 = 10, X = 0.15 * 100, rTfo0Pu = 1 + (10 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-214, -282}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1103_103(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 250, Tap0 = 5, X = 0.15 * 100, rTfo0Pu = 1 + (5 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-174, -222}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10101_101(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 24, XPu = 0.15 * 100 / 24, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-214, -322}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_103_124(B = 0, G = 0, NbTap = 33, R = 0.008 * 100, SNom = 400, Tap0 = 1, X = 0.336 * 100, rTfo0Pu = 1 + (1 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-134, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20101_101(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 24, XPu = 0.15 * 100 / 24, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-174, -322}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_101(Gain = 1, U0 = URef0_bus_101, URef0 = URef0_bus_101, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-234, -302}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 24, XPu = 0.15 * 100 / 24, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {30, -362}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 89, XPu = 0.15 * 100 / 89, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {70, -362}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_40102_ADAMS_G4(KGover = 0, PGen0Pu = PRef0Pu_gen_40102, PMaxPu = 999, PMinPu = 0, PNom = 76, PRef0Pu = -PRef0Pu_gen_40102, QMaxPu = 0.3, QMinPu = -0.25, QPercent = 0.322, U0Pu = U0Pu_gen_40102) annotation(
    Placement(visible = true, transformation(origin = {110, -402}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_30102_ADAMS_G3(KGover = 0, PGen0Pu = PRef0Pu_gen_30102, PMaxPu = 999, PMinPu = 0, PNom = 76, PRef0Pu = -PRef0Pu_gen_30102, QMaxPu = 0.3, QMinPu = -0.25, QPercent = 0.322, U0Pu = U0Pu_gen_30102) annotation(
    Placement(visible = true, transformation(origin = {70, -402}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_10102_ADAMS_G1(KGover = 0, PGen0Pu = PRef0Pu_gen_10102, PMaxPu = 999, PMinPu = 0, PNom = 20, PRef0Pu = -PRef0Pu_gen_10102, QMaxPu = 0.1, QMinPu = 0, QPercent = 0.178, U0Pu = U0Pu_gen_10102) annotation(
    Placement(visible = true, transformation(origin = {-10, -402}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_20102_ADAMS_G2(KGover = 0, PGen0Pu = PRef0Pu_gen_20102, PMaxPu = 999, PMinPu = 0, PNom = 20, PRef0Pu = -PRef0Pu_gen_20102, QMaxPu = 0.1, QMinPu = 0, QPercent = 0.178, U0Pu = U0Pu_gen_20102) annotation(
    Placement(visible = true, transformation(origin = {30, -402}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 24, XPu = 0.15 * 100 / 24, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {-10, -362}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_40102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 89, XPu = 0.15 * 100 / 89, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {110, -362}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1102_102(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 150, Tap0 = 11, X = 0.15 * 100, rTfo0Pu = 1 + (11 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-40, -362}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_102(Gain = 1, U0 = URef0_bus_102, URef0 = URef0_bus_102, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-70, -342}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.StaticVarCompensators.SVarCPV sVarC_10106_ALBER_SVC(B0Pu = Q0Pu_sVarC_10106 / 1.05 ^ 2, BMaxPu = 0.5, BMinPu = -1, BShuntPu = 0, U0Pu = 1.05, UNom = 18, URef0Pu = 1.05, i0Pu = Complex(0, Q0Pu_sVarC_10106), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {206, -322}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10106_106(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 120, XPu = 0.15 * 100 / 120, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {166, -322}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1106_106(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 200, Tap0 = 10, X = 0.15 * 100, rTfo0Pu = 1 + (10 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {166, -362}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_10122_AUBREY_G1(KGover = 0, PGen0Pu = PRef0Pu_gen_10122, PMaxPu = 999, PMinPu = 0, PNom = 50, PRef0Pu = -PRef0Pu_gen_10122, QMaxPu = 0.16, QMinPu = -0.1, QPercent = 0.1666667, U0Pu = U0Pu_gen_10122) annotation(
    Placement(visible = true, transformation(origin = {200, 182}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_40122_AUBREY_G4(KGover = 0, PGen0Pu = PRef0Pu_gen_40122, PMaxPu = 999, PMinPu = 0, PNom = 50, PRef0Pu = -PRef0Pu_gen_40122, QMaxPu = 0.16, QMinPu = -0.1, QPercent = 0.1666667, U0Pu = U0Pu_gen_40122) annotation(
    Placement(visible = true, transformation(origin = {332, 172}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {280, 212}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_60122_AUBREY_G6(KGover = 0, PGen0Pu = PRef0Pu_gen_60122, PMaxPu = 999, PMinPu = 0, PNom = 50, PRef0Pu = -PRef0Pu_gen_60122, QMaxPu = 0.16, QMinPu = -0.1, QPercent = 0.1666667, U0Pu = U0Pu_gen_60122) annotation(
    Placement(visible = true, transformation(origin = {332, 92}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {240, 142}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_50122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {280, 132}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_50122_AUBREY_G5(KGover = 0, PGen0Pu = PRef0Pu_gen_50122, PMaxPu = 999, PMinPu = 0, PNom = 50, PRef0Pu = -PRef0Pu_gen_50122, QMaxPu = 0.16, QMinPu = -0.1, QPercent = 0.1666667, U0Pu = U0Pu_gen_50122) annotation(
    Placement(visible = true, transformation(origin = {332, 132}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_40122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {280, 172}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_60122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {280, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_20122_AUBREY_G2(KGover = 0, PGen0Pu = PRef0Pu_gen_20122, PMaxPu = 999, PMinPu = 0, PNom = 50, PRef0Pu = -PRef0Pu_gen_20122, QMaxPu = 0.16, QMinPu = -0.1, QPercent = 0.1666667, U0Pu = U0Pu_gen_20122) annotation(
    Placement(visible = true, transformation(origin = {200, 142}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {240, 182}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_30122_AUBREY_G3(KGover = 0, PGen0Pu = PRef0Pu_gen_30122, PMaxPu = 999, PMinPu = 0, PNom = 50, PRef0Pu = -PRef0Pu_gen_30122, QMaxPu = 0.16, QMinPu = -0.1, QPercent = 0.1666667, U0Pu = U0Pu_gen_30122) annotation(
    Placement(visible = true, transformation(origin = {332, 212}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_122(Gain = 1, U0 = URef0_bus_122, URef0 = URef0_bus_122, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {260, 232}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1120_120(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 200, Tap0 = 10, X = 0.15 * 100, rTfo0Pu = 1 + (10 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {180, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1119_119(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 250, Tap0 = 7, X = 0.15 * 100, rTfo0Pu = 1 + (7 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {100, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20123_123(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 182, XPu = 0.15 * 100 / 182, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {280, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30123_123(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 412, XPu = 0.15 * 100 / 412, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {280, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10123_123(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 182, XPu = 0.15 * 100 / 182, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {280, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_10123_AUSTEN_G1(KGover = 0, PGen0Pu = PRef0Pu_gen_10123, PMaxPu = 999, PMinPu = 0, PNom = 155, PRef0Pu = -PRef0Pu_gen_10123, QMaxPu = 0.8, QMinPu = -0.5, QPercent = 0.258, U0Pu = 1.0491) annotation(
    Placement(visible = true, transformation(origin = {330, 50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_20123_AUSTEN_G2(KGover = 0, PGen0Pu = PRef0Pu_gen_20123, PMaxPu = 999, PMinPu = 0, PNom = 155, PRef0Pu = -PRef0Pu_gen_20123, QMaxPu = 0.8, QMinPu = -0.5, QPercent = 0.258, U0Pu = 1.0491) annotation(
    Placement(visible = true, transformation(origin = {330, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_123(Gain = 1, U0 = URef0_bus_123, URef0 = URef0_bus_123, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {260, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_30123_AUSTEN_G3(KGover = 0, PGen0Pu = PRef0Pu_gen_30123, PMaxPu = 999, PMinPu = 0, PNom = 350, PRef0Pu = -PRef0Pu_gen_30123, QMaxPu = 1.5, QMinPu = -0.5, QPercent = 0.484, U0Pu = 1.0401) annotation(
    Placement(visible = true, transformation(origin = {330, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_10113_ARNE_G1(KGover = 0, PGen0Pu = PRef0Pu_gen_10113, PMaxPu = 999, PMinPu = 0, PNom = 197, PRef0Pu = -PRef0Pu_gen_10113, QMaxPu = 0.827791, QMinPu = 0, QPercent = 0.01492537) annotation(
    Placement(visible = true, transformation(origin = {220, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_30113_ARNE_G3(KGover = 0, PGen0Pu = PRef0Pu_gen_30113, PMaxPu = 999, PMinPu = 0, PNom = 197, PRef0Pu = -PRef0Pu_gen_30113, QMaxPu = 80, QMinPu = 0, QPercent = 0.4925373) annotation(
    Placement(visible = true, transformation(origin = {220, -130}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10113_113(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 232, XPu = 0.15 * 100 / 232, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {180, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_113(Gain = 1, U0 = URef0_bus_113, URef0 = URef0_bus_113, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {160, -150}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30113_113(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 232, XPu = 0.15 * 100 / 232, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {180, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_20113_ARNE_G2(KGover = 0, PGen0Pu = PRef0Pu_gen_20113, PMaxPu = 999, PMinPu = 0, PNom = 197, PRef0Pu = -PRef0Pu_gen_20113, QMaxPu = 80, QMinPu = 0, QPercent = 0.4925373) annotation(
    Placement(visible = true, transformation(origin = {220, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20113_113(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 232, XPu = 0.15 * 100 / 232, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {180, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1113_113(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 350, Tap0 = 7, X = 0.15 * 100, rTfo0Pu = 1 + (7 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {140, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30107_107(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 118, XPu = 0.15 * 100 / 118, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {290, -310}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20107_107(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 118, XPu = 0.15 * 100 / 118, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {290, -270}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10107_107(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 118, XPu = 0.15 * 100 / 118, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {290, -230}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_10107_ALDER_G1(KGover = 0, PGen0Pu = PRef0Pu_gen_10107, PMaxPu = 999, PMinPu = 0, PNom = 100, PRef0Pu = -PRef0Pu_gen_10107, QMaxPu = 0.6, QMinPu = 0, QPercent = 0.3333333, U0Pu = 1.037) annotation(
    Placement(visible = true, transformation(origin = {330, -230}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_107(Gain = 1, U0 = URef0_bus_107, URef0 = URef0_bus_107, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {270, -210}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_30107_ALDER_G3(KGover = 0, PGen0Pu = PRef0Pu_gen_30107, PMaxPu = 999, PMinPu = 0, PNom = 100, PRef0Pu = -PRef0Pu_gen_30107, QMaxPu = 0.6, QMinPu = 0, QPercent = 0.3333333, U0Pu = 1.037) annotation(
    Placement(visible = true, transformation(origin = {330, -310}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_20107_ALDER_G2(KGover = 0, PGen0Pu = PRef0Pu_gen_20107, PMaxPu = 999, PMinPu = 0, PNom = 100, PRef0Pu = -PRef0Pu_gen_20107, QMaxPu = 0.6, QMinPu = 0, QPercent = 0.3333333, U0Pu = 1.037) annotation(
    Placement(visible = true, transformation(origin = {330, -270}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1107_107(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 200, Tap0 = 10, X = 0.15 * 100, rTfo0Pu = 1 + (10 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {250, -310}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1108_108(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 250, Tap0 = 7, X = 0.15 * 100, rTfo0Pu = 1 + (7 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {210, -270}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_109_111(B = 0, G = 0, NbTap = 33, R = 0.008 * 100, SNom = 400, Tap0 = 12, X = 0.336 * 100, rTfo0Pu = 1 + (12 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-40, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1109_109(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 250, Tap0 = 7, X = 0.15 * 100, rTfo0Pu = 1 + (7 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-46, -224}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1104_104(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 100, Tap0 = 4, X = 0.15 * 100, rTfo0Pu = 1 + (4 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-46, -264}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_110_112(B = 0, G = 0, NbTap = 33, R = 0.008 * 100, SNom = 400, Tap0 = 12, X = 0.336 * 100, rTfo0Pu = 1 + (12 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {62, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_110_111(B = 0, G = 0, NbTap = 33, R = 0.008 * 100, SNom = 400, Tap0 = 13, X = 0.336 * 100, rTfo0Pu = 1 + (13 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {10, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_109_112(B = 0, G = 0, NbTap = 33, R = 0.008 * 100, SNom = 400, Tap0 = 0, X = 0.336 * 100, rTfo0Pu = 1 + (0 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {10, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1105_105(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 100, Tap0 = 5, X = 0.15 * 100, rTfo0Pu = 1 + (5 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {42, -320}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerVariableTap2 tfo_1110_110(B = 0, G = 0, NbTap = 33, R = 0.003 * 100, SNom = 250, Tap0 = 6, X = 0.15 * 100, rTfo0Pu = 1 + (6 - 16) * 0.625 / 100, rTfoMaxPu = 1.1, rTfoMinPu = 0.9, u10Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {80, -170}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

equation
  when time >= 0 then
    tfo_103_124.tap.value = tfo_103_124.Tap0;
    tfo_109_111.tap.value = tfo_109_111.Tap0;
    tfo_109_112.tap.value = tfo_109_112.Tap0;
    tfo_110_111.tap.value = tfo_110_111.Tap0;
    tfo_110_112.tap.value = tfo_110_112.Tap0;
    tfo_1101_101.tap.value = tfo_1101_101.Tap0;
    tfo_1102_102.tap.value = tfo_1102_102.Tap0;
    tfo_1103_103.tap.value = tfo_1103_103.Tap0;
    tfo_1104_104.tap.value = tfo_1104_104.Tap0;
    tfo_1105_105.tap.value = tfo_1105_105.Tap0;
    tfo_1106_106.tap.value = tfo_1106_106.Tap0;
    tfo_1107_107.tap.value = tfo_1107_107.Tap0;
    tfo_1108_108.tap.value = tfo_1108_108.Tap0;
    tfo_1109_109.tap.value = tfo_1109_109.Tap0;
    tfo_1110_110.tap.value = tfo_1110_110.Tap0;
    tfo_1113_113.tap.value = tfo_1113_113.Tap0;
    tfo_1114_114.tap.value = tfo_1114_114.Tap0;
    tfo_1115_115.tap.value = tfo_1115_115.Tap0;
    tfo_1116_116.tap.value = tfo_1116_116.Tap0;
    tfo_1118_118.tap.value = tfo_1118_118.Tap0;
    tfo_1119_119.tap.value = tfo_1119_119.Tap0;
    tfo_1120_120.tap.value = tfo_1120_120.Tap0;
  end when;
  tfo_1101_101.switchOffSignal1.value = false;
  tfo_1101_101.switchOffSignal2.value = false;
  tfo_10101_101.switchOffSignal1.value = false;
  tfo_10101_101.switchOffSignal2.value = false;
  tfo_20101_101.switchOffSignal1.value = false;
  tfo_20101_101.switchOffSignal2.value = false;
  tfo_30101_101.switchOffSignal1.value = false;
  tfo_30101_101.switchOffSignal2.value = false;
  tfo_40101_101.switchOffSignal1.value = false;
  tfo_40101_101.switchOffSignal2.value = false;
  tfo_1102_102.switchOffSignal1.value = false;
  tfo_1102_102.switchOffSignal2.value = false;
  tfo_10102_102.switchOffSignal1.value = false;
  tfo_10102_102.switchOffSignal2.value = false;
  tfo_20102_102.switchOffSignal1.value = false;
  tfo_20102_102.switchOffSignal2.value = false;
  tfo_30102_102.switchOffSignal1.value = false;
  tfo_30102_102.switchOffSignal2.value = false;
  tfo_40102_102.switchOffSignal1.value = false;
  tfo_40102_102.switchOffSignal2.value = false;
  tfo_1103_103.switchOffSignal1.value = false;
  tfo_1103_103.switchOffSignal2.value = false;
  tfo_103_124.switchOffSignal1.value = false;
  tfo_103_124.switchOffSignal2.value = false;
  tfo_1104_104.switchOffSignal1.value = false;
  tfo_1104_104.switchOffSignal2.value = false;
  tfo_1105_105.switchOffSignal1.value = false;
  tfo_1105_105.switchOffSignal2.value = false;
  tfo_1106_106.switchOffSignal1.value = false;
  tfo_1106_106.switchOffSignal2.value = false;
  tfo_10106_106.switchOffSignal1.value = false;
  tfo_10106_106.switchOffSignal2.value = false;
  tfo_1107_107.switchOffSignal1.value = false;
  tfo_1107_107.switchOffSignal2.value = false;
  tfo_10107_107.switchOffSignal1.value = false;
  tfo_10107_107.switchOffSignal2.value = false;
  tfo_20107_107.switchOffSignal1.value = false;
  tfo_20107_107.switchOffSignal2.value = false;
  tfo_30107_107.switchOffSignal1.value = false;
  tfo_30107_107.switchOffSignal2.value = false;
  tfo_1108_108.switchOffSignal1.value = false;
  tfo_1108_108.switchOffSignal2.value = false;
  tfo_1109_109.switchOffSignal1.value = false;
  tfo_1109_109.switchOffSignal2.value = false;
  tfo_109_111.switchOffSignal1.value = false;
  tfo_109_111.switchOffSignal2.value = false;
  tfo_109_112.switchOffSignal1.value = false;
  tfo_109_112.switchOffSignal2.value = false;
  tfo_110_111.switchOffSignal1.value = false;
  tfo_110_111.switchOffSignal2.value = false;
  tfo_110_112.switchOffSignal1.value = false;
  tfo_110_112.switchOffSignal2.value = false;
  tfo_1110_110.switchOffSignal1.value = false;
  tfo_1110_110.switchOffSignal2.value = false;
  tfo_1113_113.switchOffSignal1.value = false;
  tfo_1113_113.switchOffSignal2.value = false;
  tfo_10113_113.switchOffSignal1.value = false;
  tfo_10113_113.switchOffSignal2.value = false;
  tfo_20113_113.switchOffSignal1.value = false;
  tfo_20113_113.switchOffSignal2.value = false;
  tfo_30113_113.switchOffSignal1.value = false;
  tfo_30113_113.switchOffSignal2.value = false;
  tfo_1114_114.switchOffSignal1.value = false;
  tfo_1114_114.switchOffSignal2.value = false;
  tfo_10114_114.switchOffSignal1.value = false;
  tfo_10114_114.switchOffSignal2.value = false;
  tfo_1115_115.switchOffSignal1.value = false;
  tfo_1115_115.switchOffSignal2.value = false;
  tfo_10115_115.switchOffSignal1.value = false;
  tfo_10115_115.switchOffSignal2.value = false;
  tfo_20115_115.switchOffSignal1.value = false;
  tfo_20115_115.switchOffSignal2.value = false;
  tfo_30115_115.switchOffSignal1.value = false;
  tfo_30115_115.switchOffSignal2.value = false;
  tfo_40115_115.switchOffSignal1.value = false;
  tfo_40115_115.switchOffSignal2.value = false;
  tfo_50115_115.switchOffSignal1.value = false;
  tfo_50115_115.switchOffSignal2.value = false;
  tfo_60115_115.switchOffSignal1.value = false;
  tfo_60115_115.switchOffSignal2.value = false;
  tfo_1116_116.switchOffSignal1.value = false;
  tfo_1116_116.switchOffSignal2.value = false;
  tfo_10116_116.switchOffSignal1.value = false;
  tfo_10116_116.switchOffSignal2.value = false;
  tfo_1118_118.switchOffSignal1.value = false;
  tfo_1118_118.switchOffSignal2.value = false;
  tfo_10118_118.switchOffSignal1.value = false;
  tfo_10118_118.switchOffSignal2.value = false;
  tfo_1119_119.switchOffSignal1.value = false;
  tfo_1119_119.switchOffSignal2.value = false;
  tfo_1120_120.switchOffSignal1.value = false;
  tfo_1120_120.switchOffSignal2.value = false;
  tfo_10121_121.switchOffSignal1.value = false;
  tfo_10121_121.switchOffSignal2.value = false;
  tfo_10122_122.switchOffSignal1.value = false;
  tfo_10122_122.switchOffSignal2.value = false;
  tfo_20122_122.switchOffSignal1.value = false;
  tfo_20122_122.switchOffSignal2.value = false;
  tfo_30122_122.switchOffSignal1.value = false;
  tfo_30122_122.switchOffSignal2.value = false;
  tfo_40122_122.switchOffSignal1.value = false;
  tfo_40122_122.switchOffSignal2.value = false;
  tfo_50122_122.switchOffSignal1.value = false;
  tfo_50122_122.switchOffSignal2.value = false;
  tfo_60122_122.switchOffSignal1.value = false;
  tfo_60122_122.switchOffSignal2.value = false;
  tfo_10123_123.switchOffSignal1.value = false;
  tfo_10123_123.switchOffSignal2.value = false;
  tfo_20123_123.switchOffSignal1.value = false;
  tfo_20123_123.switchOffSignal2.value = false;
  tfo_30123_123.switchOffSignal1.value = false;
  tfo_30123_123.switchOffSignal2.value = false;
  vRRemote_bus_101.URegulated = ComplexMath.'abs'(bus_101_ABEL.terminal.V) * UNom_lower;
  gen_10101_ABEL_G1.switchOffSignal1.value = false;
  gen_10101_ABEL_G1.switchOffSignal2.value = false;
  gen_10101_ABEL_G1.switchOffSignal3.value = false;
  gen_10101_ABEL_G1.N = N.setPoint.value;
  gen_10101_ABEL_G1.NQ = vRRemote_bus_101.NQ;
  gen_20101_ABEL_G2.switchOffSignal1.value = false;
  gen_20101_ABEL_G2.switchOffSignal2.value = false;
  gen_20101_ABEL_G2.switchOffSignal3.value = false;
  gen_20101_ABEL_G2.N = N.setPoint.value;
  gen_20101_ABEL_G2.NQ = vRRemote_bus_101.NQ;
  gen_30101_ABEL_G3.switchOffSignal1.value = false;
  gen_30101_ABEL_G3.switchOffSignal2.value = false;
  gen_30101_ABEL_G3.switchOffSignal3.value = false;
  gen_30101_ABEL_G3.N = N.setPoint.value;
  gen_30101_ABEL_G3.NQ = vRRemote_bus_101.NQ;
  gen_40101_ABEL_G4.switchOffSignal1.value = false;
  gen_40101_ABEL_G4.switchOffSignal2.value = false;
  gen_40101_ABEL_G4.switchOffSignal3.value = false;
  gen_40101_ABEL_G4.N = N.setPoint.value;
  gen_40101_ABEL_G4.NQ = vRRemote_bus_101.NQ;
  vRRemote_bus_102.URegulated = ComplexMath.'abs'(bus_102_ADAMS.terminal.V) * UNom_lower;
  gen_10102_ADAMS_G1.switchOffSignal1.value = false;
  gen_10102_ADAMS_G1.switchOffSignal2.value = false;
  gen_10102_ADAMS_G1.switchOffSignal3.value = false;
  gen_10102_ADAMS_G1.N = N.setPoint.value;
  gen_10102_ADAMS_G1.NQ = vRRemote_bus_102.NQ;
  gen_20102_ADAMS_G2.switchOffSignal1.value = false;
  gen_20102_ADAMS_G2.switchOffSignal2.value = false;
  gen_20102_ADAMS_G2.switchOffSignal3.value = false;
  gen_20102_ADAMS_G2.N = N.setPoint.value;
  gen_20102_ADAMS_G2.NQ = vRRemote_bus_102.NQ;
  gen_30102_ADAMS_G3.switchOffSignal1.value = false;
  gen_30102_ADAMS_G3.switchOffSignal2.value = false;
  gen_30102_ADAMS_G3.switchOffSignal3.value = false;
  gen_30102_ADAMS_G3.N = N.setPoint.value;
  gen_30102_ADAMS_G3.NQ = vRRemote_bus_102.NQ;
  gen_40102_ADAMS_G4.switchOffSignal1.value = false;
  gen_40102_ADAMS_G4.switchOffSignal2.value = false;
  gen_40102_ADAMS_G4.switchOffSignal3.value = false;
  gen_40102_ADAMS_G4.N = N.setPoint.value;
  gen_40102_ADAMS_G4.NQ = vRRemote_bus_102.NQ;
  vRRemote_bus_107.URegulated = ComplexMath.'abs'(bus_107_ALDER.terminal.V) * UNom_lower;
  gen_10107_ALDER_G1.switchOffSignal1.value = false;
  gen_10107_ALDER_G1.switchOffSignal2.value = false;
  gen_10107_ALDER_G1.switchOffSignal3.value = false;
  gen_10107_ALDER_G1.N = N.setPoint.value;
  gen_10107_ALDER_G1.NQ = vRRemote_bus_107.NQ;
  gen_20107_ALDER_G2.switchOffSignal1.value = false;
  gen_20107_ALDER_G2.switchOffSignal2.value = false;
  gen_20107_ALDER_G2.switchOffSignal3.value = false;
  gen_20107_ALDER_G2.N = N.setPoint.value;
  gen_20107_ALDER_G2.NQ = vRRemote_bus_107.NQ;
  gen_30107_ALDER_G3.switchOffSignal1.value = false;
  gen_30107_ALDER_G3.switchOffSignal2.value = false;
  gen_30107_ALDER_G3.switchOffSignal3.value = false;
  gen_30107_ALDER_G3.N = N.setPoint.value;
  gen_30107_ALDER_G3.NQ = vRRemote_bus_107.NQ;
  vRRemote_bus_113.URegulated = ComplexMath.'abs'(bus_113_ARNE.terminal.V) * UNom_upper;
  gen_10113_ARNE_G1.switchOffSignal1.value = false;
  gen_10113_ARNE_G1.switchOffSignal2.value = false;
  gen_10113_ARNE_G1.switchOffSignal3.value = false;
  gen_10113_ARNE_G1.N = N.setPoint.value;
  gen_10113_ARNE_G1.NQ = vRRemote_bus_113.NQ;
  gen_20113_ARNE_G2.switchOffSignal1.value = false;
  gen_20113_ARNE_G2.switchOffSignal2.value = false;
  gen_20113_ARNE_G2.switchOffSignal3.value = false;
  gen_20113_ARNE_G2.N = N.setPoint.value;
  gen_20113_ARNE_G2.NQ = vRRemote_bus_113.NQ;
  gen_30113_ARNE_G3.switchOffSignal1.value = false;
  gen_30113_ARNE_G3.switchOffSignal2.value = false;
  gen_30113_ARNE_G3.switchOffSignal3.value = false;
  gen_30113_ARNE_G3.N = N.setPoint.value;
  gen_30113_ARNE_G3.NQ = vRRemote_bus_113.NQ;
  vRRemote_bus_118.URegulated = ComplexMath.'abs'(bus_118_ASTOR.terminal.V) * UNom_upper;
  gen_10118_ASTOR_G1.switchOffSignal1.value = false;
  gen_10118_ASTOR_G1.switchOffSignal2.value = false;
  gen_10118_ASTOR_G1.switchOffSignal3.value = false;
  gen_10118_ASTOR_G1.N = N.setPoint.value;
  gen_10118_ASTOR_G1.NQ = vRRemote_bus_118.NQ;
  vRRemote_bus_115.URegulated = ComplexMath.'abs'(bus_115_ARTHUR.terminal.V) * UNom_upper;
  gen_10115_ARTHUR_G1.switchOffSignal1.value = false;
  gen_10115_ARTHUR_G1.switchOffSignal2.value = false;
  gen_10115_ARTHUR_G1.switchOffSignal3.value = false;
  gen_10115_ARTHUR_G1.N = N.setPoint.value;
  gen_10115_ARTHUR_G1.NQ = vRRemote_bus_115.NQ;
  gen_20115_ARTHUR_G2.switchOffSignal1.value = false;
  gen_20115_ARTHUR_G2.switchOffSignal2.value = false;
  gen_20115_ARTHUR_G2.switchOffSignal3.value = false;
  gen_20115_ARTHUR_G2.N = N.setPoint.value;
  gen_20115_ARTHUR_G2.NQ = vRRemote_bus_115.NQ;
  gen_30115_ARTHUR_G3.switchOffSignal1.value = false;
  gen_30115_ARTHUR_G3.switchOffSignal2.value = false;
  gen_30115_ARTHUR_G3.switchOffSignal3.value = false;
  gen_30115_ARTHUR_G3.N = N.setPoint.value;
  gen_30115_ARTHUR_G3.NQ = vRRemote_bus_115.NQ;
  gen_40115_ARTHUR_G4.switchOffSignal1.value = false;
  gen_40115_ARTHUR_G4.switchOffSignal2.value = false;
  gen_40115_ARTHUR_G4.switchOffSignal3.value = false;
  gen_40115_ARTHUR_G4.N = N.setPoint.value;
  gen_40115_ARTHUR_G4.NQ = vRRemote_bus_115.NQ;
  gen_50115_ARTHUR_G5.switchOffSignal1.value = false;
  gen_50115_ARTHUR_G5.switchOffSignal2.value = false;
  gen_50115_ARTHUR_G5.switchOffSignal3.value = false;
  gen_50115_ARTHUR_G5.N = N.setPoint.value;
  gen_50115_ARTHUR_G5.NQ = vRRemote_bus_115.NQ;
  gen_60115_ARTHUR_G6.switchOffSignal1.value = false;
  gen_60115_ARTHUR_G6.switchOffSignal2.value = false;
  gen_60115_ARTHUR_G6.switchOffSignal3.value = false;
  gen_60115_ARTHUR_G6.N = N.setPoint.value;
  gen_60115_ARTHUR_G6.NQ = vRRemote_bus_115.NQ;
  vRRemote_bus_122.URegulated = ComplexMath.'abs'(bus_122_AUBREY.terminal.V) * UNom_upper;
  gen_10122_AUBREY_G1.switchOffSignal1.value = false;
  gen_10122_AUBREY_G1.switchOffSignal2.value = false;
  gen_10122_AUBREY_G1.switchOffSignal3.value = false;
  gen_10122_AUBREY_G1.N = N.setPoint.value;
  gen_10122_AUBREY_G1.NQ = vRRemote_bus_122.NQ;
  gen_20122_AUBREY_G2.switchOffSignal1.value = false;
  gen_20122_AUBREY_G2.switchOffSignal2.value = false;
  gen_20122_AUBREY_G2.switchOffSignal3.value = false;
  gen_20122_AUBREY_G2.N = N.setPoint.value;
  gen_20122_AUBREY_G2.NQ = vRRemote_bus_122.NQ;
  gen_30122_AUBREY_G3.switchOffSignal1.value = false;
  gen_30122_AUBREY_G3.switchOffSignal2.value = false;
  gen_30122_AUBREY_G3.switchOffSignal3.value = false;
  gen_30122_AUBREY_G3.N = N.setPoint.value;
  gen_30122_AUBREY_G3.NQ = vRRemote_bus_122.NQ;
  gen_40122_AUBREY_G4.switchOffSignal1.value = false;
  gen_40122_AUBREY_G4.switchOffSignal2.value = false;
  gen_40122_AUBREY_G4.switchOffSignal3.value = false;
  gen_40122_AUBREY_G4.N = N.setPoint.value;
  gen_40122_AUBREY_G4.NQ = vRRemote_bus_122.NQ;
  gen_50122_AUBREY_G5.switchOffSignal1.value = false;
  gen_50122_AUBREY_G5.switchOffSignal2.value = false;
  gen_50122_AUBREY_G5.switchOffSignal3.value = false;
  gen_50122_AUBREY_G5.N = N.setPoint.value;
  gen_50122_AUBREY_G5.NQ = vRRemote_bus_122.NQ;
  gen_60122_AUBREY_G6.switchOffSignal1.value = false;
  gen_60122_AUBREY_G6.switchOffSignal2.value = false;
  gen_60122_AUBREY_G6.switchOffSignal3.value = false;
  gen_60122_AUBREY_G6.N = N.setPoint.value;
  gen_60122_AUBREY_G6.NQ = vRRemote_bus_122.NQ;
  vRRemote_bus_116.URegulated = ComplexMath.'abs'(bus_116_ASSER.terminal.V) * UNom_upper;
  gen_10116_ASSER_G1.switchOffSignal1.value = false;
  gen_10116_ASSER_G1.switchOffSignal2.value = false;
  gen_10116_ASSER_G1.switchOffSignal3.value = false;
  gen_10116_ASSER_G1.N = N.setPoint.value;
  gen_10116_ASSER_G1.NQ = vRRemote_bus_116.NQ;
  vRRemote_bus_123.URegulated = ComplexMath.'abs'(bus_123_AUSTEN.terminal.V) * UNom_upper;
  gen_10123_AUSTEN_G1.switchOffSignal1.value = false;
  gen_10123_AUSTEN_G1.switchOffSignal2.value = false;
  gen_10123_AUSTEN_G1.switchOffSignal3.value = false;
  gen_10123_AUSTEN_G1.N = N.setPoint.value;
  gen_10123_AUSTEN_G1.NQ = vRRemote_bus_123.NQ;
  gen_20123_AUSTEN_G2.switchOffSignal1.value = false;
  gen_20123_AUSTEN_G2.switchOffSignal2.value = false;
  gen_20123_AUSTEN_G2.switchOffSignal3.value = false;
  gen_20123_AUSTEN_G2.N = N.setPoint.value;
  gen_20123_AUSTEN_G2.NQ = vRRemote_bus_123.NQ;
  gen_30123_AUSTEN_G3.switchOffSignal1.value = false;
  gen_30123_AUSTEN_G3.switchOffSignal2.value = false;
  gen_30123_AUSTEN_G3.switchOffSignal3.value = false;
  gen_30123_AUSTEN_G3.N = N.setPoint.value;
  gen_30123_AUSTEN_G3.NQ = vRRemote_bus_123.NQ;
  sVarC_10114_ARNOLD_SVC.switchOffSignal1.value = false;
  sVarC_10114_ARNOLD_SVC.switchOffSignal2.value = false;
  sVarC_10114_ARNOLD_SVC.URefPu = 1.05;
  sVarC_10106_ALBER_SVC.switchOffSignal1.value = false;
  sVarC_10106_ALBER_SVC.switchOffSignal2.value = false;
  sVarC_10106_ALBER_SVC.URefPu = 1.05;
  connect(sVarC_10114_ARNOLD_SVC.terminal, bus_10114_ARNOLD_SVC.terminal);
  connect(sVarC_10106_ALBER_SVC.terminal, bus_10106_ALBER_SVC.terminal);
  connect(gen_10101_ABEL_G1.terminal, bus_10101_ABEL_G1.terminal) annotation(
    Line(points = {{-214, -362}, {-214, -342}}, color = {0, 0, 255}));
  connect(gen_20101_ABEL_G2.terminal, bus_20101_ABEL_G2.terminal) annotation(
    Line(points = {{-174, -362}, {-174, -342}}, color = {0, 0, 255}));
  connect(gen_30101_ABEL_G3.terminal, bus_30101_ABEL_G3.terminal) annotation(
    Line(points = {{-134, -362}, {-134, -342}}, color = {0, 0, 255}));
  connect(gen_40101_ABEL_G4.terminal, bus_40101_ABEL_G4.terminal) annotation(
    Line(points = {{-94, -362}, {-94, -342}}, color = {0, 0, 255}));
  connect(gen_10102_ADAMS_G1.terminal, bus_10102_ADAMS_G1.terminal) annotation(
    Line(points = {{-10, -402}, {-10, -382}}, color = {0, 0, 255}));
  connect(gen_20102_ADAMS_G2.terminal, bus_20102_ADAMS_G2.terminal) annotation(
    Line(points = {{30, -402}, {30, -382}}, color = {0, 0, 255}));
  connect(gen_30102_ADAMS_G3.terminal, bus_30102_ADAMS_G3.terminal) annotation(
    Line(points = {{70, -402}, {70, -382}}, color = {0, 0, 255}));
  connect(gen_40102_ADAMS_G4.terminal, bus_40102_ADAMS_G4.terminal) annotation(
    Line(points = {{110, -402}, {110, -382}}, color = {0, 0, 255}));
  connect(gen_10107_ALDER_G1.terminal, bus_10107_ALDER_G1.terminal) annotation(
    Line(points = {{330, -230}, {310, -230}}, color = {0, 0, 255}));
  connect(gen_20107_ALDER_G2.terminal, bus_20107_ALDER_G2.terminal) annotation(
    Line(points = {{330, -270}, {310, -270}}, color = {0, 0, 255}));
  connect(gen_30107_ALDER_G3.terminal, bus_30107_ALDER_G3.terminal) annotation(
    Line(points = {{330, -310}, {310, -310}}, color = {0, 0, 255}));
  connect(gen_10113_ARNE_G1.terminal, bus_10113_ARNE_G1.terminal) annotation(
    Line(points = {{220, -50}, {200, -50}}, color = {0, 0, 255}));
  connect(gen_20113_ARNE_G2.terminal, bus_20113_ARNE_G2.terminal) annotation(
    Line(points = {{220, -90}, {200, -90}}, color = {0, 0, 255}));
  connect(gen_30113_ARNE_G3.terminal, bus_30113_ARNE_G3.terminal) annotation(
    Line(points = {{220, -130}, {200, -130}}, color = {0, 0, 255}));
  connect(gen_10115_ARTHUR_G1.terminal, bus_10115_ARTHUR_G1.terminal) annotation(
    Line(points = {{-230, 196}, {-210, 196}}, color = {0, 0, 255}));
  connect(gen_20115_ARTHUR_G2.terminal, bus_20115_ARTHUR_G2.terminal) annotation(
    Line(points = {{-230, 156}, {-210, 156}}, color = {0, 0, 255}));
  connect(gen_30115_ARTHUR_G3.terminal, bus_30115_ARTHUR_G3.terminal) annotation(
    Line(points = {{-230, 116}, {-210, 116}}, color = {0, 0, 255}));
  connect(gen_40115_ARTHUR_G4.terminal, bus_40115_ARTHUR_G4.terminal) annotation(
    Line(points = {{-230, 76}, {-210, 76}}, color = {0, 0, 255}));
  connect(gen_50115_ARTHUR_G5.terminal, bus_50115_ARTHUR_G5.terminal) annotation(
    Line(points = {{-230, 36}, {-210, 36}}, color = {0, 0, 255}));
  connect(gen_60115_ARTHUR_G6.terminal, bus_60115_ARTHUR_G6.terminal) annotation(
    Line(points = {{-230, -4}, {-210, -4}}, color = {0, 0, 255}));
  connect(gen_10116_ASSER_G1.terminal, bus_10116_ASSER_G1.terminal) annotation(
    Line(points = {{-112, 48}, {-90, 48}}, color = {0, 0, 255}));
  connect(gen_10118_ASTOR_G1.terminal, bus_10118_ASTOR_G1.terminal) annotation(
    Line(points = {{-20, 104}, {0, 104}}, color = {0, 0, 255}));
  connect(infiniteBus.terminal, bus_10121_ATTLEE_G1.terminal) annotation(
    Line(points = {{-100, 226}, {-100, 186}}, color = {0, 0, 255}));
  connect(gen_10122_AUBREY_G1.terminal, bus_10122_AUBREY_G1.terminal) annotation(
    Line(points = {{200, 182}, {220, 182}}, color = {0, 0, 255}));
  connect(gen_20122_AUBREY_G2.terminal, bus_20122_AUBREY_G2.terminal) annotation(
    Line(points = {{200, 142}, {220, 142}}, color = {0, 0, 255}));
  connect(gen_30122_AUBREY_G3.terminal, bus_30122_AUBREY_G3.terminal) annotation(
    Line(points = {{332, 212}, {300, 212}}, color = {0, 0, 255}));
  connect(gen_40122_AUBREY_G4.terminal, bus_40122_AUBREY_G4.terminal) annotation(
    Line(points = {{332, 172}, {300, 172}}, color = {0, 0, 255}));
  connect(gen_50122_AUBREY_G5.terminal, bus_50122_AUBREY_G5.terminal) annotation(
    Line(points = {{332, 132}, {300, 132}}, color = {0, 0, 255}));
  connect(gen_60122_AUBREY_G6.terminal, bus_60122_AUBREY_G6.terminal) annotation(
    Line(points = {{332, 92}, {300, 92}}, color = {0, 0, 255}));
  connect(gen_10123_AUSTEN_G1.terminal, bus_10123_AUSTEN_G1.terminal) annotation(
    Line(points = {{330, 50}, {300, 50}}, color = {0, 0, 255}));
  connect(gen_20123_AUSTEN_G2.terminal, bus_20123_AUSTEN_G2.terminal) annotation(
    Line(points = {{330, 10}, {300, 10}}, color = {0, 0, 255}));
  connect(gen_30123_AUSTEN_G3.terminal, bus_30123_AUSTEN_G3.terminal) annotation(
    Line(points = {{330, -30}, {300, -30}}, color = {0, 0, 255}));
  connect(tfo_1101_101.terminal1, bus_1101_ABEL.terminal) annotation(
    Line(points = {{-224, -282}, {-234, -282}}, color = {0, 0, 255}));
  connect(tfo_1101_101.terminal2, bus_101_ABEL.terminal) annotation(
    Line(points = {{-204, -282}, {-192, -282}, {-192, -302}, {-134, -302}}, color = {0, 0, 255}));
  connect(tfo_1102_102.terminal1, bus_1102_ADAMS.terminal) annotation(
    Line(points = {{-50, -362}, {-60, -362}}, color = {0, 0, 255}));
  connect(tfo_1102_102.terminal2, bus_102_ADAMS.terminal) annotation(
    Line(points = {{-30, -362}, {-20, -362}, {-20, -342}, {30, -342}}, color = {0, 0, 255}));
  connect(tfo_1103_103.terminal1, bus_1103_ADLER.terminal) annotation(
    Line(points = {{-184, -222}, {-194, -222}}, color = {0, 0, 255}));
  connect(tfo_1103_103.terminal2, bus_103_ADLER.terminal) annotation(
    Line(points = {{-164, -222}, {-150, -222}, {-150, -196}, {-130, -196}}, color = {0, 0, 255}));
  connect(tfo_1104_104.terminal1, bus_1104_AGRICOLA.terminal) annotation(
    Line(points = {{-56, -264}, {-70, -264}}, color = {0, 0, 255}));
  connect(tfo_1104_104.terminal2, bus_104_AGRICOLA.terminal) annotation(
    Line(points = {{-36, -264}, {-30, -264}, {-30, -244}, {-20, -244}}, color = {0, 0, 255}));
  connect(tfo_1105_105.terminal1, bus_1105_AIKEN.terminal) annotation(
    Line(points = {{32, -320}, {20, -320}}, color = {0, 0, 255}));
  connect(tfo_1105_105.terminal2, bus_105_AIKEN.terminal) annotation(
    Line(points = {{52, -320}, {60, -320}, {60, -300}, {50, -300}}, color = {0, 0, 255}));
  connect(tfo_1106_106.terminal1, bus_1106_ALBER.terminal) annotation(
    Line(points = {{176, -362}, {186, -362}}, color = {0, 0, 255}));
  connect(tfo_1106_106.terminal2, bus_106_ALBER.terminal) annotation(
    Line(points = {{156, -362}, {140, -362}, {140, -302}, {126, -302}}, color = {0, 0, 255}));
  connect(tfo_1107_107.terminal1, bus_1107_ALDER.terminal) annotation(
    Line(points = {{250, -320}, {250, -330}}, color = {0, 0, 255}));
  connect(tfo_1107_107.terminal2, bus_107_ALDER.terminal) annotation(
    Line(points = {{250, -300}, {250, -288}, {270, -288}, {270, -270}}, color = {0, 0, 255}));
  connect(tfo_1108_108.terminal1, bus_1108_ALGER.terminal) annotation(
    Line(points = {{220, -270}, {230, -270}}, color = {0, 0, 255}));
  connect(tfo_1108_108.terminal2, bus_108_ALGER.terminal) annotation(
    Line(points = {{200, -270}, {190, -270}, {190, -250}}, color = {0, 0, 255}));
  connect(tfo_1109_109.terminal1, bus_1109_ALI.terminal) annotation(
    Line(points = {{-56, -224}, {-70, -224}}, color = {0, 0, 255}));
  connect(tfo_1109_109.terminal2, bus_109_ALI.terminal) annotation(
    Line(points = {{-36, -224}, {-30, -224}, {-30, -198}}, color = {0, 0, 255}));
  connect(tfo_1110_110.terminal1, bus_1110_ALLEN.terminal) annotation(
    Line(points = {{90, -170}, {100, -170}}, color = {0, 0, 255}));
  connect(tfo_1110_110.terminal2, bus_110_ALLEN.terminal) annotation(
    Line(points = {{70, -170}, {66, -170}, {66, -198}, {82, -198}}, color = {0, 0, 255}));
  connect(tfo_1113_113.terminal1, bus_1113_ARNE.terminal) annotation(
    Line(points = {{140, -120}, {140, -130}}, color = {0, 0, 255}));
  connect(tfo_1113_113.terminal2, bus_113_ARNE.terminal) annotation(
    Line(points = {{140, -100}, {140, -80}, {160, -80}}, color = {0, 0, 255}));
  connect(tfo_1114_114.terminal1, bus_1114_ARNOLD.terminal) annotation(
    Line(points = {{18, -12}, {28, -12}}, color = {0, 0, 255}));
  connect(tfo_1114_114.terminal2, bus_114_ARNOLD.terminal) annotation(
    Line(points = {{-2, -12}, {-10, -12}, {-10, 14}}, color = {0, 0, 255}));
  connect(tfo_1115_115.terminal1, bus_1115_ARTHUR.terminal) annotation(
    Line(points = {{-142, 68}, {-130, 68}}, color = {0, 0, 255}));
  connect(tfo_1115_115.terminal2, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-162, 68}, {-170, 68}, {-170, 96}}, color = {0, 0, 255}));
  connect(tfo_1116_116.terminal2, bus_116_ASSER.terminal) annotation(
    Line(points = {{-60, 28}, {-50, 28}, {-50, 38}}, color = {0, 0, 255}));
  connect(tfo_1116_116.terminal1, bus_1116_ASSER.terminal) annotation(
    Line(points = {{-80, 28}, {-90, 28}}, color = {0, 0, 255}));
  connect(tfo_1118_118.terminal1, bus_1118_ASTOR.terminal) annotation(
    Line(points = {{70, 164}, {80, 164}}, color = {0, 0, 255}));
  connect(tfo_1118_118.terminal2, bus_118_ASTOR.terminal) annotation(
    Line(points = {{50, 164}, {40, 164}, {40, 134}}, color = {0, 0, 255}));
  connect(tfo_1119_119.terminal1, bus_1119_ATTAR.terminal) annotation(
    Line(points = {{110, 10}, {120, 10}}, color = {0, 0, 255}));
  connect(tfo_1119_119.terminal2, bus_119_ATTAR.terminal) annotation(
    Line(points = {{90, 10}, {80, 10}, {80, 30}}, color = {0, 0, 255}));
  connect(tfo_1120_120.terminal1, bus_1120_ATTILA.terminal) annotation(
    Line(points = {{190, 10}, {200, 10}}, color = {0, 0, 255}));
  connect(tfo_1120_120.terminal2, bus_120_ATTILA.terminal) annotation(
    Line(points = {{170, 10}, {160, 10}, {160, 30}}, color = {0, 0, 255}));
  connect(tfo_10101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-214, -312}, {-214, -302}, {-134, -302}}, color = {0, 0, 255}));
  connect(tfo_10101_101.terminal2, bus_10101_ABEL_G1.terminal) annotation(
    Line(points = {{-214, -332}, {-214, -342}}, color = {0, 0, 255}));
  connect(tfo_20101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-174, -312}, {-174, -302}, {-134, -302}}, color = {0, 0, 255}));
  connect(tfo_20101_101.terminal2, bus_20101_ABEL_G2.terminal) annotation(
    Line(points = {{-174, -332}, {-174, -342}}, color = {0, 0, 255}));
  connect(tfo_30101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-134, -312}, {-134, -302}}, color = {0, 0, 255}));
  connect(tfo_30101_101.terminal2, bus_30101_ABEL_G3.terminal) annotation(
    Line(points = {{-134, -332}, {-134, -342}}, color = {0, 0, 255}));
  connect(tfo_40101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-94, -312}, {-94, -302}, {-134, -302}}, color = {0, 0, 255}));
  connect(tfo_40101_101.terminal2, bus_40101_ABEL_G4.terminal) annotation(
    Line(points = {{-94, -332}, {-94, -342}}, color = {0, 0, 255}));
  connect(tfo_10102_102.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{-10, -352}, {-10, -342}, {30, -342}}, color = {0, 0, 255}));
  connect(tfo_10102_102.terminal2, bus_10102_ADAMS_G1.terminal) annotation(
    Line(points = {{-10, -372}, {-10, -382}}, color = {0, 0, 255}));
  connect(tfo_20102_102.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{30, -352}, {30, -342}}, color = {0, 0, 255}));
  connect(tfo_20102_102.terminal2, bus_20102_ADAMS_G2.terminal) annotation(
    Line(points = {{30, -372}, {30, -382}}, color = {0, 0, 255}));
  connect(tfo_30102_102.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{70, -352}, {70, -342}, {30, -342}}, color = {0, 0, 255}));
  connect(tfo_30102_102.terminal2, bus_30102_ADAMS_G3.terminal) annotation(
    Line(points = {{70, -372}, {70, -382}}, color = {0, 0, 255}));
  connect(tfo_40102_102.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{110, -352}, {110, -342}, {30, -342}}, color = {0, 0, 255}));
  connect(tfo_40102_102.terminal2, bus_40102_ADAMS_G4.terminal) annotation(
    Line(points = {{110, -372}, {110, -382}}, color = {0, 0, 255}));
  connect(tfo_10107_107.terminal1, bus_107_ALDER.terminal) annotation(
    Line(points = {{280, -230}, {270, -230}, {270, -270}}, color = {0, 0, 255}));
  connect(tfo_10107_107.terminal2, bus_10107_ALDER_G1.terminal) annotation(
    Line(points = {{300, -230}, {310, -230}}, color = {0, 0, 255}));
  connect(tfo_20107_107.terminal1, bus_107_ALDER.terminal) annotation(
    Line(points = {{280, -270}, {270, -270}}, color = {0, 0, 255}));
  connect(tfo_20107_107.terminal2, bus_20107_ALDER_G2.terminal) annotation(
    Line(points = {{300, -270}, {310, -270}}, color = {0, 0, 255}));
  connect(tfo_30107_107.terminal1, bus_107_ALDER.terminal) annotation(
    Line(points = {{280, -310}, {270, -310}, {270, -270}}, color = {0, 0, 255}));
  connect(tfo_30107_107.terminal2, bus_30107_ALDER_G3.terminal) annotation(
    Line(points = {{300, -310}, {310, -310}}, color = {0, 0, 255}));
  connect(tfo_10113_113.terminal1, bus_113_ARNE.terminal) annotation(
    Line(points = {{170, -50}, {160, -50}, {160, -80}}, color = {0, 0, 255}));
  connect(tfo_10113_113.terminal2, bus_10113_ARNE_G1.terminal) annotation(
    Line(points = {{190, -50}, {200, -50}}, color = {0, 0, 255}));
  connect(tfo_20113_113.terminal1, bus_113_ARNE.terminal) annotation(
    Line(points = {{170, -90}, {160, -90}, {160, -80}}, color = {0, 0, 255}));
  connect(tfo_20113_113.terminal2, bus_20113_ARNE_G2.terminal) annotation(
    Line(points = {{190, -90}, {200, -90}}, color = {0, 0, 255}));
  connect(tfo_30113_113.terminal1, bus_113_ARNE.terminal) annotation(
    Line(points = {{170, -130}, {160, -130}, {160, -80}}, color = {0, 0, 255}));
  connect(tfo_30113_113.terminal2, bus_30113_ARNE_G3.terminal) annotation(
    Line(points = {{190, -130}, {200, -130}}, color = {0, 0, 255}));
  connect(tfo_10115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-180, 196}, {-170, 196}, {-170, 96}}, color = {0, 0, 255}));
  connect(tfo_10115_115.terminal2, bus_10115_ARTHUR_G1.terminal) annotation(
    Line(points = {{-200, 196}, {-210, 196}}, color = {0, 0, 255}));
  connect(tfo_20115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-180, 156}, {-170, 156}, {-170, 96}}, color = {0, 0, 255}));
  connect(tfo_20115_115.terminal2, bus_20115_ARTHUR_G2.terminal) annotation(
    Line(points = {{-200, 156}, {-210, 156}}, color = {0, 0, 255}));
  connect(tfo_30115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-180, 116}, {-170, 116}, {-170, 96}}, color = {0, 0, 255}));
  connect(tfo_30115_115.terminal2, bus_30115_ARTHUR_G3.terminal) annotation(
    Line(points = {{-200, 116}, {-210, 116}}, color = {0, 0, 255}));
  connect(tfo_40115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-180, 76}, {-170, 76}, {-170, 96}}, color = {0, 0, 255}));
  connect(tfo_40115_115.terminal2, bus_40115_ARTHUR_G4.terminal) annotation(
    Line(points = {{-200, 76}, {-210, 76}}, color = {0, 0, 255}));
  connect(tfo_50115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-180, 36}, {-170, 36}, {-170, 96}}, color = {0, 0, 255}));
  connect(tfo_50115_115.terminal2, bus_50115_ARTHUR_G5.terminal) annotation(
    Line(points = {{-200, 36}, {-210, 36}}, color = {0, 0, 255}));
  connect(tfo_60115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-180, -4}, {-170, -4}, {-170, 96}}, color = {0, 0, 255}));
  connect(tfo_60115_115.terminal2, bus_60115_ARTHUR_G6.terminal) annotation(
    Line(points = {{-200, -4}, {-210, -4}}, color = {0, 0, 255}));
  connect(tfo_10116_116.terminal1, bus_116_ASSER.terminal) annotation(
    Line(points = {{-62, 48}, {-50, 48}, {-50, 38}}, color = {0, 0, 255}));
  connect(tfo_10116_116.terminal2, bus_10116_ASSER_G1.terminal) annotation(
    Line(points = {{-82, 48}, {-90, 48}}, color = {0, 0, 255}));
  connect(tfo_10118_118.terminal1, bus_118_ASTOR.terminal) annotation(
    Line(points = {{30, 104}, {40, 104}, {40, 134}}, color = {0, 0, 255}));
  connect(tfo_10118_118.terminal2, bus_10118_ASTOR_G1.terminal) annotation(
    Line(points = {{10, 104}, {0, 104}}, color = {0, 0, 255}));
  connect(tfo_10121_121.terminal1, bus_121_ATTLEE.terminal) annotation(
    Line(points = {{-70, 186}, {-60, 186}, {-60, 166}}, color = {0, 0, 255}));
  connect(tfo_10121_121.terminal2, bus_10121_ATTLEE_G1.terminal) annotation(
    Line(points = {{-90, 186}, {-100, 186}}, color = {0, 0, 255}));
  connect(tfo_10122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{250, 182}, {260, 182}, {260, 152}}, color = {0, 0, 255}));
  connect(tfo_10122_122.terminal2, bus_10122_AUBREY_G1.terminal) annotation(
    Line(points = {{230, 182}, {220, 182}}, color = {0, 0, 255}));
  connect(tfo_20122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{250, 142}, {260, 142}, {260, 152}}, color = {0, 0, 255}));
  connect(tfo_20122_122.terminal2, bus_20122_AUBREY_G2.terminal) annotation(
    Line(points = {{230, 142}, {220, 142}}, color = {0, 0, 255}));
  connect(tfo_30122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{270, 212}, {260, 212}, {260, 152}}, color = {0, 0, 255}));
  connect(tfo_30122_122.terminal2, bus_30122_AUBREY_G3.terminal) annotation(
    Line(points = {{290, 212}, {300, 212}}, color = {0, 0, 255}));
  connect(tfo_40122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{270, 172}, {260, 172}, {260, 152}}, color = {0, 0, 255}));
  connect(tfo_40122_122.terminal2, bus_40122_AUBREY_G4.terminal) annotation(
    Line(points = {{290, 172}, {300, 172}}, color = {0, 0, 255}));
  connect(tfo_50122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{270, 132}, {260, 132}, {260, 152}}, color = {0, 0, 255}));
  connect(tfo_50122_122.terminal2, bus_50122_AUBREY_G5.terminal) annotation(
    Line(points = {{290, 132}, {300, 132}}, color = {0, 0, 255}));
  connect(tfo_60122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{270, 92}, {260, 92}, {260, 152}}, color = {0, 0, 255}));
  connect(tfo_60122_122.terminal2, bus_60122_AUBREY_G6.terminal) annotation(
    Line(points = {{290, 92}, {300, 92}}, color = {0, 0, 255}));
  connect(tfo_10123_123.terminal1, bus_123_AUSTEN.terminal) annotation(
    Line(points = {{270, 50}, {260, 50}, {260, 10}}, color = {0, 0, 255}));
  connect(tfo_10123_123.terminal2, bus_10123_AUSTEN_G1.terminal) annotation(
    Line(points = {{290, 50}, {300, 50}}, color = {0, 0, 255}));
  connect(tfo_20123_123.terminal1, bus_123_AUSTEN.terminal) annotation(
    Line(points = {{270, 10}, {260, 10}}, color = {0, 0, 255}));
  connect(tfo_20123_123.terminal2, bus_20123_AUSTEN_G2.terminal) annotation(
    Line(points = {{290, 10}, {300, 10}}, color = {0, 0, 255}));
  connect(tfo_30123_123.terminal1, bus_123_AUSTEN.terminal) annotation(
    Line(points = {{270, -30}, {260, -30}, {260, 10}}, color = {0, 0, 255}));
  connect(tfo_30123_123.terminal2, bus_30123_AUSTEN_G3.terminal) annotation(
    Line(points = {{290, -30}, {300, -30}}, color = {0, 0, 255}));
  connect(tfo_103_124.terminal1, bus_103_ADLER.terminal) annotation(
    Line(points = {{-134, -90}, {-134, -196}, {-130, -196}}, color = {0, 0, 255}));
  connect(tfo_103_124.terminal2, bus_124_AVERY.terminal) annotation(
    Line(points = {{-134, -70}, {-134, -60}}, color = {0, 0, 255}));
  connect(tfo_109_111.terminal1, bus_109_ALI.terminal) annotation(
    Line(points = {{-40, -90}, {-40, -198}, {-30, -198}}, color = {0, 0, 255}));
  connect(tfo_109_111.terminal2, bus_111_ANNA.terminal) annotation(
    Line(points = {{-40, -70}, {-40, -60}}, color = {0, 0, 255}));
  connect(tfo_110_112.terminal1, bus_110_ALLEN.terminal) annotation(
    Line(points = {{62, -90}, {62, -198}, {82, -198}}, color = {0, 0, 255}));
  connect(tfo_110_112.terminal2, bus_112_ARCHER.terminal) annotation(
    Line(points = {{62, -70}, {62, -60}}, color = {0, 0, 255}));
  connect(tfo_109_112.terminal1, bus_109_ALI.terminal) annotation(
    Line(points = {{0, -110}, {-30, -110}, {-30, -198}}, color = {0, 0, 255}));
  connect(tfo_109_112.terminal2, bus_112_ARCHER.terminal) annotation(
    Line(points = {{20, -110}, {46, -110}, {46, -60}, {62, -60}}, color = {0, 0, 255}));
  connect(tfo_110_111.terminal1, bus_110_ALLEN.terminal) annotation(
    Line(points = {{20, -140}, {50, -140}, {50, -198}, {82, -198}}, color = {0, 0, 255}));
  connect(tfo_110_111.terminal2, bus_111_ANNA.terminal) annotation(
    Line(points = {{0, -140}, {-26, -140}, {-26, -60}, {-40, -60}}, color = {0, 0, 255}));
  connect(tfo_10106_106.terminal2, bus_10106_ALBER_SVC.terminal) annotation(
    Line(points = {{176, -322}, {186, -322}}, color = {0, 0, 255}));
  connect(tfo_10106_106.terminal1, bus_106_ALBER.terminal) annotation(
    Line(points = {{156, -322}, {148, -322}, {148, -302}, {126, -302}}, color = {0, 0, 255}));
  connect(tfo_10114_114.terminal2, bus_10114_ARNOLD_SVC.terminal) annotation(
    Line(points = {{18, 28}, {28, 28}}, color = {0, 0, 255}));
  connect(tfo_10114_114.terminal1, bus_114_ARNOLD.terminal) annotation(
    Line(points = {{-2, 28}, {-10, 28}, {-10, 14}}, color = {0, 0, 255}));

  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.001),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida"),
    Diagram(coordinateSystem(extent = {{-200, -300}, {200, 300}})),
    Icon(coordinateSystem(extent = {{-200, -300}, {200, 300}})));
end FullStaticModel;
