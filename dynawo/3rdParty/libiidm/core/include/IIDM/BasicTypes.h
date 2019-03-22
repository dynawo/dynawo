//
// Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Libiidm, a library to model IIDM networks and allows
// importing and exporting them to files.
//

/**
 * @file BasicTypes.h
 * @brief general typedefs in libiidm
 */

#ifndef LIBIIDM_GUARD_BASICTYPES_H
#define LIBIIDM_GUARD_BASICTYPES_H

#include <string>
#include <IIDM/Export.h>

/**
 * @brief the global namespace of libIIDM
 */
namespace IIDM {

/**
 * @brief the type used as identifier by identifiable things, such as loads or lines.
 */
typedef std::string id_type;


/**
 * @brief the type used to identify nodes inside voltage levels.
 */
typedef int node_type;

/*
  successive values starting from 0 has several advantages:
  iteration is possible
  values can serve as array or vector index
*/
/**
 * @brief enumeration used either to designate a side of a component, or to tell what sides are available
 */
enum side_id {
  side_1,//!< is the (or has a) side one
  side_2,//!< is the (or has a) side two
  side_3,//!< is the (or has a) side three

  side_end,//!< this value represents "not a side"
  side_begin=0//!< the first available side, i.e. side_1
};


/** @defgroup connection_status connection status
 * @brief pseudo keywords for connection status.
 *
 * @{
 */
//modeled after boost::none

// underlying types for connected and disconnected
struct connection_status_t{
  bool connected;
};

/** @brief tells if two connection statuses are equal */
inline bool operator==(connection_status_t const& a, connection_status_t const& b) { return a.connected == b.connected; }
/** @brief tells if two connection statuses are different */
inline bool operator!=(connection_status_t const& a, connection_status_t const& b) { return a.connected != b.connected; }

namespace details {
template <typename T>
struct connection_status_instance {
  static const T connected, disconnected;
};

//globals, but because of templates, no cpp file required
template <typename T> const T connection_status_instance<T>::connected = {true};
template <typename T> const T connection_status_instance<T>::disconnected  = {false};
} // end of namespace IIDM::details::

namespace {
/**
 * @brief the connection status value for connected components
 */
const connection_status_t& connected = details::connection_status_instance<connection_status_t>::connected;

/**
 * @brief the connection status value for disconnected components
 */
const connection_status_t& disconnected = details::connection_status_instance<connection_status_t>::disconnected;
} // end of namespace IIDM::<anonymous>::

/** @} */ //end of @defgroup connection_status

} // end of namespace IIDM::

#endif
