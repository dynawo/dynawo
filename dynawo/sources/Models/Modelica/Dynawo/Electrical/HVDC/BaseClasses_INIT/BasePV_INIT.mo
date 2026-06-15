within Dynawo.Electrical.HVDC.BaseClasses_INIT;
partial model BasePV_INIT "Base initialization model for PV HVDC"

  parameter Types.ActivePowerPu P1RefSetPu "Start value of active power reference at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePower Q1Nom "Nominal reactive power in Mvar at terminal 1";

  Dynawo.Connectors.ReactivePowerPuConnector QInj10PuQNom "Reactive power at terminal 1 in pu (base Q1Nom) (generator convention)";
  Dynawo.Connectors.VoltageModulePuConnector U1Ref0Pu "Start value of the voltage regulation set point in pu (base UNom) at terminal 1";

  parameter Types.PerUnit Lambda1Pu "Parameter Lambda of the voltage regulation law U1RefPu = U1Pu + Lambda1Pu * QInj1Pu, in pu (base UNom, SnRef) at terminal 1";
  final parameter Boolean UseLambda1 = not
                                          (Lambda1Pu == 0) "If true, the voltage regulation follows the law U1RefPu = U1Pu + Lambda1Pu * QInj1Pu at terminal 1";

equation

  annotation(preferredView = "text");
end BasePV_INIT;
