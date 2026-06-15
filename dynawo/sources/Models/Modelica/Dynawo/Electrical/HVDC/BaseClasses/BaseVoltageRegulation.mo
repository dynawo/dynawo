within Dynawo.Electrical.HVDC.BaseClasses;
partial model BaseVoltageRegulation "Base dynamic model for Hvdc voltage regulation"
  extends BaseClasses.BaseVoltageRegulationDangling;

  input Boolean modeU2(start = modeU20) "Boolean assessing the mode of the control of converter 2: true if U mode (here a proportional Q regulation), false if Q mode (fixed Q)";
  input Types.ReactivePowerPu Q2RefPu(start = Q2Ref0Pu) "Reactive power regulation set point in pu (base SnRef) (receptor convention) at terminal 2";

  parameter Boolean modeU20 "Start value of the boolean assessing the mode of the control of converter 2";
  parameter Types.ReactivePowerPu Q2Ref0Pu "Start value of reactive power regulation set point in pu (base SnRef) (receptor convention) at terminal 2";

  annotation(preferredView = "text");
end BaseVoltageRegulation;
