within OpenEMTP.NonElectrical.Blocks;
block ParkTransform "This block implements a rotating reference frame transformation commonly known as the Park transform"
//The block implements a power invariant a-phase to d-axis alignmen
  import PI=Modelica.Constants.pi;
  parameter Integer Type=1 "Phase-a axis alignment"
      annotation(Dialog(group="Parameters"),choices(
      choice=1 "power invariant d-axis",
      choice=2 "power invariant q-axis"));
  parameter Boolean PowerInvariant=true
      annotation (Evaluate=true, choices(checkBox=true));
  final parameter Real  K1=if PowerInvariant then sqrt(2/3) else 2/3;
  final parameter Real  K2=if PowerInvariant then sqrt(1/2) else 1/3;
  Modelica.Blocks.Interfaces.RealInput u[3] annotation (
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput theta annotation (
    Placement(visible = true, transformation(origin = {-98, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  //Y={Yd,Yq,Y0}
  Modelica.Blocks.Interfaces.RealOutput y[3] annotation (
    Placement(visible = true, transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Real T[3,3] "Transformation matrix";
equation
  if     Type==1 then
  T = K1 * [cos(theta), cos(theta-2*PI/3), cos(theta+2*PI/3);
            sin(theta), sin(theta-2*PI/3), sin(theta+2*PI/3);
             K2,         K2,               K2];
  elseif Type==2 then
  T = K1 * [sin(theta), sin(theta-2*PI/3), sin(theta+2*PI/3);
                   cos(theta), cos(theta-2*PI/3), cos(theta+2*PI/3);
                   K2,         K2,               K2];
  end if;
  y=T*u;

annotation (
    uses(Modelica(version = "3.2.3")),defaultComponentName = "ParkTransform",
    Icon(graphics={  Text(origin = {-72, 70}, extent = {{-22, 22}, {40, -30}}, textString = "abc"), Text(origin = {-72, -52}, extent = {{-22, 22}, {46, -30}}, textString = "theta"), Text(origin = {62, 2}, extent = {{-40, 26}, {22, -22}}, textString = "dq0"), Rectangle(lineColor = {0, 0, 255}, extent = {{-100, 100}, {100, -100}})}, coordinateSystem(initialScale = 0.1)),
  Documentation(info="<html>
<p><b><span style=\"font-size: 12pt;\"><a name=\"d117e157579\">D</a><span style=\"color: #404040; background-color: #ffffff;\">escription</span></b></p>
<p><span style=\"font-family: Arial,Helvetica,sans-serif; font-size: 10pt;\"><a name=\"d117e157816\">T</a><span style=\"color: #404040; background-color: #ffffff;\">he&nbsp;Park Transform&nbsp;block converts the time-domain components of a three-phase system in an&nbsp;</span></span><span style=\"font-family: STIXGeneral,STIXGeneral-webfont,serif;\">abc<span style=\"font-family: Arial,Helvetica,sans-serif; font-size: 10pt;\">&nbsp;reference frame to direct, quadrature, and zero components in a rotating reference frame. The block can preserve the active and reactive powers with the powers of the system in the&nbsp;</span><span style=\"font-family: STIXGeneral,STIXGeneral-webfont,serif;\">abc</span><span style=\"font-family: Arial,Helvetica,sans-serif;\">&nbsp;reference frame by implementing an invariant version of the Park transform. For a balanced system, the zero component is equal to zero.</span></p>
<p><span style=\"font-family: Arial,Helvetica,sans-serif; color: #404040; background-color: #ffffff;\">For a power invariant&nbsp;</span></span><span style=\"font-family: STIXGeneral,STIXGeneral-webfont,serif;\">a<span style=\"font-family: Arial,Helvetica,sans-serif;\">-phase to&nbsp;</span><span style=\"font-family: STIXGeneral,STIXGeneral-webfont,serif;\">q</span><span style=\"font-family: Arial,Helvetica,sans-serif;\">-axis alignment, the block implements the transform using this equation:</span></p>
<p><img src=\"y:/ProfileS/DESktop/OpenEMTP/Images/Park.JPG\"/></p>
<p><span style=\"font-family: Arial,Helvetica,sans-serif; color: #404040; background-color: #ffffff;\">where:</span></p>
<p><i><span style=\"font-family: STIXGeneral,STIXGeneral-webfont,serif; color: #404040;\">a</span></i></span><span style=\"font-family: Arial,Helvetica,sans-serif;\">,&nbsp;<span style=\"font-family: STIXGeneral,STIXGeneral-webfont,serif;\">b</span><span style=\"font-family: Arial,Helvetica,sans-serif;\">, and&nbsp;</span><span style=\"font-family: STIXGeneral,STIXGeneral-webfont,serif;\">c</span><span style=\"font-family: Arial,Helvetica,sans-serif;\">&nbsp;are the components of the three-phase system in the&nbsp;</span><span style=\"font-family: STIXGeneral,STIXGeneral-webfont,serif;\">abc</span><span style=\"font-family: Arial,Helvetica,sans-serif;\">&nbsp;reference frame.</span></p>
<p><i><span style=\"font-family: STIXGeneral,STIXGeneral-webfont,serif; color: #404040;\">d</span></i></span><span style=\"font-family: Arial,Helvetica,sans-serif;\">&nbsp;and&nbsp;<span style=\"font-family: STIXGeneral,STIXGeneral-webfont,serif;\">q</span><span style=\"font-family: Arial,Helvetica,sans-serif;\">&nbsp;are the components of the two-axis system in the rotating reference frame.</span></p>
<p><i><span style=\"font-family: STIXGeneral,STIXGeneral-webfont,serif; color: #404040;\">0</span></i></span><span style=\"font-family: Arial,Helvetica,sans-serif;\">&nbsp;is the zero component of the two-axis system in the stationary reference frame.</p>
<p><span style=\"font-family: Arial,Helvetica,sans-serif;\"><a name=\"d117e157726\">T</a><span style=\"color: #404040; background-color: #ffffff;\">he block implements a power invariant&nbsp;</span></span><span style=\"font-family: STIXGeneral,STIXGeneral-webfont,serif;\">a<span style=\"font-family: Arial,Helvetica,sans-serif;\">-phase to&nbsp;</span><span style=\"font-family: STIXGeneral,STIXGeneral-webfont,serif;\">d</span><span style=\"font-family: Arial,Helvetica,sans-serif;\">-axis alignment as</span></p>
<p><img src=\"y:/ProfileS/DESktop/OpenEMTP/Images/Park2.JPG\"/></p>
</html>",                                                                                                                                                                                                        revisions= "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2020-01-08 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"));
end ParkTransform;
