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
 * @brief Macro to add a timeline event
 * @param pNetwork Pointer to the network being monitored
 * @param model Model that uses this service
 * @param key Key to find the message (key must be provided with the right namespace DYN::KeyTimeline_t::)
 *
 * The macro registers a timeline event, after testing if timeline has been requested from jobs file.
 */
#define DYNAddEvent(pNetwork, model, key, ...) do { \
          if ((pNetwork)->hasTimeline()) { \
            DYN::MessageTimeline m((DYN::MessageTimeline(DYN::KeyTimeline_t::names(key)), ##__VA_ARGS__)); \
            timeline::Timeline& tl(*(pNetwork)->getTimeline()); \
            tl.addEvent((pNetwork)->getCurrentTime(), model, m.str(), m.priority()); \
          } \
        } while (false)

/**
 * @brief Macro to define a constraint message
 * @param key key to find the message
 */
#define DYNConstraint(key, ...) (DYN::Message(DYN::Message::CONSTRAINT_KEY, DYN::KeyConstraint_t::names(DYN::KeyConstraint_t::key)), ##__VA_ARGS__ )

/**
 * @brief Macro to add a constraint message
 * @param pNetwork Pointer to the network being monitored
 * @param id Name or Id of the model using the service
 * @param begin true when the constraint starts, false when it ends
 * @param modelType Model type
 * @param key Key to log the message (key must be provided with the right namespace DYN::KeyConstraint_t::)
 *
 * The macro registers a constraint event, after testing if recording constraint events has been requested from jobs file.
 */
#define DYNAddConstraint(pNetwork, id, begin, modelType, key, ...) do { \
          if ((pNetwork)->hasConstraints()) { \
            DYN::Message m((DYN::Message(DYN::Message::CONSTRAINT_KEY, DYN::KeyConstraint_t::names(key)), ##__VA_ARGS__)); \
            constraints::ConstraintsCollection& cc(*(pNetwork)->getConstraints()); \
            constraints::Type_t constraintType = begin ? constraints::CONSTRAINT_BEGIN : constraints::CONSTRAINT_END; \
            cc.addConstraint(id, m.str(), (pNetwork)->getCurrentTime(), constraintType, modelType); \
          } \
        } while (false)

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
