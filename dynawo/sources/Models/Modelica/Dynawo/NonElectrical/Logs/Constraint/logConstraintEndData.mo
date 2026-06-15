within Dynawo.NonElectrical.Logs.Constraint;
function logConstraintEndData "Create an end constraint with data"
  extends Icons.Function;

  input Integer key;

  input String kind;
  input Real limit;
  input Real value;
  input String param;

  external "C" addLogConstraintEndData(key, kind, limit, value, param) annotation(Include = "#include \"logConstraint.h\"");

  annotation(preferredView = "text");
end logConstraintEndData;
