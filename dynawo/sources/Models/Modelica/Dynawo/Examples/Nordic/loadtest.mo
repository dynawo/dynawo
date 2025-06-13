within Dynawo.Examples.Nordic;

model loadtest
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the load to the grid" annotation(
    Placement(visible = true, transformation(origin = {0, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // in order to change the load set-point, connect an event to PRefPu or QRefPu
  Modelica.Blocks.Interfaces.RealInput PPu(start = s0Pu.re) "Active power request" annotation(
    Placement(visible = true, transformation(origin = {-50, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-61, -85}, extent = {{-15, -15}, {15, 15}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QPu(start = s0Pu.im) "Reactive power request" annotation(
    Placement(visible = true, transformation(origin = {50, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {60, -84}, extent = {{-16, -16}, {16, 16}}, rotation = 90)));

  Types.ComplexApparentPowerPu SPu(re(start = s0Pu.re), im(start = s0Pu.im)) "Apparent power at load terminal in pu (base SnRef) (receptor convention)";

  // initial parameters from the initialisation model
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at load terminal in pu (base UNom)";
  parameter Types.ComplexApparentPowerPu s0Pu "Start value of apparent power at load terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at load terminal in pu (base UNom, SnRef) (receptor convention)";

equation
  SPu = Complex(PPu, QPu);
  SPu = terminal.V * ComplexMath.conj(terminal.i);

end loadtest;
