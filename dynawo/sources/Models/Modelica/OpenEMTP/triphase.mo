within OpenEMTP;

model triphase
  OpenEMTP.Electrical.Sources.YCosineVoltage ac annotation(
    Placement(visible = true, transformation(origin = {-44, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.R r(R = {10, 10, 10}, m = 3)  annotation(
    Placement(visible = true, transformation(origin = {-2, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.MultiPhase.Ground g annotation(
    Placement(visible = true, transformation(origin = {46, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(ac.Pk, r.plug_p) annotation(
    Line(points = {{-34, 26}, {-12, 26}}, color = {0, 0, 255}));
  connect(r.plug_n, g.positivePlug1) annotation(
    Line(points = {{8, 26}, {46, 26}, {46, -24}}, color = {0, 0, 255}));
end triphase;
