within Dynawo.Electrical.HVDC.BaseClasses;
partial model BaseVoltageRegulationDangling "Base dynamic model for Hvdc voltage regulation at terminal 1"

  input Boolean modeU1(start = modeU10) "Boolean assessing the mode of the control of converter 1: true if U mode (here a proportional Q regulation), false if Q mode (fixed Q)";
  input Types.ReactivePowerPu Q1RefPu(start = Q1Ref0Pu) "Reactive power regulation set point in pu (base SnRef) (receptor convention) at terminal 1";

  parameter Boolean modeU10 "Start value of the boolean assessing the mode of the control of converter 1";
  parameter Types.ReactivePowerPu Q1Ref0Pu "Start value of reactive power regulation set point in pu (base SnRef) (receptor convention) at terminal 1";

  annotation(preferredView = "text");
end BaseVoltageRegulationDangling;
