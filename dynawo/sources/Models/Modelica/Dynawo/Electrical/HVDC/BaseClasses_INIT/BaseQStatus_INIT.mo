within Dynawo.Electrical.HVDC.BaseClasses_INIT;
partial model BaseQStatus_INIT "Base initialization model for QStatus"
  extends BaseClasses_INIT.BaseQStatusDangling_INIT;

  Boolean limUQDown20 "Whether the minimum reactive power limits are reached or not at terminal 2, start value";
  Boolean limUQUp20 "Whether the maximum reactive power limits are reached or not at terminal 2, start value";
  QStatus q2Status0 "Start voltage regulation status of terminal 2: Standard, AbsorptionMax, GenerationMax";

equation
  limUQDown20 = q2Status0 == QStatus.AbsorptionMax;
  limUQUp20 = q2Status0 == QStatus.GenerationMax;

  annotation(preferredView = "text");
end BaseQStatus_INIT;
