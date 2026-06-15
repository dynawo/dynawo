within Dynawo.Electrical.Controls.Basics.SwitchOff;
partial model SwitchOffLogicSide2 "Manage switch-off logic for side 2 of a quadripole"

  parameter Integer NbSwitchOffSignalsSide2(min = 1, max = 3) "Number of switch-off signals to take into account in inputs";

  Modelica.Blocks.Interfaces.BooleanInput switchOffSignal1Side2(start = SwitchOffSignal1Side20) "Switch-off signal 1 for side 2 of the quadripole";
  Modelica.Blocks.Interfaces.BooleanInput switchOffSignal2Side2(start = SwitchOffSignal2Side20) if NbSwitchOffSignalsSide2 >= 2 "Switch-off signal 2 for side 2 of the quadripole";
  Modelica.Blocks.Interfaces.BooleanInput switchOffSignal3Side2(start = SwitchOffSignal3Side20) if NbSwitchOffSignalsSide2 >= 3 "Switch-off signal 3 for side 2 of the quadripole";

  Modelica.Blocks.Interfaces.BooleanOutput runningSide2(start = RunningSide20) "Indicates if the component is running on side 2 or not";

  parameter Boolean SwitchOffSignal1Side20 = false "Initial switch-off signal 1 for side 2 of the quadripole";
  parameter Boolean SwitchOffSignal2Side20 = false "Initial switch-off signal 2 for side 2 of the quadripole";
  parameter Boolean SwitchOffSignal3Side20 = false "Initial switch-off signal 3 for side 2 of the quadripole";

  final parameter Boolean RunningSide20 = if NbSwitchOffSignalsSide2 >= 3 then not
                                                                                  (SwitchOffSignal1Side20 or SwitchOffSignal2Side20 or SwitchOffSignal3Side20) elseif NbSwitchOffSignalsSide2 >= 2 then not
                                                                                                                                                                                                        (SwitchOffSignal1Side20 or SwitchOffSignal2Side20) else not SwitchOffSignal1Side20 "Indicates if the component is initially running on side 2 or not";

equation
  if (NbSwitchOffSignalsSide2 >= 3) then
    when switchOffSignal1Side2 or switchOffSignal2Side2 or switchOffSignal3Side2 and pre(runningSide2) then
      runningSide2 = false;
    elsewhen not switchOffSignal1Side2 and not switchOffSignal2Side2 and not switchOffSignal3Side2 and not pre(runningSide2) then
      runningSide2 = true;
    end when;
  elseif (NbSwitchOffSignalsSide2 >= 2) then
    when switchOffSignal1Side2 or switchOffSignal2Side2 and pre(runningSide2) then
      runningSide2 = false;
    elsewhen not switchOffSignal1Side2 and not switchOffSignal2Side2 and not pre(runningSide2) then
      runningSide2 = true;
    end when;
  else
    when switchOffSignal1Side2 and pre(runningSide2) then
      runningSide2 = false;
    elsewhen not switchOffSignal1Side2 and not pre(runningSide2) then
      runningSide2 = true;
    end when;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><body>
Handles a predefinite number of switch-off signals and sets running to false as soon as one signal is set to true.</body></html>"));
end SwitchOffLogicSide2;
