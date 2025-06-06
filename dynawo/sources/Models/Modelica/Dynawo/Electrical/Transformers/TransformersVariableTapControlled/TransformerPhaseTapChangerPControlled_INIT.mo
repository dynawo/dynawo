within Dynawo.Electrical.Transformers.TransformersVariableTapControlled;

model TransformerPhaseTapChangerPControlled_INIT
  extends AdditionalIcons.Init;

  // Transformer phase tap changer parameters
  parameter Types.PerUnit RPu "Resistance of the generator transformer in pu (base U2Nom, SnRef)";
  parameter Types.PerUnit XPu "Reactance of the generator transformer in pu (base U2Nom, SnRef)";
  parameter Types.PerUnit GPu "Conductance of the generator transformer in pu (base U2Nom, SnRef)";
  parameter Types.PerUnit BPu "Susceptance of the generator transformer in pu (base U2Nom, SnRef)";
  parameter Integer NbTap "Number of taps";
  parameter Types.Angle AlphaTfoMin "Minimum phase shift in rad";
  parameter Types.Angle AlphaTfoMax "Maximum phase shift in rad";

  // Phase shifter parameters
  parameter Integer increasePhase "Whether the phase shifting is increased when the tap is increased";
  parameter Types.ActivePower P0 "Initial active power";
  parameter Types.ActivePower PDeadBand(min = 0) "Active-power dead-band around the target";
  parameter Types.ActivePower PTarget "Target active power";
  parameter Boolean regulating0 "Whether the tap-changer/phase-shifter is initially regulating";
  parameter Integer tap0 "Initial tap";

  // Transformer phase tap changer initialization model
  Dynawo.Electrical.Transformers.TransformersVariableTap.TransformerPhaseTapChanger_INIT transformerPhaseTapChanger_INIT(AlphaTfoMax = AlphaTfoMax, AlphaTfoMin = AlphaTfoMin, BPu = BPu, GPu = GPu, NbTap = NbTap, P10Pu = P10Pu, Q10Pu = Q10Pu, RPu = RPu, RatioTfo0Pu = RatioTfo0Pu, Tap0 = tap0, U10Pu = U10Pu, U1Phase0 = U1Phase0, XPu = XPu)  annotation(
    Placement(visible = true, transformation(origin = {-30, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Phase shifter initialization model
  Dynawo.Electrical.Controls.Transformers.PhaseShifterP_INIT phaseShifterP_INIT(P0 = P0, PDeadBand = PDeadBand, PTarget = PTarget, deadBand = PDeadBand, increasePhase = increasePhase, increaseTapToIncreaseValue = increasePhase > 0, regulating0 = regulating0, targetValue = PTarget)  annotation(
    Placement(visible = true, transformation(origin = {30, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  flow Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base U1Nom, SnRef) (receptor convention)";
  flow Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 in pu (base U2Nom, SnRef) (receptor convention)";
  Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base U1Nom)";
  Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2 in pu (base U2Nom)";
  Types.VoltageModulePu U20Pu "Start value of voltage amplitude at terminal 2 in pu (base U2Nom)";
  Boolean increaseTapToIncreaseValue "Whether increasing the tap will increase the monitored value";

  // Initial parameters
  parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.PerUnit RatioTfo0Pu "Start value of transformation ratio in pu: U2/U1 in no load conditions";
  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base U1Nom)";
  parameter Types.Angle U1Phase0 "Start value of voltage angle at terminal 1 in rad";

equation
  i10Pu = transformerPhaseTapChanger_INIT.i10Pu;
  i20Pu = transformerPhaseTapChanger_INIT.i20Pu;
  u10Pu = transformerPhaseTapChanger_INIT.u10Pu;
  u20Pu = transformerPhaseTapChanger_INIT.u20Pu;
  U20Pu = transformerPhaseTapChanger_INIT.U20Pu;
  increaseTapToIncreaseValue = phaseShifterP_INIT.increaseTapToIncreaseValue;

end TransformerPhaseTapChangerPControlled_INIT;
