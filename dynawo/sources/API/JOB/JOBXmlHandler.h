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
 * @file JOBXmlHandler.h
 * @brief Handler for jobs file header
 *
 * XmlHandler is the implementation of Dynawo handler for parsing jobs
 * files.
 */
#ifndef API_JOB_JOBXMLHANDLER_H_
#define API_JOB_JOBXMLHANDLER_H_

#include "DYNFileSystemUtils.h"
#include "JOBAppenderEntry.h"
#include "JOBConstraintsEntry.h"
#include "JOBCurvesEntry.h"
#include "JOBDynModelsEntry.h"
#include "JOBFinalStateEntry.h"
#include "JOBInitValuesEntry.h"
#include "JOBInitialStateEntry.h"
#include "JOBFinalValuesEntry.h"
#include "JOBJobEntry.h"
#include "JOBJobsCollection.h"
#include "JOBLogsEntry.h"
#include "JOBLostEquipmentsEntry.h"
#include "JOBModelerEntry.h"
#include "JOBModelsDirEntry.h"
#include "JOBNetworkEntry.h"
#include "JOBOutputsEntry.h"
#include "JOBSimulationEntry.h"
#include "JOBSolverEntry.h"
#include "JOBTimelineEntry.h"
#include "JOBTimetableEntry.h"
#include "JOBLocalInitEntry.h"

#include <boost/shared_ptr.hpp>
#include <string>
#include <vector>
#include <xml/sax/parser/ComposableDocumentHandler.h>
#include <xml/sax/parser/ComposableElementHandler.h>

namespace job {

/**
 * @class AppenderHandler
 * @brief Handler used to parse appender element
 */
class AppenderHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit AppenderHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~AppenderHandler();

  /**
   * @brief return the appender read in xml file
   * @return appender object build thanks to infos read in xml file
   */
  boost::shared_ptr<AppenderEntry> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<AppenderEntry> appender_;  ///< current appender
};

/**
 * @class DirectoryHandler
 * @brief Handler used to parse directory element
 */
class DirectoryHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit DirectoryHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~DirectoryHandler();

  /**
   * @brief return the directory read in xml file
   * @return directory object build thanks to infos read in xml file
   */
  UserDefinedDirectory get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  UserDefinedDirectory dir_;  ///< current directory
};

/**
 * @class ModelsDirHandler
 * @brief Handler used to parse models directory element
 */
class ModelsDirHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit ModelsDirHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~ModelsDirHandler();

  /**
   * @brief add a directory to the list of directory
   */
  void addDirectory();

  /**
   * @brief  get the models objects read in xml file
   * @return models objects build thanks to infos read in xml file
   */
  boost::shared_ptr<ModelsDirEntry> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<ModelsDirEntry> modelsDir_;  ///< current modelsDirEntry object
  DirectoryHandler directoryHandler_;            ///< handler used to parse directory element
};

/**
 * @class InitialStateHandler
 * @brief Handler used to parse initial state element
 */
class InitialStateHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit InitialStateHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~InitialStateHandler();

  /**
   * @brief get the initial state element read in xml file
   * @return initial state object build thanks to infos read in xml file
   */
  boost::shared_ptr<InitialStateEntry> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<InitialStateEntry> initialState_;  ///< current initial state object
};

/**
 * @class DynModelsHandler
 * @brief Handler used to parse dynModels element
 */
class DynModelsHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit DynModelsHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~DynModelsHandler();

  /**
   * @brief get the dynModels objects read in xml file
   * @return dynModels objects build thanks to infos read in xml file
   */
  boost::shared_ptr<DynModelsEntry> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<DynModelsEntry> dynModels_;  ///< current dynModels object
};

/**
 * @class NetworkHandler
 * @brief Handler used to parse network element
 */
class NetworkHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit NetworkHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~NetworkHandler();

  /**
   * @brief return the network entry element read in xml file
   * @return network entry object builds thanks to infos read in xml file
   */
  boost::shared_ptr<NetworkEntry> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<NetworkEntry> network_;  ///< current network entry object
};

/**
 * @class InitValuesHandler
 * @brief Handler used to read init values element
 */
class InitValuesHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit InitValuesHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~InitValuesHandler();

  /**
   * @brief return the init values entry read in xml file
   * @return init values entry object build thanks to infos read in xml file
   */
  boost::shared_ptr<InitValuesEntry> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<InitValuesEntry> initValuesEntry_;  ///< current init values entry object
};

class FinalValuesHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit FinalValuesHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~FinalValuesHandler();

  /**
   * @brief return the final values entry read in xml file
   * @return final values entry object build thanks to infos read in xml file
   */
  boost::shared_ptr<FinalValuesEntry> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<FinalValuesEntry> finalValuesEntry_;  ///< current final values entry object
};

/**
 * @class ConstraintsHandler
 * @brief Handler used to parse constraints element
 */
class ConstraintsHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit ConstraintsHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~ConstraintsHandler();

  /**
   * @brief return the constraints entry read in xml file
   * @return constraints entry object build thanks to infos read in xml file
   */
  boost::shared_ptr<ConstraintsEntry> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<ConstraintsEntry> constraints_;  ///< current constraints entry object
};

