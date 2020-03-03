model PV_WECC_CurrentSource

  import Modelica.ComplexMath;
  import Modelica.SIunits;
  import Dynawo;
  import Dynawo.Types;
  // Blocks:
  InfiniteBus infiniteBus1(
    U0Pu = 1, UEvtPu = 0.5, UPhase = 0,
    omega0Pu = 1, omegaEvtPu = 1.01,
    tVEvtEnd = 2, tVEvtStart = 1, tomegaEvtEnd = 9, tomegaEvtStart = 6) annotation(
    Placement(visible = true, transformation(origin = {70, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformerFixedRatio1(
    BPu = -0.004998789853554560,
    GPu = 0.00011,
    RPu = 0.0005499999970,
    XPu = 0.0999984874885615,
    rTfoPu = 1,
  state(start = Dynawo.Electrical.Constants.state.Closed)) annotation(
    Placement(visible = true, transformation(origin = {40, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformerFixedRatio2(
    BPu = -0.004998789853554560,
    GPu = 0.00002,
    RPu = 0.0000999999902,
    XPu = 0.049999899999,
    rTfoPu = 1,
    state(start = Dynawo.Electrical.Constants.state.Closed)) annotation(
    Placement(visible = true, transformation(origin = {-20, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1(
    BPu = 0, GPu = 0, RPu = 0, XPu = 0.000025,
    state(start = Dynawo.Electrical.Constants.state.Closed)) annotation(
    Placement(visible = true, transformation(origin = {10, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Photovoltaics.WECC.PVCurrentSource WECC_PV_Model1(
    Blne = 0, Btfo = -0.004998789853554560,
    Glne = 0, Gtfo = 0.00002,Omega0Pu = 1,
    PRefPu(fixed = true), PReg0Pu = -0.7, QRefPu(fixed = true), QReg0Pu = -0.1726630023,
    Rlne = 0, Rtfo = 0.0000999999902,
    SNom = 100, UReg0Pu = 1.01463461,
    URegPhase0 (displayUnit = "rad") = 0.0690452,
    Xlne = 0.000025, Xtfo = 0.049999899999) annotation(
    Placement(visible = true, transformation(origin = {-56.0619, 50.7585}, extent = {{-18.8224, -9.4112}, {18.8224, 9.4112}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PRefPu(k = WECC_PV_Model1.PRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-94, 58}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant QRefPu(k = WECC_PV_Model1.QRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-94, 44}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant OmegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-94, 30}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));

  // Inner variables:
  Types.PerUnit PRegPu_SnRef;
  Types.PerUnit QRegPu_SnRef;
  Types.ComplexCurrentPu iRegPu_SnRef;
  Types.ComplexVoltagePu uRegPu;

equation

  connect(OmegaRefPu.y, WECC_PV_Model1.OmegaRefPu) annotation(
    Line(points = {{-90, 30}, {-84, 30}, {-84, 43}, {-75, 43}}, color = {0, 0, 127}));
  connect(iRegPu_SnRef, WECC_PV_Model1.iRegPu_SnRef) annotation(
    Line);
  connect(PRegPu_SnRef, WECC_PV_Model1.PRegPu_SnRef) annotation(
    Line);
  connect(QRegPu_SnRef, WECC_PV_Model1.QRegPu_SnRef) annotation(
    Line);
  connect(uRegPu, WECC_PV_Model1.uRegPu) annotation(
    Line);
  connect(transformerFixedRatio2.terminal2, WECC_PV_Model1.terminal) annotation(
    Line);
  connect(PRefPu.y, WECC_PV_Model1.PRefPu) annotation(
    Line(points = {{-90, 58}, {-75, 58}}, color = {0, 0, 127}));
  connect(QRefPu.y, WECC_PV_Model1.QRefPu) annotation(
    Line(points = {{-90, 44}, {-88, 44}, {-88, 54}, {-75, 54}}, color = {0, 0, 127}));
  connect(infiniteBus1.terminal, transformerFixedRatio1.terminal1) annotation(
    Line);
  connect(transformerFixedRatio1.terminal2, line1.terminal1) annotation(
    Line);
  connect(line1.terminal2, transformerFixedRatio2.terminal1) annotation(
    Line);

  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  transformerFixedRatio1.switchOffSignal1.value = false;
  transformerFixedRatio2.switchOffSignal1.value = false;

  // Measurement values at regulated bus for plant level control, receptor convention, pu base SnRef
  PRegPu_SnRef = ComplexMath.real(line1.terminal1.V * ComplexMath.conj(line1.terminal1.i));
  QRegPu_SnRef = ComplexMath.imag(line1.terminal1.V * ComplexMath.conj(line1.terminal1.i));
  iRegPu_SnRef = line1.terminal1.i;
  uRegPu = line1.terminal1.V;

  annotation(
    Documentation(info = "<html>
<p> This block contains the test system for the generic WECC PV model: (Will be changed according to our discussion from 8th of August.)
<ul>
<li> Main model: WECC_PV with terminal connection and measurement inputs for P/Q/U/I.</li>
<li> Plant level network elements: step-up-transformer, line, transformer. </li>
<li> Infinite bus element with internal disturbance creation for voltage and frequency element (at the moment frequency is defined as separate variable, will be changed as soon as PLL is implemented for frequency measurement).</li>
</ul> </p></html>"),
    uses(Dynawo(version = "0.1"), Modelica(version = "3.2.3")),
    Diagram(coordinateSystem(extent = {{-100, 0}, {100, 100}})),
    experiment(StartTime = 0, StopTime = 12, Tolerance = 0.001, Interval = 0.0001),
    Icon(coordinateSystem(extent = {{-100, 0}, {100, 100}})),
    version = "",
    __OpenModelica_commandLineOptions = "");

end PV_WECC_CurrentSource;
