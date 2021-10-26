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
 * @file  DYNSimulation.cpp
 *
 * @brief Simulation implementation
 *
 */

#include <iomanip>
#include <vector>
#include <map>
#include <cstdlib>
#include <sstream>
#include <fstream>
#ifdef _MSC_VER
#include <process.h>
#endif


#include <boost/archive/binary_iarchive.hpp>
#include <boost/archive/binary_oarchive.hpp>
#include <boost/serialization/vector.hpp>
#include <boost/filesystem.hpp>
#include <boost/algorithm/string/classification.hpp>
#include <boost/algorithm/string/split.hpp>

#include <libzip/ZipFile.h>
#include <libzip/ZipFileFactory.h>
#include <libzip/ZipEntry.h>
#include <libzip/ZipInputStream.h>
#include <libzip/ZipOutputStream.h>

#include "TLTimelineFactory.h"
#include "TLTimeline.h"
#include "TLTxtExporter.h"
#include "TLXmlExporter.h"
#include "TLCsvExporter.h"

#include "CRVCurvesCollectionFactory.h"
#include "CRVCurvesCollection.h"
#include "CRVXmlImporter.h"
#include "CRVCurve.h"
#include "CRVXmlExporter.h"
#include "CRVCsvExporter.h"

#include "FSFinalStateCollectionFactory.h"
#include "FSFinalStateCollection.h"
#include "FSXmlImporter.h"
#include "FSXmlExporter.h"
#include "FSIterators.h"

#include "CSTRConstraintsCollection.h"
#include "CSTRConstraintsCollectionFactory.h"
#include "CSTRTxtExporter.h"
#include "CSTRXmlExporter.h"

#include "PARParametersSet.h"
#include "PARXmlImporter.h"

#include "CRTXmlImporter.h"
#include "CRTCriteriaCollection.h"

#include "JOBJobEntry.h"
#include "JOBSolverEntry.h"
#include "JOBModelerEntry.h"
#include "JOBModelsDirEntry.h"
#include "JOBOutputsEntry.h"
#include "JOBNetworkEntry.h"
#include "JOBInitialStateEntry.h"
#include "JOBInitValuesEntry.h"
#include "JOBConstraintsEntry.h"
#include "JOBTimelineEntry.h"
#include "JOBFinalStateEntry.h"
#include "JOBCurvesEntry.h"
#include "JOBSimulationEntry.h"
#include "JOBLogsEntry.h"
#include "JOBAppenderEntry.h"
#include "JOBDynModelsEntry.h"

#include "gitversion.h"
#include "config.h"

#include "DYNCompiler.h"
#include "DYNDynamicData.h"
#include "DYNModel.h"
#include "DYNSimulation.h"
#include "DYNSimulationContext.h"
#include "DYNTrace.h"
#include "DYNMacrosMessage.h"
#include "DYNSolver.h"
#include "DYNSolverFactory.h"
#include "DYNSubModelFactory.h"
#include "DYNTimer.h"
#include "DYNModelMulti.h"
#include "DYNModeler.h"
#include "DYNFileSystemUtils.h"
#include "DYNTerminate.h"
#include "DYNDataInterface.h"
#include "DYNDataInterfaceFactory.h"
#include "DYNExecUtils.h"
#include "DYNSignalHandler.h"
#include "DYNBitMask.h"

using std::ofstream;
using std::fstream;
using std::string;
using std::vector;
using std::stringstream;
using std::map;
using std::setw;
using boost::shared_ptr;
using boost::dynamic_pointer_cast;

namespace fs = boost::filesystem;

using timeline::TimelineFactory;

using curves::CurvesCollection;
using curves::CurvesCollectionFactory;

using finalState::FinalStateCollectionFactory;
using finalState::finalStateModel_iterator;
using finalState::finalStateVariable_iterator;

using constraints::ConstraintsCollectionFactory;

using parameters::ParametersSet;
using parameters::ParametersSetCollection;

static const char TIME_FILENAME[] = "time.bin";  ///< name of the file to dump time at the end of the simulation

