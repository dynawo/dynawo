within Dynawo.NonElectrical.Logs.Timeline;
function logEvent2 "Print a log message in event file using the multi-language dictionary"
  extends Icons.Function;

  input Integer key;
  input String arg1;

  external "C" addLogEvent2(key, arg1) annotation(Include = "#include \"logEvent.h\"");

  annotation(preferredView = "text");
end logEvent2;
