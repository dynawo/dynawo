within Dynawo.Electrical.Controls.PEIR.BaseControls.Average;

model VSC_with_pade_delay

  "VSC in dq with Pade delay"

  // Parameters
  parameter Real tVSC      "VSC time response / delay (s)";
  parameter Real UdConv0Pu "Initial d-axis converter voltage (pu)";
  parameter Real UqConv0Pu "Initial q-axis converter voltage (pu)";

  // Ingressi in dq
  Modelica.Blocks.Interfaces.RealInput udConvRefPu(start = UdConv0Pu)
    "Converter d-axis voltage reference (pu)" annotation(
      Placement(transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-114, 40}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealInput uqConvRefPu(start = UqConv0Pu)
    "Converter q-axis voltage reference (pu)" annotation(
      Placement(transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-114, -20}, extent = {{-10, -10}, {10, 10}})));

  // Uscite in dq
  Modelica.Blocks.Interfaces.RealOutput ureConvPu(start = UdConv0Pu)
    "Converter d-axis voltage (pu)" annotation(
      Placement(transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {114, 40}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealOutput uimConvPu(start = UqConv0Pu)
    "Converter q-axis voltage (pu)" annotation(
      Placement(transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {114, -20}, extent = {{-10, -10}, {10, 10}})));
  
  // Padé 1° order for VSC Delay
  // e^{-s tVSC} ≈ (1 - s tVSC/2) / (1 + s tVSC/2)
  Modelica.Blocks.Continuous.TransferFunction pade_d(
    b = {1, -tVSC/2},
    a = {1,  tVSC/2},
    x_start = {UdConv0Pu});

  Modelica.Blocks.Continuous.TransferFunction pade_q(
    b = {1, -tVSC/2},
    a = {1,  tVSC/2},
    x_start = {UqConv0Pu});

equation
  // d-axis
  connect(udConvRefPu, pade_d.u);
  connect(pade_d.y,    ureConvPu);

  // q-axis
  connect(uqConvRefPu, pade_q.u);
  connect(pade_q.y,    uimConvPu);

  annotation(
    Icon(
      coordinateSystem(extent = {{-100,-100},{100,100}}),
      graphics = {
        Rectangle(
          extent = {{-100,100},{100,-100}},
          lineColor = {0,0,0},
          fillColor = {255,255,255},
          fillPattern = FillPattern.Solid),
        Text(
          extent = {{-60,30},{60,-30}},
          textString = "VSC",
          lineColor = {0,0,0})
      }));

end VSC_with_pade_delay;