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
 * @file  DYNSimulationLauncher.cpp
 *
 * @brief SimulationLauncher implementation
 *
 */
#include <xml/sax/parser/ParserFactory.h>

#include "DYNSimulationLauncher.h"
#include "DYNMacrosMessage.h"
#include "DYNTrace.h"
#include "DYNSimulation.h"
#include "DYNSimulationRT.h"
#include "DYNSimulationContext.h"
#include "DYNFileSystemUtils.h"
#include "DYNTimer.h"
#include "DYNExecUtils.h"
#include "JOBXmlImporter.h"
#include "JOBIterators.h"
#include "JOBJobsCollection.h"
#include "JOBJobEntry.h"
#include "JOBOutputsEntry.h"

#include <string>
#include <memory>

namespace parser = xml::sax::parser;

using DYN::Trace;
using DYN::Simulation;
using DYN::SimulationRT;
using DYN::SimulationContext;

using std::chrono::system_clock;
using std::chrono::microseconds;
using std::chrono::duration_cast;

// If logging is disabled, Trace::info has no effect so we also print on standard output to have basic information
template<class T>
static void print(const T& output, DYN::SeverityLevel level = DYN::INFO) {
  DYN::TraceStream ss;
  switch (level) {
    case DYN::DEBUG:
      ss = Trace::debug();
      break;
    case DYN::INFO:
      ss = Trace::info();
      break;
    case DYN::WARN:
      ss = Trace::warn();
      break;
    case DYN::ERROR:
      ss = Trace::error();
      break;
    default:
      // impossible case by definition of the enum
      return;
  }
  ss << output << Trace::endline;
  if (!Trace::isLoggingEnabled()) {
    std::clog << output << std::endl;
  }
}

void launchSimu(const std::string& jobsFileName) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  DYN::Timer timer("Main::LaunchSimu");
#endif

  job::XmlImporter importer;
  std::shared_ptr<job::JobsCollection> jobsCollection = importer.importFromFile(jobsFileName);
  std::string prefixJobFile = absolute(remove_file_name(jobsFileName));
  if (jobsCollection->begin() == jobsCollection->end())
    throw DYNError(DYN::Error::SIMULATION, NoJobDefined);
  Trace::init();

  for (job::job_iterator itJobEntry = jobsCollection->begin();
      itJobEntry != jobsCollection->end();
      ++itJobEntry) {
    print(DYNLog(LaunchingJob, (*itJobEntry)->getName()));

    std::shared_ptr<SimulationContext> context = std::make_shared<SimulationContext>();
    context->setResourcesDirectory(getMandatoryEnvVar("DYNAWO_RESOURCES_DIR"));
    context->setLocale(getMandatoryEnvVar("DYNAWO_LOCALE"));
    context->setInputDirectory(prefixJobFile);
    context->setWorkingDirectory(prefixJobFile);


    std::shared_ptr<Simulation> simulation;
    try {
      simulation = std::shared_ptr<Simulation>(new Simulation((*itJobEntry), context));
      simulation->init();
    } catch (const DYN::Error& err) {
      print(err.what(), DYN::ERROR);
      throw;
    } catch (const DYN::MessageError& e) {
      print(e.what(), DYN::ERROR);
      throw;
    } catch (const char *s) {
      print(s, DYN::ERROR);
      throw;
    } catch (const std::string& Msg) {
      print(Msg, DYN::ERROR);
      throw;
    } catch (const std::exception& exc) {
      print(exc.what(), DYN::ERROR);
      throw;
    }

    try {
      simulation->simulate();
      simulation->terminate();
    } catch (const DYN::Error& err) {
      // Needed as otherwise terminate might crash due to missing staticRef variables
      if (err.key() == DYN::KeyError_t::StateVariableNoReference) {
        simulation->disableExportIIDM();
        simulation->setLostEquipmentsExportMode(Simulation::EXPORT_LOSTEQUIPMENTS_NONE);
      }
      print(err.what(), DYN::ERROR);
      simulation->terminate();
      throw;
    } catch (const DYN::Terminate& e) {
      print(e.what(), DYN::ERROR);
      simulation->terminate();
      throw;
    } catch (const DYN::MessageError& e) {
      print(e.what(), DYN::ERROR);
      simulation->terminate();
      throw;
    } catch (const char *s) {
      print(s, DYN::ERROR);
      simulation->terminate();
      throw;
    } catch (const std::string& Msg) {
      print(Msg, DYN::ERROR);
      simulation->terminate();
      throw;
    } catch (const std::exception& exc) {
      print(exc.what(), DYN::ERROR);
      simulation->terminate();
      throw;
    }
    simulation->clean();
    print(DYNLog(EndOfJob, (*itJobEntry)->getName()));
    Trace::resetCustomAppenders();
    Trace::init();
    print(DYNLog(JobSuccess, (*itJobEntry)->getName()));
    if ((*itJobEntry)->getOutputsEntry()) {
      std::string outputsDirectory = createAbsolutePath((*itJobEntry)->getOutputsEntry()->getOutputsDirectory(), context->getWorkingDirectory());
      print(DYNLog(ResultFolder, outputsDirectory));
    }
  }
}


