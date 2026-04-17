within Dynawo.Electrical.PEIR.Plants.Average;

model DCBus "DC bus: Cdc * dVdc/dt = (Pdc_source - Pdc) / Vdc"
  // Parameters
  parameter Real Cdc "DC-link capacitance (coherent units)";
  parameter Real Vdc0 "Initial DC-link voltage";
  parameter Real Pdc_0 "Initial DC-link power";
  // Input: power from DC source into DC bus (profilo P_ref lato DC)
  Modelica.Blocks.Interfaces.RealInput Pdc_source (start=Pdc_0) "Power injected into DC bus (P_dc,source)" annotation(
    Placement(transformation(extent = {{-120, 20}, {-100, 40}}), iconTransformation(origin = {-10, 10}, extent = {{-110, 20}, {-90, 40}})));
  // Input: power from DC bus into VSC (≈ active power injected on AC side)
  Modelica.Blocks.Interfaces.RealInput Pdc (start=Pdc_0) "Power flowing from DC bus into VSC (P_dc ≈ P_conv)" annotation(
    Placement(transformation(extent = {{-120, -20}, {-100, 0}}), iconTransformation(origin = {-10, -10}, extent = {{-110, -20}, {-90, 0}})));
  // Output: DC-link voltage

  Modelica.Blocks.Interfaces.RealOutput Pref (start=Pdc_0) "Active power reference derived from DC side" annotation(
    Placement(transformation(extent = {{100, -20}, {120, 0}}), iconTransformation(origin = {10, -30}, extent = {{90, -20}, {110, 0}})));
protected
  Real Vdc(start = Vdc0, fixed = true);
equation
// DC-link dynamics
  Cdc*der(Vdc) = (Pdc_source - Pdc)/Vdc;
// For now Pref is simply equal to Pdc_source
// (could be extended later with Vdc-based limiting)
  Pref = Pdc_source;
  annotation(
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 2}, extent = {{-60, 20}, {60, -20}}, textString = "DC Bus")}),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end DCBus;