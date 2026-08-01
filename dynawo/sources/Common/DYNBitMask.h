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

#ifndef COMMON_DYNBITMASK_H_
#define COMMON_DYNBITMASK_H_

namespace DYN {

/**
 * @class BitMask
 * @brief a generic bitmask class
 *
 */
class BitMask {
 public:
  /**
   * @brief constructor
   * initially all flags are false
   */
  BitMask();

  /**
   * @brief activate all flags that are activated in flag
   * @param flag mask to apply
   */
  void setFlags(const unsigned char& flag);

  /**
   * @brief deactivate all flags that are activated in flag
   * @param flag mask to apply
   */
  void unsetFlags(const unsigned char& flag);

  /**
   * @brief deactivate all flags
   */
  void reset();

  /**
   * @brief return true if all flags are deactivated
   * @return @b true if all flags are deactivated
   */
  bool noFlagSet() const;

  /**
   * @brief return true if all flags activated in flag are activated
   * @param flag mask to apply
   *
   * @return @b true if all flags activated in flag are activated
   */
  bool getFlags(const unsigned char& flag) const;

 private:
  unsigned char bitmask_;  ///< current mask
};

} /* namespace DYN */

#endif  // COMMON_DYNBITMASK_H_