void launchSimuInterractive(const std::string& jobsFileName) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  DYN::Timer timer("Main::launchSimuInterractive");
#endif
    // TIME
    std::chrono::system_clock::time_point t_start = system_clock::now();
    // /TIME
  job::XmlImporter importer;
  std::shared_ptr<job::JobsCollection> jobsCollection = importer.importFromFile(jobsFileName);
  std::string prefixJobFile = absolute(remove_file_name(jobsFileName));
  if (jobsCollection->begin() == jobsCollection->end())
    throw DYNError(DYN::Error::SIMULATION, NoJobDefined);
  Trace::init();

  for (job::job_iterator itJobEntry = jobsCollection->begin();
      itJobEntry != jobsCollection->end();
      ++itJobEntry) {
    print(DYNLog(LaunchingJob, (*itJobEntry)->getName()));

    std::shared_ptr<SimulationContext> context = std::shared_ptr<SimulationContext>(new SimulationContext());
    context->setResourcesDirectory(getMandatoryEnvVar("DYNAWO_RESOURCES_DIR"));
    context->setLocale(getMandatoryEnvVar("DYNAWO_LOCALE"));
    context->setInputDirectory(prefixJobFile);
    context->setWorkingDirectory(prefixJobFile);
    // TIME
    std::chrono::system_clock::time_point t_end = system_clock::now();
    double duration = (1./1000)*(duration_cast<microseconds>(t_end-t_start)).count();
    Trace::info() << "TimeManagement: pre-init duration: " << duration << "ms" << Trace::endline;
    t_start = t_end;
    // /TIME
    std::shared_ptr<SimulationRT> simulation;
    try {
      simulation = std::shared_ptr<SimulationRT>(new SimulationRT((*itJobEntry), context));
      simulation->init();
      // TIME
      t_end = system_clock::now();
      double duration = (1./1000)*(duration_cast<microseconds>(t_end-t_start)).count();
      Trace::info() << "TimeManagement: init duration: " << duration << "ms" << Trace::endline;
      t_start = t_end;
      // /TIME
    } catch (const DYN::Error& err) {
      print(err.what(), DYN::ERROR);
      throw;
    } catch (const DYN::MessageError& e) {
      print(e.what(), DYN::ERROR);
      throw;
    } catch (const char *s) {
      print(s, DYN::ERROR);
      throw;
    } catch (const std::string& Msg) {
      print(Msg, DYN::ERROR);
      throw;
    } catch (const std::exception& exc) {
      print(exc.what(), DYN::ERROR);
      throw;
    }

    try {
      simulation->simulate();
      // TIME
      t_end = system_clock::now();
      duration = (1./1000)*(duration_cast<microseconds>(t_end-t_start)).count();
      Trace::info() << "TimeManagement: simulate duration: " << duration << "ms" << Trace::endline;
      t_start = t_end;
      // /TIME
      simulation->terminate();
      // TIME
      t_end = system_clock::now();
      duration = (1./1000)*(duration_cast<microseconds>(t_end-t_start)).count();
      Trace::info() << "TimeManagement: terminate duration: " << duration << "ms" << Trace::endline;
      t_start = t_end;
      // /TIME
    } catch (const DYN::Error& err) {
      // Needed as otherwise terminate might crash due to missing staticRef variables
      if (err.key() == DYN::KeyError_t::StateVariableNoReference) {
        simulation->disableExportIIDM();
        simulation->setLostEquipmentsExportMode(SimulationRT::EXPORT_LOSTEQUIPMENTS_NONE);
      }
      print(err.what(), DYN::ERROR);
      simulation->terminate();
      throw;
    } catch (const DYN::Terminate& e) {
      print(e.what(), DYN::ERROR);
      simulation->terminate();
      throw;
    } catch (const DYN::MessageError& e) {
      print(e.what(), DYN::ERROR);
      simulation->terminate();
      throw;
    } catch (const char *s) {
      print(s, DYN::ERROR);
      simulation->terminate();
      throw;
    } catch (const std::string& Msg) {
      print(Msg, DYN::ERROR);
      simulation->terminate();
      throw;
    } catch (const std::exception& exc) {
      print(exc.what(), DYN::ERROR);
      simulation->terminate();
      throw;
    }
    simulation->clean();
    print(DYNLog(EndOfJob, (*itJobEntry)->getName()));
    Trace::resetCustomAppenders();
    Trace::init();
    print(DYNLog(JobSuccess, (*itJobEntry)->getName()));
    if ((*itJobEntry)->getOutputsEntry()) {
      std::string outputsDirectory = createAbsolutePath((*itJobEntry)->getOutputsEntry()->getOutputsDirectory(), context->getWorkingDirectory());
      print(DYNLog(ResultFolder, outputsDirectory));
    }
  }
}


