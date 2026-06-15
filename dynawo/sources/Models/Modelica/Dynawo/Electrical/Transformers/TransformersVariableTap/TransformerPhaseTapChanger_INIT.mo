within Dynawo.Electrical.Transformers.TransformersVariableTap;
model TransformerPhaseTapChanger_INIT "Initialization model for TransformerPhaseTapChanger"
  extends TransformersFixedTap.TransformerFixedRatioAndPhase_INIT(AlphaTfo0 = AlphaTfoMin + (AlphaTfoMax - AlphaTfoMin) * (Tap0 / (NbTap - 1)));

  parameter Integer NbTap "Number of taps";
  parameter Types.Angle AlphaTfoMin "Minimum phase shift in rad";
  parameter Types.Angle AlphaTfoMax "Maximum phase shift in rad";

  parameter Integer Tap0 "Start value of transformer tap";

  annotation(preferredView = "text");
end TransformerPhaseTapChanger_INIT;
