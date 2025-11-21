//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DYNSimulation.cpp
 *
 * @brief Simulation implementation
 *
 */

#include <iomanip>
#include <utility>
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
#include "CRVCurveFactory.h"
#include "CRVCurve.h"
#include "CRVXmlExporter.h"
#include "CRVCsvExporter.h"

#include "FSVFinalStateValuesCollectionFactory.h"
#include "FSVFinalStateValuesCollection.h"
#include "FSVFinalStateValue.h"
#include "FSVFinalStateValueFactory.h"
#include "FSVXmlExporter.h"
#include "FSVXmlImporter.h"
#include "FSVCsvExporter.h"
#include "FSVTxtExporter.h"

#include "CSTRConstraintsCollection.h"
#include "CSTRConstraintsCollectionFactory.h"
#include "CSTRTxtExporter.h"
#include "CSTRXmlExporter.h"

#include "LEQLostEquipmentsCollectionFactory.h"
#include "LEQXmlExporter.h"

#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"
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
#include "JOBTimetableEntry.h"
#include "JOBFinalStateEntry.h"
#include "JOBCurvesEntry.h"
#include "JOBSimulationEntry.h"
#include "JOBLogsEntry.h"
#include "JOBAppenderEntry.h"
#include "JOBDynModelsEntry.h"

#include "DYNCompiler.h"
#include "DYNDynamicData.h"
#include "DYNModel.h"
#include "DYNSimulation.h"
#include "DYNSimulationContext.h"
#include "DYNTrace.h"
#include "DYNMacrosMessage.h"
#include "DYNSolver.h"
#include "DYNTimer.h"
#include "DYNModelMulti.h"
#include "DYNFileSystemUtils.h"
#include "DYNTerminate.h"
#include "DYNDataInterface.h"
#include "DYNDataInterfaceFactory.h"
#include "DYNExecUtils.h"
#include "DYNSignalHandler.h"
#include "DYNIoDico.h"
#include "DYNBitMask.h"

#include "make_unique.hpp"

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

using finalStateValues::FinalStateValuesCollection;
using finalStateValues::FinalStateValuesCollectionFactory;

using constraints::ConstraintsCollectionFactory;

using parameters::ParametersSet;
using parameters::ParametersSetFactory;
using parameters::ParametersSetCollection;

static const char TIME_FILENAME[] = "time.bin";  ///< name of the file to dump time at the end of the simulation


/**
 * @brief Hash structure for std::pair<std::string, std::string>
 */
struct StringPairHash {
  /**
   * @brief Operator to retrieve stringPair hash value
   *
   * @param stringPair the stringPair to hash
   * @returns the hash value
   */
  size_t operator()(const std::pair<std::string, std::string>& stringPair) const {
    size_t seed = 0;
    boost::hash_combine(seed, stringPair.first);
    boost::hash_combine(seed, stringPair.second);
    return seed;
  }
};


