within Dynawo.NonElectrical.Logs.Constraint;
function logConstraintBeginData "Create a begin constraint with data"
  extends Icons.Function;

  input Integer key;

  input String kind;
  input Real limit;
  input Real value;
  input String param;

  external "C" addLogConstraintBeginData(key, kind, limit, value, param) annotation(Include = "#include \"logConstraint.h\"");

  annotation(preferredView = "text");
end logConstraintBeginData;
