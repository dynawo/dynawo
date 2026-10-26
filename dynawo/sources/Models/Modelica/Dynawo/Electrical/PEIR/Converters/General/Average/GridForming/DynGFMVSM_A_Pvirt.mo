within Dynawo.Electrical.PEIR.Converters.General.Average.GridForming;

model DynGFMVSM_A_Pvirt "PEIR model with GFM VSM control and dynamic connections to the grid"
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffInjector;
  // Installation parameter
  parameter Types.ApparentPowerModule SNom "Nominal apparent power module for the converter";
  parameter Types.Time tUFilt = 0.01 "Filter time constant for voltage measurement in s";
  parameter Types.Time tPLL = 0.01 "Time constant of the PLL Filter" annotation(
    Dialog(tab = "PLL"));
  // Voltage reference control parameters
  parameter Types.PerUnit Mq "Reactive power droop control coefficient" annotation(
    Dialog(tab = "Voltage Reference"));
  parameter Types.AngularVelocity Omegaf "Cutoff pulsation of the active and reactive filters (in rad/s)" annotation(
    Dialog(tab = "Voltage Reference"));
  parameter Types.AngularVelocity Omegaff "Cutoff pulsation of the active damping (in rad/s)" annotation(
    Dialog(tab = "Voltage Reference"));
  parameter Types.PerUnit Kff "Gain of the active damping" annotation(
    Dialog(tab = "Voltage Reference"));
  // QSEM parameter
  parameter Types.PerUnit XVIPu "Virtual impedance in pu (base UNom, SNom), directly included into the QSEM control" annotation(
    Dialog(tab = "QSEM"));
  // Filter parameters
  parameter Types.PerUnit RFilterPu "Filter resistance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Filter"));
  parameter Types.PerUnit LFilterPu "Filter inductance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Filter"));
  parameter Types.PerUnit CFilterPu "Filter capacitance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Filter"));
  // Current loop parameters
  parameter Types.PerUnit Omegac "Current Loop bandwidth (in rad/s)" annotation(
    Dialog(tab = "Current loop"));
  parameter Types.PerUnit Kfd "Feedforward gain on the d-axis" annotation(
    Dialog(tab = "Current loop"));
  parameter Types.PerUnit Kfq "Feedforward gain on the q-axis" annotation(
    Dialog(tab = "Current loop"));
  final parameter Types.PerUnit Kic = RFilterPu*Omegac "Integrator Gain of the current loop, derived from the bandwidth";
  final parameter Types.PerUnit Kpc = LFilterPu*Omegac/SystemBase.omegaNom "Integrator gain of the current loop, to cancel one pole of the transfer function";
  parameter Types.Time Ts = 5e-5 "Delay for the backward loop" annotation(
    Dialog(tab = "Current loop"));
  // Current saturation parameters
  parameter Types.CurrentModulePu ImaxPu "Current max threshold to limit a current's module" annotation(
    Dialog(tab = "Current saturation"));
  parameter Types.CurrentModulePu IminPu "Current min threshold to limit a current's module" annotation(
    Dialog(tab = "Current saturation"));
  parameter Types.CurrentModulePu EpsUpPu "Upper half-width of the dead band around Imax/Imin, to avoid chattering at the activation threshold" annotation(
    Dialog(tab = "Current saturation"));
  parameter Types.CurrentModulePu EpsDownPu "Lower half-width of the dead band around Imax/Imin, to avoid chattering at the activation threshold" annotation(
    Dialog(tab = "Current saturation"));
  parameter Types.Time tSat "Time constant of the first-order filter on the dq reference currents (in s)" annotation(
    Dialog(tab = "Current saturation"));
  // Transformer parameters
  parameter Types.PerUnit RTransformerPu "Transformer resistance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Transformer"));
  parameter Types.PerUnit LTransformerPu "Transformer inductance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Transformer"));
  // VSM parameters
  parameter Types.PerUnit kVSM "Virtual Synchronous Machine gain" annotation(
    Dialog(tab = "VSM"));
  parameter Types.Time H "Inertia constant in s" annotation(
    Dialog(tab = "VSM"));
  // PLL Parameters
  parameter Types.PerUnit OmegaPLL "PLL bandwidth (in rad/s)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit KsiPLL "PLL damping ratio (dimensionless)" annotation(
    Dialog(tab = "PLL"));
  final parameter Types.PerUnit Ki = OmegaPLL*OmegaPLL/SystemBase.omegaNom "PLL integrator gain";
  final parameter Types.PerUnit Kp = 2*KsiPLL*OmegaPLL/SystemBase.omegaNom "PLL proportional gain";
  // VSC parameter
  parameter Types.Time tVSC "VSC time response in s" annotation(
    Dialog(tab = "VSC"));
  Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(transformation(origin = {94, 44}, extent = {{-6, -6}, {6, 6}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput PFilterRefPu(start = Control_Pvirt.PFilter0Pu) "Active power reference at the filter in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = OmegaRef0Pu) "System frequency reference in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UFilterRefPu(start = Control_Pvirt.URef0Pu) "Voltage module reference (module of the internal EMF) in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = Control_Pvirt.voltageReferenceControl.QFilterRef0Pu) "Reactive power reference at the filter in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Controls.PEIR.BaseControls.Auxiliaries.Measurements Measurements(IdPcc0Pu = Converter.transformRItoDQIPcc.ud0, IqPcc0Pu = Converter.transformRItoDQIPcc.uq0, UdFilter0Pu = Converter.transformRItoDQFilter.ud0, UqFilter0Pu = Converter.transformRItoDQFilter.uq0, UdPcc0Pu = Converter.transformRItoDQUPcc.ud0, UqPcc0Pu = Converter.transformRItoDQUPcc.uq0, tUFilt = tUFilt) annotation(
    Placement(transformation(origin = {18, -32}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  // Operating point
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal/PCC in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at terminal/PCC in rad";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal/PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal/PCC in pu (base SnRef) (receptor convention)";
  parameter Types.AngularVelocityPu Omega0Pu = SystemBase.omegaRef0Pu "Start value of the converter's frequency in pu (base omegaNom)";
  parameter Types.AngularVelocityPu OmegaRef0Pu = SystemBase.omegaRef0Pu "Start value of the rotation speed of the RI reference frame (omegaRefPu input) in pu (base omegaNom)";
  // Initialization
  final parameter Types.ComplexVoltagePu u0Pu = Modelica.ComplexMath.fromPolar(U0Pu, UPhase0) "Start value of the complex voltage at terminal/PCC in pu (base UNom)";
  final parameter Types.ComplexCurrentPu i0Pu = Modelica.ComplexMath.conj(Complex(P0Pu, Q0Pu)/u0Pu) "Start value of the complex current at terminal/PCC in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.ComplexCurrentPu iPcc0GenPu = -i0Pu*SystemBase.SnRef/SNom "Start value of the complex current at terminal/PCC in pu (base UNom, SNom) (generator convention)";
  final parameter Types.ComplexVoltagePu uFilterPhys0Pu = u0Pu + Complex(RTransformerPu, LTransformerPu*Omega0Pu)*iPcc0GenPu "Start value of the physical complex voltage at the filter capacitor in pu (base UNom)";
  final parameter Types.ComplexCurrentPu iConv0Pu = iPcc0GenPu + Complex(0, Omega0Pu*CFilterPu)*uFilterPhys0Pu "Start value of the complex converter current in pu (base UNom, SNom) (generator convention)";
  final parameter Types.ComplexVoltagePu uEmf0Pu = uFilterPhys0Pu + Complex(RFilterPu, LFilterPu*Omega0Pu + XVIPu)*iConv0Pu "Start value of the internal EMF seen by the control in pu (base UNom)";
  final parameter Types.Angle Theta0 = atan2(uEmf0Pu.im, uEmf0Pu.re) "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad (d-axis aligned with the internal EMF)";
  Controls.PEIR.Converters.Average.DynGridFormingControlVSM_CSA_Pvirt Control_Pvirt(kVSM = kVSM, H = H, Mq = Mq, Omegaf = Omegaf, Omegaff = Omegaff, Kff = Kff, XVIPu = XVIPu, Kpc = Kpc, Kic = Kic, Kfd = Kfd, Kfq = Kfq, Ts = Ts, RFilterPu = RFilterPu, LFilterPu = LFilterPu, RTransformerPu = RTransformerPu, LTransformerPu = LTransformerPu, Kp = Kp, Ki = Ki, tPLL = tPLL, ImaxPu = ImaxPu, IminPu = IminPu, EpsUpPu = EpsUpPu, EpsDownPu = EpsDownPu, tSat = tSat, UdConv0Pu = Converter.transformRItoDQUConv.ud0, UqConv0Pu = Converter.transformRItoDQUConv.uq0, UdFilter0Pu = Converter.transformRItoDQFilter.ud0, UqFilter0Pu = Converter.transformRItoDQFilter.uq0, UdPcc0Pu = Converter.transformRItoDQUPcc.ud0, UqPcc0Pu = Converter.transformRItoDQUPcc.uq0, IdConv0Pu = Converter.transformRItoDQConv.ud0, IqConv0Pu = Converter.transformRItoDQConv.uq0, IdPcc0Pu = Converter.transformRItoDQIPcc.ud0, IqPcc0Pu = Converter.transformRItoDQIPcc.uq0, Theta0 = Theta0, Omega0Pu = Omega0Pu, OmegaRef0Pu = OmegaRef0Pu, PFilter0Pu = Measurements.PFilter0Pu, QFilter0Pu = Measurements.QFilter0Pu, u0Pu = u0Pu) annotation(
    Placement(transformation(origin = {-54, 43.3333}, extent = {{-20, -16.6667}, {20, 16.6667}})));
  Sources.PEIR.Converters.Average.DynConverter Converter(SNom = SNom, tVSC = tVSC, RFilterPu = RFilterPu, LFilterPu = LFilterPu, CFilterPu = CFilterPu, RTransformerPu = RTransformerPu, LTransformerPu = LTransformerPu, i0Pu = i0Pu, u0Pu = u0Pu, Theta0 = Theta0, Omega0Pu = Omega0Pu, OmegaRef0Pu = OmegaRef0Pu) annotation(
    Placement(transformation(origin = {55, 43}, extent = {{-17, -17}, {17, 17}})));
equation
  Control_Pvirt.uPccPu = terminal.V;
  connect(Converter.terminal, terminal) annotation(
    Line(points = {{74, 43}, {91, 43}, {91, 44}, {94, 44}}, color = {0, 0, 255}));
  connect(Control_Pvirt.udConvRefPu, Converter.udConvRefPu) annotation(
    Line(points = {{-32, 50}, {36, 50}}, color = {0, 0, 127}));
  connect(Control_Pvirt.uqConvRefPu, Converter.uqConvRefPu) annotation(
    Line(points = {{-32, 36}, {36, 36}}, color = {0, 0, 127}));
  connect(Converter.idPccPu, Measurements.idPccPu) annotation(
    Line(points = {{40, 24}, {40, -16}}, color = {0, 0, 127}));
  connect(Converter.iqPccPu, Measurements.iqPccPu) annotation(
    Line(points = {{43, 24}, {43, -20}, {40, -20}}, color = {0, 0, 127}));
  connect(Converter.udPccPu, Measurements.udPccPu) annotation(
    Line(points = {{49, 24}, {49, -30}, {40, -30}}, color = {0, 0, 127}));
  connect(Converter.uqPccPu, Measurements.uqPccPu) annotation(
    Line(points = {{53, 24}, {53, -34}, {40, -34}}, color = {0, 0, 127}));
  connect(Converter.udFilterPu, Measurements.udFilterPu) annotation(
    Line(points = {{58, 24}, {58, -43}, {40, -43}}, color = {0, 0, 127}));
  connect(Converter.uqFilterPu, Measurements.uqFilterPu) annotation(
    Line(points = {{61, 24}, {61, -47}, {40, -47}}, color = {0, 0, 127}));
  connect(Converter.idConvPu, Control_Pvirt.idConvPu) annotation(
    Line(points = {{67, 24}, {67, -80}, {-66, -80}, {-66, 26}}, color = {0, 0, 127}));
  connect(Converter.iqConvPu, Control_Pvirt.iqConvPu) annotation(
    Line(points = {{71, 24}, {71, -86}, {-70, -86}, {-70, 26}}, color = {0, 0, 127}));
  connect(Measurements.iqFilteredPccPu, Control_Pvirt.iqFilteredPccPu) annotation(
    Line(points = {{-4, -46}, {-50, -46}, {-50, 26}}, color = {0, 0, 127}));
  connect(Measurements.idFilteredPccPu, Control_Pvirt.idFilteredPccPu) annotation(
    Line(points = {{-4, -50}, {-46, -50}, {-46, 26}}, color = {0, 0, 127}));
  connect(Converter.idPccPu, Control_Pvirt.idPccPu) annotation(
    Line(points = {{40, 24}, {40, 18}, {-36, 18}, {-36, 26}}, color = {0, 0, 127}));
  connect(Converter.iqPccPu, Control_Pvirt.iqPccPu) annotation(
    Line(points = {{43, 24}, {43, 14}, {-40, 14}, {-40, 26}}, color = {0, 0, 127}));
  connect(QFilterRefPu, Control_Pvirt.QFilterRefPu) annotation(
    Line(points = {{-110, 16}, {-86, 16}, {-86, 40}, {-76, 40}}, color = {0, 0, 127}));
  connect(PFilterRefPu, Control_Pvirt.PFilterRefPu) annotation(
    Line(points = {{-110, 80}, {-76, 80}, {-76, 56}}, color = {0, 0, 127}));
  connect(omegaRefPu, Control_Pvirt.omegaRefPu) annotation(
    Line(points = {{-110, 48}, {-76, 48}}, color = {0, 0, 127}));
  connect(UFilterRefPu, Control_Pvirt.URefPu) annotation(
    Line(points = {{-110, 34}, {-94, 34}, {-94, 44}, {-76, 44}}, color = {0, 0, 127}));
  connect(omegaRefPu, Converter.omegaPu) annotation(
    Line(points = {{-110, 48}, {-98, 48}, {-98, 68}, {46, 68}, {46, 62}, {47, 62}}, color = {0, 0, 127}));
  connect(Control_Pvirt.theta, Converter.theta) annotation(
    Line(points = {{-64, 62}, {-64, 76}, {64, 76}, {64, 62}}, color = {0, 0, 127}));
  connect(Measurements.QFilterPu, Control_Pvirt.QFilterPu) annotation(
    Line(points = {{-4, -30}, {-82, -30}, {-82, 28}, {-76, 28}}, color = {0, 0, 127}));
  connect(Converter.udFilterPu, Control_Pvirt.udFilterPu) annotation(
    Line(points = {{58, 24}, {58, -64}, {-58, -64}, {-58, 26}}, color = {0, 0, 127}));
  connect(Converter.uqFilterPu, Control_Pvirt.uqFilterPu) annotation(
    Line(points = {{61, 24}, {60, 24}, {60, -72}, {-62, -72}, {-62, 26}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>This model represents a power-electronics interface resource, with the following elements:<div><br></div><div>- A Grid-Forming Virtual Synchronous Machine control defining voltage source references at the converter interface with a current saturation block</div><div>- A converter part with an AVM model, a dynamic RLC filter and a dynamic RL transformer</div><div>- A measurement block to apply measurement treatment to the voltage and current</div><div><br></div><div><br></div><div><br></div><div>Sources for equations:</div><div>- kVSM: Fundamental considerations about grid forming control, Xavier Guillaud, L2EP summer shcool July 2024</div><div>- Kpc, Kic: thèse de Yahya Lamrani, Appendix A.4.2, Equation A.20</div><div><br></div><div><br></div><div><br></div></body></html>"),
    Diagram(graphics = {Text(origin = {-21, -51}, textColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "idFilteredPccPu"), Text(origin = {-21, -39}, textColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "iqFilteredPccPu"), Text(origin = {-19, -13}, textColor = {85, 170, 255}, extent = {{-15, 1}, {15, -1}}, textString = "uqFilteredPccPu"), Text(origin = {-19, -23}, textColor = {85, 170, 255}, extent = {{-15, 1}, {15, -1}}, textString = "udFilteredPccPu"), Text(origin = {51, -27}, textColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "udPccPu"), Text(origin = {51, -37}, textColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "uqPccPu"), Text(origin = {55, -41}, textColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "udFilterPu"), Text(origin = {55, -51}, textColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "uqFilterPu"), Text(origin = {-21, -27}, textColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "QFilterPu"), Text(origin = {-21, -35}, textColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "PFilterPu"), Text(origin = {9, 53}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "udConvRefPu", textStyle = {TextStyle.Bold}), Text(origin = {9, 39}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "uqConvRefPu", textStyle = {TextStyle.Bold}), Text(origin = {19, -77}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "idConvPu"), Text(origin = {19, -83}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "iqConvPu"), Text(origin = {9, 83}, textColor = {0, 0, 127}, extent = {{-13, 1}, {13, -1}}, textString = "theta"), Text(origin = {9, 75}, textColor = {0, 0, 127}, extent = {{-13, 1}, {13, -1}}, textString = "omegaPu")}));
end DynGFMVSM_A_Pvirt;