// void launchSimuInterractive(const std::string& jobsFileName) {
// #if defined(_DEBUG_) || defined(PRINT_TIMERS)
//   DYN::Timer timer("Main::LaunchSimu");
// #endif

//   job::XmlImporter importer;
//   boost::shared_ptr<job::JobsCollection> jobsCollection = importer.importFromFile(jobsFileName);
//   std::string prefixJobFile = absolute(remove_file_name(jobsFileName));
//   if (jobsCollection->begin() == jobsCollection->end())
//     throw DYNError(DYN::Error::SIMULATION, NoJobDefined);
//   Trace::init();

//   for (job::job_iterator itJobEntry = jobsCollection->begin();
//       itJobEntry != jobsCollection->end();
//       ++itJobEntry) {
//     print(DYNLog(LaunchingJob, (*itJobEntry)->getName()));

//     boost::shared_ptr<SimulationContext> context = boost::shared_ptr<SimulationContext>(new SimulationContext());
//     context->setResourcesDirectory(getMandatoryEnvVar("DYNAWO_RESOURCES_DIR"));
//     context->setLocale(getMandatoryEnvVar("DYNAWO_LOCALE"));
//     context->setInputDirectory(prefixJobFile);
//     context->setWorkingDirectory(prefixJobFile);

//     boost::shared_ptr<Simulation> simulation;
//     try {
//       simulation = boost::shared_ptr<Simulation>(new Simulation((*itJobEntry), context));
//       simulation->init();
//     } catch (const DYN::Error& err) {
//       print(err.what(), DYN::ERROR);
//       throw;
//     } catch (const DYN::MessageError& e) {
//       print(e.what(), DYN::ERROR);
//       throw;
//     } catch (const char *s) {
//       print(s, DYN::ERROR);
//       throw;
//     } catch (const std::string& Msg) {
//       print(Msg, DYN::ERROR);
//       throw;
//     } catch (const std::exception& exc) {
//       print(exc.what(), DYN::ERROR);
//       throw;
//     }
//     bool rerun = true;
//     while (rerun) {
//       try {
//         rerun = false;
//         simulation->simulate();
//         simulation->terminate();
//       } catch (const DYN::Interception& interception) {
//         simulation->dumpState();
//         print(interception.what(), DYN::WARN);
//         rerun = true;
//         throw;
//       } catch (const DYN::Error& err) {
//         // Needed as otherwise terminate might crash due to missing staticRef variables
//         if (err.key() == DYN::KeyError_t::StateVariableNoReference) {
//           simulation->disableExportIIDM();
//           simulation->setLostEquipmentsExportMode(Simulation::EXPORT_LOSTEQUIPMENTS_NONE);
//         }
//         print(err.what(), DYN::ERROR);
//         simulation->terminate();
//         throw;
//       } catch (const DYN::Terminate& e) {
//         print(e.what(), DYN::ERROR);
//         simulation->terminate();
//         throw;
//       } catch (const DYN::MessageError& e) {
//         print(e.what(), DYN::ERROR);
//         simulation->terminate();
//         throw;
//       } catch (const char *s) {
//         print(s, DYN::ERROR);
//         simulation->terminate();
//         throw;
//       } catch (const std::string& Msg) {
//         print(Msg, DYN::ERROR);
//         simulation->terminate();
//         throw;
//       } catch (const std::exception& exc) {
//         print(exc.what(), DYN::ERROR);
//         simulation->terminate();
//         throw;
//       }
//     }
//     simulation->clean();
//     print(DYNLog(EndOfJob, (*itJobEntry)->getName()));
//     Trace::resetCustomAppenders();
//     Trace::init();
//     print(DYNLog(JobSuccess, (*itJobEntry)->getName()));
//     if ((*itJobEntry)->getOutputsEntry()) {
//       std::string outputsDirectory = createAbsolutePath((*itJobEntry)->getOutputsEntry()->getOutputsDirectory(), context->getWorkingDirectory());
//       print(DYNLog(ResultFolder, outputsDirectory));
//     }
//   }
// }
