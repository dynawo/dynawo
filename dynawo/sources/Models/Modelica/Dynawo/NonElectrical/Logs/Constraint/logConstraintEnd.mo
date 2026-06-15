within Dynawo.NonElectrical.Logs.Constraint;
function logConstraintEnd "Create an end constraint"
  extends Icons.Function;

  input Integer key;

  external "C" addLogConstraintEnd(key);

  annotation(preferredView = "text");
end logConstraintEnd;
