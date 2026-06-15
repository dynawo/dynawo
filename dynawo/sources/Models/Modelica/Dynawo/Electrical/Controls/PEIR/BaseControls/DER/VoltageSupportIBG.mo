within Dynawo.Electrical.Controls.PEIR.BaseControls.DER;
model VoltageSupportIBG "Reactive current injection model for IBG"
  parameter Types.CurrentModulePu IMaxPu "Maximum current of the injector in pu (base UNom, SNom)";
  parameter Real kRCA "Slope of reactive current decrease for high voltages in pu (base UNom, SNom)";
  parameter Real kRCI "Slope of reactive current increase for low voltages in pu (base UNom, SNom)";
  parameter Real m "Current injection just outside of lower deadband in pu (base IMaxPu)";
  parameter Real n "Current injection just outside of upper deadband in pu (base IMaxPu)";
  parameter Types.VoltageModulePu US1 "Lower voltage limit of deadband in pu (base UNom)";
  parameter Types.VoltageModulePu US2 "Higher voltage limit of deadband in pu (base UNom)";

  Modelica.Blocks.Interfaces.RealInput Um "Measured voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput IqSupPu "Additional reactive current for voltage support in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {108, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  if Um < US1 then
    IqSupPu = m * IMaxPu + kRCI * (US1 - Um);
  elseif Um < US2 then
    IqSupPu = 0;
  else
    IqSupPu = -n * IMaxPu + kRCA * (Um - US2);
  end if;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>The IBG unit can inject additional reactive current IqSupPu into the grid to support the terminal voltage. (See figure 2.9 in G. Chaspierre thesis 'Reduced-order modelling of active distribution networks for large-disturbance simulations')</body></html>"));
end VoltageSupportIBG;
