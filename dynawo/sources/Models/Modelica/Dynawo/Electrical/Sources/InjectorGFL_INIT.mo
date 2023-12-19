within Dynawo.Electrical.Sources;

model InjectorGFL_INIT "Injector model for grid following converter"

  import Modelica;
  import Dynawo;
  parameter Types.ApparentPowerModule SNom"base apparent power in MVA";
  parameter Types.AngularVelocity omegaNom "Nominal System angular frequency";
  parameter Types.PerUnit ratioTr "Connection transformer ratio in p.u";
  parameter Types.PerUnit R "Transformer resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit L "Transformer inductance in pu (base UNom, SNom)";
  parameter Types.PerUnit Rc "resistance value from converter terminal to PCC in pu (base UNom, SNom)";
  parameter Types.PerUnit Xc "reactance value from converter terminal to PCC in pu (base UNom, SNom)";
  parameter Types.AngularVelocity omegaRef0Pu;

  /* Converter bus initialisation data*/
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at terminal in rad";
  parameter Types.ActivePowerPu P0Pu "Start value of converter generated active power in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of converter generated reactive power in pu (base SNom) (generator convention)";

  /* Initial quantities to calculate from initialisation data*/
  Types.ComplexVoltagePu uPcc0Pu;
  Types.ComplexCurrentPu iPcc0Pu;
  Types.ComplexVoltagePu uConv0Pu;
  Types.ComplexCurrentPu iConv0Pu;
  Types.PerUnit udPcc0Pu;
  Types.PerUnit uqPcc0Pu;
  Types.PerUnit idPcc0Pu;
  Types.PerUnit iqPcc0Pu;
  Types.PerUnit udConv0Pu;
  Types.PerUnit uqConv0Pu;
  Types.PerUnit idConv0Pu;
  Types.PerUnit iqConv0Pu;
  Types.PerUnit udConvRef0Pu;
  Types.PerUnit uqConvRef0Pu;
  Types.PerUnit thetaPLL0Pu;
  Types.PerUnit omegaPLL0Pu;
  Types.PerUnit PGen0Pu;
  Types.PerUnit QGen0Pu;
  Types.PerUnit UConv0Pu;

equation
  uPcc0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  PGen0Pu = P0Pu;
  QGen0Pu = Q0Pu;
  iPcc0Pu = ComplexMath.conj(Complex(PGen0Pu, QGen0Pu)/uPcc0Pu);
  thetaPLL0Pu = ComplexMath.arg(uPcc0Pu);
  omegaPLL0Pu= omegaRef0Pu;
  udPcc0Pu = cos(thetaPLL0Pu)*uPcc0Pu.re + sin(thetaPLL0Pu)*uPcc0Pu.im;
  uqPcc0Pu = -sin(thetaPLL0Pu)*uPcc0Pu.re + cos(thetaPLL0Pu)*uPcc0Pu.im;
  idPcc0Pu = cos(thetaPLL0Pu)*iPcc0Pu.re + sin(thetaPLL0Pu)*iPcc0Pu.im;
  iqPcc0Pu = -sin(thetaPLL0Pu)*iPcc0Pu.re + cos(thetaPLL0Pu)*iPcc0Pu.im;
  udConv0Pu = cos(thetaPLL0Pu)*uConv0Pu.re + sin(thetaPLL0Pu)*uConv0Pu.im;
  uqConv0Pu = -sin(thetaPLL0Pu)*uConv0Pu.re + cos(thetaPLL0Pu)*uConv0Pu.im;
  idConv0Pu = ratioTr*cos(thetaPLL0Pu)*iPcc0Pu.re + ratioTr*sin(thetaPLL0Pu)*iPcc0Pu.im;
  iqConv0Pu = -ratioTr*sin(thetaPLL0Pu)*iPcc0Pu.re + ratioTr*cos(thetaPLL0Pu)*iPcc0Pu.im;
  udConvRef0Pu = udPcc0Pu/ratioTr + R*idPcc0Pu*ratioTr - omegaPLL0Pu*L*iqPcc0Pu*ratioTr;
  uqConvRef0Pu = uqPcc0Pu/ratioTr + R*iqPcc0Pu*ratioTr + omegaPLL0Pu*L*idPcc0Pu*ratioTr;

  uConv0Pu = (uPcc0Pu/ratioTr) + iPcc0Pu*ratioTr*Complex(R, Xc);
  iConv0Pu = iPcc0Pu*ratioTr;
  UConv0Pu = ComplexMath.'abs'(uConv0Pu);

  annotation(
    Placement(visible = true, transformation(origin = {69, -12}, extent = {{-5, -5}, {5, 5}}, rotation = 0), iconTransformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)),
    preferredView = "text",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-55, -60}, {64, 60}})),
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {5, 6}, extent = {{-95, 56}, {90, -68}}, textString = "InjectorGFL"), Text(origin = {-47, 88}, extent = {{-32, 12}, {24, -8}}, textString = "uPccPu", fontSize = 14), Text(origin = {-138, 92}, extent = {{-32, 12}, {24, -8}}, textString = "omegaPLLPu"), Text(origin = {-139, 43}, extent = {{-32, 12}, {24, -8}}, textString = "thetaPLLPu"), Text(origin = {-138, -18}, extent = {{-32, 12}, {24, -8}}, textString = "udConvRefPu"), Text(origin = {-134, -68}, extent = {{-32, 12}, {24, -8}}, textString = "uqConvRefPu"), Text(origin = {26, -86}, rotation = 180, extent = {{-32, 12}, {24, -8}}, textString = "udPccPu", fontSize = 14), Text(origin = {66, -86}, rotation = 180, extent = {{-32, 12}, {24, -8}}, textString = "uqPccPu", fontSize = 14), Text(origin = {-33, -86}, rotation = 180, extent = {{-32, 12}, {24, -8}}, textString = "iqConvPu", fontSize = 14), Text(origin = {-74, -86}, rotation = 180, extent = {{-32, 12}, {24, -8}}, textString = "idConvPu", fontSize = 14), Text(origin = {82, 78}, extent = {{-32, 12}, {24, -8}}, textString = "PGenPu", fontSize = 14), Text(origin = {82, 39}, extent = {{-32, 12}, {24, -8}}, textString = "QGenPu", fontSize = 14), Text(origin = {82, -50}, extent = {{-32, 12}, {24, -8}}, textString = "UConvPu", fontSize = 14), Text(origin = {53, 88}, extent = {{-32, 12}, {24, -8}}, textString = "iPccPu", fontSize = 14)}));
end InjectorGFL_INIT;
