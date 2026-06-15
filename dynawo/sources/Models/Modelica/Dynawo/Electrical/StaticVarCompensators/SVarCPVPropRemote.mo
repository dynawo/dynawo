within Dynawo.Electrical.StaticVarCompensators;
model SVarCPVPropRemote "PV static var compensator model with remote voltage regulation, slope and without mode handling"
  extends BaseClasses.BaseSVarC;

  parameter Types.PerUnit LambdaPu "Statism of the regulation law URefPu = UPu + LambdaPu*QPu in pu (base UNomRemote, SnRef)";

  input Types.VoltageModulePu URegulatedPu "Regulated voltage in pu (base UNomRemote)";

  Types.PerUnit BVarRawPu(start = BVar0Pu) "Raw variable susceptance of the static var compensator in pu (base UNomLocal, SnRef)";

equation
  when BVarRawPu >= BMaxPu and pre(bStatus) <> BStatus.SusceptanceMax then
    bStatus = BStatus.SusceptanceMax;
  elsewhen BVarRawPu <= BMinPu and pre(bStatus) <> BStatus.SusceptanceMin then
    bStatus = BStatus.SusceptanceMin;
  elsewhen (BVarRawPu < BMaxPu and BVarRawPu > BMinPu) and pre(bStatus) <> BStatus.Standard then
    bStatus = BStatus.Standard;
  end when;

  URefPu = URegulatedPu + LambdaPu * (BVarRawPu + BShuntPu) * UPu ^ 2;
  BVarPu = if BVarRawPu > BMaxPu then BMaxPu elseif BVarRawPu < BMinPu then BMinPu else BVarRawPu;

  if running then
    BPu = BVarPu + BShuntPu;
  else
    BPu = 0;
  end if;

  annotation(preferredView = "text");
end SVarCPVPropRemote;
