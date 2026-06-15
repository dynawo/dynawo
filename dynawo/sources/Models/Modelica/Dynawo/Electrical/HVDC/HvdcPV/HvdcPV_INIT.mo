within Dynawo.Electrical.HVDC.HvdcPV;
model HvdcPV_INIT "Initialisation model of PV HVDC link"
  extends AdditionalIcons.Init;
  extends BaseClasses_INIT.BaseHVDC_INIT;
  extends BaseClasses_INIT.BaseQStatus_INIT;
  extends BaseClasses.BaseFixedReactiveLimits;
  extends BaseClasses_INIT.BasePV_INIT;

  final parameter Types.ReactivePowerPu QInj10Pu=-Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (generator convention)";

equation
  P1Ref0Pu = P1RefSetPu;
  QInj10PuQNom = QInj10Pu * SystemBase.SnRef / Q1Nom;

  if - Q10Pu <= Q1MinPu then
    q1Status0 = QStatus.AbsorptionMax;
  elseif - Q10Pu >= Q1MaxPu then
    q1Status0 = QStatus.GenerationMax;
  else
    q1Status0 = QStatus.Standard;
  end if;

  if - Q20Pu <= Q2MinPu then
    q2Status0 = QStatus.AbsorptionMax;
  elseif - Q20Pu >= Q2MaxPu then
    q2Status0 = QStatus.GenerationMax;
  else
    q2Status0 = QStatus.Standard;
  end if;


  if UseLambda1 then
    U10Pu + Lambda1Pu * QInj10Pu = U1Ref0Pu;
  else
    U1Ref0Pu = U10Pu;
  end if;

  annotation(preferredView = "text");
end HvdcPV_INIT;
