within Dynawo.Examples.Converters.IEC;

model CurrentSourceIEC63406_INIT
  Dynawo.Electrical.Sources.ConverterCurrentSourceIEC63406_INIT converterCurrentSourceIEC63406_INIT(BesPu = 0, GesPu = 0, IMaxPu = 1.3, P0Pu = -0.5, PMaxPu = 1, PriorityFlag = true, Q0Pu = 0.289, QLimFlag = false, QMaxUd = 0.8, QMinUd = -0.8, ResPu = 0, SNom = 1000, StorageFlag = false, U0Pu = 1, UPhase0 = 0.081, XesPu = 0)  annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-60, -60}, {60, 60}}, rotation = 0)));
equation

annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end CurrentSourceIEC63406_INIT;