namespace DYN {

Simulation::Simulation(shared_ptr<job::JobEntry>& jobEntry, shared_ptr<SimulationContext>& context, shared_ptr<DataInterface> data) :
context_(context),
jobEntry_(jobEntry),
data_(data),
iidmFile_(""),
networkParFile_(""),
networkParSet_(""),
initialStateFile_(""),
exportCurvesMode_(EXPORT_CURVES_NONE),
curvesInputFile_(""),
curvesOutputFile_(""),
exportTimelineMode_(EXPORT_TIMELINE_NONE),
exportTimelineMaxPriority_(boost::none),
timelineOutputFile_(""),
exportFinalStateMode_(EXPORT_FINALSTATE_NONE),
finalStateInputFile_(""),
finalStateOutputFile_(""),
exportConstraintsMode_(EXPORT_CONSTRAINTS_NONE),
constraintsOutputFile_(""),
exportDumpFinalState_(false),
dumpFinalStateFile_(""),
exportIIDM_(false),
exportIIDMFile_(""),
dumpLocalInitValues_(false),
dumpGlobalInitValues_(false),
dumpTimetable_(true) {
  SignalHandler::setSignalHandlers();

#ifdef _MSC_VER
  pid_ = _getpid();
#else
  pid_ = getpid();
#endif
  stringstream pid_string;
  pid_string << pid_;
  timeline_ = TimelineFactory::newInstance("Simulation_" + pid_string.str());
  curvesCollection_ = CurvesCollectionFactory::newInstance("Simulation_" + pid_string.str());
  constraintsCollection_ = ConstraintsCollectionFactory::newInstance("Simulation_" + pid_string.str());

  // Set simulation parameters
  setStartTime(jobEntry_->getSimulationEntry()->getStartTime());
  setStopTime(jobEntry_->getSimulationEntry()->getStopTime());
  setActivateCriteria(!jobEntry_->getSimulationEntry()->getCriteriaFiles().empty());
  setCriteriaStep(jobEntry_->getSimulationEntry()->getCriteriaStep());
  setCurrentPrecision(jobEntry_->getSimulationEntry()->getPrecision());

  outputsDirectory_ = context_->getWorkingDirectory();
  if (jobEntry_->getOutputsEntry()) {
    outputsDirectory_ = createAbsolutePath(jobEntry_->getOutputsEntry()->getOutputsDirectory(), context_->getWorkingDirectory());
    if (!is_directory(outputsDirectory_))
      create_directory(outputsDirectory_);
  }

  configureLogs();
  configureSimulationOutputs();
  setSolver();
  configureSimulationInputs();
  configureCriteria();
}

Simulation::~Simulation() {
}

void
Simulation::configureSimulationInputs() {
  //---- dydFile ----
  vector <boost::shared_ptr<job::DynModelsEntry> > dynModelsEntries = jobEntry_->getModelerEntry()->getDynModelsEntries();
  vector <string> dydFiles;
  for (unsigned int i = 0; i < dynModelsEntries.size(); ++i) {
    string absoluteDirPath = createAbsolutePath(dynModelsEntries[i]->getDydFile(), context_->getInputDirectory());
    if (!exists(absoluteDirPath)) {
      throw DYNError(Error::MODELER, UnknownDydFile, absoluteDirPath);
    }
    dydFiles_.push_back(absoluteDirPath);
  }

  if (jobEntry_->getModelerEntry()->getNetworkEntry()) {
    iidmFile_ = createAbsolutePath(jobEntry_->getModelerEntry()->getNetworkEntry()->getIidmFile(), context_->getInputDirectory());
    if (!data_ && !exists(iidmFile_))  // no need to check iidm file if data interface is provided
      throw DYNError(Error::GENERAL, UnknownIidmFile, iidmFile_);

    networkParFile_ = createAbsolutePath(jobEntry_->getModelerEntry()->getNetworkEntry()->getNetworkParFile(), context_->getInputDirectory());
    if (!exists(networkParFile_))
      throw DYNError(Error::GENERAL, UnknownParFile, networkParFile_);
    networkParFile_ = jobEntry_->getModelerEntry()->getNetworkEntry()->getNetworkParFile();
    networkParSet_ = jobEntry_->getModelerEntry()->getNetworkEntry()->getNetworkParId();
  }
  if (jobEntry_->getModelerEntry()->getInitialStateEntry()) {
    initialStateFile_ = createAbsolutePath(jobEntry_->getModelerEntry()->getInitialStateEntry()->getInitialStateFile(), context_->getInputDirectory());
    if (!exists(initialStateFile_))
      throw DYNError(Error::GENERAL, UnknownInitialStateFile, initialStateFile_);
  }
}


void
Simulation::configureCriteria() {
  for (std::vector<std::string>::const_iterator it = jobEntry_->getSimulationEntry()->getCriteriaFiles().begin(),
      itEnd = jobEntry_->getSimulationEntry()->getCriteriaFiles().end();
      it != itEnd; ++it) {
    criteria::XmlImporter parser;
    std::string path = createAbsolutePath(*it, context_->getInputDirectory());
    boost::shared_ptr<criteria::CriteriaCollection> ccollec = parser.importFromFile(path);
    if (!criteriaCollection_)
      criteriaCollection_ = ccollec;
    else
      criteriaCollection_->merge(ccollec);
  }
}

void
Simulation::clean() {
  model_.reset();
  solver_.reset();
  data_.reset();
  dyd_.reset();
}

void
Simulation::configureSimulationOutputs() {
  if (jobEntry_->getOutputsEntry()) {
    // Init Values settings
    if (jobEntry_->getOutputsEntry()->getInitValuesEntry()) {
      setDumpLocalInitValues(jobEntry_->getOutputsEntry()->getInitValuesEntry()->getDumpLocalInitValues());
      setDumpGlobalInitValues(jobEntry_->getOutputsEntry()->getInitValuesEntry()->getDumpGlobalInitValues());
    }
    configureConstraintsOutputs();
    configureTimelineOutputs();
    configureCurveOutputs();
    configureFinalStateOutputs();
  }
}

void
Simulation::configureConstraintsOutputs() {
  // Constraints settings
  if (jobEntry_->getOutputsEntry()->getConstraintsEntry()) {
    string constraintsDir = createAbsolutePath("constraints", outputsDirectory_);
    if (!is_directory(constraintsDir))
      create_directory(constraintsDir);

    //---- exportMode ----
    string exportMode = jobEntry_->getOutputsEntry()->getConstraintsEntry()->getExportMode();
    Simulation::exportConstraintsMode_t exportModeFlag = Simulation::EXPORT_CONSTRAINTS_NONE;
    string outputFile = "";
    if (exportMode == "TXT") {
      exportModeFlag = Simulation::EXPORT_CONSTRAINTS_TXT;
      outputFile = createAbsolutePath("constraints.log", constraintsDir);
    } else if (exportMode == "XML") {
      exportModeFlag = Simulation::EXPORT_CONSTRAINTS_XML;
      outputFile = createAbsolutePath("constraints.xml", constraintsDir);
    } else {
      throw DYNError(Error::MODELER, UnknownConstraintsExport, exportMode);
    }

    setConstraintsExportMode(exportModeFlag);
    setConstraintsOutputFile(outputFile);
  } else {
    setConstraintsExportMode(Simulation::EXPORT_CONSTRAINTS_NONE);
  }
}

void
Simulation::configureTimelineOutputs() {
  // Timeline settings
  if (jobEntry_->getOutputsEntry()->getTimelineEntry()) {
    string timeLineDir = createAbsolutePath("timeLine", outputsDirectory_);
    if (!is_directory(timeLineDir))
      create_directory(timeLineDir);

    //---- exportMode ----
    string exportMode = jobEntry_->getOutputsEntry()->getTimelineEntry()->getExportMode();
    Simulation::exportTimelineMode_t exportModeFlag = Simulation::EXPORT_TIMELINE_NONE;
    string outputFile = "";
    if (exportMode == "TXT") {
      exportModeFlag = Simulation::EXPORT_TIMELINE_TXT;
      outputFile = createAbsolutePath("timeline.log", timeLineDir);
    } else if (exportMode == "CSV") {
      exportModeFlag = Simulation::EXPORT_TIMELINE_CSV;
      outputFile = createAbsolutePath("timeline.csv", timeLineDir);
    } else if (exportMode == "XML") {
      exportModeFlag = Simulation::EXPORT_TIMELINE_XML;
      outputFile = createAbsolutePath("timeline.xml", timeLineDir);
    } else {
      throw DYNError(Error::MODELER, UnknownTimelineExport, exportMode);
    }
    setTimelineExportMode(exportModeFlag);
    exportTimelineMaxPriority_ = jobEntry_->getOutputsEntry()->getTimelineEntry()->getMaxPriority();
    setTimelineOutputFile(outputFile);
  } else {
    setTimelineExportMode(Simulation::EXPORT_TIMELINE_NONE);
  }
}

void
Simulation::configureCurveOutputs() {
  // Curves settings
  if (jobEntry_->getOutputsEntry()->getCurvesEntry()) {
    string curvesDir = createAbsolutePath("curves", outputsDirectory_);
    if (!is_directory(curvesDir))
      create_directory(curvesDir);

    //---- inputFile ----
    string curveInputFile = createAbsolutePath(jobEntry_->getOutputsEntry()->getCurvesEntry()->getInputFile(), context_->getInputDirectory());
    if (!exists(curveInputFile))
      throw DYNError(Error::MODELER, UnknownCurveFile, curveInputFile);
    setCurvesInputFile(curveInputFile);
    importCurvesRequest();

    //---- outputFile ---
    setCurvesOutputFile(jobEntry_->getOutputsEntry()->getCurvesEntry()->getOutputFile());

    //---- exportMode ----
    string exportMode = jobEntry_->getOutputsEntry()->getCurvesEntry()->getExportMode();
    Simulation::exportCurvesMode_t exportModeFlag = Simulation::EXPORT_CURVES_NONE;
    string outputFile = "";
    if (exportMode == "CSV") {
      exportModeFlag = Simulation::EXPORT_CURVES_CSV;
      outputFile = createAbsolutePath("curves.csv", curvesDir);
    } else if (exportMode == "XML") {
      exportModeFlag = Simulation::EXPORT_CURVES_XML;
      outputFile = createAbsolutePath("curves.xml", curvesDir);
    } else {
      throw DYNError(Error::MODELER, UnknownCurvesExport, exportMode);
    }
    setCurvesExportMode(exportModeFlag);
    setCurvesOutputFile(outputFile);
  } else {
    setCurvesExportMode(Simulation::EXPORT_CURVES_NONE);
  }
}

void
Simulation::configureFinalStateOutputs() {
  // Final state settings
  if (jobEntry_->getOutputsEntry()->getFinalStateEntry()) {
    string finalStateDir = createAbsolutePath("finalState", outputsDirectory_);
    if (!is_directory(finalStateDir))
      create_directory(finalStateDir);

    // ---- exportDumpFile ----
    if (jobEntry_->getOutputsEntry()->getFinalStateEntry()->getExportDumpFile()) {
      activateDumpFinalState(true);
      setDumpFinalStateFile(createAbsolutePath("outputState.dmp", finalStateDir));
    } else {
      activateDumpFinalState(false);
    }

    // --- exportIIDMFile ----
    if (jobEntry_->getOutputsEntry()->getFinalStateEntry()->getExportIIDMFile()) {
      activateExportIIDM(true);
      setExportIIDMFile(createAbsolutePath("outputIIDM.xml", finalStateDir));
    } else {
      activateExportIIDM(false);
    }
  }
}

void
Simulation::compileModels() {
  // ModelsDirEntry: Precompiled models
  // convert precompiled models directories into absolute directories, and check whether they actually exist
  vector <UserDefinedDirectory> precompiledModelsDirsAbsolute;
  string preCompiledModelsExtension = sharedLibraryExtension();
  bool preCompiledUseStandardModels = false;
  if (jobEntry_->getModelerEntry()->getPreCompiledModelsDirEntry()) {
    vector <UserDefinedDirectory> precompiledModelsDirs = jobEntry_->getModelerEntry()->getPreCompiledModelsDirEntry()->getDirectories();
    for (unsigned int i = 0; i < precompiledModelsDirs.size(); ++i) {
      string absoluteDirPath = createAbsolutePath(precompiledModelsDirs[i].path, context_->getInputDirectory());
      if (!exists(absoluteDirPath)) {
        throw DYNError(Error::MODELER, UnknownModelsDir, absoluteDirPath);
      }
      UserDefinedDirectory dir;
      dir.path = absoluteDirPath;
      dir.isRecursive = precompiledModelsDirs[i].isRecursive;
      precompiledModelsDirsAbsolute.push_back(dir);
    }
    preCompiledUseStandardModels = jobEntry_->getModelerEntry()->getPreCompiledModelsDirEntry()->getUseStandardModels();
  }

  // ModelsDirEntry: Modelica models
  // convert Modelica models directories into absolute directories, and check whether they actually exist
  vector <UserDefinedDirectory> modelicaModelsDirsAbsolute;
  string modelicaModelsExtension = ".mo";
  bool modelicaUseStandardModels = false;
  if (jobEntry_->getModelerEntry()->getModelicaModelsDirEntry()) {
    vector <UserDefinedDirectory> modelicaModelsDirs = jobEntry_->getModelerEntry()->getModelicaModelsDirEntry()->getDirectories();
    for (unsigned int i = 0; i < modelicaModelsDirs.size(); ++i) {
      string absoluteDirPath = createAbsolutePath(modelicaModelsDirs[i].path, context_->getInputDirectory());
      if (!exists(absoluteDirPath)) {
        throw DYNError(Error::MODELER, UnknownModelsDir, absoluteDirPath);
      }
      UserDefinedDirectory dir;
      dir.path = absoluteDirPath;
      dir.isRecursive = modelicaModelsDirs[i].isRecursive;
      modelicaModelsDirsAbsolute.push_back(dir);
    }
    if (jobEntry_->getModelerEntry()->getModelicaModelsDirEntry()->getModelExtension() != "") {
      modelicaModelsExtension = jobEntry_->getModelerEntry()->getModelicaModelsDirEntry()->getModelExtension();
    }
    modelicaUseStandardModels = jobEntry_->getModelerEntry()->getModelicaModelsDirEntry()->getUseStandardModels();
  }

  //---- compileDir ----
  string compileDir = createAbsolutePath(jobEntry_->getModelerEntry()->getCompileDir(), context_->getWorkingDirectory());
  if (!exists(compileDir))
    create_directory(compileDir);

  vector<string> additionalHeaderFiles;
  if (hasEnvVar("DYNAWO_HEADER_FILES_FOR_PREASSEMBLED")) {
    string additionalHeaderList = getEnvVar("DYNAWO_HEADER_FILES_FOR_PREASSEMBLED");
    boost::split(additionalHeaderFiles, additionalHeaderList, boost::is_any_of(" "), boost::token_compress_on);
  }
  boost::unordered_set<boost::filesystem::path> pathsToIgnore;
  pathsToIgnore.insert(boost::filesystem::path(compileDir));

  const bool rmModels = true;
  Compiler cf = Compiler(dyd_, preCompiledUseStandardModels,
          precompiledModelsDirsAbsolute,
          preCompiledModelsExtension,
          modelicaUseStandardModels,
          modelicaModelsDirsAbsolute,
          modelicaModelsExtension,
          pathsToIgnore,
          additionalHeaderFiles,
          rmModels,
          compileDir);

  cf.compile();  // modelOnly = false, compilation and parameter linking
  cf.concatConnects();
  cf.concatRefs();
}


void
Simulation::loadDynamicData() {
  // Load model
  dyd_.reset(new DynamicData());  // takes ownership of pointer
  dyd_->setRootDirectory(context_->getInputDirectory());
  dyd_->setParametersReference(referenceParameters_);

  if (!data_) {
    if (iidmFile_ != "") {
      data_ = DataInterfaceFactory::build(DataInterfaceFactory::DATAINTERFACE_IIDM, iidmFile_);
    } else {
      dyd_->initFromDydFiles(dydFiles_);
      if (activateCriteria_) {
        Trace::warn() << DYNLog(CriteriaDefinedButNoIIDM) << Trace::endline;
      }
      return;
    }
  }
  if (criteriaCollection_)
    data_->configureCriteria(criteriaCollection_);

  data_->importStaticParameters();  // Import static model's parameters' values into DataInterface, these values are useful for referece parameters.

  dyd_->setDataInterface(data_);

  dyd_->initFromDydFiles(dydFiles_);
  data_->mapConnections();

  // the Network parameter file path is considered to be relative to the jobs file directory
  dyd_->getNetworkParameters(networkParFile_, networkParSet_);
}

void
Simulation::setSolver() {
  // Creates solver
  string solverParFile = createAbsolutePath(jobEntry_->getSolverEntry()->getParametersFile(), context_->getInputDirectory());
  solver_ = SolverFactory::createSolverFromLib(jobEntry_->getSolverEntry()->getLib() + sharedLibraryExtension());

  parameters::XmlImporter importer;
  boost::shared_ptr<ParametersSetCollection> parameters = importer.importFromFile(solverParFile);
  referenceParameters_[solverParFile] = parameters;
  string parId = jobEntry_->getSolverEntry()->getParametersId();
  if (parameters->getParametersSet(parId)) {
    shared_ptr<ParametersSet> solverParams = boost::shared_ptr<ParametersSet>(new ParametersSet(*parameters->getParametersSet(parId)));
    solver_->setParameters(solverParams);

#ifdef _DEBUG_
    solver_->checkUnusedParameters(solverParams);
#endif
  }
}

void
Simulation::configureLogs() {
  // Set custom appenders
  Trace::resetCustomAppenders();

  if (jobEntry_->getOutputsEntry()->getLogsEntry()) {
    string logsDir = createAbsolutePath("logs", outputsDirectory_);
    if (!is_directory(logsDir))
      create_directory(logsDir);

    if (jobEntry_->getOutputsEntry()->getLogsEntry()->getAppenderEntries().size() == 0) {
      Trace::disableLogging();
    } else {
      vector<shared_ptr<job::AppenderEntry> > appendersEntry = jobEntry_->getOutputsEntry()->getLogsEntry()->getAppenderEntries();
      vector<Trace::TraceAppender> appenders;
      vector<shared_ptr<job::AppenderEntry> >::iterator itApp = appendersEntry.begin();
      for (; itApp != appendersEntry.end(); ++itApp) {
        string file = createAbsolutePath((*itApp)->getFilePath(), logsDir);
        // Creates log directory if doesn't exist
        string fileDir = remove_file_name(file);
        if (!is_directory(fileDir))
          create_directory(fileDir);

        Trace::TraceAppender app;
        app.setTag((*itApp)->getTag());
        app.setFilePath(file);
        app.setLvlFilter(Trace::severityLevelFromString((*itApp)->getLvlFilter()));
        app.setShowLevelTag((*itApp)->getShowLevelTag());
        app.setSeparator((*itApp)->getSeparator());
        app.setShowTimeStamp((*itApp)->getTimeStampFormat() != "");
        app.setTimeStampFormat((*itApp)->getTimeStampFormat());
        appenders.push_back(app);
      }
      Trace::addAppenders(appenders);

      // Add DYNAWO version and revision in each header of appender
      itApp = appendersEntry.begin();
      for (; itApp != appendersEntry.end(); ++itApp) {
        string tag = (*itApp)->getTag();
        Trace::info(tag) << " ============================================================ " << Trace::endline;
        Trace::info(tag) << DYNLog(DynawoVersion) << "  " << setw(8) << DYNAWO_VERSION_STRING << Trace::endline;
        Trace::info(tag) << DYNLog(DynawoRevision) << "  " << setw(8) << DYNAWO_GIT_BRANCH << "-" << DYNAWO_GIT_HASH << Trace::endline;
        Trace::info(tag) << " ============================================================ " << Trace::endline;
      }
    }
  } else {
    Trace::disableLogging();
  }
}

void
Simulation::importCurvesRequest() {
  curves::XmlImporter importer;
  curvesCollection_ = CurvesCollectionFactory::copyInstance(importer.importFromFile(curvesInputFile_));
}

void
Simulation::importFinalStateRequest() {
  finalState::XmlImporter importer;
  finalStateCollection_ = FinalStateCollectionFactory::copyInstance(importer.importFromFile(finalStateInputFile_));
}

void
Simulation::initFromData(const shared_ptr<DataInterface> & data, const shared_ptr<DynamicData> &dyd) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("Simulation::initFromData()");
#endif
  Modeler modeler;
  modeler.setDataInterface(data);
  modeler.setDynamicData(dyd);
  modeler.initSystem();

