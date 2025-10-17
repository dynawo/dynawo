//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file JOBXmlHandler.cpp
 * @brief Handler for jobs file implementation
 *
 * JobsHandler is the implementation of Dynawo handler for parsing jobs
 * files.
 */
#include <boost/phoenix/core.hpp>
#include <boost/phoenix/operator/self.hpp>
#include <boost/phoenix/bind.hpp>

#include <xml/sax/parser/Attributes.h>

#include "JOBXmlHandler.h"
#include "JOBAppenderEntry.h"
#include "JOBConstraintsEntry.h"
#include "JOBCurvesEntry.h"
#include "JOBDynModelsEntry.h"
#include "JOBFinalStateEntry.h"
#include "JOBInitValuesEntry.h"
#include "JOBInitialStateEntry.h"
#include "JOBJobsCollectionFactory.h"
#include "JOBJobEntry.h"
#include "JOBJobsCollection.h"
#include "JOBLogsEntry.h"
#include "JOBModelerEntry.h"
#include "JOBNetworkEntry.h"
#include "JOBOutputsEntry.h"
#include "JOBSimulationEntry.h"
#include "JOBSolverEntry.h"
#include "JOBTimelineEntry.h"
#include "JOBTimetableEntry.h"
#include "DYNMacrosMessage.h"
#include "DYNEnumUtils.h"
#include "JOBModelsDirEntry.h"

#include "DYNExecUtils.h"

using std::map;
using std::string;
using std::vector;

using std::shared_ptr;

namespace lambda = boost::phoenix;
namespace lambda_args = lambda::placeholders;
namespace parser = xml::sax::parser;

namespace job {

// namespace used to read xml file
static parser::namespace_uri& namespace_uri() {
  static parser::namespace_uri namespace_uri("http://www.rte-france.com/dynawo");
  return namespace_uri;
}

XmlHandler::XmlHandler() :
jobsCollection_(JobsCollectionFactory::newInstance()),
jobHandler_(parser::ElementName(namespace_uri(), "job")) {
  onElement(namespace_uri()("jobs/job"), jobHandler_);
  jobHandler_.onEnd(lambda::bind(&XmlHandler::addJob, lambda::ref(*this)));
}

XmlHandler::~XmlHandler() {}

void
XmlHandler::addJob() {
  jobsCollection_->addJob(jobHandler_.get());
}

std::shared_ptr<JobsCollection>
XmlHandler::getJobsCollection() const {
  return jobsCollection_;
}

JobHandler::JobHandler(elementName_type const& root_element) :
solverHandler_(parser::ElementName(namespace_uri(), "solver")),
modelerHandler_(parser::ElementName(namespace_uri(), "modeler")),
simulationHandler_(parser::ElementName(namespace_uri(), "simulation")),
outputsHandler_(parser::ElementName(namespace_uri(), "outputs")),
localInitHandler_(parser::ElementName(namespace_uri(), "localInit")) {
  onStartElement(root_element, lambda::bind(&JobHandler::create, lambda::ref(*this), lambda_args::arg2));

  onElement(root_element + namespace_uri()("solver"), solverHandler_);
  onElement(root_element + namespace_uri()("modeler"), modelerHandler_);
  onElement(root_element + namespace_uri()("simulation"), simulationHandler_);
  onElement(root_element + namespace_uri()("outputs"), outputsHandler_);
  onElement(root_element + namespace_uri()("localInit"), localInitHandler_);

  solverHandler_.onEnd(lambda::bind(&JobHandler::addSolver, lambda::ref(*this)));
  modelerHandler_.onEnd(lambda::bind(&JobHandler::addModeler, lambda::ref(*this)));
  simulationHandler_.onEnd(lambda::bind(&JobHandler::addSimulation, lambda::ref(*this)));
  outputsHandler_.onEnd(lambda::bind(&JobHandler::addOutputs, lambda::ref(*this)));
  localInitHandler_.onEnd(lambda::bind(&JobHandler::addLocalInit, lambda::ref(*this)));
}

JobHandler::~JobHandler() {}

void
JobHandler::addSolver() {
  job_->setSolverEntry(solverHandler_.get());
}

void
JobHandler::addModeler() {
  job_->setModelerEntry(modelerHandler_.get());
}

void
JobHandler::addSimulation() {
  job_->setSimulationEntry(simulationHandler_.get());
}

void
JobHandler::addOutputs() {
  job_->setOutputsEntry(outputsHandler_.get());
}

void
JobHandler::addLocalInit() {
  job_->setLocalInitEntry(localInitHandler_.get());
}

void
JobHandler::create(attributes_type const& attributes) {
  job_ = std::make_shared<JobEntry>();
  job_->setName(attributes["name"]);
}

shared_ptr<JobEntry>
JobHandler::get() const {
  return job_;
}

SolverHandler::SolverHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&SolverHandler::create, lambda::ref(*this), lambda_args::arg2));
}

