within Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing;

model DynGFL "PEIR model with GFL control and dynamic connections to the grid"
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffInjector;

  // Installation parameter
  parameter Types.ApparentPowerModule SNom "Nominal apparent power module for the converter";

  // Measurements parameters
  parameter Types.Time tUFilt = 0.01 "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "Measurements"));
  parameter Types.Time tUqPLL "Filter time constant for voltage q measurement specially designed for the PLL in s" annotation(
    Dialog(tab = "Measurements"));
  parameter Types.Time tPQFilt "Filter time constant for voltage/current measurement that goes to the PQ calculation in s" annotation(
    Dialog(tab = "Measurements"));

  // PLL parameters
  parameter Types.PerUnit Ki "PLL integrator gain" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit Kp "PLL proportional gain" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit OmegaMaxPu "Upper frequency limit in pu (base OmegaNom)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit OmegaMinPu "Lower frequency limit in pu (base OmegaNom)" annotation(
    Dialog(tab = "PLL"));
  // Outer loop parameters
  parameter Types.PerUnit Kpd "Active power PI controller proportional gain in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "Outer loop"));
  parameter Types.PerUnit Kid "Active power PI controller integral gain in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "Outer loop"));
  parameter Types.PerUnit Kpq "Reactive power PI controller proportional gain in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "Outer loop"));
  parameter Types.PerUnit Kiq "Reactive power PI controller integral gain in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "Outer loop"));
  parameter Types.Time tPFilt "Filter time constant for active power measurement in s" annotation(
    Dialog(tab = "Outer loop"));
  parameter Types.Time tQFilt "Filter time constant for reactive power measurement in s" annotation(
    Dialog(tab = "Outer loop"));
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

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {106, 42}, extent = {{-6, -6}, {6, 6}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealInput PFilterRefPu(start = Control.outerLoop.PFilter0Pu) "Active power reference at the filter in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "System frequency reference in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-110, 48}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QFilterRefPu(start = Control.outerLoop.QFilter0Pu) "Reactive power reference at the filter in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.PEIR.BaseControls.Auxiliaries.MeasurementsFiltered Measurements(IdPcc0Pu = Converter.refFrameRotation.IdPcc0Pu, IqPcc0Pu = Converter.refFrameRotation.IqPcc0Pu, UdFilter0Pu = Converter.RLTransformer.UdFilter0Pu, UdPcc0Pu = Converter.refFrameRotation.UdPcc0Pu, UqFilter0Pu = Converter.RLTransformer.UqFilter0Pu, UqPcc0Pu = Converter.refFrameRotation.UqPcc0Pu, tUFilt = tUFilt, tUqPLL = tUqPLL, IdConv0Pu = Converter.RLCFilter.IdConv0Pu, IqConv0Pu = Converter.RLCFilter.IqConv0Pu, tPQFilt = tPQFilt) annotation(
    Placement(transformation(origin = {12, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Dynawo.Electrical.Controls.PEIR.Converters.Average.DynGridFollowingControl Control(IdConv0Pu = Converter.RLCFilter.IdConv0Pu, IqConv0Pu = Converter.RLCFilter.IqConv0Pu, Kfd = Kfd, Kfq = Kfq, Ki = Ki, Kic = Kic, Kid = Kid, Kiq = Kiq, Kp = Kp, Kpc = Kpc, Kpd = Kpd, Kpq = Kpq, LFilterPu = LFilterPu, LTransformerPu = LTransformerPu, Omega0Pu = SystemBase.omegaRef0Pu, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, PFilter0Pu = Measurements.PFilter0Pu, QFilter0Pu = Measurements.QFilter0Pu, RFilterPu = RFilterPu, RTransformerPu = RTransformerPu, Theta0 = Converter.Theta0, UdConv0Pu = Converter.RLCFilter.UdConv0Pu, UdFilter0Pu = Converter.RLTransformer.UdFilter0Pu, UqConv0Pu = Converter.RLCFilter.UqConv0Pu, UqFilter0Pu = Converter.RLTransformer.UqFilter0Pu, tPFilt = tPFilt, tQFilt = tQFilt) annotation(
    Placement(transformation(origin = {-48, 40}, extent = {{-20, -20}, {20, 20}})));
  Dynawo.Electrical.Sources.PEIR.Converters.Average.DynConverter1 Converter(CFilterPu = CFilterPu, LFilterPu = LFilterPu, LTransformerPu = LTransformerPu, Omega0Pu = SystemBase.omegaRef0Pu, RFilterPu = RFilterPu, RTransformerPu = RTransformerPu, SNom = SNom, Theta0 = Theta0, i0Pu = i0Pu, tVSC = tVSC, u0Pu = u0Pu) annotation(
    Placement(transformation(origin = {70, 40}, extent = {{-20, -20}, {20, 20}})));

  // Operating point
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal/PCC in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at terminal/PCC in rad";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal/PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal/PCC in pu (base SnRef) (receptor convention)";

  final parameter Types.ComplexVoltagePu u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0) "Start value of the complex voltage at terminal/PCC in pu (base UNom)";
  final parameter Types.ComplexCurrentPu i0Pu = ComplexMath.conj(Complex(P0Pu, Q0Pu)/u0Pu) "Start value of the complex current at terminal/PCC in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu uFilter0Pu = u0Pu - Complex(RTransformerPu, LTransformerPu*SystemBase.omegaRef0Pu)*i0Pu*SystemBase.SnRef/SNom "Start value of the complex voltage at the filter in pu (base UNom)";
  final parameter Types.Angle Theta0 = atan2(uFilter0Pu.im, uFilter0Pu.re) "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";

equation
  connect(omegaRefPu, Control.omegaRefPu) annotation(
    Line(points = {{-110, 48}, {-70, 48}}, color = {0, 0, 127}, thickness = 0.5));
  connect(PFilterRefPu, Control.PFilterRefPu) annotation(
    Line(points = {{-110, 64}, {-80, 64}, {-80, 55}, {-70, 55}}, color = {85, 170, 0}, thickness = 0.5));
  connect(QFilterRefPu, Control.QFilterRefPu) annotation(
    Line(points = {{-110, 32}, {-80, 32}, {-80, 36}, {-70, 36}}, color = {85, 170, 0}, thickness = 0.5));
  connect(Converter.terminal, terminal) annotation(
    Line(points = {{92, 40}, {99, 40}, {99, 42}, {106, 42}}, color = {0, 0, 255}));
  connect(Control.udConvRefPu, Converter.udConvRefPu) annotation(
    Line(points = {{-26, 48}, {48, 48}}, color = {245, 121, 0}, thickness = 0.5));
  connect(Control.uqConvRefPu, Converter.uqConvRefPu) annotation(
    Line(points = {{-26, 32}, {48, 32}}, color = {245, 121, 0}, thickness = 0.5));
  connect(Control.omegaPu, Converter.omegaPu) annotation(
    Line(points = {{-38, 62}, {-38, 70}, {60, 70}, {60, 62}}, color = {0, 0, 127}));
  connect(Control.theta, Converter.theta) annotation(
    Line(points = {{-58, 62}, {-58, 80}, {80, 80}, {80, 62}}, color = {0, 0, 127}));
  connect(Measurements.idPccPu, Converter.idPccPu) annotation(
    Line(points = {{34, -23}, {34, -22.5}, {52, -22.5}, {52, 22}, {53, 22}, {53, 18}, {52, 18}}, color = {85, 170, 255}));
  connect(Converter.iqPccPu, Measurements.iqPccPu) annotation(
    Line(points = {{56, 18}, {56, -27}, {34, -27}}, color = {85, 170, 255}));
  connect(Converter.uqPccPu, Measurements.uqPccPu) annotation(
    Line(points = {{68, 18}, {68, -44}, {34, -44}}, color = {98, 160, 234}));
  connect(Converter.udPccPu, Measurements.udPccPu) annotation(
    Line(points = {{63, 18}, {63, -42}, {34, -42}}, color = {98, 160, 234}));
  connect(Measurements.iqConvPu, Converter.iqConvPu) annotation(
    Line(points = {{34, -36}, {34, -38}, {88, -38}, {88, 18}}, color = {255, 120, 0}));
  connect(Converter.idConvPu, Measurements.idConvPu) annotation(
    Line(points = {{84, 18}, {84, -32}, {34, -32}}, color = {255, 120, 0}));
  connect(Measurements.PFilteredFilterPu, Control.PFilteredFilterPu) annotation(
    Line(points = {{-10, -58}, {-80, -58}, {-80, 28}, {-70, 28}}, color = {85, 170, 0}));
  connect(Measurements.QFilteredFilterPu, Control.QFilteredFilterPu) annotation(
    Line(points = {{-10, -54}, {-76, -54}, {-76, 24}, {-70, 24}}, color = {85, 170, 0}));
  connect(Measurements.iqFilteredConvPu, Control.iqConvPu) annotation(
    Line(points = {{22, -62}, {22, -88}, {-66, -88}, {-66, 18}}, color = {245, 121, 0}));
  connect(Measurements.idFilteredConvPu, Control.idConvPu) annotation(
    Line(points = {{16, -62}, {16, -80}, {-62, -80}, {-62, 18}}, color = {245, 121, 0}));
  connect(Measurements.udFilteredFilterPu, Control.udFilterPu) annotation(
    Line(points = {{-10, -30}, {-52, -30}, {-52, 18}}, color = {85, 170, 0}));
  connect(Measurements.uqFilteredFilterPLLPu, Control.uqFilteredPLLPu) annotation(
    Line(points = {{2, -62}, {2, -68}, {-86, -68}, {-86, 42}, {-70, 42}}, color = {97, 53, 131}));
  connect(Measurements.uqFilteredFilterPu, Control.uqFilterPu) annotation(
    Line(points = {{2, -62}, {2, -68}, {-86, -68}, {-86, 42}, {-70, 42}}, color = {97, 53, 131}));
  connect(Measurements.uqFilterPu, Converter.uqFilterPu) annotation(
    Line(points = {{-10, -34}, {-56, -34}, {-56, 18}}, color = {85, 170, 0}));
  connect(Converter.udFilterPu, Measurements.udFilterPu) annotation(
    Line(points = {{34, -58}, {78, -58}, {78, 18}}, color = {85, 170, 0}, pattern = LinePattern.Dash));
  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>This model represents a power-electronics interface resource, with the following elements:<div><br></div><div>- A Grid-Forming Virtual Synchronous Machine control defining voltage source references at the converter interface</div><div>- A converter part with an AVM model, a dynamic RLC filter and a dynamic RL transformer</div><div>- A measurement block to apply measurement treatment to the voltage and current</div><div><br></div><div>As of today, the model doesn't include any current saturation scheme.</div><div><br></div><div><br></div><div><br></div></body></html>"),
    Diagram(graphics = {Text(origin = {45, -19}, textColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "idPccPu"), Text(origin = {53, -45}, textColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "uqPccPu"), Text(origin = {53, -51}, textColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "udFilterPu"), Text(origin = {55, -61}, textColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "uqFilterPu"), Text(origin = {-29, -51}, textColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "QFilteredFilterPu"), Text(origin = {-29, -61}, textColor = {85, 170, 0}, extent = {{-13, 1}, {13, -1}}, textString = "PFilteredFilterPu"), Text(origin = {9, 53}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "udConvRefPu", textStyle = {TextStyle.Bold}), Text(origin = {9, 37}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "uqConvRefPu", textStyle = {TextStyle.Bold}), Text(origin = {51, -29}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "idConvPu"), Text(origin = {51, -33}, textColor = {245, 121, 0}, extent = {{-13, 1}, {13, -1}}, textString = "iqConvPu"), Text(origin = {9, 83}, textColor = {0, 0, 127}, extent = {{-13, 1}, {13, -1}}, textString = "theta"), Text(origin = {9, 75}, textColor = {0, 0, 127}, extent = {{-13, 1}, {13, -1}}, textString = "omegaPu"), Text(origin = {51, -39}, textColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "udPccPu"), Text(origin = {47, -25}, textColor = {85, 170, 255}, extent = {{-13, 1}, {13, -1}}, textString = "iqPccPu"), Text(origin = {-29, -26}, textColor = {85, 170, 0}, extent = {{-23, 2}, {23, -2}}, textString = "udFilteredFilterPu"), Text(origin = {-31, -38}, textColor = {85, 170, 0}, extent = {{-25, 2}, {25, -2}}, textString = "uqFilteredFilterPu"), Text(origin = {-18, -77}, textColor = {245, 121, 0}, extent = {{-20, 1}, {20, -1}}, textString = "idFilteredConvPu"), Text(origin = {-18, -85}, textColor = {245, 121, 0}, extent = {{-20, 1}, {20, -1}}, textString = "iqFilteredConvPu"), Text(origin = {-25, -70}, textColor = {97, 53, 131}, extent = {{-25, 2}, {25, -2}}, textString = "uqFilteredPLLPu")}));
end DynGFL;
