within Dynawo.Electrical.Events;
model NodeFault "Node fault which lasts from tBegin to tEnd"
  /*
    Between tBegin and tEnd, the impedance between the node and the ground is equal to ZPu.
  */
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  Dynawo.Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(origin = {2, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput nodeFault(start = false) "True when the fault is ongoing, false otherwise";

  parameter Types.PerUnit RPu "Fault resistance in pu (base SnRef)";
  parameter Types.PerUnit XPu "Fault reactance in pu (base SnRef)";
  parameter Types.Time tBegin "Time when the fault begins";
  parameter Types.Time tEnd "Time when the fault ends";

protected
  parameter Types.ComplexImpedancePu ZPu(re = RPu, im = XPu) "Impedance of the fault in pu (base SnRef)";

equation
  when time >= tEnd then
    Timeline.logEvent1(TimelineKeys.NodeFaultEnd);
    nodeFault = false;
  elsewhen time >= tBegin then
    Timeline.logEvent1(TimelineKeys.NodeFaultBegin);
    nodeFault = true;
  end when;

  if nodeFault then
    terminal.V = ZPu * terminal.i;
  else
    terminal.i = Complex(0);
  end if;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>During the fault, the impedance between the node and the ground is defined by R and X values.</body></html>"),
    Icon(graphics = {Polygon(origin = {0, 55}, fillPattern = FillPattern.Solid, points = {{0, 45}, {-6, 5}, {20, 5}, {0, -45}, {6, -5}, {-20, -5}, {0, 45}, {0, 45}})}));
end NodeFault;
