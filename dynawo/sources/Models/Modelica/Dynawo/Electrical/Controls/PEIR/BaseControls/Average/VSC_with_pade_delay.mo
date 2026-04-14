within Dynawo.Electrical.Controls.PEIR.BaseControls.Average;

model VSC_with_pade_delay
  "VSC in RI with Pade delay"

  // Parameters
  parameter Real tVSC        "VSC time response / delay (s)";
  parameter Real UreConv0Pu  "Initial real-axis converter voltage (pu)";
  parameter Real UimConv0Pu  "Initial imag-axis converter voltage (pu)";

  // Ingressi in RI
  Modelica.Blocks.Interfaces.RealInput uReConvRefPu(start = UreConv0Pu)
    "Converter real-axis voltage reference (pu)" annotation(
      Placement(transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}),
                iconTransformation(origin = {-114, 40}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealInput uImConvRefPu(start = UimConv0Pu)
    "Converter imag-axis voltage reference (pu)" annotation(
      Placement(transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}),
                iconTransformation(origin = {-114, -20}, extent = {{-10, -10}, {10, 10}})));

  // Uscite in RI
  Modelica.Blocks.Interfaces.RealOutput uReConvPu(start = UreConv0Pu)
    "Converter real-axis voltage (pu)" annotation(
      Placement(transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}),
                iconTransformation(origin = {114, 40}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealOutput uImConvPu(start = UimConv0Pu)
    "Converter imag-axis voltage (pu)" annotation(
      Placement(transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}),
                iconTransformation(origin = {114, -20}, extent = {{-10, -10}, {10, 10}})));

  // Padé 1° ordine per il ritardo del VSC
  // e^{-s tVSC} ≈ (1 - s tVSC/2) / (1 + s tVSC/2)
  Modelica.Blocks.Continuous.TransferFunction pade_re(
    b = {1, -tVSC/2},
    a = {1,  tVSC/2},
    x_start = {UreConv0Pu});

  Modelica.Blocks.Continuous.TransferFunction pade_im(
    b = {1, -tVSC/2},
    a = {1,  tVSC/2},
    x_start = {UimConv0Pu});

equation
  // Componente reale
  connect(uReConvRefPu, pade_re.u);
  connect(pade_re.y,    uReConvPu);

  // Componente immaginaria
  connect(uImConvRefPu, pade_im.u);
  connect(pade_im.y,    uImConvPu);

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
          textString = "VSC RI",
          lineColor = {0,0,0})
      }));

end VSC_with_pade_delay;
