within Dynawo.Electrical.Controls.Converters.EpriGFM;

model CurrentLimiter
  extends Parameters.CurrentLimiter;

  Modelica.Blocks.Interfaces.RealInput iqConvRefPu(start = 1) "unlimited q-axis current in pu  (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-260, -15}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110,-40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput iqConvRefLimPu(start = 1) "limited q-axis current in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-260, -15}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110,40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealInput idConvRefPu(start = 1) "unlimited d-axis current in pu  (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-260, -15}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110,40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput idConvRefLimPu(start = 1) "limited d-axis current in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-260, -15}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110,-40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

parameter Real Ipmax_pPu = IMaxPu;
parameter Real Iqmax_qPu = IMaxPu;
Real Iqmax_pPu;
Real Ipmax_qPu;

equation 

if not(PQflag) then

  //    ----- P Priority -----
  
  Iqmax_pPu = noEvent(if IMaxPu^2 > idConvRefPu^2 then sqrt(IMaxPu^2 - idConvRefPu^2) else 0);
  Ipmax_qPu = 0;
  
  if idConvRefPu > Ipmax_pPu then
      idConvRefLimPu = Ipmax_pPu;
  elseif idConvRefPu < -Ipmax_pPu then
      idConvRefLimPu = -Ipmax_pPu;
  else
      idConvRefLimPu = idConvRefPu;
  end if;
  
  if iqConvRefPu > Iqmax_pPu then
      iqConvRefLimPu = Iqmax_pPu;
  elseif iqConvRefPu < -Iqmax_pPu then
      iqConvRefLimPu = -Iqmax_pPu;
  else
          iqConvRefLimPu = iqConvRefPu;
  end if;

else
  //    ----- Q Priority -----
  Ipmax_qPu = noEvent(if IMaxPu^2 > iqConvRefPu^2 then sqrt(IMaxPu^2 - iqConvRefPu^2) else 0);
  Iqmax_pPu = 0;
  if iqConvRefPu > Iqmax_qPu then
      iqConvRefLimPu = Iqmax_qPu;
  elseif iqConvRefPu < -Iqmax_qPu then
      iqConvRefLimPu = -Iqmax_qPu;
  else
          iqConvRefLimPu = iqConvRefPu;
  end if;

  if idConvRefPu > Ipmax_qPu then
      idConvRefLimPu = Ipmax_qPu;
  elseif idConvRefPu < -Ipmax_qPu then
      idConvRefLimPu = -Ipmax_qPu;
  else
     idConvRefLimPu = idConvRefPu;
  end if;
end if;


end CurrentLimiter;