SolverHandler::~SolverHandler() {}

void
SolverHandler::create(attributes_type const & attributes) {
  solver_ = std::make_shared<SolverEntry>();
  solver_->setLib(attributes["lib"]);
  solver_->setParametersFile(attributes["parFile"]);
  solver_->setParametersId(attributes["parId"]);
}

shared_ptr<SolverEntry>
SolverHandler::get() const {
  return solver_;
}

ModelerHandler::ModelerHandler(elementName_type const& root_element) :
networkHandler_(parser::ElementName(namespace_uri(), "network")),
dynModelsHandler_(parser::ElementName(namespace_uri(), "dynModels")),
initialStateHandler_(parser::ElementName(namespace_uri(), "initialState")),
preCompiledModelsHandler_(parser::ElementName(namespace_uri(), "precompiledModels")),
modelicaModelsHandler_(parser::ElementName(namespace_uri(), "modelicaModels")) {
  onElement(root_element + namespace_uri()("network"), networkHandler_);
  onElement(root_element + namespace_uri()("dynModels"), dynModelsHandler_);
  onElement(root_element + namespace_uri()("initialState"), initialStateHandler_);
  onElement(root_element + namespace_uri()("precompiledModels"), preCompiledModelsHandler_);
  onElement(root_element + namespace_uri()("modelicaModels"), modelicaModelsHandler_);

  onStartElement(root_element, lambda::bind(&ModelerHandler::create, lambda::ref(*this), lambda_args::arg2));

  networkHandler_.onEnd(lambda::bind(&ModelerHandler::addNetwork, lambda::ref(*this)));
  dynModelsHandler_.onEnd(lambda::bind(&ModelerHandler::addDynModel, lambda::ref(*this)));
  initialStateHandler_.onEnd(lambda::bind(&ModelerHandler::addInitialState, lambda::ref(*this)));
  preCompiledModelsHandler_.onEnd(lambda::bind(&ModelerHandler::addPreCompiledModels, lambda::ref(*this)));
  modelicaModelsHandler_.onEnd(lambda::bind(&ModelerHandler::addModelicaModel, lambda::ref(*this)));
}

ModelerHandler::~ModelerHandler() {}

void
ModelerHandler::addNetwork() {
  modeler_->setNetworkEntry(networkHandler_.get());
}

void
ModelerHandler::addDynModel() {
  modeler_->addDynModelsEntry(dynModelsHandler_.get());
}

void
ModelerHandler::addInitialState() {
  modeler_->setInitialStateEntry(initialStateHandler_.get());
}

void
ModelerHandler::addPreCompiledModels() {
  modeler_->setPreCompiledModelsDirEntry(preCompiledModelsHandler_.get());
}

void
ModelerHandler::addModelicaModel() {
  modeler_->setModelicaModelsDirEntry(modelicaModelsHandler_.get());
}

