within Dynawo.Electrical.Machines.Simplified;
model GeneratorPVFixed "Generator with fixed active power and voltage"
  extends BaseClasses.BaseGeneratorSimplified(
    QGen0Pu = 0,
    u0Pu = Complex(U0Pu, 0),
    i0Pu = Complex(-PGen0Pu / U0Pu, 0));
  extends AdditionalIcons.Machine;

  Types.Angle UPhase "Voltage angle at terminal in rad";

equation
  UPhase = ComplexMath.arg(terminal.V);

  if running then
    PGenPu = PGen0Pu;
    UPu = U0Pu;
  else
    terminal.i = Complex(0);
  end if;

  annotation(preferredView = "text");
end GeneratorPVFixed;
