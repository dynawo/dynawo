within Dynawo.Examples.SMIB.Standard;

model test
  import Modelica.Math;
  import Modelica.ComplexMath;
  import Dynawo;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus2(UPhase = 0.04, UPu = 0.98) annotation(
    Placement(visible = true, transformation(origin = {40, 20}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.DynamicTransformerFixedRatio transformerFixedRatio1( CPu = 0, GPu = 0.0001, LPu = 0.0675, RPu = 0.0001,  i10Pu = Complex(-0.580128, -0.308771), i20Pu = Complex(0.580226, 0.308774), rTfoPu = 1, u10Pu = Complex(1, 0), u20Pu = Complex(0.979216, 0.0391895)) annotation(
    Placement(visible = true, transformation(origin = {0, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus3(UPhase = 0, UPu = 1) annotation(
    Placement(visible = true, transformation(origin = {-40, 20}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation

  transformerFixedRatio1.omegaPu = SystemBase.omega0Pu;
  transformerFixedRatio1.switchOffSignal1.value = false;
  transformerFixedRatio1.switchOffSignal2.value = false;

  connect(transformerFixedRatio1.terminal1, infiniteBus3.terminal) annotation(
    Line(points = {{-10, 20}, {-40, 20}}, color = {0, 0, 255}));
  connect(transformerFixedRatio1.terminal2, infiniteBus2.terminal) annotation(
    Line(points = {{10, 20}, {40, 20}}, color = {0, 0, 255}));
end test;
