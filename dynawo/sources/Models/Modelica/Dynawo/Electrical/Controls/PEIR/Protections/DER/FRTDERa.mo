within Dynawo.Electrical.Controls.PEIR.Protections.DER;
model FRTDERa "Frequency ride-through model for the der_a"
  import Modelica.Constants;

  parameter Types.PerUnit FlPu "Frequency threshold under which all inverters are disconnected in pu (base omegaNom)";
  parameter Types.Time tfl "Time-lag for under-frequency trips in s";
  parameter Types.PerUnit FhPu "Frequency threshold above which all inverters are disconnected in pu (base omegaNom)";
  parameter Types.Time tfh "Time-lag for over-frequency trips in s";

  Modelica.Blocks.Interfaces.RealInput fMonitoredPu "Monitored frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput connectedShare(start = 1) "Connected share";

  Types.Time tflReached(start = Constants.inf) "Time when fMonitoredPu dropped below FlPu in s";
  Types.Time tfhReached(start = Constants.inf) "Time when fMonitoredPu rised above FhPu in s";

equation
  // Low frequency
  when fMonitoredPu <= FlPu and pre(connectedShare) > 0 then
    tflReached = time;
  elsewhen fMonitoredPu > FlPu and pre(tflReached) <> Constants.inf and pre(connectedShare) > 0 then
    tflReached = Constants.inf;
  end when;

  // High frequency
  when fMonitoredPu >= FhPu and pre(connectedShare) > 0 then
    tfhReached = time;
  elsewhen fMonitoredPu < FhPu and pre(tfhReached) <> Constants.inf and pre(connectedShare) > 0 then
    tfhReached = Constants.inf;
  end when;

  when time - tflReached >= tfl or time - tfhReached >= tfh then
    connectedShare = 0;
  end when;

  annotation(preferredView = "text");
end FRTDERa;
