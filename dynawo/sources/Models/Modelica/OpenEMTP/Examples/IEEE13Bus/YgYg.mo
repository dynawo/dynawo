within OpenEMTP.Examples.IEEE13Bus;
model YgYg
  UnsatSTC_XFMR PhaseA(
    t=480/4160,
    Rp=0.3807,
    Rs=0,
    Ls=0,
    Lp=0.6922) annotation (Placement(transformation(extent={{-8,25},{12,45}})));
  UnsatSTC_XFMR PhaseB(
    t=480/4160,
    Rp=0.3807,
    Lp=0.6922,
    Rs=0,
    Ls=0) annotation (Placement(transformation(extent={{-6,-20},{14,0}})));
  UnsatSTC_XFMR PhaseC(
    t=480/4160,
    Rp=0.3807,
    Lp=0.6922,
    Rs=0,
    Ls=0) annotation (Placement(transformation(extent={{-6,-60},{14,-40}})));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug Pk annotation (
      Placement(transformation(extent={{-84,-10},{-64,10}}), iconTransformation(
          extent={{-84,-10},{-64,10}})));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug Pm
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p PkA(k=1)
    annotation (Placement(transformation(extent={{-58,35},{-38,55}})));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p PkB(k=2)
    annotation (Placement(transformation(extent={{-56,-10},{-36,10}})));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p PkC(k=3)
    annotation (Placement(transformation(extent={{-56,-50},{-36,-30}})));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p PmA(k=1)
    annotation (Placement(transformation(extent={{52,35},{32,55}})));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p PmB(k=2)
    annotation (Placement(transformation(extent={{50,-10},{30,10}})));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p PmC(k=3)
    annotation (Placement(transformation(extent={{50,-50},{30,-30}})));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{-30,-92},{-10,-72}})));
  Modelica.Electrical.Analog.Basic.Ground ground1
    annotation (Placement(transformation(extent={{16,-94},{36,-74}})));
equation
  connect(PkA.plug_p, Pk) annotation (Line(points={{-50,45},{-66,45},{-66,0},{
          -74,0}}, color={0,0,255}));
  connect(PkB.plug_p, Pk)
    annotation (Line(points={{-48,0},{-74,0}}, color={0,0,255}));
  connect(PkC.plug_p, Pk) annotation (Line(points={{-48,-40},{-66,-40},{-66,0},
          {-74,0}}, color={0,0,255}));
  connect(PkA.pin_p, PhaseA.Pin_i) annotation (Line(points={{-46,45},{-34,45},{
          -34,44.8},{-7.8,44.8}}, color={0,0,255}));
  connect(PhaseB.Pin_i, PkB.pin_p) annotation (Line(points={{-5.8,-0.2},{-44,
          -0.2},{-44,0}}, color={0,0,255}));
  connect(PhaseC.Pin_i, PkC.pin_p) annotation (Line(points={{-5.8,-40.2},{-44,
          -40.2},{-44,-40}}, color={0,0,255}));
  connect(PmA.pin_p, PhaseA.Pin_k)
    annotation (Line(points={{40,45},{11.6,45}}, color={0,0,255}));
  connect(PmA.plug_p, Pm) annotation (Line(points={{44,45},{46,45},{46,44},{58,
          44},{58,0},{80,0}}, color={0,0,255}));
  connect(PhaseB.Pin_k, PmB.pin_p)
    annotation (Line(points={{13.6,0},{38,0}}, color={0,0,255}));
  connect(PhaseC.Pin_k, PmC.pin_p)
    annotation (Line(points={{13.6,-40},{38,-40}}, color={0,0,255}));
  connect(PmB.plug_p, Pm)
    annotation (Line(points={{42,0},{80,0}}, color={0,0,255}));
  connect(PmC.plug_p, Pm) annotation (Line(points={{42,-40},{50,-40},{58,-40},{
          58,0},{80,0}}, color={0,0,255}));
  connect(PhaseA.Pin_j, ground.p) annotation (Line(points={{-7.8,25.2},{-7.8,24},
          {-20,24},{-20,-72}}, color={0,0,255}));
  connect(PhaseB.Pin_j, ground.p) annotation (Line(points={{-5.8,-19.8},{-14,
          -20},{-20,-20},{-20,-72}}, color={0,0,255}));
  connect(PhaseC.Pin_j, ground.p) annotation (Line(points={{-5.8,-59.8},{-20,
          -59.8},{-20,-72}}, color={0,0,255}));
  connect(PhaseA.Pin_m, ground1.p) annotation (Line(points={{11.8,25.2},{26,
          25.2},{26,-74}}, color={0,0,255}));
  connect(PhaseB.Pin_m, ground1.p) annotation (Line(points={{13.8,-19.8},{26,
          -19.8},{26,-74}}, color={0,0,255}));
  connect(PhaseC.Pin_m, ground1.p) annotation (Line(points={{13.8,-59.8},{26,
          -60},{26,-74}}, color={0,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(extent={{-48,-32},{10,28}}, lineColor={28,108,200}),
        Ellipse(extent={{-2,-32},{56,28}}, lineColor={28,108,200}),
        Text(
          extent={{-42,18},{-10,-16}},
          lineColor={28,108,200},
          textString="Yg"),
        Text(
          extent={{14,18},{46,-16}},
          lineColor={28,108,200},
          textString="Yg"),
        Line(points={{72,0},{56,0}}, color={28,108,200}),
        Line(points={{-64,0},{-48,0}}, color={28,108,200})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    uses(Modelica(version="3.2.2")));
end YgYg;
