within Dynawo.Electrical.PEIR.Plant.Simplified;

model GridFollowingPlant "Simplified grid following model with plant control"

  // Nominal parameters
  parameter Types.ApparentPowerModule SNom "Apparent nominal power in MVA";

  // Plant controller parameters
  parameter Types.PerUnit AlphaPuPNom = 0 "Frequency sensitivity in pu (base PNom, OmegaNom)";
  parameter Types.PerUnit DbdPu = 0.05 "Reactive power deadband in pu (base SNom)";
  parameter Types.PerUnit EMaxPu = 99 "Maximum VAR error in pu (base SNom)";
  parameter Types.PerUnit EMinPu = -99 "Minimum VAR error in pu (base SNom)";
  parameter Types.PerUnit Ki "VAR regulator integral gain";
  parameter Types.PerUnit Kp "VAR regulator proportional gain";
  parameter Types.PerUnit LambdaPuSNom "Reactive power sensitivity of the voltage regulation in pu (base UNom, SNom)";
  parameter Types.ActivePower PMin = 0 "Minimum active power in MW";
  parameter Types.ActivePower PMax "Maximum active power in MW";
  parameter Types.ActivePower PNom "Nominal active power in MW";
  parameter Types.ReactivePowerPu QMaxPu "Maximum plant level reactive power command in pu (base SNom)";
  parameter Types.ReactivePowerPu QMaxRegPu "Maximum reacive power in pu (base SNom)";
  parameter Types.ReactivePowerPu QMinPu "Minimum plant level reactive power command in pu (base SNom)";
  parameter Types.ReactivePowerPu QMinRegPu "Minimum reactive power in pu (base SNom)";
  parameter Boolean VRegFlag "Minimum reactive power at regulated bus in pu (base SNom)";
  final parameter Types.PerUnit LambdaPu = LambdaPuSNom * SystemBase.SnRef / SNom "Reactive power sensitivity of the voltage regulation in pu (base UNom, SnRef)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput deltaPmRefPu(start = 0) "Additional active power reference in pu (base PNom)" annotation(
    Placement(transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Network angular reference frequency in pu (base OmegaNom)" annotation(
    Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QRegPu(start = QReg0Pu) "Reactive power at regulated bus in pu (base SnRef) (generator convention)" annotation(
    Placement(transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput URegPu(start = UReg0Pu) "Voltage amplitude at regulated bus in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu)  "Voltage regulation set point in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));

  // Output variables
  Types.ActivePowerPu PGenPu(start = - P0Pu) "Active power at terminal in pu (base SnRef) (generator convention)";
  Types.ReactivePowerPu QGenPu(start = - Q0Pu) "Reactive power at terminal in pu (base SnRef) (generator convention)";

  Dynawo.Electrical.PEIR.Plant.Simplified.BaseControls.PlantControllerPI plantControllerPI(DbdPu = DbdPu, EMaxPu = EMaxPu, EMinPu = EMinPu, Ki = Ki, Kp = Kp, PMin = PMin, PMax = PMax, PNom = PNom, AlphaPuPNom = AlphaPuPNom, LambdaPuSNom = LambdaPuSNom, QMaxRegPu = QMaxRegPu, QMinRegPu = QMinRegPu, SNom = SNom, UReg0Pu = UReg0Pu, QMaxPu = QMaxPu, QMinPu = QMinPu, PInj0Pu = -P0Pu*SystemBase.SnRef/SNom, QInj0Pu = -Q0Pu*SystemBase.SnRef/SNom, QReg0Pu = QReg0Pu, VRegFlag = VRegFlag)  annotation(
    Placement(transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Connectors.ACPower terminal(V(im(start = u0Pu.im), re(start = u0Pu.re)), i(im(start = i0Pu.im), re(start = i0Pu.re))) annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 2}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.PEIR.Plant.Simplified.BaseControls.InjectorInterface injector(SNom = SNom, i0Pu = i0Pu, U0Pu = U0Pu, u0Pu = u0Pu, PInj0Pu = -P0Pu*SystemBase.SnRef/SNom, QInj0Pu = -Q0Pu*SystemBase.SnRef/SNom)  annotation(
    Placement(transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.PerUnit QReg0Pu "Start value of reactive power at regulated bus in pu (generator convention) (base SNom)";
  parameter Types.PerUnit U0Pu "Start value of voltage amplitude at terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at terminal in rad";
  parameter Types.PerUnit UReg0Pu "Start value of voltage magnitude at regulated bus in pu (base UNom)";
  parameter Types.PerUnit URef0Pu = UReg0Pu - LambdaPu * QReg0Pu "Start value of voltage setpoint for plant level control in pu (base UNom)";

  final parameter Types.ComplexCurrentPu i0Pu = Modelica.ComplexMath.conj(Complex(P0Pu, Q0Pu) / u0Pu) "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.ComplexVoltagePu u0Pu = Modelica.ComplexMath.fromPolar(U0Pu, UPhase0) "Start value of complex voltage at terminal in pu (base UNom)";

equation
  Complex(PGenPu, QGenPu) = -terminal.V*ComplexMath.conj(terminal.i);

  connect(URefPu, plantControllerPI.URefPu) annotation(
    Line(points = {{-110, -40}, {-50, -40}, {-50, -10}}, color = {0, 0, 127}));
  connect(QRegPu, plantControllerPI.QRegPu) annotation(
    Line(points = {{-110, 60}, {-50, 60}, {-50, 10}}, color = {0, 0, 127}));
  connect(URegPu, plantControllerPI.URegPu) annotation(
    Line(points = {{-110, 20}, {-80, 20}, {-80, 4}, {-60, 4}}, color = {0, 0, 127}));
  connect(deltaPmRefPu, plantControllerPI.deltaPmRefPu) annotation(
    Line(points = {{-110, 40}, {-70, 40}, {-70, 10}, {-60, 10}}, color = {0, 0, 127}));
  connect(omegaRefPu, plantControllerPI.omegaRefPu) annotation(
    Line(points = {{-110, 0}, {-60, 0}}, color = {0, 0, 127}));
  connect(plantControllerPI.PInjPu, injector.PInjPu) annotation(
    Line(points = {{-38, 6}, {-1, 6}}, color = {0, 0, 127}));
  connect(plantControllerPI.QInjPu, injector.QInjPu) annotation(
    Line(points = {{-38, -6}, {-1, -6}}, color = {0, 0, 127}));
  connect(injector.terminal, terminal) annotation(
    Line(points = {{20, 0}, {100, 0}}, color = {0, 0, 255}));

  annotation(
    Diagram,
  Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-1, 2}, extent = {{-83, 38}, {83, -38}}, textString = "Grid Following Plant PI Controller")}),
  Documentation(info = "<html><head></head><body><br></body></html>"));
end GridFollowingPlant;
