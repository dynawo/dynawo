within Dynawo.NonElectrical.Logs.Timeline;
function logEvent3 "Print a log message in event file using the multi-language dictionary"
  extends Icons.Function;

  input Integer key;
  input String arg1;
  input String arg2;

  external "C" addLogEvent3(key, arg1, arg2) annotation(Include = "#include \"logEvent.h\"");

  annotation(preferredView = "text");
end logEvent3;
