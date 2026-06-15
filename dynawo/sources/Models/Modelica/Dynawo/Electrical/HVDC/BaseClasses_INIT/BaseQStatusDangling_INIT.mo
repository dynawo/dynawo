within Dynawo.Electrical.HVDC.BaseClasses_INIT;
partial model BaseQStatusDangling_INIT "Base initialization model for QStatus at terminal 1"

  type QStatus = enumeration(Standard "Reactive power is fixed to its initial value",
                             AbsorptionMax "Reactive power is fixed to its absorption limit",
                             GenerationMax "Reactive power is fixed to its generation limit");

  Modelica.Blocks.Interfaces.BooleanOutput limUQDown10 "Whether the minimum reactive power limits are reached or not at terminal 1, start value";
  Modelica.Blocks.Interfaces.BooleanOutput limUQUp10 "Whether the maximum reactive power limits are reached or not at terminal 1, start value";
  QStatus q1Status0 "Start voltage regulation status of terminal 1: Standard, AbsorptionMax, GenerationMax";

equation
  limUQDown10 = q1Status0 == QStatus.AbsorptionMax;
  limUQUp10 = q1Status0 == QStatus.GenerationMax;

  annotation(preferredView = "text");
end BaseQStatusDangling_INIT;
