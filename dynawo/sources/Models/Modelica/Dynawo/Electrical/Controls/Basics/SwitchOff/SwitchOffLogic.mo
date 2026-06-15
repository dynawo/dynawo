within Dynawo.Electrical.Controls.Basics.SwitchOff;
partial model SwitchOffLogic "Manage switch-off logic"

  parameter Integer NbSwitchOffSignals(min = 1, max = 3) "Number of switch-off signals to take into account in inputs";

  Modelica.Blocks.Interfaces.BooleanInput switchOffSignal1(start = SwitchOffSignal10) "Switch-off signal 1";
  Modelica.Blocks.Interfaces.BooleanInput switchOffSignal2(start = SwitchOffSignal20) if NbSwitchOffSignals >= 2 "Switch-off signal 2";
  Modelica.Blocks.Interfaces.BooleanInput switchOffSignal3(start = SwitchOffSignal30) if NbSwitchOffSignals >= 3 "Switch-off signal 3";

  Modelica.Blocks.Interfaces.BooleanOutput running(start = Running0) "Indicates if the component is running or not";

  parameter Boolean SwitchOffSignal10 = false "Initial switch-off signal 1";
  parameter Boolean SwitchOffSignal20 = false "Initial switch-off signal 2";
  parameter Boolean SwitchOffSignal30 = false "Initial switch-off signal 3";

  final parameter Boolean Running0 = if NbSwitchOffSignals >= 3 then not
                                                                        (SwitchOffSignal10 or SwitchOffSignal20 or SwitchOffSignal30) elseif NbSwitchOffSignals >= 2 then not
                                                                                                                                                                             (SwitchOffSignal10 or SwitchOffSignal20) else not SwitchOffSignal10 "Indicates if the component is initially running or not";

equation
  if (NbSwitchOffSignals >= 3) then
    when switchOffSignal1 or switchOffSignal2 or switchOffSignal3 and pre(running) then
      running = false;
    elsewhen not switchOffSignal1 and not switchOffSignal2 and not switchOffSignal3 and not pre(running) then
      running = true;
    end when;
  elseif (NbSwitchOffSignals >= 2) then
    when switchOffSignal1 or switchOffSignal2 and pre(running) then
      running = false;
    elsewhen not switchOffSignal1 and not switchOffSignal2 and not pre(running) then
      running = true;
    end when;
  else
    when switchOffSignal1 and pre(running) then
      running = false;
    elsewhen not switchOffSignal1 and not pre(running) then
      running = true;
    end when;
  end if;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><body>
Handles a predefinite number of switch-off signals and sets running to false as soon as one signal is set to true.</body></html>"));
end SwitchOffLogic;