void
ModelerHandler::create(attributes_type const& attributes) {
  modeler_ = std::make_shared<ModelerEntry>();
  modeler_->setCompileDir(attributes["compileDir"]);
}

shared_ptr<ModelerEntry>
ModelerHandler::get() const {
  return modeler_;
}

CriteriaFileHandler::CriteriaFileHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&CriteriaFileHandler::create, lambda::ref(*this), lambda_args::arg2));
}

CriteriaFileHandler::~CriteriaFileHandler() {}

void
CriteriaFileHandler::create(attributes_type const& attributes) {
  criteriaFile_ = attributes["criteriaFile"].as_string();
}

const std::string&
CriteriaFileHandler::get() const {
  return criteriaFile_;
}

SimulationHandler::SimulationHandler(elementName_type const& root_element) :
criteriaFileHandler_(parser::ElementName(namespace_uri(), "criteria")) {
  onStartElement(root_element, lambda::bind(&SimulationHandler::create, lambda::ref(*this), lambda_args::arg2));
  onElement(root_element + namespace_uri()("criteria"), criteriaFileHandler_);

  criteriaFileHandler_.onEnd(lambda::bind(&SimulationHandler::addCriteriaFile, lambda::ref(*this)));
}

SimulationHandler::~SimulationHandler() {}

void
SimulationHandler::create(attributes_type const& attributes) {
  simulation_ = std::make_shared<SimulationEntry>();
  simulation_->setStartTime(attributes["startTime"]);
  simulation_->setStopTime(attributes["stopTime"]);
  if (attributes.has("criteriaStep"))
    simulation_->setCriteriaStep(attributes["criteriaStep"]);
  if (attributes.has("precision"))
    simulation_->setPrecision(attributes["precision"]);
  if (attributes.has("timeout")) {
    simulation_->setTimeout(attributes["timeout"]);
  }
}

shared_ptr<SimulationEntry>
SimulationHandler::get() const {
  return simulation_;
}

void
SimulationHandler::addCriteriaFile() {
  simulation_->addCriteriaFile(criteriaFileHandler_.get());
}

OutputsHandler::OutputsHandler(elementName_type const& root_element) :
initValuesHandler_(parser::ElementName(namespace_uri(), "dumpInitValues")),
finalValuesHandler_(parser::ElementName(namespace_uri(), "dumpFinalValues")),
constraintsHandler_(parser::ElementName(namespace_uri(), "constraints")),
timelineHandler_(parser::ElementName(namespace_uri(), "timeline")),
timetableHandler_(parser::ElementName(namespace_uri(), "timetable")),
finalStateHandler_(parser::ElementName(namespace_uri(), "finalState")),
curvesHandler_(parser::ElementName(namespace_uri(), "curves")),
finalStateValuesHandler_(parser::ElementName(namespace_uri(), "finalStateValues")),
lostEquipmentsHandler_(parser::ElementName(namespace_uri(), "lostEquipments")),
logsHandler_(parser::ElementName(namespace_uri(), "logs")) {
  onStartElement(root_element, lambda::bind(&OutputsHandler::create, lambda::ref(*this), lambda_args::arg2));

  onElement(root_element + namespace_uri()("dumpInitValues"), initValuesHandler_);
  onElement(root_element + namespace_uri()("dumpFinalValues"), finalValuesHandler_);
  onElement(root_element + namespace_uri()("constraints"), constraintsHandler_);
  onElement(root_element + namespace_uri()("timeline"), timelineHandler_);
  onElement(root_element + namespace_uri()("timetable"), timetableHandler_);
  onElement(root_element + namespace_uri()("finalState"), finalStateHandler_);
  onElement(root_element + namespace_uri()("curves"), curvesHandler_);
  onElement(root_element + namespace_uri()("finalStateValues"), finalStateValuesHandler_);
  onElement(root_element + namespace_uri()("lostEquipments"), lostEquipmentsHandler_);
  onElement(root_element + namespace_uri()("logs"), logsHandler_);

  initValuesHandler_.onEnd(lambda::bind(&OutputsHandler::addInitValuesEntry, lambda::ref(*this)));
  finalValuesHandler_.onEnd(lambda::bind(&OutputsHandler::addFinalValuesEntry, lambda::ref(*this)));
  constraintsHandler_.onEnd(lambda::bind(&OutputsHandler::addConstraints, lambda::ref(*this)));
  timelineHandler_.onEnd(lambda::bind(&OutputsHandler::addTimeline, lambda::ref(*this)));
  timetableHandler_.onEnd(lambda::bind(&OutputsHandler::addTimetable, lambda::ref(*this)));
  finalStateHandler_.onEnd(lambda::bind(&OutputsHandler::addFinalState, lambda::ref(*this)));
  curvesHandler_.onEnd(lambda::bind(&OutputsHandler::addCurves, lambda::ref(*this)));
  finalStateValuesHandler_.onEnd(lambda::bind(&OutputsHandler::addFinalStateValues, lambda::ref(*this)));
  lostEquipmentsHandler_.onEnd(lambda::bind(&OutputsHandler::addLostEquipments, lambda::ref(*this)));
  logsHandler_.onEnd(lambda::bind(&OutputsHandler::addLog, lambda::ref(*this)));
}

