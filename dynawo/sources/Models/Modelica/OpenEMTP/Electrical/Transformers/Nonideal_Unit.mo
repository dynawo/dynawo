within OpenEMTP.Electrical.Transformers;
model Nonideal_Unit "Nonideal single phase transformer based on STC model"
  import Modelica.SIunits.Resistance;
  import Modelica.SIunits.Inductance;
  parameter Real t "Turns ratio v2/v1";
  parameter Resistance Rp "Resisrance in primary side";
  parameter Inductance Lp "Inductance in primary side";
  parameter Resistance Rs "Resisrance in secondary side";
  parameter Inductance Ls "Inductance in secondary side";
  parameter Resistance Rmag "Magnetization resistance ";
  parameter Real Lmag[:, 2] = [0.225508571E+01, 0.682234741E+03] "Saturation characteristic [ i1(A) ,  phi1(V.s) ;  i2 , phi2 ; ... ]";
  Modelica.Electrical.Analog.Interfaces.PositivePin Pin_i annotation (
    Placement(visible = true, transformation(origin = {-176, 40}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-98, 98}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin Pin_j annotation (
    Placement(visible = true, transformation(origin = {-176, -20}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-98, -98}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin Pin_k annotation (
    Placement(visible = true, transformation(origin = {104, 41}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {96, 100}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.NegativePin Pin_m annotation (
    Placement(visible = true, transformation(origin = {104, -19}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {98, -98}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  OpenEMTP.Electrical.Transformers.IdealUnit IdealUnit1(final g = t)  annotation (
    Placement(visible = true, transformation(origin = {0, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.R R2(final R = Rs)  annotation (
    Placement(visible = true, transformation(origin = {40, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.L L2(final L = Ls)  annotation (
    Placement(visible = true, transformation(origin = {72, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.R R1(final R = Rp)  annotation (
    Placement(visible = true, transformation(origin = {-138, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.L L1(final L = Lp)  annotation (
    Placement(visible = true, transformation(origin = {-98, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.RLC_Branches.R Rm(final R = Rmag)  annotation (
    Placement(visible = true, transformation(origin = {-66, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  OpenEMTP.Electrical.Nonlinear.L_Nonlinear Lm(final T = Lmag)  annotation (
    Placement(visible = true, transformation(origin = {-40, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  connect(R1.p, Pin_i) annotation (
    Line(points = {{-148, 40}, {-174, 40}, {-174, 40}, {-176, 40}}, color = {0, 0, 255}));
  connect(R1.n, L1.p) annotation (
    Line(points = {{-128, 40}, {-108, 40}, {-108, 40}, {-108, 40}}, color = {0, 0, 255}));
  connect(Rm.n, Pin_j) annotation (
    Line(points = {{-66, 0}, {-66, 0}, {-66, -20}, {-176, -20}, {-176, -20}}, color = {0, 0, 255}));
  connect(Lm.n, Pin_j) annotation (
    Line(points = {{-40, 0}, {-40, 0}, {-40, -20}, {-176, -20}, {-176, -20}}, color = {0, 0, 255}));
  connect(L1.n, Rm.p) annotation (
    Line(points = {{-88, 40}, {-66, 40}, {-66, 20}, {-66, 20}}, color = {0, 0, 255}));
  connect(Lm.p, L1.n) annotation (
    Line(points = {{-40, 20}, {-40, 20}, {-40, 40}, {-88, 40}, {-88, 40}}, color = {0, 0, 255}));
  connect(IdealUnit1.p1, L1.n) annotation (
    Line(points = {{-10, 20}, {-20, 20}, {-20, 40}, {-88, 40}, {-88, 40}, {-88, 40}}, color = {0, 0, 255}));
  connect(IdealUnit1.n1, Pin_j) annotation (
    Line(points = {{-10, 0}, {-20, 0}, {-20, -20}, {-176, -20}, {-176, -20}}, color = {0, 0, 255}));
  connect(IdealUnit1.p2, R2.p) annotation (
    Line(points = {{10, 20}, {20, 20}, {20, 40}, {30, 40}, {30, 40}}, color = {0, 0, 255}));
  connect(L2.p, R2.n) annotation (
    Line(points = {{62, 40}, {50, 40}, {50, 40}, {50, 40}}, color = {0, 0, 255}));
  connect(L2.n, Pin_k) annotation (
    Line(points = {{82, 40}, {102, 40}, {102, 42}, {104, 42}}, color = {0, 0, 255}));
  connect(IdealUnit1.n2, Pin_m) annotation (
    Line(points = {{10, 0}, {20, 0}, {20, -20}, {104, -20}, {104, -18}}, color = {0, 0, 255}));
  annotation (
        Icon(graphics = {Text(extent = {{-150, -110}, {150, -150}}, textString = "n=%t"), Text(lineColor = {0, 0, 255}, extent = {{-100, 20}, {-60, -20}}, textString = "1"), Text(lineColor = {0, 0, 255}, extent = {{60, 20}, {100, -20}}, textString = "2"), Text(lineColor = {0, 0, 255}, extent = {{-150, 150}, {150, 110}}, textString = "%name"), Line(points = {{-40, 60}, {-40, 100}, {-90, 100}}, color = {0, 0, 255}), Line(points = {{40, 60}, {40, 100}, {90, 100}}, color = {0, 0, 255}), Line(points = {{-40, -60}, {-40, -100}, {-90, -100}}, color = {0, 0, 255}), Line(points = {{40, -60}, {40, -100}, {90, -100}}, color = {0, 0, 255}), Line(origin = {-33, 45}, rotation = 270, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {-33, 15}, rotation = 270, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {-33, -15}, rotation = 270, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {-33, -45}, rotation = 270, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {33, 45}, rotation = 90, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {33, 15}, rotation = 90, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {33, -15}, rotation = 90, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Line(origin = {33, -45}, rotation = 90, points = {{-15, -7}, {-14, -1}, {-7, 7}, {7, 7}, {14, -1}, {15, -7}}, color = {0, 0, 255}, smooth = Smooth.Bezier), Text(origin = {-81, 1}, extent = {{-1, 1}, {1, -1}}, textString = "text"), Text(origin = {24, 78}, lineColor = {0, 0, 255}, extent = {{60, 20}, {100, -20}}, textString = "k"), Text(origin = {22, -72}, lineColor = {0, 0, 255}, extent = {{60, 20}, {100, -20}}, textString = "m"), Text(origin = {-178, 76}, lineColor = {0, 0, 255}, extent = {{60, 20}, {100, -20}}, textString = "i"), Text(origin = {-180, -68}, lineColor = {0, 0, 255}, extent = {{60, 20}, {100, -20}}, textString = "j"), Text(origin = {3, -95}, extent = {{25, -17}, {-25, 17}}, textString = "STC_Model"), Line(origin = {-10, 0}, points = {{0, 60}, {0, -60}}, color = {0, 0, 255}), Line(origin = {10, 0}, points = {{0, 60}, {0, -60}}, color = {0, 0, 255}), Line(origin = {-1, 0}, points = {{-29, 60}, {-19, 60}, {21, -60}, {29, -60}}, color = {0, 0, 255})}, coordinateSystem(initialScale = 0.1)),
    uses(Modelica(version = "3.2.3")),
    Diagram,
    version = "",
    __OpenModelica_commandLineOptions = "",
    Documentation(info = "<html><head></head><body>




<!--[if gte mso 9]><xml>
<o:OfficeDocumentSettings>
<o:AllowPNG/>
</o:OfficeDocumentSettings>
</xml><![endif]-->


<!--[if gte mso 9]><xml>
<w:WordDocument>
<w:View>Normal</w:View>
<w:Zoom>0</w:Zoom>
<w:TrackMoves/>
<w:TrackFormatting/>
<w:PunctuationKerning/>
<w:ValidateAgainstSchemas/>
<w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid>
<w:IgnoreMixedContent>false</w:IgnoreMixedContent>
<w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText>
<w:DoNotPromoteQF/>
<w:LidThemeOther>EN-CA</w:LidThemeOther>
<w:LidThemeAsian>X-NONE</w:LidThemeAsian>
<w:LidThemeComplexScript>AR-SA</w:LidThemeComplexScript>
<w:Compatibility>
<w:BreakWrappedTables/>
<w:SnapToGridInCell/>
<w:WrapTextWithPunct/>
<w:UseAsianBreakRules/>
<w:DontGrowAutofit/>
<w:SplitPgBreakAndParaMark/>
<w:EnableOpenTypeKerning/>
<w:DontFlipMirrorIndents/>
<w:OverrideTableStyleHps/>
</w:Compatibility>
<m:mathPr>
<m:mathFont m:val=\"Cambria Math\"/>
<m:brkBin m:val=\"before\"/>
<m:brkBinSub m:val=\"&#45;-\"/>
<m:smallFrac m:val=\"off\"/>
<m:dispDef/>
<m:lMargin m:val=\"0\"/>
<m:rMargin m:val=\"0\"/>
<m:defJc m:val=\"centerGroup\"/>
<m:wrapIndent m:val=\"1440\"/>
<m:intLim m:val=\"subSup\"/>
<m:naryLim m:val=\"undOvr\"/>
</m:mathPr></w:WordDocument>
</xml><![endif]--><!--[if gte mso 9]><xml>
<w:LatentStyles DefLockedState=\"false\" DefUnhideWhenUsed=\"false\"
DefSemiHidden=\"false\" DefQFormat=\"false\" DefPriority=\"99\"
LatentStyleCount=\"376\">
<w:LsdException Locked=\"false\" Priority=\"0\" QFormat=\"true\" Name=\"Normal\"/>
<w:LsdException Locked=\"false\" Priority=\"9\" QFormat=\"true\" Name=\"heading 1\"/>
<w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 2\"/>
<w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 3\"/>
<w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 4\"/>
<w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 5\"/>
<w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 6\"/>
<w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 7\"/>
<w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 8\"/>
<w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 9\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"index 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"index 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"index 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"index 4\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"index 5\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"index 6\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"index 7\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"index 8\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"index 9\"/>
<w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" Name=\"toc 1\"/>
<w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" Name=\"toc 2\"/>
<w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" Name=\"toc 3\"/>
<w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" Name=\"toc 4\"/>
<w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" Name=\"toc 5\"/>
<w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" Name=\"toc 6\"/>
<w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" Name=\"toc 7\"/>
<w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" Name=\"toc 8\"/>
<w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" Name=\"toc 9\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Normal Indent\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"footnote text\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"annotation text\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"header\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"footer\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"index heading\"/>
<w:LsdException Locked=\"false\" Priority=\"35\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"caption\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"table of figures\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"envelope address\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"envelope return\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"footnote reference\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"annotation reference\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"line number\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"page number\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"endnote reference\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"endnote text\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"table of authorities\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"macro\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"toa heading\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Bullet\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Number\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List 4\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List 5\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Bullet 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Bullet 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Bullet 4\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Bullet 5\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Number 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Number 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Number 4\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Number 5\"/>
<w:LsdException Locked=\"false\" Priority=\"10\" QFormat=\"true\" Name=\"Title\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Closing\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Signature\"/>
<w:LsdException Locked=\"false\" Priority=\"1\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" Name=\"Default Paragraph Font\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Body Text\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Body Text Indent\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Continue\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Continue 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Continue 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Continue 4\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Continue 5\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Message Header\"/>
<w:LsdException Locked=\"false\" Priority=\"11\" QFormat=\"true\" Name=\"Subtitle\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Salutation\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Date\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Body Text First Indent\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Body Text First Indent 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Note Heading\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Body Text 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Body Text 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Body Text Indent 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Body Text Indent 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Block Text\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Hyperlink\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"FollowedHyperlink\"/>
<w:LsdException Locked=\"false\" Priority=\"22\" QFormat=\"true\" Name=\"Strong\"/>
<w:LsdException Locked=\"false\" Priority=\"20\" QFormat=\"true\" Name=\"Emphasis\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Document Map\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Plain Text\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"E-mail Signature\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Top of Form\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Bottom of Form\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Normal (Web)\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Acronym\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Address\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Cite\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Code\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Definition\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Keyboard\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Preformatted\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Sample\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Typewriter\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Variable\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Normal Table\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"annotation subject\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"No List\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Outline List 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Outline List 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Outline List 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Simple 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Simple 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Simple 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Classic 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Classic 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Classic 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Classic 4\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Colorful 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Colorful 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Colorful 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Columns 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Columns 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Columns 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Columns 4\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Columns 5\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Grid 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Grid 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Grid 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Grid 4\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Grid 5\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Grid 6\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Grid 7\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Grid 8\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table List 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table List 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table List 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table List 4\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table List 5\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table List 6\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table List 7\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table List 8\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table 3D effects 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table 3D effects 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table 3D effects 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Contemporary\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Elegant\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Professional\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Subtle 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Subtle 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Web 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Web 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Web 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Balloon Text\"/>
<w:LsdException Locked=\"false\" Priority=\"39\" Name=\"Table Grid\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Theme\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" Name=\"Placeholder Text\"/>
<w:LsdException Locked=\"false\" Priority=\"1\" QFormat=\"true\" Name=\"No Spacing\"/>
<w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading\"/>
<w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List\"/>
<w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid\"/>
<w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1\"/>
<w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2\"/>
<w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1\"/>
<w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2\"/>
<w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1\"/>
<w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2\"/>
<w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3\"/>
<w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List\"/>
<w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading\"/>
<w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List\"/>
<w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid\"/>
<w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" Name=\"Revision\"/>
<w:LsdException Locked=\"false\" Priority=\"34\" QFormat=\"true\"
Name=\"List Paragraph\"/>
<w:LsdException Locked=\"false\" Priority=\"29\" QFormat=\"true\" Name=\"Quote\"/>
<w:LsdException Locked=\"false\" Priority=\"30\" QFormat=\"true\"
Name=\"Intense Quote\"/>
<w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"19\" QFormat=\"true\"
Name=\"Subtle Emphasis\"/>
<w:LsdException Locked=\"false\" Priority=\"21\" QFormat=\"true\"
Name=\"Intense Emphasis\"/>
<w:LsdException Locked=\"false\" Priority=\"31\" QFormat=\"true\"
Name=\"Subtle Reference\"/>
<w:LsdException Locked=\"false\" Priority=\"32\" QFormat=\"true\"
Name=\"Intense Reference\"/>
<w:LsdException Locked=\"false\" Priority=\"33\" QFormat=\"true\" Name=\"Book Title\"/>
<w:LsdException Locked=\"false\" Priority=\"37\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" Name=\"Bibliography\"/>
<w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"TOC Heading\"/>
<w:LsdException Locked=\"false\" Priority=\"41\" Name=\"Plain Table 1\"/>
<w:LsdException Locked=\"false\" Priority=\"42\" Name=\"Plain Table 2\"/>
<w:LsdException Locked=\"false\" Priority=\"43\" Name=\"Plain Table 3\"/>
<w:LsdException Locked=\"false\" Priority=\"44\" Name=\"Plain Table 4\"/>
<w:LsdException Locked=\"false\" Priority=\"45\" Name=\"Plain Table 5\"/>
<w:LsdException Locked=\"false\" Priority=\"40\" Name=\"Grid Table Light\"/>
<w:LsdException Locked=\"false\" Priority=\"46\" Name=\"Grid Table 1 Light\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark\"/>
<w:LsdException Locked=\"false\" Priority=\"51\" Name=\"Grid Table 6 Colorful\"/>
<w:LsdException Locked=\"false\" Priority=\"52\" Name=\"Grid Table 7 Colorful\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"Grid Table 1 Light Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"Grid Table 6 Colorful Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"Grid Table 7 Colorful Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"Grid Table 1 Light Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"Grid Table 6 Colorful Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"Grid Table 7 Colorful Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"Grid Table 1 Light Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"Grid Table 6 Colorful Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"Grid Table 7 Colorful Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"Grid Table 1 Light Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"Grid Table 6 Colorful Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"Grid Table 7 Colorful Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"Grid Table 1 Light Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"Grid Table 6 Colorful Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"Grid Table 7 Colorful Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"Grid Table 1 Light Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"Grid Table 6 Colorful Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"Grid Table 7 Colorful Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"46\" Name=\"List Table 1 Light\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark\"/>
<w:LsdException Locked=\"false\" Priority=\"51\" Name=\"List Table 6 Colorful\"/>
<w:LsdException Locked=\"false\" Priority=\"52\" Name=\"List Table 7 Colorful\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"List Table 1 Light Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"List Table 6 Colorful Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"List Table 7 Colorful Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"List Table 1 Light Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"List Table 6 Colorful Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"List Table 7 Colorful Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"List Table 1 Light Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"List Table 6 Colorful Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"List Table 7 Colorful Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"List Table 1 Light Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"List Table 6 Colorful Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"List Table 7 Colorful Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"List Table 1 Light Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"List Table 6 Colorful Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"List Table 7 Colorful Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"List Table 1 Light Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"List Table 6 Colorful Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"List Table 7 Colorful Accent 6\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Mention\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Smart Hyperlink\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Hashtag\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Unresolved Mention\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Smart Link\"/>
</w:LatentStyles>
</xml><![endif]-->

<!--[if gte mso 10]>
<style>
/* Style Definitions */
table.MsoNormalTable
{mso-style-name:\"Table Normal\";
mso-tstyle-rowband-size:0;
mso-tstyle-colband-size:0;
mso-style-noshow:yes;
mso-style-priority:99;
mso-style-parent:\"\";
mso-padding-alt:0in 5.4pt 0in 5.4pt;
mso-para-margin-top:0in;
mso-para-margin-right:0in;
mso-para-margin-bottom:8.0pt;
mso-para-margin-left:0in;
line-height:107%;
mso-pagination:widow-orphan;
font-size:11.0pt;
font-family:\"Calibri\",sans-serif;
mso-ascii-font-family:Calibri;
mso-ascii-theme-font:minor-latin;
mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;
mso-bidi-font-family:Arial;
mso-bidi-theme-font:minor-bidi;
mso-ansi-language:EN-CA;}
</style>
<![endif]-->



<!--StartFragment-->

<p class=\"MsoNormal\" style=\"margin-left:.25in;text-align:justify\"><span lang=\"EN-CA\" style=\"font-size:12.0pt;line-height:107%;font-family:&quot;Times New Roman&quot;,serif;
mso-ascii-theme-font:major-bidi;mso-hansi-theme-font:major-bidi;mso-bidi-theme-font:
major-bidi\">The Saturable Transformer Component (STC) is a two- and
three-winding single-phase transformer model. It is the nonlinear version of
the classic Steinmetz model.<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"margin-left:.25in;text-align:justify\">




<!--[if gte mso 9]><xml>
<o:OfficeDocumentSettings>
<o:AllowPNG/>
</o:OfficeDocumentSettings>
</xml><![endif]-->


<!--[if gte mso 9]><xml>
<w:WordDocument>
<w:View>Normal</w:View>
<w:Zoom>0</w:Zoom>
<w:TrackMoves/>
<w:TrackFormatting/>
<w:PunctuationKerning/>
<w:ValidateAgainstSchemas/>
<w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid>
<w:IgnoreMixedContent>false</w:IgnoreMixedContent>
<w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText>
<w:DoNotPromoteQF/>
<w:LidThemeOther>EN-CA</w:LidThemeOther>
<w:LidThemeAsian>X-NONE</w:LidThemeAsian>
<w:LidThemeComplexScript>AR-SA</w:LidThemeComplexScript>
<w:Compatibility>
<w:BreakWrappedTables/>
<w:SnapToGridInCell/>
<w:WrapTextWithPunct/>
<w:UseAsianBreakRules/>
<w:DontGrowAutofit/>
<w:SplitPgBreakAndParaMark/>
<w:EnableOpenTypeKerning/>
<w:DontFlipMirrorIndents/>
<w:OverrideTableStyleHps/>
</w:Compatibility>
<m:mathPr>
<m:mathFont m:val=\"Cambria Math\"/>
<m:brkBin m:val=\"before\"/>
<m:brkBinSub m:val=\"&#45;-\"/>
<m:smallFrac m:val=\"off\"/>
<m:dispDef/>
<m:lMargin m:val=\"0\"/>
<m:rMargin m:val=\"0\"/>
<m:defJc m:val=\"centerGroup\"/>
<m:wrapIndent m:val=\"1440\"/>
<m:intLim m:val=\"subSup\"/>
<m:naryLim m:val=\"undOvr\"/>
</m:mathPr></w:WordDocument>
</xml><![endif]--><!--[if gte mso 9]><xml>
<w:LatentStyles DefLockedState=\"false\" DefUnhideWhenUsed=\"false\"
DefSemiHidden=\"false\" DefQFormat=\"false\" DefPriority=\"99\"
LatentStyleCount=\"376\">
<w:LsdException Locked=\"false\" Priority=\"0\" QFormat=\"true\" Name=\"Normal\"/>
<w:LsdException Locked=\"false\" Priority=\"9\" QFormat=\"true\" Name=\"heading 1\"/>
<w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 2\"/>
<w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 3\"/>
<w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 4\"/>
<w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 5\"/>
<w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 6\"/>
<w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 7\"/>
<w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 8\"/>
<w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 9\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"index 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"index 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"index 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"index 4\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"index 5\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"index 6\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"index 7\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"index 8\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"index 9\"/>
<w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" Name=\"toc 1\"/>
<w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" Name=\"toc 2\"/>
<w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" Name=\"toc 3\"/>
<w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" Name=\"toc 4\"/>
<w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" Name=\"toc 5\"/>
<w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" Name=\"toc 6\"/>
<w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" Name=\"toc 7\"/>
<w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" Name=\"toc 8\"/>
<w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" Name=\"toc 9\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Normal Indent\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"footnote text\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"annotation text\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"header\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"footer\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"index heading\"/>
<w:LsdException Locked=\"false\" Priority=\"35\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"caption\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"table of figures\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"envelope address\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"envelope return\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"footnote reference\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"annotation reference\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"line number\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"page number\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"endnote reference\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"endnote text\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"table of authorities\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"macro\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"toa heading\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Bullet\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Number\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List 4\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List 5\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Bullet 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Bullet 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Bullet 4\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Bullet 5\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Number 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Number 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Number 4\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Number 5\"/>
<w:LsdException Locked=\"false\" Priority=\"10\" QFormat=\"true\" Name=\"Title\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Closing\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Signature\"/>
<w:LsdException Locked=\"false\" Priority=\"1\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" Name=\"Default Paragraph Font\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Body Text\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Body Text Indent\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Continue\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Continue 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Continue 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Continue 4\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"List Continue 5\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Message Header\"/>
<w:LsdException Locked=\"false\" Priority=\"11\" QFormat=\"true\" Name=\"Subtitle\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Salutation\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Date\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Body Text First Indent\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Body Text First Indent 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Note Heading\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Body Text 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Body Text 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Body Text Indent 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Body Text Indent 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Block Text\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Hyperlink\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"FollowedHyperlink\"/>
<w:LsdException Locked=\"false\" Priority=\"22\" QFormat=\"true\" Name=\"Strong\"/>
<w:LsdException Locked=\"false\" Priority=\"20\" QFormat=\"true\" Name=\"Emphasis\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Document Map\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Plain Text\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"E-mail Signature\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Top of Form\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Bottom of Form\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Normal (Web)\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Acronym\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Address\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Cite\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Code\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Definition\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Keyboard\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Preformatted\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Sample\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Typewriter\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"HTML Variable\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Normal Table\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"annotation subject\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"No List\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Outline List 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Outline List 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Outline List 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Simple 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Simple 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Simple 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Classic 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Classic 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Classic 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Classic 4\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Colorful 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Colorful 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Colorful 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Columns 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Columns 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Columns 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Columns 4\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Columns 5\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Grid 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Grid 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Grid 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Grid 4\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Grid 5\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Grid 6\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Grid 7\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Grid 8\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table List 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table List 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table List 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table List 4\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table List 5\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table List 6\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table List 7\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table List 8\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table 3D effects 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table 3D effects 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table 3D effects 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Contemporary\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Elegant\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Professional\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Subtle 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Subtle 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Web 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Web 2\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Web 3\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Balloon Text\"/>
<w:LsdException Locked=\"false\" Priority=\"39\" Name=\"Table Grid\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Table Theme\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" Name=\"Placeholder Text\"/>
<w:LsdException Locked=\"false\" Priority=\"1\" QFormat=\"true\" Name=\"No Spacing\"/>
<w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading\"/>
<w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List\"/>
<w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid\"/>
<w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1\"/>
<w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2\"/>
<w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1\"/>
<w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2\"/>
<w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1\"/>
<w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2\"/>
<w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3\"/>
<w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List\"/>
<w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading\"/>
<w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List\"/>
<w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid\"/>
<w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 1\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" Name=\"Revision\"/>
<w:LsdException Locked=\"false\" Priority=\"34\" QFormat=\"true\"
Name=\"List Paragraph\"/>
<w:LsdException Locked=\"false\" Priority=\"29\" QFormat=\"true\" Name=\"Quote\"/>
<w:LsdException Locked=\"false\" Priority=\"30\" QFormat=\"true\"
Name=\"Intense Quote\"/>
<w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"19\" QFormat=\"true\"
Name=\"Subtle Emphasis\"/>
<w:LsdException Locked=\"false\" Priority=\"21\" QFormat=\"true\"
Name=\"Intense Emphasis\"/>
<w:LsdException Locked=\"false\" Priority=\"31\" QFormat=\"true\"
Name=\"Subtle Reference\"/>
<w:LsdException Locked=\"false\" Priority=\"32\" QFormat=\"true\"
Name=\"Intense Reference\"/>
<w:LsdException Locked=\"false\" Priority=\"33\" QFormat=\"true\" Name=\"Book Title\"/>
<w:LsdException Locked=\"false\" Priority=\"37\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" Name=\"Bibliography\"/>
<w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"TOC Heading\"/>
<w:LsdException Locked=\"false\" Priority=\"41\" Name=\"Plain Table 1\"/>
<w:LsdException Locked=\"false\" Priority=\"42\" Name=\"Plain Table 2\"/>
<w:LsdException Locked=\"false\" Priority=\"43\" Name=\"Plain Table 3\"/>
<w:LsdException Locked=\"false\" Priority=\"44\" Name=\"Plain Table 4\"/>
<w:LsdException Locked=\"false\" Priority=\"45\" Name=\"Plain Table 5\"/>
<w:LsdException Locked=\"false\" Priority=\"40\" Name=\"Grid Table Light\"/>
<w:LsdException Locked=\"false\" Priority=\"46\" Name=\"Grid Table 1 Light\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark\"/>
<w:LsdException Locked=\"false\" Priority=\"51\" Name=\"Grid Table 6 Colorful\"/>
<w:LsdException Locked=\"false\" Priority=\"52\" Name=\"Grid Table 7 Colorful\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"Grid Table 1 Light Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"Grid Table 6 Colorful Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"Grid Table 7 Colorful Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"Grid Table 1 Light Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"Grid Table 6 Colorful Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"Grid Table 7 Colorful Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"Grid Table 1 Light Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"Grid Table 6 Colorful Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"Grid Table 7 Colorful Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"Grid Table 1 Light Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"Grid Table 6 Colorful Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"Grid Table 7 Colorful Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"Grid Table 1 Light Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"Grid Table 6 Colorful Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"Grid Table 7 Colorful Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"Grid Table 1 Light Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"Grid Table 6 Colorful Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"Grid Table 7 Colorful Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"46\" Name=\"List Table 1 Light\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark\"/>
<w:LsdException Locked=\"false\" Priority=\"51\" Name=\"List Table 6 Colorful\"/>
<w:LsdException Locked=\"false\" Priority=\"52\" Name=\"List Table 7 Colorful\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"List Table 1 Light Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"List Table 6 Colorful Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"List Table 7 Colorful Accent 1\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"List Table 1 Light Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"List Table 6 Colorful Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"List Table 7 Colorful Accent 2\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"List Table 1 Light Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"List Table 6 Colorful Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"List Table 7 Colorful Accent 3\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"List Table 1 Light Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"List Table 6 Colorful Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"List Table 7 Colorful Accent 4\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"List Table 1 Light Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"List Table 6 Colorful Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"List Table 7 Colorful Accent 5\"/>
<w:LsdException Locked=\"false\" Priority=\"46\"
Name=\"List Table 1 Light Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"51\"
Name=\"List Table 6 Colorful Accent 6\"/>
<w:LsdException Locked=\"false\" Priority=\"52\"
Name=\"List Table 7 Colorful Accent 6\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Mention\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Smart Hyperlink\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Hashtag\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Unresolved Mention\"/>
<w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
Name=\"Smart Link\"/>
</w:LatentStyles>
</xml><![endif]-->

<!--[if gte mso 10]>
<style>
/* Style Definitions */
table.MsoNormalTable
{mso-style-name:\"Table Normal\";
mso-tstyle-rowband-size:0;
mso-tstyle-colband-size:0;
mso-style-noshow:yes;
mso-style-priority:99;
mso-style-parent:\"\";
mso-padding-alt:0in 5.4pt 0in 5.4pt;
mso-para-margin-top:0in;
mso-para-margin-right:0in;
mso-para-margin-bottom:8.0pt;
mso-para-margin-left:0in;
line-height:107%;
mso-pagination:widow-orphan;
font-size:11.0pt;
font-family:\"Calibri\",sans-serif;
mso-ascii-font-family:Calibri;
mso-ascii-theme-font:minor-latin;
mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;
mso-bidi-font-family:Arial;
mso-bidi-theme-font:minor-bidi;
mso-ansi-language:EN-CA;}
</style>
<![endif]-->



<!--StartFragment-->





<!--EndFragment--></p><p class=\"MsoNormal\" style=\"margin-left:.25in;text-align:justify\"><span lang=\"EN-CA\" style=\"font-size:12.0pt;line-height:107%;font-family:&quot;Times New Roman&quot;,serif;
mso-ascii-theme-font:major-bidi;mso-hansi-theme-font:major-bidi;mso-bidi-theme-font:
major-bidi\">The input data consist of the R and L values of each winding, the
turn ratios, and the information for magnetization branch.<o:p></o:p></span></p>

<!--EndFragment--></body></html>", revisions = "<html><head></head><body>Rev 1 12/10/2019 by Alireza Masoom</body></html>"));
end Nonideal_Unit;