  model_ = modeler.getModel();
  model_->setWorkingDirectory(context_->getWorkingDirectory());
}

void
Simulation::initStructure() {
  model_->initBuffers();
  shared_ptr<ModelMulti> model = dynamic_pointer_cast<ModelMulti>(model_);
  if (!model->checkConnects()) {
    throw DYNError(Error::MODELER, WrongConnect);
  }
}

void
Simulation::init() {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("Simulation::init()");
#endif
  Trace::info() << Trace::endline << "-----------------------------------------------------------------------" << Trace::endline;
  Trace::info() << DYNLog(ModelBuilding) << Trace::endline;
  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;

  loadDynamicData();
  compileModels();

  // NOTE: It is during the following simulation initialization(initFromData)
  // that static data (data_) and compiled dynamic data (dyd_) are combined together for the first time.
  // So the reference parameters origin from IIDM are retrieved here.
  // Simulation::initFromData==>Modeler::initSystem==>Modeler::initModelDescription(dyd,data)
  initFromData(data_, dyd_);
  initStructure();
  if (Trace::logExists(Trace::parameters(), DEBUG)) {
    model_->printParameterValues();
    solver_->printParameterValues();
  }

  double t0 = 0;

#ifdef _DEBUG_
  printDebugInfo();
#endif
  if (Trace::logExists(Trace::modeler(), DEBUG))
    model_->printModel();
  if (Trace::logExists(Trace::variables(), DEBUG))
    model_->printVariableNames();

  model_->setTimeline(timeline_);
  model_->setConstraints(constraintsCollection_);

  if (Trace::logExists(Trace::equations(), DEBUG)) {
    model_->setFequationsModel();  ///< set formula for modelica models' equations and Network models' equations
    model_->setGequationsModel();  ///< set formula for modelica models' root equations and Network models' equations
    model_->printEquations();
  }
#ifdef _DEBUG_
  model_->setFequationsModel();  ///< set formula for modelica models' equations and Network models' equations
  model_->setGequationsModel();  ///< set formula for modelica models' root equations and Network models' equations
#endif

  tCurrent_ = tStart_;
  Trace::info() << DYNLog(ModelBuildingEnd) << Trace::endline;
  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline<< Trace::endline;

  if (initialStateFile_ != "") {
    Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;
    Trace::info() << DYNLog(ModelInitialStateLoad) << Trace::endline;
    Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;
    t0 = loadState(initialStateFile_);  // loadState and return initial time
    Trace::info() << DYNLog(ModelInitialStateLoadEnd) << Trace::endline;
    Trace::info() << "-----------------------------------------------------------------------" << Trace::endline<< Trace::endline;
  }

  // When a simulation starts with a dumpfile (initial condition of variables for dynamic models),
  // initial condition's calculation is not necessary for those dynamic models;
  // however, the NETWORK model could be different from the one in dumpfile,
  // like number of parameters, number of variables, type of models etc.,
  // therefore a calculateIC() is always necessary.
  zCurrent_.assign(model_->sizeZ(), 0.);
  calculateIC();

  // Initialize curves
  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;
  Trace::info() << DYNLog(CurveInit) << Trace::endline;
  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;
  const std::vector<double>& y = solver_->getCurrentY();
  unsigned nbCurves = 0;
  for (CurvesCollection::iterator itCurve = curvesCollection_->begin();
          itCurve != curvesCollection_->end();
          ++itCurve) {
    shared_ptr<curves::Curve>& curve = *itCurve;
    bool added = model_->initCurves(curve);
    if (added)
      ++nbCurves;
    if (curve->getCurveType() == curves::Curve::DISCRETE_VARIABLE) {
      curve->setBuffer(&(zCurrent_[curve->getGlobalIndex()]));
    } else if (curve->getCurveType() == curves::Curve::CONTINUOUS_VARIABLE) {
      curve->setBuffer(&(y[curve->getGlobalIndex()]));
    }
  }
  stringstream ss;
  ss << nbCurves;
  Trace::info() << DYNLog(CurveInitEnd, ss.str()) << Trace::endline;
  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline<< Trace::endline;

  // if no dump to load t0 should be equal to zero
  // if dump loaded, t0 should be equal to the current time loaded

  if (doubleNotEquals(getStartTime(), t0))
    throw DYNError(Error::GENERAL, WrongStartTime, getStartTime(), t0);

  solver_->setTimeline(timeline_);
}