OutputsHandler::~OutputsHandler() {}

void
OutputsHandler::addInitValuesEntry() {
  outputs_->setInitValuesEntry(initValuesHandler_.get());
}

void
OutputsHandler::addFinalValuesEntry() {
  outputs_->setFinalValuesEntry(finalValuesHandler_.get());
}

void
OutputsHandler::addConstraints() {
  outputs_->setConstraintsEntry(constraintsHandler_.get());
}

void
OutputsHandler::addTimeline() {
  outputs_->setTimelineEntry(timelineHandler_.get());
}

void
OutputsHandler::addTimetable() {
  outputs_->setTimetableEntry(timetableHandler_.get());
}

void
OutputsHandler::addFinalState() {
  outputs_->addFinalStateEntry(finalStateHandler_.get());
}

void
OutputsHandler::addCurves() {
  outputs_->setCurvesEntry(curvesHandler_.get());
}

void
OutputsHandler::addFinalStateValues() {
  outputs_->setFinalStateValuesEntry(finalStateValuesHandler_.get());
}

void
OutputsHandler::addLostEquipments() {
  outputs_->setLostEquipmentsEntry(lostEquipmentsHandler_.get());
}

void
OutputsHandler::addLog() {
  outputs_->setLogsEntry(logsHandler_.get());
}

void
OutputsHandler::create(attributes_type const& attributes) {
  outputs_ = std::make_shared<OutputsEntry>();
  outputs_->setOutputsDirectory(attributes["directory"]);
}

shared_ptr<OutputsEntry>
OutputsHandler::get() const {
  return outputs_;
}

LocalInitHandler::LocalInitHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&LocalInitHandler::create, lambda::ref(*this), lambda_args::arg2));
}

LocalInitHandler::~LocalInitHandler() {}

void
LocalInitHandler::create(attributes_type const& attributes) {
  localInit_ = std::make_shared<LocalInitEntry>();
  localInit_->setParFile(attributes["parFile"]);
  localInit_->setParId(attributes["parId"]);
}

shared_ptr<LocalInitEntry>
LocalInitHandler::get() const {
  return localInit_;
}

InitValuesHandler::InitValuesHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&InitValuesHandler::create, lambda::ref(*this), lambda_args::arg2));
}

InitValuesHandler::~InitValuesHandler() {}

void
InitValuesHandler::create(attributes_type const& attributes) {
  initValuesEntry_ = std::make_shared<InitValuesEntry>();
  if (attributes.has("local"))
    initValuesEntry_->setDumpLocalInitValues(attributes["local"]);
  if (attributes.has("global"))
    initValuesEntry_->setDumpGlobalInitValues(attributes["global"]);
  if (attributes.has("init"))
    initValuesEntry_->setDumpInitModelValues(attributes["init"]);
}

