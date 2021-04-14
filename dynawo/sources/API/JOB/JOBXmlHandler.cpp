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
#include "JOBModelsDirEntry.h"
#include "JOBModalAnalysisEntry.h"
#include "JOBSubParticipationEntry.h"
#include "JOBLineariseEntry.h"

using std::map;
using std::string;
using std::vector;

using boost::shared_ptr;

namespace lambda = boost::phoenix;
namespace lambda_args = lambda::placeholders;
namespace parser = xml::sax::parser;

xml::sax::parser::namespace_uri jobs_ns("http://www.rte-france.com/dynawo");  ///< namespace used to read jobs xml file

namespace job {

XmlHandler::XmlHandler() :
jobsCollection_(JobsCollectionFactory::newInstance()),
jobHandler_(parser::ElementName(jobs_ns, "job")) {
  onElement(jobs_ns("jobs/job"), jobHandler_);
  jobHandler_.onEnd(lambda::bind(&XmlHandler::addJob, lambda::ref(*this)));
}

XmlHandler::~XmlHandler() {
}

void
XmlHandler::addJob() {
  jobsCollection_->addJob(jobHandler_.get());
}

boost::shared_ptr<JobsCollection>
XmlHandler::getJobsCollection() const {
  return jobsCollection_;
}

JobHandler::JobHandler(elementName_type const& root_element) :
solverHandler_(parser::ElementName(jobs_ns, "solver")),
modelerHandler_(parser::ElementName(jobs_ns, "modeler")),
simulationHandler_(parser::ElementName(jobs_ns, "simulation")),
outputsHandler_(parser::ElementName(jobs_ns, "outputs")) {
  onStartElement(root_element, lambda::bind(&JobHandler::create, lambda::ref(*this), lambda_args::arg2));

  onElement(root_element + jobs_ns("solver"), solverHandler_);
  onElement(root_element + jobs_ns("modeler"), modelerHandler_);
  onElement(root_element + jobs_ns("simulation"), simulationHandler_);
  onElement(root_element + jobs_ns("outputs"), outputsHandler_);


  solverHandler_.onEnd(lambda::bind(&JobHandler::addSolver, lambda::ref(*this)));
  modelerHandler_.onEnd(lambda::bind(&JobHandler::addModeler, lambda::ref(*this)));
  simulationHandler_.onEnd(lambda::bind(&JobHandler::addSimulation, lambda::ref(*this)));
  outputsHandler_.onEnd(lambda::bind(&JobHandler::addOutputs, lambda::ref(*this)));
}

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
JobHandler::create(attributes_type const& attributes) {
  job_ = shared_ptr<JobEntry>(new JobEntry());
  job_->setName(attributes["name"]);
}

shared_ptr<JobEntry>
JobHandler::get() const {
  return job_;
}

SolverHandler::SolverHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&SolverHandler::create, lambda::ref(*this), lambda_args::arg2));
}

void
SolverHandler::create(attributes_type const & attributes) {
  solver_ = shared_ptr<SolverEntry>(new SolverEntry());
  solver_->setLib(attributes["lib"]);
  solver_->setParametersFile(attributes["parFile"]);
  solver_->setParametersId(attributes["parId"]);
}

shared_ptr<SolverEntry>
SolverHandler::get() const {
  return solver_;
}

ModelerHandler::ModelerHandler(elementName_type const& root_element) :
networkHandler_(parser::ElementName(jobs_ns, "network")),
dynModelsHandler_(parser::ElementName(jobs_ns, "dynModels")),
initialStateHandler_(parser::ElementName(jobs_ns, "initialState")),
preCompiledModelsHandler_(parser::ElementName(jobs_ns, "precompiledModels")),
modelicaModelsHandler_(parser::ElementName(jobs_ns, "modelicaModels")) {
  onElement(root_element + jobs_ns("network"), networkHandler_);
  onElement(root_element + jobs_ns("dynModels"), dynModelsHandler_);
  onElement(root_element + jobs_ns("initialState"), initialStateHandler_);
  onElement(root_element + jobs_ns("precompiledModels"), preCompiledModelsHandler_);
  onElement(root_element + jobs_ns("modelicaModels"), modelicaModelsHandler_);

  onStartElement(root_element, lambda::bind(&ModelerHandler::create, lambda::ref(*this), lambda_args::arg2));

  networkHandler_.onEnd(lambda::bind(&ModelerHandler::addNetwork, lambda::ref(*this)));
  dynModelsHandler_.onEnd(lambda::bind(&ModelerHandler::addDynModel, lambda::ref(*this)));
  initialStateHandler_.onEnd(lambda::bind(&ModelerHandler::addInitialState, lambda::ref(*this)));
  preCompiledModelsHandler_.onEnd(lambda::bind(&ModelerHandler::addPreCompiledModels, lambda::ref(*this)));
  modelicaModelsHandler_.onEnd(lambda::bind(&ModelerHandler::addModelicaModel, lambda::ref(*this)));
}

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
  modeler_ = shared_ptr<ModelerEntry>(new ModelerEntry());
  modeler_->setCompileDir(attributes["compileDir"]);
}

