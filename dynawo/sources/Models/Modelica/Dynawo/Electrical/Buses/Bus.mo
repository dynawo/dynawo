within Dynawo.Electrical.Buses;
model Bus "Bus"
  extends AdditionalIcons.Bus;

  parameter Types.VoltageModule UNom = 1.0 "Nominal voltage in kV";

  Dynawo.Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(origin = {-1.42109e-14, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-1.42109e-14, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Types.VoltageModulePu UPu "Voltage amplitude at terminal in pu (base UNom)";
  Types.VoltageModule U "Voltage amplitude at terminal in kV";
  Types.Angle UPhase "Voltage angle at terminal in rad";

equation
  terminal.i = Complex(0);
  if ((terminal.V.re == 0) and (terminal.V.im == 0)) then
    UPu = 0;
  else
    UPu =Modelica.ComplexMath.abs(terminal.V);
  end if;
  UPhase = ComplexMath.arg(terminal.V);
  U = UPu * UNom;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The bus model doesn't provide any new equation to the system. It is present into the library for convenience purpose to build network tests.</body></html>"));
end Bus;
