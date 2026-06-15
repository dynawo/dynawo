within Dynawo.Electrical.Transformers.TransformersVariableTap;
model TransformerRatioTapChanger_INIT "Initialization model for TransformerRatioTapChanger"
  extends TransformersFixedTap.TransformerFixedRatioAndPhase_INIT(RatioTfo0Pu = RatioTfoMinPu + (RatioTfoMaxPu - RatioTfoMinPu) * (Tap0 / (NbTap - 1)));

  parameter Integer NbTap "Number of taps";
  parameter Types.PerUnit RatioTfoMinPu "Minimum transformation ratio in pu: U2/U1 in no load conditions";
  parameter Types.PerUnit RatioTfoMaxPu "Maximum transformation ratio in pu: U2/U1 in no load conditions";

  parameter Integer Tap0 "Start value of transformer tap";

  annotation(preferredView = "text");
end TransformerRatioTapChanger_INIT;
