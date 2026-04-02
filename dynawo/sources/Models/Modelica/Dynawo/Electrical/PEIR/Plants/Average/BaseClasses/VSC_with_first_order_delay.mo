within Dynawo.Electrical.PEIR.Plants.Average.BaseClasses;


model VSC_with_first_order_delay "VSC in RI with first-order lag"
  /**
         * Author Gaia Bergamaschi
         * Voltage-source converter (VSC) interface in RI coordinates with a
         * first-order lag filter.
         *
         * This block applies a first-order low-pass filter to the converter
         * voltage reference in real/imag (R/I) coordinates. It is used to
         * emulate the finite dynamic response / modulation delay of the
         * average VSC model.
         *
         * For each axis (real and imaginary), the dynamics are:
         *
         *   G(s) = 1 / (1 + s·tVSC)
         *
         * i.e. a simple first-order lag with time constant tVSC, rather than
         * an all-pass (Padé) delay approximation. A commented-out Padé
         * implementation is kept below for reference / future use.
         *
         * Inputs (per-unit):
         *   - uReConvRefPu : real-axis converter voltage reference.
         *   - uImConvRefPu : imaginary-axis converter voltage reference.
         *
         * Outputs (per-unit):
         *   - uReConvPu    : filtered real-axis converter voltage.
         *   - uImConvPu    : filtered imaginary-axis converter voltage.
         *
         * The initial states of the first-order filters are set so that the
         * outputs match the specified initial converter voltage
         * (UreConv0Pu, UimConv0Pu).
         */
  // ── Parameters ───────────────────────────────────────────────
  parameter Real tVSC "VSC time response / filter time constant (s)";
  parameter Real UreConv0Pu "Initial real-axis converter voltage (pu)";
  parameter Real UimConv0Pu "Initial imag-axis converter voltage (pu)";
  // ── Inputs (R/I voltage references) ──────────────────────────
  Modelica.Blocks.Interfaces.RealInput uReConvRefPu(start = UreConv0Pu) "Converter real-axis voltage reference (pu)" annotation(
    Placement(transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-114, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput uImConvRefPu(start = UimConv0Pu) "Converter imag-axis voltage reference (pu)" annotation(
    Placement(transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-114, -20}, extent = {{-10, -10}, {10, 10}})));
  // ── Outputs (filtered R/I voltages) ──────────────────────────
  Modelica.Blocks.Interfaces.RealOutput uReConvPu(start = UreConv0Pu) "Converter real-axis voltage (pu)" annotation(
    Placement(transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {114, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput uImConvPu(start = UimConv0Pu) "Converter imag-axis voltage (pu)" annotation(
    Placement(transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {114, -20}, extent = {{-10, -10}, {10, 10}})));
  // ── First-order lag filter for the VSC ───────────────────────
  // G(s) = 1 / (1 + s·tVSC)
  /* Alternative: first-order Padé approximation of a pure delay e^(−s·tVSC)
            Modelica.Blocks.Continuous.TransferFunction pade_re(
              b       = {1, -tVSC/2},
              a       = {1,  tVSC/2},
              x_start = {UreConv0Pu});

            Modelica.Blocks.Continuous.TransferFunction pade_im(
              b       = {1, -tVSC/2},
              a       = {1,  tVSC/2},
              x_start = {UimConv0Pu});*/
  Modelica.Blocks.Continuous.FirstOrder re(T = tVSC, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = UreConv0Pu) annotation(
    Placement(transformation(origin = {-40, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder im(T = tVSC, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = UimConv0Pu) annotation(
    Placement(transformation(origin = {-38, -20}, extent = {{-10, -10}, {10, 10}})));
equation

  connect(uReConvRefPu, re.u) annotation(
    Line(points = {{-110, 20}, {-52, 20}}, color = {0, 0, 127}));
  connect(re.y, uReConvPu) annotation(
    Line(points = {{-28, 20}, {110, 20}}, color = {0, 0, 127}));
  connect(uImConvRefPu, im.u) annotation(
    Line(points = {{-110, -20}, {-50, -20}}, color = {0, 0, 127}));
  connect(im.y, uImConvPu) annotation(
    Line(points = {{-26, -20}, {110, -20}}, color = {0, 0, 127}));
  annotation(
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-60, 30}, {60, -30}}, textString = "VSC RI", lineColor = {0, 0, 0})}));
end VSC_with_first_order_delay;
