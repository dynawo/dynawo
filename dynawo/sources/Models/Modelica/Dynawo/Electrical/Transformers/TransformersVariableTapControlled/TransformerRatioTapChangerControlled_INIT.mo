within Dynawo.Electrical.Transformers.TransformersVariableTapControlled;

model TransformerRatioTapChangerControlled_INIT
  extends AdditionalIcons.Init;

  // Transformer phase tap changer parameters
  parameter Types.PerUnit RPu "Resistance of the generator transformer in pu (base U2Nom, SnRef)";
  parameter Types.PerUnit XPu "Reactance of the generator transformer in pu (base U2Nom, SnRef)";
  parameter Types.PerUnit GPu "Conductance of the generator transformer in pu (base U2Nom, SnRef)";
  parameter Types.PerUnit BPu "Susceptance of the generator transformer in pu (base U2Nom, SnRef)";
  parameter Integer NbTap "Number of taps";
  parameter Types.PerUnit RatioTfoMinPu "Minimum transformation ratio in pu: U2/U1 in no load conditions";
  parameter Types.PerUnit RatioTfoMaxPu "Maximum transformation ratio in pu: U2/U1 in no load conditions";
  parameter Integer tap0 "Initial tap";

  // Tap changer parameters
  parameter Boolean regulating0 "Whether the phase-shifter is initially regulating";
  parameter Types.VoltageModule U0 "Initial voltage";
  parameter Types.VoltageModule UDeadBand "Voltage dead-band";
  parameter Types.VoltageModule UTarget "Voltage set-point";

  // Transformer ratio tap changer initialization model
  Dynawo.Electrical.Transformers.TransformersVariableTap.TransformerRatioTapChanger_INIT transformerRatioTapChanger_INIT(AlphaTfo0 = AlphaTfo0, BPu = BPu, GPu = GPu, NbTap = NbTap, P10Pu = P10Pu, Q10Pu = Q10Pu, RPu = RPu, RatioTfoMaxPu = RatioTfoMaxPu, RatioTfoMinPu = RatioTfoMinPu, Tap0 = tap0, U10Pu = U10Pu, U1Phase0 = U1Phase0, XPu = XPu) annotation(
    Placement(visible = true, transformation(origin = {-30, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Tap changer with transformer initialization model
  Dynawo.Electrical.Controls.Transformers.TapChanger_INIT tapChanger_INIT(U0 = U0, UDeadBand = UDeadBand, UTarget = UTarget, regulating0 = regulating0)  annotation(
    Placement(visible = true, transformation(origin = {30, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  flow Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base U1Nom, SnRef) (receptor convention)";
  flow Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 in pu (base U2Nom, SnRef) (receptor convention)";
  Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base U1Nom)";
  Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2 in pu (base U2Nom)";
  Types.VoltageModulePu U20Pu "Start value of voltage amplitude at terminal 2 in pu (base U2Nom)";
  Boolean increaseTapToIncreaseValue "Whether increasing the tap will increase the monitored value";

  type State = enumeration(MoveDownN "1: phase shifter has decreased the next tap",
                           MoveDown1 "2: phase shifter has decreased the first tap",
                           WaitingToMoveDown "3: phase shifter is waiting to decrease the first tap",
                           Standard "4:phase shifter is in Standard state with UThresholdDown <= UMonitored <= UThresholdUp",
                           WaitingToMoveUp "5: phase shifter is waiting to increase the first tap",
                           MoveUp1 "6: phase shifter has increased the first tap",
                           MoveUpN "7: phase shifter has increased the next tap",
                           Locked "8: phase shifter locked");
  State state0 "Initial state";

  // Initial parameters
  parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.Angle AlphaTfo0 "Start value of transformation phase shift in rad";
  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base U1Nom)";
  parameter Types.Angle U1Phase0 "Start value of voltage angle at terminal 1 in rad";

equation
  i10Pu = transformerRatioTapChanger_INIT.i10Pu;
  i20Pu = transformerRatioTapChanger_INIT.i20Pu;
  u10Pu = transformerRatioTapChanger_INIT.u10Pu;
  u20Pu = transformerRatioTapChanger_INIT.u20Pu;
  U20Pu = transformerRatioTapChanger_INIT.U20Pu;
  increaseTapToIncreaseValue = tapChanger_INIT.increaseTapToIncreaseValue;
  state0 = tapChanger_INIT.state0;

end TransformerRatioTapChangerControlled_INIT;
