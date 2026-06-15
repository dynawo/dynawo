within Dynawo.Electrical.Transformers.TransformersVariableTap;
model TransformerVariableTap "Transformer with variable tap to be connected to a tap changer"

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
  extends BaseClasses.BaseTransformerVariableTap;
  extends AdditionalIcons.Transformer;

  // Transformer's parameters
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  parameter Types.Percent R "Resistance in % (base U2Nom, SNom)";
  parameter Types.Percent X "Reactance in % (base U2Nom, SNom)";
  parameter Types.Percent G "Conductance in % (base U2Nom, SNom)";
  parameter Types.Percent B "Susceptance in % (base U2Nom, SNom)";

protected
  parameter Types.ComplexImpedancePu ZPu(re = R / 100 * SystemBase.SnRef / SNom, im = X / 100 * SystemBase.SnRef / SNom) "Transformer impedance in pu (base U2Nom, SnRef)";
  parameter Types.ComplexAdmittancePu YPu(re = G / 100 * SNom / SystemBase.SnRef, im = B / 100 * SNom / SystemBase.SnRef) "Transformer admittance in pu (base U2Nom, SnRef)";

equation
  if running then
    // Transformer equations
    terminal1.i = rTfoPu * (YPu * terminal2.V - terminal2.i);
    ZPu * terminal1.i = rTfoPu * rTfoPu * terminal1.V - rTfoPu * terminal2.V;
  else
    terminal1.i = terminal2.i;
    terminal2.V = Complex(0);
  end if;

  annotation(preferredView = "text");
end TransformerVariableTap;
