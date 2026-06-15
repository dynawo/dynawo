within Dynawo.Electrical.PEIR.Plants.DER;
model DERa_INIT "Initialization model for IBGs"
  extends Electrical.Sources.InjectorIDQ_INIT;

protected
  Types.PerUnit PF0 "Start value of power factor";

equation
  PF0 =if (not (Modelica.ComplexMath.abs(s0Pu) == 0)) then P0Pu/Modelica.ComplexMath.abs(s0Pu)
     else 0;

  annotation(preferredView = "text");
end DERa_INIT;