void
Simulation::calculateIC() {
  // ensure locally satisfactory values for initial models
  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;
  Trace::info() << DYNLog(ModelLocalInit) << Trace::endline;
  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;
  model_->setIsInitProcess(true);
  model_->init(tStart_);
  model_->rotateBuffers();
  model_->printMessages();
  if (Trace::logExists(Trace::parameters(), DEBUG)) {
    model_->printLocalInitParametersValues();
  }

  if (dumpLocalInitValues_) {
    string localInitDir = createAbsolutePath("initValues/localInit", outputsDirectory_);
    if (!exists(localInitDir))
      create_directory(localInitDir);
    model_->printInitValues(localInitDir);
  }
  // check coherence during local init process (use of init model)
  model_->checkDataCoherence(tCurrent_);
  model_->checkParametersCoherence();
  model_->setIsInitProcess(false);
  Trace::info() << DYNLog(ModelLocalInitEnd) << Trace::endline;
  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline<< Trace::endline;

  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;
  Trace::info() << DYNLog(ModelGlobalInit) << Trace::endline;
  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;
  // ensure globally satisfactory initial values for dynamic models
  solver_->init(model_, tStart_, tStop_);
  solver_->calculateIC();
  model_->getCurrentZ(zCurrent_);

  if (dumpGlobalInitValues_) {
    string globalInitDir = createAbsolutePath("initValues/globalInit", outputsDirectory_);
    if (!exists(globalInitDir))
      create_directory(globalInitDir);
    model_->printInitValues(globalInitDir);
  }

  // after the initialization process (use of dynamic model)
  model_->checkDataCoherence(tCurrent_);
  Trace::info() << DYNLog(ModelGlobalInitEnd) << Trace::endline;
  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline<< Trace::endline;
}

