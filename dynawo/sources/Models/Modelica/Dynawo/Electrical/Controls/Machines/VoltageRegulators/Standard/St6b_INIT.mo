within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;
model St6b_INIT "IEEE excitation system type ST4B initialization model"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.Stxc_INIT(
    Ki = 0,
    Sw1 = true,
    XlPu = 0);

  annotation(preferredView = "text");
end St6b_INIT;
