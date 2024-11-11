within Dynawo.Electrical.Sources.IEC.BaseConverters;

model GenSystem3b
  extends GenSystem3_base;
  extends Parameters.GenSystem3b;
  Modelica.Blocks.Math.Product prodCrowbarP annotation(
    Placement(visible = true, transformation(origin = {-180, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product prodCrowbarQ annotation(
    Placement(visible = true, transformation(origin = {-180, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addXIm(k2 = 1 / XEqv) annotation(
    Placement(visible = true, transformation(origin = {-62, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToPolar complexToAbs annotation(
    Placement(visible = true, transformation(origin = {0, 130}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder lagTgP(T = tG)  annotation(
    Placement(visible = true, transformation(origin = {44, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder lagTgQ(T = tG)  annotation(
    Placement(visible = true, transformation(origin = {42, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative(T = tWo, k = tWo)  annotation(
    Placement(visible = true, transformation(origin = {-180, 300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D lutTCrb(table = tCrb)  annotation(
    Placement(visible = true, transformation(origin = {-140, 300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.FixedDelay delay(delayTime = 1e-6)  annotation(
    Placement(visible = true, transformation(origin = {-98, 290}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater annotation(
    Placement(visible = true, transformation(origin = {-46, 300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(visible = true, transformation(origin = {10, 300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Not not1 annotation(
    Placement(visible = true, transformation(origin = {-10, 300}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqual greaterEqual annotation(
    Placement(visible = true, transformation(origin = {84, 300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.FixedDelay delay2(delayTime = 1e-6) annotation(
    Placement(visible = true, transformation(origin = {-8, 222}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-8, 250}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switchMCrb annotation(
    Placement(visible = true, transformation(origin = {-169, 103}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Math.BooleanToReal booleanToReal annotation(
    Placement(visible = true, transformation(origin = {130, 300}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant constMCrb annotation(
    Placement(visible = true, transformation(origin = {-189, 119}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constOne(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-189, 94}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-69, 287}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 1e-6) annotation(
    Placement(visible = true, transformation(origin = {-89, 271}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
equation
  connect(ipCmdPu, prodCrowbarP.u2) annotation(
    Line(points = {{-230, 60}, {-212, 60}, {-212, 54}, {-192, 54}}, color = {0, 0, 127}));
  connect(iqCmdPu, prodCrowbarQ.u2) annotation(
    Line(points = {{-230, -20}, {-214, -20}, {-214, -26}, {-192, -26}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, addXIm.u1) annotation(
    Line(points = {{-88, -20}, {-74, -20}}, color = {0, 0, 127}));
  connect(addXIm.y, rotationWtToGrid.iqCmdPu) annotation(
    Line(points = {{-50, -26}, {-24, -26}, {-24, -18}, {-8, -18}}, color = {0, 0, 127}));
  connect(uGs2.y, complexToAbs.u) annotation(
    Line(points = {{166, 34}, {162, 34}, {162, 130}, {12, 130}}, color = {85, 170, 255}));
  connect(complexToAbs.len, addXIm.u2) annotation(
    Line(points = {{-12, 136}, {-208, 136}, {-208, -60}, {-82, -60}, {-82, -32}, {-74, -32}}, color = {0, 0, 127}));
  connect(rateLimitP.y, rotationWtToGrid.ipCmdPu) annotation(
    Line(points = {{-88, 60}, {-24, 60}, {-24, 0}, {-8, 0}}, color = {0, 0, 127}));
  connect(lagTgQ.y, addXIm.u2) annotation(
    Line(points = {{54, -40}, {66, -40}}, color = {0, 0, 127}));
  connect(rotationWtToGrid.iGsImPu, lagTgQ.u) annotation(
    Line(points = {{10, -30}, {20, -30}, {20, -40}, {30, -40}}, color = {0, 0, 127}));
  connect(rotationWtToGrid.iGsRePu, lagTgP.u) annotation(
    Line(points = {{10, -8}, {20, -8}, {20, 60}, {32, 60}}, color = {0, 0, 127}));
  connect(lagTgP.y, addXRe.u1) annotation(
    Line(points = {{56, 60}, {66, 60}}, color = {0, 0, 127}));
  connect(derivative.u, complexToAbs.len) annotation(
    Line(points = {{-192, 300}, {-208, 300}, {-208, 136}, {-12, 136}}, color = {0, 0, 127}));
  connect(derivative.y, lutTCrb.u[1]) annotation(
    Line(points = {{-169, 300}, {-152, 300}}, color = {0, 0, 127}));
  connect(lutTCrb.y[1], greater.u1) annotation(
    Line(points = {{-129, 300}, {-59, 300}}, color = {0, 0, 127}));
  connect(lutTCrb.y[1], delay.u) annotation(
    Line(points = {{-129, 300}, {-115, 300}, {-115, 290}, {-105, 290}}, color = {0, 0, 127}));
  connect(not1.y, timer.u) annotation(
    Line(points = {{-3.4, 300}, {3.2, 300}}, color = {255, 0, 255}));
  connect(greater.y, not1.u) annotation(
    Line(points = {{-35, 300}, {-20, 300}}, color = {255, 0, 255}));
  connect(timer.y, greaterEqual.u1) annotation(
    Line(points = {{21, 300}, {72, 300}}, color = {0, 0, 127}));
  connect(delay2.y, switch.u3) annotation(
    Line(points = {{-15, 222}, {-30.6, 222}, {-30.6, 244}, {-16, 244}}, color = {0, 0, 127}));
  connect(switch.y, delay2.u) annotation(
    Line(points = {{0, 250}, {15.7, 250}, {15.7, 222}, {-1, 222}}, color = {0, 0, 127}));
  connect(switch.y, greaterEqual.u2) annotation(
    Line(points = {{0, 250}, {55.7, 250}, {55.7, 292}, {72, 292}}, color = {0, 0, 127}));
  connect(greater.y, switch.u2) annotation(
    Line(points = {{-35, 300}, {-29, 300}, {-29, 250}, {-16, 250}}, color = {255, 0, 255}));
  connect(lutTCrb.y[1], switch.u1) annotation(
    Line(points = {{-129, 300}, {-115, 300}, {-115, 256}, {-16, 256}}, color = {0, 0, 127}));
  connect(prodCrowbarP.y, limitP.u) annotation(
    Line(points = {{-169, 60}, {-142, 60}}, color = {0, 0, 127}));
  connect(greaterEqual.y, booleanToReal.u) annotation(
    Line(points = {{95, 300}, {115, 300}}, color = {255, 0, 255}));
  connect(switchMCrb.y, prodCrowbarP.u1) annotation(
    Line(points = {{-162, 104}, {-156, 104}, {-156, 86}, {-196, 86}, {-196, 66}, {-192, 66}}, color = {0, 0, 127}));
  connect(booleanToReal.y, switchMCrb.u1) annotation(
    Line(points = {{141, 300}, {146, 300}, {146, 142}, {-202, 142}, {-202, 108}, {-178, 108}}, color = {0, 0, 127}));
  connect(constOne.y, switchMCrb.u3) annotation(
    Line(points = {{-184, 94}, {-182, 94}, {-182, 98}, {-178, 98}}, color = {0, 0, 127}));
  connect(constMCrb.y, switchMCrb.u2) annotation(
    Line(points = {{-184, 120}, {-182, 120}, {-182, 104}, {-178, 104}}, color = {255, 0, 255}));
  connect(booleanToReal.y, prodCrowbarQ.u1) annotation(
    Line(points = {{141, 300}, {146, 300}, {146, 170}, {-202, 170}, {-202, -14}, {-192, -14}}, color = {0, 0, 127}));
  connect(prodCrowbarQ.y, limitQ.u) annotation(
    Line(points = {{-168, -20}, {-142, -20}}, color = {0, 0, 127}));
  connect(delay.y, add1.u1) annotation(
    Line(points = {{-91, 290}, {-74, 290}, {-74, 291}, {-77, 291}}, color = {0, 0, 127}));
  connect(add1.y, greater.u2) annotation(
    Line(points = {{-62, 288}, {-58, 288}, {-58, 292}}, color = {0, 0, 127}));
  connect(constant1.y, add1.u2) annotation(
    Line(points = {{-83.5, 271}, {-80, 271}, {-80, 282}, {-78, 282}}, color = {0, 0, 127}));
  annotation(
    Diagram);
end GenSystem3b;
