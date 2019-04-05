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

#include <string>

#include <xml/sax/parser/ParserFactory.h>

#include "DYNSimulationLauncher.h"
#include "DYNMacrosMessage.h"
#include "DYNTrace.h"
#include "DYNSimulation.h"
#include "DYNSimulationContext.h"
#include "DYNFileSystemUtils.h"
#include "DYNTimer.h"
#include "DYNExecUtils.h"
#include "JOBXmlImporter.h"
#include "JOBIterators.h"
#include "JOBJobsCollection.h"
#include "JOBJobEntry.h"

namespace parser = xml::sax::parser;

using DYN::Trace;
using DYN::Simulation;
using DYN::SimulationContext;

void launchSimu(const std::string& jobsFileName) {
  try {
    DYN::Timer timer("Main::LaunchSimu");

    job::XmlImporter importer;
    boost::shared_ptr<job::JobsCollection> jobsCollection = importer.importFromFile(jobsFileName);
    std::string prefixJobFile = absolute(remove_file_name(jobsFileName));

    for (job::job_iterator itJobEntry = jobsCollection->begin();
          itJobEntry != jobsCollection->end();
          ++itJobEntry) {
      Trace::init();
      Trace::debug() << DYNLog(LaunchingJob, (*itJobEntry)->getName()) << Trace::endline;

      boost::shared_ptr<SimulationContext> context = boost::shared_ptr<SimulationContext>(new SimulationContext());
      context->setResourcesDirectory(getEnvVar("DYNAWO_RESOURCES_DIR"));
      context->setLocale(getEnvVar("DYNAWO_LOCALE"));
      context->setInputDirectory(prefixJobFile);
      context->setWorkingDirectory(prefixJobFile);

      boost::shared_ptr<Simulation> simulation = boost::shared_ptr<Simulation>(new Simulation((*itJobEntry), context));
      simulation->init();
      try {
        simulation->simulate();
        simulation->terminate();
      } catch (const DYN::Error& err) {
        // Issue #144: otherwise terminate might crash due to missing staticRef variables
        if (err.key() == DYN::KeyError_t::StateVariableNoReference)
          simulation->activateExportIIDM(false);
        // Issue #144
        simulation->terminate();
        throw;
      } catch (...) {
        simulation->terminate();
        throw;
      }
      simulation->clean();
      Trace::debug() << DYNLog(EndOfJob, (*itJobEntry)->getName()) << Trace::endline;
      Trace::resetCustomAppenders();
    }
  } catch (...) {
    throw;
  }
}
