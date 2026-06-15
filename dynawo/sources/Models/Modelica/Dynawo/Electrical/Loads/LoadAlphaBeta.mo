within Dynawo.Electrical.Loads;
model LoadAlphaBeta "Load with voltage-dependent active and reactive power (alpha-beta model)"
  extends BaseClasses.BaseLoad;
  extends AdditionalIcons.Load;

  parameter Real alpha "Active load sensitivity to voltage";
  parameter Real beta "Reactive load sensitivity to voltage";

equation
  if running and terminal.V <> Complex(0) then
    PPu =PRefPu*(1 + deltaP)*((Modelica.ComplexMath.abs(terminal.V)/Modelica.ComplexMath.abs(u0Pu))
      ^alpha);
    QPu =QRefPu*(1 + deltaQ)*((Modelica.ComplexMath.abs(terminal.V)/Modelica.ComplexMath.abs(u0Pu))
      ^beta);
  else
    terminal.i = Complex(0);
  end if;

  annotation(preferredView = "text");
end LoadAlphaBeta;
