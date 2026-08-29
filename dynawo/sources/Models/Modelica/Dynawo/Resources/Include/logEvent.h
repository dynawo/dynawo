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

#include "ModelicaUtilities.h"

extern void addLogEvent1(int key){};
extern void addLogEvent2(int key, const char * arg1){};
extern void addLogEvent3(int key, const char * arg1, const char * arg2){};
extern void addLogEvent4(int key, const char * arg1, const char * arg2, const char * arg3){};
extern void addLogEvent5(int key, const char * arg1, const char * arg2, const char * arg3, const char * arg4){};

extern void addLogEventRaw1(const char * key1){ModelicaMessage(key1);};
extern void addLogEventRaw2(const char * key1,const char * key2){ModelicaMessage(key1);ModelicaMessage(key2);};
extern void addLogEventRaw3(const char * key1,const char * key2,const char * key3){ModelicaMessage(key1);ModelicaMessage(key2);ModelicaMessage(key3);};
extern void addLogEventRaw4(const char * key1,const char * key2,const char * key3,const char * key4){ModelicaMessage(key1);ModelicaMessage(key2);ModelicaMessage(key3);ModelicaMessage(key4);};
extern void addLogEventRaw5(const char * key1,const char * key2,const char * key3,const char * key4,const char * key5){ModelicaMessage(key1);ModelicaMessage(key2);ModelicaMessage(key3);ModelicaMessage(key4);ModelicaMessage(key5);};
