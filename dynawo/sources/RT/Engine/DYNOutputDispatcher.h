//
// Copyright (c) 2025, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
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

class OutputDispatcher {
 public:
  OutputDispatcher();

  ~OutputDispatcher();

  void addCurvesPublisher(std::shared_ptr<OutputChannel>& publisher, const std::string formatStr);

  void addTimelinePublisher(std::shared_ptr<OutputChannel>& publisher, const std::string formatStr);

  void addConstraintsPublisher(std::shared_ptr<OutputChannel>& publisher, const std::string formatStr);

  void initPublishCurves(std::shared_ptr<curves::CurvesCollection>& curvesCollection);

  void publishCurves(std::shared_ptr<curves::CurvesCollection>& curvesCollection);

  void publishTimeline(boost::shared_ptr<timeline::Timeline>& timeline);

  void publishConstraints(std::shared_ptr<constraints::ConstraintsCollection>& constraintsCollection);

 private:
  /**
   * @brief format last curves point in JSON
   */
  std::string curvesToJson(std::shared_ptr<curves::CurvesCollection> curvesCollection);

  /**
   * @brief format last curves point in CSV
   */
  std::string curvesToCsv(std::shared_ptr<curves::CurvesCollection> curvesCollection);

  /**
  * @brief format curves names in CSV
  */
  std::string curvesNamesToString(std::shared_ptr<curves::CurvesCollection> curvesCollection);

  /**
  * @brief format curves as bytes
  */
  void updateCurvesValues(std::shared_ptr<curves::CurvesCollection> curvesCollection);

 private:
  // std::shared_ptr<ActionBuffer> actionBuffer_;
  // std::shared_ptr<Clock> clock_;
  std::map<CurvesOutputFormat, std::vector<std::shared_ptr<OutputChannel> > > curvesPublishers_;
  std::map<TimelineOutputFormat, std::vector<std::shared_ptr<OutputChannel> > > timelinePublishers_;
  std::map<ConstraintsOutputFormat, std::vector<std::shared_ptr<OutputChannel> > > constraintsPublishers_;

  std::vector<std::uint8_t> curvesValues_;  ///< curves values buffer for BYTES export

  // std::queue<std::shared_ptr<OutputMessage>> messageQueue_;
  // std::mutex queueMutex_;
  // std::condition_variable queueCond_;
  // std::thread processorThread_;
  std::atomic<bool> running_;
};

}  // end of namespace DYN

#endif  // RT_ENGINE_DYNOUTPUTDISPATCHER_H_
