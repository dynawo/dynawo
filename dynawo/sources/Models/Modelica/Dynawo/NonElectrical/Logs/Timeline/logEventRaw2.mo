within Dynawo.NonElectrical.Logs.Timeline;
function logEventRaw2
  extends Icons.Function;

  input String key1;
  input String key2;

  external "C" addLogEventRaw2( key1, key2) annotation(Include = "#include \"logEvent.h\"");

  annotation(preferredView = "text");
end logEventRaw2;
