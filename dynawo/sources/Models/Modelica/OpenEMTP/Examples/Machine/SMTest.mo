within OpenEMTP.Examples.Machine;

model SMTest
  extends Modelica.Icons.Example;
  OpenEMTP.Electrical.Machines.SM_6thOrder_FP SM(F = 0, H = 3.7, Pb = 555, Phi0 = {0, 1.000004303388919, 1.099314884351315, 1.000004303388919, 0, 0}, Vn = 24, d_theta0 = 0, fn = 60)  annotation(
    Placement(visible = true, transformation(origin = {-42, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Vf(k = 92.95) annotation(
    Placement(visible = true, transformation(origin = {-92, 54}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.R Ra(R = 50)  annotation(
    Placement(visible = true, transformation(origin = {38, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.R Rb(R = 50) annotation(
    Placement(visible = true, transformation(origin = {38, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.R Rc(R = 50) annotation(
    Placement(visible = true, transformation(origin = {38, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Connectors.Plug_a plug_a annotation(
    Placement(visible = true, transformation(origin = {-24, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 0.55558e6) annotation(
    Placement(visible = true, transformation(origin = {-90, 78}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  OpenEMTP.Electrical.Switches.IdealSwitch sw(Tclosing = 0.1, Topening = 0.2)  annotation(
    Placement(visible = true, transformation(origin = {12, 54}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Connectors.Plug_b plug_b annotation(
    Placement(visible = true, transformation(origin = {-18, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Connectors.Plug_c plug_c annotation(
    Placement(visible = true, transformation(origin = {-20, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.RLC_Branches.Ground g annotation(
    Placement(visible = true, transformation(origin = {88, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(plug_a.plug_p, SM.Pk) annotation(
    Line(points = {{-26, 80}, {-32, 80}, {-32, 60}}, color = {0, 0, 255}));
  connect(Ra.p, plug_a.pin_p) annotation(
    Line(points = {{28, 80}, {-22, 80}, {-22, 80}, {-22, 80}}, color = {0, 0, 255}));
  connect(Vf.y, SM.Vf) annotation(
    Line(points = {{-86, 54}, {-56, 54}, {-56, 54}, {-54, 54}}, color = {0, 0, 127}));
  connect(constant1.y, SM.Pm) annotation(
    Line(points = {{-84, 78}, {-68, 78}, {-68, 68}, {-54, 68}, {-54, 68}}, color = {0, 0, 127}));
  connect(sw.pin_p, plug_a.pin_p) annotation(
    Line(points = {{12, 66}, {12, 66}, {12, 80}, {-22, 80}, {-22, 80}}, color = {0, 0, 255}));
  connect(plug_b.plug_p, SM.Pk) annotation(
    Line(points = {{-20, 20}, {-32, 20}, {-32, 60}, {-32, 60}}, color = {0, 0, 255}));
  connect(plug_c.plug_p, SM.Pk) annotation(
    Line(points = {{-22, -40}, {-32, -40}, {-32, 60}, {-32, 60}}, color = {0, 0, 255}));
  connect(Rb.p, plug_b.pin_p) annotation(
    Line(points = {{28, 20}, {-16, 20}, {-16, 20}, {-16, 20}}, color = {0, 0, 255}));
  connect(Rc.p, plug_c.pin_p) annotation(
    Line(points = {{28, -40}, {-18, -40}, {-18, -40}, {-18, -40}}, color = {0, 0, 255}));
  connect(Ra.n, g.p) annotation(
    Line(points = {{48, 80}, {88, 80}, {88, 6}, {88, 6}}, color = {0, 0, 255}));
  connect(Rb.n, g.p) annotation(
    Line(points = {{48, 20}, {88, 20}, {88, 6}, {88, 6}}, color = {0, 0, 255}));
  connect(Rc.n, g.p) annotation(
    Line(points = {{48, -40}, {72, -40}, {72, 6}, {88, 6}, {88, 6}}, color = {0, 0, 255}));
  connect(sw.pin_n, Rb.p) annotation(
    Line(points = {{12, 44}, {12, 44}, {12, 20}, {28, 20}, {28, 20}}, color = {0, 0, 255}));
protected
  annotation(
    uses(Modelica(version = "3.2.3")),
    experiment(StartTime = 0, StopTime = 6, Tolerance = 0.0001, Interval = 0.0002),
    __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "ida"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=initialization ",
  Documentation(info = "<html><head></head><body>
<p style=\"margin: 0px;\"><!--StartFragment-->% Machine parameters from Kundur Examples 3.1, 3.2,  8.1 (pages 91,102, 345)</p>
<p style=\"margin: 0px;\">% \"Power System Stability and Control\"  McGraw-Hill  book, 1994<!--EndFragment--></p><p style=\"margin: 0px;\"><br></p><p style=\"margin: 0px;\"><br></p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><!--StartFragment-->% Nominal parameters</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Pn=  555e6;   % three-pahse nominal power (VA)</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Vn=  24e3;    % nominal LL volatge (Vrms)</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">fn=  60;      % nominal frequency (Hz)</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">ifn= 1300;    % nominal field current (A)</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">% Note: ifn is deduced from stator-field mutual inductance Lsfd</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">%       Lsfd = Vn/sqrt(3)*sqrt(2)/ifn/wn </p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">% -&gt;     ifn = sqrt(2/3)*Vn/Lsfd/(2*pi*60)  = 1300 A</p><p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><br></p><p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><br></p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">% Stator RL parameters (SI)</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Rs= 0.0031;     % resistance (ohms)</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Ll= 0.4129e-3;  % leakage inductance (H) </p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Lmd=4.5696e-3;  % d-axis magnetizing inductance (H)  </p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Lmq=4.432e-3;   % q-axis magnetizing inductance (H)</p><p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><br></p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">% Field RL parameters (SI)</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Rf= 0.0715;    %  resistance (ohms)</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Lffd= 0.57692; %  self inductance (H)</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">% Note: Field leakage inductance Llfd wiil be later deduced from:</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">% Llfd_pu= Lffd_pu-Lmd_pu      </p><p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><br></p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">% Damper RL parameters from Kundur Example 3.2 </p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Rkd_pu   = 0.0284; </p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Llkd_pu  = 0.1713; </p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Rkq1_pu  = 0.00619;  </p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Llkq1_pu = 0.7252; </p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Rkq2_pu  = 0.02368;  </p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Llkq2_pu = 0.125; </p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">            </p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">% Stator base values</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">wbase=2*pi*fn;</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Vsbase=Vn/sqrt(3)*sqrt(2);</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Isbase=Pn/Vn/sqrt(3)*sqrt(2);</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Zsbase=Vn^2/Pn;</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Lsbase=Zsbase/wbase;</p><p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><br></p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">%Stator parameters in PU</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Rs_pu=Rs/Zsbase;</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Ll_pu=Ll/Lsbase;</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Lmd_pu=Lmd/Lsbase;</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Lmq_pu=Lmq/Lsbase;</p><p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><br></p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">% Field base values</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Ifbase=ifn*Lmd_pu;</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Vfbase=Pn/Ifbase;</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Zfbase=Vfbase/Ifbase;</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Lfbase=Zfbase/wbase;</p><p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><br></p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">% Transformation ratio Ns/Nf</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Ns_Nf=2/3*Ifbase/Isbase;</p><p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><br></p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">% Field parameters in PU</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Rf_pu=Rf/Zfbase;</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Lffd_pu=Lffd/Lfbase;      % self inductance (pu)</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Llfd_pu=Lffd_pu - Lmd_pu; % leakage inductance (pu)</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Llfd= Llfd_pu*Lfbase;     % leakage inductance (H)</p><p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><br></p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">% Field parameters referred to the stator</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Rf_prime=Rf*3/2*Ns_Nf^2;</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Llfd_prime=Llfd*3/2*Ns_Nf^2;</p><p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><br></p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">% Nominal field voltage</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Vfn=Rf*ifn;</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">% Nominal field voltage and current referred to stator</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Vfn_prime=Rf_pu/Lmd_pu*Vsbase;</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Ifn_prime=Isbase/Lmd_pu;</p><p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><br></p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">% Inertia</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">H= 3.7; % sec</p><p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">wm= 2*pi*60; %rad/s</p><p style=\"margin: 0px;\">







































































</p><p style=\"margin: 0px;\">J= 2*H*Pn/wm^2; % kg.m^2<!--EndFragment--></p></body></html>"),
  Diagram(graphics = {Text(origin = {-132, 80}, extent = {{-6, 4}, {6, -4}}, textString = "0.55558e6")}, coordinateSystem(initialScale = 0.1)));
end SMTest;
