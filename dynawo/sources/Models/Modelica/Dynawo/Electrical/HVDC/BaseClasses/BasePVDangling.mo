within Dynawo.Electrical.HVDC.BaseClasses;
partial model BasePVDangling "Base dynamic model for PV control at terminal 1"

  parameter Types.PerUnit Lambda1Pu "Parameter Lambda of the voltage regulation law U1RefPu = U1Pu + Lambda1Pu * QInj1Pu, in pu (base UNom, SnRef) at terminal 1";
  parameter Types.ReactivePower Q1Nom "Nominal reactive power in Mvar at terminal 1";

  final parameter Boolean UseLambda1 = not
                                          (Lambda1Pu == 0) "If true, the voltage regulation follows the law U1RefPu = U1Pu + Lambda1Pu * QInj1Pu at terminal 1";

  input Dynawo.Connectors.VoltageModulePuConnector U1RefPu(start = U1Ref0Pu) "Voltage regulation set point in pu (base UNom) at terminal 1";

  Dynawo.Connectors.ReactivePowerPuConnector QInj1PuQNom "Reactive power at terminal 1 in pu (base Q1Nom) (generator convention)";
  Types.ReactivePower QInj1 "Reactive power at terminal 1 in MVar (generator convention)";

  parameter Types.VoltageModulePu U1Ref0Pu "Start value of the voltage regulation set point in pu (base UNom) at terminal 1";

equation
  QInj1 = QInj1PuQNom * Q1Nom;

  annotation(preferredView = "text");
end BasePVDangling;
