within Dynawo.Electrical.PEIR.Plants.Average;

model RLDynTrafo
  "Dynamic RL element in RI frame (pu), between left and right nodes"

  // ────────────────────────────────────────────────────────────
  // Parameters (pu, base UNom, SNom)
  // ────────────────────────────────────────────────────────────
  parameter Dynawo.Types.PerUnit RPu 
    "Series resistance in pu (base UNom, SNom)";
  parameter Dynawo.Types.PerUnit LPu
    "Series inductance in pu (base UNom, SNom)";

  // ────────────────────────────────────────────────────────────
  // Initial conditions (steady-state operating point)
  // ────────────────────────────────────────────────────────────
  // Currents flowing from left to right (generator convention)
  parameter Dynawo.Types.PerUnit IrRight0Pu
    "Initial real-axis current on right side in pu (generator convention)";
  parameter Dynawo.Types.PerUnit IiRight0Pu
    "Initial imag-axis current on right side in pu (generator convention)";

  // Voltages at left node
  parameter Dynawo.Types.PerUnit UrLeft0Pu
    "Initial real-axis voltage at left node in pu (base UNom)";
  parameter Dynawo.Types.PerUnit UiLeft0Pu
    "Initial imag-axis voltage at left node in pu (base UNom)";

  // Voltages at right node
  parameter Dynawo.Types.PerUnit UrRight0Pu
    "Initial real-axis voltage at right node in pu (base UNom)";
  parameter Dynawo.Types.PerUnit UiRight0Pu
    "Initial imag-axis voltage at right node in pu (base UNom)";

  // Electrical frequency (pu)
  parameter Dynawo.Types.PerUnit Omega0Pu
    "Initial electrical frequency in pu (base omegaNom)";

  // ────────────────────────────────────────────────────────────
  // Inputs
  // ────────────────────────────────────────────────────────────

  // Voltages at left side (e.g. converter/filter side)
  Modelica.Blocks.Interfaces.RealInput urLeftPu(start = UrLeft0Pu)
    "Real-axis voltage at left node in pu (base UNom)" annotation(
      Placement(transformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}),
                iconTransformation(origin = {-120, 76}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealInput uiLeftPu(start = UiLeft0Pu)
    "Imag-axis voltage at left node in pu (base UNom)" annotation(
      Placement(transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}),
                iconTransformation(origin = {-120, 22}, extent = {{-20, -20}, {20, 20}})));

  // Voltages at right side (e.g. PCC / grid side)
  Modelica.Blocks.Interfaces.RealInput urRightPu(start = UrRight0Pu)
    "Real-axis voltage at right node in pu (base UNom)" annotation(
      Placement(transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}),
                iconTransformation(origin = {120, 40}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealInput uiRightPu(start = UiRight0Pu)
    "Imag-axis voltage at right node in pu (base UNom)" annotation(
      Placement(transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}),
                iconTransformation(origin = {120, -36}, extent = {{-20, -20}, {20, 20}})));

  // Frequency (pu)
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = Omega0Pu)
    "Electrical frequency in pu (base omegaNom)" annotation(
      Placement(transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}),
                iconTransformation(origin = {0, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));

  // ────────────────────────────────────────────────────────────
  // Outputs
  // ────────────────────────────────────────────────────────────

  // Currents flowing into the right side (from left to right, generator convention)
  Modelica.Blocks.Interfaces.RealOutput irRightPu(start = IrRight0Pu)
    "Real-axis current towards right side in pu (base UNom, SNom, generator convention)" annotation(
      Placement(transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}),
                iconTransformation(origin = {-118, -40}, extent = {{-18, -18}, {18, 18}})));

  Modelica.Blocks.Interfaces.RealOutput iiRightPu(start = IiRight0Pu)
    "Imag-axis current towards right side in pu (base UNom, SNom, generator convention)" annotation(
      Placement(transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}),
                iconTransformation(origin = {-118, -80}, extent = {{-18, -18}, {18, 18}})));

equation
  // Dynamics analogous to DynRLTransformer in dq:
  // LPu / omegaNom * der(i_re) = u_left_re  - RPu*i_re + omegaPu*LPu*i_im - u_right_re
  // LPu / omegaNom * der(i_im) = u_left_im  - RPu*i_im - omegaPu*LPu*i_re - u_right_im

  LPu / Dynawo.Electrical.SystemBase.omegaNom * der(irRightPu) =
    urLeftPu - RPu * irRightPu + omegaPu * LPu * iiRightPu - urRightPu;

  LPu / Dynawo.Electrical.SystemBase.omegaNom * der(iiRightPu) =
    uiLeftPu - RPu * iiRightPu - omegaPu * LPu * irRightPu - uiRightPu;

  annotation(
    preferredView = "text",
    Icon(graphics = {
        Rectangle(extent = {{-100, 100}, {100, -100}}),
        Text(origin = {-6, 20},
             extent = {{-80, 20}, {80, -20}},
             textString = "RL 
trafo")
      },
      coordinateSystem(initialScale = 0.01)),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end RLDynTrafo;