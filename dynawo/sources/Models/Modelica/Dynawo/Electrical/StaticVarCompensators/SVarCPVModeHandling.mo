within Dynawo.Electrical.StaticVarCompensators;
model SVarCPVModeHandling "PV static var compensator model with mode handling"
  import Dynawo.Electrical.StaticVarCompensators.BaseControls.Mode;

  extends BaseClasses.BaseSVarC;
  extends BaseClasses.BaseModeHandling;
  extends BaseControls.Parameters.ParamsModeHandling;

  parameter Types.VoltageModule UNom "Static var compensator nominal voltage in kV";

  input Types.VoltageModule URef(start = URef0Pu * UNom) "Voltage reference for the regulation in kV";

  BaseControls.ModeHandling modeHandling(Mode0 = Mode0, UNom = UNom, URefDown = URefDown, URefUp = URefUp, UThresholdDown = UThresholdDown, UThresholdUp = UThresholdUp, tThresholdDown = tThresholdDown, tThresholdUp = tThresholdUp, URef0 = URef0Pu * UNom);

equation
  UPu = modeHandling.UPu;
  URef = modeHandling.URef;
  URefPu = modeHandling.URefPu;
  selectModeAuto = modeHandling.selectModeAuto;
  setModeManual = modeHandling.setModeManual;

  when BVarPu >= BMaxPu and UPu <= URefPu then
    bStatus = BStatus.SusceptanceMax;
  elsewhen BVarPu <= BMinPu and UPu >= URefPu then
    bStatus = BStatus.SusceptanceMin;
  elsewhen (BVarPu < BMaxPu or UPu > URefPu) and (BVarPu > BMinPu or UPu < URefPu) then
    bStatus = BStatus.Standard;
  end when;

  if modeHandling.mode.value == Mode.RUNNING_V then
    BPu = BVarPu + BShuntPu;
  elseif modeHandling.mode.value == Mode.STANDBY then
    BPu = BShuntPu;
  else
    BPu = 0;
  end if;

  if running then
    if modeHandling.mode.value == Mode.RUNNING_V then
      if bStatus == BStatus.Standard then
        UPu = URefPu;
      elseif bStatus == BStatus.SusceptanceMax then
        BVarPu = BMaxPu;
      else
        BVarPu = BMinPu;
      end if;
    else
      BVarPu = 0;
    end if;
  else
    BVarPu = 0;
  end if;

  annotation(preferredView = "text");
end SVarCPVModeHandling;
