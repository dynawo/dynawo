within Dynawo.Electrical.PEIR.Plant.Simplified;

model PVCurrentSource "WECC PV model with a current source as interface with the grid (REPC-A REEC-B REGC-A)"
  //extends Electrical.PEIR.Plant.Simplified.BaseControls.BasePVCurrentSource;
  extends Electrical.Controls.WECC.Parameters.REPC.ParamsREPC;
  extends Electrical.Controls.PLL.ParamsPLL;
  extends Electrical.Controls.WECC.Parameters.REEC.ParamsREEC;
  extends Electrical.Controls.WECC.Parameters.REEC.ParamsREECb;
  extends Electrical.Controls.WECC.Parameters.REGC.ParamsREGC;
  extends Electrical.Controls.WECC.Parameters.REGC.ParamsREGCa;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  // Line parameters
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in pu (base SnRef, UNom)";
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in pu (base SnRef, UNom)";
  // Input variables
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = -P0Pu*SystemBase.SnRef/SNom) "Active power reference in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage setpoint for plant level control in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QRegPu annotation(
    Placement(transformation(origin = {-122, 53}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-114, 50}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput UPhase annotation(
    Placement(transformation(origin = {0, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-28, -70}, extent = {{-20, -20}, {20, 20}})));

  Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Lines.Line line(RPu = RPu, XPu = XPu, BPu = 0, GPu = 0) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Electrical.Sources.InjectorIDQ injector(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, P0Pu = -PInj0Pu*(SNom/SystemBase.SnRef), Q0Pu = -QInj0Pu*(SNom/SystemBase.SnRef), SNom = SNom, U0Pu = UInj0Pu, UPhase0 = UPhaseInj0, i0Pu = i0Pu, s0Pu = s0Pu, u0Pu = uInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));

  Electrical.PEIR.Plant.Simplified.BaseControls.REPCa wecc_repc(DDn = DDn, DUp = DUp, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PGen0Pu = -P0Pu*SystemBase.SnRef/SNom, PInj0Pu = PInj0Pu, PMaxPu = PMaxPu, PMinPu = PMinPu, QGen0Pu = -Q0Pu*SystemBase.SnRef/SNom, QInj0Pu = QInj0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, RcPu = RPu, RefFlag = RefFlag, tFilterPC = tFilterPC, tFt = tFt, tFv = tFv, tLag = tLag, tP = tP, U0Pu = U0Pu, UInj0Pu = UInj0Pu, VCompFlag = VCompFlag, VFrz = VFrz, XcPu = XPu, DbdPu = DbdPu, EMaxPu = EMaxPu, EMinPu = EMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, iInj0Pu = iInj0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.ComplexPerUnit iInj0Pu "Start value of complex current at injector in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit P0Pu "Start value of active power at regulated bus in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit Q0Pu "Start value of reactive power at regulated bus in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at regulated bus in pu (base UNom)";
  final parameter Types.PerUnit URef0Pu = if VCompFlag == true then UInj0Pu else (U0Pu - Kc*Q0Pu*SystemBase.SnRef/SNom) "Start value of voltage setpoint for plant level control, calculated depending on VcompFlag, in pu (base UNom)";
  parameter Types.ComplexPerUnit i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  parameter Types.ComplexPerUnit uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage phase angle at regulated bus in rad";
  parameter Types.Angle UPhaseInj0 "Start value of voltage angle at injector in rad";
  Modelica.Blocks.Interfaces.RealInput UPu annotation(
    Placement(transformation(origin = {-190, 30}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-186, 24}, extent = {{-20, -20}, {20, 20}})));
equation
  line.switchOffSignal1.value = injector.switchOffSignal1.value;
  line.switchOffSignal2.value = injector.switchOffSignal2.value;

  connect(injector.terminal, line.terminal2) annotation(
    Line(points = {{11.5, 8}, {30, 8}, {30, 0}, {40, 0}}, color = {0, 0, 255}));
  connect(line.terminal1, terminal) annotation(
    Line(points = {{60, 0}, {130, 0}}, color = {0, 0, 255}));
  connect(URefPu, wecc_repc.URefPu) annotation(
    Line(points = {{-190, -40}, {-120, -40}, {-120, -11}}, color = {0, 0, 127}));
  connect(wecc_repc.PInjRefPu, injector.iqPu) annotation(
    Line(points = {{-109, 6}, {-11, 6}, {-11, 4}}, color = {0, 0, 127}));
  connect(wecc_repc.QInjRefPu, injector.idPu) annotation(
    Line(points = {{-109, -6}, {-11, -6}}, color = {0, 0, 127}));
  connect(wecc_repc.QRegPu, QRegPu) annotation(
    Line(points = {{-117, 11}, {-122, 11}, {-122, 53}}, color = {0, 0, 127}));
  connect(PRefPu, wecc_repc.PRefPu) annotation(
    Line(points = {{-190, 0}, {-131, 0}, {-131, -2}}, color = {0, 0, 127}));
  connect(UPhase, injector.UPhase) annotation(
    Line(points = {{0, -50}, {0, -11}}, color = {0, 0, 127}));
  connect(UPu, wecc_repc.UPu) annotation(
    Line(points = {{-190, 30}, {-159, 30}, {-159, 10}, {-152, 10}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
<p> This block contains the generic WECC PV model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p></html>"),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "WECC PV")}, coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-180, -60}, {120, 60}})));
end PVCurrentSource;