shared_ptr<ModelerEntry>
ModelerHandler::get() const {
  return modeler_;
}
CriteriaFileHandler::CriteriaFileHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&CriteriaFileHandler::create, lambda::ref(*this), lambda_args::arg2));
}

void
CriteriaFileHandler::create(attributes_type const& attributes) {
  criteriaFile_ = attributes["criteriaFile"].as_string();
}

const std::string&
CriteriaFileHandler::get() const {
  return criteriaFile_;
}

SimulationHandler::SimulationHandler(elementName_type const& root_element) :
criteriaFileHandler_(parser::ElementName(jobs_ns, "criteria")) {
  onStartElement(root_element, lambda::bind(&SimulationHandler::create, lambda::ref(*this), lambda_args::arg2));
  onElement(root_element + jobs_ns("criteria"), criteriaFileHandler_);

  criteriaFileHandler_.onEnd(lambda::bind(&SimulationHandler::addCriteriaFile, lambda::ref(*this)));
}

void
SimulationHandler::create(attributes_type const& attributes) {
  simulation_ = shared_ptr<SimulationEntry>(new SimulationEntry());
  simulation_->setStartTime(attributes["startTime"]);
  simulation_->setStopTime(attributes["stopTime"]);
  if (attributes.has("criteriaStep"))
    simulation_->setCriteriaStep(attributes["criteriaStep"]);
  if (attributes.has("precision"))
    simulation_->setPrecision(attributes["precision"]);
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
initValuesHandler_(parser::ElementName(jobs_ns, "dumpInitValues")),
constraintsHandler_(parser::ElementName(jobs_ns, "constraints")),
timelineHandler_(parser::ElementName(jobs_ns, "timeline")),
timetableHandler_(parser::ElementName(jobs_ns, "timetable")),
modalanalysisHandler_(parser::ElementName(jobs_ns, "modalanalysis")),
subparticipationHandler_(parser::ElementName(jobs_ns, "subparticipation")),
lineariseHandler_(parser::ElementName(jobs_ns, "linearise")),
finalStateHandler_(parser::ElementName(jobs_ns, "finalState")),
curvesHandler_(parser::ElementName(jobs_ns, "curves")),
logsHandler_(parser::ElementName(jobs_ns, "logs")) {
  onStartElement(root_element, lambda::bind(&OutputsHandler::create, lambda::ref(*this), lambda_args::arg2));

  onElement(root_element + jobs_ns("dumpInitValues"), initValuesHandler_);
  onElement(root_element + jobs_ns("constraints"), constraintsHandler_);
  onElement(root_element + jobs_ns("timeline"), timelineHandler_);
  onElement(root_element + jobs_ns("timetable"), timetableHandler_);
  onElement(root_element + jobs_ns("modalanalysis"), modalanalysisHandler_);
  onElement(root_element + jobs_ns("subparticipation"), subparticipationHandler_);
  onElement(root_element + jobs_ns("linearise"), lineariseHandler_);
  onElement(root_element + jobs_ns("finalState"), finalStateHandler_);
  onElement(root_element + jobs_ns("curves"), curvesHandler_);
  onElement(root_element + jobs_ns("logs"), logsHandler_);

  initValuesHandler_.onEnd(lambda::bind(&OutputsHandler::addInitValuesEntry, lambda::ref(*this)));
  constraintsHandler_.onEnd(lambda::bind(&OutputsHandler::addConstraints, lambda::ref(*this)));
  timelineHandler_.onEnd(lambda::bind(&OutputsHandler::addTimeline, lambda::ref(*this)));
  timetableHandler_.onEnd(lambda::bind(&OutputsHandler::addTimetable, lambda::ref(*this)));
  finalStateHandler_.onEnd(lambda::bind(&OutputsHandler::addFinalState, lambda::ref(*this)));
  curvesHandler_.onEnd(lambda::bind(&OutputsHandler::addCurves, lambda::ref(*this)));
  logsHandler_.onEnd(lambda::bind(&OutputsHandler::addLog, lambda::ref(*this)));
  modalanalysisHandler_.onEnd(lambda::bind(&OutputsHandler::addModalAnalysis, lambda::ref(*this)));
  subparticipationHandler_.onEnd(lambda::bind(&OutputsHandler::addSubParticipation, lambda::ref(*this)));
  lineariseHandler_.onEnd(lambda::bind(&OutputsHandler::addLinearise, lambda::ref(*this)));
}

void
OutputsHandler::addModalAnalysis() {
  outputs_->setModalAnalysisEntry(modalanalysisHandler_.get());
}

void
OutputsHandler::addSubParticipation() {
  outputs_->setSubParticipationEntry(subparticipationHandler_.get());
}

void
OutputsHandler::addLinearise() {
  outputs_->setLineariseEntry(lineariseHandler_.get());
}

void
OutputsHandler::addInitValuesEntry() {
  outputs_->setInitValuesEntry(initValuesHandler_.get());
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
  outputs_->setFinalStateEntry(finalStateHandler_.get());
}

void
OutputsHandler::addCurves() {
  outputs_->setCurvesEntry(curvesHandler_.get());
}

void
OutputsHandler::addLog() {
  outputs_->setLogsEntry(logsHandler_.get());
}

void
OutputsHandler::create(attributes_type const& attributes) {
  outputs_ = shared_ptr<OutputsEntry>(new OutputsEntry());
  outputs_->setOutputsDirectory(attributes["directory"]);
}

shared_ptr<OutputsEntry>
OutputsHandler::get() const {
  return outputs_;
}

InitValuesHandler::InitValuesHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&InitValuesHandler::create, lambda::ref(*this), lambda_args::arg2));
}