void
Simulation::simulate() {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("Simulation::simulate()");
#endif
  printSolverHeader();

  stringstream fileName;
  if (dumpTimetable_) {
    string outputsDirectory = createAbsolutePath("outputs", context_->getInputDirectory());
    if (!is_directory(outputsDirectory))
      create_directory(outputsDirectory);
    fileName << outputsDirectory << "/.dynawoexec-" << pid_;
  }

  // Printing out the initial solution
  solver_->printSolve();
  if (exportCurvesMode_ != EXPORT_CURVES_NONE) {
    // This is a workaround to update the calculated variables with initial values of y and yp as they are not accessible at this level
    model_->evalCalculatedVariables(tCurrent_, solver_->getCurrentY(), solver_->getCurrentYP(), zCurrent_);
  }
  const bool updateCalculatedVariable = false;
  updateCurves(updateCalculatedVariable);  // initial curves

  bool criteriaChecked = true;
  try {
    if (data_ && (exportIIDM_ || activateCriteria_)) {  // no need to update state variable if the IIDM final state is not exported (same for criteria check)
      data_->getStateVariableReference();   // Each state variable in DataInterface has a mapped reference variable in dynamic model,
                                         // either in a modelica model or in a C++ model.
    }
    int currentIterNb = 0;
    while (!end() && !SignalHandler::gotExitSignal() && criteriaChecked) {
      bool isCheckCriteriaIter = data_ && activateCriteria_ && currentIterNb % criteriaStep_ == 0;

      solver_->solve(tStop_, tCurrent_);
      solver_->printSolve();
      if (currentIterNb == 0)
        printHighestDerivativesValues();

      BitMask solverState = solver_->getState();
      bool modifZ = false;
      if (solverState.getFlags(ModeChange)) {
        updateCurves(true);
        Trace::info() << DYNLog(NewStartPoint) << Trace::endline;
        solver_->reinit();
        model_->getCurrentZ(zCurrent_);
        solver_->printSolve();
        printHighestDerivativesValues();
      } else if (solverState.getFlags(NotSilentZChange)
          || solverState.getFlags(SilentZNotUsedInDiscreteEqChange)
          || solverState.getFlags(SilentZNotUsedInContinuousEqChange)) {
        updateCurves(true);
        model_->getCurrentZ(zCurrent_);
        modifZ = true;
      }

      if (isCheckCriteriaIter)
        model_->evalCalculatedVariables(tCurrent_, solver_->getCurrentY(), solver_->getCurrentYP(), zCurrent_);
      updateCurves(!isCheckCriteriaIter && !modifZ);

      model_->checkDataCoherence(tCurrent_);
      model_->printMessages();
      if (dumpTimetable_)
        printCurrentTime(fileName.str());

      if (isCheckCriteriaIter) {
        criteriaChecked = checkCriteria(tCurrent_, false);
      }
      ++currentIterNb;
    }

    // If we haven't evaluated the calculated variables for the last iteration before, we must do it here for the IIDM file export
    if (exportIIDM_ && (exportCurvesMode_ != EXPORT_CURVES_NONE || activateCriteria_))
      model_->evalCalculatedVariables(tCurrent_, solver_->getCurrentY(), solver_->getCurrentYP(), zCurrent_);

    if (SignalHandler::gotExitSignal() && !end()) {
      addEvent(DYNTimeline(SignalReceived));
      throw DYNError(Error::GENERAL, SignalReceived);
    } else if (!criteriaChecked) {
      addEvent(DYNTimeline(CriteriaNotChecked));
      throw DYNError(Error::SIMULATION, CriteriaNotChecked);
    } else if (end() && data_ && activateCriteria_) {
      criteriaChecked = checkCriteria(tCurrent_, true);
      if (!criteriaChecked) {
        addEvent(DYNTimeline(CriteriaNotChecked));
        throw DYNError(Error::SIMULATION, CriteriaNotChecked);
      }
    }
    if (dumpTimetable_)
      remove(fileName.str());
  } catch (const Terminate& t) {
    Trace::warn() << t.what() << Trace::endline;
    model_->printMessages();
    endSimulationWithError(fileName.str(), criteriaChecked);
  } catch (const Error& e) {
    Trace::error() << e.what() << Trace::endline;
    bool staticModelWellInitialized = true;
    if (e.key() == DYN::KeyError_t::StateVariableNoReference)
      staticModelWellInitialized = false;
    endSimulationWithError(fileName.str(), criteriaChecked && staticModelWellInitialized);
    throw;
  } catch (...) {
    endSimulationWithError(fileName.str(), criteriaChecked);
    throw;
  }
}

