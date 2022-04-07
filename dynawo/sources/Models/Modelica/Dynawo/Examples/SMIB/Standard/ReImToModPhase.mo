within Dynawo.Examples.SMIB.Standard;

model ReImToModPhase

  Real Re=-0.874911;
  Real Im=-0.115981;
  Real Mod;
  Real Phase;

equation

  ComplexMath.fromPolar(Mod,Phase)=Complex(Re,Im);

end ReImToModPhase;
