within Dynawo.Electrical.Transformers.BaseClasses_INIT;
partial model BaseTransformerVariableTapCommon_INIT "Base model for initialization of transformers with variable tap"

/*
  The initialization scheme is specific and considers that the values on only one side of the transformer are known plus the voltage set point on the other side.
  From these values, the tap position and its corresponding ratio are determined.
  From the tap and ratio values, the final U2, P2 and Q2 values are calculated.
*/

  // Transformer parameters
  parameter Types.PerUnit rTfoMinPu "Minimum transformation ratio in pu: U2/U1 in no load conditions";
  parameter Types.PerUnit rTfoMaxPu "Maximum transformation ratio in pu: U2/U1 in no load conditions";
  parameter Integer NbTap "Number of taps";
  parameter Types.VoltageModulePu Uc20Pu "Voltage set-point on side 2 in pu (base U2Nom)";

  // Transformer start values
  Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2 in pu (base U2Nom)";
  Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 in pu (base U2Nom, SnRef) (receptor convention)";
  Types.VoltageModulePu U20Pu "Start value of voltage amplitude at terminal 2 in pu (base U2Nom)";

  // Terminal for init connections
  Dynawo.Connectors.ACPower terminal20 "Connector on side 2 at initialization";

  Integer Tap0 "Start value of transformer tap";
  Types.PerUnit rTfo0Pu "Start value of transformer ratio";
  Constants.state state0 = Constants.state.Closed "Start value of connection state";

equation
  // Initial ratio estimation
  if (NbTap == 1) then
    rTfo0Pu = rTfoMinPu;
  else
    rTfo0Pu = rTfoMinPu + (rTfoMaxPu - rTfoMinPu) * (Tap0 / (NbTap - 1));
  end if;

  // Voltage at terminal 2
  U20Pu =Modelica.ComplexMath.abs(u20Pu);
  u20Pu = terminal20.V;
  i20Pu = terminal20.i;

  annotation(preferredView = "text");
end BaseTransformerVariableTapCommon_INIT;
