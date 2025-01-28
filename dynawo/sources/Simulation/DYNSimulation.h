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
 * @file  DYNSimulation.h
 *
 * @brief Simulation header
 *
 */
#ifndef SIMULATION_DYNSIMULATION_H_
#define SIMULATION_DYNSIMULATION_H_

#include <vector>
#include <queue>
#include <unordered_map>
#include <boost/shared_ptr.hpp>
#include <boost/optional.hpp>
#include <boost/filesystem.hpp>

#ifdef _MSC_VER
  typedef int pid_t;
#endif

#include "DYNSignalHandler.h"
#include "PARParametersSetCollection.h"
#include "DYNDataInterface.h"
#include "DYNSolverFactory.h"

namespace timeline {
class Timeline;
}

namespace curves {
class CurvesCollection;
}

namespace constraints {
class ConstraintsCollection;
}

namespace job {
class JobEntry;
}

namespace criteria {
class CriteriaCollection;
}

namespace DYN {
class Message;
class MessageTimeline;
class Model;
class Solver;
class DynamicData;
class DataInterface;
class SimulationContext;

/**
 * @brief Simulation class
 *
 * Simulation class is the entry point for Dynawo simulations. It is
 * responsible for setting solver parameters and for controlling
 * simulation time exchanges between the model and the solver
 */
class Simulation {
 public:
  /**
   * @brief Export mode for curves
   * Curves' export mode controlling the curves available in the output.
   */
  typedef enum {
    EXPORT_CURVES_NONE,  ///< Export zero curves
    EXPORT_CURVES_XML,  ///< Export curves selected in input file in XML mode in output file
    EXPORT_CURVES_CSV  ///< Export curves selected in input file in CSV mode in output file
  } exportCurvesMode_t;

  /**
   * @brief Export mode for final states values
   * Final states' export mode controlling the final states values available in the output.
   */
  typedef enum {
    EXPORT_FINAL_STATE_VALUES_NONE,  ///< Export zero final states values
    EXPORT_FINAL_STATE_VALUES_XML,   ///< Export final states values selected in input file in XML mode in output file
    EXPORT_FINAL_STATE_VALUES_CSV,   ///< Export final states values selected in input file in CSV mode in output file
    EXPORT_FINAL_STATE_VALUES_TXT    ///< Export final states values selected in input file in TXT mode in output file
  } exportFinalStateValuesMode_t;

  /**
   * @brief Export mode for timeline
   * Timeline's export mode controlling the format of the timeline's output file
   */
  typedef enum {
    EXPORT_TIMELINE_NONE,  ///< No export timeline
    EXPORT_TIMELINE_TXT,  ///< Export timeline in txt mode in output file
    EXPORT_TIMELINE_CSV,  ///< Export timeline in csv mode in output file
    EXPORT_TIMELINE_XML  ///< Export timeline in xml mode in output file
  } exportTimelineMode_t;

  /**
   * @brief Export mode for constraint's state
   * constraint's state export mode controlling the format of the constraint's output file
   */
  typedef enum {
    EXPORT_CONSTRAINTS_NONE,  ///< Export no constraints
    EXPORT_CONSTRAINTS_XML,  ///< Export constraints in xml mode in output file
    EXPORT_CONSTRAINTS_TXT  ///< Export constraints in txt mode in output file
  } exportConstraintsMode_t;

  /**
   * @brief Export mode for lostEquipments
   * lostEquipments' export mode controlling the format of the lostEquipments' output file
   */
  typedef enum {
    EXPORT_LOSTEQUIPMENTS_NONE,  ///< Export no lost equipments
    EXPORT_LOSTEQUIPMENTS_XML  ///< Export lost equipments found in XML mode in output file
  } exportLostEquipmentsMode_t;

  /**
   * @brief definition of dump to export
   *
   */
  struct ExportStateDefinition {
    /**
     * @brief Constructor
     *
     * @param timestamp Timestamp of the export
     * @param dumpFile Path of the dump
     * @param iidmFile Path of the IIDM
     */
    ExportStateDefinition(double timestamp,
      boost::optional<boost::filesystem::path> dumpFile = boost::none,
      boost::optional<boost::filesystem::path> iidmFile = boost::none);

    double timestamp_;                                   ///< Timestamp of the export (can be max for final state)
    boost::optional<boost::filesystem::path> dumpFile_;  ///< Path of the dump state file, if requested
    boost::optional<boost::filesystem::path> iidmFile_;  ///< Path of the IIDM export file, if requested
  };

