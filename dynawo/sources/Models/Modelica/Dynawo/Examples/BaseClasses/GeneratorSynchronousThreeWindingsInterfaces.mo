within Dynawo.Examples.BaseClasses;
model GeneratorSynchronousThreeWindingsInterfaces "Synchronous generator with real interfaces (inputs, outputs)"
  extends Dynawo.Examples.BaseClasses.InitializedGeneratorSynchronousThreeWindings;

  //Input variables
  Modelica.Blocks.Interfaces.RealInput efdPu_in annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-80, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PmPu_in annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {80, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput omegaPu_out annotation(
    Placement(visible = true, transformation(origin = {-10, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput PGenPu_out annotation(
    Placement(visible = true, transformation(origin = {-50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput omegaRefPu_out annotation(
    Placement(visible = true, transformation(origin = {30, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {50, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput IRotorPu_out annotation(
    Placement(visible = true, transformation(origin = {-90, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-90, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexOutput iStatorPu_out annotation(
    Placement(visible = true, transformation(origin = {90, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {90, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexOutput uPu_out annotation(
    Placement(visible = true, transformation(origin = {90, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {90, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UPu_out annotation(
    Placement(visible = true, transformation(origin = {-90, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {-90, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput UStatorPu_out annotation(
    Placement(visible = true, transformation(origin = {-32, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-30, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

equation
  PmPu = PmPu_in;
  efdPu = efdPu_in;
  omegaPu_out = omegaPu;
  PGenPu_out = PGenPu;
  omegaRefPu_out = omegaRefPu;
  IRotorPu_out = IRotorPu;
  iStatorPu_out = iStatorPu;
  uPu_out = uPu;
  UPu_out = UPu;
  UStatorPu_out = UStatorPu;

  annotation(preferredView = "text");
end GeneratorSynchronousThreeWindingsInterfaces;
