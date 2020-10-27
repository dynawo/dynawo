within OpenEMTP.Examples.IEEE13Bus;
model multiPhaseCP
  parameter Integer m(min = 1)=3 "Number of phases";
  parameter Real h[m]  "{h1,h2,h3}";
  parameter Real Zmod[m] "Modified Zcm={Zcm1,Zcm2,Zcm3}";
  parameter Real tau[m] " tau ={tau1,tau2,tau3}";
  parameter Real Ti[m,m]= CpTiMatrix(m) "If the line is not fully transposed, insert the Ti";
  // Real RN[m,m]  = Ti * diagonal(Zmod) * Modelica.Math.Matrices.inv(Ti) "CP RN";
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug sP(m = m)  annotation(
    Placement(visible = true, transformation(origin = {-100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-92, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug rP(m = m)  annotation(
    Placement(visible = true, transformation(origin = {100, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {88, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Sensors.VoltageSensor vM1(m = m)  annotation(
    Placement(visible = true, transformation(origin = {-100, -40}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  Modelica.Electrical.MultiPhase.Sensors.VoltageSensor vM2(m = m)  annotation(
    Placement(visible = true, transformation(origin = {100, -40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  CpHistoryTerm cpHistoryTerm1(Ti = Ti, Zmod = Zmod, h = h, m = m, tau = tau)  annotation(
    Placement(visible = true, transformation(origin = {1, 9}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  Norton sNorton(RN = Modelica.Math.Matrices.inv(transpose(Ti)) * diagonal(Zmod) * Modelica.Math.Matrices.inv(Ti), m = m)  annotation(
    Placement(visible = true, transformation(origin = {-60, 20}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Norton rNorton(RN = Modelica.Math.Matrices.inv(transpose(Ti)) * diagonal(Zmod) * Modelica.Math.Matrices.inv(Ti), m = m)  annotation(
    Placement(visible = true, transformation(origin = {60, 20}, extent = {{-20, 20}, {20, -20}}, rotation = -90)));
  Modelica.Electrical.MultiPhase.Basic.Star star1(m = m)  annotation(
    Placement(visible = true, transformation(origin = {8, -74}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Ground ground1 annotation(
    Placement(visible = true, transformation(origin = {66, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(vM2.v, cpHistoryTerm1.rV) annotation(
    Line(points = {{90, -40}, {40, -40}, {40, 6}, {16, 6}, {16, 6}}, color = {0, 0, 127}, thickness = 0.5));
  connect(vM1.plug_p, sP) annotation(
    Line(points = {{-100, -30}, {-100, -30}, {-100, 40}, {-100, 40}}, color = {0, 0, 255}));
  connect(sP, sNorton.plug_p) annotation(
    Line(points = {{-100, 40}, {-60, 40}, {-60, 40}, {-60, 40}}, color = {0, 0, 255}));
  connect(vM2.plug_p, rP) annotation(
    Line(points = {{100, -30}, {100, 42}}, color = {0, 0, 255}));
  connect(rP, rNorton.plug_p) annotation(
    Line(points = {{100, 42}, {100, 40}, {60, 40}}, color = {0, 0, 255}));
  connect(ground1.p, star1.pin_n) annotation(
    Line(points = {{66, -84}, {8, -84}}, color = {0, 0, 255}));
  connect(sNorton.plug_n, star1.plug_p) annotation(
    Line(points = {{-60, 0}, {-60, -64}, {8, -64}}, color = {0, 0, 255}));
  connect(rNorton.plug_n, star1.plug_p) annotation(
    Line(points = {{60, 0}, {58, 0}, {58, -64}, {8, -64}}, color = {0, 0, 255}));
  connect(vM1.plug_n, star1.plug_p) annotation(
    Line(points = {{-100, -50}, {8, -50}, {8, -64}}, color = {0, 0, 255}));
  connect(vM2.plug_n, star1.plug_p) annotation(
    Line(points = {{100, -50}, {8, -50}, {8, -64}}, color = {0, 0, 255}));
  connect(vM1.v, cpHistoryTerm1.sV) annotation(
    Line(points = {{-88, -40}, {-44, -40}, {-44, 6}, {-14, 6}, {-14, 6}}, color = {0, 0, 127}, thickness = 0.5));
  connect(cpHistoryTerm1.rIh, rNorton.iN) annotation(
    Line(points = {{16, 19.5}, {18, 19.5}, {18, 20}, {42, 20}}, color = {0, 0, 127}, thickness = 0.5));
  connect(cpHistoryTerm1.sIh, sNorton.iN) annotation(
    Line(points = {{-14, 19.5}, {-42, 19.5}, {-42, 20}}, color = {0, 0, 127}, thickness = 0.5));
  annotation(
    Icon(graphics = {Rectangle(origin = {-1, 0}, lineColor = {0, 0, 255}, extent = {{-91, 30}, {91, -30}}), Text(origin = {1, 2}, extent = {{-39, 16}, {39, -16}}, textString = "CP"), Text(origin = {-2, -61}, extent = {{-36, 15}, {36, -15}}, textString = "m=%m"), Text(origin = {-19, 70}, lineColor = {0, 0, 255}, extent = {{-61, 20}, {83, -36}}, textString = "%name"), Text(origin = {-73, 1}, extent = {{11, -13}, {-11, 13}}, textString = "+")}, coordinateSystem(extent = {{-150, -110}, {150, 110}})),
    uses(Modelica(version = "3.2.2")),
  Diagram(coordinateSystem(extent = {{-150, -110}, {150, 110}})),
  version = "",
  __OpenModelica_commandLineOptions = "");end multiPhaseCP;
