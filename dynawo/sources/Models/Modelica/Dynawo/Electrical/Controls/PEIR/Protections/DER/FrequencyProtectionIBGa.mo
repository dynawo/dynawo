within Dynawo.Electrical.Controls.PEIR.Protections.DER;
model FrequencyProtectionIBGa "Frequency protection of aggregated IBG"
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  parameter Types.AngularVelocityPu OmegaMaxPu "Maximum frequency before full disconnection in pu (base omegaNom)";
  parameter Types.AngularVelocityPu OmegaMinPu "Minimum frequency before first disconnection in pu (base omegaNom)";
  parameter Types.AngularVelocityPu p "Additional frequency drop that leads to full trip of units in pu (base omegaNom)";
  parameter Types.PerUnit r(min = 0, max = 1) "Share of units that trip at OmegaMinPu";
  parameter Types.Time tFilter = 1e-2 "Filter time constant for computation of omegaMeasuredMinPu in s";

  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.BooleanOutput switchOffSignal(start = false) "Switch off message for the generator";

  Types.PerUnit fFrequency(start = 1) "Partial tripping coefficient, equals to 1 if no trip, 0 if fully tripped";
  Types.AngularVelocityPu omegaMeasuredMinPu(start = 1) "Minimum measured frequency in pu (base omegaNom)";

equation
  when omegaPu > OmegaMaxPu and not
                                   (pre(switchOffSignal)) then
    switchOffSignal = true;
    Timeline.logEvent1(TimelineKeys.OverspeedTripped);
  elsewhen omegaPu < OmegaMinPu - p and not
                                           (pre(switchOffSignal)) then
    switchOffSignal = true;
    Timeline.logEvent1(TimelineKeys.UnderspeedTripped);
  end when;

  omegaMeasuredMinPu + tFilter * der(omegaMeasuredMinPu) = if omegaPu < omegaMeasuredMinPu then omegaPu else omegaMeasuredMinPu;

  if omegaMeasuredMinPu > OmegaMinPu then
    fFrequency = 1;
  elseif omegaMeasuredMinPu > OmegaMinPu - p then
    fFrequency = r * (OmegaMinPu - omegaMeasuredMinPu) / p;
  else
    fFrequency = 0;
  end if;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>The unit will be disconnected if the frequency gets out of the range [OmegaMinPu -p, OmegaMaxPu].</body></html>"));
end FrequencyProtectionIBGa;
