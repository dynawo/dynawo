within Dynawo.Electrical.StaticVarCompensators;
model SVarCPVNoLimits "PV static var compensator model without mode handling and with no limits on susceptance"
  extends BaseClasses.BaseSVarC(BMaxPu = 99, BMinPu = -99);

equation
  if running then
    BPu = BVarPu + BShuntPu;
  else
    BPu = 0;
  end if;

  bStatus = BStatus.Standard;
  UPu = URefPu;

  annotation(preferredView = "text");
end SVarCPVNoLimits;
