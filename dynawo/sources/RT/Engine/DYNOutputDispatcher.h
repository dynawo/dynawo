//
// Copyright (c) 2025, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file  DYNOutputDispatcher.h
 *
 * @brief OutputDispatcher header
 *
 */
#ifndef RT_ENGINE_DYNOUTPUTDISPATCHER_H_
#define RT_ENGINE_DYNOUTPUTDISPATCHER_H_

#include <memory>
#include <vector>
#include <map>

#include "DYNRTOutputCommon.h"
#include "DYNActionBuffer.h"
#include "DYNClock.h"
#include "DYNOutputChannel.h"
#include "CRVCurvesCollection.h"
#include "TLTimeline.h"
#include "CSTRConstraintsCollection.h"



namespace DYN {
/**
 * @class OutputDispatcher
 * @brief Class for publishing outputs (curves, timeline, constraints) to output channels
 */
class OutputDispatcher {
 public:
  /**
   * @brief constructor
   */
  OutputDispatcher();

  /**
   * @brief add a curves output channel
   * @param publisher channel for publication
   * @param formatStr string of the format
   */
  void addCurvesPublisher(std::shared_ptr<OutputChannel>& publisher, const std::string formatStr);

  /**
   * @brief add a timeline output channel
   * @param publisher channel for publication
   * @param formatStr string of the format
   */
  void addTimelinePublisher(std::shared_ptr<OutputChannel>& publisher, const std::string formatStr);

  /**
   * @brief add a constraints output channel
   * @param publisher channel for publication
   * @param formatStr string of the format
   */
  void addConstraintsPublisher(std::shared_ptr<OutputChannel>& publisher, const std::string formatStr);

  /**
   * @brief add a logs output channel
   * @param publisher channel for publication
   * @param formatStr string of the format
   */
  void addLogsPublisher(std::shared_ptr<OutputChannel>& publisher, const std::string formatStr);

  /**
   * @brief publish curves names
   * @param curvesCollection curves collection to publish
   */
  void publishCurvesNames(std::shared_ptr<curves::CurvesCollection>& curvesCollection);

  /**
   * @brief publish curves
   * @param curvesCollection curves collection to publish
   */
  void publishCurves(std::shared_ptr<curves::CurvesCollection>& curvesCollection);

  /**
   * @brief publish timeline
   * @param timeline timeline to publish
   */
  void publishTimeline(boost::shared_ptr<timeline::Timeline>& timeline);

  /**
   * @brief publish constraints
   * @param constraintsCollection constraints collection to publish
   */
  void publishConstraints(std::shared_ptr<constraints::ConstraintsCollection>& constraintsCollection);

 private:
  /**
   * @brief format last curves point in JSON
   * @param curvesCollection curves collection to serialize
   * @return formated curves
   */
  std::string curvesToJson(std::shared_ptr<curves::CurvesCollection> curvesCollection) const;

  /**
   * @brief format last curves point in CSV
   * @param curvesCollection curves collection to serialize
   * @return formated curves
   */
  std::string curvesToCsv(std::shared_ptr<curves::CurvesCollection> curvesCollection) const;

  /**
  * @brief format curves names in CSV
  * @param curvesCollection curves collection to serialize
  * @return formated curve names
  */
  std::string curvesNamesToString(std::shared_ptr<curves::CurvesCollection> curvesCollection) const;

  /**
  * @brief update the value of curves in a collection
  * @param curvesCollection curves collection to update
  */
  void updateCurvesValues(std::shared_ptr<curves::CurvesCollection> curvesCollection);

 private:
  std::map<CurvesStreamFormat, std::vector<std::shared_ptr<OutputChannel> > > curvesPublishers_;            ///< curves publishers
  std::map<TimelineStreamFormat, std::vector<std::shared_ptr<OutputChannel> > > timelinePublishers_;        ///< timeline publishers
  std::map<ConstraintsStreamFormat, std::vector<std::shared_ptr<OutputChannel> > > constraintsPublishers_;  ///< constraints publishers

  std::vector<std::uint8_t> curvesValues_;  ///< curves values buffer for BYTES export optimization
  std::atomic<bool> running_;               ///< running flag
};

}  // end of namespace DYN

#endif  // RT_ENGINE_DYNOUTPUTDISPATCHER_H_