shared_ptr<InitValuesEntry>
InitValuesHandler::get() const {
  return initValuesEntry_;
}

FinalValuesHandler::FinalValuesHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&FinalValuesHandler::create, lambda::ref(*this), lambda_args::arg2));
}

FinalValuesHandler::~FinalValuesHandler() {}

void
FinalValuesHandler::create(attributes_type const& /*attributes*/) {
  finalValuesEntry_ = std::make_shared<FinalValuesEntry>();
  finalValuesEntry_->setDumpFinalValues(true);
}

shared_ptr<FinalValuesEntry>
FinalValuesHandler::get() const {
  return finalValuesEntry_;
}

ConstraintsHandler::ConstraintsHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&ConstraintsHandler::create, lambda::ref(*this), lambda_args::arg2));
}

ConstraintsHandler::~ConstraintsHandler() {}

void
ConstraintsHandler::create(attributes_type const& attributes) {
  constraints_ = std::make_shared<ConstraintsEntry>();
  constraints_->setExportMode(attributes["exportMode"]);
  if (attributes.has("filter")) {
    if (attributes["filter"].as_string() == DYN::ConstraintValueTypeNames[DYN::CONSTRAINTS_KEEP_FIRST]) {
      constraints_->setFilterType(DYN::CONSTRAINTS_KEEP_FIRST);
    } else if (attributes["filter"].as_string() == DYN::ConstraintValueTypeNames[DYN::CONSTRAINTS_DYNAFLOW]) {
      constraints_->setFilterType(DYN::CONSTRAINTS_DYNAFLOW);
    } else if (attributes["filter"].as_string() == DYN::ConstraintValueTypeNames[DYN::NO_CONSTRAINTS_FILTER]) {
      constraints_->setFilterType(DYN::NO_CONSTRAINTS_FILTER);
    } else {
      throw DYNError(DYN::Error::API, ConstraintValueTypeError, attributes["filter"].as_string());
    }
  }
}

shared_ptr<ConstraintsEntry>
ConstraintsHandler::get() const {
  return constraints_;
}

TimelineHandler::TimelineHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&TimelineHandler::create, lambda::ref(*this), lambda_args::arg2));
}

TimelineHandler::~TimelineHandler() {}

void
TimelineHandler::create(attributes_type const& attributes) {
  timeline_ = std::make_shared<TimelineEntry>();
  timeline_->setExportMode(attributes["exportMode"]);
  if (attributes.has("exportTime"))
    timeline_->setExportWithTime(attributes["exportTime"]);
  if (attributes.has("maxPriority"))
    timeline_->setMaxPriority(attributes["maxPriority"]);
  if (attributes.has("filter"))
    timeline_->setFilter(attributes["filter"]);
}

shared_ptr<TimelineEntry>
TimelineHandler::get() const {
  return timeline_;
}

TimetableHandler::TimetableHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&TimetableHandler::create, lambda::ref(*this), lambda_args::arg2));
}

TimetableHandler::~TimetableHandler() {}

void
TimetableHandler::create(attributes_type const& attributes) {
  timetable_ = std::make_shared<TimetableEntry>();
  timetable_->setStep(attributes["step"]);
}

shared_ptr<TimetableEntry>
TimetableHandler::get() const {
  return timetable_;
}

FinalStateHandler::FinalStateHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&FinalStateHandler::create, lambda::ref(*this), lambda_args::arg2));
}

FinalStateHandler::~FinalStateHandler() {}

void
FinalStateHandler::create(attributes_type const& attributes) {
  finalState_ = std::make_shared<FinalStateEntry>();
  if (attributes.has("timestamp")) {
    finalState_->setTimestamp(attributes["timestamp"]);
  }
  finalState_->setExportIIDMFile(attributes["exportIIDMFile"]);
  finalState_->setExportDumpFile(attributes["exportDumpFile"]);
}

