within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters;
record ParamsQRefQU "Parameters of reactive power reference calculation"
  parameter Types.PerUnit KiAc "Integral coefficient of the PI controller for the AC voltage control";
  parameter Types.PerUnit KpAc "Proportional coefficient of the PI controller for the AC voltage control";
  parameter Types.PerUnit LambdaPu "Lambda coefficient for the QRefUPu calculation in pu (base SNom, UNom)";
  parameter Types.PerUnit SlopeQRefPu "Slope of the ramp of QRefPu in pu/s (base SNom)";
  parameter Types.PerUnit SlopeURefPu "Slope of the ramp of URefPu in pu/s (base UNom)";

  annotation(preferredView = "text");
end ParamsQRefQU;
