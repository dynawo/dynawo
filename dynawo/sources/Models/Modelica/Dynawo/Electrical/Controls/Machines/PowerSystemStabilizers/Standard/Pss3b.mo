within Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard;
model Pss3b "IEEE power system stabilizer type 3B"
  extends Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.BaseClasses.BasePss3;

equation
  connect(limiter2.y, VPssPu) annotation(
    Line(points = {{142, 0}, {160, 0}, {160, -40}, {230, -40}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end Pss3b;
