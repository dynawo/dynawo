within Dynawo.Electrical.PEIR.Plants.Average;

model current_loop

  Modelica.Blocks.Interfaces.RealInput i_d_ref annotation(
    Placement(
      transformation(origin = {-81, 89}, extent = {{-11, -11}, {11, 11}}),
      iconTransformation(origin = {-110, 34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput i_d_meas annotation(
    Placement(
      transformation(origin = {-131, 67}, extent = {{-9, -9}, {9, 9}}),
      iconTransformation(origin = {-110, 72}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback sum_node_id annotation(
    Placement(transformation(origin = {-48, 88}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.Average.pi_controller pi_controller_d(k_p = k_p_d, k_i = k_i_d, y_start = y_start_current_d) annotation(
    Placement(transformation(origin = {-14, 84}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add3 add_d(k3 = -1) annotation(
    Placement(transformation(origin = {70, 56}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput v_d annotation(
    Placement(
      transformation(origin = {26, 116}, extent = {{-12, -12}, {12, 12}}, rotation = -90),
      iconTransformation(origin = {32, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput omega_pll annotation(
    Placement(
      transformation(origin = {-120, 2}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {20, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput i_q_ref annotation(
    Placement(
      transformation(origin = {-123, -59}, extent = {{-9, -9}, {9, 9}}),
      iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput i_q_meas annotation(
    Placement(
      transformation(origin = {-130, -82}, extent = {{-8, -8}, {8, 8}}),
      iconTransformation(origin = {-110, -58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback sum_node_iq annotation(
    Placement(transformation(origin = {-58, -60}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.Average.pi_controller pi_controller_iq(k_p = k_p_q, k_i = k_i_q, y_start = y_start_current_q)  annotation(
    Placement(transformation(origin = {-24, -58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add3 add_q(k1 = -1, k2 = +1, k3 = +1) annotation(
    Placement(transformation(origin = {16, -62}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain L(k = L_g) annotation(
    Placement(transformation(origin = {-54, 2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput v_q annotation(
    Placement(
      transformation(origin = {-42, -74}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {-40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(transformation(origin = {-18, -32}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Product product_d annotation(
    Placement(transformation(origin = {-8, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput vm_d annotation(
    Placement(
      transformation(origin = {134, -20}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {110, 32}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput vm_q annotation(
    Placement(
      transformation(origin = {158, -40}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}})));
  parameter Real k_p_d;
  parameter Real k_i_d;
  parameter Real k_p_q;
  parameter Real k_i_q;
  parameter Real L_g;
  parameter Real y_start_current_d;
  parameter Real y_start_current_q;
  parameter Real y_start_outer_d;
  parameter Real y_start_outer_q;
equation
  connect(i_d_ref, sum_node_id.u1) annotation(
    Line(points = {{-81, 89}, {-73, 89}, {-73, 88}, {-56, 88}}, color = {0, 0, 127}));
  connect(sum_node_id.y, pi_controller_d.e) annotation(
    Line(points = {{-38, 88}, {-32, 88}, {-32, 84}, {-25, 84}}, color = {0, 0, 127}));
  connect(add_d.u2, pi_controller_d.y) annotation(
    Line(points = {{58, 56}, {15, 56}, {15, 84}, {-3, 84}}, color = {0, 0, 127}));
  connect(i_q_ref, sum_node_iq.u1) annotation(
    Line(points = {{-123, -59}, {-77, -59}, {-77, -60}, {-66, -60}}, color = {0, 0, 127}));
  connect(i_q_meas, sum_node_iq.u2) annotation(
    Line(points = {{-130, -82}, {-60, -82}, {-60, -68}, {-58, -68}}, color = {0, 0, 127}));
  connect(sum_node_iq.y, pi_controller_iq.e) annotation(
    Line(points = {{-48, -60}, {-41.5, -60}, {-41.5, -58}, {-35, -58}}, color = {0, 0, 127}));
  connect(pi_controller_iq.y, add_q.u2) annotation(
    Line(points = {{-13, -58}, {-4.5, -58}, {-4.5, -62}, {4, -62}}, color = {0, 0, 127}));
  connect(omega_pll, L.u) annotation(
    Line(points = {{-120, 2}, {-66, 2}}, color = {0, 0, 127}));
  connect(add_q.u3, v_q) annotation(
    Line(points = {{4, -70}, {4, -72}, {-42, -72}, {-42, -74}}, color = {0, 0, 127}));
  connect(L.y, product.u1) annotation(
    Line(points = {{-43, 2}, {-30, 2}, {-30, -26}}, color = {0, 0, 127}));
  connect(product_d.u2, L.y) annotation(
    Line(points = {{-20, 34}, {-26, 34}, {-26, 2}, {-43, 2}}, color = {0, 0, 127}));
  connect(product_d.u1, i_d_meas) annotation(
    Line(points = {{-20, 46}, {-60, 46}, {-60, 67}, {-131, 67}}, color = {0, 0, 127}));
  connect(product.u2, i_q_meas) annotation(
    Line(points = {{-30, -38}, {-70, -38}, {-70, -82}, {-130, -82}}, color = {0, 0, 127}));
  connect(add_d.u3, product.y) annotation(
    Line(points = {{58, 48}, {58, -30}, {-6, -30}, {-6, -32}}, color = {0, 0, 127}));
  connect(product_d.y, add_q.u1) annotation(
    Line(points = {{4, 40}, {4, -54}}, color = {0, 0, 127}));
  connect(add_d.u1, v_d) annotation(
    Line(points = {{58, 64}, {58, 95}, {26, 95}, {26, 116}}, color = {0, 0, 127}));
  connect(add_q.y, vm_q) annotation(
    Line(points = {{28, -62}, {124, -62}, {124, -40}, {158, -40}}, color = {0, 0, 127}));
  connect(add_d.y, vm_d) annotation(
    Line(points = {{81, 56}, {122, 56}, {122, -20}, {134, -20}}, color = {0, 0, 127}));
  connect(sum_node_id.u2, i_d_meas) annotation(
    Line(points = {{-48, 80}, {-118, 80}, {-118, 67}, {-131, 67}}, color = {0, 0, 127}));
annotation(
  uses(
    Modelica(version = "3.2.3"),
    Dynawo(version = "1.8.0")
  ),

  Icon(
    coordinateSystem(extent = {{-100, -100}, {100, 100}}),
    graphics = {
      // White box with black border
      Rectangle(
        extent = {{-100, 100}, {100, -100}},
        lineColor = {0, 0, 0},
        fillColor = {255, 255, 255},
        fillPattern = FillPattern.Solid
      ),
      // Text in the middle
      Text(
        origin = {0, 0},
        extent = {{-80, 20}, {80, -20}},
        textString = "current loop"
      )
    }
  ),

  Diagram(
    // large working area inside the block
    coordinateSystem(extent = {{-200, -200}, {200, 200}})
  )
);

end current_loop;