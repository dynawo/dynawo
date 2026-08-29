//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//
#ifndef DICO_KEYS_H
#define DICO_KEYS_H
namespace MyNS {

  ///< struct of Keyo to declare enum values and names associated to the enum to be used in dynawo
  struct Keyo_t
  {
    ///< enum of possible key for o
    enum value
    {
      MyEntry,                                                                ///< My First Entry
      MyFourthEntry,                                                          ///< My Fourth Entry
      MySecondEntry,                                                          ///< My Second Entry %u
      MyThirdEntry                                                            ///< My Third Entry
    };

    /**
    * @brief Return the name associated to the enum.
    *
    * @return The name associated to the enum.
    */
    static const char* names(const value&); ///< names associated to the enum
  };
} //namespace MyNS
#endif