namespace DYN {

Simulation::Simulation(const std::shared_ptr<job::JobEntry>& jobEntry, const std::shared_ptr<SimulationContext>& context, shared_ptr<DataInterface> data) :
context_(context),
jobEntry_(jobEntry),
data_(std::move(data)),
timeline_(),
constraintsCollection_(),
iidmFile_(""),
networkParFile_(""),
networkParSet_(""),
initialStateFile_(""),
exportCurvesMode_(EXPORT_CURVES_NONE),
curvesInputFile_(""),
curvesOutputFile_(""),
exportFinalStateValuesMode_(EXPORT_FINAL_STATE_VALUES_NONE),
finalStateValuesInputFile_(""),
finalStateValuesOutputFile_(""),
exportTimelineMode_(EXPORT_TIMELINE_NONE),
exportTimelineWithTime_(true),
exportTimelineMaxPriority_(boost::none),
timelineOutputFile_(""),
filterTimeline_(false),
exportConstraintsMode_(EXPORT_CONSTRAINTS_NONE),
constraintsOutputFile_(""),
exportLostEquipmentsMode_(EXPORT_LOSTEQUIPMENTS_NONE),
lostEquipmentsOutputFile_(""),
finalState_(std::numeric_limits<double>::max()),
tStart_(0.),
tCurrent_(0.),
tStop_(0.),
activateCriteria_(false),
criteriaStep_(0.),
dumpLocalInitValues_(false),
dumpGlobalInitValues_(false),
dumpInitModelValues_(false),
dumpFinalValues_(false),
wasLoggingEnabled_(false) {
  SignalHandler::setSignalHandlers();

#ifdef _MSC_VER
  pid_ = _getpid();
#else
  pid_ = getpid();
#endif
  stringstream pid_string;
  pid_string << pid_;
  curvesCollection_ = CurvesCollectionFactory::newInstance("Simulation_" + pid_string.str());

  // Set simulation parameters
  setStartTime(jobEntry_->getSimulationEntry()->getStartTime());
  setStopTime(jobEntry_->getSimulationEntry()->getStopTime());
  setActivateCriteria(!jobEntry_->getSimulationEntry()->getCriteriaFiles().empty());
  setCriteriaStep(jobEntry_->getSimulationEntry()->getCriteriaStep());
  setCurrentPrecision(jobEntry_->getSimulationEntry()->getPrecision());

  outputsDirectory_ = context_->getWorkingDirectory();
  if (jobEntry_->getOutputsEntry()) {
    outputsDirectory_ = createAbsolutePath(jobEntry_->getOutputsEntry()->getOutputsDirectory(), context_->getWorkingDirectory());
    if (!isDirectory(outputsDirectory_))
      createDirectory(outputsDirectory_);
  }

  configureLogs();
  configureSimulationOutputs();
  setSolver();
  configureSimulationInputs();
  configureCriteria();
}

void
Simulation::configureSimulationInputs() {
  //---- dydFile ----
  vector<string> dydFiles;
  for (const auto& dynModelsEntry : jobEntry_->getModelerEntry()->getDynModelsEntries()) {
    string absoluteDirPath = createAbsolutePath(dynModelsEntry->getDydFile(), context_->getInputDirectory());
    if (!exists(absoluteDirPath)) {
      throw DYNError(Error::MODELER, UnknownDydFile, absoluteDirPath);
    }
    dydFiles_.push_back(absoluteDirPath);
  }

  if (jobEntry_->getModelerEntry()->getNetworkEntry()) {
    iidmFile_ = createAbsolutePath(jobEntry_->getModelerEntry()->getNetworkEntry()->getIidmFile(), context_->getInputDirectory());

    if (!data_ && !exists(iidmFile_))  // no need to check iidm file if data interface is provided
      throw DYNError(Error::GENERAL, UnknownIidmFile, iidmFile_);
  }
  if (jobEntry_->getModelerEntry()->getInitialStateEntry()) {
    initialStateFile_ = createAbsolutePath(jobEntry_->getModelerEntry()->getInitialStateEntry()->getInitialStateFile(), context_->getInputDirectory());
    if (!exists(initialStateFile_))
      throw DYNError(Error::GENERAL, UnknownInitialStateFile, initialStateFile_);
  }
}

void
Simulation::configureCriteria() {
  for (const auto& criteriaFile : jobEntry_->getSimulationEntry()->getCriteriaFiles()) {
    criteria::XmlImporter parser;
    std::string path = createAbsolutePath(criteriaFile, context_->getInputDirectory());
    std::shared_ptr<criteria::CriteriaCollection> ccollec = parser.importFromFile(path);
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
  if (jobEntry_->getOutputsEntry() != nullptr) {
    // Init Values settings
    if (jobEntry_->getOutputsEntry()->getInitValuesEntry() != nullptr) {
      setDumpLocalInitValues(jobEntry_->getOutputsEntry()->getInitValuesEntry()->getDumpLocalInitValues());
      setDumpGlobalInitValues(jobEntry_->getOutputsEntry()->getInitValuesEntry()->getDumpGlobalInitValues());
      setDumpInitModelValues(jobEntry_->getOutputsEntry()->getInitValuesEntry()->getDumpInitModelValues());
    }
    if (jobEntry_->getOutputsEntry()->getFinalValuesEntry() != nullptr) {
      setDumpFinalValues(jobEntry_->getOutputsEntry()->getFinalValuesEntry()->getDumpFinalValues());
    }
    configureConstraintsOutputs();
    configureTimelineOutputs();
    configureTimetableOutputs();
    configureCurveOutputs();
    configureFinalStateValueOutputs();
    configureFinalStateOutputs();
    configureLostEquipmentsOutputs();
  }
}

void
Simulation::configureConstraintsOutputs() {
  // Constraints settings
  if (jobEntry_->getOutputsEntry()->getConstraintsEntry()) {
    stringstream pid_string;
    pid_string << pid_;
    constraintsCollection_ = ConstraintsCollectionFactory::newInstance("Simulation_" + pid_string.str());
    const string constraintsDir = createAbsolutePath("constraints", outputsDirectory_);
    if (!isDirectory(constraintsDir))
      createDirectory(constraintsDir);

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
    stringstream pid_string;
    pid_string << pid_;
    timeline_ = TimelineFactory::newInstance("Simulation_" + pid_string.str());
    string timeLineDir = createAbsolutePath("timeLine", outputsDirectory_);
    if (!isDirectory(timeLineDir))
      createDirectory(timeLineDir);

    //---- exportMode ----
    const string& exportMode = jobEntry_->getOutputsEntry()->getTimelineEntry()->getExportMode();
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
    exportTimelineWithTime_ = jobEntry_->getOutputsEntry()->getTimelineEntry()->getExportWithTime();
    exportTimelineMaxPriority_ = jobEntry_->getOutputsEntry()->getTimelineEntry()->getMaxPriority();
    filterTimeline_ = jobEntry_->getOutputsEntry()->getTimelineEntry()->isFilter();
    setTimelineOutputFile(outputFile);
  } else {
    setTimelineExportMode(Simulation::EXPORT_TIMELINE_NONE);
  }
}

void
Simulation::configureTimetableOutputs() {
  // Timetable settings
  if (jobEntry_->getOutputsEntry()->getTimetableEntry()) {
    if (!isDirectory(outputsDirectory_))
      createDirectory(outputsDirectory_);

    stringstream fileName;
    fileName << outputsDirectory_ << "/.dynawoexec-" << pid_;
    timetableOutputFile_ = fileName.str();

    timetableSteps_ = jobEntry_->getOutputsEntry()->getTimetableEntry()->getStep();
  }
}

void
Simulation::configureCurveOutputs() {
  // Curves settings
  if (jobEntry_->getOutputsEntry()->getCurvesEntry()) {
    string curvesDir = createAbsolutePath("curves", outputsDirectory_);
    if (!isDirectory(curvesDir))
      createDirectory(curvesDir);

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
Simulation::configureFinalStateValueOutputs() {
  // Final state value settings
  if (jobEntry_->getOutputsEntry()->getFinalStateValuesEntry()) {
    string finalStateValuesDir = createAbsolutePath("finalStateValues", outputsDirectory_);
    if (!isDirectory(finalStateValuesDir))
      createDirectory(finalStateValuesDir);

    //---- inputFile ----
    string finalStateValuesInputFile = createAbsolutePath(
        jobEntry_->getOutputsEntry()->getFinalStateValuesEntry()->getInputFile(),
        context_->getInputDirectory());

    if (!exists(finalStateValuesInputFile))
      throw DYNError(Error::MODELER, UnknownFinalStateValuesFile, finalStateValuesInputFile);
    setFinalStateValuesInputFile(finalStateValuesInputFile);
    importFinalStateValuesRequest();

    //---- exportMode ----
    std::string exportMode = jobEntry_->getOutputsEntry()->getFinalStateValuesEntry()->getExportMode();
    exportFinalStateValuesMode_t exportModeFlag = EXPORT_FINAL_STATE_VALUES_NONE;
    std::string outputFile = "";
    if (exportMode == "XML") {
      exportModeFlag = EXPORT_FINAL_STATE_VALUES_XML;
      outputFile = createAbsolutePath("finalStateValues.xml", finalStateValuesDir);
    } else if (exportMode == "CSV") {
      exportModeFlag = EXPORT_FINAL_STATE_VALUES_CSV;
      outputFile = createAbsolutePath("finalStateValues.csv", finalStateValuesDir);
    } else if (exportMode == "TXT") {
      exportModeFlag = EXPORT_FINAL_STATE_VALUES_TXT;
      outputFile = createAbsolutePath("finalStateValues.txt", finalStateValuesDir);
    } else {
      throw DYNError(Error::MODELER, UnknownFinalStateValuesExport, exportMode);
    }
    setFinalStateValuesExportMode(exportModeFlag);
    setFinalStateValuesOutputFile(outputFile);
  } else {
    setFinalStateValuesExportMode(Simulation::EXPORT_FINAL_STATE_VALUES_NONE);
  }
}

void
Simulation::configureFinalStateOutputs() {
  // Final state settings
  const std::vector<std::shared_ptr<job::FinalStateEntry> >& finalStateEntries = jobEntry_->getOutputsEntry()->getFinalStateEntries();

  string finalStateDir = createAbsolutePath("finalState", outputsDirectory_);
  if (!finalStateEntries.empty() && !isDirectory(finalStateDir)) {
    createDirectory(finalStateDir);
  }
  std::map<double, ExportStateDefinition> dumpStateDefinitionsMap;
  for (const auto& finalStateEntry : finalStateEntries) {
    boost::optional<double> timestamp = finalStateEntry->getTimestamp();

    if (!timestamp) {
      // case no timestamp given, meaning final state
      // ---- exportDumpFile ----
      if (finalStateEntry->getExportDumpFile()) {
        finalState_.dumpFile_ = createAbsolutePath("outputState.dmp", finalStateDir);
      }

      // --- exportIIDMFile ----
      if (finalStateEntry->getExportIIDMFile()) {
        finalState_.iidmFile_ = createAbsolutePath("outputIIDM.xml", finalStateDir);
      }
    } else {
      if (!finalStateEntry->getExportDumpFile() && !finalStateEntry->getExportIIDMFile()) {
        // no need to add a definition if no file is exported
        continue;
      }
      ExportStateDefinition dumpStateDefinition(*timestamp);
      if (finalStateEntry->getExportDumpFile()) {
        std::stringstream ss;
        ss << *timestamp << "_outputState.dmp";
        dumpStateDefinition.dumpFile_ = createAbsolutePath(ss.str(), finalStateDir);
      }
      if (finalStateEntry->getExportIIDMFile()) {
        std::stringstream ss;
        ss << *timestamp << "_outputIIDM.xml";
        dumpStateDefinition.iidmFile_ = createAbsolutePath(ss.str(), finalStateDir);
      }
      dumpStateDefinitionsMap.insert(std::make_pair(*timestamp, dumpStateDefinition));
    }
  }
  // The map is used here to sort the requested final states according to the time requested
  for (const auto& dumpStateDefinition : dumpStateDefinitionsMap) {
    intermediateStates_.push(dumpStateDefinition.second);
  }
}

void
Simulation::configureLostEquipmentsOutputs() {
  // Lost equipments settings
  if (jobEntry_->getOutputsEntry()->getLostEquipmentsEntry()
      && jobEntry_->getOutputsEntry()->getLostEquipmentsEntry()->getDumpLostEquipments()) {
    string lostEquipmentsDir = createAbsolutePath("lostEquipments", outputsDirectory_);
    if (!isDirectory(lostEquipmentsDir))
      createDirectory(lostEquipmentsDir);

    setLostEquipmentsExportMode(Simulation::EXPORT_LOSTEQUIPMENTS_XML);
    setLostEquipmentsOutputFile(createAbsolutePath("lostEquipments.xml", lostEquipmentsDir));
  }
}

void
Simulation::compileModels() const {
  // ModelsDirEntry: Precompiled models
  // convert precompiled models directories into absolute directories, and check whether they actually exist
  vector <UserDefinedDirectory> precompiledModelsDirsAbsolute;
  string preCompiledModelsExtension = sharedLibraryExtension();
  bool preCompiledUseStandardModels = false;
  if (jobEntry_->getModelerEntry()->getPreCompiledModelsDirEntry()) {
    vector <UserDefinedDirectory> precompiledModelsDirs = jobEntry_->getModelerEntry()->getPreCompiledModelsDirEntry()->getDirectories();
    for (const auto& precompiledModelsDir : precompiledModelsDirs) {
      string absoluteDirPath = createAbsolutePath(precompiledModelsDir.path, context_->getInputDirectory());
      if (!exists(absoluteDirPath)) {
        throw DYNError(Error::MODELER, UnknownModelsDir, absoluteDirPath);
      }
      UserDefinedDirectory dir;
      dir.path = absoluteDirPath;
      dir.isRecursive = precompiledModelsDir.isRecursive;
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
    for (const auto& modelicaModelsDir : modelicaModelsDirs) {
      string absoluteDirPath = createAbsolutePath(modelicaModelsDir.path, context_->getInputDirectory());
      if (!exists(absoluteDirPath)) {
        throw DYNError(Error::MODELER, UnknownModelsDir, absoluteDirPath);
      }
      UserDefinedDirectory dir;
      dir.path = absoluteDirPath;
      dir.isRecursive = modelicaModelsDir.isRecursive;
      modelicaModelsDirsAbsolute.push_back(dir);
    }
    if (!jobEntry_->getModelerEntry()->getModelicaModelsDirEntry()->getModelExtension().empty()) {
      modelicaModelsExtension = jobEntry_->getModelerEntry()->getModelicaModelsDirEntry()->getModelExtension();
    }
    modelicaUseStandardModels = jobEntry_->getModelerEntry()->getModelicaModelsDirEntry()->getUseStandardModels();
  }

  //---- compileDir ----
  string compileDir = createAbsolutePath(jobEntry_->getModelerEntry()->getCompileDir(), context_->getWorkingDirectory());
  if (!exists(compileDir))
    createDirectory(compileDir);

  vector<string> additionalHeaderFiles;
  if (hasEnvVar("DYNAWO_HEADER_FILES_FOR_PREASSEMBLED")) {
    string additionalHeaderList = getEnvVar("DYNAWO_HEADER_FILES_FOR_PREASSEMBLED");
    boost::split(additionalHeaderFiles, additionalHeaderList, boost::is_any_of(" "), boost::token_compress_on);
  }
  std::unordered_set<boost::filesystem::path, PathHash> pathsToIgnore;
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
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("Simulation::loadDynamicData()");
#endif
  // Load model
  dyd_.reset(new DynamicData());  // takes ownership of pointer
  dyd_->setRootDirectory(context_->getInputDirectory());
  dyd_->setParametersReference(referenceParameters_);

  if (!data_) {
    if (!iidmFile_.empty()) {
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

  data_->setTimeline(timeline_);

  dyd_->setDataInterface(data_);

  dyd_->initFromDydFiles(dydFiles_);
  data_->mapConnections();

  if (data_->instantiateNetwork()) {
    string networkParFileName = jobEntry_->getModelerEntry()->getNetworkEntry()->getNetworkParFile();
    if (networkParFileName.empty()) {
        throw DYNError(Error::GENERAL, MissingParFile, jobEntry_->getName());
    }
    networkParFile_ = createAbsolutePath(jobEntry_->getModelerEntry()->getNetworkEntry()->getNetworkParFile(), context_->getInputDirectory());
    if (!exists(networkParFile_)) {
      throw DYNError(Error::GENERAL, UnknownParFile, networkParFile_, context_->getInputDirectory());
    } else {
      networkParFile_ = jobEntry_->getModelerEntry()->getNetworkEntry()->getNetworkParFile();
      networkParSet_ = jobEntry_->getModelerEntry()->getNetworkEntry()->getNetworkParId();
    }
  }

  // the Network parameter file path is considered to be relative to the jobs file directory
  dyd_->getNetworkParameters(networkParFile_, networkParSet_);
}

void
Simulation::setSolver() {
  // Creates solver
  string solverParFile = createAbsolutePath(jobEntry_->getSolverEntry()->getParametersFile(), context_->getInputDirectory());
  solver_ = SolverFactory::createSolverFromLib(jobEntry_->getSolverEntry()->getLib() + sharedLibraryExtension());

  parameters::XmlImporter importer;
  std::shared_ptr<ParametersSetCollection> parameters = importer.importFromFile(solverParFile);
  parameters->propagateOriginData(solverParFile);
  referenceParameters_[solverParFile] = parameters;
  string parId = jobEntry_->getSolverEntry()->getParametersId();
  parameters->getParametersFromMacroParameter();
  if (parameters->getParametersSet(parId)) {
    std::shared_ptr<ParametersSet> solverParams = ParametersSetFactory::copySet(parameters->getParametersSet(parId));
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
    if (!isDirectory(logsDir))
      createDirectory(logsDir);

    if (jobEntry_->getOutputsEntry()->getLogsEntry()->getAppenderEntries().empty()) {
      wasLoggingEnabled_ = Trace::isLoggingEnabled();
      Trace::disableLogging();
    } else {
      vector<std::shared_ptr<job::AppenderEntry> > appendersEntry = jobEntry_->getOutputsEntry()->getLogsEntry()->getAppenderEntries();
      vector<Trace::TraceAppender> appenders;
      for (const auto& appenderEntry : appendersEntry) {
        string file = createAbsolutePath(appenderEntry->getFilePath(), logsDir);
        // Creates log directory if doesn't exist
        string fileDir = removeFileName(file);
        if (!isDirectory(fileDir))
          createDirectory(fileDir);

        Trace::TraceAppender app;
        app.setTag(appenderEntry->getTag());
        app.setFilePath(file);
        app.setLvlFilter(Trace::severityLevelFromString(appenderEntry->getLvlFilter()));
        app.setShowLevelTag(appenderEntry->getShowLevelTag());
        app.setSeparator(appenderEntry->getSeparator());
        app.setShowTimeStamp(!appenderEntry->getTimeStampFormat().empty());
        app.setTimeStampFormat(appenderEntry->getTimeStampFormat());
        appenders.push_back(app);
      }
      Trace::clearAndAddAppenders(appenders);

      // Add DYNAWO version and revision in each header of appender
      for (const auto& appenderEntry : appendersEntry) {
        string tag = appenderEntry->getTag();
        Trace::printDynawoLogHeader(tag);
      }
    }
  } else {
    wasLoggingEnabled_ = Trace::isLoggingEnabled();
    Trace::disableLogging();
  }
}

void
Simulation::importCurvesRequest() {
  curves::XmlImporter importer;
  curvesCollection_ = CurvesCollectionFactory::copyInstance(importer.importFromFile(curvesInputFile_));
}

void
Simulation::importFinalStateValuesRequest() const {
  // Obtain Final State Values definitions from input file
  finalStateValues::XmlImporter importer;
  boost::shared_ptr<FinalStateValuesCollection> finalStateValuesCollection =
    FinalStateValuesCollectionFactory::copyInstance(importer.importFromFile(finalStateValuesInputFile_));

  // Final State Values and Curve points will be recorded during simulation in the same data structures
  // Here we merge the Final State Values definitions with the existing Curves definitions

  // A map for existing Curves is built so we can locate them fast and update them from the Final State Values
  // A Curve is identified by the pair model name, variable name
  typedef std::unordered_map<std::pair<std::string, std::string>, std::shared_ptr<curves::Curve>, StringPairHash> CurvesMap;
  CurvesMap curvesMap;
  for (const auto& curve : curvesCollection_->getCurves())
    curvesMap.insert(std::make_pair(std::make_pair(curve->getModelName(), curve->getVariable()), curve));

  for (const auto& finalStateValue : finalStateValuesCollection->getFinalStateValues()) {
    const auto entry = curvesMap.find(std::make_pair(finalStateValue->getModelName(), finalStateValue->getVariable()));
    if (entry != curvesMap.end()) {
      entry->second->setExportType(curves::Curve::EXPORT_AS_BOTH);
    } else {
      std::unique_ptr<curves::Curve> curve = curves::CurveFactory::newCurve();
      curve->setModelName(finalStateValue->getModelName());
      curve->setVariable(finalStateValue->getVariable());
      curve->setExportType(curves::Curve::EXPORT_AS_FINAL_STATE_VALUE);
      curvesCollection_->add(std::move(curve));
    }
  }
}

std::unique_ptr<Modeler>
Simulation::createModeler() const {
  std::unique_ptr<Modeler> modeler = DYN::make_unique<Modeler>();
  return modeler;
}

void
Simulation::initFromData(const shared_ptr<DataInterface>& data, const shared_ptr<DynamicData>& dyd) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("Simulation::initFromData()");
#endif
  std::unique_ptr<Modeler> modeler = createModeler();
  modeler->setDataInterface(data);
  modeler->setDynamicData(dyd);
  modeler->initSystem();

  model_ = modeler->getModel();
  model_->setWorkingDirectory(context_->getWorkingDirectory());
  model_->setTimeline(timeline_);
  model_->setConstraints(constraintsCollection_);

  if (jobEntry_->getLocalInitEntry() != nullptr) {
    const std::string initParFile = createAbsolutePath(jobEntry_->getLocalInitEntry()->getParFile(), context_->getInputDirectory());
    const std::string parId = jobEntry_->getLocalInitEntry()->getParId();
    parameters::XmlImporter parametersImporter;
    std::shared_ptr<ParametersSetCollection> localInitSetCollection = parametersImporter.importFromFile(initParFile);
    std::shared_ptr<ParametersSet> localInitParameters = localInitSetCollection->getParametersSet(parId);

    model_->setLocalInitParameters(localInitParameters);
  }
}

void
Simulation::initStructure() const {
  model_->initBuffers();
  const std::shared_ptr<ModelMulti> model = std::dynamic_pointer_cast<ModelMulti>(model_);
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

  if (Trace::logExists(Trace::modeler(), DEBUG))
    model_->printModel();
  if (Trace::logExists(Trace::variables(), DEBUG)) {
    const bool withVariableType = false;  // At this point dynamic types are not known, the log is present to have infos in case calculateIC fails.
    model_->printVariableNames(withVariableType);
  }

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

  model_->initSilentZ(solver_->silentZEnabled());

  Trace::info() << DYNLog(ModelBuildingEnd) << Trace::endline;
  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline<< Trace::endline;

  if (!initialStateFile_.empty()) {
    Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;
    Trace::info() << DYNLog(ModelInitialStateLoad) << Trace::endline;
    Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;
    t0 = loadState(initialStateFile_);  // loadState and return initial time
    Trace::info() << DYNLog(ModelInitialStateLoadEnd) << Trace::endline;
    Trace::info() << "-----------------------------------------------------------------------" << Trace::endline<< Trace::endline;
  }
  // if no dump to load t0 should be equal to zero
  // if dump loaded, t0 should be equal to the current time loaded
  if (doubleNotEquals(tStart_, t0)) {
    Trace::warn() << DYNLog(WrongStartTime, tStart_, t0) << Trace::endline;
    tStart_ = t0;
  }

  // When a simulation starts with a dumpfile (initial condition of variables for dynamic models),
  // initial condition's calculation is not necessary for those dynamic models;
  // however, the NETWORK model could be different from the one in dumpfile,
  // like number of parameters, number of variables, type of models etc.,
  // therefore a calculateIC() is always necessary.
  zCurrent_.assign(model_->sizeZ(), 0.);
  calculateIC();

  if (Trace::logExists(Trace::variables(), DEBUG)) {
    const bool withVariableType = true;  // We rewrite the file with types this time
    model_->printVariableNames(withVariableType);
  }

  // Initialize curves
  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;
  Trace::info() << DYNLog(CurveInit) << Trace::endline;
  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;
  const std::vector<double>& y = solver_->getCurrentY();
  unsigned nbCurves = 0;
  for (const auto& curve : curvesCollection_->getCurves()) {
    const bool added = model_->initCurves(curve);
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

  if (dumpInitModelValues_) {
    const string localInitDir = createAbsolutePath("initValues/initModel", outputsDirectory_);
    if (!exists(localInitDir))
      createDirectory(localInitDir);
    model_->printInitModelValues(localInitDir, "dumpInitValues");
  }

  if (dumpLocalInitValues_) {
    const string localInitDir = createAbsolutePath("initValues/localInit", outputsDirectory_);
    if (!exists(localInitDir))
      createDirectory(localInitDir);
    model_->printModelValues(localInitDir, "dumpInitValues");
  }
  // check coherence during local init process (use of init model)
  model_->checkDataCoherence(tCurrent_);
  model_->checkParametersCoherence();
  model_->setIsInitProcess(false);
  Trace::info() << DYNLog(ModelLocalInitEnd) << Trace::endline;
  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline<< Trace::endline;

  model_->evalDynamicYType();
  model_->evalDynamicFType();

  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;
  Trace::info() << DYNLog(ModelGlobalInit) << Trace::endline;
  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;
  // ensure globally satisfactory initial values for dynamic models
  solver_->init(model_, tStart_, tStop_);
  solver_->calculateIC(tStop_);
  model_->getCurrentZ(zCurrent_);

  model_->notifyTimeStep();

  if (dumpGlobalInitValues_) {
    const string globalInitDir = createAbsolutePath("initValues/globalInit", outputsDirectory_);
    if (!exists(globalInitDir))
      createDirectory(globalInitDir);
    model_->printModelValues(globalInitDir, "dumpInitValues");
  }

  // after the initialization process (use of dynamic model)
  model_->checkDataCoherence(tCurrent_);
  Trace::info() << DYNLog(ModelGlobalInitEnd) << Trace::endline;
  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline<< Trace::endline;
}

void
Simulation::simulate() {
  Timer timer("Simulation::simulate()");
  printSolverHeader();

  // Printing out the initial solution
  solver_->printSolve();
  if (exportCurvesMode_ != EXPORT_CURVES_NONE) {
    // This is a workaround to update the calculated variables with initial values of y and yp as they are not accessible at this level
    model_->evalCalculatedVariables(tCurrent_, solver_->getCurrentY(), solver_->getCurrentYP(), zCurrent_);
  }
  constexpr bool updateCalculatedVariable = false;
  updateCurves(updateCalculatedVariable);  // initial curves

  bool criteriaChecked = true;
  try {
    // update state variable only if the IIDM final state is exported, or criteria is checked, or lost equipments are exported
    if (data_ && (finalState_.iidmFile_ || activateCriteria_ || isLostEquipmentsExported())) {
      data_->getStateVariableReference();   // Each state variable in DataInterface has a mapped reference variable in dynamic model,
                                         // either in a modelica model or in a C++ model.
      // save initial connection state at t0 for each equipment
      if (isLostEquipmentsExported()) {
        data_->updateFromModel(false);  // force state variables' init
        connectedComponents_ = data_->findConnectedComponents();
      }
    }

    std::shared_ptr<job::CurvesEntry> curvesEntry = jobEntry_->getOutputsEntry()->getCurvesEntry();
    boost::optional<int> iterationStep;
    boost::optional<double> timeStep;
    if (curvesEntry != nullptr) {
      iterationStep = curvesEntry->getIterationStep();
      timeStep = curvesEntry->getTimeStep();
    }
    int currentIterNb = 0;
    double nextTimeStep = 0;
    while (!end() && !SignalHandler::gotExitSignal() && criteriaChecked) {
      double elapsed = timer.elapsed();
      double timeout = jobEntry_->getSimulationEntry()->getTimeout();
      if (elapsed > timeout) {
        Trace::warn() << DYNLog(SimulationTimeoutReached, jobEntry_->getName(), timeout) << Trace::endline;
        endSimulationWithError(false);
        return;
      }

      const bool isCheckCriteriaIter = data_ && activateCriteria_ && currentIterNb % criteriaStep_ == 0;

      solver_->solve(tStop_, tCurrent_);
      solver_->printSolve();
      if (currentIterNb == 0)
        printHighestDerivativesValues();

      BitMask solverState = solver_->getState();
      bool modifZ = false;
      if (solverState.getFlags(ModeChange)) {
        updateCurves(true);
        model_->notifyTimeStep();
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

      if (iterationStep) {
        if (currentIterNb % *iterationStep == 0) {
          updateCurves(!isCheckCriteriaIter && !modifZ);
        }
      } else if (timeStep) {
        if (tCurrent_ >= nextTimeStep) {
          nextTimeStep = tCurrent_ + *timeStep;
          updateCurves(!isCheckCriteriaIter && !modifZ);
        }
      } else {
        updateCurves(!isCheckCriteriaIter && !modifZ);
      }

      model_->checkDataCoherence(tCurrent_);
      model_->printMessages();
      if (!timetableOutputFile_.empty() && currentIterNb % timetableSteps_ == 0)
        printCurrentTime(timetableOutputFile_);

      if (isCheckCriteriaIter) {
        criteriaChecked = checkCriteria(tCurrent_, false);
      }
      ++currentIterNb;

      model_->notifyTimeStep();

      if (hasIntermediateStateToDump() && !isCheckCriteriaIter) {
        // In case it was not already done beause of check criteria and intermediate state dump will be done at least one for current
        // iteration
        model_->evalCalculatedVariables(tCurrent_, solver_->getCurrentY(), solver_->getCurrentYP(), zCurrent_);
      }
      while (hasIntermediateStateToDump()) {
        const ExportStateDefinition& dumpDefinition = intermediateStates_.front();
        data_->exportStateVariables();
        if (dumpDefinition.dumpFile_) {
          dumpState(*dumpDefinition.dumpFile_);
        }
        if (dumpDefinition.iidmFile_) {
          dumpIIDMFile(*dumpDefinition.iidmFile_);
        }
        intermediateStates_.pop();
      }
    }

    // If we haven't evaluated the calculated variables for the last iteration before, we must do it here if it might be used in the post process
    if (finalState_.iidmFile_ || exportCurvesMode_ != EXPORT_CURVES_NONE || activateCriteria_)
      model_->evalCalculatedVariables(tCurrent_, solver_->getCurrentY(), solver_->getCurrentYP(), zCurrent_);

    if (SignalHandler::gotExitSignal() && !end()) {
      if (timeline_) {
        addEvent(DYNTimeline(SignalReceived));
      }
      throw DYNError(Error::GENERAL, SignalReceived);
    } else if (!criteriaChecked) {
      if (timeline_) {
        addEvent(DYNTimeline(CriteriaNotChecked));
      }
      throw DYNError(Error::SIMULATION, CriteriaNotChecked);
    } else if (end() && data_ && activateCriteria_) {
      criteriaChecked = checkCriteria(tCurrent_, true);
      if (!criteriaChecked) {
        if (timeline_) {
          addEvent(DYNTimeline(CriteriaNotChecked));
        }
        throw DYNError(Error::SIMULATION, CriteriaNotChecked);
      }
    }
    if (!timetableOutputFile_.empty())
        remove(timetableOutputFile_);
  } catch (const Terminate& t) {
    Trace::warn() << t.what() << Trace::endline;
    model_->printMessages();
    endSimulationWithError(criteriaChecked);
  } catch (const Error& e) {
    Trace::error() << e.what() << Trace::endline;
    bool staticModelWellInitialized = true;
    if (e.key() == DYN::KeyError_t::StateVariableNoReference)
      staticModelWellInitialized = false;
    if (e.type() == DYN::Error::SOLVER_ALGO ||
        e.type() == DYN::Error::SUNDIALS_ERROR ||
        e.type() == DYN::Error::NUMERICAL_ERROR) {
      endSimulationWithError(criteriaChecked && staticModelWellInitialized, true);
    } else {
      endSimulationWithError(criteriaChecked && staticModelWellInitialized);
    }
    throw;
  } catch (...) {
    endSimulationWithError(criteriaChecked);
    throw;
  }
}

bool
Simulation::hasIntermediateStateToDump() const {
  // Intermediate timestamp of the simulation reached
  return !intermediateStates_.empty() &&
        (doubleEquals(tCurrent_, intermediateStates_.front().timestamp_) || tCurrent_ > intermediateStates_.front().timestamp_);
}

void
Simulation::endSimulationWithError(const bool criteria, const bool isSimulationDiverging) const {
  if (!timetableOutputFile_.empty())
    remove(timetableOutputFile_);
  if (criteria && data_ && activateCriteria_) {
    const bool criteriaChecked = checkCriteria(tCurrent_, true);
    if (!criteriaChecked) {
      if (timeline_) {
        addEvent(DYNTimeline(CriteriaNotChecked));
      }
      if (!isSimulationDiverging) {
        throw DYNError(Error::SIMULATION, CriteriaNotChecked);
      }
    }
  }
}

bool
Simulation::checkCriteria(const double t, const bool finalStep) const {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("Simulation::checkCriteria()");
#endif
  constexpr bool filterForCriteriaCheck = true;
  data_->updateFromModel(filterForCriteriaCheck);
  const bool criteriaChecked = data_->checkCriteria(t, finalStep);
  return criteriaChecked;
}


void
Simulation::getFailingCriteria(std::vector<std::pair<double, std::string> >& failingCriteria) const {
  if (data_)
    data_->getFailingCriteria(failingCriteria);
}

void
Simulation::updateParametersValues() const {
  if (exportCurvesMode_ == EXPORT_CURVES_NONE)
    return;

  for (const auto& curve : curvesCollection_->getCurves()) {
    if (curve->isParameterCurve()) {   // if a parameter curve
      string curveModelName(curve->getModelName());
      string curveVariable(curve->getVariable());

      double value;
      bool found(false);

      model_->getModelParameterValue(curveModelName, curveVariable, value, found);   // get value

      if (found)
        curve->updateParameterCurveValue(curveVariable, value);   // update value
    }
  }
}

void
Simulation::updateCurves(const bool updateCalculatedVariable) const {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("Simulation::updateCurves()");
#endif
  if (exportCurvesMode_ == EXPORT_CURVES_NONE && exportFinalStateValuesMode_ == EXPORT_FINAL_STATE_VALUES_NONE)
    return;

  if (updateCalculatedVariable)
    model_->updateCalculatedVarForCurves();

  curvesCollection_->updateCurves(tCurrent_);
}

void
Simulation::printSolverHeader() const {
  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;
  Trace::info() << DYNLog(SimulationStart, solver_->solverType()) << Trace::endline;
  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;
  solver_->printHeader();
}

void
Simulation::addEvent(const MessageTimeline& messageTimeline) const {
  if (timeline_) {
    const string name = "Simulation";
    timeline_->addEvent(getCurrentTime(), name, messageTimeline.str(), messageTimeline.priority(), messageTimeline.getKey());
  }
}

void
Simulation::printHighestDerivativesValues() const {
  if (!Trace::logExists("", DEBUG)) return;
  const vector<double>& deriv = solver_->getCurrentYP();
  vector<std::pair<double, int> > derivValues;
  for (size_t i = 0, iEnd = deriv.size(); i < iEnd; ++i)
    derivValues.emplace_back(deriv[i], static_cast<int>(i));

  std::sort(derivValues.begin(), derivValues.end(), mapcompabs());

  const unsigned nbDeriv = std::min(10, model_->sizeY());
  Trace::debug() << DYNLog(SolverLargestDeriv, nbDeriv) << Trace::endline;
  for (size_t i = 0; i < nbDeriv; ++i) {
    Trace::debug() << DYNLog(SolverLargestDerivValue, derivValues[i].second, derivValues[i].first,
                             model_->getVariableName(derivValues[i].second)) << Trace::endline;
  }
}

void
Simulation::printEnd() const {
  solver_->printEnd();
}

void
Simulation::setCriteriaStep(const int step) {
  if (step <= 0)
    throw DYNError(Error::API, CriteriaStepError, step);
  criteriaStep_ = step;
}

void
Simulation::terminate() {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("Simulation::terminate()");
#endif
  updateParametersValues();   // update parameter curves' value

  if (!curvesOutputFile_.empty()) {
    ofstream fileCurves;
    openFileStream(fileCurves, curvesOutputFile_);
    printCurves(fileCurves);
    fileCurves.close();
  }

  if (!finalStateValuesOutputFile_.empty()) {
    ofstream fileFinalStateValues;
    openFileStream(fileFinalStateValues, finalStateValuesOutputFile_);
    printFinalStateValues(fileFinalStateValues);
    fileFinalStateValues.close();
  }

  if (!timelineOutputFile_.empty()) {
    ofstream fileTimeline;
    openFileStream(fileTimeline, timelineOutputFile_);
    printTimeline(fileTimeline);
    fileTimeline.close();
  }

  if (!constraintsOutputFile_.empty()) {
    ofstream fileConstraints;
    openFileStream(fileConstraints, constraintsOutputFile_);
    printConstraints(fileConstraints);
    fileConstraints.close();
  }

  if (dumpFinalValues_) {
    string finalValuesDir = createAbsolutePath("finalValues", outputsDirectory_);
    if (!exists(finalValuesDir))
      createDirectory(finalValuesDir);
    model_->printModelValues(finalValuesDir, "dumpFinalValues");
  }

  if (data_ && (finalState_.iidmFile_ || isLostEquipmentsExported())) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
    Timer timer2("DataInterfaceIIDM::exportStateVariables");
#endif
    data_->exportStateVariables();
  }

  if (data_ && isLostEquipmentsExported() && !lostEquipmentsOutputFile_.empty()) {
    ofstream fileLostEquipments;
    openFileStream(fileLostEquipments, lostEquipmentsOutputFile_);
    printLostEquipments(fileLostEquipments);
    fileLostEquipments.close();
  }

  if (finalState_.dumpFile_)
    dumpState();

  if (finalState_.iidmFile_)
    dumpIIDMFile();

  printEnd();
  if (wasLoggingEnabled_ && !Trace::isLoggingEnabled()) {
    // re-enable logging for upper project
    Trace::enableLogging();
  }
}

void
Simulation::openFileStream(ofstream& stream, const std::string& path) const {
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

void Simulation::printFinalStateValues(std::ostream& stream) const {
  if (exportFinalStateValuesMode_ != EXPORT_FINAL_STATE_VALUES_NONE) {
    stringstream pid_string;
    pid_string << pid_;

    boost::shared_ptr<FinalStateValuesCollection> finalStateValuesCollection =
      FinalStateValuesCollectionFactory::newInstance("Simulation_" + pid_string.str());

    for (const auto& curve : curvesCollection_->getCurves()) {
      const bool isFinalStateValue =
        curve->getExportType() == curves::Curve::EXPORT_AS_FINAL_STATE_VALUE ||
        curve->getExportType() == curves::Curve::EXPORT_AS_BOTH;
      if (curve->getAvailable() && isFinalStateValue) {
        const auto& lastPoint = curve->getPoints().back();
        std::unique_ptr<finalStateValues::FinalStateValue> finalStateValue = finalStateValues::FinalStateValueFactory::newFinalStateValue();
        finalStateValue->setModelName(curve->getModelName());
        finalStateValue->setVariable(curve->getVariable());
        finalStateValue->setValue(lastPoint->getValue());
        finalStateValuesCollection->add(std::move(finalStateValue));
      }
    }

    switch (exportFinalStateValuesMode_) {
      case EXPORT_FINAL_STATE_VALUES_XML: {
          finalStateValues::XmlExporter xmlExporter;
          xmlExporter.exportToStream(finalStateValuesCollection, stream);
          break;
        }
      case EXPORT_FINAL_STATE_VALUES_CSV: {
          finalStateValues::CsvExporter csvExporter;
          csvExporter.exportToStream(finalStateValuesCollection, stream);
          break;
        }
      case EXPORT_FINAL_STATE_VALUES_TXT: {
          finalStateValues::TxtExporter txtExporter;
          txtExporter.exportToStream(finalStateValuesCollection, stream);
          break;
        }
      case EXPORT_FINAL_STATE_VALUES_NONE:
        break;
    }
  }
}

void
Simulation::printTimeline(std::ostream& stream) const {
  if (filterTimeline_) {
    DYN::IoDicos& dicos = DYN::IoDicos::instance();
    const auto& oeDico = dicos.mergeOppositeEventsDicos();
    timeline_->filter(oeDico);
  }
  switch (exportTimelineMode_) {
    case EXPORT_TIMELINE_NONE:
      break;
    case EXPORT_TIMELINE_CSV: {
      timeline::CsvExporter exporter;
      exporter.setExportWithTime(exportTimelineWithTime_);
      exporter.setMaxPriority(exportTimelineMaxPriority_);
      exporter.exportToStream(timeline_, stream);
      break;
    }
    case EXPORT_TIMELINE_XML: {
      timeline::XmlExporter exporter;
      exporter.setExportWithTime(exportTimelineWithTime_);
      exporter.setMaxPriority(exportTimelineMaxPriority_);
      exporter.exportToStream(timeline_, stream);
      break;
    }
    case EXPORT_TIMELINE_TXT: {
      timeline::TxtExporter exporter;
      exporter.setExportWithTime(exportTimelineWithTime_);
      exporter.setMaxPriority(exportTimelineMaxPriority_);
      exporter.exportToStream(timeline_, stream);
      break;
    }
  }
}

void
Simulation::printConstraints(std::ostream& stream) const {
  if (!constraintsCollection_) return;
  constraintsCollection_->filter(jobEntry_->getOutputsEntry()->getConstraintsEntry()->getFilterType());

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
Simulation::printLostEquipments(std::ostream& stream) const {
  switch (exportLostEquipmentsMode_) {
    case EXPORT_LOSTEQUIPMENTS_NONE:
      break;
    case EXPORT_LOSTEQUIPMENTS_XML: {
      lostEquipments::XmlExporter xmlExporter;
      xmlExporter.exportToStream(data_->findLostEquipments(connectedComponents_), stream);
      break;
    }
  }
}

void
Simulation::dumpIIDMFile(const boost::filesystem::path& iidmFile) const {
  if (data_)
    data_->dumpToFile(iidmFile.generic_string());
}

void
Simulation::dumpIIDMFile(std::stringstream& stream) const {
  if (data_ && finalState_.iidmFile_)
    data_->dumpToFile(stream);
}

void
Simulation::dumpIIDMFile() {
  if (finalState_.iidmFile_)
    dumpIIDMFile(*finalState_.iidmFile_);
}

void
Simulation::dumpState() {
  if (finalState_.dumpFile_)
    dumpState(*finalState_.dumpFile_);
}

void
Simulation::dumpState(const boost::filesystem::path& dumpFile) const {
  if (!model_) return;
  stringstream state;
  boost::archive::binary_oarchive os(state);

  os << tCurrent_;
  os << solver_->getName();
  os << solver_->getTimeStep();

  map<string, string> mapValues;  // map associating file name with parameters/variables to dump
  mapValues[TIME_FILENAME] = state.str();

  model_->dumpParameters(mapValues);
  model_->dumpVariables(mapValues);

  boost::shared_ptr<zip::ZipFile> archive = zip::ZipFileFactory::newInstance();

  for (const auto& mapValue : mapValues) {
    archive->addEntry(mapValue.first, mapValue.second);
  }
  zip::ZipOutputStream::write(dumpFile.generic_string(), archive);
}

double
Simulation::loadState(const string& fileName) {
  boost::shared_ptr<zip::ZipFile> archive = zip::ZipInputStream::read(fileName);
  map<string, string> mapValues;  // map associating file name with parameters/variables to dumpe
  for (const auto& entryPair : archive->getEntries()) {
    string name = entryPair.first;
    string data(entryPair.second->getData());
    mapValues[name] = data;
  }

  auto iter = mapValues.find(TIME_FILENAME);
  if (iter == mapValues.end())
    throw DYNError(Error::GENERAL, IncompleteDump);

  stringstream state(iter->second);
  boost::archive::binary_iarchive is(state);

  double tCurrent = 0.;
  double timeStep = 0.;
  std::string solverName;
  is >> tCurrent;
  is >> solverName;
  is >> timeStep;
  // loading information
  tCurrent_ = tCurrent;

  model_->setInitialTime(tCurrent_);
  if (solver_->getName() == solverName) {
    solver_->setInitStep(timeStep);
  }

  solver_->setStartFromDump(true);

  // loading parameters/model variables
  model_->loadParameters(mapValues);
  model_->loadVariables(mapValues);
  return tCurrent_;
}

void
Simulation::printCurrentTime(const string& fileName) const {
  ofstream out(fileName.c_str());
  out << tCurrent_;
  out.close();
  fs::permissions(fileName, fs::group_read | fs::group_write | fs::owner_write | fs::others_write | fs::owner_read | fs::others_read);
}

Simulation::ExportStateDefinition::ExportStateDefinition(const double timestamp,
      boost::optional<boost::filesystem::path> dumpFile,
      boost::optional<boost::filesystem::path> iidmFile):
  timestamp_(timestamp),
  dumpFile_(std::move(dumpFile)),
  iidmFile_(std::move(iidmFile)) {
}

}  // end of namespace DYN
