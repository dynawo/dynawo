within Dynawo.Examples.RVS.Components.TransformerWithControl.BaseClasses;
model InitializedTransformerVariableTap "Model of transformer with variable tap and built-in initialization, for the RVS test system"
  import Dynawo.Examples.RVS.Components.TransformerWithControl.BaseClasses.TransformerParameters;

  extends Dynawo.Electrical.Transformers.TransformersVariableTapControlled.TransformerVariableTapXtdPuControlled(
    Tap0(fixed = false),
    rTfo0Pu(fixed = false),
    rTfoMaxPu = TransformerParameters.rTfoMaxPu,
    rTfoMinPu = TransformerParameters.rTfoMinPu,
    transformerVariableTap(
    rTfoPu(                       fixed = true)),
    NbTap = TransformerParameters.NbTap,
    U20Pu(fixed = false),
    u10Pu(
    re(      fixed = false),
    im(      fixed = false)),
    i10Pu(
    re(      fixed = false),
    im(      fixed = false)),
    u20Pu(
    re(      fixed = false),
    im(      fixed = false)),
    i20Pu(
    re(      fixed = false),
    im(      fixed = false))
                           );

  Dynawo.Electrical.Transformers.TransformersVariableTap.TransformerVariableTapPQ_INIT init(
    rTfoMinPu = TransformerParameters.rTfoMinPu,
    rTfoMaxPu = TransformerParameters.rTfoMaxPu,
    NbTap = TransformerParameters.NbTap,
    SNom = SNom, R = R, X = X, G = G, B = B,
    P10Pu = P10Pu, Q10Pu = Q10Pu, U10Pu = U10Pu, U1Phase0 = U1Phase0, Uc20Pu = Uc20Pu);

  Dynawo.Connectors.ACPower terminal20;

  parameter Types.VoltageModulePu Uc20Pu "Voltage set-point on side 2 in pu (base U2Nom)";
  parameter Types.Angle U1Phase0 "Start value of voltage angle at terminal 1 in rad";

initial algorithm
  Tap0 := init.Tap0;
  rTfo0Pu := init.rTfo0Pu;
  u10Pu.re := init.u10Pu.re;
  u10Pu.im := init.u10Pu.im;
  i10Pu.re := init.i10Pu.re;
  i10Pu.im := init.i10Pu.im;
  u20Pu.re := init.u20Pu.re;
  u20Pu.im := init.u20Pu.im;
  i20Pu.re := init.i20Pu.re;
  i20Pu.im := init.i20Pu.im;
  U20Pu := init.U20Pu;

equation
  connect(terminal20, init.terminal20);

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>This model implements a transformer with variable tap which is automatically initialized by an initialization model.<div>The parameters and the initial values of side 1 are passed to the initialization model, which in turn calculates the necessary initial tap, ratio and load flow.</div><div>The calculated values are then assigned to the respective transformer parameters in an initial algorithm section. This way, the transformer has appropriate parameters before the simulation starts. The model cannot use equations due to variability conflict (parameters and variables), therefore the assignment operator must be used. This is permissible, because the initial values do not change during simulation.</div></body></html>"));
end InitializedTransformerVariableTap;
