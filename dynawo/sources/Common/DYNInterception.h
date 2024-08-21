//
// Copyright (c) 2015-2024, RTE (http://www.rte-france.com)
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
 * @file  DYNInterception.h
 *
 * @brief Interception header
 *
 * Interception use the message class to access to the cause of model
 * interruption
 *
 */

#ifndef COMMON_DYNINTERCEPTION_H_
#define COMMON_DYNINTERCEPTION_H_

#include <stdio.h>
#include <string>

namespace DYN {
class Message;

/**
 * class Interception
 */
class Interception : public std::exception {
 public:
  /**
   * @brief Copy constructor. Creates a new Interception with same attributes as the object given
   * @param i Interception to copy
   */
  Interception(const Interception& i);

  /**
   * @brief Constructor
   *
   * creates a Interception with localisation and the message to return
   * @param m     message of the Interception
   */
  explicit Interception(const Message& m);

  /**
   * @brief Copy constructor. Creates a new Interception with same attributes as the given object
   *
   *
   * @param i Interception to copy
   * @return the new instance of Interception
   */
  Interception& operator=(const Interception& i);

  /**
   * @brief Returns a pointer to the Interception description
   *
   * @return Interception description
   */
  virtual const char* what() const noexcept;

  /**
   * @brief default destructor
   *
   */
  virtual ~Interception() = default;

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
  friend std::ostream & operator<<(std::ostream& os, const Interception& i) {
    os << i.msgToReturn_;
    return os;
  }

 private:
  /**
   * @brief default constructor
   */
  Interception();

 private:
  std::string msgToReturn_;  ///< string message to return when Interception is called
};
}  // namespace DYN


#endif  // COMMON_DYNINTERCEPTION_H_
