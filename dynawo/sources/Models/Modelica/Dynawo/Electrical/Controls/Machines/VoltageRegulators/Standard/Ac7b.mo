within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;
model Ac7b "IEEE exciter type AC7B model (2005 standard)"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.BaseClasses.BaseAc7(
    sum1(
    nin      = 3),
    Ki = 0,
    Thetap = 0,
    XlPu = 0);

equation
  connect(potentialCircuit.vE, product.u1) annotation(
    Line(points = {{-378, 120}, {240, 120}, {240, 6}, {258, 6}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(feedback.y, pid.u_s) annotation(
    Line(points = {{-270, -40}, {-82, -40}}, color = {0, 0, 127}));
  connect(pid.y, feedback1.u1) annotation(
    Line(points = {{-58, -40}, {92, -40}}, color = {0, 0, 127}));
  connect(limitedPI.y, product.u2) annotation(
    Line(points = {{162, -40}, {240, -40}, {240, -6}, {258, -6}}, color = {0, 0, 127}));
  connect(UPssPu, sum1.u[2]) annotation(
    Line(points = {{-500, -100}, {-360, -100}, {-360, -40}, {-342, -40}}, color = {0, 0, 127}));
  connect(UUelPu, sum1.u[3]) annotation(
    Line(points = {{-500, -140}, {-360, -140}, {-360, -40}, {-342, -40}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end Ac7b;