shared_ptr<FinalStateEntry>
FinalStateHandler::get() const {
  return finalState_;
}

CurvesHandler::CurvesHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&CurvesHandler::create, lambda::ref(*this), lambda_args::arg2));
}

CurvesHandler::~CurvesHandler() {}

void
CurvesHandler::create(attributes_type const& attributes) {
  if (attributes.has("iterationStep") && attributes.has("timeStep")) {
    throw DYNError(DYN::Error::SIMULATION, IterationStepAndTimeStepBothDefined);
  }
  curves_ = std::make_shared<CurvesEntry>();
  curves_->setInputFile(attributes["inputFile"]);
  curves_->setExportMode(attributes["exportMode"]);
  curves_->setIterationStep(attributes["iterationStep"]);
  curves_->setTimeStep(attributes["timeStep"]);
}

shared_ptr<CurvesEntry>
CurvesHandler::get() const {
  return curves_;
}

FinalStateValuesHandler::FinalStateValuesHandler(elementName_type const& root_element) {
  onStartElement(root_element,
                 lambda::bind(&FinalStateValuesHandler::create, lambda::ref(*this),
                              lambda_args::arg2));
}


FinalStateValuesHandler::~FinalStateValuesHandler() {}

void FinalStateValuesHandler::create(attributes_type const& attributes) {
  finalStateValues_ = std::make_shared<FinalStateValuesEntry>();
  finalStateValues_->setInputFile(attributes["inputFile"]);
  finalStateValues_->setExportMode(attributes["exportMode"]);
}

shared_ptr<FinalStateValuesEntry> FinalStateValuesHandler::get() const { return finalStateValues_; }

LostEquipmentsHandler::LostEquipmentsHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&LostEquipmentsHandler::create, lambda::ref(*this), lambda_args::arg2));
}

LostEquipmentsHandler::~LostEquipmentsHandler() {}

void
LostEquipmentsHandler::create(attributes_type const& /*attributes*/) {
  lostEquipments_ = std::make_shared<LostEquipmentsEntry>();
  lostEquipments_->setDumpLostEquipments(true);
}

shared_ptr<LostEquipmentsEntry>
LostEquipmentsHandler::get() const {
  return lostEquipments_;
}

LogsHandler::LogsHandler(elementName_type const& root_element) :
appenderHandler_(parser::ElementName(namespace_uri(), "appender")) {
  onElement(root_element + namespace_uri()("appender"), appenderHandler_);

  onStartElement(root_element, lambda::bind(&LogsHandler::create, lambda::ref(*this), lambda_args::arg2));

  appenderHandler_.onEnd(lambda::bind(&LogsHandler::addAppender, lambda::ref(*this)));
}

LogsHandler::~LogsHandler() {}

void
LogsHandler::addAppender() {
  logs_->addAppenderEntry(appenderHandler_.get());
}

void
LogsHandler::create(attributes_type const& /*attributes*/) {
  logs_ = std::make_shared<LogsEntry>();
}

shared_ptr<LogsEntry>
LogsHandler::get() const {
  return logs_;
}

AppenderHandler::AppenderHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&AppenderHandler::create, lambda::ref(*this), lambda_args::arg2));
}

AppenderHandler::~AppenderHandler() {}

void
AppenderHandler::create(attributes_type const& attributes) {
  appender_ = std::make_shared<AppenderEntry>();
  appender_->setFilePath(attributes["file"]);

  if (attributes.has("tag"))
    appender_->setTag(attributes["tag"]);

  if (attributes.has("lvlFilter"))
    appender_->setLvlFilter(attributes["lvlFilter"]);

  if (attributes.has("showLevelTag"))
    appender_->setShowLevelTag(attributes["showLevelTag"]);

  if (attributes.has("timeStampFormat"))
    appender_->setTimeStampFormat(attributes["timeStampFormat"]);

  if (hasEnvVar("DYNAWO_LOGS_NO_TIMESTAMP"))
    if (getEnvVar("DYNAWO_LOGS_NO_TIMESTAMP") == "YES")
      appender_->setTimeStampFormat("");  // force empty timestamp

  if (attributes.has("separator"))
    appender_->setSeparator(attributes["separator"]);
}