/**
 * @class TimelineHandler
 * @brief Handler used to parse timeline element
 */
class TimelineHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit TimelineHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~TimelineHandler();

  /**
   * @brief return the timeline entry read in xml file
   * @return timeline entry object build thanks to infos read in xml file
   */
  boost::shared_ptr<TimelineEntry> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<TimelineEntry> timeline_;  ///< current timeline entry object
};

/**
 * @class TimetableHandler
 * @brief Handler used to parse timetable element
 */
class TimetableHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit TimetableHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~TimetableHandler();

  /**
   * @brief return the timetable entry read in xml file
   * @return timetable entry object build thanks to infos read in xml file
   */
  boost::shared_ptr<TimetableEntry> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<TimetableEntry> timetable_;  ///< current timetable entry object
};

/**
 * @class FinalStateHandler
 * @brief Handler used to parse final state element
 */
class FinalStateHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit FinalStateHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~FinalStateHandler();

  /**
   * @brief return the final state entry read in xml file
   * @return final state entry object build thanks to infos read in xml file
   */
  boost::shared_ptr<FinalStateEntry> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<FinalStateEntry> finalState_;  ///< current final state entry object
};

/**
 * @class CurvesHandler
 * @brief Handler used to parse curves element
 */
class CurvesHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit CurvesHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~CurvesHandler();

  /**
   * @brief return the curves entry read in xml file
   * @return curves entry object build thanks to infos read in xml file
   */
  boost::shared_ptr<CurvesEntry> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<CurvesEntry> curves_;  ///< current curves entry object
};

/**
 * @class FinalStateValuesHandler
 * @brief Handler used to parse curves element
 */
class FinalStateValuesHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit FinalStateValuesHandler(elementName_type const& root_element);

  /**
   * @brief default destructor
   */
  ~FinalStateValuesHandler();

  /**
   * @brief return the final state values entry read in xml file
   * @return Final state values entry object built from the info read in xml file
   */
  boost::shared_ptr<FinalStateValuesEntry> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<FinalStateValuesEntry> finalStateValues_;  ///< current final state values entry object
};

/**
 * @class LostEquipmentsHandler
 * @brief Handler used to parse lostEquipments element
 */
class LostEquipmentsHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit LostEquipmentsHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~LostEquipmentsHandler();

  /**
   * @brief return the lostEquipments entry read in xml file
   * @return curves entry object build thanks to infos read in xml file
   */
  boost::shared_ptr<LostEquipmentsEntry> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<LostEquipmentsEntry> lostEquipments_;  ///< current lostEquipments entry object
};

/**
 * @class LogsHandler
 * @brief Handler used to parse logs element
 */
class LogsHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit LogsHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~LogsHandler();

  /**
   * @brief return the logs entry read in xml file
   * @return logs entry object build thanks to infos read in xml file
   */
  boost::shared_ptr<LogsEntry> get() const;

  /**
   * @brief add an appender in logs object
   */
  void addAppender();

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<LogsEntry> logs_;  ///< current logs entry object
  AppenderHandler appenderHandler_;    ///< handler used to read appender element
};

/**
 * @class OutputsHandler
 * @brief Handler used to read outputs element
 */
class OutputsHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit OutputsHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~OutputsHandler();

  /**
   * @brief return the outputs entry read in xml file
   * @return outputs entry object build thanks to infos read in xml file
   */
  boost::shared_ptr<OutputsEntry> get() const;

  /**
   * @brief add an init values object to the current job
   */
  void addInitValuesEntry();

  /**
   * @brief add a final values object to the current job
   */
  void addFinalValuesEntry();

  /**
   * @brief add a constraints object to the current job
   */
  void addConstraints();

  /**
   * @brief add a timeline object to the current job
   */
  void addTimeline();

  /**
   * @brief add a timetable object to the current job
   */
  void addTimetable();

  /**
   * @brief add a finalState object to the current job
   */
  void addFinalState();

  /**
   * @brief add a curves object to the current job
   */
  void addCurves();

  /**
   * @brief add a finalstatevalues object to the current job
   */
  void addFinalStateValues();

  /**
   * @brief add a lostEquipments object to the current job
   */
  void addLostEquipments();

  /**
   * @brief add a log object to the current job
   */
  void addLog();

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<OutputsEntry> outputs_;          ///< current outputs entry object
  InitValuesHandler initValuesHandler_;              ///< handler used to read init values element
  FinalValuesHandler finalValuesHandler_;            ///< handler used to read final values element
  ConstraintsHandler constraintsHandler_;            ///< handler used to read constraints element
  TimelineHandler timelineHandler_;                  ///< handler used to read timeline element
  TimetableHandler timetableHandler_;                ///< handler used to read timetable element
  FinalStateHandler finalStateHandler_;              ///< handler used to read finalState element
  CurvesHandler curvesHandler_;                      ///< handler used to read curves element
  FinalStateValuesHandler finalStateValuesHandler_;  ///< handler used to read finalStateValues element
  LostEquipmentsHandler lostEquipmentsHandler_;      ///< handler used to read curves element
  LogsHandler logsHandler_;                          ///< handler used to read logs element
};

