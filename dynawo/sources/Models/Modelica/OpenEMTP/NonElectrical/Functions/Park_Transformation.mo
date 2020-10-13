within OpenEMTP.NonElectrical.Functions;

function Park_Transformation
  extends UserGuide.Icons.Function;
  input Real theta "Angle";
  output Real K[3, 3] ;   // "Transformation Matrix"
protected
  Real alpha;
algorithm
  alpha:=2*Modelica.Constants.pi/3;
  K:=2/3*[cos(theta), cos(theta-alpha), cos(theta+alpha);
          sin(theta), sin(theta-alpha), sin(theta+alpha);
             0.5    ,       0.5       ,       0.5];
annotation(
    Documentation(info = "<html><head></head><body><div><b>Park's Transformation</b></div><div><!--StartFragment--><span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);\">The transformation originally proposed by Park differs slightly from the one given above. In Park's transformation q-axis is ahead of d-axis, qd0, and the&nbsp;</span><span class=\"mwe-math-element\" style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);\"><span class=\"mwe-math-mathml-inline mwe-math-mathml-a11y\" style=\"display: none; clip: rect(1px 1px 1px 1px); overflow: hidden; position: absolute; width: 1px; height: 1px; opacity: 0;\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\" alttext=\"{\displaystyle heta }\"><semantics><annotation encoding=\"application/x-tex\">{\displaystyle heta }</annotation></semantics></math></span><img src=\"https://wikimedia.org/api/rest_v1/media/math/render/svg/6e5ab2664b422d53eb0c7df3b87e1360d75ad9af\" class=\"mwe-math-fallback-image-inline\" aria-hidden=\"true\" alt=\"	heta \" style=\"border: 0px; vertical-align: -0.338ex; margin: 0px; display: inline-block; width: 1.09ex; height: 2.176ex;\"></span><span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);\">&nbsp;angle is the angle between phase-a and q-axis</span></div><div><span style=\"color: rgb(32, 33, 34); font-family: sans-serif; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);\"><br></span></div><div><br></div><div><em>2020-07-31 &nbsp;&nbsp;</em>&nbsp;by Alireza Masoom initially implemented</div></body></html>"));
end Park_Transformation;
