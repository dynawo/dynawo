within Dynawo.Electrical.PEIR.Plants.Average;

model trafoNoDyn
  "Static RL element in RI frame (pu), between left and right nodes (no dynamics)"

  // ────────────────────────────────────────────────────────────
  // Parameters (pu, base UNom, SNom)
  // ────────────────────────────────────────────────────────────
  parameter Types.PerUnit RPu
    "Series resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LPu
    "Series inductance in pu (base UNom, SNom)";

  // ────────────────────────────────────────────────────────────
  // Initial conditions (just for start values of I/O)
  // ────────────────────────────────────────────────────────────
  parameter Types.PerUnit IrRight0Pu
    "Initial real-axis current on right side in pu (generator convention)";
  parameter Types.PerUnit IiRight0Pu
    "Initial imag-axis current on right side in pu (generator convention)";

  parameter Types.PerUnit UrLeft0Pu
    "Initial real-axis voltage at left node in pu (base UNom)";
  parameter Types.PerUnit UiLeft0Pu
    "Initial imag-axis voltage at left node in pu (base UNom)";

  parameter Types.PerUnit UrRight0Pu
    "Initial real-axis voltage at right node in pu (base UNom)";
  parameter Types.PerUnit UiRight0Pu
    "Initial imag-axis voltage at right node in pu (base UNom)";

  parameter Types.PerUnit Omega0Pu
    "Initial electrical frequency in pu (base omegaNom)";

  // ────────────────────────────────────────────────────────────
  // Inputs
  // ────────────────────────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealInput urLeftPu(start = UrLeft0Pu)
    "Real-axis voltage at left node in pu (base UNom)" annotation(
    Placement(transformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}),
              iconTransformation(origin = {-120, 76}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealInput uiLeftPu(start = UiLeft0Pu)
    "Imag-axis voltage at left node in pu (base UNom)" annotation(
    Placement(transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}),
              iconTransformation(origin = {-120, 22}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealInput urRightPu(start = UrRight0Pu)
    "Real-axis voltage at right node in pu (base UNom)" annotation(
    Placement(transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}),
              iconTransformation(origin = {120, 40}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealInput uiRightPu(start = UiRight0Pu)
    "Imag-axis voltage at right node in pu (base UNom)" annotation(
    Placement(transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}),
              iconTransformation(origin = {120, -36}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealInput omegaPu(start = Omega0Pu)
    "Electrical frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}),
              iconTransformation(origin = {0, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));

  // ────────────────────────────────────────────────────────────
  // Outputs
  // ────────────────────────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealOutput irRightPu(start = IrRight0Pu)
    "Real-axis current towards right side in pu (generator convention)" annotation(
    Placement(transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}),
              iconTransformation(origin = {-118, -40}, extent = {{-18, -18}, {18, 18}})));

  Modelica.Blocks.Interfaces.RealOutput iiRightPu(start = IiRight0Pu)
    "Imag-axis current towards right side in pu (generator convention)" annotation(
    Placement(transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}),
              iconTransformation(origin = {-118, -80}, extent = {{-18, -18}, {18, 18}})));

protected
  // Tensione differenziale tra i due nodi
  Real du_re;
  Real du_im;

  // Impedenza complessa Z = R + j ω L (in pu)
  Real Z_re;
  Real Z_im;

  // Denominatore per l'ammettenza |Z|^2
  Real denom;

equation
  // Differenza di tensione (left - right)
  du_re = urLeftPu - urRightPu;
  du_im = uiLeftPu - uiRightPu;

  // Impedenza complessa in pu
  Z_re = RPu;
  Z_im = omegaPu * LPu;   // j ω L

  denom = Z_re^2 + Z_im^2;

  // i = (du_re + j du_im) / (Z_re + j Z_im)
  irRightPu = ( du_re * Z_re + du_im * Z_im ) / denom;
  iiRightPu = ( du_im * Z_re - du_re * Z_im ) / denom;

  annotation(
    preferredView = "text",
    Icon(
      graphics = {
        Rectangle(extent = {{-100, 100}, {100, -100}}),
        Text(origin = {-6, 20}, extent = {{-80, 20}, {80, -20}},
             textString = "RL\ntrafo (static)")
      },
      coordinateSystem(initialScale = 0.01)),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end trafoNoDyn;