void
Simulation::endSimulationWithError(const std::string& execFileName, bool criteria) {
  if (dumpTimetable_)
    remove(execFileName);
  if (criteria && data_ && activateCriteria_) {
    bool criteriaChecked = checkCriteria(tCurrent_, true);
    if (!criteriaChecked) {
      if (timeline_) {
        addEvent(DYNTimeline(CriteriaNotChecked));
      }
      throw DYNError(Error::SIMULATION, CriteriaNotChecked);
    }
  }
}

bool
Simulation::checkCriteria(double t, bool finalStep) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("Simulation::checkCriteria()");
#endif
  const bool filterForCriteriaCheck = true;
  data_->updateFromModel(filterForCriteriaCheck);
  bool criteriaChecked = data_->checkCriteria(t, finalStep);
  return criteriaChecked;
}


void
Simulation::getFailingCriteria(std::vector<std::pair<double, std::string> >& failingCriteria) const {
  data_->getFailingCriteria(failingCriteria);
}

void
Simulation::updateParametersValues() {
  if (exportCurvesMode_ == EXPORT_CURVES_NONE)
    return;

  for (CurvesCollection::iterator itCurve = curvesCollection_->begin();
          itCurve != curvesCollection_->end();
          ++itCurve) {
    if ((*itCurve)->isParameterCurve()) {   // if a parameter curve
      string curveModelName((*itCurve)->getModelName());
      string curveVariable((*itCurve)->getVariable());

      double value;
      bool found(false);

      model_->getModelParameterValue(curveModelName, curveVariable, value, found);   // get value

      if (found) {
        (*itCurve)->updateParameterCurveValue(curveVariable, value);   // update value
      }
    }
  }
}

