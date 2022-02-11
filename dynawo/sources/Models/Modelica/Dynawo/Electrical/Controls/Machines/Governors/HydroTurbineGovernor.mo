within Dynawo.Electrical.Controls.Machines.Governors;

model HydroTurbineGovernor

  import Modelica;
  import Dynawo;

  parameter Types.Time Tder = 1e-4 "Delay of the derivative block";

  // Turbine
  parameter Types.Time Tw "Water delay";
  parameter Types.PerUnit qnL "Per unit no-load flow";
  parameter Real At "Proportionality factor = Turbine MW rating / Genrator MWA rating / h_r / (q_r - q_nL), h_r is the unit head at rating flow, q_r is the rating fload";
  parameter Real D "Speed deviation damping effect";
  parameter Types.PerUnit R "Droop";

  // Governor
  parameter Types.Time Tf "Filter delay";
  parameter Types.Time Tr "Temporary droop reset time";
  parameter Types.PerUnit r "Temporary droop";
  parameter Types.Time Tg "Gate delay";
  parameter Types.PerUnit Gmax "Max gate opening";
  parameter Types.PerUnit Gmin "Min gate opening";
  parameter Types.PerUnit VelMax "Gate rate limit";
  parameter Types.PerUnit Hdam "Dam height";
  Modelica.Blocks.Math.Gain gain3(k = G0 * R / Pm0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-186, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PmRefPu(start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {-243, 139}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {40, 102}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative D_(T = Tder, k = 1 / r, x_start = 0, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-18, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {-232, 50}, extent = {{-14, -14}, {14, 14}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-272, 102}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
protected
  parameter Types.ActivePowerPu Pm0Pu "Initial mechanical power in pu (base PNom)";
  // Pm = At * h * (q-qnL) - D*G*deltaOmega
  parameter Types.PerUnit q0 = Pm0Pu / (At * Hdam) + qnL "Initial value of the water flow";
  parameter Types.PerUnit G0 = q0 / sqrt(Hdam) "Initial value of the gate opening";
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = Tf, y_start = 0)  annotation(
    Placement(visible = true, transformation(origin = {-68, 102}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k3 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-118, 102}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-232, 102}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain P(k = 1 / (r * Tr))  annotation(
    Placement(visible = true, transformation(origin = {-18, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter rateLimit(limitsAtInit = true, uMax = VelMax, uMin = -VelMax)  annotation(
    Placement(visible = true, transformation(origin = {76, 102}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(outMax = Gmax, outMin = -Gmax, y_start = G0)  annotation(
    Placement(visible = true, transformation(origin = {116, 102}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrderGate(T = Tg, y_start = G0)  annotation(
    Placement(visible = true, transformation(origin = {156, 102}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain droop(k = R)  annotation(
    Placement(visible = true, transformation(origin = {-14, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-118, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-72, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add deltaH(k1 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-16, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant damHeight(k = Hdam)  annotation(
    Placement(visible = true, transformation(origin = {-68, -106}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = 1 / Tw, y_start = q0)  annotation(
    Placement(visible = true, transformation(origin = {26, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {96, -106}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant flowNoLoad(k = qnL)  annotation(
    Placement(visible = true, transformation(origin = {64, -118}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {146, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = At)  annotation(
    Placement(visible = true, transformation(origin = {188, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = D)  annotation(
    Placement(visible = true, transformation(origin = {-162, -168}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product2 annotation(
    Placement(visible = true, transformation(origin = {-106, -162}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {234, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {284, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {116, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(add3.y, firstOrder.u) annotation(
    Line(points = {{-107, 102}, {-80, 102}}, color = {0, 0, 127}));
  connect(firstOrder.y, P.u) annotation(
    Line(points = {{-57, 102}, {-49, 102}, {-49, 120}, {-30, 120}}, color = {0, 0, 127}));
  connect(rateLimit.y, limIntegrator.u) annotation(
    Line(points = {{87, 102}, {104, 102}}, color = {0, 0, 127}));
  connect(limIntegrator.y, droop.u) annotation(
    Line(points = {{127, 102}, {133, 102}, {133, 26}, {-2, 26}}, color = {0, 0, 127}));
  connect(droop.y, add3.u3) annotation(
    Line(points = {{-25, 26}, {-149, 26}, {-149, 94}, {-130, 94}}, color = {0, 0, 127}));
  connect(feedback.y, add3.u2) annotation(
    Line(points = {{-223, 102}, {-130, 102}}, color = {0, 0, 127}));
  connect(division.y, product.u1) annotation(
    Line(points = {{-107, -60}, {-99, -60}, {-99, -54}, {-84, -54}}, color = {0, 0, 127}));
  connect(division.y, product.u2) annotation(
    Line(points = {{-107, -60}, {-99, -60}, {-99, -66}, {-84, -66}}, color = {0, 0, 127}));
  connect(deltaH.y, integrator.u) annotation(
    Line(points = {{-5, -100}, {14, -100}}, color = {0, 0, 127}));
  connect(integrator.y, add1.u1) annotation(
    Line(points = {{37, -100}, {84, -100}}, color = {0, 0, 127}));
  connect(flowNoLoad.y, add1.u2) annotation(
    Line(points = {{75, -118}, {77, -118}, {77, -112}, {84, -112}}, color = {0, 0, 127}));
  connect(add1.y, product1.u2) annotation(
    Line(points = {{107, -106}, {134, -106}}, color = {0, 0, 127}));
  connect(product.y, product1.u1) annotation(
    Line(points = {{-61, -60}, {118, -60}, {118, -94}, {134, -94}}, color = {0, 0, 127}));
  connect(product1.y, gain1.u) annotation(
    Line(points = {{157, -100}, {176, -100}}, color = {0, 0, 127}));
  connect(product.y, deltaH.u1) annotation(
    Line(points = {{-61, -60}, {-50, -60}, {-50, -94}, {-28, -94}}, color = {0, 0, 127}));
  connect(damHeight.y, deltaH.u2) annotation(
    Line(points = {{-57, -106}, {-28, -106}}, color = {0, 0, 127}));
  connect(gain1.y, feedback1.u1) annotation(
    Line(points = {{199, -100}, {226, -100}}, color = {0, 0, 127}));
  connect(product2.y, feedback1.u2) annotation(
    Line(points = {{-95, -162}, {234, -162}, {234, -108}}, color = {0, 0, 127}));
  connect(feedback1.y, PmPu) annotation(
    Line(points = {{243, -100}, {284, -100}}, color = {0, 0, 127}));
  connect(feedback.y, gain2.u) annotation(
    Line(points = {{-223, 102}, {-208, 102}, {-208, -168}, {-174, -168}}, color = {0, 0, 127}));
  connect(gain2.y, product2.u2) annotation(
    Line(points = {{-151, -168}, {-118, -168}}, color = {0, 0, 127}));
  connect(firstOrderGate.y, product2.u1) annotation(
    Line(points = {{167, 102}, {182, 102}, {182, -14}, {-190, -14}, {-190, -150}, {-132, -150}, {-132, -156}, {-118, -156}}, color = {0, 0, 127}));
  connect(gain3.y, add3.u1) annotation(
    Line(points = {{-174, 140}, {-148, 140}, {-148, 110}, {-130, 110}}, color = {0, 0, 127}));
  connect(limIntegrator.y, firstOrderGate.u) annotation(
    Line(points = {{127, 102}, {144, 102}}, color = {0, 0, 127}));
  connect(PmRefPu, gain3.u) annotation(
    Line(points = {{-243, 139}, {-220, 139}, {-220, 140}, {-198, 140}}, color = {0, 0, 127}));
  connect(add.y, rateLimit.u) annotation(
    Line(points = {{51, 102}, {64, 102}}, color = {0, 0, 127}));
  connect(P.y, add.u1) annotation(
    Line(points = {{-7, 120}, {11, 120}, {11, 108}, {28, 108}}, color = {0, 0, 127}));
  connect(D_.y, add.u2) annotation(
    Line(points = {{-6, 70}, {10, 70}, {10, 96}, {28, 96}}, color = {0, 0, 127}));
  connect(firstOrder.y, D_.u) annotation(
    Line(points = {{-56, 102}, {-50, 102}, {-50, 70}, {-30, 70}}, color = {0, 0, 127}));
  connect(integrator.y, division.u1) annotation(
    Line(points = {{38, -100}, {46, -100}, {46, -122}, {-152, -122}, {-152, -54}, {-130, -54}}, color = {0, 0, 127}));
  connect(firstOrderGate.y, division.u2) annotation(
    Line(points = {{168, 102}, {182, 102}, {182, -14}, {-190, -14}, {-190, -66}, {-130, -66}}, color = {0, 0, 127}));
  connect(omegaPu, feedback.u2) annotation(
    Line(points = {{-232, 50}, {-232, 94}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, feedback.u1) annotation(
    Line(points = {{-261, 102}, {-240, 102}}, color = {0, 0, 127}));
  annotation(
    Diagram(graphics = {Text(origin = {-171, -60}, extent = {{17, 4}, {-17, -4}}, textString = "Gate (G)"), Text(origin = {-131, -117}, extent = {{17, 5}, {-17, -5}}, textString = "Flow (q)")}, coordinateSystem(extent = {{-220, 160}, {260, -180}})),
    Icon);
end HydroTurbineGovernor;
