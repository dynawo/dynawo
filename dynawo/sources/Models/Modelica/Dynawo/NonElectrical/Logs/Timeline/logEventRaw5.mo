within Dynawo.NonElectrical.Logs.Timeline;
function logEventRaw5
  extends Icons.Function;

  input String key1;
  input String key2;
  input String key3;
  input String key4;
  input String key5;

  external "C" addLogEventRaw5( key1, key2, key3, key4, key5) annotation(Include = "#include \"logEvent.h\"");

  annotation(preferredView = "text");
end logEventRaw5;
