within Dynawo.Electrical.HVDC.HvdcPQProp;
model HvdcPQPropDangling_INIT "Initialisation model of HVDC link with a proportional reactive power control and with terminal 1 only"
  extends AdditionalIcons.Init;
  extends BaseClasses_INIT.BaseHVDC_INIT;
  extends BaseClasses_INIT.BaseQStatusDangling_INIT;
  extends BaseClasses.BaseFixedReactiveLimitsDangling;

  parameter Types.ActivePowerPu P1RefSetPu "Start value of active power reference at terminal 1 in pu (base SnRef) (receptor convention)";

equation
  P1Ref0Pu = P1RefSetPu;

  if - Q10Pu <= Q1MinPu then
    q1Status0 = QStatus.AbsorptionMax;
  elseif - Q10Pu >= Q1MaxPu then
    q1Status0 = QStatus.GenerationMax;
  else
    q1Status0 = QStatus.Standard;
  end if;

  annotation(preferredView = "text");
end HvdcPQPropDangling_INIT;
