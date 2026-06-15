within Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard;
model Pss2a "IEEE power system stabilizer type 2A"
  extends Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.BaseClasses.BasePss2;

equation
  connect(transferFunction1.y, limiter2.u) annotation(
    Line(points = {{162, 0}, {258, 0}}, color = {0, 0, 127}));
  connect(limiter2.y, VPssPu) annotation(
    Line(points = {{282, 0}, {300, 0}, {300, -40}, {370, -40}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end Pss2a;
