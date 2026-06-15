within Dynawo.Electrical.Machines.Simplified;
model GeneratorAlphaBeta "Generator with voltage-dependent active and reactive power (alpha-beta model)"
  extends BaseClasses.BaseGeneratorSimplified;
  extends AdditionalIcons.Machine;

  parameter Real Alpha "Exponential active power sensitivity to voltage";
  parameter Real Beta "Exponential reactive power sensitivity to voltage";

equation
  if running then
    PGenPu = PGen0Pu * (UPu / U0Pu) ^ Alpha;
    QGenPu = QGen0Pu * (UPu / U0Pu) ^ Beta;
  else
    terminal.i = Complex(0);
  end if;

  annotation(preferredView = "text");
end GeneratorAlphaBeta;
