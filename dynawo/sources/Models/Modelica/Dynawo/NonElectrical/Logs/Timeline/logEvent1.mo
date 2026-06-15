within Dynawo.NonElectrical.Logs.Timeline;
function logEvent1 "Print a log message in event file using the multi-language dictionary"
  extends Icons.Function;

  input Integer key;

  external "C" addLogEvent1(key) annotation(Include = "#include \"logEvent.h\"");

  annotation(preferredView = "text");
end logEvent1;
