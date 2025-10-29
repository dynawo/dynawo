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
#include "DYNOutputDispatcher.h"

#include "DYNOutputChannel.h"
#include "TLExporter.h"
#include "TLXmlExporter.h"
#include "TLCsvExporter.h"
#include "TLJsonExporter.h"
#include "TLTxtExporter.h"
#include "CRVXmlExporter.h"
#include "CSTRExporter.h"
#include "CSTRTxtExporter.h"
#include "CSTRJsonExporter.h"
#include "CSTRXmlExporter.h"
#include "DYNError.h"

#include <vector>
#include <functional>
#include <iostream>
#include <sstream>
#include <atomic>

namespace DYN {

OutputDispatcher::OutputDispatcher() :
  running_(false) {}

void
OutputDispatcher::addCurvesPublisher(std::shared_ptr<OutputChannel>& publisher, const std::string formatStr) {
  CurvesStreamFormat format;
  if (formatStr == "BYTES") {
    format = CurvesStreamFormat::BYTES;
  } else if (formatStr == "CSV") {
    format = CurvesStreamFormat::CSV;
  } else if (formatStr == "JSON") {
    format = CurvesStreamFormat::JSON;
  } else if (formatStr == "XML") {
    format = CurvesStreamFormat::XML;
  } else {
    throw DYNError(Error::GENERAL, UnknownCurvesStreamFormat, formatStr);
  }

  if (curvesPublishers_.find(format) == curvesPublishers_.end()) {
    curvesPublishers_.emplace(format, std::vector<std::shared_ptr<OutputChannel> >());
  }
  curvesPublishers_.find(format)->second.push_back(publisher);
}

void
OutputDispatcher::addTimelinePublisher(std::shared_ptr<OutputChannel>& publisher, const std::string formatStr) {
  TimelineStreamFormat format;
  if (formatStr == "CSV") {
    format = TimelineStreamFormat::CSV;
  } else if (formatStr == "JSON") {
    format = TimelineStreamFormat::JSON;
  } else if (formatStr == "TXT") {
    format = TimelineStreamFormat::TXT;
  } else if (formatStr == "XML") {
    format = TimelineStreamFormat::XML;
  } else {
    throw DYNError(Error::GENERAL, UnknownTimelineStreamFormat, formatStr);
  }
  if (timelinePublishers_.find(format) == timelinePublishers_.end()) {
    timelinePublishers_.emplace(format, std::vector<std::shared_ptr<OutputChannel> >());
  }
  timelinePublishers_.find(format)->second.push_back(publisher);
}

void
OutputDispatcher::addConstraintsPublisher(std::shared_ptr<OutputChannel>& publisher, const std::string formatStr) {
  ConstraintsStreamFormat format;
  if (formatStr == "JSON") {
    format = ConstraintsStreamFormat::JSON;
  } else if (formatStr == "TXT") {
    format = ConstraintsStreamFormat::TXT;
  } else if (formatStr == "XML") {
    format = ConstraintsStreamFormat::XML;
  } else {
    throw DYNError(Error::GENERAL, UnknownConstraintsStreamFormat, formatStr);
  }
  if (constraintsPublishers_.find(format) == constraintsPublishers_.end()) {
    constraintsPublishers_.emplace(format, std::vector<std::shared_ptr<OutputChannel> >());
  }
  constraintsPublishers_.find(format)->second.push_back(publisher);
}

void
OutputDispatcher::addLogsPublisher(std::shared_ptr<OutputChannel>& /*publisher*/, const std::string /*formatStr*/) {
  Trace::error() << DYNError(Error::GENERAL, LogStreamNotImplemented) << Trace::endline;
}

void
OutputDispatcher::publishCurvesNames(std::shared_ptr<curves::CurvesCollection>& curvesCollection) {
  if (!curvesCollection)
    return;
  if (curvesPublishers_.find(CurvesStreamFormat::BYTES) != curvesPublishers_.end()) {
    size_t nbAvailableCurves = 0;
    for (auto &curve : curvesCollection->getCurves())
      if (curve->getAvailable())
        nbAvailableCurves++;
    curvesValues_.reserve((nbAvailableCurves + 1) * sizeof(double));
    std::string formatedCurvesNames = curvesNamesToString(curvesCollection);
    for (auto &publisher : curvesPublishers_.find(CurvesStreamFormat::BYTES)->second)
        publisher->sendMessage(formatedCurvesNames, "curves_names");
  }
}

void
OutputDispatcher::publishCurves(std::shared_ptr<curves::CurvesCollection>& curvesCollection) {
  if (!curvesCollection)
    return;
  for (auto &curvePublishersPair : curvesPublishers_) {
    switch (curvePublishersPair.first) {
      case (CurvesStreamFormat::BYTES): {
        updateCurvesValues(curvesCollection);
        for (auto &publisher : curvePublishersPair.second)
          publisher->sendMessage(curvesValues_, "curves_values");
        break;
      }
      case (CurvesStreamFormat::JSON): {
        std::string outputSring = curvesToJson(curvesCollection);
        for (auto &publisher : curvePublishersPair.second)
          publisher->sendMessage(outputSring, "curves");
        break;
      }
      case (CurvesStreamFormat::CSV): {
        std::string outputSring = curvesToCsv(curvesCollection);
        for (auto &publisher : curvePublishersPair.second)
          publisher->sendMessage(outputSring, "curves");
        break;
      }
      case (CurvesStreamFormat::XML):
        std::stringstream stream;
        curves::XmlExporter exporter;
        exporter.exportToStream(curvesCollection, stream);
        std::string outputSring = stream.str();
        for (auto &publisher : curvePublishersPair.second)
          publisher->sendMessage(outputSring, "curves");
        break;
    }
  }
}

void
OutputDispatcher::publishTimeline(boost::shared_ptr<timeline::Timeline>& timeline) {
  if (!timeline)
    return;

  for (auto &timelinePublishersPair : timelinePublishers_) {
    switch (timelinePublishersPair.first) {
      case (TimelineStreamFormat::JSON): {
        std::stringstream stream;
        timeline::JsonExporter exporter;
        exporter.exportToStream(timeline, stream);
        std::string strTimeline = stream.str();
        for (auto &publisher : timelinePublishersPair.second)
          publisher->sendMessage(strTimeline, "timeline");
        break;
      }
      case (TimelineStreamFormat::CSV): {
        std::stringstream stream;
        timeline::CsvExporter exporter;
        exporter.exportToStream(timeline, stream);
        std::string strTimeline = stream.str();
        for (auto &publisher : timelinePublishersPair.second)
          publisher->sendMessage(strTimeline, "timeline");
        break;
      }
      case (TimelineStreamFormat::TXT): {
        std::stringstream stream;
        timeline::TxtExporter exporter;
        exporter.exportToStream(timeline, stream);
        std::string strTimeline = stream.str();
        for (auto &publisher : timelinePublishersPair.second)
          publisher->sendMessage(strTimeline, "timeline");
        break;
      }
      case (TimelineStreamFormat::XML): {
        std::stringstream stream;
        timeline::XmlExporter exporter;
        exporter.exportToStream(timeline, stream);
        std::string strTimeline = stream.str();
        for (auto &publisher : timelinePublishersPair.second)
          publisher->sendMessage(strTimeline, "timeline");
        break;
      }
    }
  }
}

void
OutputDispatcher::publishConstraints(std::shared_ptr<constraints::ConstraintsCollection>& constraintsCollection) {
    if (!constraintsCollection)
    return;

  for (auto &constraintsPublishersPair : constraintsPublishers_) {
    switch (constraintsPublishersPair.first) {
      case (ConstraintsStreamFormat::JSON): {
        std::stringstream stream;
        constraints::JsonExporter exporter;
        exporter.exportToStream(constraintsCollection, stream);
        std::string strConstraints = stream.str();
        for (auto &publisher : constraintsPublishersPair.second)
          publisher->sendMessage(strConstraints, "constraints");
        break;
      }
      case (ConstraintsStreamFormat::TXT): {
        std::stringstream stream;
        constraints::TxtExporter exporter;
        exporter.exportToStream(constraintsCollection, stream);
        std::string strConstraints = stream.str();
        for (auto &publisher : constraintsPublishersPair.second)
          publisher->sendMessage(strConstraints, "constraints");
        break;
      }
      case (ConstraintsStreamFormat::XML): {
        std::stringstream stream;
        constraints::XmlExporter exporter;
        exporter.exportToStream(constraintsCollection, stream);
        std::string strConstraints = stream.str();
        for (auto &publisher : constraintsPublishersPair.second)
          publisher->sendMessage(strConstraints, "constraints");
        break;
      }
    }
  }
}


std::string
OutputDispatcher::curvesToJson(std::shared_ptr<curves::CurvesCollection> curvesCollection) const {
  std::stringstream stream;
  double time = -1;
  stream << "{\n\t\"curves\": {\n";
  stream << "\t\t" << "\"values\": {\n";
  for (auto &curve : curvesCollection->getCurves()) {
    if (curve->getAvailable()) {
      if (time < 0) {
        time = curve->getLastTime();
        stream << "\n";
      } else {
        stream << ",\n";
      }
      std::string curveName = curve->getUniqueName();
      stream << "\t\t\t" << "\"" << curveName << "\": " << curve->getLastValue();
    }
  }
  stream << "\n\t\t" << "},\n";
  stream << "\t\t" << "\"time\": " << time << "\n";
  stream << "\t}\n}";

  return stream.str();
}


std::string
OutputDispatcher::curvesToCsv(std::shared_ptr<curves::CurvesCollection> curvesCollection) const {
  std::stringstream stream;
  double time = -1;
  for (auto &curve : curvesCollection->getCurves()) {
    if (curve->getAvailable()) {
      if (time < 0) {
        time = curve->getLastTime();
        stream << "time," << time << "\n";
      }
      std::string curveName = curve->getUniqueName();
      stream << curveName << "," << curve->getLastValue() << "\n";
    }
  }
  return stream.str();
}

std::string
OutputDispatcher::curvesNamesToString(std::shared_ptr<curves::CurvesCollection> curvesCollection) const {
  std::stringstream stream;
  stream << "time" << "\n";
  for (auto &curve : curvesCollection->getCurves()) {
    if (curve->getAvailable()) {
      std::string curveName = curve->getUniqueName();
      stream << curveName << "\n";
    }
  }
  return stream.str();
}

void
OutputDispatcher::updateCurvesValues(std::shared_ptr<curves::CurvesCollection> curvesCollection) {
  curvesValues_.clear();
  double time = -1;
  for (auto &curve : curvesCollection->getCurves()) {
    if (curve->getAvailable()) {
      if (time < 0) {
        time = curve->getLastTime();
        std::uint8_t* rawBytes = reinterpret_cast<std::uint8_t*>(&time);
        curvesValues_.insert(curvesValues_.end(), rawBytes, rawBytes + sizeof(double));
      }
      double value = curve->getLastValue();
      std::uint8_t* rawBytes = reinterpret_cast<std::uint8_t*>(&value);
      curvesValues_.insert(curvesValues_.end(), rawBytes, rawBytes + sizeof(double));
    }
  }
}

}  // end of namespace DYN
