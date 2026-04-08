within Dynawo.Electrical.PEIR.Plants.Average;

model RLDynTrafo


  "Dynamic RL transformer in real/imag (RI) frame (pu), similar to DynRLTransformer in dq"
 

  // Parameters (pu, base UNom, SNom)
  parameter Dynawo.Types.PerUnit RPu 
    "Transformer resistance in pu (base UNom, SNom)";
  parameter Dynawo.Types.PerUnit LPu
    "Transformer inductance in pu (base UNom, SNom)";

  // Initial parameters (steady-state operating point)
  parameter Dynawo.Types.PerUnit IrPcc0Pu
    "Start value of real-axis current in the grid in pu (generator convention)";
  parameter Dynawo.Types.PerUnit IiPcc0Pu
    "Start value of imag-axis current in the grid in pu (generator convention)";
  parameter Dynawo.Types.PerUnit UrPcc0Pu
    "Start value of real-axis voltage at the PCC in pu (base UNom)";
  parameter Dynawo.Types.PerUnit UiPcc0Pu
    "Start value of imag-axis voltage at the PCC in pu (base UNom)";
  parameter Dynawo.Types.PerUnit Omega0Pu
    "Start value of converter's frequency in pu (base omegaNom)";

  // Steady-state filter-side voltages (computed from RL equations)
  parameter Dynawo.Types.PerUnit UrFilter0Pu
    "Start value of real-axis voltage at the filter side in pu (base UNom)";

 parameter Dynawo.Types.PerUnit UiFilter0Pu
    "Start value of imag-axis voltage at the filter side in pu (base UNom)";

  // ── Inputs ──────────────────────────────────────────────────
  // Voltages at filter side (node 1, from converter/filter)
  Modelica.Blocks.Interfaces.RealInput urFilterPu(start = UrFilter0Pu)
    "Real-axis voltage at the filter side in pu (base UNom)" annotation(
      Placement(transformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 76}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealInput uiFilterPu(start = UiFilter0Pu)
    "Imag-axis voltage at the filter side in pu (base UNom)" annotation(
      Placement(transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 22}, extent = {{-20, -20}, {20, 20}})));

  // Voltages at PCC side (node 2, towards grid)
  Modelica.Blocks.Interfaces.RealInput urPccPu(start = UrPcc0Pu)
    "Real-axis voltage at the PCC in pu (base UNom)" annotation(
      Placement(transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {120, 40}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealInput uiPccPu(start = UiPcc0Pu)
    "Imag-axis voltage at the PCC in pu (base UNom)" annotation(
      Placement(transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {120, -36}, extent = {{-20, -20}, {20, 20}})));

  // Frequency (pu)
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = Omega0Pu)
    "Converter's electrical frequency in pu (base omegaNom)" annotation(
      Placement(transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {0, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));

  // ── Outputs ─────────────────────────────────────────────────
  // Currents flowing into the grid at PCC (generator convention)
  Modelica.Blocks.Interfaces.RealOutput irPccPu(start = IrPcc0Pu)
    "Real-axis current in the grid in pu (base UNom, SNom, generator convention)" annotation(
      Placement(transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-118, -40}, extent = {{-18, -18}, {18, 18}})));

  Modelica.Blocks.Interfaces.RealOutput iiPccPu(start = IiPcc0Pu)
    "Imag-axis current in the grid in pu (base UNom, SNom, generator convention)" annotation(
      Placement(transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-118, -80}, extent = {{-18, -18}, {18, 18}})));

equation
  // Dynamics analogous to DynRLTransformer in dq:
  // LPu / omegaNom * der(i_re) = u_filter_re - RPu*i_re + omegaPu*LPu*i_im - u_pcc_re
  // LPu / omegaNom * der(i_im) = u_filter_im - RPu*i_im - omegaPu*LPu*i_re - u_pcc_im

  LPu / Dynawo.Electrical.SystemBase.omegaNom * der(irPccPu) =
    urFilterPu - RPu * irPccPu + omegaPu * LPu * iiPccPu - urPccPu;

  LPu / Dynawo.Electrical.SystemBase.omegaNom * der(iiPccPu) =
    uiFilterPu - RPu * iiPccPu - omegaPu * LPu * irPccPu - uiPccPu;

  annotation(
    preferredView="text",
    Icon(graphics = {
        Rectangle(extent = {{-100, 100}, {100, -100}}),
        Text(origin = {0, 60},
             extent = {{-80, 20}, {80, -20}},
             textString = "Trafo RL")
      },
      coordinateSystem(initialScale = 0.01)),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})));



end RLDynTrafo;