void
Simulation::updateCurves(bool updateCalculateVariable) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("Simulation::updateCurves()");
#endif
  if (exportCurvesMode_ == EXPORT_CURVES_NONE)
    return;

  if (updateCalculateVariable)
    model_->updateCalculatedVarForCurves(curvesCollection_);

  curvesCollection_->updateCurves(tCurrent_);
}

void
Simulation::printSolverHeader() {
  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;
  Trace::info() << DYNLog(SimulationStart, solver_->solverType()) << Trace::endline;
  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;
  solver_->printHeader();
}

void
Simulation::addEvent(const MessageTimeline& messageTimeline) {
  const string name = "Simulation";
  timeline_->addEvent(getCurrentTime(), name, messageTimeline.str(), messageTimeline.priority());
}

void
Simulation::printHighestDerivativesValues() {
  if (!Trace::logExists("", DEBUG)) return;
  const vector<double>& deriv = solver_->getCurrentYP();
  vector<std::pair<double, size_t> > derivValues;
  for (size_t i = 0, iEnd = deriv.size(); i < iEnd; ++i)
    derivValues.push_back(std::make_pair(deriv[i], i));

  std::sort(derivValues.begin(), derivValues.end(), mapcompabs());

  const unsigned nbDeriv = std::min(10, model_->sizeY());
  Trace::debug() << DYNLog(SolverLargestDeriv, nbDeriv) << Trace::endline;
  for (size_t i = 0; i < nbDeriv; ++i) {
    Trace::debug() << DYNLog(SolverLargestDerivValue, derivValues[i].second, derivValues[i].first,
                             model_->getVariableName(derivValues[i].second)) << Trace::endline;
  }
}

void
Simulation::printEnd() {
  solver_->printEnd();
}

void
Simulation::terminate() {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("Simulation::terminate()");
#endif
  updateParametersValues();   // update parameter curves' value

  if (curvesOutputFile_ != "") {
    ofstream fileCurves;
    openFileStream(fileCurves, curvesOutputFile_);
    printCurves(fileCurves);
    fileCurves.close();
  }

  if (timelineOutputFile_ != "") {
    ofstream fileTimeline;
    openFileStream(fileTimeline, timelineOutputFile_);
    printTimeline(fileTimeline);
    fileTimeline.close();
  }

  if (finalStateOutputFile_ != "") {
    ofstream fileFinalState;
    openFileStream(fileFinalState, finalStateOutputFile_);
    printFinalState(fileFinalState);
    fileFinalState.close();
  }

  if (constraintsOutputFile_ != "") {
    ofstream fileConstraints;
    openFileStream(fileConstraints, constraintsOutputFile_);
    printConstraints(fileConstraints);
    fileConstraints.close();
  }

  if (exportDumpFinalState_)
    dumpState();

  if (exportIIDM_)
    dumpIIDMFile();

  printEnd();
}

