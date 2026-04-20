within Dynawo.Electrical.Sources.PEIR.Converters.BaseConverters;

model Generator "Generator model for a PEIR converter, replacing the internal loop"

  parameter Types.PerUnit dIdMaxPu "Maximum rate-of-change of active current in pu (base UNom, SNom)";
  parameter Types.PerUnit dIdMinPu "Minimum rate-of-change of active current in pu (base UNom, SNom)";
  parameter Types.PerUnit dIqMaxPu "Maximum rate-of-change of reactive current in pu (base UNom, SNom)";
  parameter Types.PerUnit dIqMinPu "Minimum rate-of-change of reactive current in pu (base UNom, SNom)";
  parameter Types.Time tG "Emulated delay in converter controls in s";

  Modelica.Blocks.Interfaces.RealInput idRefFilterPu(start = IdFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqRefFilterPu(start = IqFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, -52}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput idFilterPu(start = IdFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {116, 50}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {110, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqFilterPu(start = IqFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {116, -52}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze(T = tG, UseRateLim = true, Y0 = IdFilter0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-2, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze1(T = tG, UseRateLim = true, Y0 = IqFilter0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-2, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = dIdMaxPu)  annotation(
    Placement(visible = true, transformation(origin = {-112, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = dIdMinPu)  annotation(
    Placement(visible = true, transformation(origin = {-112, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = dIqMaxPu)  annotation(
    Placement(visible = true, transformation(origin = {-112, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant3(k = dIqMinPu)  annotation(
    Placement(visible = true, transformation(origin = {-112, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit IdFilter0Pu "Start value of d-axis current after the filter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqFilter0Pu "Start value of q-axis current after the filter in pu (base UNom, SNom) (generator convention)";

equation
  connect(idRefFilterPu, rateLimFirstOrderFreeze.u) annotation(
    Line(points = {{-120, 50}, {-14, 50}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze.y, idFilterPu) annotation(
    Line(points = {{9, 50}, {115, 50}}, color = {0, 0, 127}));
  connect(iqRefFilterPu, rateLimFirstOrderFreeze1.u) annotation(
    Line(points = {{-120, -52}, {-14, -52}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze1.y, iqFilterPu) annotation(
    Line(points = {{9, -52}, {115, -52}}, color = {0, 0, 127}));
  connect(const.y, rateLimFirstOrderFreeze.dyMax) annotation(
    Line(points = {{-101, 90}, {-40, 90}, {-40, 56}, {-14, 56}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze.dyMin, constant1.y) annotation(
    Line(points = {{-14, 43.7}, {-40, 43.7}, {-40, 19.7}, {-100, 19.7}}, color = {0, 0, 127}));
  connect(constant2.y, rateLimFirstOrderFreeze1.dyMax) annotation(
    Line(points = {{-100, -20}, {-40, -20}, {-40, -46}, {-14, -46}}, color = {0, 0, 127}));
  connect(constant3.y, rateLimFirstOrderFreeze1.dyMin) annotation(
    Line(points = {{-100, -80}, {-40, -80}, {-40, -58}, {-14, -58}}, color = {0, 0, 127}));
end Generator;
