within Dynawo.Examples.RVS.BaseSystems;

model Loadflow_equiv_extended
  import Modelica.ComplexMath;
  import Modelica.SIunits.Conversions.from_deg;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Electrical.SystemBase.SnRef;
  final parameter Types.VoltageModule UNom_lower = 138 "Nominal Voltage of the lower part of the network in kV";

  final parameter Types.VoltageModule URef0_bus_101 = 1.0342 * UNom_lower;
  final parameter Types.VoltageModule URef0_bus_102 = 1.0358 * UNom_lower;
  final parameter Types.ActivePowerPu PRef0Pu_gen_10101 = 10 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_10101 = 3.877 / SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_gen_10101 = Complex(PRef0Pu_gen_10101, QRef0Pu_gen_10101);
  final parameter Types.ComplexVoltagePu u0Pu_gen_10101 = ComplexMath.fromPolar(1.0083, from_deg(1.1881));
  final parameter Types.ComplexCurrentPu i0Pu_gen_10101 = ComplexMath.conj(s0Pu_gen_10101 / u0Pu_gen_10101);
  final parameter Types.ActivePowerPu PRef0Pu_gen_20101 = 10 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_20101 = 3.877 / SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_gen_20101 = Complex(PRef0Pu_gen_20101, QRef0Pu_gen_20101);
  final parameter Types.ComplexVoltagePu u0Pu_gen_20101 = ComplexMath.fromPolar(1.0083, from_deg(1.1881));
  final parameter Types.ComplexCurrentPu i0Pu_gen_20101 = ComplexMath.conj(s0Pu_gen_20101 / u0Pu_gen_20101);
  final parameter Types.ActivePowerPu PRef0Pu_gen_30101 = 76 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_30101 = 11.508 / SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_gen_30101 = Complex(PRef0Pu_gen_30101, QRef0Pu_gen_30101);
  final parameter Types.ComplexVoltagePu u0Pu_gen_30101 = ComplexMath.fromPolar(0.9986, from_deg(5.068));
  final parameter Types.ComplexCurrentPu i0Pu_gen_30101 = ComplexMath.conj(s0Pu_gen_30101 / u0Pu_gen_30101);
  final parameter Types.ActivePowerPu PRef0Pu_gen_40101 = 76 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_40101 = 11.508 / SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_gen_40101 = Complex(PRef0Pu_gen_40101, QRef0Pu_gen_40101);
  final parameter Types.ComplexVoltagePu u0Pu_gen_40101 = ComplexMath.fromPolar(0.9986, from_deg(5.068));
  final parameter Types.ComplexCurrentPu i0Pu_gen_40101 = ComplexMath.conj(s0Pu_gen_40101 / u0Pu_gen_40101);
  final parameter Types.ActivePowerPu PRef0Pu_gen_10102 = 10 / SnRef; 
  final parameter Types.ReactivePowerPu QRef0Pu_gen_10102 = 09.5355 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_20102 = 10 / SnRef; 
  final parameter Types.ReactivePowerPu QRef0Pu_gen_20102 = 09.5355 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_30102 = 76 / SnRef; 
  final parameter Types.ReactivePowerPu QRef0Pu_gen_30102 = 21.7756 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_40102 = 76 / SnRef; 
  final parameter Types.ReactivePowerPu QRef0Pu_gen_40102 = 21.7756 / SnRef;
  final parameter Types.ActivePowerPu P0Pu_load_1101 = 118.8 / SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_load_1101 = 24.2 / SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1101 = Complex(P0Pu_load_1101, Q0Pu_load_1101);
  final parameter Types.ComplexVoltagePu u0Pu_load_1101 = ComplexMath.fromPolar(1.043, from_deg(-8.4522));
  final parameter Types.ComplexCurrentPu i0Pu_load_1101 = ComplexMath.conj(s0Pu_load_1101 / u0Pu_load_1101);
  final parameter Types.ActivePowerPu P0Pu_load_1102 = 106.7 / SystemBase.SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_load_1102 = 22.0 / SystemBase.SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1102 = Complex(P0Pu_load_1102, Q0Pu_load_1102);
  final parameter Types.ComplexVoltagePu u0Pu_load_1102 = ComplexMath.fromPolar(1.0496, from_deg(-7.3096));
  final parameter Types.ComplexCurrentPu i0Pu_load_1102 = ComplexMath.conj(s0Pu_load_1102 / u0Pu_load_1102);
  
  Types.ActivePowerPu check_Pinfbus;
  Types.ReactivePowerPu check_Qinfbus;
  Dynawo.Electrical.Controls.Basics.SetPoint N(Value0 = 0);
  Electrical.Controls.Basics.SetPoint PrefPu_load_1101(Value0 = P0Pu_load_1101);
  Electrical.Controls.Basics.SetPoint QrefPu_load_1101(Value0 = Q0Pu_load_1101);
  Electrical.Controls.Basics.SetPoint PrefPu_load_1102(Value0 = P0Pu_load_1102);
  Electrical.Controls.Basics.SetPoint QrefPu_load_1102(Value0 = Q0Pu_load_1102);
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_20101_ABEL_G2(KGover = 0, PGen0Pu = PRef0Pu_gen_20101, PMaxPu = 999, PMinPu = 0, PNom = 20, PRef0Pu = -PRef0Pu_gen_20101, QMaxPu = 0.1, QMinPu = 0, QPercent = 0.126, U0Pu = 1, i0Pu = i0Pu_gen_20101, u0Pu = u0Pu_gen_20101) annotation(
    Placement(visible = true, transformation(origin = {-20, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //QGen0Pu = QRef0Pu_gen_20101
  //, QRef0Pu = -QRef0Pu_gen_20101
  Dynawo.Electrical.Buses.Bus bus_40101_ABEL_G4 annotation(
    Placement(visible = true, transformation(origin = {60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_101_ABEL annotation(
    Placement(visible = true, transformation(origin = {20, -10}, extent = {{-90, -10}, {90, 10}}, rotation = 180)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_10101_ABEL_G1(KGover = 0, PGen0Pu = PRef0Pu_gen_10101, PMaxPu = 999, PMinPu = 0, PNom = 20, PRef0Pu = -PRef0Pu_gen_10101, QMaxPu = 0.1, QMinPu = 0, QPercent = 0.126, U0Pu = 1, i0Pu = i0Pu_gen_10101, u0Pu = u0Pu_gen_10101
  ) annotation(
    Placement(visible = true, transformation(origin = {-60, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //QGen0Pu = QRef0Pu_gen_10101,
  //,QRef0Pu = -QRef0Pu_gen_10101
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_30101_ABEL_G3(KGover = 0, PGen0Pu = PRef0Pu_gen_30101, PMaxPu = 999, PMinPu = 0, PNom = 76, PRef0Pu = -PRef0Pu_gen_30101, QMaxPu = 0.3, QMinPu = -0.25,
  QPercent = 0.374, U0Pu = 1, i0Pu = i0Pu_gen_30101, u0Pu = u0Pu_gen_30101) annotation(
    Placement(visible = true, transformation(origin = {20, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //QGen0Pu = QRef0Pu_gen_30101,
  //,QRef0Pu = -QRef0Pu_gen_30101
  Dynawo.Electrical.Lines.Line line_101_103(BPu = 0.057 / 2, GPu = 0, RPu = 0.055, XPu = 0.211) annotation(
    Placement(visible = true, transformation(origin = {30, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ load_1101_ABEL(i0Pu = i0Pu_load_1101, s0Pu = s0Pu_load_1101, u0Pu = u0Pu_load_1101) annotation(
    Placement(visible = true, transformation(origin = {-80, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_103_ADLER annotation(
    Placement(visible = true, transformation(origin = {30, 90}, extent = {{-30, -10}, {30, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20101_101(BPu = 0, GPu = 0, RPu = 0.003 * (100 / 24), XPu = 0.15 * (100 / 24), rTfoPu = 0.95238) annotation(
    Placement(visible = true, transformation(origin = {-20, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_40101_ABEL_G4(KGover = 0, PGen0Pu = PRef0Pu_gen_40101, PMaxPu = 999, PMinPu = 0, PNom = 76, PRef0Pu = -PRef0Pu_gen_40101, QMaxPu = 0.3, QMinPu = -0.25, QPercent = 0.374, U0Pu = 1, i0Pu = i0Pu_gen_40101, u0Pu = u0Pu_gen_40101
  ) annotation(
    Placement(visible = true, transformation(origin = {60, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Buses.Bus bus_10101_ABEL_G1 annotation(
    Placement(visible = true, transformation(origin = {-60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_1101_101(BPu = 0, GPu = 0, RPu = 0.003 * (100 / 150), XPu = 0.15 * (100 / 150), rTfoPu = 1.041505) annotation(
    Placement(visible = true, transformation(origin = {-40, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Buses.Bus bus_1101_ABEL annotation(
    Placement(visible = true, transformation(origin = {-60, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_20101_ABEL_G2 annotation(
    Placement(visible = true, transformation(origin = {-20, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_40101_101(BPu = 0, GPu = 0, RPu = 0.003 * (100 / 89), XPu = 0.15 * (100 / 89), rTfoPu = 0.95238) annotation(
    Placement(visible = true, transformation(origin = {60, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10101_101(BPu = 0, GPu = 0, RPu = 0.003 * (100 / 24), XPu = 0.15 * (100 / 24), rTfoPu = 0.95238) annotation(
    Placement(visible = true, transformation(origin = {-60, -32}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30101_101(BPu = 0, GPu = 0, RPu = 0.003 * (100 / 89), XPu = 0.15 * (100 / 89), rTfoPu = 0.95238) annotation(
    Placement(visible = true, transformation(origin = {20, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_101(Gain = 1, U0 = URef0_bus_101, URef0 = URef0_bus_101, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-80, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_30101_ABEL_G3 annotation(
    Placement(visible = true, transformation(origin = {20, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = from_deg(-16.2), UPu = 1.007) annotation(
    Placement(visible = true, transformation(origin = {30, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_10102_ADAMS_G1(KGover = 0, PGen0Pu = PRef0Pu_gen_10102, PMaxPu = 999, PMinPu = 0, PNom = 20, PRef0Pu = -PRef0Pu_gen_10102, QMaxPu = 0.1, QMinPu = 0, QPercent = 0.178, U0Pu = 1) annotation(
    Placement(visible = true, transformation(origin = {152, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_20102_ADAMS_G2 annotation(
    Placement(visible = true, transformation(origin = {192, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_30102_ADAMS_G3 annotation(
    Placement(visible = true, transformation(origin = {232, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_40102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 89, XPu = 0.15 * 100 / 89, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {272, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_102(Gain = 1, U0 = URef0_bus_102, URef0 = URef0_bus_102, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {90, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 24, XPu = 0.15 * 100 / 24, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {192, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_40102_ADAMS_G4 annotation(
    Placement(visible = true, transformation(origin = {272, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 24, XPu = 0.15 * 100 / 24, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {152, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_30102_ADAMS_G3(KGover = 0, PGen0Pu = PRef0Pu_gen_30102, PMaxPu = 999, PMinPu = 0, PNom = 76, PRef0Pu = -PRef0Pu_gen_30102, QMaxPu = 0.3, QMinPu = -0.25, QPercent = 0.322) annotation(
    Placement(visible = true, transformation(origin = {232, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_10102_ADAMS_G1 annotation(
    Placement(visible = true, transformation(origin = {152, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_1102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 150, XPu = 0.15 * 100 / 150, rTfoPu = 1 / 0.9614) annotation(
    Placement(visible = true, transformation(origin = {122, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Buses.Bus bus_102_ADAMS annotation(
    Placement(visible = true, transformation(origin = {192, -50}, extent = {{-90, -10}, {90, 10}}, rotation = 180)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 89, XPu = 0.15 * 100 / 89, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {232, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ load_1102_ADAMS(i0Pu = i0Pu_load_1102, s0Pu = s0Pu_load_1102, u0Pu = u0Pu_load_1102)  annotation(
    Placement(visible = true, transformation(origin = {82, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_40102_ADAMS_G4(KGover = 0, PGen0Pu = PRef0Pu_gen_40102, PMaxPu = 999, PMinPu = 0, PNom = 76, PRef0Pu = -PRef0Pu_gen_40102, QMaxPu = 0.3, QMinPu = -0.25, QPercent = 0.322, U0Pu = 1) annotation(
    Placement(visible = true, transformation(origin = {272, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_20102_ADAMS_G2(KGover = 0, PGen0Pu = PRef0Pu_gen_20102, PMaxPu = 999, PMinPu = 0, PNom = 20, PRef0Pu = -PRef0Pu_gen_20102, QMaxPu = 0.1, QMinPu = 0, QPercent = 0.178, U0Pu = 1) annotation(
    Placement(visible = true, transformation(origin = {192, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line_101_102(BPu = 0.461 / 2, GPu = 0, RPu = 0.003, XPu = 0.014)  annotation(
    Placement(visible = true, transformation(origin = {106, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_1102_ADAMS annotation(
    Placement(visible = true, transformation(origin = {96, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ load_1106_ALBER annotation(
    Placement(visible = true, transformation(origin = {356, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10106_106(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 100, XPu = 0.15 * 100 / 100, rTfoPu = 1 / 1.05) annotation(
    Placement(visible = true, transformation(origin = {316, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_1106_ALBER annotation(
    Placement(visible = true, transformation(origin = {336, -62}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_10106_ALBER_SVC annotation(
    Placement(visible = true, transformation(origin = {336, -22}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.StaticVarCompensators.SVarCPVRemote sVarC_10106_ALBER_SVC(B0Pu = 0.1, BMaxPu = 0.5, BMinPu = -1, BShuntPu = 0.1, U0Pu = 1, UNomRemote = 138, URef0Pu = URef0Pu_sVarC_10106, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {356, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line_102_106(BPu = 0.052 / 2, GPu = 0, RPu = 0.05, XPu = 0.192)  annotation(
    Placement(visible = true, transformation(origin = {270, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Buses.Bus bus_106_ALBER annotation(
    Placement(visible = true, transformation(origin = {286, -2}, extent = {{-30, -10}, {30, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_1106_106(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 200, XPu = 0.15 * 100 / 200, rTfoPu = 1 / 0.9625) annotation(
    Placement(visible = true, transformation(origin = {316, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  check_Pinfbus = SnRef * ComplexMath.real(infiniteBus.terminal.V * ComplexMath.conj(infiniteBus.terminal.i));
  check_Qinfbus = SnRef * ComplexMath.imag(infiniteBus.terminal.V * ComplexMath.conj(infiniteBus.terminal.i));
  connect(gen_20101_ABEL_G2.terminal, bus_20101_ABEL_G2.terminal) annotation(
    Line(points = {{-20, -70}, {-20, -50}}, color = {0, 0, 255}));
  connect(tfo_1101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-30, 10}, {-20, 10}, {-20, -10}, {20, -10}}, color = {0, 0, 255}));
  connect(gen_40101_ABEL_G4.terminal, bus_40101_ABEL_G4.terminal) annotation(
    Line(points = {{60, -70}, {60, -50}}, color = {0, 0, 255}));
  connect(tfo_40101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{60, -20}, {60, -10}, {20, -10}}, color = {0, 0, 255}));
  connect(tfo_20101_101.terminal2, bus_20101_ABEL_G2.terminal) annotation(
    Line(points = {{-20, -40}, {-20, -50}}, color = {0, 0, 255}));
  connect(gen_30101_ABEL_G3.terminal, bus_30101_ABEL_G3.terminal) annotation(
    Line(points = {{20, -70}, {20, -50}}, color = {0, 0, 255}));
  connect(tfo_30101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{20, -20}, {20, -10}}, color = {0, 0, 255}));
  connect(tfo_30101_101.terminal2, bus_30101_ABEL_G3.terminal) annotation(
    Line(points = {{20, -40}, {20, -50}}, color = {0, 0, 255}));
  connect(tfo_40101_101.terminal2, bus_40101_ABEL_G4.terminal) annotation(
    Line(points = {{60, -40}, {60, -50}}, color = {0, 0, 255}));
  connect(tfo_20101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-20, -20}, {-20, -10}, {20, -10}}, color = {0, 0, 255}));
  connect(gen_10101_ABEL_G1.terminal, bus_10101_ABEL_G1.terminal) annotation(
    Line(points = {{-60, -70}, {-60, -50}}, color = {0, 0, 255}));
  connect(load_1101_ABEL.terminal, bus_1101_ABEL.terminal) annotation(
    Line(points = {{-80, 10}, {-60, 10}}, color = {0, 0, 255}));
  connect(tfo_1101_101.terminal2, bus_1101_ABEL.terminal) annotation(
    Line(points = {{-50, 10}, {-60, 10}}, color = {0, 0, 255}));
  connect(line_101_103.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{30, 28}, {30, -10}, {20, -10}}, color = {0, 0, 255}));
  connect(line_101_103.terminal2, bus_103_ADLER.terminal) annotation(
    Line(points = {{30, 48}, {30, 90}}, color = {0, 0, 255}));
  line_101_103.switchOffSignal1.value = false;
  line_101_103.switchOffSignal2.value = false;
  line_101_102.switchOffSignal1.value = false;
  line_101_102.switchOffSignal2.value = false;
  line_102_106.switchOffSignal1.value = false;
  line_102_106.switchOffSignal2.value = false;
  load_1101_ABEL.switchOffSignal1.value = false;
  load_1101_ABEL.switchOffSignal2.value = false;
  load_1102_ADAMS.switchOffSignal1.value = false;
  load_1102_ADAMS.switchOffSignal2.value = false;
  PrefPu_load_1101.setPoint.value = load_1101_ABEL.PRefPu;
  QrefPu_load_1101.setPoint.value = load_1101_ABEL.QRefPu;
  PrefPu_load_1102.setPoint.value = load_1102_ADAMS.PRefPu;
  QrefPu_load_1102.setPoint.value = load_1102_ADAMS.QRefPu;
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
  connect(infiniteBus.terminal, bus_103_ADLER.terminal) annotation(
    Line(points = {{30, 120}, {30, 90}}, color = {0, 0, 255}));
  connect(tfo_10101_101.terminal2, bus_10101_ABEL_G1.terminal) annotation(
    Line(points = {{-60, -42}, {-60, -50}}, color = {0, 0, 255}));
  connect(tfo_10101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-60, -22}, {-60, -10}, {20, -10}}, color = {0, 0, 255}));
  connect(tfo_30102_102.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{232, -60}, {232, -50}, {192, -50}}, color = {0, 0, 255}));
  connect(tfo_10102_102.terminal2, bus_10102_ADAMS_G1.terminal) annotation(
    Line(points = {{152, -80}, {152, -90}}, color = {0, 0, 255}));
  connect(tfo_20102_102.terminal2, bus_20102_ADAMS_G2.terminal) annotation(
    Line(points = {{192, -80}, {192, -90}}, color = {0, 0, 255}));
  connect(tfo_30102_102.terminal2, bus_30102_ADAMS_G3.terminal) annotation(
    Line(points = {{232, -80}, {232, -90}}, color = {0, 0, 255}));
  connect(tfo_1102_102.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{132, -70}, {142, -70}, {142, -50}, {192, -50}}, color = {0, 0, 255}));
  connect(tfo_20102_102.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{192, -60}, {192, -50}}, color = {0, 0, 255}));
  connect(gen_10102_ADAMS_G1.terminal, bus_10102_ADAMS_G1.terminal) annotation(
    Line(points = {{152, -110}, {152, -90}}, color = {0, 0, 255}));
  connect(gen_20102_ADAMS_G2.terminal, bus_20102_ADAMS_G2.terminal) annotation(
    Line(points = {{192, -110}, {192, -90}}, color = {0, 0, 255}));
  connect(tfo_10102_102.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{152, -60}, {152, -50}, {192, -50}}, color = {0, 0, 255}));
  connect(tfo_40102_102.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{272, -60}, {272, -50}, {192, -50}}, color = {0, 0, 255}));
  connect(gen_40102_ADAMS_G4.terminal, bus_40102_ADAMS_G4.terminal) annotation(
    Line(points = {{272, -110}, {272, -90}}, color = {0, 0, 255}));
  connect(gen_30102_ADAMS_G3.terminal, bus_30102_ADAMS_G3.terminal) annotation(
    Line(points = {{232, -110}, {232, -90}}, color = {0, 0, 255}));
  connect(tfo_40102_102.terminal2, bus_40102_ADAMS_G4.terminal) annotation(
    Line(points = {{272, -80}, {272, -90}}, color = {0, 0, 255}));
  connect(load_1102_ADAMS.terminal, bus_1102_ADAMS.terminal) annotation(
    Line(points = {{82, -70}, {96, -70}}, color = {0, 0, 255}));
  connect(tfo_1102_102.terminal2, bus_1102_ADAMS.terminal) annotation(
    Line(points = {{112, -70}, {96, -70}}, color = {0, 0, 255}));
  connect(line_101_102.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{106, -20}, {106, -10}, {20, -10}}, color = {0, 0, 255}));
  connect(line_101_102.terminal2, bus_102_ADAMS.terminal) annotation(
    Line(points = {{106, -40}, {106, -50}, {192, -50}}, color = {0, 0, 255}));
  connect(tfo_10106_106.terminal2, bus_10106_ALBER_SVC.terminal) annotation(
    Line(points = {{326, -22}, {336, -22}}, color = {0, 0, 255}));
  connect(tfo_1106_106.terminal2, bus_1106_ALBER.terminal) annotation(
    Line(points = {{326, -62}, {336, -62}}, color = {0, 0, 255}));
  connect(sVarC_10106_ALBER_SVC.terminal, bus_10106_ALBER_SVC.terminal) annotation(
    Line(points = {{356, -22}, {336, -22}}, color = {0, 0, 255}));
  connect(tfo_1106_106.terminal1, bus_106_ALBER.terminal) annotation(
    Line(points = {{306, -62}, {300, -62}, {300, -2}, {286, -2}}, color = {0, 0, 255}));
  connect(load_1106_ALBER.terminal, bus_1106_ALBER.terminal) annotation(
    Line(points = {{356, -62}, {336, -62}}, color = {0, 0, 255}));
  connect(tfo_10106_106.terminal1, bus_106_ALBER.terminal) annotation(
    Line(points = {{306, -22}, {306, -2}, {286, -2}}, color = {0, 0, 255}));
  connect(line_102_106.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{270, -38}, {272, -38}, {272, -50}, {192, -50}}, color = {0, 0, 255}));
  connect(line_102_106.terminal2, bus_106_ALBER.terminal) annotation(
    Line(points = {{270, -18}, {270, -2}, {286, -2}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida"));
end Loadflow_equiv_extended;