 public:
  /**
   * @brief default constructor
   *
   * @param jobEntry data read in jobs file
   * @param context context of the simulation (configuration, directories, locale, etc...)
   * @param data data interface to use for the simulation (NULL if we build it inside simulation)
   */
  Simulation(boost::shared_ptr<job::JobEntry>& jobEntry, boost::shared_ptr<SimulationContext>& context,
              boost::shared_ptr<DataInterface> data = boost::shared_ptr<DataInterface>());

  /**
   * @brief initialize the simulation
   */
  void init();

  /**
   * @brief calculate the initial conditions of the simulation
   */
  void calculateIC();

  /**
   * @brief initialize the buffers uses by the model
   */
  void initStructure();

  /**
   * @brief initialize the whole system with respect to the input "static/dynamic" data
   * @param data input "static" data
   * @param dyd input "dynamic" data
   */
  void initFromData(const boost::shared_ptr<DataInterface>& data, const boost::shared_ptr<DynamicData>& dyd);

  /**
   * @brief launch the simulation
   */
  void simulate();

  /**
   * @brief destroy all allocated objected during the simulation
   */
  void clean();

  /**
   * @brief routine to run when the simulation ends with an error
   * @param criteria true if we want to check one last time the criteria
   * @param isSimulationDiverging true if the simulation diverges, false otherwise
   */
  void endSimulationWithError(bool criteria, bool isSimulationDiverging = false);

  /**
   * @brief print the header information of the solver used
   */
  void printSolverHeader();

  /**
   * @brief print the statistics of the solver
   */
  void printEnd();

  /**
   * @brief load a previous state
   * @param fileName name of file where the dump is stored
   * @return the last time stored in the dump state
   */
  double loadState(const std::string& fileName);

  /**
   * @brief store a simulation state in a file
   */
  void dumpState();

  /**
   * @brief dump the final state of the network in a IIDM file
   */
  void dumpIIDMFile();

  /**
   * @brief store a simulation state in a file
   * @param dumpFile the dump file to export to
   */
  void dumpState(const boost::filesystem::path& dumpFile);

  /**
   * @brief dump the final state of the network in a IIDM file
   * @param iidmFile the iidm to export to
   */
  void dumpIIDMFile(const boost::filesystem::path& iidmFile);

  /**
   * @brief dump the final state of the network in a stream
   * @param stream the stream to export to
   */
  void dumpIIDMFile(std::stringstream& stream) const;

  /**
   * @brief import curves request from a file (i.e. curves that the user wants to plot)
   * @warning the file should be set before the call of this method
   */
  void importCurvesRequest();

  /**
   * @brief import final state values request from a file (i.e. final states values that the user wants to see)
   * @warning the file should be set before the call of this method
   */
  void importFinalStateValuesRequest();

  /**
   * @brief setter for the output file of the timeline
   * @param outputFile timeline's output file
   */
  inline void setTimelineOutputFile(const std::string& outputFile) {
    timelineOutputFile_ = outputFile;
  }

  /**
   * @brief getter for the output file of the timeline
   * @return outputFile timeline's output file
   */
  inline const std::string& getTimelineOutputFile() {
    return timelineOutputFile_;
  }

  /**
   * @brief setter for the export mode of the timeline
   * @param mode timeline's mode export
   */
  inline void setTimelineExportMode(const exportTimelineMode_t& mode) {
    exportTimelineMode_ = mode;
  }

  /**
   * @brief setter for the export mode of curves
   * @param mode curves' export mode
   */
  inline void setCurvesExportMode(const exportCurvesMode_t& mode) {
    exportCurvesMode_ = mode;
  }

  /**
   * @brief setter for the curves input file
   * @param inputFile input file of curves request
   */
  inline void setCurvesInputFile(const std::string& inputFile) {
    curvesInputFile_ = inputFile;
  }

  /**
   * @brief setter for the curves' output file
   * @param outputFile curves' output file
   */
  inline void setCurvesOutputFile(const std::string& outputFile) {
    curvesOutputFile_ = outputFile;
  }

  /**
   * @brief setter for the export mode of final state values
   * @param mode final state values' export mode
   */
  inline void setFinalStateValuesExportMode(const exportFinalStateValuesMode_t& mode) {
    exportFinalStateValuesMode_ = mode;
  }

  /**
   * @brief setter for the final state values' input file
   * @param inputFile final state values input file
   */
  inline void setFinalStateValuesInputFile(const std::string& inputFile) {
    finalStateValuesInputFile_ = inputFile;
  }

  /**
   * @brief setter for the final state values' output file
   * @param outputFile final state values' output file
   */
  inline void setFinalStateValuesOutputFile(const std::string& outputFile) {
    finalStateValuesOutputFile_ = outputFile;
  }

