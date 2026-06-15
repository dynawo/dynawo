within Dynawo.Electrical.Controls.WECC.Mechanical;
model WTGTb "Drive train control with a mechanical power derived from filtered electrical power"
  extends Dynawo.Electrical.Controls.WECC.Mechanical.BaseClasses.BaseWTGT;
  extends Dynawo.Electrical.Controls.WECC.Parameters.Mechanical.ParamsWTGTb;

  Modelica.Blocks.Continuous.FirstOrder Pmech(T = tpWTGTb, y_start = PConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {-170, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

equation
  connect(Pmech.y, TorqueM.u1) annotation(
    Line(points = {{-170, 16}, {-170, 54}, {-162, 54}}, color = {0, 0, 127}));
  connect(PePu, Pmech.u) annotation(
    Line(points = {{-210, -54}, {-170, -54}, {-170, -8}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
    <p> This block contains the updated drive train model for generic WECC WTG type 4 model according to (in case page cannot be found, copy link in browser): <br><a href=\"https://www.wecc.org/Administrative/Memo%20RES%20Modeling%20Updates-%20Pourbeik.pdf\" >https://www.wecc.org/Administrative/Memo%20RES%20Modeling%20Updates-%20Pourbeik.pdf</a> </p>
    <p> This model is a simplified model for the purpose of emulating the behavior of torsional mode oscillations. The shaft damping coefficient (Dshaft) in the drive-train model is fitted to capture the net damping of the torsional mode seen in the post fault electrical power response. In the actual equipment, the drive train oscillations are damped through filtered signals and active damping controllers, which obviously are significantly different from the simple generic two mass drive train model used here. Therefore, the
    parameters (and variables) of this simple drive-train model cannot necessarily be compared with
    actual physical quantities directly. </p>
    <p>In this updated version B of the drive train, the mechanical power is derived from the electrical power by filtering with first order delay. </p></html>"),
    Icon(graphics = {Text(origin = {-13, -3}, extent = {{-147, 103}, {133, -99}}, textString = "WTGT B")}));
end WTGTb;
