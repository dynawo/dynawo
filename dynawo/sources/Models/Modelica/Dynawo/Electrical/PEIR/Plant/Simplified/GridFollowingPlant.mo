within Dynawo.Electrical.PEIR.Plant.Simplified;

model GridFollowingPlant
  parameter Types.PerUnit DbdPu "Reactive power (RefFlag = 0) or voltage (RefFlag = 1) deadband in pu (base SNom or UNom) (typical: 0..0.1)";
  parameter Types.PerUnit EMaxPu "Maximum Volt/VAR error in pu (base UNom or SNom)";
  parameter Types.PerUnit EMinPu "Minimum Volt/VAR error in pu (base UNom or SNom)";
  parameter Types.PerUnit Ki "Volt/VAR regulator integral gain";
  parameter Types.PerUnit Kp "Volt/VAR regulator proportional gain";
  //parameter Types.ReactivePowerPu QMaxPu "Maximum plant level reactive power command in pu (base SNom)";
  //parameter Types.ReactivePowerPu QMinPu "Minimum plant level reactive power command in pu (base SNom)";

  parameter Types.ActivePower PMin "Minimum active power in MW";
  parameter Types.ActivePower PMax "Maximum active power in MW";
  parameter Types.ActivePower PNom "Nominal active power in MW";
  parameter Types.PerUnit AlphaPuPNom "Frequency sensitivity in pu (base PNom, OmegaNom)";

  parameter Types.PerUnit LambdaPuSNom "Reactive power sensitivity of the voltage regulation in pu (base UNom, SNom)";
  parameter Types.ReactivePower QMax "Maximum reactive power in Mvar";
  parameter Types.ReactivePower QMin "Minimum reactive power in Mvar";
  parameter Types.ApparentPowerModule SNom "Apparent nominal power in MVA";
  parameter Types.ReactivePower QMaxRegPu "Maximum reactive power in Mvar";
  parameter Types.ReactivePower QMinRegPu "Minimum reactive power in Mvar";

  // Line parameters
  parameter Types.PerUnit RPu "Resistance of equivalent branch connection to the grid in pu (base SnRef, UNom)";
  parameter Types.PerUnit XPu "Reactance of equivalent branch connection to the grid in pu (base SnRef, UNom)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput URefPu(start = U0Pu) annotation(
    Placement(transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) annotation(
    Placement(transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QRegPu(start = PInj0Pu) annotation(
    Placement(transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.BooleanInput freeze(start = false) annotation(
    Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) annotation(
    Placement(transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput deltaPmRefPu(start = 0) annotation(
    Placement(transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}})));
  /*Modelica.Blocks.Interfaces.RealInput UPhase annotation(
    Placement(transformation(origin = {-110, 110}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-114, 98}, extent = {{-20, -20}, {20, 20}})));*/

  Types.ActivePowerPu PGenPu(start = - P0Pu);
  Types.ReactivePowerPu QGenPu(start = - Q0Pu);

  Dynawo.Electrical.PEIR.Plant.Simplified.BaseControls.PlantControllerPI plantControllerPI(DbdPu = DbdPu, EMaxPu = EMaxPu, EMinPu = EMinPu, Ki = Ki, Kp = Kp, PMin = PMin, PMax = PMax, PNom = PNom, AlphaPuPNom = AlphaPuPNom, LambdaPuSNom = LambdaPuSNom, QMax = QMax, QMin = QMin, SNom = SNom, U0Pu = U0Pu, u0Pu = u0Pu, i0Pu = i0Pu, QMaxRegPu = QMaxRegPu, QMinRegPu = QMinRegPu, PInj0Pu = PInj0Pu, QInj0Pu = QInj0Pu, QReg0Pu = QReg0Pu)  annotation(
    Placement(transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Connectors.ACPower terminal(V(im(start = u0Pu.im), re(start = u0Pu.re)), i(im(start = i0Pu.im), re(start = i0Pu.re))) annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = RPu, XPu = XPu) annotation(
    Placement(transformation(origin = {50, 0}, extent = {{10, -10}, {-10, 10}})));
  Dynawo.Electrical.PEIR.Plant.Simplified.BaseControls.Injector injector(SNom = SNom, i0Pu = i0Pu, U0Pu = U0Pu, u0Pu = u0Pu, PInj0Pu = PInj0Pu, QInj0Pu = QInj0Pu)  annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  parameter Types.PerUnit PInj0Pu "Start value of active power at injector terminal in pu (generator convention) (base SNom)";
  parameter Types.PerUnit QInj0Pu "Start value of reactive power at injector terminal in pu (generator convention) (base SNom)";
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at regulated bus in pu (base UNom)";
  parameter Types.PerUnit QReg0Pu "Start value of reactive power at regulated bus in pu (generator convention) (base SNom)";
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal in pu (base SnRef) (receptor convention)";

equation
  line.switchOffSignal1.value = injector.switchOffSignal1.value;
  line.switchOffSignal2.value = injector.switchOffSignal2.value;

  Complex(PGenPu, QGenPu) = -terminal.V * ComplexMath.conj(terminal.i);

  connect(URefPu, plantControllerPI.URefPu) annotation(
    Line(points = {{-110, -20}, {-50, -20}, {-50, -10}}, color = {0, 0, 127}));
  connect(line.terminal1, terminal) annotation(
    Line(points = {{60, 0}, {100, 0}}, color = {0, 0, 255}));
  connect(QRegPu, plantControllerPI.QRegPu) annotation(
    Line(points = {{-110, 40}, {-50, 40}, {-50, 10}}, color = {0, 0, 127}));
  connect(UPu, plantControllerPI.UPu) annotation(
    Line(points = {{-110, 20}, {-80, 20}, {-80, 4}, {-60, 4}}, color = {0, 0, 127}));
  connect(freeze, plantControllerPI.freeze) annotation(
    Line(points = {{-110, 0}, {-80, 0}, {-80, -4}, {-60, -4}}, color = {255, 0, 255}));
  connect(deltaPmRefPu, plantControllerPI.deltaPmRefPu) annotation(
    Line(points = {{-110, 80}, {-70, 80}, {-70, 10}, {-60, 10}}, color = {0, 0, 127}));
  connect(omegaRefPu, plantControllerPI.omegaRefPu) annotation(
    Line(points = {{-110, 60}, {-74, 60}, {-74, 0}, {-60, 0}}, color = {0, 0, 127}));
  connect(injector.terminal, line.terminal2) annotation(
    Line(points = {{12, 0}, {40, 0}}, color = {0, 0, 255}));
  connect(plantControllerPI.PInjPu, injector.PInjPu) annotation(
    Line(points = {{-38, 6}, {-10, 6}}, color = {0, 0, 127}));
  connect(plantControllerPI.QInjPu, injector.QInjPu) annotation(
    Line(points = {{-38, -6}, {-10, -6}}, color = {0, 0, 127}));

  annotation(
    Diagram);
end GridFollowingPlant;
