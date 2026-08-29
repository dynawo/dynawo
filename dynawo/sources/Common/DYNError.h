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
 * @file  DYNError.h
 *
 * @brief Error header
 *
 */

#ifndef COMMON_DYNERROR_H_
#define COMMON_DYNERROR_H_

#include <stdio.h>
#include <string>

#include "DYNMessage.h"

namespace DYN {

/**
 * @class Error
 * @brief Generic error handler for Dynawo
 */
class Error : public std::exception {
 public:
  /**
   * @brief define the type of the error
   * Don't use the 0 value, which means success for shell script
   */
  typedef enum {
    UNDEFINED = -1, /**< undefined error */
    SUNDIALS_ERROR = 1, /**< error localised in sundials solver when reading/creating data */
    SOLVER_ALGO = 2, /**< error localised in solver during solve algorithm */
    MODELER = 3, /**< error localised in modeler */
    GENERAL = 4, /**< general error */
    SIMULATION = 5, /**< error localised in simulation */
    NUMERICAL_ERROR = 6, /**< numerical error (localised in models) */
    STATIC_DATA = 7, /**< error localised in DynawoIidm library */
    API = 8 /**< error localised in Dynawo API */
  } TypeError_t;

 public:
  /**
   * @brief Copy constructor. Creates a new Error with same attributes as the object given
   *
   * @param e error to copy
   */
  Error(const Error& e);

  /// @brief Destructor
  ~Error() override = default;

  /**
   * @brief Constructor
   *
   * creates an error with localisation, type and the message to return
   *
   * @param type  type of the error
   * @param key   key of the error
   * @param file  file where the error occurs
   * @param line  line where the error occurs
   * @param m     message of the error
   */
  Error(TypeError_t type, int key, const std::string& file, int line, const Message& m);

  /**
   * @brief Assignement operator.
   *
   * @param e error to copy
   *
   * @return an error with same value as e
   */
  Error & operator=(const Error & e);

  /**
   * @brief Returns a pointer to the error description
   *
   * @return error's description
   */
  const char* what() const noexcept override;

  /**
   * @brief returns the error's type
   *
   * @return error's type
   */
  TypeError_t type() const;

  /**
   * @brief return the key of the error
   *
   * @return error's key
   */
  int key() const;

  /**
   * @brief Operator << overload for error
   *
   * @param os stream instance where the error is added
   * @param e Object to add to the stream
   *
   * @return reference to the stream instance
   *
   */
  friend std::ostream & operator<<(std::ostream& os, const Error& e) {
    os << e.msgToReturn_;
    return os;
  }

 private:
  /**
   * @brief default constructor
   */
  Error(): key_(-1), type_(UNDEFINED) { }

 private:
  int key_;  ///< key of the error
  TypeError_t type_;  ///< type of the error
  std::string msgToReturn_;  ///< string message to return when the error is flushed
};

/**
 * @class MessageError
 * @brief Generic error handler for Dynawo (simple message). Used when dictionaries are not initialized
 */
class MessageError : public std::exception {
 public:
  /**
   * @brief Copy constructor. Creates a new Error with same attributes as the object given
   *
   * @param e error to copy
   */
  MessageError(const MessageError& e);

  /// @brief Destructor
  ~MessageError() override = default;

  /**
   * @brief Constructor
   *
   * creates an error with a message
   *
   * @param message   message of the error
   */
  explicit MessageError(const std::string& message);

  /**
   * @brief Assignement operator.
   *
   * @param e error to copy
   *
   * @return an error with same value as e
   */
  MessageError& operator=(const MessageError& e);

  /**
   * @brief Returns a pointer to the error description
   *
   * @return error's description
   */
  const char* what() const noexcept override;

  /**
   * @brief returns the error's message
   *
   * @return error's message
   */
  std::string message() const;

  /**
   * @brief Operator << overload for error
   *
   * @param os stream instance where the error is added
   * @param e Object to add to the stream
   *
   * @return reference to the stream instance
   *
   */
  friend std::ostream & operator<<(std::ostream& os, const MessageError& e) {
    os << e.msgToReturn_;
    return os;
  }

 private:
  /**
   * @brief default constructor
   */
  MessageError() { }

 private:
  std::string msgToReturn_;  ///< string message to return when the error is flushed
};
}  // namespace DYN

#endif  // COMMON_DYNERROR_H_
