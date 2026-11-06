within Dynawo.Electrical.PEIR.Plants.Average.BaseClasses;

model PlantController "Simplified Plant Controller - no internal filters, u+lambdaQ, P with frequency droop, deadbands"
  /**
     * Author Gaia Bergamaschi
     * Simplified plant-level P–f and Q–U controller for the GFL converter.
     *
     * This model implements a plant controller that generates active and reactive
     * power references for the converter outer control loops. It operates on
     * filtered measurements of PCC voltage, active power and reactive power, and
     * uses frequency information from the PLL.
     *
     * Main functions:
     *   - Reactive/voltage control via a U + λ·Q characteristic:
     *       • Forms the composite signal U + λ·Q from filtered voltage and
     *         reactive power.
     *       • Compares it against a voltage reference URefPu.
     *       • Applies a deadband on the voltage error (±DbdPu).
     *       • Feeds the result to a PI controller with output limits [QMinPu, QMaxPu].
     *       • Outputs QInjRefPu (reactive power reference, generator convention).
     *
     *   - Active power / frequency droop control:
     *       • Computes frequency error between a reference (const = 1 pu) and the
     *         measured PLL frequency omegaPLLPu.
     *       • Applies an asymmetric deadband on frequency error [−FDbd1Pu, +FDbd2Pu].
     *       • Scales the net frequency error by KDroop and limits it to
     *         [FEMinPu, FEMaxPu].
     *       • Adds this droop term to the active power reference PRefPu to obtain
     *         an effective reference PRefEff.
     *       • Forms the active power error PRefEff − PFiltPu and feeds it to a
     *         PI controller with output limits [PMinPu, PMaxPu].
     *       • Outputs PInjRefPu (active power reference, generator convention).
     *
     * Inputs (per-unit):
     *   - URefPu    : voltage set-point for U + λ·Q loop.
     *   - UFiltPu   : filtered PCC voltage magnitude.
     *   - QFiltPu   : filtered reactive power (generator convention).
     *   - PRefPu    : active power set-point (no droop, generator convention).
     *   - PFiltPu   : filtered active power (generator convention).
     *   - omegaPLLPu: PLL frequency in pu (base SystemBase.omegaNom).
     *
     * Outputs (per-unit):
     *   - QInjRefPu : reactive power reference to converter outer loop
     *                 (generator convention, limited between QMinPu and QMaxPu).
     *   - PInjRefPu : active power reference to converter outer loop
     *                 (generator convention, limited between PMinPu and PMaxPu).
     *
     * All quantities are expressed in per-unit on the machine/system base. This
     * plant controller assumes that signal filtering is done externally; it only
     * applies deadbands, droop and PI control with saturation.
     */
  // Parameters
  parameter Types.VoltageModulePu DbdPu "Voltage error deadband half-width in pu (base UNom)";
  parameter Types.AngularVelocityPu FDbd1Pu "Frequency deadband lower threshold in pu (base omegaNom)(positive value)";
  parameter Types.AngularVelocityPu FDbd2Pu "Frequency deadband upper threshold in pu (base omegaNom) (positive value)";
  parameter Types.AngularVelocityPu FEMaxPu "Maximum frequency error after droop limiter in pu (base omegaNom)";
  parameter Types.AngularVelocityPu FEMinPu "Minimum frequency error after droop limiter in pu (base omegaNom)";
  parameter Types.PerUnit KDroop "Frequency droop gain on active power (pu/pu)";
  parameter Types.PerUnit LambdaPu "Voltage droop gain in u + lambdaQ control";
  parameter Types.PerUnit Kiq "PI integral gain - voltage/Q loop";
  parameter Types.PerUnit Kpp "PI proportional gain - active power loop";
  parameter Types.PerUnit Kip "PI integral gain - active power loop";
  parameter Types.PerUnit Kpq "PI proportional gain - voltage/Q loop";
  parameter Types.ActivePowerPu PMaxPu "Maximum active power reference in pu (base SNom)";
  parameter Types.ActivePowerPu PMinPu "Minimum active power reference in pu (base SNom)";
  parameter Types.ReactivePowerPu QMaxPu "Maximum reactive power reference in pu (base SNom)";
  parameter Types.ReactivePowerPu QMinPu "Minimum reactive power reference in pu (base SNom)";

  // Inputs
  Modelica.Blocks.Interfaces.RealInput omegaPLLPu(start = Omega0Pu) "Measured frequency from PLL (pu)" annotation(
    Placement(transformation(origin = {-160, -81}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -9}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput PFiltPu(start = P0Pu) "Filtered active power (pu)" annotation(
    Placement(transformation(origin = {-160, -100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) "Active power setpoint - constant (pu)" annotation(
    Placement(transformation(origin = {-160, -10}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QFiltPu(start = Q0Pu) "Filtered reactive power (pu)" annotation(
    Placement(transformation(origin = {-160, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {8, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput UFiltPu(start = U0Pu) "Filtered PCC voltage magnitude (pu)" annotation(
    Placement(transformation(origin = {-160, 59}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {56, -111}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage setpoint (pu)" annotation(
    Placement(transformation(origin = {-160, 80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -48}, extent = {{-10, -10}, {10, 10}})));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput PInjRefPu(start = PInj0Pu) "Active power reference to outer loop (pu)" annotation(
    Placement(transformation(origin = {160, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {116, 38}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput QInjRefPu(start = QInj0Pu) "Reactive power reference to outer loop (pu)" annotation(
    Placement(transformation(origin = {160, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {116, -48}, extent = {{-10, -10}, {10, 10}})));

  // Internal blocks
  // --- Reactive / voltage path ---------------------------------
  // lambda * Q_filt
  Modelica.Blocks.Math.Gain lambdaGain(k = LambdaPu) annotation(
    Placement(transformation(origin = {-70, 20}, extent = {{-10, -10}, {10, 10}})));
  // U + lambda*Q
  Modelica.Blocks.Math.Add uLambdaQ annotation(
    Placement(transformation(origin = {-30, 40}, extent = {{-10, -10}, {10, 10}})));
  // URef - (U + lambda*Q)
  Modelica.Blocks.Math.Add voltageErr(k2 = -1) annotation(
    Placement(transformation(origin = {30, 60}, extent = {{-10, -10}, {10, 10}})));
  // Deadband on voltage error
  Modelica.Blocks.Nonlinear.DeadZone voltDeadband(uMax = DbdPu, uMin = -DbdPu) annotation(
    Placement(transformation(origin = {71, 60}, extent = {{-10, -10}, {10, 10}})));
  // Q PI controller
  Modelica.Blocks.Continuous.LimPID piQ(controllerType = Modelica.Blocks.Types.SimpleController.PI, k = Kpq, Ti = Kpq/Kiq, yMax = QMaxPu, yMin = QMinPu, xi_start = QInj0Pu/Kpq, y_start = QInj0Pu, initType = Modelica.Blocks.Types.InitPID.InitialState) annotation(
    Placement(transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant zeroQ(k = 0) annotation(
    Placement(transformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  // --- Active power path with frequency droop ------------------
  // omega_ref - omega_PLL
  Modelica.Blocks.Math.Add freqErr(k1 = +1, k2 = -1) annotation(
    Placement(transformation(origin = {-130, -59}, extent = {{-10, -10}, {10, 10}})));
  // Deadband on frequency error
  Modelica.Blocks.Nonlinear.DeadZone freqDeadband(uMax = FDbd2Pu, uMin = -FDbd1Pu) annotation(
    Placement(transformation(origin = {-89, -61}, extent = {{-10, -10}, {10, 10}})));
  // Frequency droop: KDroop * delta_omega
  Modelica.Blocks.Math.Gain droopGain(k = KDroop) annotation(
    Placement(transformation(origin = {-49, -60}, extent = {{-9, -9}, {9, 9}})));
  // Limiter on frequency droop output
  Modelica.Blocks.Nonlinear.Limiter freqErrLim(uMax = FEMaxPu, uMin = FEMinPu) annotation(
    Placement(transformation(origin = {-10, -61}, extent = {{-10, -10}, {10, 10}})));
  // PRef_eff = PRef + KDroop*(omega_ref - omega_PLL)
  Modelica.Blocks.Math.Add PRefEff annotation(
    Placement(transformation(origin = {30, -21}, extent = {{-10, -10}, {10, 10}})));
  // PRef_eff - P_filt
  Modelica.Blocks.Math.Add activePowerErr(k2 = -1) annotation(
    Placement(transformation(origin = {70, -41}, extent = {{-10, -10}, {10, 10}})));
  // P PI controller
  Modelica.Blocks.Continuous.LimPID piP(controllerType = Modelica.Blocks.Types.SimpleController.PI, k = Kpp, Ti = Kpp/Kip, yMax = PMaxPu, yMin = PMinPu, xi_start = PInj0Pu/Kpp, y_start = PInj0Pu, initType = Modelica.Blocks.Types.InitPID.InitialState) annotation(
    Placement(transformation(origin = {110, -41}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant zeroP(k = 0) annotation(
    Placement(transformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant const(k = 1) annotation(
    Placement(transformation(origin = {-160, -40}, extent = {{-10, -10}, {10, 10}})));

  // ── Start values ─────────────────────────────────────────────
  parameter Real U0Pu "Initial PCC voltage magnitude (pu)";
  parameter Real Q0Pu "Initial reactive power (pu) in generator convention";
  parameter Real P0Pu "Initial active power (pu) in generator convention";
  parameter Real Omega0Pu "Initial frequency (pu) - nominal";
  parameter Real QInj0Pu "Initial reactive power in pu in generator convention";
  parameter Real PInj0Pu "Initial active power in pu in generator convention";
  final parameter Real URef0Pu = U0Pu + LambdaPu*Q0Pu;
  // PRef0: frequency error = 0 at t=0 => PRef0 = P0
  final parameter Real PRef0Pu = P0Pu;

equation
// ── Reactive / voltage path ──────────────────────────────────
  connect(QFiltPu, lambdaGain.u) annotation(
    Line(points = {{-160, 20}, {-82, 20}}, color = {0, 0, 127}));
  connect(UFiltPu, uLambdaQ.u1) annotation(
    Line(points = {{-160, 59}, {-60, 59}, {-60, 46}, {-42, 46}}, color = {0, 0, 127}));
  connect(lambdaGain.y, uLambdaQ.u2) annotation(
    Line(points = {{-59, 20}, {-50.5, 20}, {-50.5, 34}, {-42, 34}}, color = {0, 0, 127}));
  connect(URefPu, voltageErr.u1) annotation(
    Line(points = {{-160, 80}, {0, 80}, {0, 66}, {18, 66}}, color = {0, 0, 127}));
  connect(uLambdaQ.y, voltageErr.u2) annotation(
    Line(points = {{-19, 40}, {0, 40}, {0, 54}, {18, 54}}, color = {0, 0, 127}));
  connect(voltageErr.y, voltDeadband.u) annotation(
    Line(points = {{41, 60}, {59, 60}}, color = {0, 0, 127}));
  connect(voltDeadband.y, piQ.u_s) annotation(
    Line(points = {{82, 60}, {98, 60}}, color = {0, 0, 127}));
  connect(zeroQ.y, piQ.u_m) annotation(
    Line(points = {{110, 41}, {110, 48}}, color = {0, 0, 127}));
  connect(piQ.y, QInjRefPu) annotation(
    Line(points = {{121, 60}, {160, 60}}, color = {0, 0, 127}));
// ── Active power path ────────────────────────────────────────
  connect(freqErr.y, freqDeadband.u) annotation(
    Line(points = {{-119, -59}, {-110, -59}, {-110, -61}, {-101, -61}}, color = {0, 0, 127}));
  connect(PFiltPu, activePowerErr.u2) annotation(
    Line(points = {{-160, -100}, {40, -100}, {40, -47}, {58, -47}}, color = {0, 0, 127}));
  connect(piP.y, PInjRefPu) annotation(
    Line(points = {{121, -41}, {141, -41}, {141, -40}, {160, -40}}, color = {0, 0, 127}));
  connect(piP.u_m, zeroP.y) annotation(
    Line(points = {{110, -52}, {110, -58}}, color = {0, 0, 127}));
  connect(activePowerErr.y, piP.u_s) annotation(
    Line(points = {{82, -40}, {98, -40}}, color = {0, 0, 127}));
  connect(PRefEff.y, activePowerErr.u1) annotation(
    Line(points = {{41, -21}, {50, -21}, {50, -34}, {58, -34}}, color = {0, 0, 127}));
  connect(freqErrLim.y, PRefEff.u2) annotation(
    Line(points = {{1, -61}, {8, -61}, {8, -26}, {18, -26}}, color = {0, 0, 127}));
  connect(droopGain.y, freqErrLim.u) annotation(
    Line(points = {{-40, -60}, {-30, -60}, {-30, -61}, {-22, -61}}, color = {0, 0, 127}));
  connect(freqDeadband.y, droopGain.u) annotation(
    Line(points = {{-78, -60}, {-60, -60}}, color = {0, 0, 127}));
  connect(const.y, freqErr.u1) annotation(
    Line(points = {{-149, -40}, {-146, -40}, {-146, -53}, {-142, -53}}, color = {0, 0, 127}));
  connect(omegaPLLPu, freqErr.u2) annotation(
    Line(points = {{-160, -80}, {-148, -80}, {-148, -64}, {-142, -64}}, color = {0, 0, 127}));
  connect(PRefPu, PRefEff.u1) annotation(
    Line(points = {{-160, -10}, {0, -10}, {0, -14}, {18, -14}}, color = {0, 0, 127}));

  annotation(
    uses(Modelica(version = "3.2.3"), Dynawo(version = "1.8.0")),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 40}, extent = {{-80, 20}, {80, -20}}, textString = "Plant Controller"), Text(origin = {0, 10}, extent = {{-80, 15}, {80, -15}}, textString = "u + lambda·Q"), Text(origin = {0, -15}, extent = {{-80, 15}, {80, -15}}, textString = "P + freq droop"), Text(origin = {0, -40}, extent = {{-80, 15}, {80, -15}}, textString = "deadbands")}, coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(extent = {{-150, -110}, {150, 110}})));
end PlantController;
