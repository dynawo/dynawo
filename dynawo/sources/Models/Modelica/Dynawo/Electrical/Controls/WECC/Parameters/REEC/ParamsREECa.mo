within Dynawo.Electrical.Controls.WECC.Parameters.REEC;
record ParamsREECa "REEC type A parameters"
  parameter Types.PerUnit VDLIp11 annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.PerUnit VDLIp12 annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.PerUnit VDLIp21 annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.PerUnit VDLIp22 annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.PerUnit VDLIp31 annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.PerUnit VDLIp32 annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.PerUnit VDLIp41 annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.PerUnit VDLIp42 annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.PerUnit VDLIq11 annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.PerUnit VDLIq12 annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.PerUnit VDLIq21 annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.PerUnit VDLIq22 annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.PerUnit VDLIq31 annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.PerUnit VDLIq32 annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.PerUnit VDLIq41 annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.PerUnit VDLIq42 annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.PerUnit VDLIpPoints[:, :] = [VDLIp11, VDLIp12; VDLIp21, VDLIp22; VDLIp31, VDLIp32; VDLIp41, VDLIp42] "Pair of points for voltage-dependent active current limitation piecewise linear curve [u1,y1; u2,y2;...]" annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.PerUnit VDLIqPoints[:, :] = [VDLIq11, VDLIq12; VDLIq21, VDLIq22; VDLIq31, VDLIq32; VDLIq41, VDLIq42] "Pair of points for voltage-dependent reactive current limitation piecewise linear curve [u1,y1; u2,y2;...]" annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.Time tHoldIpMax "Time delay for which the active current limit (ipMaxPu) is held after voltage dip in s" annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.Time tHoldIq "Absolute value of tHoldIq defines seconds to hold current injection after voltage dip ended. tHoldIq > 0 for constant, 0 for no injection after voltage dip, tHoldIq < 0 for voltage-dependent injection (typical: -1 .. 1 s)"  annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.PerUnit IqFrzPu "Constant reactive current injection value in pu (base UNom, SNom) (typical: -0.1 .. 0.1 pu)" annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Boolean PFlag "Power reference flag: const. Pref (0) or consider generator speed (1)" annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));
  parameter Types.VoltageModulePu VRef1Pu "User-defined reference/bias on the inner-loop voltage control in pu (base UNom) (typical: 0 pu)" annotation(
    Dialog(tab = "Electrical Control", group = "REECa"));

  // Initial parameters
  parameter Types.AngularVelocityPu omegaRefWTGQPu0 "Start value of reference angular frequency of torque control in pu (base omegaNom)";

  annotation(preferredView = "text");
end ParamsREECa;
