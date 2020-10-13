within OpenEMTP.Electrical.Lines.WBmodel;
model HistoryTerm
  // This is to demonestrate History calc. for WB model
  import Modelica.ComplexMath.real;
  import Modelica.ComplexMath.imag;
  constant Complex j = Complex(0,1);

  parameter Integer m( start=3)              "Number of phases" annotation(HideResult=true);
  final parameter Integer Ng=size(Rm_H,1)    "Number of groups" annotation(HideResult=true);
  final parameter Integer No_H=size(Rm_H,2)  "Order of Fitting" annotation(HideResult=true);
  parameter Real tau[:] annotation(HideResult=true);
  parameter Complex Pm_H[:,:] annotation(HideResult=true);
  parameter Complex Rm_H[:,:,:,:] annotation(HideResult=true);
  Real i_kr[m] annotation(HideResult=true);                // i_ku:  forward traveling current-wave vector from k-end
  Real i_mr[m] annotation(HideResult=true);                // i_mu:  forward traveling current-wave vector from m-end

// i_hmu: i_mu with delay
  Real xR_k[Ng, No_H, m](start=zeros(Ng, No_H, m),each fixed=true) annotation(HideResult=true);          // States convolution of propagation function  xR:Real Part, k-end
  Real xI_k[Ng, No_H, m](start=zeros(Ng, No_H, m),each fixed=true) annotation(HideResult=true);
// States convolution of propagation function  xI:Imaginary Part, k-end
  Real xR_m[Ng, No_H, m](start=zeros(Ng, No_H, m),each fixed=true) annotation(HideResult=true);          // States convolution of propagation function  xR:Real Part, m-end
  Real xI_m[Ng, No_H, m](start=zeros(Ng, No_H, m),each fixed=true) annotation(HideResult=true);
// States convolution of propagation function  xI:Imaginary Part, m-end


  //  i_k: injected current in k-end
  //  i_m: injected current in m-end
  Modelica.Blocks.Interfaces.RealInput ik[m] annotation (
    Placement(visible = true, transformation(origin = {-88, 22}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-83, 60}, extent = {{-17, -17}, {17, 17}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput im[m] annotation (
    Placement(visible = true, transformation(origin = {88, 30}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {84, 60}, extent = {{16, -16}, {-16, 16}}, rotation = 0)));
  //  i_ki: incident current in k-end
  //  i_mi: incident current in m-end
  Modelica.Blocks.Interfaces.RealOutput i_ki[m] annotation (
    Placement(visible = true, transformation(origin = {8, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-38, -66}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput i_mi[m] annotation (
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {34, -66}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
 Real i_hkr[m, Ng] annotation(HideResult=true);             // i_hku: i_ku with delay
 Real i_hmr[m, Ng] annotation(HideResult=true);
// i_hmu: i_mu with delay
equation

i_kr = i_ki + ik;
i_mr = i_mi + im;
  for k in 1:Ng loop

    if time<tau[k] then
      i_hmr[:, k] =zeros(m);
      i_hkr[:, k] =zeros(m);
      else
    i_hmr[:, k] = delay(i_mr, tau[k]);
    i_hkr[:, k] = delay(i_kr, tau[k]);
    end if;

    for p in 1:No_H loop
      for i in 1:m loop
// calc of History cuurent k-end
        der(xR_k[k, p, i]) = real(Pm_H[k, p]) * xR_k[k, p, i] - imag(Pm_H[k, p]) * xI_k[k, p, i] + real(Rm_H[k, p, i, :]) * i_hmr[:, k];
        der(xI_k[k, p, i]) = imag(Pm_H[k, p]) * xR_k[k, p, i] + real(Pm_H[k, p]) * xI_k[k, p, i] + imag(Rm_H[k, p, i, :]) * i_hmr[:, k];
// calc of History cuurent m-end
        der(xR_m[k, p, i]) = real(Pm_H[k, p]) * xR_m[k, p, i] - imag(Pm_H[k, p]) * xI_m[k, p, i] + real(Rm_H[k, p, i, :]) * i_hkr[:, k];
        der(xI_m[k, p, i]) = imag(Pm_H[k, p]) * xR_m[k, p, i] + real(Pm_H[k, p]) * xI_m[k, p, i] + imag(Rm_H[k, p, i, :]) * i_hkr[:, k];
      end for;
    end for;
  end for;
//summation of fitting orders for each phase
  for i in 1:m loop
    i_ki[i] = sum(xR_k[:, :, i]);
    i_mi[i] = sum(xR_m[:, :, i]);
  end for;

annotation (
    uses(Modelica(version="3.2.3")),
    Diagram,
  Icon(graphics={Text(origin = {32, -48}, extent = {{-8, 10}, {8, -10}}, textString = "i_mi"), Rectangle(origin = {0, 10}, extent = {{-80, 70}, {80, -70}}), Text(origin = {-38, -48}, extent = {{-8, 10}, {8, -10}}, textString = "i_ki"), Text(origin = {-56, 66}, extent = {{-8, 10}, {8, -10}}, textString = "ik"), Text(origin = {54, 66}, extent = {{-8, 10}, {8, -10}}, textString = "im"),  Text(origin = {9, 7}, extent = {{-41, 21}, {29, -15}}, textString = "History")}, coordinateSystem(initialScale = 0.1)),
    experiment(
      StopTime=0.05,
      Interval=1e-06,
      Tolerance=0.001,
      __Dymola_fixedstepsize=1e-06,
      __Dymola_Algorithm="Dassl"));
end HistoryTerm;
