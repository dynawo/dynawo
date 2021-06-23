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
 * @file JOBAppenderEntryImpl.h
 * @brief Appender entries description : header file
 *
 */

#ifndef API_JOB_JOBAPPENDERENTRYIMPL_H_
#define API_JOB_JOBAPPENDERENTRYIMPL_H_

#include <string>
#include "JOBAppenderEntry.h"
namespace job {

/**
 * @class AppenderEntry::Impl
 * @brief AppenderEntry implemented class
 *
 * Implementation of AppenderEntry interface.
 */
class AppenderEntry::Impl : public AppenderEntry {
 public:
  /**
   * @brief AppenderEntry constructor
   */
  Impl();

  /**
   * @brief AppenderEntry destructor
   */
  virtual ~Impl();

  /**
   * @copydoc AppenderEntry::getTag() const
   */
  std::string getTag() const;

  /**
   * @copydoc AppenderEntry::getFilePath() const;
   */
  std::string getFilePath() const;

  /**
   * @copydoc AppenderEntry::getLvlFilter() const
   */
  std::string getLvlFilter() const;

  /**
   * @copydoc AppenderEntry::getShowLevelTag() const
   */
  bool getShowLevelTag() const;

  /**
   * @copydoc AppenderEntry::getSeparator() const
   */
  std::string getSeparator() const;

  /**
   * @copydoc AppenderEntry::getTimeStampFormat() const
   */
  std::string getTimeStampFormat() const;

  /**
   * @copydoc AppenderEntry::setTag()
   */
  void setTag(const std::string& tag);

  /**
   * @copydoc AppenderEntry::setFilePath()
   */
  void setFilePath(const std::string& filePath);

  /**
   * @copydoc AppenderEntry::setLvlFilter()
   */
  void setLvlFilter(const std::string& lvlFilter);

  /**
   * @copydoc AppenderEntry::setShowLevelTag()
   */
  void setShowLevelTag(const bool showTag);

  /**
   * @copydoc AppenderEntry::setSeparator()
   */
  void setSeparator(const std::string& separator);

  /**
   * @copydoc AppenderEntry::setTimeStampFormat()
   */
  void setTimeStampFormat(const std::string& format);

  /**
   * @copydoc AppenderEntry::clone()
   */
  boost::shared_ptr<AppenderEntry> clone() const;

 private:
  std::string tag_;  ///< Tag filtered by the appender
  std::string filePath_;  ///< Output file path of the appender
  std::string lvlFilter_;  ///< Minimum severity level exported by the appender
  bool showLevelTag_;  ///< @b true if the tag of the log should be printed
  std::string separator_;  ///< separator used between each log information
  std::string timeStampFormat_;  ///< format of the timestamp information , "" if no time to print
};

}  // namespace job

#endif  // API_JOB_JOBAPPENDERENTRYIMPL_H_
