within Dynawo.Electrical.StaticVarCompensators;
model SVarCPV "PV static var compensator model without mode handling"
  extends BaseClasses.BaseSVarC;

equation
  when BVarPu >= BMaxPu and UPu <= URefPu then
    bStatus = BStatus.SusceptanceMax;
  elsewhen BVarPu <= BMinPu and UPu >= URefPu then
    bStatus = BStatus.SusceptanceMin;
  elsewhen (BVarPu < BMaxPu or UPu > URefPu) and (BVarPu > BMinPu or UPu < URefPu) then
    bStatus = BStatus.Standard;
  end when;

  if running then
    BPu = BVarPu + BShuntPu;
    if bStatus == BStatus.Standard then
      UPu = URefPu;
    elseif bStatus == BStatus.SusceptanceMax then
      BVarPu = BMaxPu;
    else
      BVarPu = BMinPu;
    end if;
  else
    BVarPu = 0;
    BPu = 0;
  end if;

  annotation(preferredView = "text");
end SVarCPV;
