within Dynawo.Electrical.PEIR.Converters.General.Average.GridForming;

model DynGFMDroop_NOFR
  // Installation parameter
  parameter Types.ApparentPowerModule SNom "Nominal apparent power module for the converter";
  parameter Types.Time tUFilt = 0.01 "Filter time constant for voltage measurement in s";
  // Droop control parameters
  parameter Types.PerUnit Mp "Active power droop control coefficient" annotation(
    Dialog(tab = "Droop"));
  parameter Types.PerUnit WfDroop "Cutoff pulsation of the active filter (in rad/s)" annotation(
    Dialog(tab = "Droop"));
  // Virtual impedance parameters
  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance" annotation(
    Dialog(tab = "VI"));
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance" annotation(
    Dialog(tab = "VI"));
  parameter Types.CurrentModulePu IMaxVI "Maximum current before activating the virtual impedance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "VI"));
  // Voltage reference control parameters
  parameter Types.PerUnit Mq "Reactive power droop control coefficient" annotation(
    Dialog(tab = "Voltage Reference"));
  parameter Types.PerUnit Wf "Cutoff pulsation of the active and reactive filters (in rad/s)" annotation(
    Dialog(tab = "Voltage Reference"));
  parameter Types.PerUnit Wff "Cutoff pulsation of the active damping (in rad/s)" annotation(
    Dialog(tab = "Voltage Reference"));
  parameter Types.PerUnit Kff "Gain of the active damping" annotation(
    Dialog(tab = "Voltage Reference"));
  // QSEM parameter
  parameter Real XVI "Virtual impedance in pu (base UNom, SNom), directly included into the QSEM control" annotation(
    Dialog(tab = "QSEM"));
  // Current loop parameters
  parameter Types.PerUnit Kpc "Proportional gain of the current loop" annotation(
    Dialog(tab = "Current loop"));
  parameter Types.PerUnit Kic "Integral gain of the current loop" annotation(
    Dialog(tab = "Current loop"));
  parameter Types.PerUnit Kfd = 0 "Feedforward gain on the d-axis" annotation(
    Dialog(tab = "Current loop"));
  parameter Types.PerUnit Kfq = 0 "Feedforward gain on the q-axis" annotation(
    Dialog(tab = "Current loop"));
  // Filter parameters
  parameter Types.PerUnit RFilterPu "Filter resistance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Filter"));
  parameter Types.PerUnit LFilterPu "Filter inductance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Filter"));
  parameter Types.PerUnit CFilterPu "Filter capacitance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Filter"));
  // Transformer parameters
  parameter Types.PerUnit RTransformerPu "Transformer resistance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Transformer"));
  parameter Types.PerUnit LTransformerPu "Transformer inductance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Transformer"));
  // VSC parameter
  parameter Types.Time tVSC "VSC time response in s" annotation(
    Dialog(tab = "VSC"));
  Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {106, 42}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PFilterRefPu(start = Control.PFilter0Pu) "Active power reference at the filter in pu (base SNom)" annotation(
    Placement(transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "System frequency reference in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-110, 48}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput UFilterRefPu(start = Control.URef0Pu) "Voltage reference at the filter in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = Control.QFilter0Pu) "Reactive power reference at the filter in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Sources.PEIR.Converters.Average.DynConverter1 Converter(CFilterPu = CFilterPu, LFilterPu = LFilterPu, LTransformerPu = LTransformerPu, Omega0Pu = SystemBase.omegaRef0Pu, RFilterPu = RFilterPu, RTransformerPu = RTransformerPu, SNom = SNom, Theta0 = Theta0, i0Pu = i0Pu, tVSC = tVSC, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {66, 42}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Electrical.Controls.PEIR.BaseControls.Auxiliaries.Measurements Measurements(IdPcc0Pu = Converter.refFrameRotation.IdPcc0Pu, IqPcc0Pu = Converter.refFrameRotation.IqPcc0Pu, UdFilter0Pu = Converter.RLTransformer.UdFilter0Pu, UdPcc0Pu = Converter.refFrameRotation.UdPcc0Pu, UqFilter0Pu = Converter.RLTransformer.UqFilter0Pu, UqPcc0Pu = Converter.refFrameRotation.UqPcc0Pu, tUFilt = tUFilt) annotation(
    Placement(visible = true, transformation(origin = {18, -32}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Electrical.Controls.PEIR.Converters.Average.DynGridFormingControlDroop Control(IMaxVI = IMaxVI, IdConv0Pu = Converter.RLCFilter.IdConv0Pu, IdPcc0Pu = Converter.refFrameRotation.IdPcc0Pu, IqConv0Pu = Converter.RLCFilter.IqConv0Pu, IqPcc0Pu = Converter.refFrameRotation.IqPcc0Pu, Kfd = Kfd, Kff = Kff, Kfq = Kfq, Kic = Kic, KpVI = KpVI, Kpc = Kpc, LFilterPu = LFilterPu, LTransformerPu = LTransformerPu, Mp = Mp, Mq = Mq, Omega0Pu = SystemBase.omegaRef0Pu, PFilter0Pu = Measurements.PFilter0Pu, QFilter0Pu = Measurements.QFilter0Pu, RFilterPu = RFilterPu, RTransformerPu = RTransformerPu, Theta0 = Converter.Theta0, UdConv0Pu = Converter.RLCFilter.UdConv0Pu, UdFilter0Pu = Converter.RLTransformer.UdFilter0Pu, UdPcc0Pu = Converter.refFrameRotation.UdPcc0Pu, UqConv0Pu = Converter.RLCFilter.UqConv0Pu, UqFilter0Pu = Converter.RLTransformer.UqFilter0Pu, UqPcc0Pu = Converter.refFrameRotation.UqPcc0Pu, Wf = Wf, WfDroop = WfDroop, Wff = Wff, XRratio = XRratio, XVI = XVI) annotation(
    Placement(visible = true, transformation(origin = {-47, 41}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  // Operating point
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal/PCC in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at terminal/PCC in rad";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal/PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal/PCC in pu (base SnRef) (receptor convention)";
  parameter Types.AngularVelocityPu OmegaSetPu "Defaut angular velocity reference for the converter in pu (base omegaNom)";
  final parameter Types.ComplexVoltagePu u0Pu = Modelica.ComplexMath.fromPolar(U0Pu, UPhase0) "Start value of the complex voltage at terminal/PCC in pu (base UNom)";
  final parameter Types.ComplexCurrentPu i0Pu = Modelica.ComplexMath.conj(Complex(P0Pu, Q0Pu)/u0Pu) "Start value of the complex current at terminal/PCC in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu uFilter0Pu = u0Pu - Complex(RTransformerPu, LTransformerPu*SystemBase.omegaRef0Pu)*i0Pu*SystemBase.SnRef/SNom "Start value of the complex voltage at the filter in pu (base UNom)";
  final parameter Types.Angle Theta0 = atan2(uFilter0Pu.im, uFilter0Pu.re) "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = 0.5, y_start = 1, k = 1) annotation(
    Placement(transformation(origin = {-97, 65}, extent = {{-7, -7}, {7, 7}})));
equation
  connect(Measurements.idPccPu, Converter.idPccPu) annotation(
    Line(points = {{40, -16}, {48, -16}, {48, 20}}, color = {85, 170, 255}, pattern = LinePattern.Dash));
  connect(Measurements.iqPccPu, Converter.iqPccPu) annotation(
    Line(points = {{40, -20}, {52, -20}, {52, 20}}, color = {85, 170, 255}, pattern = LinePattern.Dash));
  connect(Measurements.udPccPu, Converter.udPccPu) annotation(
    Line(points = {{40, -30}, {60, -30}, {60, 20}}, color = {85, 170, 255}));
  connect(Measurements.uqPccPu, Converter.uqPccPu) annotation(
    Line(points = {{40, -34}, {64, -34}, {64, 20}}, color = {85, 170, 255}));
  connect(Converter.udFilterPu, Measurements.udFilterPu) annotation(
    Line(points = {{70, 20}, {70, -44}, {40, -44}}, color = {85, 170, 0}, pattern = LinePattern.Dash));
  connect(Converter.uqFilterPu, Measurements.uqFilterPu) annotation(
    Line(points = {{74, 20}, {74, -46}, {40, -46}}, color = {85, 170, 0}, pattern = LinePattern.Dash));
  connect(Converter.terminal, terminal) annotation(
    Line(points = {{88, 42}, {106, 42}}, color = {0, 0, 255}));
  connect(Control.theta, Converter.theta) annotation(
    Line(points = {{-58, 64}, {-58, 80}, {76, 80}, {76, 64}}, color = {0, 0, 127}));
  connect(Control.omegaPu, Converter.omegaPu) annotation(
    Line(points = {{-36, 64}, {-36, 72}, {56, 72}, {56, 64}}, color = {0, 0, 127}));
  connect(Control.udConvRefPu, Converter.udConvRefPu) annotation(
    Line(points = {{-24, 50}, {44, 50}}, color = {245, 121, 0}, thickness = 0.5));
  connect(Control.uqConvRefPu, Converter.uqConvRefPu) annotation(
    Line(points = {{-24, 32}, {44, 32}, {44, 34}}, color = {245, 121, 0}, thickness = 0.5));
  connect(PFilterRefPu, Control.PFilterRefPu) annotation(
    Line(points = {{-110, 80}, {-76, 80}, {-76, 58}, {-70, 58}}, color = {85, 170, 0}, thickness = 0.5));
  connect(UFilterRefPu, Control.UFilterRefPu) annotation(
    Line(points = {{-110, 34}, {-80, 34}, {-80, 42}, {-70, 42}}, color = {85, 170, 0}, thickness = 0.5));
  connect(QFilterRefPu, Control.QFilterRefPu) annotation(
    Line(points = {{-110, 16}, {-90, 16}, {-90, 30}, {-76, 30}, {-76, 38}, {-70, 38}}, color = {85, 170, 0}, thickness = 0.5));
  connect(Converter.idPccPu, Control.idPccPu) annotation(
    Line(points = {{48, 20}, {48, 8}, {-28, 8}, {-28, 18}}, color = {85, 170, 255}));
  connect(Converter.iqPccPu, Control.iqPccPu) annotation(
    Line(points = {{52, 20}, {52, 0}, {-32, 0}, {-32, 18}}, color = {85, 170, 255}));
  connect(Measurements.udFilteredPccPu, Control.udFilteredPccPu) annotation(
    Line(points = {{-4, -20}, {-40, -20}, {-40, 18}}, color = {85, 170, 255}));
  connect(Measurements.uqFilteredPccPu, Control.uqFilteredPccPu) annotation(
    Line(points = {{-4, -28}, {-44, -28}, {-44, 18}}, color = {85, 170, 255}));
  connect(Measurements.QFilterPu, Control.QFilterPu) annotation(
    Line(points = {{-4, -36}, {-74, -36}, {-74, 22}, {-70, 22}}, color = {85, 170, 0}));
  connect(Measurements.PFilterPu, Control.PFilterPu) annotation(
    Line(points = {{-4, -44}, {-80, -44}, {-80, 26}, {-70, 26}}, color = {85, 170, 0}));
  connect(Converter.udFilterPu, Control.udFilterPu) annotation(
    Line(points = {{70, 20}, {70, -64}, {-50, -64}, {-50, 18}}, color = {85, 170, 0}));
  connect(Converter.uqFilterPu, Control.uqFilterPu) annotation(
    Line(points = {{74, 20}, {74, -74}, {-54, -74}, {-54, 18}}, color = {85, 170, 0}));
  connect(Converter.idConvPu, Control.idConvPu) annotation(
    Line(points = {{80, 20}, {80, -80}, {-60, -80}, {-60, 18}}, color = {245, 121, 0}));
  connect(Converter.iqConvPu, Control.iqConvPu) annotation(
    Line(points = {{84, 20}, {84, -88}, {-64, -88}, {-64, 18}}, color = {245, 121, 0}));
  connect(Control.omegaRefPu, omegaRefPu) annotation(
    Line(points = {{-70, 48}, {-110, 48}}, color = {0, 0, 127}));
  connect(firstOrder.y, Control.omegaSetPu) annotation(
    Line(points = {{-89, 65}, {-86, 65}, {-86, 52}, {-70, 52}}, color = {0, 0, 127}));
  connect(firstOrder.u, Control.omegaPu) annotation(
    Line(points = {{-105, 65}, {-128, 65}, {-128, 94}, {-36, 94}, {-36, 64}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>This model represents a power-electronics interface resource, with the following elements:<div><br></div><div>- A Grid-Forming Virtual Synchronous Machine control defining voltage source references at the converter interface</div><div>- A converter part with an AVM model, a dynamic RLC filter and a dynamic RL transformer</div><div>- A measurement block to apply measurement treatment to the voltage and current</div><div><br></div><div>As of today, the model doesn't include any current saturation scheme.</div><div><br></div><div><br></div><div><br></div></body></html>"),
    Diagram(graphics = {Text(origin = {11, 11}, lineColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "idPccPu"), Text(origin = {11, 3}, lineColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "iqPccPu"), Text(origin = {-21, -25}, lineColor = {85, 170, 255}, extent = {{-15, 1}, {15, -1}}, textString = "uqFilteredPccPu"), Text(origin = {-21, -17}, lineColor = {85, 170, 255}, extent = {{-15, 1}, {15, -1}}, textString = "udFilteredPccPu"), Text(origin = {51, -27}, lineColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "udPccPu"), Text(origin = {51, -37}, lineColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "uqPccPu"), Text(origin = {19, -61}, lineColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "udFilterPu"), Text(origin = {19, -71}, lineColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "uqFilterPu"), Text(origin = {-21, -33}, lineColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "QFilterPu"), Text(origin = {-21, -41}, lineColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "PFilterPu"), Text(origin = {9, 53}, lineColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "udConvRefPu", textStyle = {TextStyle.Bold}), Text(origin = {9, 37}, lineColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "uqConvRefPu", textStyle = {TextStyle.Bold}), Text(origin = {19, -77}, lineColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "idConvPu"), Text(origin = {19, -83}, lineColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "iqConvPu"), Text(origin = {9, 83}, lineColor = {0, 0, 127}, extent = {{-13, 1}, {13, -1}}, textString = "theta"), Text(origin = {9, 75}, lineColor = {0, 0, 127}, extent = {{-13, 1}, {13, -1}}, textString = "omegaPu")}));


end DynGFMDroop_NOFR;
