within Dynawo.NonElectrical.Logs.Timeline;
function logEventRaw4
  extends Icons.Function;

  input String key1;
  input String key2;
  input String key3;
  input String key4;

  external "C" addLogEventRaw4( key1, key2, key3, key4) annotation(Include = "#include \"logEvent.h\"");

  annotation(preferredView = "text");
end logEventRaw4;