shared_ptr<AppenderEntry>
AppenderHandler::get() const {
  return appender_;
}

NetworkHandler::NetworkHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&NetworkHandler::create, lambda::ref(*this), lambda_args::arg2));
}

NetworkHandler::~NetworkHandler() {}

void
NetworkHandler::create(attributes_type const& attributes) {
  network_ = std::make_shared<NetworkEntry>();
  network_->setIidmFile(attributes["iidmFile"]);
  if (attributes.has("parFile"))
    network_->setNetworkParFile(attributes["parFile"]);
  if (attributes.has("parId"))
    network_->setNetworkParId(attributes["parId"]);
}

shared_ptr<NetworkEntry>
NetworkHandler::get() const {
  return network_;
}

DynModelsHandler::DynModelsHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&DynModelsHandler::create, lambda::ref(*this), lambda_args::arg2));
}

DynModelsHandler::~DynModelsHandler() {}

void
DynModelsHandler::create(attributes_type const& attributes) {
  dynModels_ = std::make_shared<DynModelsEntry>();
  dynModels_->setDydFile(attributes["dydFile"].as_string());
}

shared_ptr<DynModelsEntry>
DynModelsHandler::get() const {
  return dynModels_;
}

InitialStateHandler::InitialStateHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&InitialStateHandler::create, lambda::ref(*this), lambda_args::arg2));
}

InitialStateHandler::~InitialStateHandler() {}

void
InitialStateHandler::create(attributes_type const& attributes) {
  initialState_ = std::make_shared<InitialStateEntry>();
  initialState_->setInitialStateFile(attributes["file"]);
}

shared_ptr<InitialStateEntry>
InitialStateHandler::get() const {
  return initialState_;
}

ModelsDirHandler::ModelsDirHandler(elementName_type const& root_element) :
directoryHandler_(parser::ElementName(namespace_uri(), "directory")) {
  onStartElement(root_element, lambda::bind(&ModelsDirHandler::create, lambda::ref(*this), lambda_args::arg2));

  onElement(root_element + namespace_uri()("directory"), directoryHandler_);

  directoryHandler_.onEnd(lambda::bind(&ModelsDirHandler::addDirectory, lambda::ref(*this)));
}

ModelsDirHandler::~ModelsDirHandler() {}

void
ModelsDirHandler::create(attributes_type const& attributes) {
  modelsDir_ = std::make_shared<ModelsDirEntry>();
  if (attributes.has("modelExtension"))
    modelsDir_->setModelExtension(attributes["modelExtension"].as_string());
  modelsDir_->setUseStandardModels(attributes["useStandardModels"]);
}

shared_ptr<ModelsDirEntry>
ModelsDirHandler::get() const {
  return modelsDir_;
}

void
ModelsDirHandler::addDirectory() {
  modelsDir_->addDirectory(directoryHandler_.get());
}

DirectoryHandler::DirectoryHandler(elementName_type const& root_element) {
  dir_.path.clear();
  dir_.isRecursive = false;
  onStartElement(root_element, lambda::bind(&DirectoryHandler::create, lambda::ref(*this), lambda_args::arg2));
}

DirectoryHandler::~DirectoryHandler() {}

void
DirectoryHandler::create(attributes_type const& attributes) {
  dir_.path = attributes["path"].as_string();
  dir_.isRecursive = attributes["recursive"];
}

UserDefinedDirectory
DirectoryHandler::get() const {
  return dir_;
}

}  // namespace job
