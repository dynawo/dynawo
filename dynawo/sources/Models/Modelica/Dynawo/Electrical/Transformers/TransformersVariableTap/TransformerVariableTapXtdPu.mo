within Dynawo.Electrical.Transformers.TransformersVariableTap;
model TransformerVariableTapXtdPu "Transformer with variable tap to be connected to a tap changer"
  /*
    Equivalent circuit and conventions:

                 I1  r                I2
      U1,P1,Q1 -->---oo----R+jX-------<-- U2,P2,Q2
    (terminal1)                   |      (terminal2)
                                 G+jB
                                  |
                                 ---

    The transformer ratio is variable.
  */
  extends Dynawo.Electrical.Transformers.BaseClasses.BaseTransformerVariableTap;
  extends AdditionalIcons.Transformer;

  // Transformer parameters
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  parameter Types.Percent R "Resistance in % (base U2Nom, SNom)";
  parameter Types.Percent X "Reactance in % (base U2Nom, SNom)";
  parameter Types.Percent G "Conductance in % (base U2Nom, SNom)";
  parameter Types.Percent B "Susceptance in % (base U2Nom, SNom)";

protected
  parameter Types.ComplexAdmittancePu YPu(re = G / 100 * SNom / SystemBase.SnRef, im = B / 100 * SNom / SystemBase.SnRef) "Transformer admittance in pu (base U2Nom, SnRef)";

  Types.ComplexImpedancePu ZPu(re(start = R / 100 * rTfo0Pu ^ 2 * SystemBase.SnRef / SNom), im(start = X / 100 * rTfo0Pu ^ 2 * SystemBase.SnRef / SNom)) "Transformer impedance in pu (base U2Nom, SnRef)";

equation
  ZPu = Complex(R, X) / 100 * rTfoPu ^ 2 * SystemBase.SnRef / SNom;

  if running then
    terminal1.i = rTfoPu * (YPu * terminal2.V - terminal2.i);
    ZPu * terminal1.i = rTfoPu * rTfoPu * terminal1.V - rTfoPu * terminal2.V;
  else
    terminal1.i = terminal2.i;
    terminal2.V = Complex(0);
  end if;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>This model is a variation of the TransformerVariableTap, where the impedance of side 2 is calculated from the impedance of side 1, therefore depending on the transformer ratio over time.</body></html>"));
end TransformerVariableTapXtdPu;
