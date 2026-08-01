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
 * @file TestUtil.h
 * @brief Utility for unit tests
 *
 */

#ifndef COMMON_TESTUTIL_H_
#define COMMON_TESTUTIL_H_


#include <boost/iostreams/device/mapped_file.hpp>

/**
 * @brief operator to compare 2 files
 *
 * @param[in] file1 first file to compare
 * @param[in] file2 second file to compare
 * @return @b true if file1 == file2 @b false else
 */
inline bool compareFiles(const std::string& file1, const std::string& file2) {
  const boost::iostreams::mapped_file_source f1(file1);
  const boost::iostreams::mapped_file_source f2(file2);

  if (f1.size() == f2.size()
          && std::equal(f1.data(), f1.data() + f1.size(), f2.data())
          )
    return true;

  return false;
}

#endif  // COMMON_TESTUTIL_H_