/**
 * @class CriteriaFileHandler
 * @brief Handler used to parse criteriaFile element
 */
class CriteriaFileHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit CriteriaFileHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~CriteriaFileHandler();

  /**
   * @brief return the simulation entry read in xml file
   * @return simulation entry object build thanks to infos read in xml file
   */
  const std::string& get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  std::string criteriaFile_;  ///< current simulation entry object
};

/**
 * @class SimulationHandler
 * @brief Handler used to parse simulation element
 */
class SimulationHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit SimulationHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~SimulationHandler();

  /**
   * @brief return the simulation entry read in xml file
   * @return simulation entry object build thanks to infos read in xml file
   */
  boost::shared_ptr<SimulationEntry> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

  /**
   * @brief add a criteria file to the simulation
   */
  void addCriteriaFile();

 private:
  boost::shared_ptr<SimulationEntry> simulation_;  ///< current simulation entry object
  CriteriaFileHandler criteriaFileHandler_;        ///< handler used to read criteriaFiles element
};

/**
 * @class ModelerHandler
 * @brief Handler used to parse modeler element
 */
class ModelerHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit ModelerHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~ModelerHandler();

  /**
   * @brief return the modeler entry read in xml file
   * @return modeler entry object build thanks to infos read in xml file
   */
  boost::shared_ptr<ModelerEntry> get() const;

  /**
   * @brief add a modelica model object to the modeler entry
   */
  void addModelicaModel();

  /**
   * @brief add a precompiled model object to the modeler entry
   */
  void addPreCompiledModels();

  /**
   * @brief add an initial state object to the modeler entry
   */
  void addInitialState();

  /**
   * @brief add a dynamic model object to the modeler entry
   */
  void addDynModel();

  /**
   * @brief add a network object to the modeler entry
   */
  void addNetwork();

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<ModelerEntry> modeler_;    ///< current modeler object
  NetworkHandler networkHandler_;              ///< handler used to read network element
  DynModelsHandler dynModelsHandler_;          ///< handler used to read dynModels element
  InitialStateHandler initialStateHandler_;    ///< handler used to read initial state element
  ModelsDirHandler preCompiledModelsHandler_;  ///< handler used to read precompiled models element
  ModelsDirHandler modelicaModelsHandler_;     ///< handler used to read modelica models element
};

/**
 * @class SolverHandler
 * @brief Handler used to parse solver element
 */
class SolverHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit SolverHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~SolverHandler();

  /**
   * @brief return the solver entry read in xml file
   * @return solver entry object build thanks to infos read in xml file
   */
  boost::shared_ptr<SolverEntry> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<SolverEntry> solver_;  ///< current solver object
};

/**
 * @class LocalInitHandler
 * @brief Handler used to parse local init element
 */
class LocalInitHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit LocalInitHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~LocalInitHandler();

  /**
   * @brief return the local init entry read in xml file
   * @return local init entry object build thanks to infos read in xml file
   */
  boost::shared_ptr<LocalInitEntry> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<LocalInitEntry> localInit_;  ///< current local init object
};

/**
 * @class JobHandler
 * @brief Handler used to parse job element
 */
class JobHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit JobHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~JobHandler();

  /**
   * @brief return the job read in xml file
   * @return job object build thanks to infos read in xml file
   */
  boost::shared_ptr<JobEntry> get() const;

  /**
   * @brief add a solver object to the current job
   */
  void addSolver();

  /**
   * @brief add a modeler object to the current job
   */
  void addModeler();

  /**
   * @brief add a simulation object to the current job
   */
  void addSimulation();

  /**
   * @brief add an outputs object to the current job
   */
  void addOutputs();

  /**
   * @brief add a local init object to the current job
   */
  void addLocalInit();

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<JobEntry> job_;      ///< job object created by the handler
  SolverHandler solverHandler_;          ///< handler used to read solver element
  ModelerHandler modelerHandler_;        ///< handler used to read modeler element
  SimulationHandler simulationHandler_;  ///< handler used to read simulation element
  OutputsHandler outputsHandler_;        ///< handler used to read outputs element
  LocalInitHandler localInitHandler_;    ///< handler used to read local init element
};

/**
 * @class XmlHandler
 * @brief Jobs xml file handler class
 *
 * XmlHandler is the implementation of Dynawo handler for parsing jobs
 * files.
 */
class XmlHandler : public xml::sax::parser::ComposableDocumentHandler {
 public:
  /**
   * @brief Constructor
   */
  XmlHandler();

  /**
   * @brief Destructor
   */
  ~XmlHandler();

  /**
   * @brief add a job to the jobs list
   */
  void addJob();

  /**
   * @brief returns the jobs collection read in jobs file
   * @return jobs collection created thanks to the jobs file
   */
  boost::shared_ptr<JobsCollection> getJobsCollection() const;

 private:
  boost::shared_ptr<JobsCollection> jobsCollection_;  ///< jobs collection parsed
  JobHandler jobHandler_;                             ///< handler used to read job element
};

}  // namespace job

#endif  // API_JOB_JOBXMLHANDLER_H_
