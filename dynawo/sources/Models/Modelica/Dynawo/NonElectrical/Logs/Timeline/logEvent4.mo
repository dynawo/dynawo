within Dynawo.NonElectrical.Logs.Timeline;
function logEvent4 "Print a log message in event file using the multi-language dictionary"
  extends Icons.Function;

  input Integer key;
  input String arg1;
  input String arg2;
  input String arg3;

  external "C" addLogEvent4(key, arg1, arg2, arg3) annotation(Include = "#include \"logEvent.h\"");

  annotation(preferredView = "text");
end logEvent4;
