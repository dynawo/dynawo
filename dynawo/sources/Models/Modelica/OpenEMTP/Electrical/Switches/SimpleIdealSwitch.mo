within OpenEMTP.Electrical.Switches;

model SimpleIdealSwitch "Ideal Switch"
  import Modelica.SIunits.Time;
  import Modelica.SIunits.ElectricCurrent;
  parameter Time Tclosing = 0 "Closing Time";
  parameter Time Topening = 0.1 "Opening Time";
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p;
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n;
  Modelica.Electrical.Analog.Ideal.IdealClosingSwitch idealClosingSwitch1(Goff = 1e-15, Ron = 1e-15);
  Modelica.Electrical.Analog.Sensors.CurrentSensor currentSensor1;

equation

  when (time > Tclosing and time < Topening) then
    idealClosingSwitch1.control = true;
  elsewhen (time <= Tclosing or time >= Topening) then
    idealClosingSwitch1.control = false;
  end when;

  connect(pin_p, idealClosingSwitch1.p);
  connect(idealClosingSwitch1.n, currentSensor1.p);
  connect(currentSensor1.n, pin_n);

end SimpleIdealSwitch;
