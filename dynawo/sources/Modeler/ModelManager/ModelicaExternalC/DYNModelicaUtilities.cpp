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
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>

#include "DYNModelicaUtilities.h"
#include "DYNTrace.h"

void ModelicaVFormatMessage(const char *string, va_list args) {
  char buff[100];
  snprintf(buff, sizeof(buff), string, args);
  std::string buffAsStdStr = buff;
  DYN::Trace::info() << buffAsStdStr << DYN::Trace::endline;
}

void ModelicaFormatMessage(const char *string, ...) {
  va_list args;
  va_start(args, string);
  ModelicaVFormatMessage(string, args);
  va_end(args);
}

void ModelicaError(const char *string) {
  DYN::Trace::error() << std::string(string) << DYN::Trace::endline;
}

void ModelicaVFormatError(const char *string, va_list args) {
  char buff[100];
  snprintf(buff, sizeof(buff), string, args);
  std::string buffAsStdStr = buff;
  DYN::Trace::error() << buffAsStdStr << DYN::Trace::endline;
}

void ModelicaFormatError(const char *string, ...) {
  DYN::Trace::error() << string << DYN::Trace::endline;
}

char* ModelicaAllocateStringWithErrorReturn(size_t len) {
  char *res = reinterpret_cast<char *>(malloc((len+1)*sizeof(char)));
  if (res != NULL) {
    res[len] = '\0';
  }
  return res;
}

char* ModelicaAllocateString(size_t len) {
  char *res = ModelicaAllocateStringWithErrorReturn(len);
  if (!res) {
    ModelicaFormatError("%s:%d: ModelicaAllocateString failed", __FILE__, __LINE__);
  }
  return res;
}
