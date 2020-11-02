within OpenEMTP.Electrical.Lines.WBmodel;
model AdmittanceConvolution
  // parameter YcFittingParamters lineParameter //
  extends Modelica.Electrical.MultiPhase.Interfaces.OnePort;
  parameter Real G0[m, m] annotation(HideResult=true);
  parameter Real G[Ny, m, m] annotation(HideResult=true);
  parameter Real q[Ny] annotation(HideResult=true);
  Real w[m, Ny](start=zeros(m,Ny),each fixed=true) annotation(HideResult=true);
  Real sum_w[m] annotation(HideResult=true);
  Real i_sh[m] annotation(HideResult=true);
  final parameter Integer Ny = size(G, 1) "Order of fitting of Yc" annotation(HideResult=true);
// incident current
  Modelica.Blocks.Interfaces.RealInput i_i[m] annotation (
    Placement(visible = true, transformation(origin = {20, 52}, extent = {{20, -20}, {-20, 20}}, rotation = 90), iconTransformation(origin = {0, 87}, extent = {{13, -13}, {-13, 13}}, rotation = 90)));

equation
  i = i_sh - 2 * i_i;
  for p in 1:Ny loop
    for k in 1:m loop
      der(w[k, p]) = q[p] * w[k, p] + G[p, k, :] * v;
    end for;
  end for;
// sum of all columns for each phase
  for k in 1:m loop
    sum_w[k] = sum(w[k, :]);
  end for;
  i_sh = G0 * v + sum_w "Calc of shunt current";

  annotation (
    Icon(graphics = {Rectangle(origin = {-8, -3}, rotation = 90, extent = {{-5, 9}, {9, -25}}), Text(origin = {-3, -18}, rotation = 90, extent = {{-7, 8}, {7, -8}}, textString = "Yc"), Ellipse(origin = {-1, 49}, rotation = 90, extent = {{-21, -21}, {19, 19}}, endAngle = 360), Line(origin = {-2.0044, 49.1651}, rotation = 90, points = {{0, 15}, {0, -15}}, color = {255, 0, 0}, thickness = 1, arrow = {Arrow.Filled, Arrow.None}, arrowSize = 7), Text(origin = {23, 85}, rotation = 90, extent = {{-7, 8}, {7, -8}}, textString = "i_incident"), Line(origin = {-76, 0}, points = {{-14, 0}, {14, 0}, {14, 0}, {14, 0}, {58, 0}}), Line(origin = {78, 0}, points = {{-60, 0}, {12, 0}, {12, 0}}), Line(origin = {-50, 25}, points = {{30, 25}, {-30, 25}, {-30, -25}}), Line(origin = {50, 50}, points = {{-30, 0}, {30, 0}}), Line(origin = {80, 25}, points = {{0, 25}, {0, -25}})}, coordinateSystem(initialScale = 0.1)),
    uses(Modelica(version = "3.2.3")),
  experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002),
  __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"));
end AdmittanceConvolution;