void
InitValuesHandler::create(attributes_type const& attributes) {
  initValuesEntry_ = shared_ptr<InitValuesEntry>(new InitValuesEntry());
  initValuesEntry_->setDumpLocalInitValues(attributes["local"]);
  initValuesEntry_->setDumpGlobalInitValues(attributes["global"]);
}

shared_ptr<InitValuesEntry>
InitValuesHandler::get() const {
  return initValuesEntry_;
}

ConstraintsHandler::ConstraintsHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&ConstraintsHandler::create, lambda::ref(*this), lambda_args::arg2));
}

void
ConstraintsHandler::create(attributes_type const& attributes) {
  constraints_ = shared_ptr<ConstraintsEntry>(new ConstraintsEntry());
  constraints_->setExportMode(attributes["exportMode"]);
}

shared_ptr<ConstraintsEntry>
ConstraintsHandler::get() const {
  return constraints_;
}

TimelineHandler::TimelineHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&TimelineHandler::create, lambda::ref(*this), lambda_args::arg2));
}

void
TimelineHandler::create(attributes_type const& attributes) {
  timeline_ = shared_ptr<TimelineEntry>(new TimelineEntry());
  timeline_->setExportMode(attributes["exportMode"]);
}

shared_ptr<TimelineEntry>
TimelineHandler::get() const {
  return timeline_;
}

TimetableHandler::TimetableHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&TimetableHandler::create, lambda::ref(*this), lambda_args::arg2));
}

void
TimetableHandler::create(attributes_type const& attributes) {
  timetable_ = shared_ptr<TimetableEntry>(new TimetableEntry());
  timetable_->setStep(attributes["step"]);
}

shared_ptr<TimetableEntry>
TimetableHandler::get() const {
  return timetable_;
}

ModalAnalysisHandler::ModalAnalysisHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&ModalAnalysisHandler::create, lambda::ref(*this), lambda_args::arg2));
}

void
ModalAnalysisHandler::create(attributes_type const& attributes) {
  modalanalysis_ = shared_ptr<ModalAnalysisEntry>(new ModalAnalysisEntry);
  modalanalysis_->setModalAnalysisTime(attributes["modalanalysisTime"]);
  modalanalysis_->setModalAnalysisPart(attributes["modalanalysisPart"]);
}

shared_ptr<ModalAnalysisEntry>
ModalAnalysisHandler::get() const {
  return modalanalysis_;
}

SubParticipationHandler::SubParticipationHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&SubParticipationHandler::create, lambda::ref(*this), lambda_args::arg2));
}

void
SubParticipationHandler::create(attributes_type const& attributes) {
  subparticipation_ = shared_ptr<SubParticipationEntry>(new SubParticipationEntry);
  subparticipation_->setSubParticipationTime(attributes["subparticipationTime"]);
  subparticipation_->setSubParticipationNbMode(attributes["subparticipationNbMode"]);
}

shared_ptr<SubParticipationEntry>
SubParticipationHandler::get() const {
  return subparticipation_;
}

