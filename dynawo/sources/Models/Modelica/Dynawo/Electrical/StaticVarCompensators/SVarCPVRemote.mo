within Dynawo.Electrical.StaticVarCompensators;
model SVarCPVRemote "PV static var compensator model with remote voltage regulation without mode handling"
  extends BaseClasses.BaseSVarC;

  input Types.VoltageModulePu URegulatedPu "Regulated voltage in pu (base UNomRemote)";

equation
  when BVarPu >= BMaxPu and URegulatedPu <= URefPu then
    bStatus = BStatus.SusceptanceMax;
  elsewhen BVarPu <= BMinPu and URegulatedPu >= URefPu then
    bStatus = BStatus.SusceptanceMin;
  elsewhen (BVarPu < BMaxPu or URegulatedPu > URefPu) and (BVarPu > BMinPu or URegulatedPu < URefPu) then
    bStatus = BStatus.Standard;
  end when;

  if running then
    BPu = BVarPu + BShuntPu;
    if bStatus == BStatus.Standard then
      URegulatedPu = URefPu;
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
end SVarCPVRemote;
