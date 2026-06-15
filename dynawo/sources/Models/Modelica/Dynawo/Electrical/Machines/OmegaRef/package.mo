within Dynawo.Electrical.Machines;
package OmegaRef "Generator models that are based on OmegaRef for the frequency handling"
  extends Icons.Package;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> These generators models need a reference frequency omegaRefPu to work properly. This reference can be set by the user, or it can be handled by the cpp frequency handling model DYNModelOmegaRef, which computes a barycenter of the synchronous machines frequency omegaPu."));
end OmegaRef;
