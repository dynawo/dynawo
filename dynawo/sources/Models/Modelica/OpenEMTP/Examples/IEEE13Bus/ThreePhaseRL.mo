within OpenEMTP.Examples.IEEE13Bus;
model ThreePhaseRL
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug positivePlug1(m = 3)  annotation(
    Placement(visible = true, transformation(origin = {-94, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-98, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_p1(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {-56, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_p2(k = 2)  annotation(
    Placement(visible = true, transformation(origin = {-56, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_p3(k = 3)  annotation(
    Placement(visible = true, transformation(origin = {-56, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor resistor1(R = 0)  annotation(
    Placement(visible = true, transformation(origin = {-14, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Inductor inductor1(L = 0.786710020900058)  annotation(
    Placement(visible = true, transformation(origin = {26, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground1 annotation(
    Placement(visible = true, transformation(origin = {84, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Inductor inductor2(L = 0.200502543602494)  annotation(
    Placement(visible = true, transformation(origin = {28, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor resistor2(R = 131.283862068966000)  annotation(
    Placement(visible = true, transformation(origin = {-12, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Inductor inductor3(L = 0.113635414584439)  annotation(
    Placement(visible = true, transformation(origin = {26, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor resistor3(R = 73.709212035166300)  annotation(
    Placement(visible = true, transformation(origin = {-14, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(plugToPin_p3.pin_p, resistor3.p) annotation(
    Line(points = {{-54, -80}, {-24, -80}, {-24, -80}, {-24, -80}}, color = {0, 0, 255}));
  connect(plugToPin_p2.pin_p, resistor2.p) annotation(
    Line(points = {{-54, 0}, {-22, 0}, {-22, 0}, {-22, 0}}, color = {0, 0, 255}));
  connect(plugToPin_p1.pin_p, resistor1.p) annotation(
    Line(points = {{-54, 80}, {-24, 80}, {-24, 80}, {-24, 80}}, color = {0, 0, 255}));
  connect(resistor3.n, inductor3.p) annotation(
    Line(points = {{-4, -80}, {16, -80}, {16, -80}, {16, -80}}, color = {0, 0, 255}));
  connect(resistor2.n, inductor2.p) annotation(
    Line(points = {{-2, 0}, {18, 0}, {18, 0}, {18, 0}}, color = {0, 0, 255}));
  connect(resistor1.n, inductor1.p) annotation(
    Line(points = {{-4, 80}, {16, 80}, {16, 80}, {16, 80}}, color = {0, 0, 255}));
  connect(inductor2.n, ground1.p) annotation(
    Line(points = {{38, 0}, {82, 0}, {82, 0}, {84, 0}, {84, 0}}, color = {0, 0, 255}));
  connect(inductor3.n, ground1.p) annotation(
    Line(points = {{36, -80}, {60, -80}, {60, 0}, {84, 0}, {84, 0}}, color = {0, 0, 255}));
  connect(inductor1.n, ground1.p) annotation(
    Line(points = {{36, 80}, {60, 80}, {60, 0}, {84, 0}, {84, 0}}, color = {0, 0, 255}));
  connect(plugToPin_p3.plug_p, positivePlug1) annotation(
    Line(points = {{-58, -80}, {-94, -80}, {-94, 0}, {-94, 0}}, color = {0, 0, 255}));
  connect(plugToPin_p2.plug_p, positivePlug1) annotation(
    Line(points = {{-58, 0}, {-94, 0}, {-94, 0}, {-94, 0}}, color = {0, 0, 255}));
  connect(plugToPin_p1.plug_p, positivePlug1) annotation(
    Line(points = {{-58, 80}, {-94, 80}, {-94, 0}, {-94, 0}}, color = {0, 0, 255}));

annotation(
    uses(Modelica(version = "3.2.2")),
    Icon(graphics = {Line(origin = {-40, 59.01}, points = {{-30, 0.99136}, {-20, 20.9914}, {0, -21.0086}, {20, 20.9914}, {30, 0.99136}, {30, 0.99136}}, color = {0, 0, 255}), Line(origin = {10, 67.95}, points = {{-10, -7.94721}, {-10, -1.94721}, {-8, 2.05279}, {-4, 6.05279}, {0, 8.05279}, {4, 6.05279}, {8, 2.05279}, {10, -1.94721}, {10, -7.94721}, {10, -7.94721}}, color = {0, 0, 255}), Line(origin = {30.6, 68.54}, points = {{-10, -7.94721}, {-10, -1.94721}, {-8, 2.05279}, {-4, 6.05279}, {0, 8.05279}, {4, 6.05279}, {8, 2.05279}, {10, -1.94721}, {10, -7.94721}, {10, -7.94721}}, color = {0, 0, 255}), Line(origin = {50.16, 68.09}, points = {{-10, -7.94721}, {-10, -1.94721}, {-8, 2.05279}, {-4, 6.05279}, {0, 8.05279}, {4, 6.05279}, {8, 2.05279}, {10, -1.94721}, {10, -7.94721}, {10, -7.94721}}, color = {0, 0, 255}), Line(origin = {-5, 60}, points = {{5, 0}, {-5, 0}, {-5, 0}}, color = {0, 0, 255}), Line(origin = {-75, 60}, points = {{5, 0}, {-5, 0}, {-5, 0}}, color = {0, 0, 255}), Line(origin = {65.73, 59.39}, points = {{5, 0}, {-5, 0}, {-5, 0}}, color = {0, 0, 255}), Line(origin = {72, 0}, points = {{0, 60}, {0, -60}}, color = {0, 0, 255}), Line(origin = {-79, 1}, points = {{-1, 59}, {-1, -59}, {1, -59}}, color = {0, 0, 255}), Line(origin = {-87, 0}, points = {{7, 0}, {-1, 0}, {-7, 0}}, color = {0, 0, 255}), Line(origin = {65.9771, -0.476596}, points = {{5, 0}, {-5, 0}, {-5, 0}}, color = {0, 0, 255}), Line(origin = {50.7417, 8.2234}, points = {{-10, -7.94721}, {-10, -1.94721}, {-8, 2.05279}, {-4, 6.05279}, {0, 8.05279}, {4, 6.05279}, {8, 2.05279}, {10, -1.94721}, {10, -7.94721}, {10, -7.94721}}, color = {0, 0, 255}), Line(origin = {31.1817, 8.6734}, points = {{-10, -7.94721}, {-10, -1.94721}, {-8, 2.05279}, {-4, 6.05279}, {0, 8.05279}, {4, 6.05279}, {8, 2.05279}, {10, -1.94721}, {10, -7.94721}, {10, -7.94721}}, color = {0, 0, 255}), Line(origin = {10.5817, 8.0834}, points = {{-10, -7.94721}, {-10, -1.94721}, {-8, 2.05279}, {-4, 6.05279}, {0, 8.05279}, {4, 6.05279}, {8, 2.05279}, {10, -1.94721}, {10, -7.94721}, {10, -7.94721}}, color = {0, 0, 255}), Line(origin = {-4.4183, 0.133424}, points = {{5, 0}, {-5, 0}, {-5, 0}}, color = {0, 0, 255}), Line(origin = {-39.4183, -0.856598}, points = {{-30, 0.99136}, {-20, 20.9914}, {0, -21.0086}, {20, 20.9914}, {30, 0.99136}, {30, 0.99136}}, color = {0, 0, 255}), Line(origin = {-74.4183, 0.133424}, points = {{5, 0}, {-5, 0}, {-5, 0}}, color = {0, 0, 255}), Line(origin = {50.7417, -49.7766}, points = {{-10, -7.94721}, {-10, -1.94721}, {-8, 2.05279}, {-4, 6.05279}, {0, 8.05279}, {4, 6.05279}, {8, 2.05279}, {10, -1.94721}, {10, -7.94721}, {10, -7.94721}}, color = {0, 0, 255}), Line(origin = {65.9771, -58.4766}, points = {{5, 0}, {-5, 0}, {-5, 0}}, color = {0, 0, 255}), Line(origin = {31.1817, -49.3266}, points = {{-10, -7.94721}, {-10, -1.94721}, {-8, 2.05279}, {-4, 6.05279}, {0, 8.05279}, {4, 6.05279}, {8, 2.05279}, {10, -1.94721}, {10, -7.94721}, {10, -7.94721}}, color = {0, 0, 255}), Line(origin = {10.5817, -49.9166}, points = {{-10, -7.94721}, {-10, -1.94721}, {-8, 2.05279}, {-4, 6.05279}, {0, 8.05279}, {4, 6.05279}, {8, 2.05279}, {10, -1.94721}, {10, -7.94721}, {10, -7.94721}}, color = {0, 0, 255}), Line(origin = {-4.4183, -57.8666}, points = {{5, 0}, {-5, 0}, {-5, 0}}, color = {0, 0, 255}), Line(origin = {-39.4183, -58.8566}, points = {{-30, 0.99136}, {-20, 20.9914}, {0, -21.0086}, {20, 20.9914}, {30, 0.99136}, {30, 0.99136}}, color = {0, 0, 255}), Line(origin = {-74.4183, -57.8666}, points = {{5, 0}, {-5, 0}, {-5, 0}}, color = {0, 0, 255})}, coordinateSystem(initialScale = 0.1)));end ThreePhaseRL;
