within Dynawo.Electrical.Controls.Generic;
model GenericAutomaton "Generic control automaton, call an external model"
  import Dynawo.Electrical.Controls.Generic.Functions;
  import Dynawo.Electrical.Controls.Generic.GenericAutomatonConstants;

  parameter Types.Time SamplingTime "Automaton sampling time";
  parameter Integer NbInputs "Number of required inputs data for the automaton";
  parameter Integer NbOutputs "Number of required discrete real outputs data from the automaton";
  parameter Integer NbIntOutputs "Number of required integer outputs data from the automaton";
  parameter String Command "External command line to call";
  parameter String InputsName[GenericAutomatonConstants.inputsMaxSize] = {"EMPTY" for i in 1:GenericAutomatonConstants.inputsMaxSize} "Names of required inputs data for the automaton";
  parameter String OutputsName[GenericAutomatonConstants.outputsMaxSize] = {"EMPTY" for i in 1:GenericAutomatonConstants.outputsMaxSize} "Names of required discrete real outputs data from the automaton";
  parameter String IntOutputsName[GenericAutomatonConstants.outputsMaxSize] = {"EMPTY" for i in 1:GenericAutomatonConstants.outputsMaxSize} "Names of required integer outputs data from the automaton";
  parameter Types.Time t0Start = 0 "Start time of the automaton";
  final parameter Boolean initializeStart = if t0Start == 0 then true else false "Indicates if the automaton should be called at initialization";

  Types.Time t0(start = t0Start) "First time when the automaton will act";
  Boolean initialize(start = initializeStart) "Indicates if the automaton should be called at initialization";
  Real inputs[GenericAutomatonConstants.inputsMaxSize] "Inputs provided to the automaton";
  Real outputs[GenericAutomatonConstants.outputsMaxSize] "Discrete real outputs got from the automaton";
  Integer intOutputs[GenericAutomatonConstants.outputsMaxSize] "Integer outputs got from the automaton";

equation
  when time >= pre(t0) + SamplingTime or pre(initialize) then
    t0 = time;
    initialize = false;
    (outputs, intOutputs) = Functions.Automaton(Command, t0, inputs, InputsName, NbInputs, GenericAutomatonConstants.inputsMaxSize, OutputsName, NbOutputs, GenericAutomatonConstants.outputsMaxSize, IntOutputsName, NbIntOutputs, GenericAutomatonConstants.outputsMaxSize);
  end when;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>This model enables to call an external C method representing the behavior of any control system. For example, it could be used to call every few seconds an OPF that will change the system state, according to some objective function.</body></html>"));
end GenericAutomaton;
