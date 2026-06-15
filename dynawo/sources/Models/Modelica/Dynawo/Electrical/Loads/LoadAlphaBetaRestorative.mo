within Dynawo.Electrical.Loads;
model LoadAlphaBetaRestorative "Generic model of a restorative Alpha-Beta load."
  extends BaseClasses.BaseLoad;
  extends AdditionalIcons.Load;

  parameter Types.Time tFilter "Time constant of the load restoration";
  parameter Types.VoltageModulePu UMinPu "Minimum value of the voltage amplitude at terminal in pu (base UNom) that ensures the P/Q restoration";
  parameter Types.VoltageModulePu UMaxPu "Maximum value of the voltage amplitude at terminal in pu (base UNom) that ensures the P/Q restoration";
  parameter Real Alpha "Active load sensitivity to voltage";
  parameter Real Beta "Reactive load sensitivity to voltage";

protected
  Types.VoltageModulePu UFilteredRawPu(start=Modelica.ComplexMath.abs(u0Pu))
    "Filtered voltage amplitude at terminal in pu (base UNom)";
  Types.VoltageModulePu UFilteredPu(start=Modelica.ComplexMath.abs(u0Pu))
    "Bounded filtered voltage amplitude at terminal in pu (base UNom)";

equation
  if running then
    if (terminal.V == Complex(0)) then
      tFilter * der(UFilteredRawPu) = -UFilteredRawPu;
      terminal.i = Complex(0);
    elseif UFilteredPu == 0 then
      tFilter * der(UFilteredRawPu) =Modelica.ComplexMath.abs(terminal.V) - UFilteredRawPu;
      terminal.i = Complex(0);
    else
      tFilter * der(UFilteredRawPu) =Modelica.ComplexMath.abs(terminal.V) - UFilteredRawPu;
      PPu =PRefPu*(1 + deltaP)*((Modelica.ComplexMath.abs(terminal.V)/UFilteredPu)^Alpha);
      QPu =QRefPu*(1 + deltaQ)*((Modelica.ComplexMath.abs(terminal.V)/UFilteredPu)^Beta);
    end if;
    UFilteredPu = if UFilteredRawPu >= UMaxPu then UMaxPu elseif UFilteredRawPu <= UMinPu then UMinPu else UFilteredRawPu;
  else
    UFilteredRawPu = 0;
    UFilteredPu = 0;
    terminal.i = Complex(0);
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>  After an event, the load goes back to its initial PPu/QPu unless the voltage at its terminal is lower than UMinPu or higher than UMaxPu. In this case, the load behaves as a classical Alpha-Beta load.<div>This load restoration emulates the behaviour of a tap changer transformer that connects the load to the system and regulates the voltage at its terminal.</div></body></html>"));
end LoadAlphaBetaRestorative;
