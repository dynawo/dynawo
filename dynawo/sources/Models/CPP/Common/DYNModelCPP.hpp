/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

/**
 * @file  DYNModelCPP.hpp
 *
 * @brief Implementation of template methods
 *
 */

#ifndef MODELS_CPP_COMMON_DYNMODELCPP_HPP_
#define MODELS_CPP_COMMON_DYNMODELCPP_HPP_

namespace DYN {

/**
 * @brief dump in a stream the value of a boolean
 * @param os stringstream with binary formated internalVariables
 * @param value value to write
 */
template <>
inline void
ModelCPP::dumpInStream(boost::archive::binary_oarchive& os, bool value) {
  os << 'B';
  os <<  value;
}

/**
 * @brief dump in a stream the value of a double
 * @param os stringstream with binary formated internalVariables
 * @param value value to write
 */
template <>
inline void
ModelCPP::dumpInStream(boost::archive::binary_oarchive& os, double value) {
  os << 'D';
  os << value;
}

/**
 * @brief dump in a stream the value of an integer
 * @param os stringstream with binary formated internalVariables
 * @param value value to write
 */
template <>
inline void
ModelCPP::dumpInStream(boost::archive::binary_oarchive& os, int value) {
  os << 'I';
  os << value;
}

}  // namespace DYN

#endif  // MODELS_CPP_COMMON_DYNMODELCPP_HPP_
