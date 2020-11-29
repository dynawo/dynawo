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
#include <boost/shared_ptr.hpp>
#include <boost/unordered_map.hpp>

#ifdef _MSC_VER
  typedef int pid_t;
#endif

#include "DYNSignalHandler.h"
#include "PARParametersSetCollection.h"

namespace timeline {
class Timeline;
}
namespace linearise {
class Linearise;
}
namespace modalanalysis {
class ModalAnalysis;
}
namespace allmodes {
class AllModes;
}
namespace subparticipation {
class SubParticipation;
}
namespace curves {
class CurvesCollection;
}

namespace finalState {
class FinalStateCollection;
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
   * @brief Export mode for linearization
   * Linearise's export mode controlling the format of the linearise's output file
   */
  typedef enum {
    EXPORT_LINEARISE_NONE,  ///< No export linearise
    EXPORT_LINEARISE_TXT,  ///< Export linearise in txt mode in output file
    EXPORT_LINEARISE_CSV,  ///< Export linearise in csv mode in output file
    EXPORT_LINEARISE_XML  ///< Export linearise in xml mode in output file
  } exportLineariseMode_t;

  /**
   * @brief Export mode for modal analysis
   * Modal analysis' export mode controlling the format of the moadal analysis' output file
   */
  typedef enum {
    EXPORT_MODALANALYSIS_NONE,  ///< No export linearise
    EXPORT_MODALANALYSIS_TXT,  ///< Export Modal analysis in txt mode in output file
    EXPORT_MODALANALYSIS_CSV,  ///< Export Modal analysis in csv mode in output file
    EXPORT_MODALANALYSIS_XML  ///< Export Modal analysis in xml mode in output file
  } exportModalAnalysisMode_t;

  /**
   * @brief Export mode for finalState
   * finalState's export mode controlling the format of the finalState's output file
   */
  typedef enum {
    EXPORT_FINALSTATE_NONE,  ///< Export no final state
    EXPORT_FINALSTATE_XML  ///< Export final states selected in input file in XML mode in output file
  } exportFinalStateMode_t;

  /**
   * @brief Export mode for constraint's state
   * constraint's state export mode controlling the format of the constraint's output file
   */
  typedef enum {
    EXPORT_CONSTRAINTS_NONE,  ///< Export no constraints
    EXPORT_CONSTRAINTS_XML,  ///< Export constraints in xml mode in output file
    EXPORT_CONSTRAINTS_TXT  ///< Export constraints in txt mode in output file
  } exportConstraintsMode_t;

 public:
  /**
   * @brief default constructor
   *
   * @param jobEntry data read in jobs file
   * @param context context of the simulation (configuration, directories, locale, etc...)
   */
  Simulation(boost::shared_ptr<job::JobEntry>& jobEntry, boost::shared_ptr<SimulationContext>& context);

  /**
   * @brief destructor
   */
  ~Simulation();

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
   * @brief print debug information
   */
  void printDebugInfo();

  /**
   * @brief import curves request from a file (i.e curves that the user wants to plot)
   * @warning the file should be set before the call of this method
   */
  void importCurvesRequest();

  /**
   * @brief importe final state request from a file (i.e final state that the user wants to see)
   * @warning the file should be set before the call of this method
   */
  void importFinalStateRequest();

  /**
   * @brief setter for the output file of the timeline
   * @param outputFile timeline's output file
   */
  inline void setTimelineOutputFile(const std::string& outputFile) {
    timelineOutputFile_ = outputFile;
  }

  /**
   * @brief setter for the output file of the linearise
   * @param outputFile linearise's output file
   */
  inline void setLineariseOutputFile(const std::string& outputFile) {
    lineariseOutputFile_ = outputFile;
  }

  /**
   * @brief setter for the output file of the modal analysis
   * @param outputFile modal analysis's output file
   */
  inline void setModalAnalysisOutputFile(const std::string& outputFile) {
    modalanalysisOutputFile_ = outputFile;
  }

  /**
   * @brief setter for the output file of the allmodes
   * @param outputFile allmodes's output file
   */
  inline void setAllModesOutputFile(const std::string& outputFile) {
    allmodesOutputFile_ = outputFile;
  }

