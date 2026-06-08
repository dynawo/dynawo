within Dynawo.Examples.Nordic.Components.GeneratorWithControl;

model ElectricalControlNordic

  parameter Modelica.Units.SI.Time t1, t2, t3, t4, t5, t6;
  parameter Real Kp, Ki;
  parameter Types.CurrentModulePu Imax;
  parameter Modelica.Units.SI.Voltage Vt0;
  parameter Real Q0Pu, P0Pu, U0Pu;
  parameter Real baseratio;
  parameter Real Iq0Pu;

  Modelica.Units.SI.Power Qmax, Qmin;
  Modelica.Units.SI.Current IqMin, IqMax, IdMin, IdMax;
  Modelica.Blocks.Interfaces.RealOutput IqRef annotation(
    Placement(transformation(origin = {100, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput IdRef annotation(
    Placement(transformation(origin = {100, -60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput VRef annotation(
    Placement(transformation(origin = {-200, 80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput VReg annotation(
    Placement(transformation(origin = {-200, 40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput Vt annotation(
    Placement(transformation(origin = {-266, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput VtRef annotation(
    Placement(transformation(origin = {-200, -40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput PRef annotation(
    Placement(transformation(origin = {-200, -80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Math.Add add(k2 = +1, k1 = -1)  annotation(
    Placement(transformation(origin = {-108, 46}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.DeadZone deadZone(uMax = 0)  annotation(
    Placement(transformation(origin = {-74, 46}, extent = {{-10, -10}, {10, 10}})));
  NonElectrical.Blocks.Continuous.TransferFunction transferFunction(b = {t2, 1}, a = {t3, 1}, initType = Modelica.Blocks.Types.Init.SteadyState, u_start = Q0Pu*baseratio)  annotation(
    Placement(transformation(origin = {40, 46}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(y_start = Vt0, T = t4)  annotation(
    Placement(transformation(origin = {-216, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Division division annotation(
    Placement(transformation(origin = {-98, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add1(k1 = -1, k2 = +1)  annotation(
    Placement(transformation(origin = {-100, -34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.DeadZone deadZone1(uMax = 0)  annotation(
    Placement(transformation(origin = {-60, -34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(transformation(origin = {-20, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder11(y_start = -P0Pu*baseratio, T = t6)  annotation(
    Placement(transformation(origin = {-150, -64}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(transformation(origin = {-90, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder12(T = t5, y_start = Iq0Pu)  annotation(
    Placement(transformation(origin = {-62, 6}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(transformation(origin = {48, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y = IqMax)  annotation(
    Placement(transformation(origin = {10, -2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = IqMin)  annotation(
    Placement(transformation(origin = {10, -18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter1 annotation(
    Placement(transformation(origin = {-10, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y = IdMax)  annotation(
    Placement(transformation(origin = {-50, -62}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y = IdMin)  annotation(
    Placement(transformation(origin = {-50, -78}, extent = {{-10, -10}, {10, 10}})));
  NonElectrical.Blocks.Continuous.PI pi(Ki = Ki, Kp = Kp, Y0 = Q0Pu*baseratio)  annotation(
    Placement(transformation(origin = {-38, 46}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter2 annotation(
    Placement(transformation(origin = {10, 46}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression4(y = Qmax)  annotation(
    Placement(transformation(origin = {-26, 64}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression5(y = Qmin)  annotation(
    Placement(transformation(origin = {-26, 28}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMin = 0, uMax = 10)  annotation(
    Placement(transformation(origin = {-186, 0}, extent = {{-10, -10}, {10, 10}})));
equation
  IdMin = 0;
  IqMin = -IqMax;
  IqMax = Imax;
  IdMax = sqrt(max(0, Imax^2 - noEvent(min(IqRef^2, 1))));
  Qmax = Vt*IqMax;
  Qmin = Vt*IqMin;
  connect(VRef, add.u1) annotation(
    Line(points = {{-200, 80}, {-120, 80}, {-120, 52}}, color = {0, 0, 127}));
  connect(add.y, deadZone.u) annotation(
    Line(points = {{-96, 46}, {-86, 46}}, color = {0, 0, 127}));
  connect(Vt, firstOrder1.u) annotation(
    Line(points = {{-266, 0}, {-228, 0}}, color = {0, 0, 127}));
  connect(VtRef, add1.u2) annotation(
    Line(points = {{-200, -40}, {-112, -40}}, color = {0, 0, 127}));
  connect(add1.y, deadZone1.u) annotation(
    Line(points = {{-89, -34}, {-72, -34}}, color = {0, 0, 127}));
  connect(deadZone1.y, add2.u2) annotation(
    Line(points = {{-49, -34}, {-32, -34}, {-32, -16}}, color = {0, 0, 127}));
  connect(PRef, firstOrder11.u) annotation(
    Line(points = {{-200, -80}, {-171, -80}, {-171, -64}, {-162, -64}}, color = {0, 0, 127}));
  connect(firstOrder11.y, division1.u1) annotation(
    Line(points = {{-139, -64}, {-102, -64}}, color = {0, 0, 127}));
  connect(transferFunction.y, division.u1) annotation(
    Line(points = {{51, 46}, {66, 46}, {66, 22}, {-120, 22}, {-120, 12}, {-110, 12}}, color = {0, 0, 127}));
  connect(division.y, firstOrder12.u) annotation(
    Line(points = {{-86, 6}, {-74, 6}}, color = {0, 0, 127}));
  connect(firstOrder12.y, add2.u1) annotation(
    Line(points = {{-50, 6}, {-32, 6}, {-32, -4}}, color = {0, 0, 127}));
  connect(add2.y, variableLimiter.u) annotation(
    Line(points = {{-9, -10}, {36, -10}}, color = {0, 0, 127}));
  connect(variableLimiter.y, IqRef) annotation(
    Line(points = {{59, -10}, {72, -10}, {72, 60}, {100, 60}}, color = {0, 0, 127}));
  connect(realExpression.y, variableLimiter.limit1) annotation(
    Line(points = {{21, -2}, {36, -2}}, color = {0, 0, 127}));
  connect(realExpression1.y, variableLimiter.limit2) annotation(
    Line(points = {{21, -18}, {36, -18}}, color = {0, 0, 127}));
  connect(division1.y, variableLimiter1.u) annotation(
    Line(points = {{-78, -70}, {-22, -70}}, color = {0, 0, 127}));
  connect(realExpression2.y, variableLimiter1.limit1) annotation(
    Line(points = {{-38, -62}, {-22, -62}}, color = {0, 0, 127}));
  connect(realExpression3.y, variableLimiter1.limit2) annotation(
    Line(points = {{-38, -78}, {-22, -78}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, IdRef) annotation(
    Line(points = {{2, -70}, {56, -70}, {56, -60}, {100, -60}}, color = {0, 0, 127}));
  connect(deadZone.y, pi.u) annotation(
    Line(points = {{-63, 46}, {-50, 46}}, color = {0, 0, 127}));
  connect(pi.y, variableLimiter2.u) annotation(
    Line(points = {{-26, 46}, {-2, 46}}, color = {0, 0, 127}));
  connect(variableLimiter2.y, transferFunction.u) annotation(
    Line(points = {{21, 46}, {28, 46}}, color = {0, 0, 127}));
  connect(realExpression4.y, variableLimiter2.limit1) annotation(
    Line(points = {{-14, 64}, {-12, 64}, {-12, 54}, {-2, 54}}, color = {0, 0, 127}));
  connect(realExpression5.y, variableLimiter2.limit2) annotation(
    Line(points = {{-15, 28}, {-12, 28}, {-12, 38}, {-2, 38}}, color = {0, 0, 127}));
  connect(firstOrder1.y, limiter.u) annotation(
    Line(points = {{-204, 0}, {-198, 0}}, color = {0, 0, 127}));
  connect(limiter.y, division1.u2) annotation(
    Line(points = {{-174, 0}, {-134, 0}, {-134, -76}, {-102, -76}}, color = {0, 0, 127}));
  connect(limiter.y, add1.u1) annotation(
    Line(points = {{-174, 0}, {-126, 0}, {-126, -28}, {-112, -28}}, color = {0, 0, 127}));
  connect(limiter.y, division.u2) annotation(
    Line(points = {{-174, 0}, {-110, 0}}, color = {0, 0, 127}));
  connect(VReg, add.u2) annotation(
    Line(points = {{-200, 40}, {-120, 40}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end ElectricalControlNordic;
