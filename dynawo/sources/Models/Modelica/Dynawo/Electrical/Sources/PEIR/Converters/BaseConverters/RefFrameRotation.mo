within Dynawo.Electrical.Sources.PEIR.Converters.BaseConverters;

model RefFrameRotation "Reference frame rotation module - (re, im) <-> (d,q)"

  parameter Types.ApparentPowerModule SNom "Nominal apparent power module for the converter in MVA";

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {110, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Inputs
  Modelica.Blocks.Interfaces.RealInput idPccPu(start = IdPcc0Pu) "d-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start = IqPcc0Pu) "q-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {8.88178e-16, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput udPccPu(start = UdPcc0Pu) "d-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqPccPu(start = UqPcc0Pu) "q-axis voltage at the PCC in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at terminal in pu (base UNom)";
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";

  final parameter Types.PerUnit UdPcc0Pu = cos(Theta0)*u0Pu.re + sin(Theta0)*u0Pu.im "Start value of d-axis voltage at the PCC in pu (base UNom)";
  final parameter Types.PerUnit UqPcc0Pu = -sin(Theta0)*u0Pu.re + cos(Theta0)*u0Pu.im "Start value of q-axis voltage at the PCC in pu (base UNom)";
  final parameter Types.PerUnit IdPcc0Pu = -(cos(Theta0)*i0Pu.re + sin(Theta0)*i0Pu.im) * SystemBase.SnRef / SNom "Start value of d-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  final parameter Types.PerUnit IqPcc0Pu = (sin(Theta0)*i0Pu.re - cos(Theta0)*i0Pu.im) * SystemBase.SnRef / SNom "Start value of q-axis current in the grid in pu (base UNom, SNom) (generator convention)";

equation
  [udPccPu; uqPccPu] = [cos(theta), sin(theta); -sin(theta), cos(theta)] * [terminal.V.re; terminal.V.im];
  [idPccPu; iqPccPu] = -[cos(theta), sin(theta); -sin(theta), cos(theta)] * [terminal.i.re; terminal.i.im] * SystemBase.SnRef / SNom;

annotation(preferredView = "text",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {52, 58}, rotation = 90, extent = {{-141, 127}, {38, -33}}, textString = "Reference Frame Rotation")}));
end RefFrameRotation;
