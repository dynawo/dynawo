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
 * @file  DYNTerminate.h
 *
 * @brief Terminate header
 *
 * Terminate use the message class to access the cause of model
 * interruption
 *
 */

#ifndef COMMON_DYNTERMINATE_H_
#define COMMON_DYNTERMINATE_H_

#include <stdio.h>
#include <string>

namespace DYN {
class Message;

/**
 * class Terminate
 */
class Terminate : public std::exception {
 public:
  /**
   * @brief Copy constructor. Creates a new Terminate with same attributes as the object given
   * @param t terminate to copy
   */
  Terminate(const Terminate& t);

  /**
   * @brief Constructor
   *
   * creates a Terminate with localisation and the message to return
   * @param m     message of the terminate
   */
  explicit Terminate(const Message& m);

  /**
   * @brief Copy constructor. Creates a new Terminate with same attributes as the given object
   *
   *
   * @param t terminate to copy
   * @return the new instance of Terminate
   */
  Terminate& operator=(const Terminate& t);

  /**
   * @brief Returns a pointer to the terminate description
   *
   * @return terminate description
   */
  const char* what() const noexcept override;

  /**
   * @brief Operator << overload for error
   *
   *
   * @param os stream instance where the error is added
   * @param t Object to add to the stream
   *
   * @return reference to the stream instance
   *
   */
  friend std::ostream & operator<<(std::ostream& os, const Terminate& t) {
    os << t.msgToReturn_;
    return os;
  }

 private:
  /**
   * @brief default constructor
   */
  Terminate();

 private:
  std::string msgToReturn_;  ///< string message to return when terminate is called
};
}  // namespace DYN


#endif  // COMMON_DYNTERMINATE_H_
