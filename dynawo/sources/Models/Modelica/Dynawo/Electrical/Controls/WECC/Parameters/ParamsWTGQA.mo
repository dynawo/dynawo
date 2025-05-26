within Dynawo.Electrical.Controls.WECC.Parameters;

    record ParamsWTGQA
    parameter Types.Frequency kip "Integral gain" annotation (Dialog(tab="Torque control"));
    parameter Real kpp "Proportional gain"annotation (Dialog(tab="Torque control"));
    parameter Types.Time tp "Power measurement lag time constant"annotation (Dialog(tab="Torque control"));
    parameter Types.Time twref "Speed reference time constant"annotation (Dialog(tab="Torque control"));
    parameter Types.PerUnit temax "Maximum torque"annotation (Dialog(tab="Torque control"));
    parameter Types.PerUnit temin "Minimum torque"annotation (Dialog(tab="Torque control"));
    parameter Real p1" 1st power point for extrapolation table"annotation (Dialog(tab="Torque control"));
    parameter Types.PerUnit spd1 " 1st speed point for extrapolation table"annotation (Dialog(tab="Torque control"));
    parameter Types.PerUnit p2" 2nd power point for extrapolation table"annotation (Dialog(tab="Torque control"));
    parameter Types.PerUnit spd2 " 2nd speed point for extrapolation table"annotation (Dialog(tab="Torque control"));
    parameter Types.PerUnit p3" 3rd power point for extrapolation table"annotation (Dialog(tab="Torque control"));
    parameter Types.PerUnit spd3 " 3rd speed point for extrapolation table"annotation (Dialog(tab="Torque control"));
    parameter Types.PerUnit p4" 4th power point for extrapolation table"annotation (Dialog(tab="Torque control"));
    parameter Types.PerUnit spd4 " 4th speed point for extrapolation table"annotation (Dialog(tab="Torque control"));
    parameter Boolean tflag "Flag to specify PI controller Input"annotation (Dialog(tab="Torque control"));
    parameter Real PInj0Pu "Start value of active power at injector terminal in pu (generator convention) (base SNom)" annotation (Dialog(group="Initialization"));

end ParamsWTGQA;
