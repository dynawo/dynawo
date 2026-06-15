within Dynawo.Electrical.Machines.BaseClasses;
partial model BaseGeneratorSimplified "Base model for simplified generator models"
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffGenerator;

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the synchronous generator to the grid" annotation(
      Placement(visible = true, transformation(origin = {0, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.ActivePowerPu PGen0Pu "Start value of active power at terminal in pu (base SnRef) (generator convention)";
  parameter Types.ReactivePowerPu QGen0Pu "Start value of reactive power at terminal in pu (base SnRef) (generator convention)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal in pu (base UNom)";
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";

  Types.ActivePower PGen(start = SystemBase.SnRef * PGen0Pu) "Active power at terminal in MW (generator convention)";
  Types.ActivePowerPu PGenPu(start = PGen0Pu) "Active power at terminal in pu (base SnRef) (generator convention)";
  Dynawo.Connectors.ReactivePowerPuConnector QGenPu(start = QGen0Pu) "Reactive power at terminal in pu (base SnRef) (generator convention)";
  Types.ComplexApparentPowerPu SGenPu(re(start = PGen0Pu), im(start = QGen0Pu)) "Complex apparent power at terminal in pu (base SnRef) (generator convention)";
  Dynawo.Connectors.VoltageModulePuConnector UPu(start = U0Pu) "Voltage amplitude at terminal in pu (base UNom)";

equation
  PGen = SystemBase.SnRef * PGenPu;
  SGenPu = Complex(PGenPu, QGenPu);
  SGenPu = -terminal.V * ComplexMath.conj(terminal.i);

  if running then
    if ((terminal.V.re == 0) and (terminal.V.im == 0)) then
      UPu = 0.;
    else
      UPu =Modelica.ComplexMath.abs(terminal.V);
    end if;
  else
    UPu = 0.;
  end if;

  annotation(preferredView = "text");
end BaseGeneratorSimplified;