void
Simulation::openFileStream(ofstream& stream, const std::string& path) {
  stream.open(path.c_str(), ofstream::out);
  if (!stream.is_open()) {
    throw DYNError(Error::SIMULATION, OpenFileFailed, path);
  }
}

void
Simulation::printCurves(std::ostream& stream) const {
  switch (exportCurvesMode_) {
    case EXPORT_CURVES_NONE:
      break;
    case EXPORT_CURVES_XML: {
      curves::XmlExporter xmlExporter;
      xmlExporter.exportToStream(curvesCollection_, stream);
      break;
    }
    case EXPORT_CURVES_CSV: {
      curves::CsvExporter csvExporter;
      csvExporter.exportToStream(curvesCollection_, stream);
      break;
    }
  }
}

void
Simulation::printTimeline(std::ostream& stream) const {
  switch (exportTimelineMode_) {
    case EXPORT_TIMELINE_NONE:
      break;
    case EXPORT_TIMELINE_CSV: {
      timeline::CsvExporter csvExporter;
      csvExporter.setMaxPriority(exportTimelineMaxPriority_);
      csvExporter.exportToStream(timeline_, stream);
      break;
    }
    case EXPORT_TIMELINE_XML: {
      timeline::XmlExporter xmlExporter;
      xmlExporter.setMaxPriority(exportTimelineMaxPriority_);
      xmlExporter.exportToStream(timeline_, stream);
      break;
    }
    case EXPORT_TIMELINE_TXT: {
      timeline::TxtExporter txtExporter;
      txtExporter.setMaxPriority(exportTimelineMaxPriority_);
      txtExporter.exportToStream(timeline_, stream);
      break;
    }
  }
}

void
Simulation::printFinalState(std::ostream& stream) const {
  switch (exportFinalStateMode_) {
    case EXPORT_FINALSTATE_NONE:
      break;
    case EXPORT_FINALSTATE_XML: {
      // update calculated variables
      model_->evalCalculatedVariables(tCurrent_, solver_->getCurrentY(), solver_->getCurrentYP(), zCurrent_);

      // association between requested variables and model variables
      for (finalStateModel_iterator itModel = finalStateCollection_->beginFinalStateModel();
              itModel != finalStateCollection_->endFinalStateModel();
              ++itModel) {
        model_->fillVariables(*itModel);
      }

      for (finalStateVariable_iterator itVariable = finalStateCollection_->beginVariable();
              itVariable != finalStateCollection_->endVariable();
              ++itVariable) {
        model_->fillVariable(*itVariable);
      }
      // export variables
      finalState::XmlExporter xmlExporter;
      xmlExporter.exportToStream(finalStateCollection_, stream);
      break;
    }
  }
}

void
Simulation::printConstraints(std::ostream& stream) const {
  switch (exportConstraintsMode_) {
    case EXPORT_CONSTRAINTS_NONE:
      break;
    case EXPORT_CONSTRAINTS_XML: {
      constraints::XmlExporter xmlExporter;
      xmlExporter.exportToStream(constraintsCollection_, stream);
      break;
    }
    case EXPORT_CONSTRAINTS_TXT: {
      constraints::TxtExporter txtExporter;
      txtExporter.exportToStream(constraintsCollection_, stream);
      break;
    }
  }
}

void
Simulation::dumpIIDMFile() {
  if (data_) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
    Timer timer("Job::exportStateVariables");
#endif
    data_->exportStateVariables();
  }
  data_->dumpToFile(exportIIDMFile_);
}

void
Simulation::dumpState() {
  if (!model_) return;
  stringstream state;
  boost::archive::binary_oarchive os(state);

  os << tCurrent_;

  map<string, string> mapValues;  // map associating file name with parameters/variables to dump
  mapValues[TIME_FILENAME] = state.str();

  model_->dumpParameters(mapValues);
  model_->dumpVariables(mapValues);

  boost::shared_ptr<zip::ZipFile> archive = zip::ZipFileFactory::newInstance();

  for (map<string, string>::const_iterator it = mapValues.begin();
          it != mapValues.end();
          ++it) {
    archive->addEntry(it->first, it->second);
  }
  zip::ZipOutputStream::write(dumpFinalStateFile_, archive);
}

double
Simulation::loadState(const string & fileName) {
  boost::shared_ptr<zip::ZipFile> archive = zip::ZipInputStream::read(fileName);
  map<string, string> mapValues;  // map associating file name with parameters/variables to dumpe
  for (map<string, shared_ptr<zip::ZipEntry> >::const_iterator itE = archive->getEntries().begin();
          itE != archive->getEntries().end(); ++itE) {
    string name = itE->first;
    string data(itE->second->getData());
    mapValues[name] = data;
  }

  map<string, string >::iterator iter = mapValues.find(TIME_FILENAME);
  if (iter == mapValues.end())
    throw DYNError(Error::GENERAL, IncompleteDump);

  stringstream state(iter->second);
  boost::archive::binary_iarchive is(state);

  double tCurrent = 0;
  is >> tCurrent;
  // loading information
  tCurrent_ = tCurrent;

  setStartTime(tStart_);
  setStopTime(tStop_);

  model_->setInitialTime(tCurrent_);

  // loading parameters/model variables
  model_->loadParameters(mapValues);
  model_->loadVariables(mapValues);
  return tCurrent_;
}

void
Simulation::printDebugInfo() {
  Trace::debug() << DYNLog(NbVar, model_->sizeY()) << Trace::endline;
  Trace::debug() << DYNLog(NbRootFunctions, model_->sizeG()) << Trace::endline;
}

void
Simulation::printCurrentTime(const string& fileName) {
  ofstream out(fileName.c_str());
  out << tCurrent_;
  out.close();
  fs::permissions(fileName, fs::group_read | fs::group_write | fs::owner_write | fs::others_write | fs::owner_read | fs::others_read);
}

}  // end of namespace DYN
