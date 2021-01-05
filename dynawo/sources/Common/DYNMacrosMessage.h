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

#ifndef COMMON_DYNMACROSMESSAGE_H_
#define COMMON_DYNMACROSMESSAGE_H_

#include "DYNMessage.hpp"
#include "DYNMessageTimeline.h"
#include "DYNError.h"
#include "DYNTerminate.h"

/**
 * @brief Macro description to have a shortcut.
 *  Thanks to this macro, user can only call a log message with the key to access
 *  to the message (+ optionnal arguments if the message need)
 *
 * @param key  key of the message description
 *
 * @return a log message Terminate
 */
#define DYNLog(key, ...) (DYN::Message(DYN::Message::LOG_KEY, DYN::KeyLog_t::names(DYN::KeyLog_t::key)), ##__VA_ARGS__ )

/**
 * @brief Macro to define a timeline message
 * @param key key to find the message (may be called without namespace)
 */
#define DYNTimeline(key, ...) (DYN::MessageTimeline(DYN::KeyTimeline_t::names(DYN::KeyTimeline_t::key)), ##__VA_ARGS__ )

/**
 * @brief Macro to conditionally add a timeline event
 * @param pTimeline Pointer to the timeline that registers events or NULL
 * @param model Model that uses this service
 * @param key Key to find the message (must be provided with the right namespace DYN::KeyTimeline_t::)
 *
 * That macro intends to replace SubModel::addEvent().
 * It adds simply a test to insure the jobs file requests registering events into a timeline file
 */
#define DYNAddEvent(pTimeline, model, key, ...) do { \
          if ((pTimeline)->hasTimeline()) { \
            (pTimeline)->addEvent((model), (DYN::MessageTimeline(DYN::KeyTimeline_t::names(key)), ##__VA_ARGS__)); \
          } \
        } while (false)

/**
 * @brief Macro to define a constraint message
 * @param key key to find the message
 */
#define DYNConstraint(key, ...) (DYN::Message(DYN::Message::CONSTRAINT_KEY, DYN::KeyConstraint_t::names(DYN::KeyConstraint_t::key)), ##__VA_ARGS__ )

/**
 * @brief Macro description to have a shortcut.
 *  Thanks to this macro, user can only call an error with the type and the key to access
 *  to the message (+ optionnal arguments if the message need)
 *  File error localisation and line error localisation are added
 *
 * @param type type of the error, refer to enum
 * @param key  key of the message description
 *
 * @return an Error
 */
#define DYNError(type, key, ...) DYN::Error(DYN::Error::TypeError_t(type), DYN::KeyError_t::key, std::string(__FILE__), __LINE__, \
                                            (DYN::Message(DYN::Message::ERROR_KEY, DYN::KeyError_t::names(DYN::KeyError_t::key)), ##__VA_ARGS__))

/**
 * @brief Macro description to have a shortcut.
 *  Thanks to this macro, user can only call a terminate with the key to access
 *  to the message (+ optionnal arguments if the message need)
 *
 * @param key  key of the message description
 *
 * @return a Terminate
 */
#define DYNTerminate(key, ...) DYN::Terminate((DYN::MessageTimeline(DYN::KeyTimeline_t::names(DYN::KeyTimeline_t::key)), ##__VA_ARGS__))

#endif  // COMMON_DYNMACROSMESSAGE_H_
