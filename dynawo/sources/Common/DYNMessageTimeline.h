//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file DYNMessageTimeline.h
 *
 * @brief DYNMessageTimeline header
 *
 *  Message are used to access to dictionnary log where log are described
 *  with the boost::format convention
 */

#ifndef COMMON_DYNMESSAGETIMELINE_H_
#define COMMON_DYNMESSAGETIMELINE_H_

#include <utility>
#include <stdio.h>
#include <iostream>

#include "DYNMessage.hpp"

namespace DYN {

/**
 * @class MessageTimeline
 * @brief  MessageTimeline are used to access to dictionnary log where log are described
 *  with the boost::format convention
 */
class MessageTimeline : public Message {
 public:
  /**
   * @brief Constructor
   *
   * @param key key to access to the message description
   */
  explicit MessageTimeline(const std::string& key);

  /**
   * @brief Constructor
   *
   * @param dicoName name of the dictionnary where the message is described
   * @param key key to access to the message description
   */
  explicit MessageTimeline(const std::string& dicoName, const std::string& key);

  /**
   * @brief Copy constructor
   *
   * creates a message with same attributes as message object given
   *
   * @param m Message to copy
   */
  MessageTimeline(const MessageTimeline& m);

  /**
   * @brief destructor
   */
  ~MessageTimeline() override;

  /**
   * @brief Operator , overload for message
   *
   * @param x  parameter to add to the boost::format message
   *
   * @return Reference to the message instance
   */
  template <typename T> MessageTimeline& operator,(T& x);

  /**
   * @brief Operator , overload for message
   *
   * @param x parameter to add to the boost::format message
   *
   * @return Reference to the message instance
   */
  template <typename T> MessageTimeline& operator,(const T& x);

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
  friend std::ostream& operator<<(std::ostream& os, const MessageTimeline& m) {
    os << static_cast<const Message&>(m);
    return os;
  }

  /**
   * @brief Priority of the message
   *
   * @return Priority of the message timeline
   */
  inline const boost::optional<int>& priority() const { return priority_; }

 private:
  MessageTimeline();

  /**
   * @brief initialize attributes of the message
   * Creates a message . Try to access the dictionnary named @b dicoName
   * and find the message description thanks to @b key.
   * If there is no dictionnary or message description, we  use key as a message
   *
   *
   * @param key  key to access to the message description
   */
  void initialize(const std::string& key);

 private:
  boost::optional<int> priority_;  ///< priority of the message in the timeline
};
}  // namespace DYN

#include "DYNMessageTimeline.hpp"

#endif  // COMMON_DYNMESSAGETIMELINE_H_