  /**
   * @brief setter for the constraints' output file
   * @param outputFile constraints' output file
   */
  inline void setConstraintsOutputFile(const std::string& outputFile) {
    constraintsOutputFile_ = outputFile;
  }

  /**
   * @brief getter for the constraints' output file
   * @return constraints' output file
   */
  inline const std::string& getContraintsOutputFile() const {
    return constraintsOutputFile_;
  }

  /**
   * @brief setter for the constraints' export mode
   * @param mode constraints' export mode
   */
  inline void setConstraintsExportMode(const exportConstraintsMode_t& mode) {
    exportConstraintsMode_ = mode;
  }

  /**
   * @brief setter for the lost equipments' output file
   * @param outputFile lost equipments' output file
   */
  inline void setLostEquipmentsOutputFile(const std::string& outputFile) {
    lostEquipmentsOutputFile_ = outputFile;
  }

  /**
   * @brief getter for the lost equipments' output file
   * @return lost equipments' output file
   */
  inline const std::string& getLostEquipmentsOutputFile() const {
    return lostEquipmentsOutputFile_;
  }

  /**
   * @brief setter for the lost equipments' export mode
   * @param mode lost equipments' export mode
   */
  inline void setLostEquipmentsExportMode(const exportLostEquipmentsMode_t& mode) {
    exportLostEquipmentsMode_ = mode;
  }

  /**
   * @brief Checks if lost equipments should be exported
   * @return whether lost equipments should be exported
   */
  inline bool isLostEquipmentsExported() const {
    return exportLostEquipmentsMode_ != EXPORT_LOSTEQUIPMENTS_NONE;
  }

  /**
   * @brief setter for local init values dump mode
   * @param dumpLocalInitValues @b true if local init values should be dumped
   * local init values are the values calculated by the init algorithm for each models, one by one
   */
  inline void setDumpLocalInitValues(const bool dumpLocalInitValues) {
    dumpLocalInitValues_ = dumpLocalInitValues;
  }

  /**
   * @brief setter for init model values dump mode
   * @param dumpInitModelValues @b true if init model values should be dumped
   */
  inline void setDumpInitModelValues(const bool dumpInitModelValues) {
    dumpInitModelValues_ = dumpInitModelValues;
  }

  /**
   * @brief setter for global init values dump mode
   * @param dumpGlobalInitValues  @b true if global init values should be dumped
   * global init values are the values calculated by the init algorithm for each models, all models at the same time
   */
  inline void setDumpGlobalInitValues(const bool dumpGlobalInitValues) {
    dumpGlobalInitValues_ = dumpGlobalInitValues;
  }

  /**
   * @brief setter for final values dump mode
   * @param dumpFinalValues  @b true if final values should be dumped
   * final values are the values of each models at the end of the simulation
   */
  inline void setDumpFinalValues(const bool dumpFinalValues) {
    dumpFinalValues_ = dumpFinalValues;
  }

  /**
   * @brief indicates if the simulation has reached the stop time
   * @return @b true if current time >= stop time, @b false otherwise
   */
  inline bool end() const {
    return (tCurrent_ >= tStop_);
  }

  /**
   * @brief setter of the start time of the simulation
   * @param time start time of the simulation
   */
  inline void setStartTime(const double time) {
    tStart_ = time;
  }

  /**
   * @brief setter of the stop time of the simulation
   * @param time stop time of the simulation
   */
  inline void setStopTime(const double time) {
    tStop_ = time;
  }

  /**
   * @brief setter for activating the checking of criteria (minimal voltage, etc..)
   * @param activate @b true if checking of criteria should be activated during simulation
   */
  inline void setActivateCriteria(bool activate) {
    activateCriteria_ = activate;
  }

  /**
   * @brief setter for criteria step
   * @param step number of iterations between 2 criteria check
   */
  void setCriteriaStep(const int step);

  /**
   * @brief getter for the start time of the simulation
   * @return the start time of the simulation
   */
  inline double getStartTime() const {
    return tStart_;
  }

  /**
   * @brief getter for the current time of the simulation
   * @return the current time of the simulation
   */
  inline double getCurrentTime() const {
    return tCurrent_;
  }

  /**
   * @brief setter for the final state dump output file
   * @param file final state dump output file
   */
  inline void setDumpFinalStateFile(const std::string& file) {
    finalState_.dumpFile_ = file;
  }

  /**
   * @brief setter for the final state IIDM output file
   * @param file final state IIDM output file
   */
  inline void setExportIIDMFile(const std::string& file) {
    finalState_.iidmFile_ = file;
  }