  /**
   * @brief setter for the output file of the subparticipation
   * @param outputFile subparticipation's output file
   */
  inline void setSubParticipationOutputFile(const std::string& outputFile) {
    subparticipationOutputFile_ = outputFile;
  }
  /**
   * @brief setter for the export mode of the linearise
   * @param mode linearise's mode export
   */
  inline void setLineariseExportMode(const exportLineariseMode_t& mode) {
    exportLineariseMode_ = mode;
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
   * @brief setter for the export mode of final state
   * @param mode final state's export mode
   */
  inline void setFinalStateExportMode(const exportFinalStateMode_t& mode) {
    exportFinalStateMode_ = mode;
  }

  /**
   * @brief setter for the final state input file
   * @param inputFile input file of final state request
   */
  inline void setFinalStateInputFile(const std::string& inputFile) {
    finalStateInputFile_ = inputFile;
  }

  /**
   * @brief setter for the final state output file
   * @param outputFile final state's output file
   */
  inline void setFinalStateOutputFile(const std::string& outputFile) {
    finalStateOutputFile_ = outputFile;
  }

  /**
   * @brief setter for the constraints' output file
   * @param outputFile constraints' output file
   */
  inline void setConstraintsOutputFile(const std::string& outputFile) {
    constraintsOutputFile_ = outputFile;
  }

  /**
   * @brief setter for the constraints' export mode
   * @param mode constraints' export mode
   */
  inline void setConstraintsExportMode(const exportConstraintsMode_t& mode) {
    exportConstraintsMode_ = mode;
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
   * @brief setter for global init values dump mode
   * @param dumpGlobalInitValues  @b true if global init values should be dumped
   * global init values are the values calculated by the init algorithm for each models, all models at the same time
   */
  inline void setDumpGlobalInitValues(const bool dumpGlobalInitValues) {
    dumpGlobalInitValues_ = dumpGlobalInitValues;
  }

  /**
   * @brief indicates if the simulation has reached the stop time
   * @return @b true if current time >= stop time, @b false otherwise
   */
  inline bool end() const {
    return (tCurrent_ >= tStop_);
  }

  /**
   * @brief setter of the time of the linearisation
   * @param time start time of the linearisation
   */
  inline void setLineariseTime(const double& time) {
    tLinearise_ = time;
  }

  /**
   * @brief setter of the time of the modal analysis
   * @param time start time of the modal analysis
   */
  inline void setModalAnalysisTime(const double& time) {
    tModalAnalysis_ = time;
  }

  /**
   * @brief setter of the time of the eigencalculation
   * @param time start time of the eigencalculation
   */
  inline void setAllModesTime(const double& time) {
    tAllModes_ = time;
  }

  /**
   * @brief setter of the time of the Sub Participation
   * @param time start time of the Sub Participation
   */
  inline void setSubParticipationTime(const double& time) {
    tSubParticipation_ = time;
  }

  /**
   * @brief setter of the number of mode of minimum relative participation
   * @param participation start the number of minimum relative participation
   */
  inline void setSubParticipationNbMode(const double& nbmode) {
    NbMode_ = nbmode;
  }

  /**
   * @brief getter for the start number of mode of subparticipation factor
   * @return the start number of mode of subparticipation factor
   */
  inline double getSubParticipationNbMode() const {
    return NbMode_;
  }
  /**
   * @brief setter of the value of minimum relative participation
   * @param participation start the value of minimum relative participation
   */
  inline void setModalAnalysisPart(const double& participation) {
    Part_ = participation;
  }

  /**
   * @brief setter of the start time of the simulation
   * @param time start time of the simulation
   */
  inline void setStartTime(const double& time) {
    tStart_ = time;
  }

  /**
   * @brief setter of the stop time of the simulation
   * @param time stop time of the simulation
   */
  inline void setStopTime(const double& time) {
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

  void setCriteriaStep(const int& step);

  /**
   * @brief getter for the start time of the simulation
   * @return the start time of the simulation
   */
  inline double getStartTime() const {
    return tStart_;
  }

  /**
   * @brief getter for the start time of the linearisation
   * @return the start time of the linearisation
   */
  inline double getLineariseTime() const {
    return tLinearise_;
  }

  /**
   * @brief getter for the start time of the modal analysis
   * @return the start time of the modal analysis
   */
  inline double getModalAnalysisTime() const {
    return tModalAnalysis_;
  }

  /**
   * @brief getter for the start time of the eigencalculation
   * @return the start time of the eigencalculation
   */
  inline double getAllModesTime() const {
    return tAllModes_;
  }
  /* inline int getModalAnalysisSolver() const {
    return Solver_;
  }*/

  /**
   * @brief getter for the start time of the eigencalculation
   * @return the start time of the eigencalculation
   */
  /* inline int getAllModesSolver() const {
    return Solver_;
  }*/
  /**
   * @brief getter for the start time of the Sub Participation
   * @return the start time of the Sub Participation
   */
  inline double getSubParticipationTime() const {
    return tSubParticipation_;
  }

  /**
   * @brief getter for the start value of minimum relative participation factor
   * @return the start value of minimum relative participation factor
   */
  inline double getModalAnalysisPart() const {
    return Part_;
  }
  /**
   * @brief getter for the current time of the simulation
   * @return the current time of the simulation
   */
  inline double getCurrentTime() const {
    return tCurrent_;
  }

  /**
   * @brief set if final state dump is activated
   * @param activate @b true if final state dump should be made, @b false otherwise
   */
  inline void activateDumpFinalState(bool activate) {
    exportDumpFinalState_ = activate;
  }

  /**
   * @brief setter for the final state dump output file
   * @param file final state dump output file
   */
  inline void setDumpFinalStateFile(const std::string& file) {
    dumpFinalStateFile_ = file;
  }

  /**
   * @brief set if final state IIDM file should be dumped
   * @param activate @b true if final state IIDM file should be dumped, @b false otherwise
   */
  inline void activateExportIIDM(bool activate) {
    exportIIDM_ = activate;
  }

  /**
   * @brief setter for the final state IIDM output file
   * @param file final state IIDM output file
   */
  inline void setExportIIDMFile(const std::string& file) {
    exportIIDMFile_ = file;
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
   * @brief print timeline output of the simulation in the given stream
   * @param stream stream where the timeline output should be printed
   */
  void printTimeline(std::ostream& stream) const;

  /**
   * @brief print linearise output of the simulation in the given stream
   * @param stream stream where the linearise output should be printed
   */
  void printLinearise() const;

  /**
   * @brief print modalanalysis output of the simulation in the given stream
   * @param stream stream where the modalanalysis output should be printed
   */
  void printModalAnalysis(std::ostream& stream) const;

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
   * @brief fill a vector with the ids of the failing criteria met so far
   * @param failingCriteria vector to fill
   */
  void getFailingCriteria(std::vector<std::pair<double, std::string> >& failingCriteria) const;

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

 public:
  boost::shared_ptr<SimulationContext> context_;  ///< simulation context : configuration of the simulation
  boost::shared_ptr<job::JobEntry> jobEntry_;  ///< jobs data description
  boost::shared_ptr<Solver> solver_;  ///< solver used for the simulation
  boost::shared_ptr<Model> model_;  ///< model used for the simulation
  boost::shared_ptr<DataInterface> data_;  ///< Data interface associated to the job
  boost::shared_ptr<DynamicData> dyd_;  ///< Dynamic data container associated to the job
  boost::shared_ptr<timeline::Timeline> timeline_;  ///< instance of the timeline where events are stored
  boost::shared_ptr<curves::CurvesCollection> curvesCollection_;  ///< instance of curves collection where curves are stored
  boost::shared_ptr<finalState::FinalStateCollection> finalStateCollection_;  ///< instance of final state collection where final state are stored
  boost::shared_ptr<constraints::ConstraintsCollection> constraintsCollection_;  ///< instance of constraints collection where constraints are stored
  boost::shared_ptr<criteria::CriteriaCollection> criteriaCollection_;  ///< instance of criteria collection where criteria are stored
  boost::shared_ptr<linearise::Linearise> linearise_;  ///< instance of the linearise where events are stored
  boost::shared_ptr<modalanalysis::ModalAnalysis> modalanalysis_;  ///< instance of the modalanalysis where events are stored
  boost::shared_ptr<allmodes::AllModes> allmodes_;  ///< instance of the allmodes where events are stored
  boost::shared_ptr<subparticipation::SubParticipation> subparticipation_;  ///< instance of the sub participation where events are stored

  std::vector<std::string> dydFiles_;  ///< list of files to used dynamic data
  std::string iidmFile_;  ///< iidm input file
  std::string networkParFile_;  ///< file containing all parameters for the network
  std::string networkParSet_;  ///< id of the set of parameters to use for the network
  std::string initialStateFile_;  ///< dump to load for each state variable
  boost::unordered_map<std::string,
          boost::shared_ptr<parameters::ParametersSetCollection> > referenceParameters_;  ///< association between file name and parameters collection

  std::string outputsDirectory_;  ///< directory for simulation outputs

  exportCurvesMode_t exportCurvesMode_;  ///< curves' export mode
  std::string curvesInputFile_;  ///< curves' resquest input file
  std::string curvesOutputFile_;  ///< curves' output file

  exportTimelineMode_t exportTimelineMode_;  ///< timeline's output mode
  std::string timelineOutputFile_;  ///< timeline's export file

  std::string timetableOutputFile_;  ///< timetable export file
  int timetableSteps_;  ///< timetable' steps

  exportLineariseMode_t exportLineariseMode_;  ///< linearise's output mode
  std::string lineariseOutputFile_;  ///< linearise's export file

  exportModalAnalysisMode_t exportModalAnalysisMode_;  ///< modalanalysis's output mode
  std::string modalanalysisOutputFile_;  ///< modalanalysis's export file

  std::string allmodesOutputFile_;  ///< modalanalysis's export file
  std::string subparticipationOutputFile_;  ///< modalanalysis's export file

  exportFinalStateMode_t exportFinalStateMode_;  ///< final state's export mode
  std::string finalStateInputFile_;  ///< final state's request input file
  std::string finalStateOutputFile_;  ///< final state's output file

  exportConstraintsMode_t exportConstraintsMode_;  ///< contstraints' export mode
  std::string constraintsOutputFile_;  ///< constraints' export file

  pid_t pid_;  ///< pid of the current simulation

  bool exportDumpFinalState_;  ///< @b true if final state dump should be activated
  std::string dumpFinalStateFile_;  ///< final state dump file

  bool exportIIDM_;  ///< @b true if final IIDM file should be dump
  std::string exportIIDMFile_;  ///< final IIDM file dump
  double tStart_;  ///< start time of the simulation
  double tCurrent_;  ///< current time of the simulation
  double Part_;  ///< minimum value of relative participation factor
  // int Solver_;  ///< minimum value of relative participation factor
  double tStop_;  ///< stop time of the simulation
  bool activateCriteria_;  ///< whether to activate the verification if criteria are fullfilled
  int  criteriaStep_;  ///< if activated, this number will be the number of iterations between two criteria checks
  bool dumpLocalInitValues_;  ///< whether to export the results from the local initialisation
  bool dumpGlobalInitValues_;  ///< whether to export the results from the global initialisation
  std::vector<double> zCurrent_;  ///< current values of the model's discrete variables
  double tLinearise_;  ///< start time of the Linearisation
  double tModalAnalysis_;  ///< start time of the Modal analysis
  double tAllModes_;  ///< start time of the all modes
  double tSubParticipation_;  ///< start time of the sub participation
  double NbMode_;  ///< start number of mode of the sub participation

 private:
 /**
   * @brief configure the all modes outputs
   */
  void configureAllModesOutputs();

 /**
   * @brief configure the modal analysis outputs
   */
  void configureModalAnalysisOutputs();

 /**
   * @brief configure the sub-participation outputs
   */
  void configureSubParticipationOutputs();

 /**
   * @brief configure the linearisation outputs
   */
  void configureLineariseOutputs();


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
  void configureFinalStateOutputs();
};

}  // end of namespace DYN

#endif  // SIMULATION_DYNSIMULATION_H_
