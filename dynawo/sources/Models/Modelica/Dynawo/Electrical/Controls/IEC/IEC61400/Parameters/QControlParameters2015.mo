within Dynawo.Electrical.Controls.IEC.IEC61400.Parameters;
record QControlParameters2015
  parameter Real TableQwpUErr11 = -0.05 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr12 = 1.21 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr21 = 0 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr22 = 0.21 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr31 = 0.05 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr32 = -0.79 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr41 = 0.06 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr42 = -0.79 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr51 = 0.07 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr52 = -0.79 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr61 = 0.08 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr62 = -0.79 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr[:,:] = [TableQwpUErr11, TableQwpUErr12; TableQwpUErr21, TableQwpUErr22; TableQwpUErr31, TableQwpUErr32; TableQwpUErr41, TableQwpUErr42; TableQwpUErr51, TableQwpUErr52; TableQwpUErr61, TableQwpUErr62] "Table for the UQ static mode" annotation(
    Dialog(tab = "QControlTables"));

  annotation(
    preferredView = "text");
end QControlParameters2015;
