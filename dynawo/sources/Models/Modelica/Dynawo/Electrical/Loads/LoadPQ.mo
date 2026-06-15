within Dynawo.Electrical.Loads;
model LoadPQ "Load with constant reactive/active power"
  extends BaseClasses.BaseLoad;
  extends AdditionalIcons.Load;

equation
  if running and terminal.V <> Complex(0) then
    PPu = PRefPu * (1 + deltaP);
    QPu = QRefPu * (1 + deltaQ);
  else
    terminal.i = Complex(0);
  end if;

  annotation(preferredView = "text");
end LoadPQ;
