within Dynawo.Electrical.Controls.Converters.Parameters;

record Params_PControl

  parameter Real tablePwpbiasFwpfiltCom11 = 0.95;
  parameter Real tablePwpbiasFwpfiltCom12 = 1;
  parameter Real tablePwpbiasFwpfiltCom21 = 1;
  parameter Real tablePwpbiasFwpfiltCom22 = 0;
  parameter Real tablePwpbiasFwpfiltCom31 = 1.05;
  parameter Real tablePwpbiasFwpfiltCom32 = -1;

  parameter Real tablePwpbiasFwpfiltCom[:,:] = [tablePwpbiasFwpfiltCom11,tablePwpbiasFwpfiltCom12;tablePwpbiasFwpfiltCom21,tablePwpbiasFwpfiltCom22;tablePwpbiasFwpfiltCom31,tablePwpbiasFwpfiltCom32] "Pf diagram";

end Params_PControl;