LineariseHandler::LineariseHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&LineariseHandler::create, lambda::ref(*this), lambda_args::arg2));
}

void
LineariseHandler::create(attributes_type const& attributes) {
  linearise_ = shared_ptr<LineariseEntry>(new LineariseEntry);
  linearise_->setLineariseTime(attributes["lineariseTime"]);
}

shared_ptr<LineariseEntry>
LineariseHandler::get() const {
  return linearise_;
}

FinalStateHandler::FinalStateHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&FinalStateHandler::create, lambda::ref(*this), lambda_args::arg2));
}

void
FinalStateHandler::create(attributes_type const& attributes) {
  finalState_ = shared_ptr<FinalStateEntry>(new FinalStateEntry());
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

void
CurvesHandler::create(attributes_type const& attributes) {
  curves_ = shared_ptr<CurvesEntry>(new CurvesEntry());
  curves_->setInputFile(attributes["inputFile"]);
  curves_->setExportMode(attributes["exportMode"]);
}

shared_ptr<CurvesEntry>
CurvesHandler::get() const {
  return curves_;
}

LogsHandler::LogsHandler(elementName_type const& root_element) :
appenderHandler_(parser::ElementName(jobs_ns, "appender")) {
  onElement(root_element + jobs_ns("appender"), appenderHandler_);

  onStartElement(root_element, lambda::bind(&LogsHandler::create, lambda::ref(*this), lambda_args::arg2));

  appenderHandler_.onEnd(lambda::bind(&LogsHandler::addAppender, lambda::ref(*this)));
}

void
LogsHandler::addAppender() {
  logs_->addAppenderEntry(appenderHandler_.get());
}

void
LogsHandler::create(attributes_type const& /*attributes*/) {
  logs_ = shared_ptr<LogsEntry>(new LogsEntry());
}

shared_ptr<LogsEntry>
LogsHandler::get() const {
  return logs_;
}

AppenderHandler::AppenderHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&AppenderHandler::create, lambda::ref(*this), lambda_args::arg2));
}

void
AppenderHandler::create(attributes_type const& attributes) {
  appender_ = shared_ptr<AppenderEntry>(new AppenderEntry());
  appender_->setFilePath(attributes["file"]);

  if (attributes.has("tag"))
    appender_->setTag(attributes["tag"]);

  if (attributes.has("lvlFilter"))
    appender_->setLvlFilter(attributes["lvlFilter"]);

  if (attributes.has("showLevelTag"))
    appender_->setShowLevelTag(attributes["showLevelTag"]);

  if (attributes.has("timeStampFormat"))
    appender_->setTimeStampFormat(attributes["timeStampFormat"]);

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

void
NetworkHandler::create(attributes_type const& attributes) {
  network_ = shared_ptr<NetworkEntry>(new NetworkEntry());
  network_->setIidmFile(attributes["iidmFile"]);
  network_->setNetworkParFile(attributes["parFile"]);
  network_->setNetworkParId(attributes["parId"]);
}

shared_ptr<NetworkEntry>
NetworkHandler::get() const {
  return network_;
}

DynModelsHandler::DynModelsHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&DynModelsHandler::create, lambda::ref(*this), lambda_args::arg2));
}

void
DynModelsHandler::create(attributes_type const& attributes) {
  dynModels_ = shared_ptr<DynModelsEntry>(new DynModelsEntry());
  dynModels_->setDydFile(attributes["dydFile"].as_string());
}

shared_ptr<DynModelsEntry>
DynModelsHandler::get() const {
  return dynModels_;
}

InitialStateHandler::InitialStateHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&InitialStateHandler::create, lambda::ref(*this), lambda_args::arg2));
}

void
InitialStateHandler::create(attributes_type const& attributes) {
  initialState_ = shared_ptr<InitialStateEntry>(new InitialStateEntry());
  initialState_->setInitialStateFile(attributes["file"]);
}

shared_ptr<InitialStateEntry>
InitialStateHandler::get() const {
  return initialState_;
}

ModelsDirHandler::ModelsDirHandler(elementName_type const& root_element) :
directoryHandler_(parser::ElementName(jobs_ns, "directory")) {
  onStartElement(root_element, lambda::bind(&ModelsDirHandler::create, lambda::ref(*this), lambda_args::arg2));

  onElement(root_element + jobs_ns("directory"), directoryHandler_);

  directoryHandler_.onEnd(lambda::bind(&ModelsDirHandler::addDirectory, lambda::ref(*this)));
}

void
ModelsDirHandler::create(attributes_type const& attributes) {
  modelsDir_ = shared_ptr<ModelsDirEntry>(new ModelsDirEntry());
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
