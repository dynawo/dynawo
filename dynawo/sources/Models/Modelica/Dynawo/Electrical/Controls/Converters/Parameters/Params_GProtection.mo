within Dynawo.Electrical.Controls.Converters.Parameters;

record Params_GProtection

  parameter Real tableTuoveruWTfilt11 = 0;
  parameter Real tableTuoveruWTfilt12 = 0.33;
  parameter Real tableTuoveruWTfilt21 = 0.5;
  parameter Real tableTuoveruWTfilt22 = 0.33;
  parameter Real tableTuoveruWTfilt31 = 1;
  parameter Real tableTuoveruWTfilt32 = 0.33;
  parameter Real tableTuoveruWTfilt[:,:] = [tableTuoveruWTfilt11,tableTuoveruWTfilt12;tableTuoveruWTfilt21,tableTuoveruWTfilt22;tableTuoveruWTfilt31,tableTuoveruWTfilt32] "PQ diagram";

  parameter Real tableTuunderuWTfilt11 = 0;
  parameter Real tableTuunderuWTfilt12 = -0.33;
  parameter Real tableTuunderuWTfilt21 = 0.5;
  parameter Real tableTuunderuWTfilt22 = -0.33;
  parameter Real tableTuunderuWTfilt31 = 1;
  parameter Real tableTuunderuWTfilt32 = -0.33;
  parameter Real tableTuunderuWTfilt[:,:] = [tableTuunderuWTfilt11,tableTuunderuWTfilt12;tableTuunderuWTfilt21,tableTuunderuWTfilt22;tableTuunderuWTfilt31,tableTuunderuWTfilt32] "PQ diagram";

  parameter Real tableTfoverfWTfilt11 = 0;
  parameter Real tableTfoverfWTfilt12 = -0.33;
  parameter Real tableTfoverfWTfilt21 = 0.5;
  parameter Real tableTfoverfWTfilt22 = -0.33;
  parameter Real tableTfoverfWTfilt31 = 1;
  parameter Real tableTfoverfWTfilt32 = -0.33;
  parameter Real tableTfoverfWTfilt[:,:] = [tableTfoverfWTfilt11,tableTfoverfWTfilt12;tableTfoverfWTfilt21,tableTfoverfWTfilt22;tableTfoverfWTfilt31,tableTfoverfWTfilt32] "PQ diagram";

  parameter Real tableTfunderfWTfilt11 = 0;
  parameter Real tableTfunderfWTfilt12 = -0.33;
  parameter Real tableTfunderfWTfilt21 = 0.5;
  parameter Real tableTfunderfWTfilt22 = -0.33;
  parameter Real tableTfunderfWTfilt31 = 1;
  parameter Real tableTfunderfWTfilt32 = -0.33;
  parameter Real tableTfunderfWTfilt[:,:] = [tableTfunderfWTfilt11,tableTfunderfWTfilt12;tableTfunderfWTfilt21,tableTfunderfWTfilt22;tableTfunderfWTfilt31,tableTfunderfWTfilt32] "PQ diagram";

end Params_GProtection;
