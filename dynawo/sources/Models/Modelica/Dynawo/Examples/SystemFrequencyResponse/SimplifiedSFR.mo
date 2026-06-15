within Dynawo.Examples.SystemFrequencyResponse;
model SimplifiedSFR
  extends Icons.Example;

  Modelica.Blocks.Sources.Step Pe(height = -0.3, offset = 0, startTime = 1) annotation(
      Placement(visible = true, transformation(origin = {-32, 0}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Dynawo.Electrical.Controls.Frequency.SystemFrequencyResponse.SimplifiedSFR simplifiedSFR(R = 0.05, H = 4, Km = 0.95, Fh = 0.3, Tr = 8, DPu = 1,
    gain(                                                                                                                                         k      = 60),Pe0Pu = 0) annotation(
      Placement(visible = true, transformation(origin = {6, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(Pe.y, simplifiedSFR.PePu) annotation(
      Line(points = {{-26, 0}, {-4, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-6, Interval = 0.004));
end SimplifiedSFR;
