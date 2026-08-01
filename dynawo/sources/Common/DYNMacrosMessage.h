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

#ifndef COMMON_DYNMACROSMESSAGE_H_
#define COMMON_DYNMACROSMESSAGE_H_

#include "DYNMessage.hpp"
#include "DYNMessageTimeline.h"
#include "DYNError.h"
#include "DYNTerminate.h"

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu-zero-variadic-macro-arguments"
#pragma clang diagnostic ignored "-Wc++98-compat-pedantic"
#endif

/**
 * @brief Macro description to have a shortcut.
 *  Thanks to this macro, user can only call a log message with the key to access
 *  to the message (+ optional arguments if the message need)
 *
 * @param key  key of the message description
 *
 * @return a log message Terminate
 */
#define DYNLog(key, ...) (DYN::Message(DYN::Message::LOG_KEY, DYN::KeyLog_t::names(DYN::KeyLog_t::key)), ##__VA_ARGS__ )

/**
 * @brief Macro to define a timeline message
 * @param key key to find the message
 */
#define DYNTimeline(key, ...) (DYN::MessageTimeline(DYN::KeyTimeline_t::names(DYN::KeyTimeline_t::key)), ##__VA_ARGS__ )

/**
 * @brief Macro to add a timeline event, only if timeline exists, implemented as a ternary operator to avoid if/else syntax traps
 * @param model the model to add the event to
 * @param name the name of the model
 * @param key key to find the message
 */
#define DYNAddTimelineEvent(model, name, key, ...) (model->hasTimeline() ? model->addEvent(name, DYNTimeline(key, ##__VA_ARGS__)) : (void)0)

/**
 * @brief Macro description to have a shortcut.
 *  Thanks to this macro, user can only call an error with the type and the key to access
 *  to the message (+ optional arguments if the message need)
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
 *  to the message (+ optional arguments if the message need)
 *
 * @param key  key of the message description
 *
 * @return a Terminate
 */
#define DYNTerminate(key, ...) DYN::Terminate((DYN::MessageTimeline(DYN::KeyTimeline_t::names(DYN::KeyTimeline_t::key)), ##__VA_ARGS__))

#ifdef __clang__
#pragma clang diagnostic pop
#endif

#endif  // COMMON_DYNMACROSMESSAGE_H_