  /**
   * @brief getter for the final state IIDM output file
   * @return final state IIDM output file
   */
  inline const boost::optional<boost::filesystem::path>& getExportIIDMFile() const {
    return finalState_.iidmFile_;
  }

  /**
   * @brief disable IIDM export for final state
   */
  inline void disableExportIIDM() {
    finalState_.iidmFile_.reset();
  }

  /**
   * @brief disable dump export for final state
   */
  inline void disableDumpFinalState() {
    finalState_.dumpFile_.reset();
  }

  /**
   * @brief setter for the initial state file to load
   * @param file initial state file
   */
  inline void setInitialStateFile(const std::string& file) {
    initialStateFile_ = file;
  }

  /**
   * @brief setter for the input iidm file
   * @param file input iidm file
   */
  inline void setIIDMFile(const std::string& file) {
    iidmFile_ = file;
  }

  /**
   * @brief end the simulation : export data, curves,...
   */
  void terminate();

  /**
   * @brief print curves output of the simulation in the given stream
   * @param stream stream where the curves output should be printed
   */
  void printCurves(std::ostream& stream) const;

  /**
   * @brief print final state values of the simulation in the given stream
   * @param stream stream where the final state values should be printed
   */
  void printFinalStateValues(std::ostream& stream) const;

  /**
   * @brief print timeline output of the simulation in the given stream
   * @param stream stream where the timeline output should be printed
   */
  void printTimeline(std::ostream& stream) const;

  /**
   * @brief print constraints output of the simulation in the given stream
   * @param stream stream where the constraints output should be printed
   */
  void printConstraints(std::ostream& stream) const;

  /**
   * @brief print finalState output of the simulation in the given stream
   * @param stream stream where the finalState output should be printed
   */
  void printFinalState(std::ostream& stream) const;

  /**
   * @brief print lost equipments output of the simulation in the given stream
   * @param stream stream where the lost equipments output should be printed
   */
  void printLostEquipments(std::ostream& stream) const;

  /**
   * @brief fill a vector with the ids of the failing criteria met so far
   * @param failingCriteria vector to fill
   */
  void getFailingCriteria(std::vector<std::pair<double, std::string> >& failingCriteria) const;

  /**
 * @brief get model used in simulation

 * @return model used in simulation
 */
  std::shared_ptr<Model> getModel() {
    return model_;
  }

 private:
  /**
   * @brief open a file stream
   * @param stream file stream stream to open
   * @param path path of the file
   */
  void openFileStream(std::ofstream& stream, const std::string& path);
  /**
   * @brief check if criteria are fullfilled
   *
   * @param t current time of the simulation
   * @param finalStep  @b true if this is the final step of the simulation
   * @return @b true if all criteria are fullfilled
   */
  bool checkCriteria(double t, bool finalStep);

  /**
   * @brief configure and create all appenders of the simulation
   */
  void configureLogs();

  /**
   * @brief create the solver instance to use for the simulation
   */
  void setSolver();

  /**
   * @brief load dynamic data
   */
  void loadDynamicData();

  /**
   * @brief analyze dynamic data and compile modelica models
   */
  void compileModels();

  /**
   * @brief configure the simulation outputs
   */
  void configureSimulationOutputs();

  /**
   * @brief configure the simulation inputs
   */
  void configureSimulationInputs();

  /**
   * @brief configure the criteria
   */
  void configureCriteria();

  /**
   * @brief  update the curves depending on parameters values
   * At the end of the simulation, parameter value is duplicated into curve
   */
  void updateParametersValues();

  /**
   * @brief update curves : at the end of each iteration, new points are added to curve
   * @param updateCalculateVariable @b true is calculated variables should be updated
   */
  void updateCurves(bool updateCalculateVariable = true);

  /**
   * @brief dump the current time of the simulation in a file
   * @param fileName file where the current time is dumped
   */
  void printCurrentTime(const std::string& fileName);

  /**
   * @brief add an event to the timeline
   * @param messageTimeline message to add in the timeline
   */
  void addEvent(const MessageTimeline& messageTimeline);

  /**
   * @brief dump the 10 highest derivatives values in the global log
   */
  void printHighestDerivativesValues();

  /**
   * @brief Determines whether an intermediate dump state has to be performed
   *
   * @return true if a dump must be performed, false if not
   */
  bool hasIntermediateStateToDump() const;

