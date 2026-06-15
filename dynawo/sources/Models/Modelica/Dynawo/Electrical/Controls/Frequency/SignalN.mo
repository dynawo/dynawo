within Dynawo.Electrical.Controls.Frequency;
model SignalN "Model for frequency regulation"

  input Types.Angle thetaRef(start = 0) "Voltage angle reference";
  output Types.PerUnit N "Signal to change the active power reference setpoint of the generators participating in the primary frequency regulation in pu (base SnRef)";

equation
  der(thetaRef) = 0;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>All generators of the network are connected to this model through the signal N, which is common to all the generators in the same synchronous area and that changes the active power reference of the generators to balance the generation and the consumption. Moreover, the voltage angle of a chosen bus is fixed here to balance the number of equations and the number of variables. When using this model, the frequency is not explicitly modeled.</div></body></html>"));
end SignalN;
