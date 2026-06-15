within Dynawo.Electrical.Machines;
package SignalN "Generator models that are based on SignalN for the frequency handling"
  extends Icons.Package;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> These generators models provide an active power PGenPu that depends on their setpoint PGen0Pu and their participation in an emulated frequency regulation that calculates the signal N, that is common to all the generators in a connected component and which increases or decreases the generation of each generator.<div>This model is used with the frequency handling model SignalN and cannot be used with DYNModelOmegaRef as the frequency is not explicitly expressed.</div></body></html>"));
end SignalN;
