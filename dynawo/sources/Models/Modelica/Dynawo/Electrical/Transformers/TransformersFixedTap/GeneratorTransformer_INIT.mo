within Dynawo.Electrical.Transformers.TransformersFixedTap;
model GeneratorTransformer_INIT
  extends BaseClasses_INIT.BaseGeneratorTransformer_INIT;
  extends AdditionalIcons.Init;

  // Transformer internal parameters
  parameter Types.PerUnit rTfoPu "Transformation ratio in pu: U2/U1 in no load conditions";
  parameter Types.PerUnit RPu "Resistance of the generator transformer in pu (base U2Nom, SnRef)";
  parameter Types.PerUnit BPu "Susceptance of the generator transformer in pu (base U2Nom, SnRef)";
  parameter Types.PerUnit XPu "Reactance of the generator transformer in pu (base U2Nom, SnRef)";
  parameter Types.PerUnit GPu "Conductance of the generator transformer in pu (base U2Nom, SnRef)";

  // Transformer parameters
  parameter Types.ComplexImpedancePu ZPu = Complex(RPu, XPu) "Impedance in pu (base U2Nom, SnRef)";
  parameter Types.ComplexAdmittancePu YPu = Complex(GPu, BPu) "Admittance in pu (base U2Nom, SnRef)";

equation
  // Transformer equations
  i10Pu = rTfoPu * (YPu * u20Pu - i20Pu);
  rTfoPu * rTfoPu * u10Pu = rTfoPu * u20Pu + ZPu * i10Pu;
  // Equations could also be written with the following
  // i10Pu = rTfoPu * rTfoPu * u10Pu / ZPu - rTfoPu * u20Pu / ZPu;
  // i20Pu = - rTfoPu * u10Pu / ZPu + (1 / ZPu + YPu) * u20Pu;

  annotation(preferredView = "text");
end GeneratorTransformer_INIT;
