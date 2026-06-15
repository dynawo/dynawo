within Dynawo.Electrical.Wind.WECC.BaseClasses;
partial model BaseWT4B "Base model for WECC Wind Turbine 4B"
  extends Dynawo.Electrical.Wind.WECC.BaseClasses.BaseWT4;

  Modelica.Blocks.Sources.Constant omegaGPu(k = 1) annotation(
    Placement(transformation(origin = {-105, -40}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

equation
  connect(omegaGPu.y, wecc_reec.omegaGPu) annotation(
    Line(points = {{-100, -40}, {-85, -40}, {-85, -11}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram");
end BaseWT4B;
