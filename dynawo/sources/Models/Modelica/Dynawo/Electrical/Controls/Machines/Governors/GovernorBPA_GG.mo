within Dynawo.Electrical.Controls.Machines.Governors;

model GovernorBPA_GG "Governor BPA GG"

  import Modelica;
  import Dynawo;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;
  type status = enumeration(Standard "Active power is modulated by the frequency deviation",
                            LimitPMin "Active power is fixed to its minimum value",
                            LimitPMax "Active power is fixed to its maximum value");

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, -46}, extent = {{-14, -14}, {14, 14}}, rotation = 90), iconTransformation(origin = {-160, -54}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PmRefPu(start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {-25, -45}, extent = {{-13, -13}, {13, 13}}, rotation = 90), iconTransformation(origin = {-150, 58}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {116, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit KGover "Mechanical power sensitivity to frequency";
  parameter Types.ActivePower PMin "Minimum mechanical power in MW";
  parameter Types.ActivePower PMax "Maximum mechanical power in MW";
  // may be negative (for power plants which may be pumping)
  parameter Types.ActivePower PNom "Nominal active power in MW";

  parameter Types.Time T1 "Control time constant (governor delay) in s";
  parameter Types.Time T2 "Hydro reset time constant in s";
  parameter Types.Time T3 "Servo time constant in s";
  parameter Types.Time T4 "Steam valve bowl time constant in s";
  parameter Types.Time T5 "Steam reheat time constant in s";
  parameter Real F "Shaft output ahead of reheater in p.u.";

  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-130, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-178, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = T3, y_start = Pm0Pu)  annotation(
    Placement(visible = true, transformation(origin = {76, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = PMaxPu, uMin = PMinPu)  annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = KGover) annotation(
    Placement(visible = true, transformation(origin = {-94, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = T4, y_start = Pm0Pu)  annotation(
    Placement(visible = true, transformation(origin = {112, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add PmRawPu annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LeadLag leadLag(t1 = T2, t2 = T1)  annotation(
    Placement(visible = true, transformation(origin = {-50, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LeadLag leadLag1(Y0 = Pm0Pu, t1 = F * T5, t2 = T5)  annotation(
    Placement(visible = true, transformation(origin = {154, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
protected
  parameter Types.ActivePowerPu Pm0Pu "Initial mechanical power in p.u (base PNom)";
  final parameter Types.ActivePowerPu PMinPu = PMin / PNom "Minimum mechanical power in p.u (base PNom)";
  final parameter Types.ActivePowerPu PMaxPu = PMax / PNom "Maximum mechanical power in p.u (base PNom)";
  final parameter Boolean ActiveFrequencyRegulation = if Pm0Pu < PMin / PNom or Pm0Pu > PMax / PNom then false else true "Boolean indicating whether the group participates to primary frequency control or not";
  status state(start = status.Standard);
equation
  connect(omegaPu, feedback.u2) annotation(
    Line(points = {{-130, -46}, {-130, -2}}, color = {0, 0, 127}));
  connect(omegaRefPu.y, feedback.u1) annotation(
    Line(points = {{-167, 6}, {-138, 6}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-121, 6}, {-106, 6}}, color = {0, 0, 127}));
  connect(limiter.y, firstOrder.u) annotation(
    Line(points = {{51, 0}, {63, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, firstOrder1.u) annotation(
    Line(points = {{87, 0}, {99, 0}}, color = {0, 0, 127}));
  connect(PmRefPu, PmRawPu.u2) annotation(
    Line(points = {{-25, -45}, {-25, -6}, {-12, -6}}, color = {0, 0, 127}));
  connect(PmRawPu.y, limiter.u) annotation(
    Line(points = {{11, 0}, {27, 0}}, color = {0, 0, 127}));
  when PmRawPu.y >= PMaxPu and pre(state) <> status.LimitPMax then
    state = status.LimitPMax;
    Timeline.logEvent1(TimelineKeys.ActivatePMAX);
  elsewhen PmRawPu.y <= PMinPu and pre(state) <> status.LimitPMin then
    state = status.LimitPMin;
    Timeline.logEvent1(TimelineKeys.ActivatePMIN);
  elsewhen PmRawPu.y > PMinPu and PmRawPu.y < PMaxPu and pre(state) == status.LimitPMin then
    state = status.Standard;
    Timeline.logEvent1(TimelineKeys.DeactivatePMIN);
  elsewhen PmRawPu.y > PMinPu and PmRawPu.y < PMaxPu and pre(state) == status.LimitPMax then
    state = status.Standard;
    Timeline.logEvent1(TimelineKeys.DeactivatePMAX);
  end when;
  connect(gain.y, leadLag.u) annotation(
    Line(points = {{-83, 6}, {-62, 6}}, color = {0, 0, 127}));
  connect(leadLag.y, PmRawPu.u1) annotation(
    Line(points = {{-39, 6}, {-12, 6}}, color = {0, 0, 127}));
  connect(firstOrder1.y, leadLag1.u) annotation(
    Line(points = {{124, 0}, {142, 0}}, color = {0, 0, 127}));
  connect(PmPu, leadLag1.y) annotation(
    Line(points = {{190, 0}, {166, 0}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "3.2.3")),
    Diagram);
end GovernorBPA_GG;
