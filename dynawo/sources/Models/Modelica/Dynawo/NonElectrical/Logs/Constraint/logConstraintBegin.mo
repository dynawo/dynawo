within Dynawo.NonElectrical.Logs.Constraint;
function logConstraintBegin "Create a begin constraint"
  extends Icons.Function;

  input Integer key;

  external "C" addLogConstraintBegin(key);

  annotation(preferredView = "text");
end logConstraintBegin;
