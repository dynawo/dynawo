within Dynawo.Examples.Converters.IEC;

model VoltageSourceIEC63406_INIT
  Dynawo.Electrical.Sources.ConverterVoltageSourceIEC63406_INIT converterVoltageSourceIEC63406_INIT(BesPu = 0, GesPu = 0, IMaxPu = 1.3, P0Pu = 0.5, PMaxPu = 1, PriorityFlag = true, Q0Pu = 0.118, QLimFlag = true, QMaxUd = 0.8, QMinUd = -0.8, ResPu = 0.015, SNom = 100, StorageFlag = false, U0Pu = 1, UPhase0 = -0.237, XesPu = 0.15)  annotation(
    Placement(visible = true, transformation(origin = {3.55271e-15, 3.55271e-15}, extent = {{-60, -60}, {60, 60}}, rotation = 0)));
equation

annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end VoltageSourceIEC63406_INIT;
