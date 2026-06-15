within Dynawo.Electrical.Buses;
model BusWithInit "Bus with init"
  extends AdditionalIcons.Bus;
  import Modelica.Constants;

  parameter Types.VoltageModule UNom = 1.0 "Nominal voltage in kV";

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = 0.), im(start = 0.)));

  Types.VoltageModulePu UPu(start=Modelica.ComplexMath.abs(u0Pu))
    "Voltage amplitude at terminal in pu (base UNom)";
  Types.VoltageModule U "Voltage amplitude at terminal in kV";
  Types.Angle UPhase(start = ComplexMath.arg(u0Pu)) "Voltage angle at terminal in rad";
  Types.Angle UPhaseDeg(start = ComplexMath.arg(u0Pu) * 180.0 / Constants.pi) "Voltage angle at terminal in degree";

  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal (base UNom)";

equation
  terminal.i = Complex(0);
  if ((terminal.V.re == 0) and (terminal.V.im == 0)) then
    UPu = 0;
  else
    UPu =Modelica.ComplexMath.abs(terminal.V);
  end if;
  UPhase = ComplexMath.arg(terminal.V);
  UPhaseDeg = UPhase * 180.0 / Constants.pi;
  U = UPu * UNom;

  annotation(preferredView = "text");

end BusWithInit;
