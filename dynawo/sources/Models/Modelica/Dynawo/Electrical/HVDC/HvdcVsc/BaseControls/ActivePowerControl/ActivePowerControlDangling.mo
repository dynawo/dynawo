within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.ActivePowerControl;
model ActivePowerControlDangling "Active power control for the HVDC VSC model with terminal2 connected to a switched-off bus (P control on terminal 1)"
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.ActivePowerControl.BaseActivePowerControl;

  Modelica.Blocks.Sources.Constant zero1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-50, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(zero1.y, add1.u1) annotation(
    Line(points = {{-38, 80}, {20, 80}, {20, 6}, {38, 6}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end ActivePowerControlDangling;
