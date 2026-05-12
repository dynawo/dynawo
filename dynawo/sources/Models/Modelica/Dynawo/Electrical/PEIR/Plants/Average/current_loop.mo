within Dynawo.Electrical.PEIR.Plants.Average;

model current_loop

  Modelica.Blocks.Interfaces.RealInput i_d_ref (start=id_ref_0) annotation(
    Placement(
      transformation(origin = {-211, 99}, extent = {{-11, -11}, {11, 11}}),
      iconTransformation(origin = {-110, 34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput i_d_meas (start=id_meas_0)annotation(
    Placement(
      transformation(origin = {-211, 79}, extent = {{-9, -9}, {9, 9}}),
      iconTransformation(origin = {-110, 72}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback sum_node_id annotation(
    Placement(transformation(origin = {-48, 88}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.Average.pi_controller pi_controller_d(k_p = k_p_d, k_i = k_i_d, y_start = y_start_current_d) annotation(
    Placement(transformation(origin = {-14, 88}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add3 add_d(k3 = -1, k1 = voltagefeedforwardflag) annotation(
    Placement(transformation(origin = {72, 56}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput v_d (start=vd_0) annotation(
    Placement(
      transformation(origin = {60, 212}, extent = {{-12, -12}, {12, 12}}, rotation = -90),
      iconTransformation(origin = {60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput omega_pll (start=Omega0Pu) annotation(
    Placement(
      transformation(origin = {-208, 0}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {20, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput i_q_ref (start=iq_ref_0)annotation(
    Placement(
      transformation(origin = {-207, -61}, extent = {{-9, -9}, {9, 9}}),
      iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput i_q_meas (start=iq_meas_0)annotation(
    Placement(
      transformation(origin = {-206, -80}, extent = {{-8, -8}, {8, 8}}),
      iconTransformation(origin = {-110, -58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback sum_node_iq annotation(
    Placement(transformation(origin = {-58, -60}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.Average.pi_controller pi_controller_iq(k_p = k_p_q, k_i = k_i_q, y_start = y_start_current_q)  annotation(
    Placement(transformation(origin = {-26, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add3 add_q(k1 = 1, k2 = +1, k3 = voltagefeedforwardflag) annotation(
    Placement(transformation(origin = {18, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain L(k = L_g) annotation(
    Placement(transformation(origin = {-52, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput v_q (start=vq_0)annotation(
    Placement(
      transformation(origin = {0, -212}, extent = {{-10, -10}, {10, 10}}, rotation = 90),
      iconTransformation(origin = {-40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(transformation(origin = {-18, -32}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Product product_d annotation(
    Placement(transformation(origin = {-10, 48}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput vm_d (start=vmd_0)annotation(
    Placement(
      transformation(origin = {210, 56}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {110, 32}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput vm_q (start=vmq_0) annotation(
    Placement(
      transformation(origin = {210, -60}, extent = {{-10, -10}, {10, 10}}),
      iconTransformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}})));
  parameter Real k_p_d;
  parameter Real k_i_d;
  parameter Real k_p_q;
  parameter Real k_i_q;
  parameter Real L_g;
  parameter Real id_ref_0     "Initial d-axis current reference (pu)";
  parameter Real id_meas_0    "Initial d-axis measured current (pu)";
  parameter Real iq_ref_0     "Initial q-axis current reference (pu)";
  parameter Real iq_meas_0    "Initial q-axis measured current (pu)";

  parameter Real vd_0         "Initial d-axis converter voltage (pu)";
  parameter Real vq_0         "Initial q-axis converter voltage (pu)";

  parameter Real Omega0Pu     "Initial per-unit electrical frequency (pu)";

  parameter Real vmd_0        "Initial modulation voltage reference (pu)";
  parameter Real vmq_0        "Initial modulation voltage reference (pu)";

  parameter Real voltagefeedforwardflag
  "If 0, no voltage feed-forward is applied in the current loop; if 1, it is applied";
  
 final parameter Real y_start_current_d = vmd_0
                    - voltagefeedforwardflag*vd_0
                    + Omega0Pu*L_g*iq_meas_0;

 final parameter Real y_start_current_q = vmq_0
                    + Omega0Pu*L_g*id_meas_0
                    - voltagefeedforwardflag*vq_0;


equation
  connect(i_d_ref, sum_node_id.u1) annotation(
    Line(points = {{-211, 99}, {-55, 99}, {-55, 88}, {-56, 88}}, color = {0, 0, 127}));
  connect(sum_node_id.y, pi_controller_d.e) annotation(
    Line(points = {{-39, 88}, {-25, 88}}, color = {0, 0, 127}));
  connect(add_d.u2, pi_controller_d.y) annotation(
    Line(points = {{60, 56}, {15, 56}, {15, 88}, {-3, 88}}, color = {0, 0, 127}));
  connect(i_q_ref, sum_node_iq.u1) annotation(
    Line(points = {{-207, -61}, {-203, -61}, {-203, -60}, {-66, -60}}, color = {0, 0, 127}));
  connect(i_q_meas, sum_node_iq.u2) annotation(
    Line(points = {{-206, -80}, {-58, -80}, {-58, -68}}, color = {0, 0, 127}));
  connect(sum_node_iq.y, pi_controller_iq.e) annotation(
    Line(points = {{-49, -60}, {-37, -60}}, color = {0, 0, 127}));
  connect(pi_controller_iq.y, add_q.u2) annotation(
    Line(points = {{-15, -60}, {6, -60}}, color = {0, 0, 127}));
  connect(omega_pll, L.u) annotation(
    Line(points = {{-208, 0}, {-64, 0}}, color = {0, 0, 127}));
  connect(add_q.u3, v_q) annotation(
    Line(points = {{6, -68}, {6, -68.125}, {0, -68.125}, {0, -212}}, color = {0, 0, 127}));
  connect(product_d.u2, L.y) annotation(
    Line(points = {{-22, 42}, {-26, 42}, {-26, 0}, {-41, 0}}, color = {0, 0, 127}));
  connect(add_d.u1, v_d) annotation(
    Line(points = {{60, 64}, {60, 212}}, color = {0, 0, 127}));
  connect(add_q.y, vm_q) annotation(
    Line(points = {{29, -60}, {210, -60}}, color = {0, 0, 127}));
  connect(add_d.y, vm_d) annotation(
    Line(points = {{83, 56}, {210, 56}}, color = {0, 0, 127}));
  connect(sum_node_id.u2, i_d_meas) annotation(
    Line(points = {{-48, 80}, {-210, 80}, {-210, 79}, {-211, 79}}, color = {0, 0, 127}));
  connect(product.u1, L.y) annotation(
    Line(points = {{-30, -26}, {-36, -26}, {-36, 0}, {-41, 0}}, color = {0, 0, 127}));
  connect(product_d.y, add_d.u3) annotation(
    Line(points = {{1, 48}, {60, 48}}, color = {0, 0, 127}));
  connect(product.y, add_q.u1) annotation(
    Line(points = {{-6, -32}, {6, -32}, {6, -52}}, color = {0, 0, 127}));
  connect(product.u2, i_d_meas) annotation(
    Line(points = {{-30, -38}, {-210, -38}, {-210, 80}}, color = {87, 227, 137}, pattern = LinePattern.Dash, thickness = 0.5));
  connect(product_d.u1, i_q_meas) annotation(
    Line(points = {{-22, 54}, {-98, 54}, {-98, -79.25}, {-206, -79.25}, {-206, -80}}, color = {229, 165, 10}, pattern = LinePattern.Dash, thickness = 0.5));

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