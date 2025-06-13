within Dynawo.Examples.Nordic;

model loadinittestterminal
  // to be connected with the transformer init model
  Connectors.ACPower terminal;
  Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power in pu (base SnRef) (receptor convention)";
equation
  s0Pu = terminal.V*Modelica.ComplexMath.conj(terminal.i);
end loadinittestterminal;
