within Dynawo.NonElectrical.Logs.Timeline;
function logEventRaw1
  extends Icons.Function;

  input String key1;

  external "C" addLogEventRaw1( key1) annotation(Include = "#include \"logEvent.h\"");

  annotation(preferredView = "text");
end logEventRaw1;
