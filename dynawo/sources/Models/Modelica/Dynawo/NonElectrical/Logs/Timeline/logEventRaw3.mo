within Dynawo.NonElectrical.Logs.Timeline;
function logEventRaw3
  extends Icons.Function;

  input String key1;
  input String key2;
  input String key3;

  external "C" addLogEventRaw3( key1, key2, key3) annotation(Include = "#include \"logEvent.h\"");

  annotation(preferredView = "text");
end logEventRaw3;
