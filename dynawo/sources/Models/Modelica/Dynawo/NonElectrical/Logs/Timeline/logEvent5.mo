within Dynawo.NonElectrical.Logs.Timeline;
function logEvent5 "Print a log message in event file using the multi-language dictionary"
  extends Icons.Function;

  input Integer key;
  input String arg1;
  input String arg2;
  input String arg3;
  input String arg4;

  external "C" addLogEvent5(key, arg1, arg2, arg3, arg4) annotation(Include = "#include \"logEvent.h\"");

  annotation(preferredView = "text");
end logEvent5;
