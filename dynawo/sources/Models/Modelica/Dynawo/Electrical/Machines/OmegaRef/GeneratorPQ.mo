within Dynawo.Electrical.Machines.OmegaRef;
model GeneratorPQ "Generator with power / frequency modulation and fixed reactive power"
  /*
  The P output is modulated according to frequency (in order to model frequency containment reserves)
  The Q output is fixed equal to its initial value QGen0Pu
  */

  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends BaseClasses.BaseGeneratorSimplifiedPFBehavior;
  extends AdditionalIcons.Machine;

equation
  if running then
    QGenPu = QGen0Pu;
  else
    terminal.i.im = 0;
  end if;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>The active power output is modulated according to frequency (in order to model frequency containment reserves).<div>The reactive power output is fixed equal to its initial value QGen0Pu.</div></body></html>"));
end GeneratorPQ;