 private:
  boost::shared_ptr<SimulationContext> context_;  ///< simulation context : configuration of the simulation
  boost::shared_ptr<job::JobEntry> jobEntry_;  ///< jobs data description
  SolverFactory::SolverPtr solver_;  ///< solver used for the simulation
  std::shared_ptr<Model> model_;  ///< model used for the simulation
  boost::shared_ptr<DataInterface> data_;  ///< Data interface associated to the job
  boost::shared_ptr<DynamicData> dyd_;  ///< Dynamic data container associated to the job
  boost::shared_ptr<timeline::Timeline> timeline_;  ///< instance of the timeline where events are stored
  std::shared_ptr<curves::CurvesCollection> curvesCollection_;  ///< instance of curves collection where curves are stored
  std::shared_ptr<constraints::ConstraintsCollection> constraintsCollection_;  ///< instance of constraints collection where constraints are stored
  std::shared_ptr<criteria::CriteriaCollection> criteriaCollection_;  ///< instance of criteria collection where criteria are stored
  std::shared_ptr<std::vector<
          std::shared_ptr<ComponentInterface> > > connectedComponents_;  ///< instance of vector of connected components at simulation start

  std::vector<std::string> dydFiles_;  ///< list of files to used dynamic data
  std::string iidmFile_;  ///< iidm input file
  std::string networkParFile_;  ///< file containing all parameters for the network
  std::string networkParSet_;  ///< id of the set of parameters to use for the network
  std::string initialStateFile_;  ///< dump to load for each state variable
  std::unordered_map<std::string,
          std::shared_ptr<parameters::ParametersSetCollection> > referenceParameters_;  ///< association between file name and parameters collection

  std::string outputsDirectory_;  ///< directory for simulation outputs

  exportCurvesMode_t exportCurvesMode_;  ///< curves' export mode
  std::string curvesInputFile_;  ///< curves' resquest input file
  std::string curvesOutputFile_;  ///< curves' output file

  exportFinalStateValuesMode_t exportFinalStateValuesMode_;  ///< final state values export mode
  std::string finalStateValuesInputFile_;  ///< final state values input file
  std::string finalStateValuesOutputFile_;  ///< final state values output file

  exportTimelineMode_t exportTimelineMode_;  ///< timeline's output mode
  bool exportTimelineWithTime_;  ///< whether to export time when exporting timeline
  boost::optional<int> exportTimelineMaxPriority_;  ///< maximum priority when exporting timeline
  std::string timelineOutputFile_;  ///< timeline's export file
  bool filterTimeline_;  ///< whether to filter timeline

  std::string timetableOutputFile_;  ///< timetable export file
  int timetableSteps_;  ///< timetable' steps

  exportConstraintsMode_t exportConstraintsMode_;  ///< contstraints' export mode
  std::string constraintsOutputFile_;  ///< constraints' export file

  exportLostEquipmentsMode_t exportLostEquipmentsMode_;  ///< lostEquipments' export mode
  std::string lostEquipmentsOutputFile_;  ///< lost equipments' export file

  pid_t pid_;  ///< pid of the current simulation

  ExportStateDefinition finalState_;  ///< Final state definition
  std::queue<ExportStateDefinition> intermediateStates_;  ///< Queue of intermediate dump states to perform, sorted by timestamp

  double tStart_;  ///< start time of the simulation
  double tCurrent_;  ///< current time of the simulation
  double tStop_;  ///< stop time of the simulation
  bool activateCriteria_;  ///< whether to activate the verification if criteria are fullfilled
  int  criteriaStep_;  ///< if activated, this number will be the number of iterations between two criteria checks
  bool dumpLocalInitValues_;  ///< whether to export the results from the local initialisation
  bool dumpGlobalInitValues_;  ///< whether to export the results from the global initialisation
  bool dumpInitModelValues_;  ///< whether to export the results from the initialisation model
  bool dumpFinalValues_;  ///< whether to export the values of the models's variables and parameters at the end of the simulation
  std::vector<double> zCurrent_;  ///< current values of the model's discrete variables

  bool wasLoggingEnabled_;  ///< true if logging was enabled by an upper project

 private:
  /**
   * @brief configure the constraints outputs
   */
  void configureConstraintsOutputs();

  /**
   * @brief configure the timeline outputs
   */
  void configureTimelineOutputs();

  /**
   * @brief configure the timetable outputs
   */
  void configureTimetableOutputs();

  /**
   * @brief configure the curve outputs
   */
  void configureCurveOutputs();

  /**
   * @brief configure the final state outputs
   */
  void configureFinalStateValueOutputs();

  /**
   * @brief configure the final state outputs
   */
  void configureFinalStateOutputs();

  /**
   * @brief configure the lost equipments outputs
   */
  void configureLostEquipmentsOutputs();
};

}  // end of namespace DYN

#endif  // SIMULATION_DYNSIMULATION_H_
