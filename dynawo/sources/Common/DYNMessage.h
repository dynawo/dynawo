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
 * @file DYNMessage.h
 *
 * @brief Message header
 *
 *  Message are used to access to dictionnary log where log are described
 *  with the boost::format convention
 */

#ifndef COMMON_DYNMESSAGE_H_
#define COMMON_DYNMESSAGE_H_
#include <sstream>
#include <boost/format.hpp>

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wshadow"
#endif  // __clang__
#include "DYNError_keys.h"
#include "DYNLog_keys.h"
#include "DYNTimeline_keys.h"
#include "DYNConstraint_keys.h"
#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

namespace DYN {

/**
 * @class Message
 * @brief  Message are used to access to dictionnary log where log are described
 *  with the boost::format convention
 */
class Message {
 public:
  ///< enum of possible key for dictionaries
  enum dictionaryKey {
    TIMELINE_KEY,    ///< Key used to store timeline dictionary
    ERROR_KEY,       ///< Key used to store error dictionary
    CONSTRAINT_KEY,  ///< Key used to store constraint dictionary
    LOG_KEY          ///< Key used to store log dictionary
  };

  /**
   * @brief Constructor
   *
   *
   * @param dicoKey key of the dictionary where the message is described
   * @param key key to access to the message description
   */
  Message(const dictionaryKey& dicoKey, const std::string& key);

  /**
   * @brief Constructor
   *
   *
   * @param dicoName name of the dictionary where the message is described
   * @param key key to access to the message description
   */
  Message(const std::string& dicoName, const std::string& key);

  /**
   * @brief Copy constructor
   *
   * creates a message with same attributes as message object given
   *
   * @param m Message to copy
   */
  Message(const Message& m);

  /**
   * @brief destructor
   */
  ~Message() { }

  /**
   * @brief Operator , overload for message
   *
   * @param x  parameter to add to the boost::format message
   *
   * @return Reference to the message instance
   */
  template <typename T> Message& operator,(T& x);

  /**
   * @brief Operator , overload for message
   *
   * @param x parameter to add to the boost::format message
   *
   * @return Reference to the message instance
   */
  template <typename T> Message& operator,(const T& x);

  /**
   * @brief Operator << overlaod for Message
   *
   * @param os stream instance where the message is added
   * @param m Object to add to the stream
   *
   * @return reference to the stream instance
   *
   * @note If the message is not described in the dictionnary, the message
   * return is only the key (thanks to that we can print message without access to
   * a dictionnary)
   */
  friend std::ostream& operator<<(std::ostream& os, const Message& m) {
    if (m.hasFmt_)
      os << m.fmt_;
    else
      os << m.fmtss_.str();
    return os;
  }

  /**
   * @brief return the message in string format
   *
   * if there is no boost::format description, return the key as a message
   *
   * Be carefull when to call this method, it must be after the creation of the object (obvious)
   * and after the comma overloading operator has been applied
   *
   * @return the message to return
   */
  std::string str() const;

  /**
     * @brief return the message's key
     * @return the message's key
     */
  const std::string& getKey() const {return key_;}

 private:
  Message();

  /**
   * @brief initialize attributes of the message
   * Creates a message . Try to access the dictionnary named @b dicoName
   * and find the message description thanks to @b key.
   * If there is no dictionnary or message description, we  use key as a message
   *
   *
   * @param dicoName name of the dictionnary where the message is described
   * @param key  key to access to the message description
   */
  void initialize(const std::string& dicoName, const std::string& key);

 protected:
  boost::format fmt_;  ///< log message with the boost format convention
  std::stringstream fmtss_;  ///< log message when boost format message does not exist
  bool hasFmt_;  ///< @b true is there is a log message in the dictionnary, @b false otherwise
  std::string key_;  ///< Key to access to the log message in the dictionnary
};
}  // namespace DYN

#endif  // COMMON_DYNMESSAGE_H_
